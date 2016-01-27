package game.ui.guild.my_guild 
{
	import core.util.FontUtil;
	import flash.display.MovieClip;
	import flash.text.TextField;
	import game.enum.GameConfigID;
	import game.Game;
	import game.net.lobby.response.ResponseGuOwnGuildInfo;
	import game.enum.Font;
	import game.net.ResponsePacket;
	import game.ui.guild.home.GuildDetail;
	
	/**
	 * ...
	 * @author vu anh
	 */
	public class MyGuildDetail extends GuildDetail
	{
		public var noticeTf:TextField;
		public var personDedicatedPointTf:TextField;
		public function MyGuildDetail()
		{
			FontUtil.setFont(noticeTf, Font.ARIAL, true);
			FontUtil.setFont(personDedicatedPointTf, Font.ARIAL, true);
		}
		
		override public function update(packet:ResponsePacket):void
		{
			this.info = packet;
			guildNameTf.text = ResponseGuOwnGuildInfo(packet).strName;
			rankTf.text = ResponseGuOwnGuildInfo(packet).nRank.toString();
			levelTf.text = ResponseGuOwnGuildInfo(packet).nLevel.toString();
			var currentMax:int = Game.database.gamedata.getConfigData(GameConfigID.GUILD_MAX_MEMBER_BASE) + Game.database.gamedata.getConfigData(GameConfigID.GUILD_MAX_MEMBER_ADDED_ARR)[ResponseGuOwnGuildInfo(packet).nLevel];
			totalMemberTf.text = ResponseGuOwnGuildInfo(packet).nNumMember.toString() + " / " + currentMax;
			presidentNameTf.text = ResponseGuOwnGuildInfo(packet).strPresidenName;
			dedicatedPointTf.text = ResponseGuOwnGuildInfo(packet).nTotalDedicationPoint.toString();
			announceTf.text = ResponseGuOwnGuildInfo(packet).strAnnounce;
			noticeTf.text = ResponseGuOwnGuildInfo(packet).strNotice;
			personDedicatedPointTf.text = ResponseGuOwnGuildInfo(packet).nCurrentDP.toString();
		}
		
		override public function reset():void
		{
			noticeTf.text = "";
			super.reset();
		}
	}

}