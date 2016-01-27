package game.ui.activity_point {
	import core.display.ModuleBase;
	import core.event.EventEx;
	import core.Manager;
	import game.Game;
	import game.net.IntResponsePacket;
	import game.net.lobby.LobbyRequestType;
	import game.net.lobby.LobbyResponseType;
	import game.net.lobby.response.ResponseGetActivityInfo;
	import game.net.lobby.response.ResponseGuOwnGuildInfo;
	import game.net.RequestPacket;
	import game.net.ResponsePacket;
	import game.net.Server;
	/**
	 * ...
	 * @author vu anh
	 */
	public class ActivityPointModule extends ModuleBase
	{
		public var view:ActivityPointView;
		public function ActivityPointModule() 
		{
		}
		
		override protected function createView():void 
		{
			super.createView();
			baseView = new ActivityPointView();
			view = baseView as ActivityPointView;
		}
		
		override protected function preTransitionIn():void 
		{
			super.preTransitionIn();
			Game.network.lobby.addEventListener(Server.SERVER_DATA, onServerDataResponseHandler);
			Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.AC_GET_ACTIVITY_INFO));
		}
		
		override protected function preTransitionOut():void {
			super.preTransitionOut();
			Game.network.lobby.removeEventListener(Server.SERVER_DATA, onServerDataResponseHandler);
		}
		
		private function onServerDataResponseHandler(e:EventEx):void 
		{
			var packet:ResponsePacket = e.data as ResponsePacket;
			var errorCode:int;
			var message:String;
			switch(packet.type) 
			{
				case LobbyResponseType.GET_ACTIVITY_INFO:
					var activityInfo:ResponseGetActivityInfo = packet as ResponseGetActivityInfo;
					
					ActivityItemInfo(view.actionList.infoList[0]).usedTime = activityInfo.nFinishDailyQuestCount;
					ActivityItemInfo(view.actionList.infoList[1]).usedTime = activityInfo.nFinishTransporterQuestCount;
					ActivityItemInfo(view.actionList.infoList[2]).usedTime = activityInfo.nFinishCampaignCount;
					ActivityItemInfo(view.actionList.infoList[3]).usedTime = activityInfo.nFinishPVP1vs1Count;
					ActivityItemInfo(view.actionList.infoList[4]).usedTime = activityInfo.nFinishPVP3vs3MMCount;
					ActivityItemInfo(view.actionList.infoList[5]).usedTime = activityInfo.nFinishPVP1vs1MMCount;
					ActivityItemInfo(view.actionList.infoList[6]).usedTime = activityInfo.nFinishHeroicCount;
					ActivityItemInfo(view.actionList.infoList[7]).usedTime = activityInfo.nFinishGlobalBossCount;
					ActivityItemInfo(view.actionList.infoList[8]).usedTime = activityInfo.nFinishTowerCount;
					ActivityItemInfo(view.actionList.infoList[9]).usedTime = activityInfo.nFinishTransmitExpCount;
					ActivityItemInfo(view.actionList.infoList[10]).usedTime = activityInfo.nFinishAlchemyCount;
					ActivityItemInfo(view.actionList.infoList[11]).usedTime = activityInfo.nFinishSoulCount;
					ActivityItemInfo(view.actionList.infoList[12]).usedTime = activityInfo.nFinishUpgradeSkillCount;
					
					view.actionPointTf.text = activityInfo.nActivityPoint.toString();
					view.actionList.updateActionList();
					view.rewardCon.updateReward(activityInfo.nActivityPoint, activityInfo.nRewardIndexs);
					break;
				case LobbyResponseType.GU_GET_ACTIVITY_REWARD:
					errorCode = IntResponsePacket(packet).value;
					switch (errorCode)
					{
						case 0:
							message = "Nhận thưởng thành công";
							Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.GET_PLAYER_INFO));
							Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.AC_GET_ACTIVITY_INFO));
							break;
						case 1:
							message = "Nhận thưởng thất bại";
							break;
						case 2:
							message = "Nhận thưởng thất bại. Hành trang của bạn đã đầy";
							break;
						default:
							message = "Nhận thưởng thất bại";
					}
					Manager.display.showMessage(message);
					break;
			}
			
		}

	}
}