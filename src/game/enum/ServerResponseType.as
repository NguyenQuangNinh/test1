package game.enum
{
	import core.util.Enum;
	
	public class ServerResponseType extends Enum
	{
		public var packetClass:Class;
		
		public function ServerResponseType(ID:int, packetClass:Class, name:String="")
		{
			super(ID, name);
			this.packetClass = packetClass;
		}
	}
}