package game.ui.message 
{
	import core.display.ModuleBase;
	
	/**
	 * ...
	 * @author MaiPTT
	 */
	public class MessageModule extends ModuleBase 
	{
		
		public function MessageModule() {
			
		}
		
		override protected function createView():void 
		{
			baseView = new MessageView();
		}
		
		public function showMessageID(messageID:int):void {
			if (baseView) {
				(MessageView)(baseView).messageID = messageID;
			}
		}
		
		public function showMessage(message:String):void
		{
			if(baseView != null)
			{
				MessageView(baseView).addMessage(message);
			}
		}
	}

}