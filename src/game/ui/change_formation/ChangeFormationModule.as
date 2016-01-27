package game.ui.change_formation
{
	import core.display.layer.Layer;
	import core.display.layer.LayerManager;
	import core.display.ModuleBase;
	import core.Manager;
	import flash.events.Event;
	import flash.geom.Point;
	import game.enum.InventoryMode;
	import game.ui.formation.FormationModule;
	import game.ui.formation.FormationView;
	import game.ui.hud.HUDModule;
	import game.ui.inventory.InventoryView;
	import game.ui.ModuleID;
	
	/**
	 * ...
	 * @author MaiPTT
	 */
	public class ChangeFormationModule extends ModuleBase
	{
		
		public function ChangeFormationModule()
		{
			relatedModuleIDs = [ModuleID.FORMATION, ModuleID.INVENTORY_UNIT, ModuleID.CHARACTER_INFO];
		}
		
		override protected function createView():void
		{
			super.createView();
			baseView = new ChangeFormationView();
			baseView.addEventListener(ChangeFormationView.CLOSE, onViewEventHdl);
			baseView.addEventListener(ChangeFormationView.CHANGE_FORMATION_TYPE, onChangeFormationTypeHdl);
		}
		
		private function onChangeFormationTypeHdl(e:Event):void
		{
			Manager.display.showModule(ModuleID.FORMATION_TYPE, new Point(0, 0), LayerManager.LAYER_POPUP, "top_left", Layer.BLOCK_BLACK);
		}
		
		override protected function preTransitionIn():void
		{
			//(ChangeFormationView)(view).movContainer.addChild(characterInfoView);
			//(ChangeFormationView)(view).movContainer.addChild(formationTypeView);
			
			//formationView.x = 50;
			//formationView.y = 565;
			formationView.x = 495;
			formationView.y = 190;
			(FormationModule)(modulesManager.getModuleByID(ModuleID.FORMATION)).mode = InventoryMode.CHANGE_FORMATION_MODE;
			(ChangeFormationView)(baseView).addChild(formationView);
			formationView.enableChange = true;
			formationView.enableAddCharacter = true;
			//formationView.showFormationStat(true);
			
			inventoryView.x = 73;
			inventoryView.y = 105;
			(ChangeFormationView)(baseView).addChild(inventoryView);
			
			//characterInfoView.displayMode = ModuleID.INVENTORY.url;
			
			super.preTransitionIn();
			inventoryView.setMode(InventoryMode.CHANGE_FORMATION_MODE);
			inventoryView.transitionIn();
		}
		
		private function onViewEventHdl(e:Event):void
		{
			var hudModule:HUDModule = Manager.module.getModuleByID(ModuleID.HUD) as HUDModule;
			if (hudModule != null)
			{
				hudModule.updateHUDButtonStatus(ModuleID.CHANGE_FORMATION, false);
			}
			//Manager.display.hideModule(ModuleID.CHANGE_FORMATION);
		}
		
		private function get formationView():FormationView
		{
			return (FormationView)(modulesManager.getModuleByID(ModuleID.FORMATION).baseView);
		}
		
		private function get inventoryView():InventoryView
		{
			return (InventoryView)(modulesManager.getModuleByID(ModuleID.INVENTORY_UNIT).baseView);
		}
	
		//private function get characterInfoView():CharacterInfoView {
		//return (CharacterInfoView)(modulesManager.getModuleByID(ModuleID.CHARACTER_INFO).view);
		//}
	
		//private function get formationTypeView():FormationTypeView {
		//return FormationTypeView(modulesManager.getModuleByID(ModuleID.FORMATION_TYPE).view);			
		//}
		public function update():void
		{
			if(baseView)
				ChangeFormationView(baseView).update();
		}

		//TUTORIAL

		public function showHintButton():void
		{
			if(baseView)
				ChangeFormationView(baseView).showHintButton();
		}
	}

}