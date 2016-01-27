package game.data.xml 
{
	import core.util.Enum;
	import core.util.Utility;
	
	import game.enum.SkillTargetType;
	import game.enum.SkillType;

	/**
	 * ...
	 * @author bangnd2
	 */
	public class SkillXML extends XMLData 
	{
		public var iconURL:String;
		public var targetType:SkillTargetType;
		public var name:String;
		public var type:SkillType;
		public var radius:int;
		//public var effectID:int;
		public var desc:String;
		public var inGameDesc:String;
		public var stanceIDs:Array = [];
		public var cooldown:Number;
		public var effectArr:Array = [];
		public var visualEffectIDs:Array;
		public var summonCharacterIDs:Array;
		public var castTime:int;
		
		/*<ID>7</ID>
		<Name>Bổng Đả Ác Cẩu</Name>				
		<TargetType>0</TargetType>
		<Passive>0</Passive>
		<CoolDown>5000</CoolDown>
		<SubClassRequirement>1</SubClassRequirement>
		<ArrStances>47</ArrStances>
		<IconURL>resource/image/skill/caibang1_skill1.png</IconURL>
		<Radius></Radius>		
		<Desc></Desc>*/
		
		override public function parseXML(xml:XML):void 
		{
			super.parseXML(xml);
			iconURL = xml.IconURL.toString();
			var i:int = xml.TargetType.toString();
			targetType = SkillTargetType.ALL[i];
			name = xml.Name.toString();
			type = Enum.getEnum(SkillType, xml.Passive.toString()) as SkillType;
			radius = xml.Radius.toString();
			//effectID = xml.EffectID.toString();
			cooldown = xml.CoolDown.toString() / 1000;
			desc = xml.Description.toString();
			inGameDesc = xml.InGameDescription.toString();
			if (inGameDesc == null || inGameDesc == "")
			{
				inGameDesc = desc;
			}
			stanceIDs = xml.ArrStances.toString().split(",");
			Utility.convertToIntArray(stanceIDs);
			for each(var effect:XML in xml.Effects.Effect as XMLList) {
				effectArr.push(effect);
			}
			visualEffectIDs = Utility.toIntArray(xml.VisualEffectIDs.toString());
			summonCharacterIDs = Utility.toIntArray(xml.SummonCharacterIDs.toString());
			castTime = parseInt(xml.TimeCast.toString());
		}
		
		/*public function getSkillDesc():String {
			
		}*/
	}

}