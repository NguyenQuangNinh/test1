package game.ui.present.gui
{
	import components.scroll.VerScroll;
	import core.util.Utility;
	import flash.display.MovieClip;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import game.data.vo.lobby.LobbyPlayerInfo;
	import game.data.xml.DataType;
	import game.data.xml.TopConfigXML;
	import game.enum.GameConfigID;
	import game.enum.LeaderBoardTypeEnum;
	import game.Game;
	import game.net.lobby.response.ResponseGetTopLevelInPresent;
	import game.ui.components.ScrollbarEx;
	
	//import game.data.enum.topleader.LeaderBoardTypeEnum;
	
	/**
	 * ...
	 * @author chuongth2
	 */
	public class PresentTopView extends MovieClip
	{
		
		public var contentMask:MovieClip;
		public var scroll:MovieClip;
		public var topContent:PresentTopContentTop;
		
		private var scrollbar:VerScroll;
		private var _contentScrollBar:MovieClip = new MovieClip();
		private var _myTimer:Timer = new Timer(1000);
		
		public function PresentTopView()
		{
			contentMask.visible = false;
			scrollbar = new VerScroll(contentMask, _contentScrollBar, scroll);
			
			_contentScrollBar.x = contentMask.x;
			_contentScrollBar.y = contentMask.y;
			
			_myTimer.addEventListener(TimerEvent.TIMER, countdown);
			
			this.addChild(_contentScrollBar);
		}
		
		private function countdown(e:TimerEvent):void
		{
			topContent.exprieTimeTf.text = Utility.math.formatTime("H-M-S", _myTimer.repeatCount - _myTimer.currentCount);
			if (_myTimer.currentCount >= _myTimer.repeatCount)
				_myTimer.reset();
		}
		
		public function init(packetGetTopLevelInPresent:ResponseGetTopLevelInPresent):void
		{
			if (packetGetTopLevelInPresent == null)
				return;
			var topItem:PresentTopItem;
			var topItemEx:PresentTopItemEx;
			while (_contentScrollBar.numChildren > 0)
			{
				_contentScrollBar.removeChildAt(0);
			}
			
			var nDayReceiveTopLevel:int = Game.database.gamedata.getConfigData(GameConfigID.DAY_RECEIVE_TOP_LEVEL) as int;
			if (packetGetTopLevelInPresent.nDetaDiffDays == 1)
			{
				_myTimer.repeatCount = 86400 - (packetGetTopLevelInPresent.nDiffSeconds - (nDayReceiveTopLevel -1)*86400);
				_myTimer.start();
			}
			else if (packetGetTopLevelInPresent.nDetaDiffDays > 1)
				topContent.exprieTimeTf.text = "Còn " + packetGetTopLevelInPresent.nDetaDiffDays.toString() + " ngày";
			else
				topContent.exprieTimeTf.text = "--:--:--";
			
			
			
			topContent.msgTf.text = "Trong " + nDayReceiveTopLevel.toString() + " ngày đầu mở server, 100 người có cấp độ cao nhất sẽ nhận phần thưởng hậu hĩnh";
			
			if (packetGetTopLevelInPresent.nDetaDiffDays >= 0)
			{
				var pos:int = 0;
				var topConfig:TopConfigXML = Game.database.gamedata.getData(DataType.TOP_CONFIG, LeaderBoardTypeEnum.TOP_LEVEL.type) as TopConfigXML;
				if (topConfig == null)
					return;
				
				for (var i:int = 0; i < packetGetTopLevelInPresent.players.length; i++)
				{
					var playerInfo:LobbyPlayerInfo = packetGetTopLevelInPresent.players[i] as LobbyPlayerInfo;
					if (playerInfo != null)
					{
						pos++;
						topItem = new PresentTopItem();
						topItem.x = 0;
						topItem.y = i * 31;
						
						topItem.init(playerInfo, topConfig.getRewardIntervalAtIndex(i));
						
						_contentScrollBar.addChild(topItem);
					}
				}
				
				pos++;
				topItemEx = new PresentTopItemEx();
				topItemEx.x = 71;
				topItemEx.y = 5 + pos * 28 + 10;
				topItemEx.initEx("11-20:", topConfig.getRewardIntervalAtIndex(10));
				_contentScrollBar.addChild(topItemEx);
				
				pos++;
				topItemEx = new PresentTopItemEx();
				topItemEx.x = 71;
				topItemEx.y = 5 + pos * 28 + 20;
				topItemEx.initEx("21-50:", topConfig.getRewardIntervalAtIndex(11));
				_contentScrollBar.addChild(topItemEx);
				
				pos++;
				topItemEx = new PresentTopItemEx();
				topItemEx.x = 71;
				topItemEx.y = 5 + pos * 28 + 30;
				topItemEx.initEx("51-100:", topConfig.getRewardIntervalAtIndex(12));
				
				_contentScrollBar.addChild(topItemEx);
			}
			scrollbar.updateScroll();
			
		}
	}

}