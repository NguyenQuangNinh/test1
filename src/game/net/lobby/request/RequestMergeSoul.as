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
	public class RequestMergeSoul extends RequestPacket
	{
		public var mergeIndex:int;
		public var recipeIndex:Array = [];
		
		public function RequestMergeSoul(itemIndex:int, recipeArrIndex:Array) 
		{
			super(LobbyRequestType.MERGE_SOUL);
			mergeIndex = itemIndex;
			recipeIndex = recipeArrIndex;
		}
		
		override public function encode():ByteArray 
		{
			var data:ByteArrayEx = new ByteArrayEx();
			data.writeInt(mergeIndex);
			for each(var index:int in recipeIndex) {
				data.writeInt(index);
			}
			return data;			
		}
	}

}