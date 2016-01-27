/**
 * Created by NinhNQ on 9/22/2014.
 */
package game.data.xml.event
{

	import game.data.model.event.Equation;

	public class ExchangeEventXML extends EventXML
	{
		public var maxCombination:int;
		public var maxUse:int;
		public var equation:Equation; // Cong thuc ghep vat pham

		override public function parseXML(xml:XML):void
		{
			super.parseXML(xml);

			maxCombination = parseInt(xml.MaxCombination.toString());
			maxUse = parseInt(xml.MaxUse.toString());

			for each (var equationXML:XML in xml.Equation)
			{
				equation = new Equation();
				equation.parseData(equationXML);
			}
		}
	}
}
