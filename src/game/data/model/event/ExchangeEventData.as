/**
 * Created by NinhNQ on 9/19/2014.
 */
package game.data.model.event
{

	import flash.events.Event;

	import game.Game;

	import game.data.xml.event.EventXML;
	import game.data.xml.event.ExchangeEventXML;
	import game.enum.ItemType;
	import game.net.lobby.response.ResponseEventInfo;

	public class ExchangeEventData extends EventData
	{
		public function ExchangeEventData(xml:EventXML, currentTime:Number)
		{
			super(xml, currentTime);
		}

		public function get maxCombination():int
		{
			var currentQuantity:int = Game.database.inventory.getItemQuantity(ItemType.NORMAL_CHEST, exchangeEventXML.equation.dest.itemID);
			var rs:int = (maxAcc - currentAcc - currentQuantity > exchangeEventXML.maxCombination) ? exchangeEventXML.maxCombination : maxAcc - currentAcc - currentQuantity;
			return (rs > 0) ? rs : 0;
		}


		override public function get maxAcc():int
		{
			return exchangeEventXML.maxUse;
		}

		override public function get isMax():Boolean
		{
			return maxCombination == 0;
		}

		public var currentCombination:int = 0;

		public function get exchangeEventXML():ExchangeEventXML
		{
			return super.eventXML as ExchangeEventXML;
		}
	}
}
