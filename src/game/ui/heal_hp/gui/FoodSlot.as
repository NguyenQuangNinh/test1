package game.ui.heal_hp.gui 
{
	import core.display.BitmapEx;
	import core.event.EventEx;
	import core.Manager;
	import core.util.FontUtil;
	import core.util.MovieClipUtils;
	import core.util.Utility;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import game.enum.Font;
	import game.Game;
	import game.ui.heal_hp.HealHpEvent;
	import game.utility.GameUtil;
	/**
	 * ...
	 * @author anhtinh
	 */
	public class FoodSlot extends Sprite
	{
		public var xuTf : TextField;
		private var foodIcon : Sprite = new Sprite();
		private var vipIcon : Sprite = new Sprite();
		private var foodIconBitmap : BitmapEx;
		public var index : int;
		private var vipIconBitmap : BitmapEx;
		private var _isBuyable : Boolean;
		private var _xuPrice : int;
		private var _vipIconLoaded : Boolean;
		
		public function FoodSlot() 
		{
			this.addChild(foodIcon);
			this.addChild(vipIcon);
			
			FontUtil.setFont(xuTf, Font.ARIAL, true);
			foodIconBitmap = new BitmapEx();
			foodIconBitmap.addEventListener(BitmapEx.LOADED, onBitmapLoaded);
		}
		
		private function onBitmapLoaded(e:Event):void 
		{
			foodIconBitmap.x = 25;
			foodIconBitmap.y = 1 - foodIconBitmap.height;
			this.foodIcon.addChild(foodIconBitmap);
			
			this.buttonMode = true;
			this.addEventListener(MouseEvent.ROLL_OVER, onRollOver);
			this.addEventListener(MouseEvent.ROLL_OUT, onRollOut);
			this.addEventListener(MouseEvent.CLICK, onClick);
		}
		
		private function onClick(e:MouseEvent):void 
		{
			if (_isBuyable) {
				if (Game.database.userdata.xu >= _xuPrice) this.dispatchEvent(new EventEx(HealHpEvent.HEAL_HP, index, true));
				else {		//Ko du xu
					Manager.display.showMessageID(40);
				}
			}
			else {		// Chua phai vip
				Manager.display.showMessageID(42);
			}
			
		}
		
		private function onRollOut(e:MouseEvent):void 
		{
			if(_isBuyable) this.filters = null;
			this.dispatchEvent(new EventEx(HealHpEvent.HIDE_TOOLTIP, index, true));
		}
		
		private function onRollOver(e:MouseEvent):void 
		{
			
			if(_isBuyable) this.filters = [GameUtil.glowFilterYellow];
			this.dispatchEvent(new EventEx(HealHpEvent.SHOW_TOOLTIP, index, true));
		}
		
		public function loadIcon(url : String) : void {
			foodIconBitmap.load(url);
		}
		
		public function setPrice(xu : int) : void {
			_xuPrice = xu;
			
			xuTf.text = Utility.math.formatInteger(_xuPrice);
		}
		
		public function setVip(vip : int) : void {
			if (vip > 0) {
				if (Game.database.userdata.vip >= vip) {
					MovieClipUtils.removeAllFilters(this);
					_isBuyable = true;
				}else {
					MovieClipUtils.applyGrayScale(this);
					_isBuyable = false;
				}
				
				vipIcon.visible = true;
				
				if (! _vipIconLoaded) {
					vipIconBitmap = new BitmapEx();
					vipIconBitmap.addEventListener(BitmapEx.LOADED, onVipBitmapLoaded);
					vipIconBitmap.load("resource/image/ui/heal_hp/icon_vip.png");
				}
				
			}else {
				_isBuyable = true;
				vipIcon.visible = false;
			}
		}
		
		private function onVipBitmapLoaded(e:Event):void 
		{
			_vipIconLoaded = true;
			vipIconBitmap.x = 25;
			vipIconBitmap.y = -80 - vipIconBitmap.height;
			this.vipIcon.addChild(vipIconBitmap);
		}
		
	}

}