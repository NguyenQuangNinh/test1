package game.net.lobby.response 
{
	import flash.utils.ByteArray;
	import game.data.vo.formation_type.FormationTypeInfo;
	import game.net.ResponsePacket;
	/**
	 * ...
	 * @author anhtinh
	 */
	public class ResponseListFormationType extends ResponsePacket
	{
		public var formationTypes : Array; 		// FormationTypeInfo array
		
		public function ResponseListFormationType()
		{
			formationTypes = [];
		}
		override public function decode(data:ByteArray):void
		{
			while (data.bytesAvailable >= 8) 	// 2 so int
			{
				var formationTypeInfo : FormationTypeInfo = new FormationTypeInfo();
				formationTypeInfo.id = data.readInt();
				formationTypeInfo.level = data.readInt();
				formationTypes.push(formationTypeInfo);
			}
		}
		
	}

}