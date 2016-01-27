package game.ui.guild.popups 
{
	import core.display.DisplayManager;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author vu anh
	 */
	public class GuildPopupMng 
	{
		public static var createGuildPopup:CreateGuildPopup;
		public static var noticePopup:GuildNoticePopup;
		public static var annoucePopup:GuildAnnoucePopup;
		public static var joinRequestPopup:ViewJoinRequestPopup;
		public static var changeRolePopup:GuildChangeRolePopup;
		public static var messagePopup:MessageGuildPopup;
		public static var refusePresidentPopup:RefusePresidentPopup;
		public static var upgrateGuildPopup:UpgrateGuildPopup;
		public static var dedicateGuildPopup:DedicatePopup;
		public static var historyPopup:GuildHistoryPopup;
		public static var skillPopup:SkillDedicatePopup;
		
		public function GuildPopupMng() 
		{
			
		}
		
		public static function init(con:MovieClip):void
		{
			for ( var i:int = 0; i < con.numChildren; i++ ) 
			{
				con.getChildAt(i).visible = false;
				Sprite(con.getChildAt(i)).graphics.beginFill(0x000000, 0.4);
				Sprite(con.getChildAt(i)).graphics.drawRect(- con.getChildAt(i).x, - con.getChildAt(i).y, DisplayManager.SCREEN_WIDTH, DisplayManager.SCREEN_HEIGHT);
				Sprite(con.getChildAt(i)).graphics.endFill();
			}
			createGuildPopup = con.createGuildPopup;
			noticePopup = con.noticePopup;
			annoucePopup = con.annoucePopup;
			joinRequestPopup = con.joinRequestPopup;
			changeRolePopup = con.changeRolePopup;
			messagePopup = con.messagePopup;
			refusePresidentPopup = con.refusePresidentPopup;
			upgrateGuildPopup = con.upgrateGuildPopup;
			dedicateGuildPopup = con.dedicateGuildPopup;
			historyPopup = con.historyPopup;
			skillPopup = con.skillPopup;
		}
		
	}

}