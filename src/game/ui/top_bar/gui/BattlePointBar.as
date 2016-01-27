package game.ui.top_bar.gui
{
	import com.greensock.TweenLite;
	import core.display.animation.Animator;
	import core.util.FontUtil;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.text.TextField;
	import game.enum.Font;
	import game.ui.components.RuningNumberTf;
	
	/**
	 * ...
	 * @author chuongth2
	 */
	public class BattlePointBar extends MovieClip
	{
		public var valueTf:TextField;
		
		private var runingNumberTf:RuningNumberTf;
		
		private var _effectChange:Animator;
		private var _pointChange:int;
		
		public function BattlePointBar()
		{
			runingNumberTf = new RuningNumberTf(valueTf);
			FontUtil.setFont(valueTf, Font.ARIAL, true);
			
			_effectChange = new Animator();
			_effectChange.load("resource/anim/ui/hieuung_lucchien.banim");
			_effectChange.setCacheEnabled(false);
			_effectChange.x = valueTf.x + valueTf.width / 2;
			_effectChange.y = valueTf.y + valueTf.height / 2;
			_effectChange.visible = false;
			_effectChange.addEventListener(Event.COMPLETE, onPlayEffectCompletedHdl);
			addChild(_effectChange);
		}
		
		private function onPlayEffectCompletedHdl(e:Event):void
		{
			_effectChange.visible = false;
			TweenLite.to(runingNumberTf, 1.0, {value: _pointChange});
		}
		
		public function setBattlePoint(oldPoint:int, battlePoint:int):void
		{
			runingNumberTf.value = oldPoint;
			_pointChange = battlePoint;
			if (oldPoint < battlePoint && oldPoint > 0)
			{
				_effectChange.visible = true;
				_effectChange.play(0, 1);
			}
			else
			{
				TweenLite.to(runingNumberTf, 1.0, {value: battlePoint});
			}
		}
	}

}