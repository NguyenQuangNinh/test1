package game.ui.dialog.dialogs 
{
	import core.util.FontUtil;
	import flash.events.Event;
	import flash.text.TextField;
	import game.enum.Font;
	/**
	 * ...
	 * @author TrungLNM
	 */
	public class PassConfirm extends Dialog
	{
		public var messageTf: TextField;	
		public var passTf: TextField;	
		
		public function PassConfirm() 
		{
			if (stage) 
				init();
			else addEventListener(Event.ADDED_TO_STAGE, init);	
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			initUI();
		}
		
		private function initUI():void 
		{
			//set font
			FontUtil.setFont(messageTf, Font.ARIAL, true);
			FontUtil.setFont(passTf, Font.ARIAL, true);					
		}
		
		override public function onShow():void 
		{
			super.onShow();
			messageTf.text = " room require password. Please input password to join ";
			passTf.text = "";
		}
		
		override protected function onOK(event:Event = null):void 
		{
			if(data)
				data.pass = passTf.text;
			super.onOK(event);
		}
	}

}