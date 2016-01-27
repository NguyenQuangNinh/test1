/**
 * Created by NinhNQ on 9/22/2014.
 */
package game.data.xml.event
{

	import game.data.model.event.ItemActive;

	public class ActivateEventXML extends EventXML
	{
		public var itemActive:ItemActive; // Cong thuc ghep vat pham

		override public function parseXML(xml:XML):void
		{
			super.parseXML(xml);

			itemActive = new ItemActive();
			itemActive.price = parseInt(xml.ItemActive.Price.toString());
			itemActive.description = xml.ItemActive.Desc.toString();
			itemActive.iconURL = xml.ItemActive.IconURL.toString();
		}
	}
}
