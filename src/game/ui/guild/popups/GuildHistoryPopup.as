package game.ui.guild.popups 
{
	import components.popups.OKCancelPopup;
	import game.Game;
	import game.net.lobby.LobbyRequestType;
	import game.net.RequestPacket;
	import game.ui.guild.popups.guild_log.LogList;
	/**
	 * ...
	 * @author vu anh
	 */
	public class GuildHistoryPopup extends OKCancelPopup
	{
		public var logList:LogList;
		
		public function GuildHistoryPopup() 
		{
			
		}
		
		override public function show(callback:Function = null, title:String = "", msg:String = "", data:Object = null, isHideCancelBtn:Boolean = false):void
		{
			super.show(callback, title, msg, data);
			Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.GU_GET_ACTION_LOG));
		}
	}

}