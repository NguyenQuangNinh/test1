package core.service 
{
	import core.util.Utility;
	import flash.events.Event;
	import flash.external.ExternalInterface;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import game.data.Database;
	import game.Game;
	/**
	 * ...
	 * @author anhpnh2
	 */
	public class ServiceVLCBBase 
	{
		private var url:String = "";
		private var appData:Database = null;
		
		private var localServer:String = "";
		
		public function ServiceVLCBBase(_url:String) 
		{
			url = _url;
		}

		
		private function sendRequest(msg:String, nType:int):void
		{
			if (url == "") return;
			
            var variables:URLVariables = new URLVariables();
            variables.nType = nType;
            variables.strContent = msg;
			
            var request:URLRequest = new URLRequest(url);
            request.data = variables;
            request.method = URLRequestMethod.POST;
			
			if(ExternalInterface.available)
			{
				new URLLoader(request);
			} else
			{
				//var loader:URLLoader = new URLLoader();
				//loader.addEventListener(Event.COMPLETE, receiveHandler);
				//loader.load(request);
			}
		}
		
		private function receiveHandler(e:Event):void 
		{
			Utility.log("receiveTracking : "+e.toString());
		}
		
		public function requestTracking(idTracking:String, desc:String, nType:int = 1, data:String = null):void
		{
			//if (url == "")
			//	return;
			if (appData == null)
			{
				appData = Game.database;
				localServer = "http://adobe.com";
				if(ExternalInterface.available) localServer = ExternalInterface.call("window.location.href.toString");
				var urlPattern:RegExp = new RegExp("http://(www|).*?\.(com|org|net|vn|html)","i");
				var found:Object =  urlPattern.exec(localServer);
				if(found!=null&&found[0]!=null)
					localServer = found[0];
			}
			var message:String = appData.flashVar.user + "\t" + appData.userdata.level + "\t" + appData.flashVar.server + "\t" + localServer + "\t" + idTracking + "\t" + desc;
			if (data != null)
				message = message + "\t" + data;
			Utility.log("sendTutorialTrackingLog : "+message);
			sendRequest(message,nType);
		}
		
	}

}