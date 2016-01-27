package game.ui.leader_board 
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import core.event.EventEx;
	import core.util.FontUtil;
	
	import game.data.vo.lobby.LobbyPlayerInfo;
	import game.enum.Font;
	import game.enum.LeaderBoardTypeEnum;
	/**
	 * ...
	 * @author TrungLNM
	 */
	public class LeaderBoardPlayer extends MovieClip
	{
		public static const PLAYER_LEADER_BOARD_CLICK:String = "playerLeaderBoardClick";
		
		public var numTf:TextField;
		public var nameTf:TextField;
		public var levelTf:TextField;
		public var bgSelectedMov:MovieClip;
		public var bgMov:MovieClip;
		public var rankStatMov:RankStatMov;
		
		private var _info:LobbyPlayerInfo;
		private var _state:int = 0;
		
		public function LeaderBoardPlayer() 
		{
			/*if (stage)
				init();
			else addEventListener(Event.ADDED_TO_STAGE, init);	*/
			initUI();
		}
		
		/*private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			initUI();
		}*/
		
		private function initUI():void 
		{
			//set fonts
			FontUtil.setFont(numTf, Font.ARIAL, false);
			FontUtil.setFont(nameTf, Font.ARIAL, false);
			FontUtil.setFont(levelTf, Font.ARIAL, false);
			
			//selected
			//bgSelectedMov.alpha = 0;
			setState(0);
			bgSelectedMov.buttonMode = true;
			bgSelectedMov.addEventListener(MouseEvent.CLICK, onSelectedHdl);
			bgSelectedMov.addEventListener(MouseEvent.MOUSE_OVER, onMouseOverHdl);
			bgSelectedMov.addEventListener(MouseEvent.MOUSE_OUT, onMouseOutHdl);
		}
		
		private function onMouseOverHdl(e:MouseEvent):void 
		{
			var id:int = _info ? _info.id : 0;
			//Utility.log("request player formation info of ID: " + id);
			//dispatchEvent(new EventEx(TooltipEvent.SHOW_TOOLTIP, { type:TooltipID.PLAYER_FORMATION_INFO, value:id, from: TooltipID.FROM_LEADER_BOARD}, true));	
			if (_state != 1) {
				//Utility.log( "LeaderBoardPlayer.onMouseOverHdl > e :");
				setState(2);
			}
		}
		
		private function onMouseOutHdl(e:MouseEvent):void 
		{
			//dispatchEvent(new EventEx(TooltipEvent.HIDE_TOOLTIP, null, true));
			if(_state != 1) {
				//Utility.log( "LeaderBoardPlayer.onMouseOutHdl > e : ");
				setState(0);
			}
		}
		
		public function onSelectedHdl(e:MouseEvent = null):void 
		{
			//bgSelectedMov.alpha = 1;
			setState(1);
			dispatchEvent(new EventEx(PLAYER_LEADER_BOARD_CLICK, _info, true ));
		}
		
		public function updateInfo(index:int, info:LobbyPlayerInfo, topType:int):void {
			_info = info;
			
			numTf.text = _info ? index.toString() : "";
			nameTf.text = _info ? _info.name.toString() : "";			
			switch(topType) {
				case LeaderBoardTypeEnum.TOP_1vs1_AI.type:
					levelTf.text = _info ? _info.level.toString() : "";				
					break;		
				case LeaderBoardTypeEnum.TOP_LEVEL.type:
					levelTf.text = _info ? _info.level.toString() : "";				
					break;
				case LeaderBoardTypeEnum.TOP_DAMAGE.type:
					levelTf.text = _info ? _info.damage.toString() : "";				
					break;
				case LeaderBoardTypeEnum.TOP_1VS1_MM.type:
				case LeaderBoardTypeEnum.TOP_3VS3_MM.type:
					levelTf.text = _info ? _info.eloScore.toString() : "";				
					break;
				case LeaderBoardTypeEnum.HEROIC_TOWER.type:
					levelTf.text = _info ? _info.maxFloor.toString() : "";
					break;
			}
				
			//if (_info) {
				//rankStatMov.updateStat(info.rankUpdate);
				//rankStatMov.visible = _info ? true : false;
			//}
		}
		
		public function setState(state:int):void {
			_state = state;
			switch(state) {
				case 0:
					bgSelectedMov.gotoAndStop("normal");
					break;
				case 1:
					//Utility.log( "LeaderBoardPlayer.setState > state : ");
					bgSelectedMov.gotoAndStop("selected");
					break;	
				case 2:
					bgSelectedMov.gotoAndStop("rollover");
					break;	
			}
		}
		
	}

}