package core.util
{
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	public class ByteArrayEx extends ByteArray
	{
		public function ByteArrayEx(endian:String = Endian.LITTLE_ENDIAN)
		{
			this.endian = endian;
		}
		
		public function readString():String
		{
			var string:String = "";
			var length:int = readInt();
			if(length > 0) string = readUTFBytes(length);
			return string;
		}
		
		public function writeString(string:String, fixLength:int):void
		{
			if (string == null) return;
			var stringByteArray:ByteArray = new ByteArray();
			/*if(fixLength == 0)
			{
				writeMultiByte(string, "UTF-8");
				writeByte(0);
			}
			else
			{*/
				if(string.length < fixLength)
				{
					stringByteArray.writeMultiByte(string, "UTF-8");
					writeBytes(stringByteArray);
					//Utility.log("Byte Array Length:" + length);
					for (var i:int = 0, total:int = fixLength - stringByteArray.length; i < total; ++i)
					{
						writeByte(0);
					}
					writeByte(0);
					//Utility.log("Byte Array Length:" + length);
				}
				else
				{
					//writeUTFBytes(string.substr(0, fixLength));
					stringByteArray.writeMultiByte(string, "UTF-8");
					writeBytes(stringByteArray,0, fixLength);
					writeByte(0);
				}
			//}
		}
	}
}