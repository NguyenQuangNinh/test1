package game.ui.arena 
{
	import core.event.EventEx;
	import core.util.FontUtil;
	import core.util.MovieClipUtils;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import game.data.vo.lobby.LobbyPlayerInfo;
	import game.enum.Font;
	import game.ui.components.PagingMov;
	/**
	 * ...
	 * @author TrungLNM
	 */
	public class TopLeaderBoardMov extends MovieClip
	{
		//event dispatch
		public static const TOP_LEADER_BOARD_REQUEST:String = "topLeaderBoardRequest";
		public static const TOP_LEADER_BOARD_PREVIOUS:int = 1;
		public static const TOP_LEADER_BOARD_NEXT:int = 2;
		
		public var leftBtn:SimpleButton;
		public var rightBtn:SimpleButton;
		
		public var playersContainerMov:MovieClip;
		
		public var titleTf:TextField;
		private var _paging:PagingMov;
		
		public static const MAX_TOP_SHOW_IN_LIST:int = 10;
		
		private static const PAGING_START_FROM_X:int = 145;
		private static const PAGING_START_FROM_Y:int = 345;
		
		private static const DISTANCE_PER_PLAYER:int = 31;
		
		//public var matchingCountMov:MatchingCount;
		private var _data:Array;
		
		public function TopLeaderBoardMov() 
		{
			initUI();
		}
		
		private function initUI():void 
		{
			//set fonts
			FontUtil.setFont(titleTf, Font.ARIAL, false);
			
			_paging = new PagingMov();
			_paging.x = PAGING_START_FROM_X;
			_paging.y = PAGING_START_FROM_Y;
			addChild(_paging);
			
			//add events
			leftBtn.addEventListener(MouseEvent.CLICK, onBtnClickHdl);
			rightBtn.addEventListener(MouseEvent.CLICK, onBtnClickHdl);
			
			//set text
			titleTf.text = "BẢNG XẾP HẠNG TUẦN";
		}
		
		private function onBtnClickHdl(e:MouseEvent):void 
		{
			switch(e.target) {				
				case leftBtn:
					dispatchEvent(new EventEx(TOP_LEADER_BOARD_REQUEST, TOP_LEADER_BOARD_PREVIOUS, true));
					break;
				case rightBtn:
					dispatchEvent(new EventEx(TOP_LEADER_BOARD_REQUEST, TOP_LEADER_BOARD_NEXT, true));
					break;
				/*case rewardBtn:
					//just show reward description
					rewardInfoMov.visible = true;
					enableButtonView(false);
					break;*/
			}
		}
		
		public function updateTopChampion(index:int, pageNum:int, data:Array, isLastBack:Boolean, isLastNext:Boolean):void {
			_data = data;
			if (data) {
				//clear content
				var page:MovieClip;
				var player:PlayerLeaderBoard;				
				MovieClipUtils.removeAllChildren(playersContainerMov);
				//data.sortOn(["eloScore"], [Array.DESCENDING | Array.NUMERIC]);
				
				for (var i:int = 0; i < data.length; i++) {
					player = new PlayerLeaderBoard();
					player.updateInfo(data[i] as LobbyPlayerInfo, i % 2 == 0);
					player.y = DISTANCE_PER_PLAYER * i;						
					playersContainerMov.addChild(player);					
				}
				
				//set top title 
				titleTf.text = "BẢNG XẾP HẠNG " + (index < 0 ? "CÁCH ĐÂY " + Math.abs(index).toString() + " TUẦN" : "TUẦN HIỆN TẠI");
				
				//update navigation status
				if (isLastBack) {
					leftBtn.mouseEnabled = false;
					MovieClipUtils.applyGrayScale(leftBtn);
				}else {
					leftBtn.mouseEnabled = true;
					MovieClipUtils.removeAllFilters(leftBtn);
				}
				
				if (isLastNext) {
					rightBtn.mouseEnabled = false;
					MovieClipUtils.applyGrayScale(rightBtn);
				}else {
					rightBtn.mouseEnabled = true;
					MovieClipUtils.removeAllFilters(rightBtn);
				}
			}
		}
		
		public function updatePaging(current:int, total:int):void {
			_paging.visible = current > 0;
			_paging.update(current, total);
		}
		
		/*public function updateInfo(info:ResponsePVP1vs1ChampionState):void {
			if (info) {
				_info = info;
				
				//update info 
				//set text				
				numPlayTf.text = "Số trận:   " + info.numMatchPlayed.toString() + "/" + _maxNumPlayerInDay.toString();
				rankTf.text = "Hạng của bạn:   " + info.rank.toString();
				
				var limit:int = Game.database.gamedata.getConfigData(GameConfigID.LIMIT_HONOR_POINT_DAILY) as int;
				//var modeXML:ModePvPXML = GameUtil.getModeXMLByType(ModePVPEnum.PvP_1vs1_MATCHING) as ModePvPXML;
				
				pointTf.text = "Chiến tích:   " + info.honorPoint.toString() + "/" + limit.toString();
				eloTf.text = "Uy Danh\n" + info.eloPoint.toString();
				rewardTf.text = "PHẦN THƯỞNG";
				
				//update reward
				rewardReceiveMov.updateRewards(info.rewardDaily, info.receivedRewardDaily, info.rewardWeekly, info.receivedRewardWeekly,
												info.timeRemainRewardDaily, info.timeRemainRewardWeekly);
			}		
		}*/
		
		/*public function startMatching():void {
			enableButtonView(false);
			matchingCountMov.visible = true;
			matchingCountMov.startCount();
		}
		
		public function stopMatching():void {
			enableButtonView(true);
			matchingCountMov.visible = false;
			matchingCountMov.stopCount();
		}
		
		public function enableButtonView(enable:Boolean):void {
			closeBtn.mouseEnabled = enable;
			infoBtn.mouseEnabled = enable;
			rewardBtn.mouseEnabled = enable;
			leftBtn.mouseEnabled = enable;			
			rightBtn.mouseEnabled = enable;
			startBtn.mouseEnabled = enable;
			
			_paging.mouseEnabled = enable;			
			_paging.mouseChildren = enable;			
			
			rewardReceiveMov.mouseEnabled = enable;
			rewardReceiveMov.mouseChildren = enable;
		}*/
	}

}