package game.ui.mail.gui
{
	import components.scroll.VerScroll;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import game.data.vo.mail.MailInfo;
	import game.Game;
	import game.ui.components.ScrollbarEx;
	
	/**
	 * ...
	 * @author chuongth2
	 */
	public class MailContainer extends Sprite
	{
		public var contentMask:MovieClip;
		public var scroll:MovieClip;
		
		private var _contentScrollBar:MovieClip = new MovieClip();
		private var _arrMail:Array = [];
		private var _previousIndex:int = -1;
		
		private var scrollbar:VerScroll;
		
		public function MailContainer()
		{
			contentMask.visible = false;
			
			_contentScrollBar.x = 225;
			_contentScrollBar.y = 160;
			this.addChild(_contentScrollBar);
			
			scrollbar = new VerScroll(contentMask, _contentScrollBar, scroll);
		}
		
		public function setStatus(index:int, value:String):void
		{
			if (index >= 0 && index < _arrMail.length)
			{
				var ftCell:MailItem;
				if (_previousIndex != -1)
				{
					ftCell = _arrMail[_previousIndex] as MailItem;
					ftCell.status = MailItem.NORMAL;
				}
				_previousIndex = index;
				ftCell = _arrMail[index] as MailItem;
				ftCell.status = value;
			}
		
		}
		
		public function showMailBox():Boolean
		{
			_arrMail = [];
			while (_contentScrollBar.numChildren) _contentScrollBar.removeChildAt(0);
			var arrMailData:Array = Game.database.userdata.arrMailData;
			for (var i:int = 0; i < arrMailData.length; i++)
			{
				var mailInfo:MailInfo = arrMailData[i];
				if (mailInfo != null)
				{
					var ftMail:MailItem = new MailItem();
					ftMail.x = 0;
					ftMail.y = i * 52;
					
					ftMail.titleTf.text = mailInfo._strTitle;
					ftMail.mailIndex = mailInfo._nMailIndex;
					ftMail.mailType = mailInfo._nMailType;
					ftMail.mailState = mailInfo._nState;
					ftMail.setData(mailInfo);
					_contentScrollBar.addChild(ftMail);
					_arrMail.push(ftMail);
				}
			}
			scrollbar.updateScroll();
			
			return arrMailData.length > 0;
		}
		
		public function reset():void
		{
			_previousIndex = -1;
		}
	}

}