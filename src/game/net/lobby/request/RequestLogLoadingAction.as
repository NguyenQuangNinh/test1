package game.net.lobby.request 
{
	import core.util.ByteArrayEx;
	import flash.utils.ByteArray;
	import game.net.lobby.LobbyRequestType;
	import game.net.RequestPacket;
	/**
	 * ...
	 * @author TrungLNM
	 */
	public class RequestLogLoadingAction extends RequestPacket
	{
		//LoadID: 1 – startload, 2—done load
		//StateID: 1 – Lobby, ModeID (dành cho ingame, vd: AHA, Hoa sơn luận kiếm, …)
		
		public var actionLog:int;
		public var stateLog:int;
		
		public function RequestLogLoadingAction(action:int, state:int) 
		{
			super(LobbyRequestType.LOG_LOADING_ACTION);
			actionLog = action;
			stateLog = state;
		}
			
		override public function encode():ByteArray 
		{
			var data:ByteArrayEx = new ByteArrayEx();
			data.writeInt(actionLog);
			data.writeInt(stateLog);			
			return data;
		}
	}

}