package game.net.lobby.response 
{
	import core.util.ByteArrayEx;
	import flash.utils.ByteArray;
	import game.net.ResponsePacket;
	/**
	 * ...
	 * @author vuanh
	 */
	public class ResponseGuOwnGuildInfo extends ResponsePacket
	{
		public var nRank	:int;
		public var nGuildID	:int = -1;
		public var strName:String;
		public var strAnnounce:String;
		public var strNotice:String;
		public var nNumMember	:int;
		public var nLevel	:int;
		public var nTotalDedicationPoint	:int;
		public var nPresidenID	:int;
		public var strPresidenName	:String;
		public var nMemberType	:uint; // 1 byte
		public var nCurrentDP	:int;

		public var guildVitalitySkillLvl		:int;
		public var guildStrengthSkillLvl		:int;
		public var guildAgilitySkillLvl			:int;
		public var guildIntelligentSkillLvl		:int;
		
		public var guildVitalityDP			:int;
		public var guildStrengthDP			:int;
		public var guildAgilityDP			:int;
		public var guildIntelligentDP		:int;

		public var nDedicateGoldCountInDay:int;
		public var nDedicateXuCountInDay:int;
		
		override public function decode(data:ByteArray):void 
		{
			if (!data.bytesAvailable) return;
			nRank = data.readInt();
			nGuildID = data.readInt();
			strName = ByteArrayEx(data).readString();
			strAnnounce = ByteArrayEx(data).readString();
			strNotice = ByteArrayEx(data).readString();
			nNumMember = data.readInt();
			nLevel = data.readInt();
			nTotalDedicationPoint = data.readInt();
			
			nPresidenID = data.readInt();
			strPresidenName = ByteArrayEx(data).readString();
			nMemberType = data.readInt();
			nCurrentDP = data.readInt();
			
			nDedicateGoldCountInDay = data.readInt();
			nDedicateXuCountInDay = data.readInt();
			
			guildStrengthSkillLvl = data.readInt();
			guildAgilitySkillLvl = data.readInt();
			guildIntelligentSkillLvl = data.readInt();
			guildVitalitySkillLvl = data.readInt();
			
			guildStrengthDP = data.readInt();
			guildAgilityDP = data.readInt();
			guildIntelligentDP = data.readInt();
			guildVitalityDP = data.readInt();
		}
		
	}

}