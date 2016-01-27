package game.ui.character_info 
{
	import core.Manager;
	import core.display.ModuleBase;
	import core.event.EventEx;
	
	import game.Game;
	import game.data.model.Character;
	import game.data.model.UserData;
	import game.data.model.shop.ShopItem;
	import game.net.IntRequestPacket;
	import game.net.lobby.LobbyRequestType;
	import game.ui.ModuleID;
	
	/**
	 * ...
	 * @author MaiPTT
	 */
	public class CharacterInfoModule extends ModuleBase 
	{
		public function CharacterInfoModule() {
			
		}
		
		override protected function createView():void {
			super.createView();
			baseView = new CharacterInfoView();
			baseView.addEventListener(CharacterInfoView.CHARACTER_INFO_EVENT, onViewEventHdl);
		}
		
		private function onViewEventHdl(e:EventEx):void {
			switch(e.data.type) {
				case CharacterInfoView.CLOSE:
					Manager.display.hideModule(ModuleID.CHARACTER_INFO);
					break;
			}
		}
		
		override protected function preTransitionIn():void {
			super.preTransitionIn();
			Game.database.userdata.addEventListener(UserData.UPDATE_CHARACTER_INFO, onDetailCharacterChanged);
			Game.network.lobby.sendPacket(new IntRequestPacket(LobbyRequestType.GET_CHARACTER_INFO, int(extraInfo)));
		}
		
		override protected function transitionOut():void {
			super.transitionOut();
			Game.database.userdata.removeEventListener(UserData.UPDATE_CHARACTER_INFO, onDetailCharacterChanged);
		}
		
		private function onDetailCharacterChanged(e:EventEx):void {
			(CharacterInfoView) (baseView).model = e.data as Character;
		}
	}

}