package game.ui.guild 
{
	import components.event.BaseEvent;
	import components.tab.TabMng;
	import core.display.ModuleBase;
	import core.event.EventEx;
	import core.Manager;
	import core.util.Utility;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import game.enum.GameConfigID;
	import game.enum.LeaderBoardTypeEnum;
	import game.Game;
	import game.net.IntResponsePacket;
	import game.net.IntResponsePacket;
	import game.net.lobby.LobbyRequestType;
	import game.net.lobby.LobbyResponseType;
	import game.net.lobby.response.ResponseGuActionLog;
	import game.net.lobby.response.ResponseGuGetElderList;
	import game.net.lobby.response.ResponseGuGetMemberList;
	import game.net.lobby.response.ResponseGuGuildInfo;
	import game.net.lobby.response.ResponseGuGuildLevelUp;
	import game.net.lobby.response.ResponseGuGuildSearch;
	import game.net.lobby.response.ResponseGuJoinRequestList;
	import game.net.lobby.response.ResponseGuOwnGuildInfo;
	import game.net.lobby.response.ResponseGuProfile;
	import game.net.lobby.response.ResponseGuTopLadder;
	import game.net.lobby.response.ResponseGuUpdateMemberRole;
	import game.net.RequestPacket;
	import game.net.ResponsePacket;
	import game.net.Server;
	import game.net.StringRequestPacket;
	import game.ui.dialog.DialogID;
	import game.ui.guild.home.GuildInfoList;
	import game.ui.guild.popups.GuildPopupMng;
	import game.ui.hud.HUDModule;
	import game.ui.ModuleID;
	/**
	 * ...
	 * @author vu anh
	 */
	public class GuildModule extends ModuleBase
	{
		private var view:GuildView;
	
		public function GuildModule() 
		{
		}
		
		override protected function createView():void 
		{
			super.createView();
			view = new GuildView();
			this.baseView = view;
			view.tabMng.addEventListener(TabMng.EVENT_TAB_CHANGE, onViewChangeHdl);
			view.closeBtn.addEventListener(MouseEvent.CLICK, closeBtnHdl);
		}
		
		private function closeBtnHdl(e:MouseEvent):void 
		{
			var hudModule:HUDModule = Manager.module.getModuleByID(ModuleID.HUD) as HUDModule;
			if (hudModule != null)
			{
				hudModule.updateHUDButtonStatus(ModuleID.GUILD, false);
			}
		}
		
		private function onViewChangeHdl(e:BaseEvent):void 
		{
			var tabIndex:int = e.data as int;
			switch (tabIndex)
			{
				case 0: // home
					//GuildView(view).guildHome.guildList.getGuildList();
					break;
				case 1: // my guild
					//GuildView(view).myGuild.getInfo();
					break; 
			}
		}
		
		override protected function preTransitionIn():void 
		{
			Game.network.lobby.addEventListener(Server.SERVER_DATA, onLobbyResponse);
			view.guildHome.guildList.getGuildList();
			view.myGuild.getInfo();
		}
		
		override protected function preTransitionOut():void {
			super.preTransitionOut();
			Game.network.lobby.removeEventListener(Server.SERVER_DATA, onLobbyResponse);
		}
		
		private function onLobbyResponse(e:EventEx):void 
		{
			var packet:ResponsePacket = e.data as ResponsePacket;
			var errorCode:int;
			var message:String;
			var guildList:GuildInfoList = GuildView(view).guildHome.guildList;
			switch(packet.type) 
			{
				case LobbyResponseType.GU_GET_LEADER_BOARD:
					if (packet as ResponseGuTopLadder) 
					{
						guildList.updateGuildList((packet as ResponseGuTopLadder).guildList);
						// backBtn is clicked before
						if (!guildList.backBtn.mouseEnabled && ResponseGuTopLadder(packet).guildList.length) guildList.backBtn.mouseEnabled = true;
						// nextBtn is clicked before
						if (!guildList.nextBtn.mouseEnabled && ResponseGuTopLadder(packet).guildList.length) guildList.nextBtn.mouseEnabled = true;
					}
					break;
				case LobbyResponseType.GU_CREATE:
					errorCode = (packet as IntResponsePacket).value;
					switch (errorCode)
					{
						case 0:
							message = "Xin chúc mừng! Bạn đã tạo ban hội thành công";
							view.myGuild.getInfo();
							break;
						case 1:
							message = "Tạo ban hội thất bại";
							break;
						case 2:
							message = "Bạn không đủ bạc để tạo ban hội";
							break;
						case 3:
							message = "Tên ban hội đã tồn tại";
							break;
						case 4:
							message = "Bạn không đủ level để tạo ban hội";
							break;
						case 5:
							message = "Bạn cần chờ " + Game.database.gamedata.getConfigData(GameConfigID.GUILD_DELAY_AFTER_LEAVE) + " ngày để tạo ban hội sau khi rời bang";
							break;
						default:
							message = "Tạo ban hội thất bại";
							break;
					}
					Manager.display.showMessage(message);
					if (errorCode == 0) 
					{
						view.guildHome.guildList.getGuildList();
						GuildPopupMng.createGuildPopup.hide();
					}
			
					break;
				case LobbyResponseType.GU_GET_GUILD_INFO:
					view.guildHome.guildDetail.update(packet as ResponseGuGuildInfo);
					// unlock guild list after get guild detail
					view.guildHome.guildList.unlock();
					break;
				case LobbyResponseType.GU_SEARCH_GUILD_NAME:
					if ((packet as ResponseGuGuildSearch).guildList.length == 0) Manager.display.showMessage("Không tìm thấy bang hội, vui lòng nhập tên khác.");
					guildList.updateGuildList((packet as ResponseGuGuildSearch).guildList);
					break;
				case LobbyResponseType.GU_JOIN_REQUEST_SEND:
					view.guildHome.joinBtn.mouseEnabled = true;
					errorCode = (packet as IntResponsePacket).value;
					switch (errorCode)
					{
						case 0:
							message = "Đã gửi đơn xin gia nhập";
							break;
						case 1:
							message = "Gửi đơn xin gia nhập thất bại";
							break;
						case 2:
							message = "Chưa thể gửi đơn xin gia nhập. Bạn có thể gửi đơn sau " + Game.database.gamedata.getConfigData(GameConfigID.GUILD_DELAY_AFTER_LEAVE) + " ngày";
							break;
						case 3:
							message = "Đơn xin gia nhập đã được gửi";
							break;
						case 4:
							message = "Số lượng thành viên trong bang hội này đã đạt mức tối đa";
							break;
						default:
							message = "Gửi đơn xin gia nhập thất bại";
							break;
					}
					Manager.display.showMessage(message);
					break;
				case LobbyResponseType.GU_GET_OWN_GUILD_INFO:
					Game.database.userdata.guildLevel = ResponseGuOwnGuildInfo(packet).nLevel;
					view.myGuild.myGuildDetail.update(packet);
					if (ResponseGuOwnGuildInfo(packet).nGuildID >= 0) 
					{
						view.tabMng.setActive(1);
						view.guildHome.updateFeatureUI(true);
						view.myGuild.memberList.getMemberList();
						view.tabbBtns.btn2.mouseEnabled = true;
						view.tabbBtns.btn2.mouseChildren = true;
					}
					else 
					{
						view.tabbBtns.btn2.mouseEnabled = false;
						view.tabbBtns.btn2.mouseChildren = false;
						view.guildHome.updateFeatureUI(false);
						Manager.display.showMessage("Bạn chưa có ban hội");
					}
					
					view.myGuild.updateRoleUI(ResponseGuOwnGuildInfo(packet).nMemberType);
					GuildPopupMng.skillPopup.update(ResponseGuOwnGuildInfo(packet));
					break;
				case LobbyResponseType.GU_GET_MEMBER_LIST:
					view.myGuild.memberList.updateMemberList(ResponseGuGetMemberList(packet).memberList);
					break;
				case LobbyResponseType.GU_UPDATE_ANNOUCE:
					var messageType:int = (packet as IntResponsePacket).value;
					if (messageType == 0) // annouce
					view.myGuild.updateAnnouceMessage();
					else view.myGuild.updateNoticeMessage();
					break;
				case LobbyResponseType.GU_INVITE_ACCEPT :
					Manager.display.showMessage("Bạn đã gửi yêu cầu gia nhập thành công");
					break;
				case LobbyResponseType.GU_GET_JOIN_REQUEST_LIST:
					GuildPopupMng.joinRequestPopup.list.updateGuildList(ResponseGuJoinRequestList(packet).requestList);
					break;
				case LobbyResponseType.GU_JOIN_REQUEST_ACCEPT:
					errorCode = (packet as IntResponsePacket).value;
					switch (errorCode)
					{
						case 0:
							view.myGuild.isRequestListChanged = true;
							message = "Thành công, Đã chấp nhận gia nhập";
							break;
						case 1:
							message = "Gia nhập thất bại";
							break;
						case 2:
							message = "Người này đã ở trong bang hội";
							break;
						case 3:
							message = "Thất bại, Người này đã có bang hội";
							break;
						case 4:
							message = "Thất bại, Số lượng thành viên trong bang hội này đã đạt mức tối đa";
							break;
						default:
							message = "Gia nhập thất bại";
							break;
					}
					Manager.display.showMessage(message);
					break;
				case LobbyResponseType.GU_CHANGE_MEMBER_ROLE:
					errorCode = (packet as IntResponsePacket).value;
					switch (errorCode)
					{
						case 0:
							view.myGuild.memberList.getMemberList();
							message = "Điều chỉnh chức vụ thành công";
							break;
						case 1:
							message = "Điều chỉnh chức vụ thất bại";
							break;
						default:
							message = "Điều chỉnh chức vụ thất bại";
							break;
					}
					Manager.display.showMessage(message);
					break;
				
				case LobbyResponseType.GU_KICK:
					errorCode = (packet as IntResponsePacket).value;
					
					switch (errorCode)
					{
						case 0:
							message = "Trục xuất thành công";
							view.myGuild.memberList.getMemberList();
							break;
						case 1:
							message = "Trục xuất thất bại";
							break;
						default:
							message = "Trục xuất thất bại";
							break;
					}
					
					Manager.display.showMessage(message);
					break;
				case LobbyResponseType.GU_LEAVE:
					errorCode = (packet as IntResponsePacket).value;
					switch (errorCode)
					{
						case 0:
							view.tabbBtns.btn2.mouseEnabled = false;
							view.tabbBtns.btn2.mouseChildren = false;
							view.guildHome.updateFeatureUI(false);
							message = "Rời bang hội thành công";
							Game.database.userdata.leaveGuild();
							break;
						case 1:
							message = "Rời bang hội thất bại";
							break;
						default:
							message = "Rời bang hội thất bại";
							break;
					}
					Manager.display.showMessage(message);
					break;
				case LobbyResponseType.GU_UPDATE_MEMBER_ROLE:
					GuildPopupMng.messagePopup.show(null, "", "Bạn vừa được chuyển chức trách thành " + GuildUtils.getRoleName(ResponseGuUpdateMemberRole(packet).nMemberType), null, true);
					view.myGuild.getInfo();
					break;
				case LobbyResponseType.GU_KICKED:
					//Manager.display.showMessage("Bạn đã bị trục xuất khỏi bang hội!");
					GuildPopupMng.messagePopup.show(null, "", "Bạn đã bị trục xuất khỏi bang hội!");
					view.tabbBtns.btn2.mouseEnabled = false;
					view.tabbBtns.btn2.mouseChildren = false;
					view.guildHome.updateFeatureUI(false);
					Game.database.userdata.leaveGuild();
					break;
				case LobbyResponseType.GU_UPGRATE_GUILD:
					errorCode = (packet as IntResponsePacket).value;
					switch (errorCode)
					{
						case 0:
							message = "Nâng cấp bang hội thành công";
							break;
						case 1:
							message = "Nâng cấp bang hội thất bại";
							break;
						default:
							message = "Nâng cấp bang hội thất bại";
							break;
					}
					Manager.display.showMessage(message);
					break;
				case LobbyResponseType.GU_GET_ELDER_LIST:
					GuildPopupMng.refusePresidentPopup.updateList(ResponseGuGetElderList(packet).memberList);
					break;
				case LobbyResponseType.GU_PROMOTE_TO_PRESIDENT:
					errorCode = (packet as IntResponsePacket).value;
					switch (errorCode)
					{
						case 0:
							message = "Thoái vị thành công";
							view.myGuild.getInfo();
							Game.database.userdata.leaveGuild();
							break;
						case 1:
							message = "Thoái vị thất bại";
							break;
						case 2:
							message = "Chưa thể thoái vị. Bạn cần chờ " + Game.database.gamedata.getConfigData(GameConfigID.GUILD_PROMOTE_PRESIDENT_DELAY) + " ngày để thoái vị.";
							break;
						default:
							message = "Thoái vị thất bại";
							break;
					}
					Manager.display.showMessage(message);
					break;
				case LobbyResponseType.GU_DEDICATED:
					errorCode = (packet as IntResponsePacket).value;
					switch (errorCode)
					{
						case 0:
							message = "Cống hiến thành công";
							view.myGuild.getInfo();
							break;
						case 1:
							message = "Cống hiến thất bại";
							break;
						case 2:
							message = "Cống hiến thất bại. Bạn không đủ vàng/bạc để cống hiến";
							break;
						case 3:
							message = "Cống hiến thất bại. Bạn đã vượt quá " + Game.database.gamedata.getConfigData(GameConfigID.GUILD_DEDICATED_GOLD_MAX_TIME) + " lần cống hiến bạc tối đa trong ngày.";
							break;
						case 4:
							message = "Cống hiến thất bại. Bạn đã vượt quá " + Game.database.gamedata.getConfigData(GameConfigID.GUILD_DEDICATED_XU_MAX_TIME) + " lần cống hiến vàng tối đa trong ngày.";
							break;
						default:
							message = "Cống hiến thất bại";
							break;
					}
					Manager.display.showMessage(message);
					break;
				case LobbyResponseType.GU_GUILD_LEVEL_UP:
					view.myGuild.myGuildDetail.levelTf.text = ResponseGuGuildLevelUp(packet).level.toString();
					break;
				case LobbyResponseType.GU_GET_ACTION_LOG:
					GuildPopupMng.historyPopup.logList.updateLogList(ResponseGuActionLog(packet).logArr);
					break; 
				case LobbyResponseType.GU_DEDICATED_SKILL:
					errorCode = (packet as IntResponsePacket).value;
					switch (errorCode)
					{
						case 0:
							message = "Cống hiến thành công";
							view.myGuild.getInfo();
							break;
						case 1:
							message = "Cống hiến thất bại";
							break;
						case 2:
							message = "Cống hiến thất bại. Bạn đã vượt quá số lần cống hiến tối đa trong ngày.";
							break;
						case 3:
							message = "Cống hiến thất bại. Kỹ năng này đã đạt level tối đa";
							break;
						default:
							message = "Cống hiến thất bại";
							break;
					}
					Manager.display.showMessage(message);
					break;
			}
			Utility.log("guild error code: " + errorCode);
		}
		
	}

}