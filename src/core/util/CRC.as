package core.util
{
	import flash.utils.ByteArray;

	public class CRC
	{
		private var key:uint;
		private var table:Array = [];
		
		public function init(key:uint):void
		{
			this.key = key;
			table = new Array(256);
			
			for (var i:int = 0; i < 256; ++i) 
			{
				var c:uint = i;
				for (var j:int = 8; j > 0; --j) 
				{
					if ((c & 1) != 0)
						c = key ^ (c >>> 1);
					else
						c = c >>> 1;
					table[i] = c;
				}
			}
		}
		
		public function make(data:ByteArray):uint
		{
			var off:uint = 0;
			var length:uint = data.length;
			var c:uint = ~key;
			
			while (--length >= 0)
				c = table[(c ^ data[off++]) & 0xff] ^ (c >>> 8);
			
			return (~c);
		}
	}
}