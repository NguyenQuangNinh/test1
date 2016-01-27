package game.net.lobby.request
{
	import flash.utils.ByteArray;
	import game.net.RequestPacket;
	
	/**
	 * ...
	 * @author chuongth2
	 */
	public class RequestBossMissionInfo extends RequestPacket
	{
		public var missionID:int;
		public var bActiveQuickJoin:Boolean = false;
			
		public function RequestBossMissionInfo(type:int, missionID:int, bActiveQuickJoin:Boolean = false)
		{
			super(type);
			this.missionID = missionID;
			this.bActiveQuickJoin = bActiveQuickJoin;
		}
		
		override public function encode():ByteArray
		{
			var data:ByteArray = super.encode();
			data.writeInt(missionID);
			data.writeBoolean(bActiveQuickJoin);
			return data;
		}
	}

}