package game.data.xml 
{
	import core.util.Utility;
	import game.data.vo.formation_type.FormationEffectInfo;
	/**
	 * ...
	 * @author anhtinh
	 */
	public class UnitFormationXML extends XMLData
	{
		public var name : String;
		public var description : String;
		/**
		 * FormationEffectInfo
		 */
		public var effects : Array;
		
		
		override public function parseXML(xml:XML):void 
		{
			super.parseXML(xml);
			
			name = xml.Name.toString();
			description = xml.Description.toString();
			
			effects = [];
			
			var effectXMLList : XMLList = xml.Effects.Effect;
			if (effectXMLList == null) return ;
			
			for each (var effectXML: XML in effectXMLList) 
			{
				var formationEffectInfo : FormationEffectInfo = new FormationEffectInfo();
				
				formationEffectInfo.requiredElements =  Utility.parseToIntArray(effectXML.RequireElement.toString(), ",");
				//bo phan tu 0 dau tien
				formationEffectInfo.requiredElements.splice(0, 1);
				
				
				formationEffectInfo.bonusAttributes =  Utility.parseToIntArray(effectXML.BonusAttributes.toString(), ",");
				
				effects.push(formationEffectInfo);
			}
		}
		
	}

}