package game.ui.guild 
{
	import components.tab.TabMng;
	import core.display.ViewBase;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import game.ui.components.ButtonClose;
	import game.ui.guild.home.GuildHome;
	import game.ui.guild.my_guild.MyGuild;
	import game.ui.guild.popups.GuildPopupMng;
	/**
	 * ...
	 * @author vu anh
	 */
	public class GuildView extends ViewBase
	{
		public var popupCon:MovieClip;
		
		public var closeCon:MovieClip;
		public var closeBtn:ButtonClose;
		
		public var myGuild:MyGuild;
		public var guildHome:GuildHome;
		public var guildFight:MovieClip;
		public var tabbBtns:MovieClip;
		
		public var tabMng:TabMng;
		public function GuildView() 
		{
			GuildPopupMng.init(popupCon);
			
			tabMng = new TabMng();
			tabMng.addTab(tabbBtns.btn1, guildHome);
			tabMng.addTab(tabbBtns.btn2, myGuild);
			tabMng.addTab(tabbBtns.btn3, guildFight);
			tabbBtns.btn2.mouseEnabled = false;
			tabbBtns.btn2.mouseChildren = false;
			tabMng.setActive(0);
			
			closeBtn = new ButtonClose();
			closeCon.addChild(closeBtn);
		}
		
	}

}