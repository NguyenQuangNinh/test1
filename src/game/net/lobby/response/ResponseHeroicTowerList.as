package game.net.lobby.response
{
	import core.util.Utility;
	
	import flash.utils.ByteArray;
	
	import game.net.ResponsePacket;
	import game.ui.challenge_center.HeroicTowerData;
	
	public class ResponseHeroicTowerList extends ResponsePacket
	{
		public var towers:Array = [];
		public var isDead:Boolean;
		public var itemActivated:Boolean;
		
		override public function decode(data:ByteArray):void
		{
			var size:int = data.readInt();
			var towerData:HeroicTowerData;
			var ID:int;
			for(var i:int = 0; i < size; ++i)
			{
				ID = data.readInt();
				towerData = new HeroicTowerData();
				towerData.setXMLID(ID);
				towerData.setCurrentFloor(data.readInt());
				towerData.setMaxFloor(data.readInt());
				Utility.log("heroic tower ID=" + ID + " peakFloor=" + towerData.getMaxFloor() + " currentFloor=" + towerData.getCurrentFloor());
				towers[ID] = towerData;
			}
			isDead = data.readBoolean();
			itemActivated = data.readBoolean();
		}
	}
}