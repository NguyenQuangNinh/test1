package game.ui.character_enhancement.character_upgrade 
{
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.utils.Timer;
	
	import core.Manager;
	import core.display.ModuleBase;
	import core.display.animation.Animator;
	import core.event.EventEx;
	import core.util.Enum;
	import core.util.FontUtil;
	import core.util.Utility;
	
	import game.Game;
	import game.data.model.Character;
	import game.data.model.UIData;
	import game.enum.Element;
	import game.enum.ErrorCode;
	import game.enum.Font;
	import game.enum.GameConfigID;
	import game.enum.PlayerAttributeID;
	import game.net.IntRequestPacket;
	import game.net.IntResponsePacket;
	import game.net.lobby.LobbyRequestType;
	import game.net.lobby.LobbyResponseType;
	import game.net.lobby.request.RequestLevelUpEnhancement;
	import game.ui.ModuleID;
	import game.ui.character_enhancement.CharacterLevelDetail;
	import game.ui.character_enhancement.TabContent;
	import game.ui.components.FormationSlot;
	import game.ui.components.LevelBarMov;
	import game.ui.components.characterslot.CharacterSlotAnimation;
	import game.ui.dialog.DialogID;
	import game.ui.home.HomeView;
	import game.ui.inventory.InventoryView;
	import game.ui.message.MessageID;
	import game.ui.tooltip.TooltipEvent;
	import game.ui.tooltip.TooltipID;
	import game.ui.tutorial.TutorialEvent;
	
	/**
	 * ...
	 * @author MaiPTT
	 */
	public class CharacterUpgrade extends TabContent 
	{
		public static const MAX_MATERIAL_ITEMS		:int = 5;
		
		private static const EFFECT_START:int = 0;
		private static const EFFECT_PLAY:int = 1;
		private static const EFFECT_STOP:int = 2;
		
		public var btnUpgrade:SimpleButton;
		public var txtCost			:TextField;
		public var movCurrency		:MovieClip;
		public var dummyCharacter:MovieClip;
		public var characterContainer:MovieClip;
		public var levelDetail:CharacterLevelDetail;
		public var createElement:MovieClip;
		public var resistElement:MovieClip;
		public var blackMask:MovieClip;
		public var materialCharactersContainer:MovieClip;
		public var estimater:Estimater;
		public var movElementInstruction	:SimpleButton;
		
		private var _character		:Character;
		private var materialSlots	:Array;
		private var characterSlot:CharacterSlotAnimation;
		private var expTransfering:Boolean;
		private var totalTransferEXP:int;
		private var cloneCharacter:Character;
		private var mainCharacter:Character;
		private var materialEffects:Array;
		private var mainEffect:Animator;
		private var timer:Timer;
		
		public static var TRANSFER_POWER:String = "transferPower";
		
		public function CharacterUpgrade()
		{
			timer = new Timer(0, 1);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, timer_onComplete);
			
			materialSlots = [];
			materialEffects = [];
			
			characterSlot = new CharacterSlotAnimation();
			characterSlot.mouseChildren = false;
			characterSlot.doubleClickEnabled = true;
			characterSlot.addEventListener(MouseEvent.DOUBLE_CLICK, characterSlot_onDBClicked);
			characterContainer.addChild(characterSlot);
			mainEffect = new Animator();
			mainEffect.load("resource/anim/ui/fx_truyencong_main.banim");
			mainEffect.mouseEnabled = false;
			mainEffect.mouseChildren = false;
			mainEffect.addEventListener(Event.COMPLETE, mainEffect_onComplete);
			characterContainer.addChild(mainEffect);
			levelDetail.levelBar.addEventListener(LevelBarMov.TWEEN_COMPLETE, onLevelBarTweenComplete);
			blackMask.visible = false;
			
			FontUtil.setFont(txtCost, Font.ARIAL, true);
			
			initUI();
			btnUpgrade.addEventListener(MouseEvent.CLICK, btnUpgrade_onClicked);
			btnUpgrade.addEventListener(MouseEvent.ROLL_OVER, onMouseOverHdl);
			btnUpgrade.addEventListener(MouseEvent.ROLL_OUT, onMouseOutHdl);
			addEventListener(FormationSlot.FORMATION_SLOT_DCLICK, onClicked);
			movElementInstruction.addEventListener(MouseEvent.ROLL_OVER, onMouseOverHdl);
			movElementInstruction.addEventListener(MouseEvent.ROLL_OUT, onMouseOutHdl);
		}
		
		protected function mainEffect_onComplete(event:Event):void
		{
			blackMask.visible = false;
			var materialCharacterIDs:Array = Game.uiData.getMaterialCharacterIDs();
			for each(var characterID:int in materialCharacterIDs)
			{
				Game.database.userdata.removeCharacter(characterID);
			}
			Game.uiData.clearMaterialCharacterIDs();
			Game.network.lobby.sendPacket(new IntRequestPacket(LobbyRequestType.GET_CHARACTER_INFO, Game.uiData.getMainCharacterID()));
			var module:ModuleBase = Manager.module.getModuleByID(ModuleID.INVENTORY_UNIT);
			if(module != null)
			{
				InventoryView(module.baseView).updateCharacterList();
			}
			module = Manager.module.getModuleByID(ModuleID.HOME);
			if(module != null)
			{
				HomeView(module.baseView).update();
			}
		}
		
		protected function characterSlot_onDBClicked(event:MouseEvent):void
		{
			Game.uiData.setMainCharacterID(-1);
		}
		
		override protected function onActivate():void
		{
			Game.uiData.addEventListener(UIData.MATERIAL_CHARACTERS_CHANGED, onMaterialCharactersChanged);
			Game.uiData.addEventListener(UIData.MAIN_CHARACTER_CHANGED, onMainCharacterChanged);
			Game.network.lobby.registerPacketHandler(LobbyResponseType.LEVEL_UP_ENHANCEMENT, expTransferResult);
			update();
			super.onActivate();
		}
		
		protected function onMainCharacterChanged(event:Event):void
		{
			if(Game.uiData.getMainCharacterID() == -1)
			{
				if(mainCharacter != null)
				{
					mainCharacter.removeEventListener(Character.BATTLE_POINT_CHANGED, mainCharacter_onBattlePointChanged);
					mainCharacter = null;
					cloneCharacter = null;
				}
				createElement.visible = false;
				resistElement.visible = false;
			}
			else
			{
				mainCharacter = Game.database.userdata.getCharacter(Game.uiData.getMainCharacterID());
				if(mainCharacter != null)
				{
					mainCharacter.addEventListener(Character.BATTLE_POINT_CHANGED, mainCharacter_onBattlePointChanged);
					cloneCharacter = mainCharacter.clone();
					var element:Element = Enum.getEnum(Element, mainCharacter.element) as Element;
					createElement.visible = true;
					createElement.gotoAndStop(element.created);
					resistElement.visible = true;
					resistElement.gotoAndStop(element.destroy);
				}
			}
			update();
		}
		
		override protected function onDeactivate():void
		{
			Utility.log( "CharacterUpgrade.onDeactivate" );
			Game.uiData.reset();
			Game.uiData.removeEventListener(UIData.MATERIAL_CHARACTERS_CHANGED, onMaterialCharactersChanged);
			Game.uiData.removeEventListener(UIData.MAIN_CHARACTER_CHANGED, onMainCharacterChanged);
			Game.network.lobby.unregisterPacketHandler(LobbyResponseType.LEVEL_UP_ENHANCEMENT, expTransferResult);
			super.onDeactivate();
		}
		
		private function onMouseOverHdl(e:MouseEvent):void {
			switch(e.target) {
				case movElementInstruction:
					if (Game.uiData.getMainCharacterID() != -1) {
						var value:String = "Công Lực Truyền Thụ Của Hệ: \n - Tương Sinh: <font size = '16' color = '#00ff00'>+150%</font> "
								+ "\n - Khắc Hệ: <font size = '16' color = '#333333'>+50%</font>"
								+ "\n - Các Hệ Khác: <font size = '16'>+100%</font>"
								+ "\nClick vào Ngũ Hành để chọn nhân vật theo Hệ";
						dispatchEvent(new EventEx(TooltipEvent.SHOW_TOOLTIP, { type:TooltipID.SIMPLE, value:value }, true));
					}
					break;
				case btnUpgrade:
					if (Game.uiData.getMainCharacterID() != -1) {
						value = "Công lực truyền thụ: " + getCurrentTotalEXP()
								+ "\nCông lực cần thiết: " + getNextStarEXP();
						dispatchEvent(new EventEx(TooltipEvent.SHOW_TOOLTIP, { type:TooltipID.SIMPLE, value:value }, true));
					}
					break;
			}
		}
		
		private function onMouseOutHdl(e:MouseEvent):void {
			dispatchEvent(new EventEx(TooltipEvent.HIDE_TOOLTIP, null, true));
		}
		
		private function getCurrentTotalEXP():int
		{
			var result:int = 0;
			if(Game.uiData.getMainCharacterID() != -1)
			{
				var materialCharacterIDs:Array = Game.uiData.getMaterialCharacterIDs();
				for(var i:int = 0, length:int = materialSlots.length; i < length; ++i)
				{
					var formationSlot:MaterialSlot = materialSlots[i];
					result += formationSlot.getEXP();
				}
			}
			return result;
		}
		
		private function getNextStarEXP():int
		{
			var result:int = 0;
			if(Game.uiData.getMainCharacterID() != -1)
			{
				var character:Character = Game.database.userdata.getCharacter(Game.uiData.getMainCharacterID());
				if(character != null)
				{
					var maxLevel:int = (character.currentStar + 1) * 12 + 1;
					var expTable:Array = Game.database.gamedata.getConfigData(GameConfigID.EXP_TABLE);
					result = expTable[character.level + 1] - character.exp;
					for(var i:int = character.level + 2; i <= maxLevel; ++i)
					{
						result += expTable[i];
					}
				}
			}
			return result;
		}
		
		private function expTransferResult(packet:IntResponsePacket):void
		{
			Utility.log("exp transfer, result=" + packet.value);
			switch(packet.value)
			{
				case ErrorCode.SUCCESS:
					playEffectTransmission();
					Game.network.lobby.sendPacket(new IntRequestPacket(LobbyRequestType.GET_PLAYER_INFO_ATTRIBUTE, PlayerAttributeID.GOLD.ID));
					Game.database.userdata.isEXPTransfer = true;
					Manager.tutorial.onTriggerCondition();
					break;
				case ErrorCode.EXP_TRANSFER_NOT_ENOUGH_GOLD:
					Manager.display.showMessageID(MessageID.NOT_ENOUGH_GOLD);
					break;
				case ErrorCode.EXP_TRANSFER_OVERCOMING:
					Manager.display.showMessage("Ngũ hành xung khắc");
					break;
				case ErrorCode.EXP_TRANSFER_FULL:
					Manager.display.showMessage("Đã đầy 12 tầng công lực, thăng cấp nhân vật để tiếp tục truyền công");
					break;
				case ErrorCode.EXP_TRANSFER_CURRENTLY_IN_FORMATION:
					Manager.display.showMessage("Không thể dùng nhân vật trong Đội Hình để truyền công");
					break;
			}
		}
		
		//protected function onClicked(event:MouseEvent):void
		protected function onClicked(event:EventEx):void
		{
			if(event.target is FormationSlot)
			{
				var slot:FormationSlot = event.target as FormationSlot;
				if(slot.getData() != null) Game.uiData.removeMaterialCharacter(slot.getData().ID);
			}
		}
		
		protected function onMaterialCharactersChanged(event:Event):void
		{
			update();
		}
		
		private function update():void
		{
			var mainCharacter:Character = Game.database.userdata.getCharacter(Game.uiData.getMainCharacterID());
			if(mainCharacter != null)
			{
				dummyCharacter.visible = false;
				characterSlot.visible = true;
				characterSlot.setData(mainCharacter);
				levelDetail.visible = true;
				levelDetail.setData(mainCharacter);
				estimater.setMainChar(mainCharacter);
				var config:Array = Game.database.gamedata.getConfigData(GameConfigID.COST_TRANSMISSION);
				setCost(config[mainCharacter.level]);
				movCurrency.visible = true;
				movCurrency.x = txtCost.x + ((txtCost.width - txtCost.textWidth) / 2) - movCurrency.width;
			}
			else
			{
				dummyCharacter.visible = true;
				characterSlot.visible = false;
				setCost(0);
				movCurrency.visible = false;
				levelDetail.visible = false;
			}
			var materialCharacter:Character;
			var materialCharacterIDs:Array = Game.uiData.getMaterialCharacterIDs();
			var i:int;
			var length:int;
			var ID:int;
			var formationSlot:MaterialSlot;
			for(i = 0, length = materialCharacterIDs.length; i < length; ++i)
			{
				ID = materialCharacterIDs[i];
				materialCharacter = Game.database.userdata.getCharacter(ID);
				formationSlot = materialSlots[i];
				formationSlot.setData(materialCharacter, mainCharacter);
			}

			estimater.updateMaterials(materialCharacterIDs);
		}
		
		protected function mainCharacter_onBattlePointChanged(event:Event):void
		{
			var dialogData:Object = {};
			dialogData.oldCharacter = cloneCharacter;
			dialogData.newCharacter = mainCharacter;
			dispatchEvent(new EventEx(TutorialEvent.EVENT, { type:TutorialEvent.SHOW_UPGRADE_INFO }, true));
			Manager.display.showDialog(DialogID.UPGRADE_INFO, onCloseUpgradeInfoDialog, null, dialogData);
		}
		
		private function onCloseUpgradeInfoDialog(data:Object):void
		{
			update();
			cloneCharacter.cloneInfo(mainCharacter);
			Game.network.lobby.getPlayerAttribute(PlayerAttributeID.BATTLE_POINT);
		}
		
		public function setCost(value:int):void {
			if (value >= 0) {
				txtCost.text = Utility.formatNumber(value);
			} else {
				txtCost.text = "";
			}
		}
		
		private function playEffectTransmission():void
		{
			blackMask.visible = true;
			mainEffect.play(0);
			var materialCharacterIDs:Array = Game.uiData.getMaterialCharacterIDs();
			for(var i:int = 0; i < materialEffects.length; ++i)
			{
				if(materialCharacterIDs[i] > -1) materialEffects[i].play(0,1);
			}
			timer.delay = 693;
			timer.start();
			dispatchEvent(new EventEx(TutorialEvent.EVENT, { type:TutorialEvent.ENHANCEMENT_SUCCESS }, true));
		}
		
		protected function timer_onComplete(event:TimerEvent):void
		{
			trace("timer_onComplete ========== " + timer_onComplete);
			var timer:Timer = event.target as Timer;
			switch(timer.delay)
			{
				case 693:
					transferEXP();
					break;
				case 990:
					mainEffect.play(1,1);
					break;
			}
		}
		
		public function set character(value:Character):void {
			_character = value;
		}
		
		private function btnUpgrade_onClicked(e:MouseEvent):void
		{
			if(Game.uiData.getMainCharacterID() > -1)
			{
				var packet:RequestLevelUpEnhancement = new RequestLevelUpEnhancement();
				packet.IDs.push(Game.uiData.getMainCharacterID());
				var characterIDs:Array = Game.uiData.getMaterialCharacterIDs();
				var passed:Boolean = false;
				for each(var characterID:int in characterIDs)
				{
					packet.IDs.push(characterID);
					if(characterID > -1) passed = true;
				}
				if(passed) Game.network.lobby.sendPacket(packet);
			}
		}
		
		public function clean():void
		{
			var x:Number;
			var y:Number;
			var beginRadian:Number = -Math.PI/2;
			var degree:Number = 360/MAX_MATERIAL_ITEMS;
			blackMask.visible = false;
			var radian:Number = Math.PI * 2 / MAX_MATERIAL_ITEMS;
			var materialEffect:Animator;
			for (var i:int = 0; i < materialEffects.length; i++) 
			{
				materialEffect = Animator(materialEffects[i])
				materialEffect.reset();
				
				x = Math.cos(beginRadian + i * radian) * 120;
				y = Math.sin(beginRadian + i * radian) * 120;
				
				materialEffect.x = x;
				materialEffect.y = y;
				materialEffect.rotation = i * degree;
			}
		}
		
		private function initUI():void {
			var formationSlot	:MaterialSlot;
			var boundingBox		:Rectangle;
			var point			:Point;
			var radian:Number = Math.PI*2/MAX_MATERIAL_ITEMS;
			var beginRadian:Number = -Math.PI/2;
			var degree:Number = 360/MAX_MATERIAL_ITEMS;
			var materialEffect:Animator;
			var x:Number;
			var y:Number;
			for (var i:int = 0; i < MAX_MATERIAL_ITEMS; i++) {
				x = Math.cos(beginRadian + i * radian) * 120;
				y = Math.sin(beginRadian + i * radian) * 120;
				formationSlot = new MaterialSlot();
				formationSlot.x = x;
				formationSlot.y = y;
				formationSlot.mouseChildren = false;
				formationSlot.doubleClickEnabled = true;
				formationSlot.addEventListener(MouseEvent.DOUBLE_CLICK, materialSlot_onDBClicked);
				materialSlots.push(formationSlot);
				materialCharactersContainer.addChild(formationSlot);
				
				materialEffect = new Animator();
				materialEffect.load("resource/anim/ui/fx_truyencong_material.banim");
				materialEffect.x = x;
				materialEffect.y = y;
				materialEffect.rotation = i * degree;
				materialEffect.addEventListener(Event.COMPLETE, materialEffect_onComplete);
				materialEffects.push(materialEffect);
				materialCharactersContainer.addChild(materialEffect);
			}
			
			movCurrency.visible = false;
		}
		
		protected function materialEffect_onComplete(event:Event):void
		{
			var animator:Animator = event.target as Animator;
			var animIndex:int = animator.getCurrentAnimation();
			switch(animIndex)
			{
				case 0:
					animator.play(1);
					break;
			}
		}
		
		protected function materialSlot_onDBClicked(event:MouseEvent):void
		{
			var slot:MaterialSlot = event.target as MaterialSlot;
			if(slot.getData() != null) Game.uiData.removeMaterialCharacter(slot.getData().ID);
		}
		
		public function transferEXP():void
		{
			var mainCharacter:Character = Game.database.userdata.getCharacter(Game.uiData.getMainCharacterID());
			if(mainCharacter != null)
			{
				expTransfering = true;
				totalTransferEXP = 0;
				var materials:Array = Game.uiData.getMaterialCharacterIDs();
				var character:Character;
				for each(var characterID:int in materials)
				{
					if(characterID > -1)
					{
						character = Game.database.userdata.getCharacter(characterID);
						if(character != null)
						{
							totalTransferEXP += character.getTransferEXP(mainCharacter.element);
						}
					}
				}
				partialTransfer();
			}
		}
		
		private function partialTransfer():void
		{
			var mainCharacter:Character = Game.database.userdata.getCharacter(Game.uiData.getMainCharacterID());
			if(mainCharacter != null)
			{
				var config:Array = Game.database.gamedata.getConfigData(GameConfigID.EXP_TABLE) as Array;
				var nextLevelEXP:int = config[mainCharacter.level + 1];
				var transferEXP:int = nextLevelEXP - mainCharacter.exp;
				if(totalTransferEXP < transferEXP)
				{
					mainCharacter.exp += totalTransferEXP;
					var progress:Number = mainCharacter.exp / nextLevelEXP;
					totalTransferEXP = 0;
					levelDetail.levelBar.setPercent(progress, true);
				}
				else
				{
					if((mainCharacter.level % 12) == 0)
					{
						totalTransferEXP = 0;
						mainCharacter.exp = nextLevelEXP;
					}
					else
					{
						totalTransferEXP -= transferEXP;
						mainCharacter.level += 1;
						mainCharacter.exp = 0;
					}
					
					levelDetail.levelBar.setPercent(1, true);
				}
			}
		}
		
		protected function onLevelBarTweenComplete(event:Event):void
		{
			if(expTransfering)
			{
				if(totalTransferEXP > 0)
				{
					var character:Character = Game.database.userdata.getCharacter(Game.uiData.getMainCharacterID());
					if(character != null)
					{
						var currentLevel:int = character.level % 12;
						if(currentLevel == 0) currentLevel = 12;
						levelDetail.txtCurrentLevel.text = currentLevel + "/12 tầng";
						var config:Array = Game.database.gamedata.getConfigData(GameConfigID.EXP_TABLE) as Array;
						var maxEXP:int = config[character.level + 1];
						levelDetail.txtEXP.text = character.exp + "/" + maxEXP;
					}
					levelDetail.levelBar.setPercent(0, false);
					partialTransfer();
				}
				else
				{
					expTransfering = false;
					for each(var effect:Animator in materialEffects)
					{
						if(effect.getCurrentAnimation() == 1) effect.play(2,1);
						timer.delay = 990;
						timer.start();
					}
				}
			}
		}
	}
	
}