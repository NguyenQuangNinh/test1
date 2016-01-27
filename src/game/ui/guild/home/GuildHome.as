package game.ui.guild.home 
{
	import com.adobe.utils.StringUtil;
	import components.enum.PopupAction;
	import core.Manager;
	import core.util.FontUtil;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import game.enum.Font;
	import flash.text.TextField;
	import game.Game;
	import game.net.IntRequestPacket;
	import game.net.lobby.LobbyRequestType;
	import game.net.StringRequestPacket;
	import game.ui.guild.popups.GuildPopupMng;
	/**
	 * ...
	 * @author vu anh
	 */
	public class GuildHome extends MovieClip
	{
		
		public var guildList:GuildInfoList;
		public var guildDetail:GuildDetail;
		
		public var searchGuildNameTf:TextField;
		
		public var searchCloseBtn:SimpleButton;
		public var searchBtn:SimpleButton;
		public var joinBtn:SimpleButton;
		public var createBtn:SimpleButton;
		public var defaultStr:String;
		
		public function GuildHome() 
		{
			//searchCloseBtn.addEventListener(MouseEvent.CLICK, searchCloseBtnHdl);
			createBtn.addEventListener(MouseEvent.CLICK, createBtnHdl);
			searchBtn.addEventListener(MouseEvent.CLICK, searchBtnHdl);
			
			joinBtn.addEventListener(MouseEvent.CLICK, joinBtnHdl);
			
			searchGuildNameTf.addEventListener(MouseEvent.CLICK, searchGuildNameTfHdl);
			defaultStr = searchGuildNameTf.text;
			FontUtil.setFont(searchGuildNameTf, Font.ARIAL, true);
		}
		public function updateFeatureUI(isHasGuild:Boolean):void
		{
			if (isHasGuild)
			{
				createBtn.mouseEnabled = false;
				joinBtn.mouseEnabled = false;
				createBtn.alpha = 0.5;
				joinBtn.alpha = 0.5;
			}
			else
			{
				createBtn.mouseEnabled = true;
				joinBtn.mouseEnabled = true;
				createBtn.alpha = 1;
				joinBtn.alpha = 1;
			}
		}
		
		private function searchBtnHdl(e:MouseEvent):void 
		{
			if (StringUtil.trim(searchGuildNameTf.text) == defaultStr)
			{
				Manager.display.showMessage("Bạn vui lòng nhập tên bang hội");
				return;
			}
			
			if (StringUtil.trim(searchGuildNameTf.text) == "")
			{
				//Manager.display.showMessage("Bạn vui lòng nhập tên bang hội");
				guildList.getGuildList();
				return;
			}
			
			if (StringUtil.trim(searchGuildNameTf.text).length < 5)
			{
				Manager.display.showMessage("Vui lòng nhập tối thiểu 5 ký tự");
				return;
			}
			guildList.unselectItem();
			guildList.clearList();
			guildDetail.reset();
			Game.network.lobby.sendPacket(new StringRequestPacket(LobbyRequestType.GU_SEARCH_GUILD_NAME, searchGuildNameTf.text, 32));
		}
		
		private function searchGuildNameTfHdl(e:MouseEvent):void 
		{
			if (searchGuildNameTf.text == defaultStr) searchGuildNameTf.setSelection(0, searchGuildNameTf.text.length);
		}
		
		private function createBtnHdl(e:MouseEvent):void 
		{
			GuildPopupMng.createGuildPopup.show();
			GuildPopupMng.createGuildPopup.createBtn.addEventListener(MouseEvent.CLICK, onCreateGuild);
		}
	
		private function onCreateGuild(e:MouseEvent):void 
		{
			var guildName:String = GuildPopupMng.createGuildPopup.nameTf.text;
			if (StringUtil.trim(guildName) == "")
			{
				Manager.display.showMessage("Bạn vui lòng nhập tên bang hội");
				return;
			}
			Game.network.lobby.sendPacket(new StringRequestPacket(LobbyRequestType.GU_CREATE, guildName, 32));
		}
		
		private function joinBtnHdl(e:MouseEvent):void 
		{
			if (!guildList.activeItem) 
			{
				Manager.display.showMessage("Bạn vui lòng chọn bang hội để xin gia nhập");
				return;
			}
			GuildPopupMng.messagePopup.show(joinGuildConfirmHdl, "", "Bạn sẽ gởi đơn xin gia nhập bang: " + guildList.activeItem.info.strName + "?");
		}
		
		private function joinGuildConfirmHdl(action:int, data:Object):void 
		{
			if (action != PopupAction.OK) return;
			joinBtn.mouseEnabled = false;
			Game.network.lobby.sendPacket(new IntRequestPacket(LobbyRequestType.GU_JOIN_REQUEST_SEND, guildList.activeItem.info.nGuildID));
		}
		
		private function searchCloseBtnHdl(e:MouseEvent):void 
		{
			searchGuildNameTf.text = "";
			guildList.getGuildList();
		}
		
	}

}