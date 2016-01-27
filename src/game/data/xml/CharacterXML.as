package game.data.xml
{
	import core.util.Utility;
	import game.enum.ItemType;
	
	import game.data.model.item.IItemConfig;
	import game.enum.Sex;
	
	public class CharacterXML extends XMLData implements IItemConfig
	{
		public var nextIDs:Array = [];
		public var characterClass:int;
		public var name:String;
		public var desc:String;
		public var width:int;
		public var height:int;
		public var activeSkills:Array = [];
		public var quality:Array = [];
		public var rangerAttackRange:int;
		public var meleeAttackRange:int;
		public var bulletID:int;
		public var type:int;
		public var smallAvatarURLs:Array = [];
		public var largeAvatarURLs:Array = [];
		public var animURLs:Array = [];
		public var artworkURL			:String;
		public var passiveSkill			:int = -1;
		public var opacity:Number;
		public var level:int;
		public var beginStar:int;
		public var expTransmission:int;
		
		override public function parseXML(xml:XML):void
		{
			super.parseXML(xml);
			nextIDs = Utility.parseToIntArray(xml.NextID.toString());
			name = xml.Name.toString();
			desc = xml.Desc.toString();
			characterClass = xml.Class.toString();
			width = xml.Width.toString();
			height = xml.Height.toString();
			rangerAttackRange = xml.RangerAttackRange.toString();
			bulletID = xml.BulletID.toString();
			type = parseInt(xml.UnitType.toString());
			largeAvatarURLs[Sex.MALE] = xml.MaleIconURL.toString();
			smallAvatarURLs[Sex.MALE] = xml.MaleSmallIconURL.toString();
			animURLs[Sex.MALE] = xml.MaleAnimURL.toString();
			largeAvatarURLs[Sex.FEMALE] = xml.FemaleIconURL.toString();
			smallAvatarURLs[Sex.FEMALE] = xml.FemaleSmallIconURL.toString();
			animURLs[Sex.FEMALE] = xml.FemaleAnimURL.toString();
			artworkURL = xml.ArtworkURL.toString();
			activeSkills = Utility.parseToIntArray(xml.ActiveSkills.toString());
			passiveSkill = parseInt(xml.PassiveSkill.toString());
			opacity = xml.Opacity.toString();
			meleeAttackRange = parseInt(xml.MeleeAttackRange.toString());
			quality= Utility.parseToIntArray(xml.Quality.toString());
			level = xml.BeginLevel.toString();
			beginStar = parseInt(xml.BeginStar.toString());
			expTransmission = parseInt(xml.TransmissionExp.toString());
		}
		
		public function getIconURL() : String {
			return smallAvatarURLs[Sex.FEMALE];
		}
		
		public function getName() : String {
			return name;
		}
		
		public function getDescription() : String {
			return desc;
		}
		
		public function getType(): ItemType {
			return ItemType.UNIT;
		}
		
		/*public function getAnimURL():String {
			return "";
		}*/
	}
}