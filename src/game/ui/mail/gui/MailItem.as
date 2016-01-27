package game.ui.mail.gui
{
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import core.event.EventEx;
	import core.util.FontUtil;
	
	import game.data.vo.mail.MailInfo;
	import game.enum.Font;
	
	/**
	 * ...
	 * @author chuongth2
	 */
	public class MailItem extends MovieClip
	{
		//enum
		public static const NORMAL:String = "normal";
		public static const ACTIVE:String = "active";
		
		public static const MAIL_STATUS_NEW:int = 0;
		public static const MAIL_STATUS_READ:int = 1;
		public static const MAIL_STATUS_DELETE:int = 2;
		public static const MAIL_STATUS_RECEIVED:int = 3;
		
		//event
		public static const VIEW_MAIL_INFO:String = "view_mail_info";
		public static const DELETE:String = "delete";
		
		public var titleTf:TextField;
		public var selectMail:MovieClip;
		public var mailNew:MovieClip;
		public var mailIcon:MailItemIcon;
		public var btnDelete:SimpleButton;
		
		private var _mailIndex:int;
		private var _mailType:int;
		private var data:MailInfo;
		private var _mailState:int;
		private var _status:String;
		
		public function MailItem()
		{
			status = NORMAL;
			selectMail.buttonMode = true;
			mailNew.visible = false;
			FontUtil.setFont(titleTf, Font.ARIAL);
			this.addEventListener(MouseEvent.CLICK, onViewMail);
			btnDelete.addEventListener(MouseEvent.CLICK, onDeleteMail);
			btnDelete.visible = false;
		}
		
		private function onDeleteMail(e:Event):void
		{
			if (_mailIndex >= 0) {
				dispatchEvent(new Event(DELETE, true));
			}
		}
		
		private function onViewMail(e:MouseEvent):void
		{
			this.dispatchEvent(new EventEx(VIEW_MAIL_INFO, this, true));
		}
		
		public function setData(data:MailInfo):void { this.data = data; }
		public function getData():MailInfo { return data; }
		
		public function set status(value:String):void
		{
			switch (value)
			{
				case NORMAL: 
				case ACTIVE: 
					this.gotoAndStop(value);
					break;
				default: 
					this.gotoAndStop(NORMAL);
			}
			_status = value;
			btnDelete.visible = false;
			if (_status == ACTIVE)
			{
				btnDelete.visible = true;
				mailNew.visible = false;
				mailIcon.setStatus(MailItemIcon.READED);
			}
		}
		
		public function set mailState(value:int):void
		{
			_mailState = value;
			
			if (_mailState == MAIL_STATUS_NEW)
			{
				mailNew.visible = true;
				mailIcon.setStatus(MailItemIcon.NEW);
			}
			else
				mailIcon.setStatus(MailItemIcon.READED);
		}
		
		public function get mailIndex():int
		{
			return _mailIndex;
		}
		
		public function set mailIndex(value:int):void
		{
			_mailIndex = value;
		}
		
		public function get mailType():int
		{
			return _mailType;
		}
		
		public function set mailType(value:int):void
		{
			_mailType = value;
		}
	
	}

}