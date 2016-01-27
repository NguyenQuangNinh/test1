package game.utility 
{
	import flash.events.EventDispatcher;
	import game.enum.NotifyType;
	/**
	 * ...
	 * @author TrungLNM
	 */
	public class NotifyManager extends EventDispatcher
	{
		private static var _instance	:NotifyManager;
		
		private function NotifyManager() 
		{
			
		}
		
		public static function getInstance():NotifyManager {
			if (_instance == null)
				_instance = new NotifyManager();
			return _instance;
		}
		
		public function checkNotify(type:int):void {
			switch(type) {
				case NotifyType.NOTIFY_ARENA_1VS1MM_OPEN:
					
					break;
			}
		}
	}

}