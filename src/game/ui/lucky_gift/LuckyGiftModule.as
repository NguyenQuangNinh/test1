package game.ui.lucky_gift
{
	import com.adobe.utils.StringUtil;
	import core.display.ModuleBase;
	import core.event.EventEx;
	import core.Manager;
	import core.util.Utility;
	import flash.events.Event;
	import game.data.model.UserData;
	import game.Game;
	import game.net.lobby.LobbyRequestType;
	import game.net.lobby.LobbyResponseType;
	import game.net.lobby.request.RequestLuckyGift;
	import game.net.lobby.response.ResponseRequestLuckyGift;
	import game.net.RequestPacket;
	import game.net.ResponsePacket;
	import game.net.Server;
	import game.ui.hud.HUDModule;
	import game.ui.ModuleID;
	
	/**
	 * ...
	 * @author chuongth2
	 */
	public class LuckyGiftModule extends ModuleBase
	{
		
		public static const REQUEST_REWARD_LUCKY_GIFT:String = "request_Reward_LuckyGift";
		public static const CLOSE_LUCKY_GIFT_VIEW:String = "close_LuckyGift_View";
		
		public function LuckyGiftModule()
		{
		
		}
		
		override protected function createView():void
		{
			super.createView();
			baseView = new LuckyGiftView();
			baseView.addEventListener(REQUEST_REWARD_LUCKY_GIFT, luckyGiftHandler);
			baseView.addEventListener(CLOSE_LUCKY_GIFT_VIEW, closeLuckyGiftHandler);
		
		}
		
		private function closeLuckyGiftHandler(e:Event):void
		{
			var hudModule : HUDModule = Manager.module.getModuleByID(ModuleID.HUD) as HUDModule;
			if (hudModule != null) {
				hudModule.updateHUDButtonStatus(ModuleID.LUCKY_GIFT, false);
			}
			
			//Manager.display.hideModule(ModuleID.LUCKY_GIFT);
		}
		
		private function luckyGiftHandler(e:Event):void
		{
			Game.network.lobby.sendPacket(new RequestLuckyGift(LobbyRequestType.REQUEST_LUCKY_GIFT, int(StringUtil.trim(LuckyGiftView(baseView).spinNumTf.text))));
		}
		
		override protected function preTransitionIn():void {
			super.preTransitionIn();
			LuckyGiftView(baseView).init();
		}
		
		override protected function onTransitionInComplete():void
		{
			super.onTransitionInComplete();
			Game.network.lobby.addEventListener(Server.SERVER_DATA, onLobbyServerData);
			Game.database.userdata.addEventListener(UserData.UPDATE_PLAYER_INFO, onUpdatePlayerInfo);
		}
		
		override protected function onTransitionOutComplete():void
		{
			super.onTransitionOutComplete();
			Game.network.lobby.removeEventListener(Server.SERVER_DATA, onLobbyServerData);
			Game.database.userdata.removeEventListener(UserData.UPDATE_PLAYER_INFO, onUpdatePlayerInfo);
		}
		
		private function onLobbyServerData(e:EventEx):void
		{
			var packet:ResponsePacket = ResponsePacket(e.data);
			switch (packet.type)
			{
				case LobbyResponseType.LUCKY_GIFT_RESULT: 
					onRequestLuckyGiftResponse(packet as ResponseRequestLuckyGift);
					break;
			}
		}
		
		private function onUpdatePlayerInfo(e:Event):void 
		{
			LuckyGiftView(baseView).init();
		}
		
		private function onRequestLuckyGiftResponse(responsePacket:ResponseRequestLuckyGift):void
		{
			Utility.log("onRequestLuckyGiftResponse : " + responsePacket._errorCode);
			switch (responsePacket._errorCode)
			{
				case 0: //success
				{
					Utility.log("onRequestLuckyGiftResponse " + responsePacket._indexRewardIDs);
					Game.database.userdata.luckyGiftTime -= responsePacket._indexRewardIDs.length;
					LuckyGiftView(baseView).updateLuckyGiftView(responsePacket._indexRewardIDs);
					break;
				}
				case 1: //fail
					break;
				case 2: //khong du so lan quay
					Manager.display.showMessageID(56);
					break;
			}
		}
	}

}