package game.ui.character_enhancement 
{

	import core.util.Utility;

	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	import game.data.vo.skill.Skill;
	import game.enum.SuggestionEnum;
	import game.net.RequestPacket;
	import game.net.ResponsePacket;
	import game.net.Server;
	import game.net.lobby.LobbyRequestType;
	import game.net.lobby.LobbyResponseType;
	import game.net.lobby.response.ResponseChangeSkillResult;
	import game.ui.character_enhancement.change_skill.ChangeSkillPanel;
	import game.ui.character_enhancement.skill_upgrade.SkillInfo;
	import game.ui.components.SuggestBoard;
	import game.utility.UtilityUI;
	
	import core.Manager;
	import core.display.ModuleBase;
	import core.display.ViewBase;
	import core.display.layer.LayerManager;
	import core.event.EventEx;
	
	import game.Game;
	import game.data.model.Character;
	import game.enum.InventoryMode;
	import game.ui.ModuleID;
	import game.ui.character_enhancement.character_evolution.CharacterEvolution;
	import game.ui.character_enhancement.character_upgrade.CharacterUpgrade;
	import game.ui.character_enhancement.skill_upgrade.SkillUpgrade;
	import game.ui.hud.HUDModule;
	import game.ui.inventory.InventoryModule;
	import game.ui.inventory.InventoryView;
	import game.ui.tutorial.TutorialEvent;
	
	/**
	 * ...
	 * @author MaiPTT
	 */
	public class CharacterEnhancementView extends ViewBase 
	{
		public static const CHARACTER_UPGRADE:int = 0;
		public static const CHARACTER_EVOLUTION:int = 1;
		public static const SKILL_UPGRADE:int = 2;
			
		public var btnCharacterUpgrade:MovieClip;
		public var btnCharacterEvolution:MovieClip;
		public var btnSkillUpgrade:MovieClip;
		public var btnClose:SimpleButton;
		public var helpBtn:SimpleButton;
		public var characterUpgrade:CharacterUpgrade;
		public var characterEvolution:CharacterEvolution;
		public var skillUpgrade:SkillUpgrade;
		public var changeSkillPanel:ChangeSkillPanel;

		public var tabGroup:TabGroup;
		
		private static const SUGGEST_START_FROM_X:int = 1080;
		private static const SUGGEST_START_FROM_Y:int = 194;
		
		private var _suggestBoard:SuggestBoard;
		
		public function CharacterEnhancementView()
		{
			btnClose.addEventListener(MouseEvent.CLICK, onCloseHdl);
			helpBtn.addEventListener(MouseEvent.CLICK, onHelpClickHdl);

			characterUpgrade.visible = false;
			characterEvolution.visible = false;
			skillUpgrade.visible = false;

			tabGroup = new TabGroup();
			tabGroup.addEventListener(TabGroup.TAB_CHANGED, tabGroup_onTabChanged);
			tabGroup.add(new Tab(btnCharacterUpgrade, characterUpgrade));
			tabGroup.add(new Tab(btnCharacterEvolution, characterEvolution));
			tabGroup.add(new Tab(btnSkillUpgrade, skillUpgrade));

			//init suggestBoard
			//_suggestBoard = new SuggestBoard();
			_suggestBoard = UtilityUI.getComponent(UtilityUI.SUGGEST_BOARD) as SuggestBoard;
			_suggestBoard.x = SUGGEST_START_FROM_X;
			_suggestBoard.y = SUGGEST_START_FROM_Y;
			addChild(_suggestBoard);

			addEventListener(SkillInfo.CHANGE_SKILL, onChangeSkillHdl);

			changeSkillPanel.hide();
			changeSkillPanel.addEventListener(ChangeSkillPanel.CLOSE, onChangePanelCloseHdl);
		}

		private function onChangePanelCloseHdl(event:EventEx):void
		{
			skillUpgrade.updateInfo(false);
		}

		private function onChangeSkillHdl(event:EventEx):void
		{
			changeSkillPanel.show(event.data as Skill);
		}
		
		private function onHelpClickHdl(e:MouseEvent):void 
		{
			/*if(!_suggestBoard.visible) {
				switch(tabGroup.getCurrentTab()) {
					case CHARACTER_UPGRADE:
						
						break;
					case CHARACTER_EVOLUTION:
						
						break;
					case SKILL_UPGRADE:
						
						break;
				}
			}*/
			_suggestBoard.visible = !_suggestBoard.visible;
		}
		
		protected function tabGroup_onTabChanged(event:Event):void
		{
			var inventoryView:InventoryView = Manager.module.getModuleByID(ModuleID.INVENTORY_UNIT).baseView as InventoryView;
			if(inventoryView != null)
			{
				switch(tabGroup.getCurrentTab())
				{
					case CHARACTER_UPGRADE:
						inventoryView.setMode(InventoryMode.LEVEL_UP_ENHANCEMENT);
						_suggestBoard.initUI(SuggestionEnum.SUGGEST_UPGRADE_CHARACTER.ID);
						_suggestBoard.visible = true;
						break;
					case CHARACTER_EVOLUTION:
						inventoryView.setMode(InventoryMode.LEVEL_UP_EVOLUTION);
						_suggestBoard.initUI(SuggestionEnum.SUGGEST_UPGRADE_STAR.ID);
						_suggestBoard.visible = true;
						break;
					case SKILL_UPGRADE:
						inventoryView.setMode(InventoryMode.UPGRADE_SKILL_MODE);
						_suggestBoard.initUI(SuggestionEnum.SUGGEST_UPGRADE_SKILL.ID);
						_suggestBoard.visible = true;
						break;
				}
				dispatchEvent(new EventEx(TutorialEvent.EVENT, { type:TutorialEvent.CHARACTER_ENHANCE_CHANGE_TAB, tab:tabGroup.getCurrentTab() }, true));
			}
		}
		
		protected function onInventoryViewLoaded(event:Event):void
		{
			var inventoryModule:InventoryModule = Manager.module.getModuleByID(ModuleID.INVENTORY_UNIT) as InventoryModule;
			if (inventoryModule && inventoryModule.baseView) {
				inventoryModule.baseView.x = 80;
				inventoryModule.baseView.y = 106;
			}	
			var module:CharacterEnhancementModule = Manager.module.getModuleByID(ModuleID.CHARACTER_ENHANCEMENT) as CharacterEnhancementModule;
			if(module.extraInfo==null)
				tabGroup.selectTab(0);
			else
				tabGroup.selectTab(module.extraInfo.tap);
		}
		
		override protected function transitionInComplete():void
		{
			var module:ModuleBase = Manager.module.getModuleByID(ModuleID.INVENTORY_UNIT);
			if (module.baseView == null) {
				module.addEventListener(ModuleBase.UI_MODULE_LOADED, onInventoryViewLoaded);
			}
			else onInventoryViewLoaded(null);
			super.transitionInComplete();

			Game.network.lobby.addEventListener(Server.SERVER_DATA, onLobbyServerReceiveHdl);

		}
		
		override protected function transitionOutComplete():void
		{
			tabGroup.selectTab(-1);
			super.transitionOutComplete();
			changeSkillPanel.hide();
			Game.network.lobby.removeEventListener(Server.SERVER_DATA, onLobbyServerReceiveHdl);
		}

		private function onLobbyServerReceiveHdl(e:EventEx):void
		{
			var packet:ResponsePacket = e.data as ResponsePacket;
			switch (packet.type)
			{
				case LobbyResponseType.CHANGE_SKILL_RESULT:
					onChangeSkillResult(packet as ResponseChangeSkillResult);
					break;
			}
		}

		private function onCloseHdl(e:MouseEvent):void
		{
			dispatchEvent(new EventEx(TutorialEvent.EVENT, { type:TutorialEvent.CLOSE_UPGRADE }, true));
			Manager.display.hideModule(ModuleID.CHARACTER_ENHANCEMENT);
			Manager.display.hideModule(ModuleID.INVENTORY_UNIT);
			var hudModule : HUDModule = Manager.module.getModuleByID(ModuleID.HUD) as HUDModule;
			if (hudModule != null)
			{
				hudModule.updateHUDButtonStatus(ModuleID.CHARACTER_ENHANCEMENT, false);
			}
		}

		private function onChangeSkillResult(packet:ResponseChangeSkillResult):void
		{
			Utility.log("onChangeSkillResult:" + packet.errorCode);
			switch (packet.errorCode)
			{
				case 0://success
					Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.GET_ITEM_INVENTORY));
					changeSkillPanel.showResult(packet.newSkillID);
					break;
				case 1://fail
					Manager.display.showMessage("Đổi kỹ năng thất bại");
					break;
				case 2://not enough money
					Manager.display.showMessageID(152);
					break;
				case 3:
					Manager.display.showMessage("Không đủ Tẩy Tủy Kinh");
					break;
				case 4:
					Manager.display.showMessage("Nhân vật không đủ cấp độ");
					break;
				case 5:
					Manager.display.showMessage("Phẩm chất nhân vật không đủ để đổi kỹ năng");
					break;
			}
		}

		public function evolveCharacter(character:Character):void
		{
			if(character != null)
			{
				tabGroup.selectTab(CHARACTER_EVOLUTION);
				Game.uiData.setMainCharacterID(character.ID);
				dispatchEvent(new EventEx(TutorialEvent.EVENT, { type:TutorialEvent.LEVEL_UP_EVOLUTION}, true));
			}
		}
	}

}