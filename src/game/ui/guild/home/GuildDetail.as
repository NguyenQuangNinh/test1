package game.ui.guild.home 
{
	import core.display.layer.Layer;
	import core.Manager;
	import core.util.FontUtil;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import game.enum.GameConfigID;
	import game.Game;
	import game.net.lobby.response.ResponseGuGuildInfo;
	import game.enum.Font;
	import game.net.ResponsePacket;
	import game.ui.ModuleID;
	
	/**
	 * ...
	 * @author vu anh
	 */
	public class GuildDetail extends MovieClip
	{
		public var presInfoBtn:SimpleButton;
		
		public var guildNameTf:TextField;
		public var rankTf:TextField;
		public var levelTf:TextField;
		public var totalMemberTf:TextField;
		public var presidentNameTf:TextField;
		public var dedicatedPointTf:TextField;
		public var announceTf:TextField;
		
		public var info:ResponsePacket;
		
		public function GuildDetail() 
		{
			reset();
			FontUtil.setFont(guildNameTf, Font.ARIAL, true);
			FontUtil.setFont(rankTf, Font.ARIAL, true);
			FontUtil.setFont(levelTf, Font.ARIAL, true);
			FontUtil.setFont(totalMemberTf, Font.ARIAL, true);
			FontUtil.setFont(presidentNameTf, Font.ARIAL, true);
			FontUtil.setFont(dedicatedPointTf, Font.ARIAL, true);
			FontUtil.setFont(announceTf, Font.ARIAL, true);
			if (presInfoBtn) presInfoBtn.addEventListener(MouseEvent.CLICK, presInfoBtnHdl);
		}
		
		private function presInfoBtnHdl(e:MouseEvent):void 
		{
			if (this.info) Manager.display.showPopup(ModuleID.PLAYER_PROFILE,  Layer.BLOCK_BLACK, ResponseGuGuildInfo(this.info).nPresidenID);
		}
		
		public function update(packet:ResponsePacket):void
		{
			this.info = packet;
			guildNameTf.text = ResponseGuGuildInfo(packet).strName;
			rankTf.text = ResponseGuGuildInfo(packet).nRank.toString();
			levelTf.text = ResponseGuGuildInfo(packet).nLevel.toString();
			var currentMax:int = Game.database.gamedata.getConfigData(GameConfigID.GUILD_MAX_MEMBER_BASE) + Game.database.gamedata.getConfigData(GameConfigID.GUILD_MAX_MEMBER_ADDED_ARR)[ResponseGuGuildInfo(packet).nLevel];
			totalMemberTf.text = ResponseGuGuildInfo(packet).nNumMember.toString() + " / " + currentMax;
			presidentNameTf.text = ResponseGuGuildInfo(packet).strPresidenName;
			dedicatedPointTf.text = ResponseGuGuildInfo(packet).nTotalDedicationPoint.toString();
			announceTf.text = ResponseGuGuildInfo(packet).strAnnounce;
		}
		
		public function reset():void
		{
			guildNameTf.text = "";
			rankTf.text = "";
			levelTf.text = "";
			totalMemberTf.text = "";
			presidentNameTf.text = "";
			dedicatedPointTf.text = "";
			announceTf.text = "";
			info = null;
		}
		
	}

}