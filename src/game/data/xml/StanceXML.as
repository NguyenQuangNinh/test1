package game.data.xml 
{
	import core.util.Utility;
	/**
	 * ...
	 * @author TrungLNM
	 */
	public class StanceXML extends XMLData
	{
		public var name:String;
		public var desc:String;
		public var effectIDs:Array = [];
		
		/*<ID>1</ID>
		<Name>Thức 1</Name>		
		<Desc>hiệu quả thức 1</Desc>
		<ArrRatePerLevel>100,100,100,100,100,100,100,100,100,100</ArrRatePerLevel>
		<ClientEffectID>0</ClientEffectID>
		<ArrEffects>1</ArrEffects>*/
		
		override public function parseXML(xml:XML):void 		
		{
			super.parseXML(xml);
			name = xml.Name.toString();
			desc = xml.Desc.toString();
			effectIDs = xml.ArrEffects.toString().split(",");
			Utility.convertToIntArray(effectIDs);
		}					
	}

}