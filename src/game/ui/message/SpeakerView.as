package game.ui.message 
{
	import flash.display.MovieClip;
	import flash.utils.Dictionary;
	
	/**
	 * ...
	 * @author MaiPTT
	 */
	public class SpeakerView extends MovieClip 
	{
		public var movUser		:SpeakerItem;
		public var movSystem	:SpeakerItem;
		
		public function SpeakerView() {
			movUser = new SpeakerItem();
			movUser.x = 440;
			movUser.y = 25;
			addChild(movUser);
			
			movSystem = new SpeakerItem();
			movSystem.x = 440;
			movSystem.y = 55;
			addChild(movSystem);
		}
		
		public function showAnnouncement(type:int, userName:String, message:String, highPriority:Boolean, repeat:int):void {
			switch(type) {
				case 0:
					movSystem.setContent(type, userName, message, highPriority, repeat);
					break;
					
				case 1:
				case 2:
					movUser.setContent(type, userName, message, highPriority, repeat);
					break;
			}
		}
		
	}

}