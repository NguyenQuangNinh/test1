package game.ui.create_character 
{
	import com.greensock.easing.Back;
	import com.greensock.TweenMax;
	import core.event.EventEx;
	import game.utility.ElementUtil;
	import core.util.MovieClipUtils;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.BlurFilter;
	import flash.filters.GlowFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Transform;
	import flash.utils.getDefinitionByName;
	
	/**
	 * ...
	 * @author MaiPTT
	 */
	public class CreateCharacterClassView extends MovieClip 
	{
		static public const SELECTED		:String = "create_character_selected";
		
		public static const VO_DANG_BG		:String = "game.ui.create_character.bg.vo_dang";
		public static const THIEU_LAM_BG	:String = "game.ui.create_character.bg.thieu_lam";
		public static const NGA_MY_BG		:String = "game.ui.create_character.bg.nga_my";
		public static const MINH_GIAO_BG	:String = "game.ui.create_character.bg.minh_giao";
		public static const CAI_BANG_BG		:String = "game.ui.create_character.bg.cai_bang";
		
		public static const CAI_BANG_FEMALE		:String = "game.ui.create_character.character.cai_bang_female";
		public static const CAI_BANG_MALE		:String = "game.ui.create_character.character.cai_bang_male";
		public static const MINH_GIAO_FEMALE	:String = "game.ui.create_character.character.minh_giao_female";
		public static const MINH_GIAO_MALE		:String = "game.ui.create_character.character.minh_giao_male";
		public static const NGA_MY				:String = "game.ui.create_character.character.nga_my";
		public static const THIEU_LAM			:String = "game.ui.create_character.character.thieu_lam";
		public static const VO_DANG_MALE		:String = "game.ui.create_character.character.vo_dang";
		public static const VO_DANG_FEMALE		:String = "game.ui.create_character.character.vo_dang_female";
		
		public var element	:int;
		public var desX		:int;
		public var desY		:int;
		private var movBg	:MovieClip;
		private var sex		:int;
		private var blurFilter	:BlurFilter;
		private var glowFilter	:GlowFilter;
		private var characters	:Array;
		private var currentCharacterIndex	:int;
		private var _mainCharacterID		:int;
		
		public function CreateCharacterClassView(_element:int) {
			characters = [];
			currentCharacterIndex = -1;
			element = _element;
			sex = -1;
			_mainCharacterID = -1;
			switch(_element) {
				case ElementUtil.EARTH:
					desX = 340;
					desY = 106;
					movBg = getComponent(VO_DANG_BG);
					characters.push(getComponent(VO_DANG_FEMALE));
					characters.push(getComponent(VO_DANG_MALE));
					break;
					
				case ElementUtil.METAL:
					desX = 550;
					desY = 60;
					movBg = getComponent(THIEU_LAM_BG);
					characters.push(getComponent(THIEU_LAM));
					break;
					
				case ElementUtil.WATER:
					desX = 763;
					desY = 106;
					movBg = getComponent(NGA_MY_BG);
					characters.push(getComponent(NGA_MY));
					break;
					
				case ElementUtil.WOOD:
					desX = 970;
					desY = 60;
					movBg = getComponent(MINH_GIAO_BG);
					characters.push(getComponent(MINH_GIAO_FEMALE));
					characters.push(getComponent(MINH_GIAO_MALE));
					break;
					
				case ElementUtil.FIRE:
					desX = 136;
					desY = 60;
					movBg = getComponent(CAI_BANG_BG);
					characters.push(getComponent(CAI_BANG_FEMALE));
					characters.push(getComponent(CAI_BANG_MALE));
					break;
					
				default:
					movBg = null;
					desX = 0;
					desY = 0;
					characters = [];
					break;
			}	
			this.x = desX;
			this.buttonMode = true;
			glowFilter = new GlowFilter(0xFFFF00, 1, 7, 7, 4, BitmapFilterQuality.HIGH);
			initHandlers();
		}
		
		public function unSelect():void {
			if (characters && characters[currentCharacterIndex]) {
				characters[currentCharacterIndex].getChildAt(0).gotoAndStop(1);
				characters[currentCharacterIndex].getChildAt(0).filters = [];
				currentCharacterIndex = -1;	
			}
		}
		
		public function onTransIn():void {
			blurFilter = new BlurFilter(0, 250, 20);
			if (movBg) {
				addChild(movBg);
				movBg.filters = [blurFilter];
				
				if (element % 2) {
					movBg.y = - (movBg.height + desY);
				} else {
					movBg.y = (movBg.height + desY);
				}
				
				TweenMax.to(movBg, 0.9, { y:desY, ease:Back.easeOut, blurFilter:{blurY:0}, onComplete:onTransInBGAnimComplete} );
			}
		}
		
		public function onTransOut():void {
			
		}
		
		private function initHandlers():void {
			if (characters) {
				var character:MovieClip;
				for (var i:int = 0; i < characters.length; i++) {
					character = characters[i];
					character.addEventListener(MouseEvent.CLICK, onCharacterSelectHdl);
				}
			}
		}
		
		private function onCharacterSelectHdl(e:MouseEvent):void {
			var character:MovieClip;
			if (characters.length == 1) {
				character = characters[0];
				if (character) {
					MovieClip(character.getChildAt(0)).gotoAndPlay(2);
					character.getChildAt(0).filters = [glowFilter];
					currentCharacterIndex = 0;
				}
			} else if (characters.length == 2) {
				character = e.currentTarget as MovieClip;
				MovieClip(character.getChildAt(0)).gotoAndPlay(2);
				character.getChildAt(0).filters = [glowFilter];
				var index:int = Utilities.getElementIndex(characters, character);
				if (index != -1 && index != currentCharacterIndex) {
					if (currentCharacterIndex != -1) {
						swapCharacter(characters[index], characters[currentCharacterIndex], true);	
					} else {
						if (index) {
							swapCharacter(characters[1], characters[0], true);
						} else {
							swapCharacter(characters[0], characters[1], true);
						}
					}
					currentCharacterIndex = index;
				} 
			}
			dispatchEvent(new EventEx(SELECTED, { _sex:currentCharacterIndex, _class:_mainCharacterID,
												 _element:element}, true));
		}
		
		private function swapCharacter(front:MovieClip, back:MovieClip, isSelected:Boolean):void {
			if (front && back) {
				if (back && movBg) {
					MovieClip(back.getChildAt(0)).gotoAndStop(1);
					MovieClipUtils.removeAllFilters(back.getChildAt(0));
					MovieClipUtils.adjustBrightness(back.getChildAt(0), 0.4);
					back.scaleX = back.scaleY = 0.75;
					back.x = (movBg.width - back.width) / 2;
					back.y = 200 + desY - back.height;
					back.alpha = 0;
					addChild(back);
					TweenMax.to(back, 0.5, { alpha:1 } );
				}
				
				if (front && movBg) {
					MovieClip(front.getChildAt(0)).gotoAndStop(1);
					MovieClipUtils.removeAllFilters(front);
					if (isSelected) {
						MovieClip(front.getChildAt(0)).gotoAndPlay(2);
						front.getChildAt(0).filters = [glowFilter];
					} 
					front.scaleX = front.scaleY = 1.0;
					front.x = (movBg.width - front.width) / 2;
					front.y = 350 + desY - front.height;
					front.alpha = 0;
					addChild(front);
					TweenMax.to(front, 0.5, { alpha:1} );
				}
			}
		}
		
		private function onTransInBGAnimComplete():void {
			var character:MovieClip;
			if (characters.length == 1) {
				character = characters[0] as MovieClip;
				if (character && movBg) {
					character.x = (movBg.width - character.width) / 2;
					character.y = 345 + desY - character.height;
					character.alpha = 0;
					addChild(character);
					TweenMax.to(character, 0.5, { alpha:1 } );
				}
			} else if (characters.length == 2) {
				swapCharacter(characters[1], characters[0], false);
			}
		}
				
		private function getComponent(componentName : String) : MovieClip {
			try {
				var classDef : Class =  getDefinitionByName(componentName) as Class;
			} catch (err:Error){
				return null;				
			}
			return new classDef();		
		}
		
		public function get mainCharacterID():int	{
			return _mainCharacterID;
		}
		
		public function set mainCharacterID(value:int):void {
			_mainCharacterID = value;
		}
	}

}