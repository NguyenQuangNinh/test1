package game.ui.dialog
{
	import components.scroll.VerScroll;
	import core.util.FontUtil;
	import core.util.TextFieldUtil;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFormatAlign;
	import game.data.xml.DataType;
	import game.data.xml.MessageXML;
	import game.enum.Font;
	import game.Game;
	import game.ui.components.ScrollBar;
	import game.ui.message.MessageID;
	
	import game.ui.dialog.dialogs.Dialog;
	
	public class DialogHelpTuuLau extends Dialog
	{
		public var btnClose:SimpleButton;
		public var maskMovie:MovieClip;
		public var contentMovie:MovieClip;
		public var scrollbar:MovieClip;
		public var vScroller:VerScroll;
		
		public function DialogHelpTuuLau()
		{
			btnClose.addEventListener(MouseEvent.CLICK, btnClose_onClicked);
			
			vScroller = new VerScroll(maskMovie, contentMovie, scrollbar);
			contentMovie.x = maskMovie.x;
			contentMovie.y = maskMovie.y;
			
			var glow:GlowFilter = new GlowFilter(0x663300, 1, 2, 2);
			var contentTf:TextField = TextFieldUtil.createTextfield(Font.ARIAL, 15, maskMovie.width - 5, maskMovie.height * 6.5, 0x000000, true, TextFormatAlign.LEFT, [glow]);
			contentTf.multiline = true;
			contentTf.wordWrap = true;
			var messageXML:MessageXML = Game.database.gamedata.getData(DataType.MESSAGE, MessageID.TUU_LAU_CHIEN_GUIDE) as MessageXML;
			contentTf.htmlText = messageXML.content;
			FontUtil.setFont(contentTf, Font.ARIAL);
			contentMovie.addChild(contentTf);
			
			vScroller.updateScroll(contentMovie.height + 10);
		}
		
		protected function btnClose_onClicked(event:MouseEvent):void
		{
			close();
		}
		
		override public function get height():Number 
		{
			return maskMovie.height * 1.5;
		}
	}
}