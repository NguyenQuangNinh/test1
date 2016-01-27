package game.ui.mail
{
	import flash.events.Event;
	
	import core.Manager;
	import core.display.ModuleBase;
	import core.event.EventEx;
	
	import game.Game;
	import game.data.model.UserData;
	import game.data.vo.mail.MailInfo;
	import game.net.IntResponsePacket;
	import game.net.ResponsePacket;
	import game.net.Server;
	import game.net.lobby.LobbyRequestType;
	import game.net.lobby.LobbyResponseType;
	import game.net.lobby.request.RequestInboxMail;
	import game.net.lobby.request.RequestReadMail;
	import game.net.lobby.request.RequestReceiveMailAttachment;
	import game.ui.ModuleID;
	import game.ui.hud.HUDModule;
	import game.ui.mail.gui.MailItem;
	
	/**
	 * ...
	 * @author ...
	 */
	public class MailModule extends ModuleBase
	{
		
		public static const RECIEVE_MAIL_ATTACKMENT:String = "recieve_Mail_Attackment";
		//public static const REQUEST_MAIL_BOX:String 		= "requestMailBox";
		public static const CLOSE_MAIL_BOX_VIEW:String = "close_MailBox_View";
		
		override protected function createView():void
		{
			super.createView();
			baseView = new MailView();
			
			baseView.addEventListener(RECIEVE_MAIL_ATTACKMENT, requestAttackment);
			//view.addEventListener(REQUEST_MAIL_BOX, requestMailBoxHandler);
			baseView.addEventListener(CLOSE_MAIL_BOX_VIEW, closeMailBoxHandler);
			baseView.addEventListener(MailItem.VIEW_MAIL_INFO, onViewMailInfo);
		}
		
		private function requestAttackment(e:EventEx):void
		{
			var mailInfo:MailInfo = e.data as MailInfo;
			if (mailInfo != null)
			{
				//request nhan reward
				if (mailInfo._nState == MailItem.MAIL_STATUS_RECEIVED)
					Manager.display.showMessage("Đã nhận item rồi."); //change by create message content in message.xml, load dynamic
				else
				{
					MailView(baseView).btnAttackment.mouseEnabled = false;
					Game.network.lobby.sendPacket(new RequestReceiveMailAttachment(LobbyRequestType.MAIL_RECEIVE_ATTACHMENT, mailInfo._nMailIndex, mailInfo._nMailType));
				}
			}
		}
		
		private function onViewMailInfo(e:EventEx):void
		{
			var mailItem:MailItem = e.data as MailItem;
			if (mailItem != null && mailItem.mailIndex >= 0)
			{
				MailView(baseView).showMailContent(mailItem.mailIndex);
				//request read mail
				Game.network.lobby.sendPacket(new RequestReadMail(LobbyRequestType.MAIL_READ_MAIL, mailItem.mailIndex, mailItem.mailType));
			}
		}
		
		private function closeMailBoxHandler(e:Event):void
		{
			var hudModule:HUDModule = Manager.module.getModuleByID(ModuleID.HUD) as HUDModule;
			if (hudModule != null)
			{
				hudModule.updateHUDButtonStatus(ModuleID.MAIL_BOX, false);
			}
		}
		
		public function MailModule()
		{
		
		}
		
		override protected function preTransitionIn():void
		{
			super.preTransitionIn();
			Game.database.userdata.addEventListener(UserData.GET_MAIL_BOX, onReceiveMail);
			Game.network.lobby.sendPacket(new RequestInboxMail(LobbyRequestType.MAIL_GET_MAIL, 0, 10));
		}
		
		override protected function onTransitionInComplete():void
		{
			super.onTransitionInComplete();
			Game.network.lobby.addEventListener(Server.SERVER_DATA, onLobbyServerData);
		}
		
		override protected function onTransitionOutComplete():void
		{
			super.onTransitionOutComplete();
			Game.network.lobby.removeEventListener(Server.SERVER_DATA, onLobbyServerData);
			Game.database.userdata.removeEventListener(UserData.GET_MAIL_BOX, onReceiveMail);
		}
		
		private function onReceiveMail(e:Event):void
		{
			MailView(baseView).showMailBox();
		}
		
		private function onLobbyServerData(e:EventEx):void
		{
			var packet:ResponsePacket = ResponsePacket(e.data);
			switch (packet.type)
			{
				case LobbyResponseType.MAIL_DELETE_MAIL_RESULT: 
					onResponseDeleteMail(packet as IntResponsePacket);
					break;
			
			}
		}
		
		private function onResponseDeleteMail(intResponsePacket:IntResponsePacket):void
		{
			switch (intResponsePacket.value)
			{
				case 0: //thanh cong
					Manager.display.showMessage("Xóa thư thành công");
					break;
				case 1: //loi
					//Manager.display.showMessage("Xóa thư bị lỗi");
					break;
			}
		}
	}

}