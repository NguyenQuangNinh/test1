package game.ui.leader_board 
{
	import core.util.FontUtil;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.text.TextField;
	import game.enum.Font;
	/**
	 * ...
	 * @author TrungLNM
	 */
	public class RankStatMov extends MovieClip
	{
		
		public var countTf:TextField;
		public var stateMov:MovieClip;
		
		public function RankStatMov() 
		{
			if (stage)
				init();
			else addEventListener(Event.ADDED_TO_STAGE, init);	
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			initUI();
		}
		
		private function initUI():void 
		{
			//set font
			FontUtil.setFont(countTf, Font.ARIAL, true);			
		}
		
		public function updateStat(rankUpdate:int):void {
			stateMov.gotoAndStop(rankUpdate != 0 ? (rankUpdate > 0 ? "up" : "down") : "normal");
			//display need to be format for short
			countTf.text = rankUpdate != 0 ? Math.abs(rankUpdate).toString() : "";
		}
		
		
	}

}