package game.ui.arena 
{
	import core.util.FontUtil;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import game.data.vo.lobby.LobbyPlayerInfo;
	import game.enum.Font;
	/**
	 * ...
	 * @author TrungLNM
	 */
	public class PlayerLeaderBoard extends MovieClip
	{
		
		//public var hitMov:MovieClip;
		
		public var rankTf:TextField;
		public var nameTf:TextField;
		public var valueTf:TextField;
		
		private var _data:LobbyPlayerInfo;
		
		public function PlayerLeaderBoard() 
		{
			initUI();			
		}
		
		private function initUI():void 
		{
			//set fonst
			FontUtil.setFont(rankTf, Font.ARIAL, true);
			FontUtil.setFont(nameTf, Font.ARIAL, true);
			FontUtil.setFont(valueTf, Font.ARIAL, true);
			
			//add events
			//hitMov.addEventListener(MouseEvent.CLICK, onClickHdl);
		}
		
		private function onClickHdl(e:MouseEvent):void 
		{
			
		}
		
		public function updateInfo(data:LobbyPlayerInfo, style:Boolean):void {
			if (data) {
				_data = data;
				
				rankTf.text = (data.rank + 1).toString();
				nameTf.text = data.name.toString();
				valueTf.text = data.eloScore.toString();
			}
			
			this.gotoAndStop(style ? "bg_black" : "bg_red");
		}
		
	}

}