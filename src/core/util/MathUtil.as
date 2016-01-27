package core.util
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class MathUtil
	{
		
		public function MathUtil()
		{
		
		}
		
		public function clamp(value:Number, min:Number, max:Number):Number
		{
			return Math.min(Math.max(min, value), max);
		}
		
		public function correctFloatingPointError(number:Number, precision:int = 5):Number
		{
			return Number(number.toFixed(precision));
		}
		
		public function wrap(num1:Number, num2:Number, factor:Number = 0):Number
		{
			var delta:Number = num2 - factor;
			
			while (num1 >= num2)
			{
				num1 = num1 - delta;
			}
			
			while (num1 < factor)
			{
				num1 = num1 + delta;
			}
			
			return num1;
		}
		
		public function interpolate(start:Number, end:Number, factor:Number):Number
		{
			return (1 - start) * end + start * factor;
		}
		
		public function random(start:int, end:int = 0):int
		{
			return Math.floor(Math.random() * (start - end)) + end;
		}
		
		public function randomIncl(num1:int, num2:int):int
		{
			return Math.floor(Math.random() * (num1 - num2 + 1)) + num2;
		}
		
		public function randomEpsilon(num1:int, num2:int):int
		{
			return random(num1 + num2, num1 - num2);
		}
		
		public function randomIndex(list:Array):int
		{
			return random(list.length);
		}
		
		public function randomIndexVector(param1:*):int
		{
			return random(param1.length);
		}
		
		public function randomElement(arr:Array):*
		{
			return arr.length == 0 ? (null) : (arr[random(arr.length)]);
		}
		
		public function randomElementVector(vectorList:*):*
		{
			return vectorList.length == 0 ? (null) : (vectorList[random(vectorList.length)]);
		}
		
		public function randomIndexWeighed(numbersArray:Array):int
		{
			var item:Number = NaN;
			var total:Number = 0;
			var index:int = 0;
			while (index < numbersArray.length)
			{
				total = total + numbersArray[index];
				index++;
			}
			var randomWeighed:Number = Math.random() * total;
			index = 0;
			while (index < numbersArray.length)
			{
				
				item = numbersArray[index];
				if (randomWeighed < item)
				{
					return index;
				}
				randomWeighed = randomWeighed - item;
				index++;
			}
			
			return -1;
		}
		
		public function randomWobble(start:Number, end:Number):Number
		{
			return start + (2 * Math.random() - 1) * end * start;
		}
		
		public function inEpsilonRange(num1:Number, num2:Number, epsilon:Number):Boolean
		{
			return Math.abs(num1 - num2) < epsilon;
		}
		
		public function distance(startPt:Point, endPt:Point, algorithmIndex:int = 2):Number
		{
			var deltaX:Number = startPt.x - endPt.x;
			var deltaY:Number = startPt.y - endPt.y;
			if (algorithmIndex == 2)
			{
				return Math.sqrt(deltaX * deltaX + deltaY * deltaY);
			}
			
			if (algorithmIndex == 1)
			{
				return Math.abs(deltaX) + Math.abs(deltaY);
			}
			
			if (algorithmIndex > 0)
			{
				return Math.pow(Math.pow(Math.abs(deltaX), algorithmIndex) + Math.pow(Math.abs(deltaY), algorithmIndex), 1 / algorithmIndex);
			}
			
			return deltaX > deltaY ? (deltaX) : (deltaY);
		}
		
		public function setPrecision(number:Number, precision:int):Number {
			precision = Math.pow(10, precision);
			return (Math.round(number * precision)/precision);
		}
		
		public function formatInteger(num:int):String
		{
			if (num == 0)
				return "0";
			
			var dotIntFormat:String = "";
			
			var numDigit:int = 0;
			var singleDigit:int = 0;
			while (num > 0)
			{
				singleDigit = num % 10;
				numDigit++;
				if ((numDigit - 3) % 3 == 1)
				{
					dotIntFormat = singleDigit.toString() + "." + dotIntFormat;
				}
				else
				{
					dotIntFormat = singleDigit.toString() + dotIntFormat;
				}
				num = Math.floor(num / 10);
			}
			
			return dotIntFormat;
		}
		
		/*
		 *	obj style is {x, y, w, h}
		 */
		public function checkOverlap(obj1:Rectangle, obj2:Rectangle):Boolean
		{
			//var result: Boolean = false;
			//Utility.log("check hit " + obj1 + " by " + obj2);
			/*if (obj2.x >= obj1.x && obj2.x <= obj1.x + obj1.w) {
			   if (obj2.y >= obj1.y && obj2.y <= obj1.y + obj1.h) {
			   return true;
			   }
			 }else*/ /*if(obj1.x >= obj2.x && obj1.x <= obj2.x + obj2.w) {
			   if (obj1.y >= obj2.y && obj1.y <= obj2.y + obj2.h) {
			   return true;
			   }
			   }
			 return false;*/
			return obj1 && obj1 ? obj1.intersects(obj2) || obj1.containsRect(obj2) || obj2.containsRect(obj1) || obj2.intersects(obj1) : false;
		}
		
		public function formatTime(type:String, value:int):String
		{
			//value is count by second unit
			
			var result:String = "";
			
			var hours:int;
			var minutes:int;
			var seconds:int;
			var days:int;
			
			/*var milliseconds:int = parseInt(temp);
			   var seconds:int = milliseconds / 1000;
			   var minutes:int = seconds / 60;
			   var hours:int = minutes / 60;
			
			   seconds %= 60;
			 minutes %= 60;*/
			//parse hour - minute - second
			minutes = value / 60;
			hours = minutes / 60;
			days = hours / 24;
			
			hours = hours - days * 24;
			minutes = minutes - (days * 24 + hours) * 60;
			seconds = value - (days * 24 + hours) * 3600 - minutes * 60;
			
			switch (type)
			{
				case "D-H-M": 
					result = (days >= 10 ? days : "0" + days) + ":"
							+ (hours >= 10 ? hours : "0" + hours) + ":"
							+ (minutes >= 10 ? minutes : "0" + minutes) + ""
							//+ (seconds >= 10 ? seconds : "0" + seconds) + "s";
					break;
				case "H-M": 
					//parse hour - minute
					result = (hours >= 10 ? hours : "0" + hours) + ":"
							+ (minutes >= 10 ? minutes : "0" + minutes) + "";
					break;
				case "H-M-S":
					
					result = (hours >= 10 ? hours : "0" + hours) + ":"
							+ (minutes >= 10 ? minutes : "0" + minutes) + ":"
							+ (seconds >= 10 ? seconds : "0" + seconds) + "";
					break;
				case "M-S": 
					//parse minute - econd
					/*minutes = value / 60;
					   seconds = value - minutes * 60;
					
					 minutes %= 60;*/
					
					result = (minutes >= 10 ? minutes : "0" + minutes) + ":"
							+ (seconds >= 10 ? seconds : "0" + seconds) + "";
					break;
					
				case "DD":
					result = days + " ngày";
					break;
			}
			//Utility.log("time format is " + result);
			return result;
		}
		
		public function formatTimeEx(strFormat:String, strTime:String):String
		{
			if (strTime.indexOf("T") > 0)
			{
				switch (strFormat)
				{
					case "YYYY-MM-DD": 
						return strTime.substr(0, 4) + "-" + strTime.substr(4, 2) + "-" + strTime.substr(6, 2);
					case "h:m:s": 
						return strTime.substr(10, 2) + ":" + strTime.substr(12, 2) + ":" + strTime.substr(14, 2);
					case "YYYY-MM-DD h:m:s": 
						return formatTimeEx("YYYY-MM-DD", strTime) + " " + formatTimeEx("h:m:s", strTime);
					case "DD-MM-YYYY":
						return strTime.substr(6, 2) + "-" + strTime.substr(4, 2) + "-" + strTime.substr(0, 4);
					//default: 
						//return "";
				}
			}
			return "";
		}
		
		public static function degreeToRadian(degree:Number):Number { return degree / 180 * Math.PI; }
		public static function radianToDegree(radian:Number):Number { return radian / Math.PI * 180; }
	}
}
