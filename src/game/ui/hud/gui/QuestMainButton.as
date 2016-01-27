package game.ui.hud.gui 
{
	import com.greensock.TweenMax;
	import game.Game;
	
	import flash.display.MovieClip;
	
	import game.ui.hud.HUDButtonID;

	/**
	 * ...
	 * @author anhtinh
	 */
	public class QuestMainButton extends HUDButton
	{
		/*public var newMov:MovieClip;
		private var _newsTween:TweenMax;
		
		public var finishMov:MovieClip;
		private var _finishTween:TweenMax;*/
		
		public function QuestMainButton() 
		{
			/*_newsTween = new TweenMax(newMov, 0.3, { y: -15, yoyo: true, repeat: -1 } );
			_finishTween = new TweenMax(finishMov, 0.3, { y: -15, yoyo: true, repeat: -1 } );*/
			
			ID = HUDButtonID.QUEST_MAIN;
			focusable = true;
		}
		
		//public function showAttention(type:int, show:Boolean):void {
		/*public function showAttention(show:Boolean):void {
			//switch(type) {
				//case 1:
					//newMov.visible = show;
					//_newsTween._active = show;
					//break;
				//case 2:
					//finishMov.visible = show;
					//_finishTween._active = show;
					//break;
			//}
			newMov.visible = !show;
			_newsTween._active = !show;
			
			finishMov.visible = show;
			_finishTween._active = show;
		}*/		
		override public function checkVisible():void
		{
			this.visible = Game.database.userdata.quests.length > 0?true:false;
		}
	}

}