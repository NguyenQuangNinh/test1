package game.data.xml
{
	
	/**
	 * ...
	 * @author chuongth2
	 */
	
	public class ChargeEventXML extends XMLData
	{
		public var nMaxRequirementXu:int = 0;
		public var arrServerEvent:Array = [];
		public var arrPaymentReward:Array = [];
		
		public function ChargeEventXML()
		{
		
		}
		
		override public function parseXML(xml:XML):void
		{
			//super.parseXML(xml);
			ID = parseInt(xml.EventID.toString());
			
			var serverXMLList:XMLList = xml.Servers.Server;
			if (serverXMLList)
			{
				for each (var serverXML:XML in serverXMLList)
				{
					var serverEventXML:ServerEventXML = new ServerEventXML();
					serverEventXML.parseXML(serverXML);
					arrServerEvent.push(serverEventXML);
				}
			}
			
			var paymentXMLList:XMLList = xml.PaymentRewards.PaymentReward;
			if (paymentXMLList)
			{
				for each (var paymentXML:XML in paymentXMLList)
				{
					var paymentEventXML:PaymentEventRewardXML = new PaymentEventRewardXML();
					paymentEventXML.parseXML(paymentXML);
					
					if (paymentEventXML.nRequirementXu > nMaxRequirementXu)
						nMaxRequirementXu = paymentEventXML.nRequirementXu;
					arrPaymentReward.push(paymentEventXML);
				}
				
			}
		}
	
	}

}