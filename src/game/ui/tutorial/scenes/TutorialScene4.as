package game.ui.tutorial.scenes 
{
	import core.event.EventEx;
	import core.Manager;
	import core.util.Enum;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.utils.getDefinitionByName;
	import game.data.model.Character;
	import game.enum.Element;
	import game.Game;
	import game.ui.components.CharacterSlot;
	import game.ui.inventory.InventoryView;
	import game.ui.ModuleID;
	import game.ui.tooltip.TooltipEvent;
	import game.ui.tutorial.TutorialEvent;
	import game.ui.tutorial.TutorialSceneID;
	import game.ui.worldmap.WorldMapView;
	/**
	 * ...
	 * @author MaiPTT
	 */
	public class TutorialScene4 extends BaseScene 
	{
		private static const MAX_MATERIALS	:int = 5;
		private static const CHAR_MAX_STARS	:int = 1;
		
		public function TutorialScene4() {
			super(4);
			sceneName = "Truyen cong";
			init();
		}
		
		override public function start():void {
			super.start();
			var mainChar:Character = Game.database.userdata.mainCharacter;
			if (mainChar) {
				if (mainChar.level > 1 
					|| mainChar.exp > 0) {
						stepID = 100;
						log(1, stepID);
						onComplete();
						return;
					}
			} 
			
			if (Game.database.userdata.finishedMissions 
				&& Game.database.userdata.finishedMissions[5] > 0) {
				onComplete();
				return;
			}
			
			if (Game.database.userdata.isEXPTransfer) {
				onComplete();
				return;
			}
			
			gotoAndStop("empty");
			setConversation(0, function callbackFunc():void {
				gotoAndStop("open-transmission");
			});
		}
		
		override protected function onTutorialEventHdl(e:EventEx):void {
			super.onTutorialEventHdl(e);
			if (Manager.tutorial.getCurrentTutorialID() != sceneID) {
				return;
			}
			
			switch(e.data.type) {
				case TutorialEvent.HOME_MODULE_TRANS_IN:
					break;
					
				case TutorialEvent.POWER_TRANSFER:
					if (currentLabel == "open-transmission") {
						stepID = 1;
						log(1, stepID);
						increaseStepID();
						gotoAndStop("insert-main-char");
					}
					break;
					
				case TutorialEvent.LEVEL_UP_ENHANCEMENT:
					if (currentLabel == "insert-main-char") {
						log(1, stepID);
						increaseStepID();
						gotoAndStop("insert-materials");
						stepID = 10;
						showArrowInstruction();
					}
					break;
					
				case TutorialEvent.ADD_ENHANCEMENT_MATERIAL:
					if (currentLabel == "insert-materials") {
						log(1, stepID);
						increaseStepID();
						showArrowInstruction();
						dispatchEvent(new EventEx(TooltipEvent.HIDE_TOOLTIP, null, true));
					}
					break;
					
				case TutorialEvent.SHOW_UPGRADE_INFO:
					gotoAndStop("upgrade-info");
					break;
					
				case TutorialEvent.CLOSE_UPGRADE_INFO:
					gotoAndStop("close-upgrade-panel");
					break;
					
				case TutorialEvent.WORLD_CAMPAIGN_CLICK:
					gotoAndStop("enter-campaign");
					break;
					
				case TutorialEvent.WORLD_MAP_TRANS_IN:
					if (currentLabel == "close-upgrade") {
						var worldMapView:WorldMapView = Manager.module.getModuleByID(ModuleID.WORLD_MAP).baseView as WorldMapView;
						if (worldMapView) {
							worldMapView.showLocalMapTutorial(true);
						}
						gotoAndStop("enter-node");
					}
					break;
					
				case TutorialEvent.CLOSE_UPGRADE:
					gotoAndStop("close-upgrade");
					setConversation(1, function callbackFunc():void {
						if (!Manager.display.checkVisible(ModuleID.WORLD_MAP)) {
							Manager.display.to(ModuleID.WORLD_MAP);
						}
						else
						{
							var worldMapView:WorldMapView = Manager.module.getModuleByID(ModuleID.WORLD_MAP).baseView as WorldMapView;
							worldMapView.showLocalMapTutorial(true);
							gotoAndStop("enter-node");
						}
					});
					break;
					
				case TutorialEvent.ENHANCEMENT_SUCCESS:
					break;
					
				case TutorialEvent.ENTER_CAMPAIGN:
					gotoAndStop("enter-node");
					break;
					
				case TutorialEvent.ENTER_NODE:
					log(1, stepID);
					increaseStepID();
					gotoAndStop("in-game");
					break;
					
				case TutorialEvent.END_GAME:
					gotoAndStop("end-game");
					break;
					
				case TutorialEvent.GET_REWARD:
					log(1, stepID);
					increaseStepID();
					//gotoAndStop("open-main-quest");
					gotoAndStop("empty");
					setConversation(2, function callbackFunc():void {
						onComplete();
					});
					break;
					
				case TutorialEvent.LOCAL_MAP_CLOSE:
					break;
					
				case TutorialEvent.OPEN_MAIN_QUEST:
					if (currentLabel == "open-main-quest") {
						gotoAndStop("close-quest");	
					}
					break;
					
				case TutorialEvent.CLOSE_QUEST:
					gotoAndStop("close-quest-panel");
					break;
					
				case TutorialEvent.CLOSE_QUEST_PANEL:
					
					break;

			}
		}

		private function get materialLength():int
		{
			var materialIDs:Array = Game.uiData.getMaterialCharacterIDs();
			var materialLength:int = 0;
			for (var i:int = 0; i < materialIDs.length; i++) {
				if (materialIDs[i] > -1) {
					materialLength ++;
				}
			}

			return materialLength;
		}

		private function showArrowInstruction():void {
			var mainChar:Character = Game.database.userdata.getCharacter(Game.uiData.getMainCharacterID()) as Character;
			var materialIDs:Array = Game.uiData.getMaterialCharacterIDs();
			if (mainChar) {
				var element:Element;
				var searchingRs:Boolean = false;
				var charSlot:CharacterSlot = inventoryView.characterSlots[materialLength];
				var char:Character = charSlot.getData();
				if(materialLength < MAX_MATERIALS)
				{
					element = Enum.getEnum(Element, char.element) as Element;
					if (element.destroy != mainChar.element)
					{
						inventoryView.showDbClickTutArrowAt(materialLength);
						searchingRs = true;
					}
				}

				if (materialLength == MAX_MATERIALS
					|| ((materialLength < MAX_MATERIALS) && !searchingRs)) {
					if (inventoryView) {
						inventoryView.showDbClickTutArrow(-1);
					}
					stepID = 20;
					log(1, stepID);
					increaseStepID();
					dispatchEvent(new EventEx(TooltipEvent.HIDE_TOOLTIP, null, true));
					gotoAndStop("process-tranmission");
				} else if (materialLength == 0 && !searchingRs) {
					stepID = 200;
					log(1, stepID);
					onComplete();
				}
			}
		}

		public function get inventoryView():InventoryView
		{
			return Manager.module.getModuleByID(ModuleID.INVENTORY_UNIT).baseView as InventoryView;
		}
	}

}