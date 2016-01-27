package game.ui.master_invitation
{

	import com.greensock.TweenLite;

	import core.display.ModuleBase;

	import core.display.ModulesManager;

	import core.display.ViewBase;
	import core.event.EventEx;
	import core.Manager;
	import core.util.FontUtil;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.utils.Timer;
	import game.data.model.item.Item;
	import game.data.xml.CharacterXML;
	import game.data.xml.DataType;
	import game.data.xml.item.ItemChestXML;
	import game.data.xml.RewardXML;
	import game.enum.ErrorCode;
	import game.enum.Font;
	import game.enum.ItemType;
	import game.Game;
	import game.net.IntRequestPacket;
	import game.net.RequestPacket;
	import game.net.lobby.LobbyRequestType;
	import game.net.lobby.LobbyResponseType;
	import game.net.lobby.request.RequestUseItems;
	import game.net.lobby.response.ResponseConsumeItem;
	import game.net.ResponsePacket;
	import game.net.Server;
	import game.ui.ModuleID;
	import game.ui.hud.HUDModule;

	import mx.modules.ModuleManager;


	public class MasterInvitationView extends ViewBase
	{
		public var btnClose:SimpleButton;
		public var btnInvite:SimpleButton;
		public var btnReceive:SimpleButton;
		public var containerAvatars:MovieClip;
		public var txtRemainQuantity:TextField;
		private var selectedAvatar:AvatarMaster;

		private var avatars:Array = [];

		public function MasterInvitationView()
		{
			btnClose.addEventListener(MouseEvent.CLICK, btn_onClicked);
			btnInvite.addEventListener(MouseEvent.CLICK, btn_onClicked);
			btnReceive.addEventListener(MouseEvent.CLICK, btn_onClicked);
			FontUtil.setFont(txtRemainQuantity, Font.ARIAL);
		}
		
		protected function btn_onClicked(event:MouseEvent):void
		{
			switch(event.target)
			{
				case btnClose:
					Manager.display.hideModule(ModuleID.MASTER_INVITATION);
					break;
				case btnReceive:
					receiveAnim();
					break;
				case btnInvite:
					inviteMaster();
					break;
			}
		}

		private function receiveAnim():void
		{
			if(selectedAvatar)
			{
				var hudModule:HUDModule = Manager.module.getModuleByID(ModuleID.HUD) as HUDModule;

				var point:Point = hudModule.getPositionBtnByName("changeFormationBtn");
				point = globalToLocal(point);
				TweenLite.to(selectedAvatar, .3, {x: point.x+20, y: point.y+20, scaleX:0, scaleY:0, onComplete:checkRemainItems});
			}
		}

		private function checkRemainItems():void {
			selectedAvatar.reset();
			var item:Item = data as Item;
			if (item && item.xmlData) {
				var itemID:int = item.xmlData.ID as int;
				var remainQuantity:int = Game.database.inventory.getItemQuantity(ItemType.MASTER_INVITATION_CHEST, itemID);
				if (remainQuantity > 0) {
					txtRemainQuantity.text = "Số lượt quay còn lại: " + remainQuantity;
					reset();
				} else {
					Manager.display.hideModule(ModuleID.MASTER_INVITATION);
				}
			}
		}
		
		private function reset():void {
			btnInvite.visible = true;
			btnReceive.visible = false;
			
			for each (var avatar:AvatarMaster in avatars) {
				if (avatar && avatar.getSelected()) {
					avatar.setSelected(false);
					avatar.reset();
				}
			}
		}
		
		override public function transitionIn():void
		{
			btnInvite.visible = true;
			btnReceive.visible = false;
			
			var item:Item = data as Item;
			if(item != null)
			{
				txtRemainQuantity.text = "Số lượt quay còn lại: " + item.quantity;
				var xmlData:ItemChestXML = item.itemXML as ItemChestXML;
				if(xmlData != null)
				{
					var avatar:AvatarMaster;
					var characterXML:CharacterXML;
					var rewardXML:RewardXML;
					for(var i:int = 0; i < xmlData.rewardIDs.length; ++i)
					{
						rewardXML = Game.database.gamedata.getData(DataType.REWARD, xmlData.rewardIDs[i]) as RewardXML;
						if(rewardXML != null && rewardXML.type == ItemType.UNIT)
						{
							characterXML = Game.database.gamedata.getData(DataType.CHARACTER, rewardXML.itemID) as CharacterXML;
							avatar = Manager.pool.pop(AvatarMaster) as AvatarMaster;
							avatar.setData(characterXML);
							avatar.x = i * 167;
							avatar.setSelected(false);
							containerAvatars.addChild(avatar);
							avatars.push(avatar);
						}
					}
				}
			}
			Game.network.lobby.addEventListener(Server.SERVER_DATA, lobby_onPacketReceived);
			Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.GET_INVENTORY_SLOT_INFO));
			Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.GET_CHARACTERS));

			super.transitionIn();
		}
		
		protected function lobby_onPacketReceived(event:EventEx):void
		{
			var packet:ResponsePacket = event.data as ResponsePacket;
			switch(packet.type)
			{
				case LobbyResponseType.CONSUME_ITEM:
					onInviteMasterResult(packet as ResponseConsumeItem);
					break;
			}

		}
		
		override public function transitionOut():void
		{
			var avatar:AvatarMaster;
			for(var i:int = 0; i < avatars.length; ++i)
			{
				avatar = avatars[i];
				avatar.reset();
				containerAvatars.removeChild(avatar);
				Manager.pool.push(avatar, AvatarMaster);
			}
			avatars.splice(0);
			
			Game.network.lobby.removeEventListener(Server.SERVER_DATA, lobby_onPacketReceived);
			
			super.transitionOut();
		}
		
		private function inviteMaster():void
		{
			var item:Item = data as Item;
			
			if(item != null)
			{
				if (Game.database.userdata.getNumFreeSlots() > 0)
				{
					Game.network.lobby.sendPacket(new RequestUseItems(item.itemXML.type.ID,item.xmlData.ID, 1));
				} else
				{
					Manager.display.showMessage("Số lượng đồng đội đã đầy ^_^");
				}
			}
		}

		private function roll(index:int):void
		{
			btnInvite.visible = false;

			var scaleFactor:Number = 1.1;
			selectedAvatar = avatars[index];
			var newX:int = selectedAvatar.x + (selectedAvatar.width - selectedAvatar.width*scaleFactor)/2;
			var newY:int = selectedAvatar.y + (selectedAvatar.height - selectedAvatar.height*scaleFactor)/2;
			selectedAvatar.save();

			TweenLite.to(selectedAvatar, .3, {x:newX, y: newY, scaleX:scaleFactor, scaleY:scaleFactor, glowFilter:{color:0xFFFF33, alpha:1, blurX:20, blurY:20, strength:2, quality:3}, onComplete:zoomInComplete});
		}

		private function zoomInComplete():void
		{
			btnReceive.visible = true;
		}
		
		private function onInviteMasterResult(packet:ResponseConsumeItem):void
		{
			switch(packet.errorCode)
			{
				case ErrorCode.SUCCESS:
					roll(packet.indexes[0]);
					break;
				case ErrorCode.FAIL:
					Manager.display.showMessage("Số lượng đồng đội đã đầy ^_^");
					break;
			}
		}
	}
}