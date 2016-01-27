package game.ui.change_formation_challenge 
{
	import core.display.layer.Layer;
	import core.display.layer.LayerManager;
	import core.display.ModuleBase;
	import core.Manager;
	import core.util.Utility;
	import flash.events.Event;
	import flash.geom.Point;
	import game.ui.challenge.ChallengeModule;
	//import game.data.enum.formation.FormationTypeEnum;
	import game.data.model.Character;
	import game.enum.DialogEventType;
	import game.enum.FormationType;
	import game.enum.InventoryMode;
	import game.Game;
	import game.net.lobby.request.RequestSaveFormation;
	import game.ui.dialog.DialogID;
	import game.ui.formation.FormationModule;
	import game.ui.formation.FormationView;
	import game.ui.inventory.InventoryView;
	import game.ui.ModuleID;
	/**
	 * ...
	 * @author TrungLNM
	 */
	public class ChangeFormationChallengeModule extends ModuleBase
	{
		
		private static const INVENTORY_START_FROM_X:int = 80;
		private static const INVENTORY_START_FROM_Y:int = 105;
		private static const FORMATION_START_FROM_X:int = 530;
		private static const FORMATION_START_FROM_Y:int = 240;
		
		public function ChangeFormationChallengeModule() 
		{
			relatedModuleIDs = [ModuleID.FORMATION, ModuleID.INVENTORY_UNIT];
		}
		
		override protected function createView():void 
		{
			super.createView();
			
			baseView = new ChangeFormationChallengeView();
			baseView.addEventListener(ChangeFormationChallengeView.CLOSE_FORMATION_CHALLENGE, onViewRequestHdl);
			baseView.addEventListener(ChangeFormationChallengeView.SHOW_INFO_FORMATION_CHALLENGE, onViewRequestHdl);
			baseView.addEventListener(ChangeFormationChallengeView.REGISTER_FORMATION_CHALLENGE, onViewRequestHdl);
		}
		
		private function onViewRequestHdl(e:Event):void {
			switch(e.type) {
				case ChangeFormationChallengeView.CLOSE_FORMATION_CHALLENGE:					
					//Manager.display.hideModule(ModuleID.CHANGE_FORMATION_CHALLENGE);
					var formationChallenge:Array = Game.database.userdata.formationChallenge;
					var formationTemp:Array = Game.database.userdata.formationChallengeTemp;
					if(!checkIfMathFormation(formationChallenge, formationTemp))
						Manager.display.showDialog(DialogID.YES_NO, onAcceptHdl, null,
								{ type:DialogEventType.CONFIRM_SAVE_FORMATION_CHALLENGE } );
					else 
						onAcceptHdl();
					break;
				case ChangeFormationChallengeView.SHOW_INFO_FORMATION_CHALLENGE:
					//show dialog info
					break;
				case ChangeFormationChallengeView.REGISTER_FORMATION_CHALLENGE:
					//register formation challenge
					Utility.log("save formation challenge: ");
					//Game.database.userdata.formationChallenge = Game.database.userdata.formationChallengeTemp;
					Game.network.lobby.sendPacket(new RequestSaveFormation(FormationType.FORMATION_CHALLENGE.ID, Game.database.userdata.formationChallengeTemp));
					Manager.display.hideModule(ModuleID.CHANGE_FORMATION_CHALLENGE);
					break;
			}
		}
		
		private function checkIfMathFormation(arr1:Array, arr2:Array):Boolean 
		{
			var isMatch:Boolean;
			if(arr1.length == arr2.length) {
				for (var i:int = 0; i < arr1.length; i++) {
					/*isMatch = arr1[i] != null;
					isMatch = arr2[i] != null;
					isMatch = (arr1[i] as Character).ID != (arr2[i] as Character).ID
					if (arr1[i] && arr2[i] && (arr1[i] as Character).ID != (arr2[i] as Character).ID) {
						isMatch = false;
						break;
					}*/
					isMatch = (!arr1[i] && !arr2[i]) || (arr1[i] && arr2[i] && (arr1[i] as Character).ID == (arr2[i] as Character).ID);
					if (!isMatch)
						return isMatch;
				}
			} else {
				isMatch = false;
			}
			return isMatch;
		}
		
		private function onAcceptHdl(data:Object = null):void 
		{
			Manager.display.hideModule(ModuleID.CHANGE_FORMATION_CHALLENGE);
		}
		
		/*override protected function preTransitionIn():void {
			
			/*formationView.x = FORMATION_START_FROM_X;
			formationView.y = FORMATION_START_FROM_Y;
			(FormationModule)(modulesManager.getModuleByID(ModuleID.FORMATION)).mode = InventoryMode.CHANGE_FORMATION_CHALLENGE;
			//formationView.showFormationStat(false);
			
			inventoryView.x = INVENTORY_START_FROM_X;
			inventoryView.y = INVENTORY_START_FROM_Y;
			
			(view as ChangeFormationChallengeView).addFormationView(formationView);
			(view as ChangeFormationChallengeView).addInventoryView(inventoryView);
			
			super.preTransitionIn();
			addFormationView();
			addInventoryView();
			Manager.display.hideModule(ModuleID.HUD);
			//inventoryView.onViewTransIn(InventoryMode.CHANGE_FORMATION_CHALLENGE);
			//(FormationModule)(modulesManager.getModuleByID(ModuleID.FORMATION)).preTransitionIn();
		}*/
		
		override protected function transitionIn():void 
		{
			super.transitionIn();
			
			addFormationView();
			addInventoryView();
		}
		
		public function addFormationView():void {
			var formationView:FormationView = (FormationView)(modulesManager.getModuleByID(ModuleID.FORMATION).baseView);
			
			formationView.x = FORMATION_START_FROM_X;
			formationView.y = FORMATION_START_FROM_Y;
			(FormationModule)(modulesManager.getModuleByID(ModuleID.FORMATION)).mode = InventoryMode.CHANGE_FORMATION_CHALLENGE;
			
			(baseView as ChangeFormationChallengeView).addFormationView(formationView);
		}
		
		public function addInventoryView():void {
			var inventoryView:InventoryView = (InventoryView)(modulesManager.getModuleByID(ModuleID.INVENTORY_UNIT).baseView);
			
			inventoryView.x = INVENTORY_START_FROM_X;
			inventoryView.y = INVENTORY_START_FROM_Y;
			
			(baseView as ChangeFormationChallengeView).addInventoryView(inventoryView);
			inventoryView.setMode(InventoryMode.CHANGE_FORMATION_CHALLENGE);
			inventoryView.transitionIn();
		}
		
		/*private function get formationView():FormationView {
			return (FormationView)(modulesManager.getModuleByID(ModuleID.FORMATION).view);
		}
		
		private function get inventoryView():InventoryView {
			return (InventoryView)(modulesManager.getModuleByID(ModuleID.INVENTORY).view);
		}*/
		
		override protected function transitionOut():void 
		{
			super.transitionOut();
			Manager.display.showModule(ModuleID.CHALLENGE, new Point(0, 0), LayerManager.LAYER_POPUP);
			//(Manager.module.getModuleByID(ModuleID.CHALLENGE) as ChallengeModule).addFormationView();
		}
	}

}