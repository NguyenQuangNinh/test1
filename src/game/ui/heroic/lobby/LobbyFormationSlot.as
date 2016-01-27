package game.ui.heroic.lobby 
{
	import core.display.animation.Animator;
	import core.display.BitmapEx;
	import core.event.EventEx;
	import core.Manager;
	import core.util.Enum;
	import core.util.FontUtil;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.utils.getTimer;
	import game.data.gamemode.ModeDataPVEHeroic;
	import game.data.model.Character;
	import game.data.vo.lobby.LobbyPlayerInfo;
	import game.enum.DragDropEvent;
	import game.enum.FlowActionEnum;
	import game.enum.Font;
	import game.enum.GameMode;
	import game.enum.SkillType;
	import game.Game;
	import game.main.SkillSlot;
	import game.ui.components.LevelIcon;
	import game.ui.heroic.HeroicEvent;
	import game.utility.UtilityUI;
	
	
	
	/**
	 * ...
	 * @author MaiPTT
	 */
	public class LobbyFormationSlot extends MovieClip 
	{
		static public const LOBBY_FORMATION_DRAG	:String = "lobbyFormationDrag";
		static public const INSERT_CHARACTER		:String = "insertCharacter";
		
		public var txtMainCharName	:TextField;
		public var txtName			:TextField;
		public var animContainer	:MovieClip;
		public var movEffect		:MovieClip;
		public var movHost			:MovieClip;
		public var btnKick			:SimpleButton;
		public var boundingBox		:Rectangle;
		
		private var animator		:Animator;
		private var data			:LobbyPlayerInfo;
		private var characterData	:Character;
		private var levelIcon		:LevelIcon;
		private var formationIndex	:int;
		private var characterIndex	:int;
		private var isHost			:Boolean;
		private var isMouseDown		:Boolean;
		private var lastMouseClick	:int;
		private var skills			:Array;
		private var enableInsertChar:Boolean;
		
		public function LobbyFormationSlot() {
			skills = [];
			initUI();
			initHandlers();
		}
		
		public function getData():LobbyPlayerInfo { return data; }
		public function setData(value:LobbyPlayerInfo, characterIndex:int, formationIndex:int, point:Point):void {
			data = value;
			this.formationIndex = formationIndex;
			this.characterIndex = characterIndex;
			txtMainCharName.text = "";
			txtName.text = "";
			btnKick.visible = false;
			levelIcon.visible = false;
			movHost.visible = false;
			setIsHost(ModeDataPVEHeroic(Game.database.userdata.getModeData(GameMode.PVE_HEROIC)).isHost);
			boundingBox.x = this.x + point.x;
			boundingBox.y = this.y + point.y;
			
			for each (var skillSlot:SkillSlot in skills) {
				Manager.pool.push(skillSlot, SkillSlot);
				removeChild(skillSlot);
			}
			skills.splice(0);
			
			if (data) {
				if (animator == null) {
					animator = Manager.pool.pop(Animator) as Animator;
					animator.reset();
					animator.stop();
				}
				if (!animator.hasEventListener(Animator.LOADED)) {
					animator.addEventListener(Animator.LOADED, onAnimLoadedHdl);
				}
				
				txtMainCharName.text = data.name;
				
				if (ModeDataPVEHeroic(Game.database.userdata.getModeData(GameMode.PVE_HEROIC)).isHost
					&& (data.id != Game.database.userdata.userID)) {
					btnKick.visible = true;
				}
				
				if (data.characters) {
					if ((data.characters[characterIndex] != null)	
					&& (data.charactersSex[characterIndex] != null)) {
						characterData = data.characters[characterIndex];
						if (data.owner && characterData.isMainCharacter) {
							movHost.visible = true;
						}
						levelIcon.visible = true;
						levelIcon.level = characterData.level;
						if (characterData.xmlData) {
							animator.load(characterData.xmlData.animURLs[data.charactersSex[characterIndex]]);
							var htmlText:String;
							var glow:GlowFilter = new GlowFilter();
							htmlText = "<font color = '" + UtilityUI.getTxtColor(characterData.rarity, characterData.isMainCharacter, characterData.isLegendary() ) 
									+ "'>" + characterData.name + "</font>";
							glow.strength = 10;
							glow.blurX = glow.blurY = 4;
							glow.color = UtilityUI.getTxtGlowColor(characterData.rarity, characterData.isMainCharacter, characterData.isLegendary());
							txtName.filters = [glow];
							txtName.htmlText = htmlText;
							FontUtil.setFont(txtName, Font.ARIAL);
							
							var skillTypes:Array = Enum.getAll(SkillType);
							var skillType:SkillType;
							for (var i:int = 0; i < skillTypes.length; i++) {
								skillType = skillTypes[i];
								skillSlot = Manager.pool.pop(SkillSlot) as SkillSlot;
								skillSlot.setData(characterData.getEquipSkill(skillType));
								skillSlot.showHotKey(false);
								skills.push(skillSlot);
								skillSlot.x = 10 + i * (SkillSlot.WIDTH + 10);
								skillSlot.y = 10;
								addChild(skillSlot);
							}
							
							if (data.id == Game.database.userdata.userID) {
								movEffect.gotoAndStop(2);
								if (!hasEventListener(MouseEvent.CLICK)) {
									addEventListener(MouseEvent.CLICK, onSlotClickHdl);	
								}
							} else {
								movEffect.gotoAndStop(3);
							}
						}
					} else {
						resetUI();
					}
				}
				 
			} else {
				resetUI();
			}
		}
		
		public function updateBoundingBoxPos(point:Point):void {
			boundingBox.x = this.x + point.x;
			boundingBox.y = this.y + point.y;
		}
		
		public function getFormationIndex():int {
			return formationIndex;
		}
		
		private function setIsHost(value:Boolean):void {
			isHost = value;
			if (isHost) {
				if (!hasEventListener(MouseEvent.MOUSE_DOWN)) {
					addEventListener(MouseEvent.MOUSE_DOWN, onMouseDownHdl);
				}
			} else {
				if (hasEventListener(MouseEvent.MOUSE_DOWN)) {
					removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDownHdl);
				}
			}
		}
		
		private function onMouseDownHdl(e:MouseEvent):void {
			if (data) {
				addEventListener(MouseEvent.MOUSE_UP, onMouseUpHdl);
				addEventListener(MouseEvent.MOUSE_OUT, onMouseOutHdl);
				isMouseDown = true;
			}
		}
		
		private function onMouseUpHdl(e:MouseEvent):void {
			if (hasEventListener(MouseEvent.MOUSE_UP)) {
				removeEventListener(MouseEvent.MOUSE_UP, onMouseUpHdl);
			}
			if (hasEventListener(MouseEvent.MOUSE_OUT)) {
				removeEventListener(MouseEvent.MOUSE_OUT, onMouseOutHdl);
			}
			isMouseDown = false;
		}
		
		private function onMouseOutHdl(e:MouseEvent):void {
			if (hasEventListener(MouseEvent.MOUSE_UP)) {
				removeEventListener(MouseEvent.MOUSE_UP, onMouseUpHdl);
			}
			if (hasEventListener(MouseEvent.MOUSE_OUT)) {
				removeEventListener(MouseEvent.MOUSE_OUT, onMouseOutHdl);
			}
			
			if (isMouseDown) {
				isMouseDown = false;	
				var character:Character = data.characters[characterIndex];
				if (character && (data.charactersSex[characterIndex] != null)) {
					var objDrag:BitmapEx = new BitmapEx();	
					objDrag.load(character.xmlData.largeAvatarURLs[data.charactersSex[characterIndex]]);
					objDrag.name = "mov_drag";
					dispatchEvent(new EventEx(LOBBY_FORMATION_DRAG, { target:objDrag, x:e.stageX, y:e.stageY, data:formationIndex,
								type: DragDropEvent.FROM_HEROIC_FORMATION }, true));
				}
			}
		}
		
		private function initHandlers():void {
			btnKick.addEventListener(MouseEvent.CLICK, onClickHdl);
			animContainer.mouseChildren = false;
			animContainer.doubleClickEnabled = true;
		}
		
		private function resetUI():void {
			if (animator != null) {
				if (animator.hasEventListener(Animator.LOADED)) {
					animator.removeEventListener(Animator.LOADED, onAnimLoadedHdl);
				}
				
				animator.reset();
				if (animator.parent == animContainer) {
					animContainer.removeChild(animator);	
				}
				Manager.pool.push(animator, Animator);
				animator = null;
			}
			if (hasEventListener(MouseEvent.CLICK)) {
				removeEventListener(MouseEvent.CLICK, onSlotClickHdl);
			}
			
			if (data) {
				if (data.id == Game.database.userdata.userID) {
					movEffect.gotoAndStop(4);
					enableInsertChar = true;
					if (!hasEventListener(MouseEvent.CLICK)) {
						addEventListener(MouseEvent.CLICK, onSlotClickHdl);	
					}
				}
			} else {
				enableInsertChar = false;
				movEffect.gotoAndStop(1);
			}
		}
		
		private function onSlotClickHdl(e:MouseEvent):void {
			if (enableInsertChar) {
				dispatchEvent(new Event(INSERT_CHARACTER, true));
				enableInsertChar = false;
			}
		}
		
		private function initUI():void {
			FontUtil.setFont(txtMainCharName, Font.ARIAL);
			FontUtil.setFont(txtName, Font.ARIAL);
			
			this.buttonMode = true;
			movEffect.gotoAndStop(1);
			
			levelIcon = new LevelIcon();
			levelIcon.y = 135;
			levelIcon.x = 10;
			addChild(levelIcon);
			
			movEffect.mouseChildren = false;
			movEffect.mouseEnabled = false;
			
			boundingBox = new Rectangle(0, 0, 90, 120);
		}
		
		private function onAnimLoadedHdl(e:Event):void {
			animContainer.addChild(animator);
			animator.play(0);
		}
		
		private function onClickHdl(e:MouseEvent):void {
			switch(e.target) {
				case btnKick:
					if (data) {
						dispatchEvent(new EventEx(HeroicEvent.EVENT, { type:HeroicEvent.KICK, id:data.id }, true));
					}
					break;
			}
		}
	}

}