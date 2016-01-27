package game.ui.mail
{

	import core.util.Utility;

	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import core.Manager;
	import core.display.ViewBase;
	import core.display.layer.Layer;
	import core.event.EventEx;
	import core.util.FontUtil;
	
	import game.Game;
	import game.data.vo.mail.MailInfo;
	import game.enum.ErrorCode;
	import game.enum.Font;
	import game.enum.GameConfigID;
	import game.net.IntRequestPacket;
	import game.net.IntResponsePacket;
	import game.net.lobby.LobbyRequestType;
	import game.net.lobby.LobbyResponseType;
	import game.net.lobby.request.RequestReceiveMailAttachment;
	import game.ui.dialog.DialogID;
	import game.ui.dialog.dialogs.YesNo;
	import game.ui.mail.gui.MailContainer;
	import game.ui.mail.gui.MailContent;
	import game.ui.mail.gui.MailItem;
	import game.utility.UtilityUI;
	
	/**
	 * ...
	 * @author ...
	 */
	public class MailView extends ViewBase
	{
		private var closeBtn:SimpleButton;
		
		public var btnAttackment:SimpleButton;
		public var mailContainer:MailContainer;
		public var mailContent:MailContent;
		public var msgTf:TextField;
		public var maxMailTf:TextField;
		public var currentMailTf:TextField;
		public var btnClaimAndDelete:SimpleButton;
		
		private var _currentMailIndex:int = -1;
		private var deleteMailAfterClaimItem:Boolean;
		
		public function MailView()
		{
			FontUtil.setFont(msgTf, Font.ARIAL, false);
			FontUtil.setFont(maxMailTf, Font.ARIAL, false);
			FontUtil.setFont(currentMailTf, Font.ARIAL, false);
			
			closeBtn = UtilityUI.getComponent(UtilityUI.CLOSE_BTN) as SimpleButton;
			
			if (closeBtn != null)
			{
				closeBtn.x = 985;
				closeBtn.y = 113;
				addChild(closeBtn);
				closeBtn.addEventListener(MouseEvent.CLICK, closeHandler);
			}
			btnAttackment.addEventListener(MouseEvent.CLICK, onMouseClick);
			btnClaimAndDelete.addEventListener(MouseEvent.CLICK, onMouseClick);
			
			this.addChild(mailContainer);
			this.addChild(mailContent);
			
			btnAttackment.visible = false;
			btnClaimAndDelete.visible = false;
			
			var nMaxMailInbox:int = Game.database.gamedata.getConfigData(GameConfigID.MAX_MAIL_INBOX) as int;
			maxMailTf.text = nMaxMailInbox.toString();
			currentMailTf.text = "0";
			
			addEventListener(MailItem.DELETE, onMailItemDelete);
		}
		
		override protected function transitionInComplete():void
		{
			Game.network.lobby.registerPacketHandler(LobbyResponseType.MAIL_RECEIVE_ATTACHMENT_RESULT, onReceiveAttachmentResult);
			super.transitionInComplete();
		}
		
		override protected function transitionOutComplete():void
		{
			Game.network.lobby.unregisterPacketHandler(LobbyResponseType.MAIL_RECEIVE_ATTACHMENT_RESULT, onReceiveAttachmentResult);
			super.transitionOutComplete();
		}
		
		private function onReceiveAttachmentResult(packet:IntResponsePacket):void
		{
			Utility.log("onReceiveAttachmentResult: " + packet.value);
			switch(packet.value)
			{
				case ErrorCode.SUCCESS: //thanh cong
					if(deleteMailAfterClaimItem) {
						deleteMail(_currentMailIndex);
						deleteMailAfterClaimItem = false;
					}
					updateMailItem();
					Manager.display.showMessage("Nhận item thành công");
					break;
				case ErrorCode.FAIL: //loi
					Manager.display.showMessage("Nhận item bị lỗi");
					break;
				case ErrorCode.MAIL_CLAIM_ITEM_MAIL_EXPIRED: //mail da het han
					Manager.display.showMessage("Thư đã hết hạn.");
					break;
				case ErrorCode.FULL_UNIT_INVENTORY: //full dong doi
					Manager.display.showMessage("Đồng đội đã đầy. Không nhận được item.");
					break;
				case ErrorCode.FULL_ITEM_INVENTORY: //full thung do
					Manager.display.showMessage("Thùng đồ đã đầy. Không nhận được item.");
					break;
			}
		}
		
		protected function onMailItemDelete(event:Event):void
		{
			var mail:MailItem = event.target as MailItem;
			var mailInfo:MailInfo = mail.getData();
			if(mailInfo != null) {
				switch(mailInfo._nState)
				{
					case MailItem.MAIL_STATUS_DELETE:
						break;
					case MailItem.MAIL_STATUS_RECEIVED:
						deleteMail(mailInfo._nMailIndex);
						break;
					case MailItem.MAIL_STATUS_NEW:
					case MailItem.MAIL_STATUS_READ:
						var dialogData:Object = {};
						dialogData.index = mailInfo._nMailIndex;
						dialogData.title = "Xác nhận";
						dialogData.message = "Thư chứa vật phẩm chưa nhận, đại hiệp có chắc chắn muốn xóa không?";
						dialogData.option = YesNo.YES | YesNo.NO;
						Manager.display.showDialog(DialogID.YES_NO, onConfirmDeleteMail, null, dialogData, Layer.BLOCK_BLACK);
						break;
				}
			}
		}
		
		private function deleteMail(index:int):void	{
			Game.network.lobby.sendPacket(new IntRequestPacket(LobbyRequestType.MAIL_DELETE_MAIL, index));
		}
		
		private function onConfirmDeleteMail(data:Object):void {
			deleteMail(data.index);
		}
		
		private function onMouseClick(e:Event):void
		{
			switch(e.target)
			{
				case btnClaimAndDelete:
					deleteMailAfterClaimItem = true;
				case btnAttackment:
					claimItem();
					break;
			}
		}
		
		private function claimItem():void
		{
			var arrMailData:Array = Game.database.userdata.arrMailData;
			for (var i:int = 0; i < arrMailData.length; i++)
			{
				var mailInfo:MailInfo = arrMailData[i] as MailInfo;
				if (_currentMailIndex == mailInfo._nMailIndex)
				{
					Game.network.lobby.sendPacket(new RequestReceiveMailAttachment(LobbyRequestType.MAIL_RECEIVE_ATTACHMENT, mailInfo._nMailIndex, mailInfo._nMailType));
					break;
				}
			}
		}
		
		private function closeHandler(e:Event):void
		{
			this.dispatchEvent(new EventEx(MailModule.CLOSE_MAIL_BOX_VIEW));
		}
		
		public function showMailBox():void
		{
			reset();
			var arrMailData:Array = Game.database.userdata.arrMailData;
			currentMailTf.text = arrMailData.length.toString();
			//khong co mail thi hien thi thong bao
			msgTf.visible = !mailContainer.showMailBox();
		}
		
		public function showMailContent(mailIndex:int):void
		{
			_currentMailIndex = mailIndex;
			mailContainer.setStatus(mailIndex, MailItem.ACTIVE);
			var arrMailData:Array = Game.database.userdata.arrMailData;
			for (var i:int = 0; i < arrMailData.length; i++)
			{
				var mailInfo:MailInfo = arrMailData[i] as MailInfo;
				if (mailIndex == mailInfo._nMailIndex)
				{
					mailContainer.setStatus(i, MailItem.ACTIVE);
					mailContent.reset();
					btnAttackment.mouseEnabled = mailInfo._arrAttachment.length > 0 && mailInfo._nState != MailItem.MAIL_STATUS_RECEIVED;
					btnClaimAndDelete.visible = btnAttackment.visible = mailInfo._arrAttachment.length > 0 && mailInfo._nState != MailItem.MAIL_STATUS_RECEIVED;
					mailContent.showMailDetail(mailInfo);
					break;
				}
			}
		}
		
		public function reset():void
		{
			btnAttackment.mouseEnabled = false;
			_currentMailIndex = -1;
			mailContainer.reset();
			mailContent.reset();
		}
		
		public function updateMailItem():void
		{
			var arrMailData:Array = Game.database.userdata.arrMailData;			
			for (var i:int = 0; i < arrMailData.length; i++)
			{
				var mailInfo:MailInfo = arrMailData[i] as MailInfo;
				if (_currentMailIndex == mailInfo._nMailIndex)
				{
					mailInfo._nState = MailItem.MAIL_STATUS_RECEIVED;
					btnAttackment.mouseEnabled = mailInfo._arrAttachment.length > 0 && mailInfo._nState != MailItem.MAIL_STATUS_RECEIVED;
					btnClaimAndDelete.visible = btnAttackment.visible = mailInfo._arrAttachment.length > 0 && mailInfo._nState != MailItem.MAIL_STATUS_RECEIVED;
					mailContent.showMailDetail(mailInfo);
				}
			}
		}
	}
}