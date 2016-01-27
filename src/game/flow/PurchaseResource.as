package game.flow 
{
	import core.display.layer.Layer;
	import core.event.EventEx;
	import core.Manager;
	import core.util.Utility;
	import flash.events.EventDispatcher;

	import game.Game;
	import game.enum.ItemType;
	import game.enum.PaymentType;
	import game.ui.dialog.DialogID;
	import game.ui.dialog.dialogs.YesNo;
	import game.ui.hud.HUDModule;
	import game.ui.hud.HUDView;
	import game.ui.ModuleID;
	/**
	 * ...
	 * @author TrungLNM
	 */
	public class PurchaseResource extends EventDispatcher
	{
		
		public function PurchaseResource() 
		{
			
		}
		
		public function purchase(resourceID:Object):void {
			var dialogData:Object = {};
			dialogData.title = "Thông báo";
			var acceptHdl:Function;
			switch(resourceID as int) {
				case PaymentType.GOLD.ID:
					dialogData.message = "Không có đủ bạc, các hạ có muốn đến lò luyện kim ngay bây giờ không?";
					dialogData.option = YesNo.METAL_FURNACE | YesNo.CLOSE ;
					acceptHdl = purchaseGold;
					break;
				case PaymentType.XU_NORMAL.ID:
					dialogData.message = "Không có đủ vàng, các hạ có muốn nạp thêm vàng ngay bây giờ không?";
					dialogData.option = YesNo.NAP_XU | YesNo.CLOSE ;
					acceptHdl = purchaseXu;
					break;
				//case ItemType.HONOR.ID:
					//dialogData.message = "Không có đủ vàng để mua vật phẩm, các hạ có muốn nạp thêm bây giờ không?";
					//dialogData.option = YesNo.PURCHASE | YesNo.CLOSE;
					//break;
			}
			Manager.display.showDialog(DialogID.YES_NO, acceptHdl, null, dialogData, Layer.BLOCK_BLACK);
		}
		
		private function purchaseGold(data:Object = null):void {
			var hudModule:HUDModule = Manager.module.getModuleByID(ModuleID.HUD) as HUDModule;
			var event:EventEx = new EventEx(HUDView.REQUEST_HUD_VIEW);
			event.data = ModuleID.METAL_FURNACE;
			hudModule.showHUDModule(event);
		}
		
		private function purchaseXu(data:Object = null):void {
//			Manager.display.showPopup(ModuleID.PAYMENT);
			Game.database.gamedata.loadPaymentHTML();
		}
	}

}