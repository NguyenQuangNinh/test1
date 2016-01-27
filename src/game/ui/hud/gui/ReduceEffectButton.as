package game.ui.hud.gui 
{
	import core.sound.SoundManager;
	import core.util.MovieClipUtils;
	import core.util.Utility;
	import flash.events.Event;
	import flash.events.MouseEvent;

	import game.Game;
	import game.ui.hud.HUDButtonID;
	/**
	 * ...
	 * @author TrungLNM
	 */
	public class ReduceEffectButton extends HUDButton
	{
		private var _enable:Boolean = true;
		
		public static const REDUCE_EFFECT_TOOGLE:String = "reduce_effect_toogle";
		
		public function ReduceEffectButton()
		{
			ID = HUDButtonID.REDUCE_EFFECT;
			enable = Game.database.gamedata.enableReduceEffect;
			isSelected = _enable;
			addEventListener(MouseEvent.CLICK, onClickHdl);
//			addEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}
		
		private function onClickHdl(e:MouseEvent = null):void 
		{
			onToggle();
		}			
		
		public function onToggle():void
		{
			enable = !_enable;
			isSelected = _enable;
			
			if (bgMov) {
				MovieClipUtils.starHueAdjust(bgMov, _enable ? 128 : 0);
			}else {
				gotoAndStop(_enable ? "selected" : "unselected");				
			}
			Utility.log("REDUCE_EFFECT_TOOGLE enable: " + _enable);
			dispatchEvent(new Event(REDUCE_EFFECT_TOOGLE, true));
		}

		override public function checkVisible():void
		{
			super.checkVisible();
			gotoAndStop(_enable ? "selected" : "unselected");
		}

		private function set enable(value:Boolean):void
		{
			_enable = value;
		}
	}

}