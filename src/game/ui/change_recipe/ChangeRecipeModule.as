package game.ui.change_recipe
{
	import core.display.ModuleBase;
	import core.event.EventEx;
	import core.Manager;
	import core.util.Utility;

	import flash.events.Event;
	import game.Game;
	import game.data.model.Inventory;
	import game.enum.PlayerAttributeID;
	import game.net.IntRequestPacket;
	import game.net.RequestPacket;
	import game.net.lobby.LobbyRequestType;
	import game.net.lobby.LobbyResponseType;
	import game.net.lobby.response.ResponseChangeRecipe;
	import game.net.ResponsePacket;
	import game.net.Server;
	import game.net.lobby.response.ResponseExchangeInvitation;
	import game.ui.hud.HUDModule;
	import game.ui.ModuleID;
	
	/**
	 * ...
	 * @author chuongth2
	 */
	public class ChangeRecipeModule extends ModuleBase
	{
		public static const CLOSE_CHANGE_RECIPE_VIEW:String = "close_change_recipe_view";
		
		public function ChangeRecipeModule()
		{
		
		}
		
		override protected function createView():void
		{
			baseView = new ChangeRecipeView();
			baseView.addEventListener(CLOSE_CHANGE_RECIPE_VIEW, closeChangeRecipeViewHandler);
		}
		
		private function closeChangeRecipeViewHandler(e:Event):void
		{
			var hudModule:HUDModule = Manager.module.getModuleByID(ModuleID.HUD) as HUDModule;
			if (hudModule != null)
			{
				hudModule.updateHUDButtonStatus(ModuleID.CHANGE_RECIPE, false);
			}
		}
		
		override protected function preTransitionIn():void
		{
			super.preTransitionIn();
			ChangeRecipeView(baseView).reset();
		}
		
		override protected function onTransitionInComplete():void
		{
			super.onTransitionInComplete();
			Game.network.lobby.addEventListener(Server.SERVER_DATA, onLobbyServerData);
			Game.database.inventory.addEventListener(Inventory.UPDATE_ITEM, onInventoryItemUpdate);
			ChangeRecipeView(baseView).update();
		}

		private function onInventoryItemUpdate(event:Event):void
		{
			ChangeRecipeView(baseView).update();
		}
		
		override protected function onTransitionOutComplete():void
		{
			super.onTransitionOutComplete();
			Game.network.lobby.removeEventListener(Server.SERVER_DATA, onLobbyServerData);
			Game.database.inventory.removeEventListener(Inventory.UPDATE_ITEM, onInventoryItemUpdate);

		}
		
		private function onLobbyServerData(e:EventEx):void
		{
			var packet:ResponsePacket = ResponsePacket(e.data);
			if (!packet)
				return;
			switch (packet.type)
			{
				case LobbyResponseType.CHANGE_SKILL_BOOK: 
					onChangeRecipeResponse(packet as ResponseChangeRecipe);
					break;
				case LobbyResponseType.CHANGE_FORMATION_TYPE_BOOK: 
					onChangeRecipeResponse(packet as ResponseChangeRecipe);
					break;
				case LobbyResponseType.EXCHANGE_INVITATION_RESULT:
					onExchangeInviationResponse(packet as ResponseExchangeInvitation);
					break;
			}
		}

		private function onExchangeInviationResponse(packet:ResponseExchangeInvitation):void
		{
			Utility.log("onExchangeInviationResponse > errorCode: " + packet.errorCode);
			switch (packet.errorCode)
			{
				case 0: // success
					Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.GET_ITEM_INVENTORY));
					Game.network.lobby.sendPacket(new IntRequestPacket(LobbyRequestType.GET_PLAYER_INFO_ATTRIBUTE, PlayerAttributeID.XU.ID));
					ChangeRecipeView(baseView).showExchangeInvitationSuccess(packet.items);
					break;
				case 1: // fail
					break;
				case 2: //no enough money
					Manager.display.showMessage("Không đủ vàng");
					break;
				case 3: //MASTER_INVITATION_CHEST_FAIL_CONFIG
					Manager.display.showMessage("Thiết lập không hợp lệ");
					break;
				case 4: //MASTER_INVITATION_CHEST_FAIL_NOT_ENOUGH_SOURCE
					Manager.display.showMessage("Không đủ nguyên liệu");
					break;
			}
		}
		
		private function onChangeRecipeResponse(responseChangeRecipe:ResponseChangeRecipe):void
		{
			if (responseChangeRecipe)
			{
				ChangeRecipeView(baseView).resetButtonChange();
				switch (responseChangeRecipe.errorCode)
				{
					case 0: //success
						Manager.display.showMessage("Đổi bí kíp thành công");
						ChangeRecipeView(baseView).showItemChangeRecipeSuccess(responseChangeRecipe.itemID, responseChangeRecipe.itemType, responseChangeRecipe.quantity);
						break;
					case 1: //fail
						
						break;
					case 2: //no enough empty slot
						Manager.display.showMessage("Thùng đồ đã đầy");
						break;
					case 3: //no enough gold
						Manager.display.showMessage("Không đủ Bạc để đổi bí kíp");
						break;
					case 4: //item invailid
						Manager.display.showMessage("");
						break;
					case 5: //no map itemtype change recipe
						Manager.display.showMessage("Không tồn tại bí kíp trong thùng đồ");
						break;
				}
			}
		}
	}

}