package game.ui.hud.gui 
{
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	
	import core.util.FontUtil;
	
	import flash.display.MovieClip;
	import flash.text.TextField;
	
	import game.enum.Font;
	import game.ui.hud.HUDButtonID;

	/**
	 * ...
	 * @author anhtinh
	 */
	public class QuestTransportButton extends HUDButton
	{
		public var timeMov:MovieClip;
		public var countMov:MovieClip;
		public var completedMov:MovieClip;
		public var numTf: TextField;
		
		/*public var newMov:MovieClip;
		private var _newsTween:TweenMax;
		
		public var finishMov:MovieClip;
		private var _finishTween:TweenMax;*/
		
		public function QuestTransportButton() 
		{			
			/*_newsTween = new TweenMax(newMov, 0.3, { y: -15, yoyo: true, repeat: -1 } );
			_finishTween = new TweenMax(finishMov, 0.3, { y: -15, yoyo: true, repeat: -1 } );*/
			FontUtil.setFont(numTf, Font.ARIAL, true);		
			ID = HUDButtonID.QUEST_TRANSPORT;
			focusable = true;
			timeMov.visible = false;
		}
		
		/*public function showAttention(type:int, show:Boolean):void {
			switch(type) {
				case 1:
					newMov.visible = show;
					_newsTween._active = show;
					break;
				case 2:
					finishMov.visible = show;
					_finishTween._active = show;
					break;
			}
		}*/
		
	}

}