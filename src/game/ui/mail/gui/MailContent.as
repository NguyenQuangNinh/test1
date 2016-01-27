package game.ui.mail.gui
{
	import core.util.FontUtil;
	import core.util.Utility;
	import flash.display.Sprite;
	import flash.text.TextField;
	import game.data.vo.mail.MailInfo;
	import game.enum.Font;
	import game.enum.ItemType;
	
	/**
	 * ...
	 * @author chuongth2
	 */
	public class MailContent extends Sprite
	{
		public var contentTf:TextField;
		public var titleTf:TextField;
		public var sendTimeTf:TextField;
		public var expireTimeTf:TextField;
		public var msgTf:TextField;
		private var _arrCellTemp:Array;
		
		public function MailContent()
		{
			_arrCellTemp = [];
			FontUtil.setFont(contentTf, Font.ARIAL, false);
			FontUtil.setFont(titleTf, Font.ARIAL, false);
			FontUtil.setFont(sendTimeTf, Font.ARIAL, false);
			FontUtil.setFont(expireTimeTf, Font.ARIAL, false);
			FontUtil.setFont(msgTf, Font.ARIAL, false);
			
			msgTf.visible = false;
		}
		
		public function reset():void
		{
			msgTf.visible = false;
			contentTf.text = "";
			titleTf.text = "";
			sendTimeTf.text = "";
			expireTimeTf.text = "";
			for each (var cell:MailAttackment in _arrCellTemp)
			{
				if (cell != null)
				{
					cell.destroy();
					this.removeChild(cell);
					cell = null;
				}
			}
			_arrCellTemp = [];
		}
		
		public function initAttackment(arrAttackment:Array):void
		{
			for (var i:int = 0; i < arrAttackment.length; i++)
			{
				var cell:MailAttackment = new MailAttackment();
				cell.init(arrAttackment[i].id, arrAttackment[i].type, arrAttackment[i].quantity);
				cell.x = i * 75 + 685;
				cell.y = 420;
				_arrCellTemp.push(cell);
				this.addChild(cell);	
			}
		}
		
		public function showMailDetail(mailInfo:MailInfo):void
		{
			if (mailInfo == null)
				return;
			titleTf.text = mailInfo._strTitle;
			contentTf.text = mailInfo._strMsg;
			sendTimeTf.text = "Gửi ngày: " + Utility.formatTimeEx("DD-MM-YYYY", mailInfo._strSendTime);
			expireTimeTf.text = "Hết hạn: " + Utility.formatTimeEx("DD-MM-YYYY", mailInfo._strExpireTime);
			msgTf.visible = mailInfo._nState == MailItem.MAIL_STATUS_RECEIVED;
				
			initAttackment(mailInfo._arrAttachment);
		}
	}

}