package game.ui.hud.gui 
{
	import core.sound.SoundManager;
	import core.util.MovieClipUtils;
	import core.util.Utility;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import game.ui.hud.HUDButtonID;
	/**
	 * ...
	 * @author TrungLNM
	 */
	public class SoundButton extends HUDButton
	{
		private var _enable:Boolean = true;
		
		public static const SOUND_TOOGLE:String = "sound_toogle";
		
		public function SoundButton() 
		{
			ID = HUDButtonID.SOUND;
			
			isSelected = _enable;
			gotoAndStop("selected");
			addEventListener(MouseEvent.CLICK, onClickHdl);
		}
		
		private function onClickHdl(e:MouseEvent = null):void 
		{
			onToggle();
		}			
		
		public function onToggle():void
		{
			_enable = !_enable;
			isSelected = _enable;
			
			if (bgMov) {
				MovieClipUtils.starHueAdjust(bgMov, _enable ? 128 : 0);
			}else {
				gotoAndStop(_enable ? "selected" : "unselected");				
			}
			Utility.log("sound button toogle enable: " + _enable);
			dispatchEvent(new Event(SOUND_TOOGLE, true));
		}
		
		/*override public function get isSelected():Boolean 
		{
			return super.isSelected;
		}
		
		override public function set isSelected(value:Boolean):void 
		{
			super.isSelected = value;
			
			if (bgMov) {
				MovieClipUtils.starHueAdjust(bgMov, super.isSelected ? 128 : 0);
			}else {
				gotoAndStop(super.isSelected ? "selected" : "unselected");				
			}
			
			SoundManager.toggleMute();
		}*/
	}

}