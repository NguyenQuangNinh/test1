package  
{
	/**
	 * ...
	 * @author 
	 */
	public class Utilities 
	{
		public static var months:Array = new Array("JAN", "FEB", "MAR", "APR", "MAY", "JUN", "JUL", "AUG", "SEP", "OCT", "NOV", "DEC");
		public function Utilities() 
		{
			
		}
		
		public static function getTimeInFormat(t:Date):String {
			var h:String = (t.getHours() % 12).toString();
			if (h.length == 1) h = "0" + h; 
			var m:String = t.getMinutes().toString();
			if (m.length == 1) m = "0" + m;		
			var phase:String = (t.getHours() > 12)? "PM":"AM";
			var d:String = Utilities.months[t.getMonth()] + " " + t.getDate() + " " + t.getFullYear();
			return(h + ":" + m + " " + phase + " - " + d);
		}				
		
		public static function removeElementFromArray(arr:Array, e:*):void
		{
			for ( var i:int = 0; i < arr.length; i++ ) 
			{
				if (arr[i] == e)
				{
					arr.splice(i, 1);
					return;
				}
			}
		}
		
		public static function insertElementToArray(arr:Array, e:*, ind:int):Array
		{
			var arr1:Array = arr.slice(0, ind);
			arr1.push(e);
			return arr1.concat(arr.slice(ind, arr.length));
		}
		
		public static function getElementIndex(arr:Array, e:*):int
		{
			for ( var i:int = 0; i < arr.length; i++ ) 
			{
				if (arr[i] == e)
				{
					return i;
				}
			}
			return -1;
		}
		
		public static function getElementIndex2(arr:Array, e:*, onProp:String):int
		{
			for ( var i:int = 0; i < arr.length; i++ ) 
			{
				if (arr[i][onProp] == e)
				{
					return i;
				}
			}
			return -1;
		}
		
		public static function getArrViewStr(arr:Array, prop:String):String
		{
			var str:String = "";
			for ( var i:int = 0; i < arr.length; i++ ) str += arr[i][prop] + ",";
			return str;
		}
		
		public static function trimWhitespace(str:String):String 
		{
			if (str == null) {
				return "";
			}
			return str.replace(/^\s+|\s+$/g, "");
		}
		
		public static function shuffleArray(array:Array):Array 
		{
			var newArray:Array = new Array();
			while(array.length > 0){
				var obj:Array = array.splice(Math.floor(Math.random()*array.length), 1);
				newArray.push(obj[0]);
			}
			return newArray;
		}

	}

}