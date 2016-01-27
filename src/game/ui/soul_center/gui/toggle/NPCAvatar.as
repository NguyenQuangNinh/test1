package game.ui.soul_center.gui.toggle 
{
	import core.display.BitmapEx;
	import core.util.FontUtil;
	import core.util.MovieClipUtils;
	import core.util.Utility;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import game.enum.Font;
	import game.ui.components.ThreeStateMov;
	import game.ui.components.ToggleMov;
	import game.ui.soul_center.event.EventSoulCenter;
	/**
	 * ...
	 * @author anhtinh
	 */
	public class NPCAvatar extends ThreeStateMov
	{
		public var goldTf : TextField;
		public var nameTf : TextField;
		private var avatar : BitmapEx = new BitmapEx();
		private var _isDivinable : Boolean;
		
		public function NPCAvatar() 
		{
			FontUtil.setFont(goldTf, Font.ARIAL, true);
			FontUtil.setFont(nameTf, Font.ARIAL, true);
			
			this.addChild(avatar);
			
			this.addEventListener(MouseEvent.CLICK, onNormalDivine);
		}
		
		override public function set state(value:String):void 
		{
			super.state = value;
			
			switch (state) 
			{
				case INACTIVE_STATE:
					MovieClipUtils.adjustBrightness(avatar, 0.3);
					break;
					
				case ACTIVE_STATE:
					MovieClipUtils.glow(avatar, 0xFFFF00, 6, 6);
					break;
					
				case COMPLETE_STATE:
					MovieClipUtils.removeAllFilters(avatar);
					break;
				default:
					
			}
			
			
		}
		private function onNormalDivine(e:MouseEvent):void 
		{
			if(isDivinable) this.dispatchEvent(new EventSoulCenter(EventSoulCenter.NORMAL_DIVINE, null, true));
		}
		
		public function setAvatar(url : String) : void {
			avatar.load(url);
		}
		
		public function setAvatarPos(xPos : Number, yPos : Number) : void {
			
			avatar.x = xPos;
			avatar.y = yPos;
			
		}
		
		public function setNpcName(name : String) : void {
			nameTf.text = name;
		}
		
		public function setGold(gold : int) : void {
			goldTf.text = Utility.math.formatInteger(gold);
		}
		
		public function get isDivinable():Boolean 
		{
			return _isDivinable;
		}
		
		public function set isDivinable(value:Boolean):void 
		{
			_isDivinable = value;
			if (_isDivinable) {
				this.buttonMode = true;
				this.mouseEnabled = true;
			}else {
				this.buttonMode = false;
				this.mouseEnabled = false;
			}
		}
		
		
	}

}