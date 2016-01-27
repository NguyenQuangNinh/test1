package game.data.vo.flashvar 
{
	

	/**
	 * ...
	 * @author TrungLNM
	 */
	public class FlashVar 
	{
		public var rootURL:String = "";
		public var user	:String = "";
		public var userID:String = "";
		public var srcSite:String = "";// noi embed toonline.swf
		public var key	:String = "";
		public var pid	:String = "";
		public var time	:String = "";
		public var rand	:String = "";
		public var server:String = "";
		public var version:String = "";
		public var debug:Boolean = false;
		public var zmCode:String = "";
		public var channel:String = "";
		
		public function parse(params:Object):void
		{
			if(params != null)
			{
				if(params.user) 	user 	= params.user;
				if(params.userID) 	userID 	= params.userID;
				if(params.src) 		srcSite	= params.src;
				if(params.mode) 	debug 	= Boolean(int(params.mode));
				if(params.pid) 		pid 	= params.pid;
				if(params.time) 	time 	= params.time;
				if(params.rand) 	rand 	= params.rand;
				if(params.server) 	server = params.server;
				if(params.rooturl) 	rootURL = params.rooturl;
				if(params.version) 	version = params.version;
				if(params.channel) 	channel = params.channel;
				if(params.key) 		key 	= params.key;
				//Utility.log(key);
			}
		}
	}
}