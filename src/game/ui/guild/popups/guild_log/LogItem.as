package game.ui.guild.popups.guild_log 
{
	import core.util.FontUtil;
	import flash.display.MovieClip;
	import flash.text.TextField;
	import game.net.lobby.response.data.GuLogItemInfo;
	import game.ui.guild.GuildUtils;
	import game.enum.Font;
	/**
	 * ...
	 * @author vu anh
	 */
	public class LogItem extends MovieClip
	{
		
		public var dateTf:TextField;
		public var contentTf:TextField;

		public function LogItem() 
		{
			FontUtil.setFont(dateTf, Font.ARIAL, true);
			FontUtil.setFont(contentTf, Font.ARIAL, true);
		}
		
		public function reset():void
		{
			dateTf.text = "";
			contentTf.text = "";
		}
		
		public function update(info:GuLogItemInfo):void
		{
			var date:Date = new Date();
			date.setTime(info.time * 1000);
			dateTf.text = date.date + " - " + date.month + " - " + date.fullYear;
			contentTf.text = GuildUtils.getGuildActionDes(info.nType, info.strPlayerCreateName, info.strPlayerTargetName, info.value);
		}
		
	}

}