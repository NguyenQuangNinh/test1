package core.util
{
	import com.greensock.TweenMax;

	import flash.display.DisplayObject;
	import flash.external.ExternalInterface;
	import flash.utils.ByteArray;

	import game.Game;

	public class Utility
	{
		public static var crc:CRC = new CRC();
		public static var math:MathUtil = new MathUtil();
		public static var font:FontUtil = new FontUtil();

		public static function log(message:String):void
		{
			if (!Game.database.gamedata.allowTracing) return;
			if (ExternalInterface.available)
			{
				ExternalInterface.call("console.log", "LOG  >>>  " + message);
			}
			else
			{
				trace(message);
			}
		}

		public static function info(message:String):void
		{
			if (!Game.database.gamedata.allowTracing) return;
			if (ExternalInterface.available)
			{
				ExternalInterface.call("console.info", "INFO  >>>  " + message);
			}
			else
			{
				trace(message);
			}
		}

		public static function warning(message:String):void
		{
			if (!Game.database.gamedata.allowTracing) return;
			if (ExternalInterface.available)
			{
				ExternalInterface.call("console.warn", "WARNING  >>>  " + message);
			}
			else
			{
				trace(message);
			}
		}

		public static function debug(message:String):void
		{
			if (!Game.database.gamedata.allowTracing) return;
			if (ExternalInterface.available)
			{
				ExternalInterface.call("console.debug", "DEBUG  >>>  " + message);
			}
			else
			{
				trace(message);
			}
		}

		public static function error(message:String):void
		{
			if (!Game.database.gamedata.allowTracing) return;
			if (ExternalInterface.available)
			{
				ExternalInterface.call("console.error", "ERROR  >>>  " + message);
			}
			else
			{
				trace(message);
			}
		}

		public static function convertToIntArray(array:Array):void
		{
			if (array == null) return;

			for (var i:int = 0; i < array.length; ++i)
			{
				array[i] = int(array[i]);
			}
		}

		public static function toIntArray(string:String, delim:String = ","):Array
		{
			var result:Array = [];
			if (string != null)
			{
				result = string.split(delim);
				for (var i:int = 0; i < result.length; ++i)
				{
					result[i] = int(result[i]);
				}
			}
			return result;
		}

		public static function parseToIntArray(str:String, delim:String = ","):Array
		{
			if (str == null || str == "") return [];

			var rs:Array = str.split(delim);
			convertToIntArray(rs);

			return rs;
		}

		public static function parseToStringArray(str:String, delim:String = ","):Array
		{
			if (str == null || str == "") return [];

			var rs:Array = str.split(delim);

			return rs;
		}

		public static function parseToDate(str:String):Date
		{
			//format cua String: YY-MM-DD HH:MM:SS
			var date:Date = null;
			var dayFormat:Array = str.substr(0, 10).split("-");
			var hourFormat:Array = str.substr(11, str.length).split(":");
			if (dayFormat.length != 3 || hourFormat.length != 3)
			{
				return date;
			}
			date = new Date(dayFormat[0],
							dayFormat[1] - 1,
					dayFormat[2],
					hourFormat[0],
					hourFormat[1],
					hourFormat[2]);
			return date;
		}

		public static function parseToBoolArray(str:String, delim:String = ","):Array
		{
			if (!str || str == "") return [];
			var arr:Array = str.split(delim);
			var rs:Array = [];
			for (var i:int = 0; i < arr.length; i++)
			{
				rs.push(Boolean(arr[i]));
			}
			return rs;
		}

		public static function clone(source:Object):*
		{
			var myBA:ByteArray = new ByteArray();
			myBA.writeObject(source);
			myBA.position = 0;
			return( myBA.readObject() );
		}

		public static function formatTimeEx(strFormat:String, strTime:String):String
		{
			return math.formatTimeEx(strFormat, strTime);
		}

		public static function setGrayscale(target:DisplayObject, value:Boolean):void
		{
			if (target != null) TweenMax.to(target, 0, {colorMatrixFilter: { saturation: value ? 0 : 1}});
		}

		public static function trim(string:String):String
		{
			var result:String = "";
			if (string != null) result = string.replace(/ /g, "");
			return result;
		}

		public static function formatNumber(number:Number):String
		{
			var string:String = number.toString();
			var index:int = string.lastIndexOf(".");
			if (index == -1) index = string.length - 1;
			var first:String;
			var last:String;
			while (index > 2)
			{
				index -= 3;
				first = string.substring(0, index + 1);
				last = string.substring(index + 1);
				string = first + "," + last;
			}
			return string;
		}

		private static function letterPairs(str:String):Array {

			var numPairs:int= str.length - 1;

			var pairs:Array= [];

			for (var i:int=0; i < numPairs; i++) {
				pairs[i] = str.substring(i,i+2);
			}

			return pairs;

		}

		private static function wordLetterPairs(str:String):Array {

			var allPairs:Array= [];

			// Tokenize the string and put the tokens/words into an array

			var words:Array= str.split("\\s");

			// For each word

			for (var w:int=0; w < words.length; w++) {

				// Find the pairs of characters

				var pairsInWord:Array= letterPairs(words[w]);

				for (var p:int=0; p < pairsInWord.length; p++) {

					allPairs.push(pairsInWord[p]);

				}

			}

			return allPairs;

		}

		public static function compareStrings(str1:String, str2:String):Number {

			var pairs1:Array= wordLetterPairs(str1.toUpperCase());

			var pairs2:Array= wordLetterPairs(str2.toUpperCase());

			var intersection:int= 0;

			var union:int= pairs1.length + pairs2.length;

			for (var i:int=0; i<pairs1.length; i++) {

				var pair1:Object = pairs1[i];

				for(var j:int=0; j<pairs2.length; j++) {

					var pair2:Object=pairs2[j];

					if (pair1 == pair2) {

						intersection++;

						pairs2.splice(j,1);

						break;
					}

				}
			}

			return (2.0*intersection)/union;

		}

		public static function distance(string_1:String, string_2:String):int
		{
			var matrix:Array = new Array();
			var dist:int;
			for (var i:int = 0; i <= string_1.length; i++)
			{
				matrix[i] = new Array();
				for (var j:int = 0; j <= string_2.length; j++)
				{
					if (i != 0)
					{
						matrix[i].push(0);
					}
					else
					{
						matrix[i].push(j);
					}
				}
				matrix[i][0] = i;
			}
			for (i = 1; i <= string_1.length; i++)
			{
				for (j = 1; j <= string_2.length; j++)
				{
					if (string_1.charAt(i - 1) == string_2.charAt(j - 1))
					{
						dist = 0;
					}
					else
					{
						dist = 1;
					}
					matrix[i][j] = Math.min(matrix[i - 1][j] + 1, matrix[i][j - 1] + 1, matrix[i - 1][j - 1] + dist);
				}
			}
			return matrix[string_1.length][string_2.length];
		}
	}
}