package core.util 
{
	/**
	 * ...
	 * @author anhpnh2
	 */
	public class TextCheckUtils 
	{
		private static var match1:String = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ_ ÀÁÂÃÈÉÊÌÍÒÓÔÕÙÚĂĐĨŨƠƯĂẠẢẤẦẨẪẬẮẰẲẴẶẸẺẼỀỀỂỄỆẾỈỊỌỎỐỒỔỖỘỚỜỞỠỢỤỦỨỪỬỮỰỲỴÝỶỸ";
		
		public function TextCheckUtils() 
		{
			
		}
		
		public static function checkAllSpace(name:String):Boolean
		{
			name = name.replace(new RegExp(" ", 'g'), "");
			if(name == "")
			{
				return true;
			}
			return false;
		}
		
		public static function checkArrayMatch_1(name:String):Boolean
		{
			var str:String = name.toUpperCase();
			for (var i:int = 0; i < str.length; i++)
			{
				if (match1.indexOf(str.charAt(i)) == -1)
				{
					Utility.log("str.charAt(i) : "+str.charAt(i));
					return true;
				}
			}
			return false;
		}
		
	}

}