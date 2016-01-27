package game.data.xml
{
	import core.util.Utility;
	
	/**
	 * ...
	 * @author chuongth2
	 */
	public class PaymentEventRewardXML
	{
		
		public var nRequirementXu:int = 0;
		public var arrRewardID:Array = [];
		
		
		public function PaymentEventRewardXML()
		{
		
		}
		public function parseXML(xml:XML):void
		{
			nRequirementXu = parseInt(xml.RequirementXu.toString());
			arrRewardID = Utility.parseToIntArray(xml.Rewards.toString());
		}
	}

}