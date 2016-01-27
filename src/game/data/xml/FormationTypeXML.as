package game.data.xml 
{
	import core.util.Utility;
	import game.data.vo.formation_type.FormationEffectInfo;
	/**
	 * ...
	 * @author anhtinh/chuongth2
	 */
	public class FormationTypeXML extends XMLData
	{
		public var name : String;
		public var description : String;
		public var iconUrl : String;
		public var arrLevelUnlock:Array;
		public var upgradeItemID:int;
		public var arrRateUpgrade : Array;
		public var arrItemQuantityUpgrade : Array;
		public var arrGoldUpgrade : Array;
		public var enable : Boolean;

		public var effects : Array;
		
		
		override public function parseXML(xml:XML):void 
		{
			super.parseXML(xml);
			
			name = xml.Name.toString();
			description = xml.Description.toString();
			iconUrl = xml.IconURL.toString();
			arrLevelUnlock = Utility.parseToIntArray(xml.LevelUnlock.toString(), ",");
			upgradeItemID = parseInt(xml.UpgradeItemID.toString());
			arrRateUpgrade = Utility.parseToIntArray(xml.RateUpgrade.toString(), ",");
			arrItemQuantityUpgrade = Utility.parseToIntArray(xml.ItemQuantityUpgrade.toString(), ",");
			arrGoldUpgrade = Utility.parseToIntArray(xml.GoldUpgrade.toString(), ",");
			enable = parseInt(xml.Enable.toString()) == 1;

			effects = [];
			var effectXMLList : XMLList = xml.Effects.Effect;
			if (effectXMLList == null) return ;
			
			for each (var effectXML: XML in effectXMLList) 
			{
				
				var formationEffectInfo : FormationEffectInfo = new FormationEffectInfo();
				formationEffectInfo.levelUnlockEffect = effectXML.LevelUnlockEffect.toString();
				formationEffectInfo.requiredElements =  Utility.parseToIntArray(effectXML.RequireElement.toString(), ",");
				//bo phan tu 0 dau tien
				//formationEffectInfo.requiredElements.splice(0, 1);
				formationEffectInfo.bonusAttributes =  Utility.parseToIntArray(effectXML.BonusAttributes.toString(), ",");
				formationEffectInfo.arrTargets =  Utility.parseToIntArray(effectXML.arrTargets.toString(), ",");
				formationEffectInfo.targetType =   parseInt(effectXML.TargetType.toString());
				effects.push(formationEffectInfo);
			}
		}
		
	}

}