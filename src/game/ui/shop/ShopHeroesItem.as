package game.ui.shop 
{
	import com.greensock.easing.Back;
	import com.greensock.TweenMax;

	import core.display.BitmapEx;
	import core.display.animation.Animator;
	import core.display.pixmafont.PixmaText;
	import core.event.EventEx;
	import core.Manager;
	import core.util.FontUtil;
	import core.util.MovieClipUtils;
	import core.util.Utility;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.filters.BlurFilter;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.utils.Timer;
	import game.data.model.Character;
	import game.data.model.shop.ShopItem;
	import game.data.xml.DataType;
	import game.data.xml.GameConditionXML;
	import game.data.xml.MissionXML;
	import game.enum.CharacterAnimation;
	import game.enum.ConditionType;
	import game.enum.Font;
	import game.enum.GameConditionType;
	import game.Game;
	import game.utility.UtilityUI;
	
	/**
	 * ...
	 * @author MaiPTT
	 */
	public class ShopHeroesItem extends MovieClip 
	{
		public var movHit					:SimpleButton;
		public var characterSlotContainer	:MovieClip;
		public var movLock					:MovieClip;
		public var movNotBuyable			:MovieClip;
		public var movExpired				:MovieClip;
		public var avatar                   :BitmapEx;
		public var txtInfo					:TextField;
		public var txtName					:TextField;
		
		private var _shopItemData			:ShopItem;
		private var _character				:Character;
		private var _isSelected				:Boolean;
		private var timer					:Timer;
		private var expiredTime				:int;
		private var glow					:GlowFilter
		
		public function ShopHeroesItem() {
			avatar = Manager.pool.pop(BitmapEx) as BitmapEx;
			avatar.addEventListener(BitmapEx.LOADED, avatarLoadedHandler);
			avatar.reset();
			characterSlotContainer.addChild(avatar);

			movHit.addEventListener(MouseEvent.CLICK, onBtnClickHdl);
			
			FontUtil.setFont(txtInfo, Font.ARIAL, true);
			FontUtil.setFont(txtName, Font.ARIAL, true);
			
			buttonMode = true;
			movLock.visible = false;
			movLock.mouseChildren = false;
			movLock.mouseEnabled = false;
			movNotBuyable.visible = false;
			movNotBuyable.mouseChildren = false;
			movNotBuyable.mouseEnabled = false;
			txtName.mouseEnabled = false;
			timer = new Timer(1000);
			movExpired.visible = false;
			
			glow = new GlowFilter();
			glow.strength = 10;
			glow.blurX = glow.blurY = 4;
		}

		private function avatarLoadedHandler(event:Event):void
		{
			avatar.x = -avatar.width/2;
			avatar.y = -avatar.height/2;
		}

		public function tweenTo(_x:int, _y:int, _scale:Number):void {
			var blurFilter:BlurFilter = new BlurFilter(30, 0, 5);
			this.filters = [blurFilter];
			TweenMax.to(this, 0.5, {x:_x, y:_y, scaleX:_scale, scaleY:_scale, blurFilter:{blurX:0}, ease: Back.easeOut});
		}
		
		private function onBtnClickHdl(e:MouseEvent):void {
			var targetDisplayObj:DisplayObject = e.target as DisplayObject;
			switch(targetDisplayObj) {
				case movHit:
					dispatchEvent(new EventEx(ShopEvent.SHOP_EVENT, { type: ShopEvent.REQUEST_CHARACTER_INFO,
																	value: _character, shopItem:_shopItemData}, true ));
					break;
			}
		}
		
		public function isExpired():Boolean {
			if (_character) {
				return _character.isExpired();
			}
			return false;
		}
		
		public function get isSelected():Boolean {
			return _isSelected;
		}
		
		public function set isSelected(value:Boolean):void {
			movLock.visible = false;
			movNotBuyable.visible = false;
			_isSelected = value;
			if (value) {
				switch(_shopItemData.status) {
					case ShopItem.LOCKED:
						MovieClipUtils.adjustBrightness(characterSlotContainer, 0.2);
						movLock.visible = true;
						movNotBuyable.visible = true;
						break;
						
					case ShopItem.NOT_BUYABLE:
						MovieClipUtils.glow(characterSlotContainer);
						movNotBuyable.visible = true;
						break;
						
					case ShopItem.BUYABLE:
					case ShopItem.ALREADY_BOUGHT:
						MovieClipUtils.glow(characterSlotContainer);
						break;
						
				}
			} else {
				switch(_shopItemData.status) {
					case ShopItem.BUYABLE:
					case ShopItem.ALREADY_BOUGHT:
						MovieClipUtils.removeAllFilters(characterSlotContainer);
						break;
						
					case ShopItem.NOT_BUYABLE:
						MovieClipUtils.removeAllFilters(characterSlotContainer);
						movNotBuyable.visible = true;
						break;
						
					case ShopItem.LOCKED:
						MovieClipUtils.adjustBrightness(characterSlotContainer, 0.2);
						movLock.visible = true;
						movNotBuyable.visible = true;
						break;
				}
			}
		}
		
		public function set shopItemData(value:ShopItem):void {
			_shopItemData = value;
			if (_shopItemData) {
				if (_shopItemData.item as Character) {
					_character = _shopItemData.item as Character;
					avatar.load(_character.xmlData.artworkURL);
				}
				
				movLock.visible = false;
				movNotBuyable.visible = false;
				txtInfo.text = "";
				
				if (timer.running) timer.stop();
				if (timer.hasEventListener(TimerEvent.TIMER)) {
					timer.removeEventListener(TimerEvent.TIMER, onTimerEventHdl);
				}
				
				movExpired.visible = false;
				switch(_shopItemData.status) {
					case ShopItem.ALREADY_BOUGHT:
						MovieClipUtils.removeAllFilters(characterSlotContainer);
						if (!_character.isExpired()) {
							if (_character.expiredTime == -1) {
								txtInfo.text = "Vĩnh Viễn";
							} else {
								expiredTime = _character.expiredTime;
								timer.addEventListener(TimerEvent.TIMER, onTimerEventHdl);
								timer.start();
								txtInfo.text = formatTime(expiredTime);
							}
							
						} else {
							txtInfo.text = "";
							movExpired.visible = true;
						}
						break;

					case ShopItem.BUYABLE:
						MovieClipUtils.removeAllFilters(characterSlotContainer);
						break;
						
					case ShopItem.NOT_BUYABLE:
						MovieClipUtils.removeAllFilters(characterSlotContainer);
						movNotBuyable.visible = true;
						break;
						
					case ShopItem.LOCKED:
						movLock.visible = true;
						movNotBuyable.visible = true;
						MovieClipUtils.adjustBrightness(characterSlotContainer, 0.2);
						txtInfo.text = "Mở ở level: " + shopItemData.shopXML.levelRequire;
						break;
				}
				
				if (_character && _character.xmlData) {
					txtName.htmlText = "<font color = '"
										+ UtilityUI.getTxtColor(_character.xmlData.quality[0], false, _character.isLegendary()) 
										+ "'>" + _character.xmlData.name + "</font>";
					glow.color = UtilityUI.getTxtGlowColor(_character.xmlData.quality[0], false, _character.isLegendary());
					txtName.filters = [glow];
				}
				FontUtil.setFont(txtName, Font.ARIAL, true);
			}
		}
		
		public function destroy():void {
			_character = null;
			_shopItemData = null;

			avatar.removeEventListener(BitmapEx.LOADED, avatarLoadedHandler);
			avatar.reset();
			if (avatar.parent) {
				avatar.parent.removeChild(avatar);
			}
			Manager.pool.push(avatar, BitmapEx);
			avatar = null;
		}
		
		private function onTimerEventHdl(e:TimerEvent):void {
			expiredTime = expiredTime - 1;
			if (expiredTime > 0) {
				txtInfo.text = formatTime(expiredTime);	
			} else {
				timer.stop();
				timer.removeEventListener(TimerEvent.TIMER, onTimerEventHdl);
				txtInfo.text = "";
				movExpired.visible = true;
			}
		}
		
		private function formatTime(value:int):String {
			var rs:String = "";
			var hours:int = Math.floor(value / (60 * 60));
			var minutes:int = Math.floor((value - hours * 60 * 60) / 60);
			var seconds:int = value - (hours * 60 * 60) - (minutes * 60);
			if (hours < 10) {
				rs += "0" + hours + ":";
			} else {
				rs += hours + ":";
			}
			if (minutes < 10) {
				rs += "0" + minutes + ":";
			} else {
				rs += minutes + ":";
			}
			if (seconds < 10) {
				rs += "0" + seconds;
			} else {
				rs += seconds;
			}
			return rs;
		}
		
		public function get characterID():int {
			if (_character) {
				return _character.xmlData.ID;
			}
			return -1;
		}
		
		public function get shopItemData():ShopItem {
			return _shopItemData;
		}
	}

}