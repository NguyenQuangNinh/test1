package components.popups 
{
	import flash.text.TextField;
	/**
	 * ...
	 * @author 
	 */
	public class MessagePopup extends BasePopup
	{
		
		public var titleTf:TextField;
		public var messageTf:TextField;
		
		public function MessagePopup() 
		{
			super();
		}
		
		override public function show(callback:Function = null, title:String = "", msg:String = ""):void
		{
			super.show(callback);
			if (title == "") title = "Thông báo";
			titleTf.text = title;
			messageTf.text = msg;
		}
		
	}

}