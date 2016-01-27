package game.ui.formation_type
{
	import core.display.ModuleBase;
	import core.event.EventEx;
	import core.Manager;
	import core.util.Utility;
	import flash.events.Event;
	import game.data.model.UserData;
	import game.enum.InventoryMode;
	import game.Game;
	import game.net.IntRequestPacket;
	import game.net.IntResponsePacket;
	import game.net.lobby.LobbyRequestType;
	import game.net.lobby.LobbyResponseType;
	import game.net.lobby.response.ResponseListFormationType;
	import game.net.RequestPacket;
	import game.net.ResponsePacket;
	import game.net.Server;
	import game.ui.change_formation.ChangeFormationModule;
	import game.ui.formation.FormationModule;
	import game.ui.formation.FormationView;
	import game.ui.formation_type.gui.FormationTypeContent;
	import game.ui.formation_type.gui.FormationTypeItem;
	import game.ui.hud.HUDModule;
	import game.ui.ModuleID;
	
	/**
	 * ...
	 * @author anhtinh/chuongth2
	 */
	public class FormationTypeModule extends ModuleBase
	{
		public static const CLOSE_FORMATION_TYPE_VIEW:String = "close_Formation_Type_View";
		
		public function FormationTypeModule()
		{
			//relatedModuleIDs = [ModuleID.FORMATION];
		}
		
		override protected function createView():void
		{
			super.createView();
			baseView = new FormationTypeView();
			baseView.addEventListener(CLOSE_FORMATION_TYPE_VIEW, closeFormationTypeViewHandler);
			baseView.addEventListener(FormationTypeContent.EVENT_UPGRADE_FORMATION_TYPE, upgradeFormationTypeHandler);
		}
		
		private function upgradeFormationTypeHandler(e:EventEx):void
		{
			var obj:Object = e.data as Object;
			if (!obj)
				return;
			var nID:int = obj.nID;
			if (nID > 0)
			{
				Game.network.lobby.sendPacket(new IntRequestPacket(LobbyRequestType.UPGRADE_FORMATION_TYPE, nID));
			}
		
		}
		
		private function closeFormationTypeViewHandler(e:Event):void
		{
			//update ten tran hinh đang chọn
			var module:ChangeFormationModule = Manager.module.getModuleByID(ModuleID.CHANGE_FORMATION) as ChangeFormationModule;
			if (module != null)
			{
				module.update();
			}
			Manager.display.hideModule(ModuleID.FORMATION_TYPE);
		}
		
		override protected function preTransitionIn():void
		{
			super.preTransitionIn();
			FormationTypeView(baseView).reset();
		}
		
		override protected function transitionIn():void
		{
			super.transitionIn();
			Game.network.lobby.addEventListener(Server.SERVER_DATA, onLobbyServerData);
			Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.LIST_FORMATION_TYPE));
		}
		
		override protected function onTransitionInComplete():void
		{
			super.onTransitionInComplete();
		}
		
		override protected function onTransitionOutComplete():void
		{
			super.onTransitionOutComplete();
			Game.network.lobby.removeEventListener(Server.SERVER_DATA, onLobbyServerData);
		}
		
		private function onLobbyServerData(e:EventEx):void
		{
			var packet:ResponsePacket = ResponsePacket(e.data);
			if (!packet)
				return;
			switch (packet.type)
			{
				case LobbyResponseType.ACTIVE_FORMATION_TYPE: 
					onActiveFormationTypeResponse(packet as IntResponsePacket);
					break;
				case LobbyResponseType.UPGRADE_FORMATION_TYPE: 
					onUpgradeFormationTypeResponse(packet as IntResponsePacket);
					break;
				case LobbyResponseType.LIST_FORMATION_TYPE: 
					onReceiveListFormationType(packet as ResponseListFormationType);
					break;
			}
		}
		
		private function onReceiveListFormationType(responseListFormationType:ResponseListFormationType):void
		{
			if (responseListFormationType)
			{
				//Game.database.userdata.arrFormationType = responseListFormationType.formationTypes;
				FormationTypeView(baseView).init();
			}
		}
		
		private function onActiveFormationTypeResponse(intResponsePacket:IntResponsePacket):void
		{
			switch (intResponsePacket.value)
			{
				case 0: //success
					FormationTypeView(baseView).activeStatusFormationTypeContainer(true);
					Manager.display.showMessage("Kích hoạt trận hình thành công!");
					notifyHeroicLobby();
					break;
				case 1: //error
					break;
				case 2: //remove success
					FormationTypeView(baseView).activeStatusFormationTypeContainer(false);
					Manager.display.showMessage("Tháo kích hoạt trận hình thành công!");
					notifyHeroicLobby();
					break;
			}
		}
		
		private function onUpgradeFormationTypeResponse(intResponsePacket:IntResponsePacket):void
		{
			
			Utility.log("onUpgradeFormationTypeResponse : " + intResponsePacket.value);
			switch (intResponsePacket.value)
			{
				case 0: //thanh cong
					FormationTypeView(baseView).preShowContent();
					Manager.display.showMessageID(21);
					notifyHeroicLobby();
					break;
				case 1: //that bai
					Manager.display.showMessageID(22);
					break;
				case 2: //thieu bac
					Manager.display.showMessageID(26);
					break;
				case 3: //maxlevel : reach to account level
					Manager.display.showMessageID(27);
					break;
				case 4: //thieu item
					Manager.display.showMessageID(68);
					break;
				case 5: //no rate
					Manager.display.showMessageID(69);
					break;
				default: 
					Manager.display.showMessageID(22);
			}
		}
		
		private function notifyHeroicLobby():void
		{
			if (Manager.display.checkVisible(ModuleID.HEROIC_LOBBY))
			{
				Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.NOTIFY_JOIN_ROOM_READY));
			}
		}

		//TUTORIAL
		public function showHint():void
		{
			if(baseView)
				FormationTypeView(baseView).showHint();
		}
	}

}