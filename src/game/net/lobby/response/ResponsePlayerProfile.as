package game.net.lobby.response
{
	import flash.utils.ByteArray;
	
	import core.util.ByteArrayEx;
	
	import game.net.ResponsePacket;
	import game.ui.player_profile.CharacterSimple;
	
	public class ResponsePlayerProfile extends ResponsePacket
	{
		public var playerID:int;
		public var playerLevel:int;
		public var playerName:String;
		public var totalPower:int;
		public var formationID:int;
		public var formationLevel:int;
		public var effects:Array = [];
		public var formations:Array = [];
		
		override public function decode(data:ByteArray):void
		{
			playerID = data.readInt();
			playerLevel = data.readInt();
			playerName = ByteArrayEx(data).readString();
			totalPower = data.readInt();
			formationID = data.readInt();
			formationLevel = data.readInt();
			var size:int = data.readInt();
			for(i = 0; i < size; ++i)
			{
				var effect:Object = {};
				effect.buffType = data.readInt();
				effect.buffValueType = data.readInt();
				effect.buffValue = data.readInt();
				var targetTypes:Array = [];
				effect.targetType = data.readInt();
				var targetSize:int = data.readInt();
				for(var j:int = 0; j < targetSize; ++j)
				{
					targetTypes.push(data.readInt());
				}
				effect.buffTargetTypes = targetTypes;
				effects.push(effect);
			}
			size = data.readInt();
			var character:CharacterSimple;
			var arr:Array = [];
			for(var i:int = 0; i < size; ++i)
			{
				var inventoryID:int = data.readInt();
				arr.push(inventoryID);
				if(inventoryID > -1)
				{
					character = new CharacterSimple();
					character.inventoryID = inventoryID;
					character.xmlID = data.readInt();
					character.sex = data.readByte();
					formations[i] = character;
				}
			}
		}
		
	}
}