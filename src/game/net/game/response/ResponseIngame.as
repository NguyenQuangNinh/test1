package game.net.game.response 
{
	import core.util.Enum;
	import core.util.Utility;
	
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	import game.net.ResponsePacket;
	import game.net.game.ingame.IngamePacket;
	import game.net.game.ingame.ResponseAddEffect;
	import game.net.game.ingame.ResponseAddStatus;
	import game.net.game.ingame.ResponseByte;
	import game.net.game.ingame.ResponseCastSkill;
	import game.net.game.ingame.ResponseCreateBullet;
	import game.net.game.ingame.ResponseCreateObject;
	import game.net.game.ingame.ResponseInt;
	import game.net.game.ingame.ResponseObjectStatus;
	import game.net.game.ingame.ResponseRemoveStatus;
	import game.net.game.ingame.ResponseShort;
	import game.net.game.ingame.ResponseUpdateHP;
	import game.net.game.ingame.ResponseUpdateObject;
	
	/**
	 * ...
	 * @author bangnd2
	 */
	public class ResponseIngame extends ResponsePacket 
	{
		private static var packetMapping:Array = [];
		{
			packetMapping[IngamePacket.CREATE_OBJECT] 	= ResponseCreateObject;
			packetMapping[IngamePacket.CREATE_BULLET] 	= ResponseCreateBullet;
			packetMapping[IngamePacket.DESTROY_OBJECT] 	= IngamePacket;
			packetMapping[IngamePacket.OBJECT_STATUS] 	= ResponseObjectStatus;
			packetMapping[IngamePacket.UPDATE_HP] 		= ResponseUpdateHP;
			packetMapping[IngamePacket.UPDATE_MP] 		= ResponseInt;
			packetMapping[IngamePacket.UPDATE_OBJECT] 	= ResponseUpdateObject;
			packetMapping[IngamePacket.CAST_SKILL] 		= ResponseCastSkill;
			packetMapping[IngamePacket.CAST_SKILL_ERROR]= ResponseByte;
			packetMapping[IngamePacket.RELEASE_SKILL] 	= IngamePacket;
			packetMapping[IngamePacket.ADD_STATUS] 		= ResponseAddStatus;
			packetMapping[IngamePacket.ADD_EFFECT] 		= ResponseAddEffect;
			packetMapping[IngamePacket.PREPARE_NEXT_WAVE] 		= ResponseByte;
			packetMapping[IngamePacket.NEXT_WAVE_READY] 		= IngamePacket;
			packetMapping[IngamePacket.REMOVE_STATUS] 	= ResponseRemoveStatus;
			packetMapping[IngamePacket.CHANGE_CHARACTER_MODEL] 	= ResponseInt;
			packetMapping[IngamePacket.SHOW_HIDE_CHARACTER] 	= ResponseByte;
			packetMapping[IngamePacket.CHARACTER_ATTACK_SPEED] 	= ResponseShort;
		}
		
		public var subpackets:Array;
		
		override public function decode(data:ByteArray):void 
		{
			subpackets = [];
			while (data.bytesAvailable > 0)
			{
				var objectLength:int = data.readUnsignedByte();
				var objectID:int = data.readShort();
				//trace("objectID=" + objectID + " objectLength=" + objectLength + " byteAvailable=" + data.bytesAvailable);
				
				if(objectLength > 0)
				{
					var objectData:ByteArray = new ByteArray();
					objectData.endian = Endian.LITTLE_ENDIAN;
					data.readBytes(objectData, 0, objectLength);
					
					while (objectData.bytesAvailable > 0)
					{
						var type:int = objectData.readByte();
						//if (type == IngamePacket.UPDATE_HP || type == IngamePacket.CREATE_BULLET || type == IngamePacket.DESTROY_OBJECT) trace("objectID = " + objectID + " type = " + Enum.getString(IngamePacket, type)); // + " byteAvailable=" + objectData.bytesAvailable
						var packetClass:Class = packetMapping[type];
						if (packetClass != null)
						{
							var packet:IngamePacket = new packetClass();
							packet.type = type;
							packet.objectID = objectID;
							packet.decode(objectData);
							subpackets.push(packet);
						}
						else
						{
							Utility.error("Unhandled ingame packet type: " + type);
						}
					}
				}
			}
		}
	}

}