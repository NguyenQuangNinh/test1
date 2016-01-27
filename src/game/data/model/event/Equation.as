/**
 * Created by NinhNQ on 9/19/2014.
 */
package game.data.model.event
{

	import core.util.Utility;

	public class Equation
	{
		public var source:Array = [];
		public var dest:Variable;

		public function parseData(xmlData:XML):void
		{
			var s:Array = Utility.parseToIntArray(xmlData.Source.toString(), ",");
			var d:Array = Utility.parseToIntArray(xmlData.Dest.toString(), ",");

			for (var i:int = 0; i < s.length; i = i + 2)
			{
				var variable:Variable = new Variable();
				variable.quantity = s[i];
				variable.itemID = s[i + 1];

				source.push(variable);
			}

			dest = new Variable();
			dest.quantity = d[0];
			dest.itemID = d[1];
		}
	}
}
