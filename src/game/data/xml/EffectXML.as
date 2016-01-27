package game.data.xml 
{
	import core.util.Utility;
	import game.enum.EffectType;
	/**
	 * ...
	 * @author bangnd2
	 */
	public class EffectXML extends XMLData 
	{
		//public var animURL:String = "";
		//public var layers:Array = [];
		//public var delays:Array = [];
		//public var loops:Array = [];
		public var name:String;
		public var desc:String;
		public var statXML:XML;
		
		/*<ID>1</ID>
		<Name>Đào Đào Chi Yêu - Heal</Name>
		<Desc>Đào Đào Chi Yêu - Heal ba cmnd, tuyet the vo song tang {p1} trong thoi gian {p2}</Desc>
		<Stats>
			<p1>1,2,3,4,5</p1>
			<p2>1,2,3,4,5</p2>
		</Stats>*/
		
		override public function parseXML(xml:XML):void 
		{
			super.parseXML(xml);
			//animURL = xml.AnimURL.toString();
			//layers = xml.Layers.toString().split(",");
			//Utility.convertToIntArray(layers);
			//delays = xml.Delays.toString().split(",");
			//for (var i:int = 0; i < delays.length; ++i)
			//{
				//var delay:int = delays[i];
				//if (delay > 0) delay = delay / 1000;
				//delays[i] = delay;
			//}
			//loops = xml.Loops.toString().split(",");
			//Utility.convertToIntArray(loops);
			name = xml.Name.toString();
			desc = xml.Desc.toString();
			statXML = xml.Stats[0] as XML;
			
			//getString(1);
		}
		
		private function getValue(paraName:String, index:int): String {
			var result:String = "";
			try 
			{
				if (statXML[paraName]) {
					var paraXML:XML = (statXML[paraName] as XMLList)[0];
					var valueArr:Array = paraXML.toString().split(",");
					if (index < valueArr.length) {
						result = valueArr[index] as String;	
					}else {
						Utility.error("can not get value of " + paraName + " by index out of bound " + index);
					}
				}
			}catch (err:Error)
			{
				Utility.error("can not get value from effect: " + ID + " by error " + paraName + " // " + index);
			}
			return result;
		}
		
		public function getString(index:int):String {
			/*var result:String = "";
			
			var tempStr:String = desc.slice();
			var tempArr:Array = [];
			while (tempStr.indexOf("{") != -1) {
				tempArr = tempStr.split("{");
			}
			
			return result;*/
			
			/*var str:String = "<p>Hello\n"
					+ "again</p>"
					+ "<p>Hello</p>";
				
			var pattern:RegExp = /<p>.*?<\/p>/;
			trace(pattern.dotall) // false
			trace(pattern.exec(str)); // <p>Hello</p>
				
			pattern = /<p>.*?<\/p>/s;
			trace(pattern.dotall) // true
			trace(pattern.exec(str)); */
			
			/*//Exec() method returns an Object containing the groups that were matched
			//var htmlText:String = "<strong>This text is important</strong> while this text is not as important <strong>ya</strong>";
			var pattern:RegExp = /{(.*?)}/g;
			var matches:Array = pattern.exec(desc);
			for( var i:String in matches ) {
				trace( i + ": " + matches[i] );
			}*/
			
			//Exec() method returns an Object containing the groups that were matched
			//var htmlText:String = "<strog>This text is important</strong> while this text is not as important <strog>ya</strong>";
			//var strongRegExp:RegExp = /<strong>(.*?)<\/strong>/g;
			//var matches:Object = strongRegExp.exec( htmlText);
			//for( var i:String in matches ) {
				//trace( i + ": " + matches[i] );
			//}
			
			var pattern:RegExp = /{(.*?)}/;
			var result:String = desc.slice();
			
			var paraName:Array = [];
			var obj:Array = pattern.exec(result);
			
			while (obj) {				
				paraName.push(obj[1]);
				result = result.split(obj[0])[1];
				obj = pattern.exec(result);
			}
			
			var paraValue:Array = [];
			result = desc.slice();
			result = result.replace(/{/g, "");
			result = result.replace(/}/g, "");
			for each(var name:String in paraName) {
				result = result.replace(name, getValue(name, index));
			}
			
			return result;
		}
	}
}