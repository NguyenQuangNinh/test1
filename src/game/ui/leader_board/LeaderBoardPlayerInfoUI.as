package game.ui.leader_board 
{
	import core.util.FontUtil;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.text.TextField;
	import game.data.vo.lobby.LobbyPlayerInfo;
	import game.enum.Font;
	/**
	 * ...
	 * @author TrungLNM
	 */
	public class LeaderBoardPlayerInfoUI extends MovieClip
	{
		
		public var rankTf:TextField;	
		private var _player:LeaderBoardPlayerTop;
		
		private static const PLAYER_START_FROM_X:int = 40;
		private static const PLAYER_START_FROM_Y:int = 63;
		
		
		public function LeaderBoardPlayerInfoUI() 
		{
			/*if (stage)
				init();
			else addEventListener(Event.ADDED_TO_STAGE, init);*/	
			initUI();
		}
		
		/*private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			initUI();
		}*/
		
		private function initUI():void 
		{
			//set font
			FontUtil.setFont(rankTf, Font.ARIAL, true);
			
			_player = new LeaderBoardPlayerTop();
			_player.gotoAndStop("info");
			_player.x = PLAYER_START_FROM_X;
			_player.y = PLAYER_START_FROM_Y;
			addChild(_player);
		}
		
		public function updateInfo(info: LobbyPlayerInfo): void {
			_player.updateInfo(-1,info);
			
			if (info.rank < 0){
				rankTf.text = "Chưa xếp hạng";
			}
			else {
				rankTf.text = info ? "Hạng " + (info.rank + 1).toString() : "";
			}
			
		}
		
	}

}