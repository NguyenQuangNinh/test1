package game.ui.arena 
{
	import core.util.FontUtil;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.text.TextField;
	import game.enum.Font;
	/**
	 * ...
	 * @author TrungLNM
	 */
	public class TimeInfo extends MovieClip
	{
		public var descTf:TextField;
		
		public function TimeInfo() 
		{
			/*if (stage)
				init();
			else addEventListener(Event.ADDED_TO_STAGE, init);	*/
			initUI();
		}
		
		/*private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			initUI();
		}*/
		
		private function initUI():void 
		{
			//set font
			FontUtil.setFont(descTf, Font.ARIAL, true);
			//descTf.text = "hello why you so shy?";
		}
		
		public function update(timeOpen:Array, timeClose:Array):void {
			//descTf.htmlText = desc;
			if(timeOpen.length == timeClose.length) {
				var contentStr:String = "";
				for (var i:int = 0; i < timeOpen.length; i ++) {
					contentStr += "\n" + (timeOpen[i] < 10 ? "0" + timeOpen[i] : timeOpen[i]) + "h"
										//+ ":" + (timeOpen[i + 1] < 10 ? "0" + timeOpen[i + 1] : timeOpen[i + 1])
										+ " -- " + (timeClose[i] < 10 ? "0" + timeClose[i] : timeClose[i]) + "h"
										//+ ":" + (timeClose[i + 1] < 10 ? "0" + timeClose[i + 1] : timeClose[i + 1]);
				}
				descTf.text = contentStr;
			}
		}
	}

}