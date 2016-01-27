package game.data.xml 
{
	import core.util.Utility;
	import game.data.model.shop.SecretMerchantShopConfig;
	/**
	 * ...
	 * @author MaiPTT
	 */
	public class SecretMerchantEventXML extends XMLData 
	{
		public var serverDatas :Array = [];
		
		override public function parseXML(xml:XML):void {
			ID = parseInt(xml.EventID.toString());
			for each (var serverXML:XML in xml.Servers.Server) {
				var config:SecretMerchantShopConfig = new SecretMerchantShopConfig();
				config.serverID = parseInt(serverXML.ServerID.toString());
				config.enable = parseInt(serverXML.Enable.toString()) == 1 ? true : false;
				for each (var timeXML:XML in serverXML.Times.Time) {
					config.openTime.push(Utility.parseToDate(timeXML.Begin.toString()).getTime());
					config.closeTime.push(Utility.parseToDate(timeXML.End.toString()).getTime());
				}
				serverDatas.push(config);
			}
		}
	}

}