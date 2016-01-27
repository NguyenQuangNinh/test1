package game.utility 
{
	//import core.util.Utility;
	import flash.events.Event;
	import flash.external.ExternalInterface;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.utils.getTimer;
	/**
	 * ...
	 * @author ...
	 */
	public class Tracker 
	{
		private var ssid:String = "";
		private var timestamp:int = 0;
		private var processID:int = 0;
		private var url:String = "";
		
		public function Tracker(ssid:String, processID:int = 0, url:String = "", timestamp:int = -1) {
			this.timestamp = (timestamp == -1) ? getTimer() : timestamp;
			this.ssid = ssid;
			this.processID = processID;
			this.url = url;
		}
		
		public function getTimestamp():int { return timestamp; }
		
		public function track(step:int, description:String, isNewUser:int = 0):void
		{
			if(url == "") return;

			var current:int = getTimer();
			var delta:int = current - timestamp;
			timestamp = current;
			
			var variables:URLVariables = new URLVariables();
			variables.productname = "VLBD";
			variables.userid = ssid;
			variables.step_number = step;
			variables.unixtime = delta;
			variables.new_user = isNewUser;
			variables.progressid = processID;
			//variables.description = description;
			//
			//var m:String = "";
			//for (var key:String in variables) {
				//m += key + ": " + variables[key] + ", ";
			//}
			//
			//Utility.log(m);
			
			var request:URLRequest = new URLRequest(url);
			request.data = variables;
			request.method = URLRequestMethod.POST;
			
			if(ExternalInterface.available)
			{
				var loader:URLLoader = new URLLoader();
				loader.addEventListener(Event.COMPLETE, receiveHandler);
				if (url) loader.load(request);
			}
		}
		
		private function receiveHandler(e:Event):void 
		{
			//Utility.log(e.target.data);
		}
	}

}