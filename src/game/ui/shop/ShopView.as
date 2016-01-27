package game.ui.shop 
{
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import core.Manager;
	import core.display.ViewBase;
	import core.display.layer.LayerManager;
	
	import game.ui.ModuleID;
	import game.utility.UtilityUI;
	
	/**
	 * ...
	 * @author MaiPTT
	 */
	public class ShopView extends ViewBase 
	{
		public var btnBack			:SimpleButton;
		public var movShopHeroes	:ShopHeroes;
		
		public function ShopView() {
			addEventListener(Event.ADDED_TO_STAGE, onInit);
		}
		
		override public function transitionIn():void {
			super.transitionIn();
			movShopHeroes.transitionIn();
		}
		
		override public function transitionOut():void {
			super.transitionOut();
			movShopHeroes.transitionOut();
		}
		
		private function onInit(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, onInit);
			
			btnBack = UtilityUI.getComponent(UtilityUI.BACK_BTN) as SimpleButton;
			var btnBackPos:Point = UtilityUI.getComponentPosition(UtilityUI.BACK_BTN) as Point;
			btnBack.x = btnBackPos.x;
			btnBack.y = btnBackPos.y;
			addChild(btnBack);
			
			btnBack.addEventListener(MouseEvent.CLICK, onBtnClickHdl);
		}
		
		private function onBtnClickHdl(e:MouseEvent):void {
			Manager.display.hideModule(ModuleID.SHOP);
			Manager.display.showModule(ModuleID.HUD, new Point(0, 0), LayerManager.LAYER_HUD,
				"top_left");	
		}
		
	}

}