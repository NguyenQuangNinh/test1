package game.ui.guild.my_guild 
{
	import com.adobe.utils.StringUtil;
	import components.enum.PopupAction;
	import core.display.layer.Layer;
	import core.display.layer.LayerManager;
	import core.Manager;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import game.enum.GameConfigID;
	import game.enum.ShopID;
	import game.Game;
	import game.net.IntRequestPacket;
	import game.net.lobby.LobbyRequestType;
	import game.net.lobby.request.RequestBasePacket;
	import game.net.lobby.response.data.GuMemberInfo;
	import game.net.lobby.response.ResponseGuOwnGuildInfo;
	import game.net.RequestPacket;
	import game.net.StringRequestPacket;
	import game.ui.guild.enum.GuildFeature;
	import game.ui.guild.enum.GuildMemberAction;
	import game.ui.guild.popups.GuildPopupMng;
	import game.ui.ModuleID;
	/**
	 * ...
	 * @author vu anh
	 */
	public class MyGuild extends MovieClip
	{
		public var myGuildDetail:MyGuildDetail;
		public var memberList:MemberList;
		
		public var noticeBtn:SimpleButton;
		public var announceBtn:SimpleButton;
		public var upgrateBtn:SimpleButton;
		public var shopBtn:SimpleButton;
		public var refusePresidentBtn:SimpleButton;
		public var changeMemberRoleBtn:SimpleButton;
		public var viewJoinRequestBtn:SimpleButton;
		public var removeMemberBtn:SimpleButton;
		public var quitGuildBtn:SimpleButton;
		public var dedicatedBtn :SimpleButton;
		public var historyBtn :SimpleButton;
		public var skillBtn :SimpleButton;
		
		private var buttonMap:Array;
		
		public var isRequestListChanged:Boolean;
		
		public function MyGuild() 
		{
			
			buttonMap = [];
			buttonMap[GuildMemberAction.INVITE_MEMBER] = null;
			buttonMap[GuildMemberAction.REMOVE_MEMBER] = removeMemberBtn;
			buttonMap[GuildMemberAction.CHANGE_ROLE] = changeMemberRoleBtn;
			buttonMap[GuildMemberAction.UPGRATE_GUILD] = upgrateBtn;
			buttonMap[GuildMemberAction.DISTRIBUTE_RESOURCE] = null;
			buttonMap[GuildMemberAction.REFUSE_PRESIDENT] = refusePresidentBtn;
			buttonMap[GuildMemberAction.UPDATE_ANNOUCE] = announceBtn;
			buttonMap[GuildMemberAction.UPDATE_NOTICE] = noticeBtn;
			buttonMap[GuildMemberAction.VIEW_JOIN_REQUEST] = viewJoinRequestBtn;
			buttonMap[GuildMemberAction.LEAVE_GUILD] = quitGuildBtn;
			
			noticeBtn.addEventListener(MouseEvent.CLICK, noticeBtnHdl);
			announceBtn.addEventListener(MouseEvent.CLICK, announceBtnHdl);
			viewJoinRequestBtn.addEventListener(MouseEvent.CLICK, viewJoinRequestBtnHdl);
			changeMemberRoleBtn.addEventListener(MouseEvent.CLICK, changeMemberRoleBtnHdl);
			removeMemberBtn.addEventListener(MouseEvent.CLICK, removeMemberBtnHdl);
			quitGuildBtn.addEventListener(MouseEvent.CLICK, quitGuildBtnHdl);
			upgrateBtn.addEventListener(MouseEvent.CLICK, upgrateBtnHdl);
			refusePresidentBtn.addEventListener(MouseEvent.CLICK, refusePresidentBtnHdl);
			dedicatedBtn.addEventListener(MouseEvent.CLICK, dedicatedBtnHdl);
			shopBtn.addEventListener(MouseEvent.CLICK, shopBtnHdl);
			historyBtn.addEventListener(MouseEvent.CLICK, historyBtnHdl);
			skillBtn.addEventListener(MouseEvent.CLICK, skillBtnHdl);
			
		}
		
		private function skillBtnHdl(e:MouseEvent):void 
		{
			GuildPopupMng.skillPopup.show();
		}
		
		private function historyBtnHdl(e:MouseEvent):void 
		{
			GuildPopupMng.historyPopup.show();
		}
		
		private function shopBtnHdl(e:MouseEvent):void 
		{
			Manager.display.showModule(ModuleID.SHOP_ITEM, new Point(0, 0), LayerManager.LAYER_POPUP, "top_left", Layer.NONE, ShopID.GUILD_ITEM.ID);
		}
		
		private function dedicatedBtnHdl(e:MouseEvent):void 
		{
			GuildPopupMng.dedicateGuildPopup.show();
		}
		
		private function refusePresidentBtnHdl(e:MouseEvent):void 
		{
			GuildPopupMng.refusePresidentPopup.show();
		}
		
		private function upgrateBtnHdl(e:MouseEvent):void 
		{
			var prices:Array = Game.database.gamedata.getConfigData(GameConfigID.GUILD_LEVEL_UP_DP_COST) as Array;
			
			if (currentGuildLevel >= prices.length)
			{
				Manager.display.showMessage("Không thể nâng cấp, Bang hội của bạn đã đạt cấp tối đa!");
				return;
			}
			
			var currentGuildLevel:int = ResponseGuOwnGuildInfo(myGuildDetail.info).nLevel;
			GuildPopupMng.upgrateGuildPopup.updateInfo(currentGuildLevel);
			GuildPopupMng.upgrateGuildPopup.show(upgrateConfirmHdl);
		}
		
		private function upgrateConfirmHdl(action:int, data:Object):void 
		{
			if (action != PopupAction.OK) return;
			Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.GU_UPGRATE_GUILD));
		}
		
		private function quitGuildBtnHdl(e:MouseEvent):void 
		{
			GuildPopupMng.messagePopup.show(onQuitConfirmHdl, "", "Bạn có muốn rời bang hội?");
		}
		
		private function onQuitConfirmHdl(action:int, data:Object):void 
		{
			if (action != PopupAction.OK) return;
			Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.GU_LEAVE));
		}
		
		private function removeMemberBtnHdl(e:MouseEvent):void 
		{
			if (!memberList.activeItem) 
			{
				Manager.display.showMessage("Bạn chưa chọn thành viên để trục xuất");
				return;
			}
			GuildPopupMng.messagePopup.show(onKickConfirmHdl, "", "Bạn có muốn trục xuất thành viên " + memberList.activeItem.info.strRoleName + "?");
		}
		
		private function onKickConfirmHdl(action:int, data:Object):void 
		{
			if (action != PopupAction.OK) return;
			Game.network.lobby.sendPacket(new IntRequestPacket(LobbyRequestType.GU_KICK, memberList.activeItem.info.nPlayerID));
		}
		
		private function changeMemberRoleBtnHdl(e:MouseEvent):void 
		{
			if (!memberList.activeItem) 
			{
				Manager.display.showMessage("Bạn chưa chọn thành viên để điều chỉnh");
				return;
			}
			GuildPopupMng.changeRolePopup.updateRole(ResponseGuOwnGuildInfo(myGuildDetail.info).nMemberType, memberList.activeItem.info);
			GuildPopupMng.changeRolePopup.show(changeMemberRolePopupCloseHdl, "", "", memberList.activeItem.info);
		}
		
		private function changeMemberRolePopupCloseHdl(action:int, data:Object):void 
		{
			var guMemberInfo:GuMemberInfo = data as GuMemberInfo;
			if (action == PopupAction.OK)
			{
				var packet:RequestBasePacket = new RequestBasePacket(LobbyRequestType.GU_CHANGE_MEMBER_ROLE);
				packet.ba.writeInt(guMemberInfo.nPlayerID);
				packet.ba.writeByte(GuildPopupMng.changeRolePopup.roleRBGroup.activeItem.info as int);
				Game.network.lobby.sendPacket(packet);
			}
		}
		
		public function updateRoleUI(roleId:int):void
		{
			var actions:Array = GuildFeature.getGuildFeature(roleId);
			var btn:SimpleButton;
			for (var i:int = 0; i < buttonMap.length; i++) 
			{
				btn = buttonMap[i] as SimpleButton;
				if (!btn) continue;
				btn.mouseEnabled = false;
				btn.alpha = 0.5;
			}
			
			for (var j:int = 0; j < actions.length; j++) 
			{
				btn = buttonMap[actions[j]] as SimpleButton;
				if (!btn) continue;
				btn.alpha = 1;
				btn.mouseEnabled = true;
			}
		}
		
		public function getInfo():void
		{
			Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.GU_GET_OWN_GUILD_INFO));
		}
		
		private function viewJoinRequestBtnHdl(e:MouseEvent):void 
		{
			GuildPopupMng.joinRequestPopup.show(joinRequestPopupCloseHdl);
		}
		
		private function joinRequestPopupCloseHdl(action:int, data:Object):void 
		{
			if (isRequestListChanged) memberList.getMemberList();
		}
		
		private function announceBtnHdl(e:MouseEvent):void 
		{
			GuildPopupMng.annoucePopup.show(annoucePopupCallback);
		}
		
		private function annoucePopupCallback(action:int, data:Object):void 
		{
			if (action != PopupAction.OK || StringUtil.trim(GuildPopupMng.annoucePopup.tf.text) == "") return;
			var packet:RequestBasePacket = new RequestBasePacket(LobbyRequestType.GU_UPDATE_ANNOUCE);
			packet.ba.writeByte(0); // 0: annouce 1: notice
			packet.ba.writeString(GuildPopupMng.annoucePopup.tf.text, 80);
			Game.network.lobby.sendPacket(packet);
		}
		
		private function noticeBtnHdl(e:MouseEvent):void 
		{
			GuildPopupMng.noticePopup.show(onNoticeCallback);
		}
		
		private function onNoticeCallback(action:int, data:Object):void 
		{
			if (action != PopupAction.OK || StringUtil.trim(GuildPopupMng.noticePopup.tf.text) == "") return;
			var packet:RequestBasePacket = new RequestBasePacket(LobbyRequestType.GU_UPDATE_ANNOUCE);
			packet.ba.writeByte(1); // 0: annouce 1: notice
			packet.ba.writeString(GuildPopupMng.noticePopup.tf.text, 80);
			Game.network.lobby.sendPacket(packet);
		}
		
		public function updateAnnouceMessage():void
		{
			myGuildDetail.announceTf.text = GuildPopupMng.annoucePopup.tf.text;
		}
		
		public function updateNoticeMessage():void
		{
			myGuildDetail.noticeTf.text = GuildPopupMng.noticePopup.tf.text;
		}
		
		public function reset():void
		{
			myGuildDetail.reset();
			memberList.clearList();
		}
		
	}

}