package game.ui.guild.popups 
{
	import components.popups.OKCancelPopup;
	import core.Manager;
	import core.util.FontUtil;
	import flash.text.TextField;
	import game.enum.GameConfigID;
	import game.Game;
	import game.net.lobby.response.ResponseGuOwnGuildInfo;
	import game.enum.Font;
	/**
	 * ...
	 * @author vu anh
	 */
	public class UpgrateGuildPopup extends OKCancelPopup
	{
		public var tf:TextField;
		public var dpTf:TextField;
		public var currentMaxTf:TextField;
		public var afterMaxTf:TextField;
		
		public function UpgrateGuildPopup() 
		{
			FontUtil.setFont(dpTf, Font.ARIAL, true);
			FontUtil.setFont(currentMaxTf, Font.ARIAL, true);
			FontUtil.setFont(afterMaxTf, Font.ARIAL, true);
			FontUtil.setFont(tf, Font.ARIAL, true);
		}
		
		public function updateInfo(currentGuildLevel:int):void
		{
			var prices:Array = Game.database.gamedata.getConfigData(GameConfigID.GUILD_LEVEL_UP_DP_COST) as Array;
			var addedMembers:Array =  Game.database.gamedata.getConfigData(GameConfigID.GUILD_MAX_MEMBER_ADDED_ARR) as Array;
			tf.text = "Nâng cấp bang lên cấp " + (currentGuildLevel + 1) + " cần: ";
			dpTf.text = prices[currentGuildLevel + 1] + " điểm cống hiến.";
			var currentMax:int = Game.database.gamedata.getConfigData(GameConfigID.GUILD_MAX_MEMBER_BASE) + Game.database.gamedata.getConfigData(GameConfigID.GUILD_MAX_MEMBER_ADDED_ARR)[currentGuildLevel];
			currentMaxTf.text =  currentMax.toString();
			afterMaxTf.text = int( Game.database.gamedata.getConfigData(GameConfigID.GUILD_MAX_MEMBER_BASE) + addedMembers[currentGuildLevel + 1] ).toString();
		}
		
	}

}