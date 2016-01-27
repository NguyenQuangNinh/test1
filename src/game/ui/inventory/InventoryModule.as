package game.ui.inventory 
{
	import core.display.ModuleBase;
	import core.Manager;

	import flash.utils.setTimeout;

	import game.ui.character_info.CharacterInfoView;
	import game.ui.ModuleID;
	
	import flash.events.Event;
	
	import game.Game;
	import game.data.model.Character;
	import game.data.model.UserData;
	import game.ui.home.scene.CharacterManager;
	
	/**
	 * ...
	 * @author MaiPTT
	 */
	public class InventoryModule extends ModuleBase 
	{		
		public function InventoryModule() {
			relatedModuleIDs = [ModuleID.CHARACTER_INFO];
		}
		
		override protected function createView():void {
			super.createView();
			baseView = new InventoryView();
		}	

		override protected function preTransitionIn():void {
			super.preTransitionIn();
			
			var characterInfoView:CharacterInfoView = (CharacterInfoView)(modulesManager.getModuleByID(ModuleID.CHARACTER_INFO).baseView);
			if (characterInfoView) {
				characterInfoView.x = 342;
				characterInfoView.y = 82;	
			}
		}
		
		override protected function onTransitionOutComplete():void 	{
			super.onTransitionOutComplete();
			
			Game.database.userdata.removeEventListener(UserData.UPDATE_CHARACTER_LIST, onUpdateCharacterListHdl);
			
			CharacterManager.instance.displayCharacters();
		}
		
		override protected function onTransitionInComplete():void {
			super.onTransitionInComplete();
			if (Manager.display.checkVisible(ModuleID.HOME)) {
				CharacterManager.instance.hideCharacters();	
			}
			Game.database.userdata.addEventListener(UserData.UPDATE_CHARACTER_LIST, onUpdateCharacterListHdl);

			if(currHintSlotIndex >= 0)
			{
				showHintSlotByIndex(currHintSlotIndex);
				currHintSlotIndex = -1;
			}
		}
		
		private function onLevelUpCharactersChangedHdl(e:Event):void {
			levelCharactersChanged(null);
		}
		
		public function levelCharactersChanged(character:Character):void {
			(InventoryView)(baseView).levelUpCharactersChanged(character);
		}
		
		private function onUpdateCharacterListHdl(e:Event):void {
			(InventoryView)(baseView).updateCharacterList();
		}

		//TUTORIAL
		private var currHintSlotIndex:int = -1;

		public function showHintSlotByIndex(index:int = 0):void
		{
			if(baseView)
			{
				(InventoryView)(baseView).showHintSlotByIndex(index);
			}
			else
			{ // Module chua duoc load, cho cho den khi module load xong thi hien hint
				currHintSlotIndex = index;
			}
		}

		public function showHintSlot():void
		{
			if(baseView)
			{
				(InventoryView)(baseView).showHintSlot();
			}
		}
	}

}