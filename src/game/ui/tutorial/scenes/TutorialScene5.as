package game.ui.tutorial.scenes 
{
	import core.event.EventEx;
	import core.Manager;
	import flash.events.MouseEvent;
	import game.data.model.Character;
	import game.enum.ItemType;
	import game.Game;
	import game.ui.character_enhancement.CharacterEnhancementView;
	import game.ui.dialog.DialogID;
	import game.ui.inventory.InventoryView;
	import game.ui.ModuleID;
	import game.ui.tooltip.TooltipEvent;
	import game.ui.tutorial.TutorialEvent;
	/**
	 * ...
	 * @author MaiPTT
	 */
	public class TutorialScene5 extends BaseScene 
	{
		
		public function TutorialScene5() {
			super(5);
			sceneName = "Thang cap sao";
			init();
		}
		
		override public function start():void {
			super.start();
			for each (var char:Character in Game.database.userdata.characters) {
				if (char && !char.isMystical() && char.currentStar > 0) {
					stepID = 100;
					log(1, stepID);
					onComplete();
					return;
				}
			}
			
			if (Manager.display.checkVisible(ModuleID.CHARACTER_ENHANCEMENT)) {
				stepID = 1;
				log(1, stepID);
				increaseStepID();
				gotoAndStop("empty");
				Manager.display.hideDialog(DialogID.UPGRADE_INFO);
				setConversation(0, function callback():void {
					setConversation(1, function callbackFunc():void {
						var inventoryView:InventoryView = Manager.module.getModuleByID(ModuleID.INVENTORY_UNIT).baseView as InventoryView;
						if (inventoryView) {
							inventoryView.resetFilter();
						}
						gotoAndStop("select-tab");	
					});	
				});
			} else {
				if (Manager.display.checkVisible(ModuleID.HOME)) {
					stepID = 10;
					log(1, stepID);
					increaseStepID();
					gotoAndStop("up-star-btn");
				} else if (Manager.display.checkVisible(ModuleID.WORLD_MAP)) {
					stepID = 20;
					log(1, stepID);
					increaseStepID();
					gotoAndStop("up-star-btn");
				} else {
					gotoAndStop("empty");
					Manager.display.to(ModuleID.HOME);
				}
			}
		}
		
		override protected function onTutorialEventHdl(e:EventEx):void {
			super.onTutorialEventHdl(e);
			if (Manager.tutorial.getCurrentTutorialID() != sceneID) {
				return;
			}
			
			switch(e.data.type) {
				case TutorialEvent.HOME_MODULE_TRANS_IN:
					stepID = 30;
					log(1, stepID);
					increaseStepID();
					gotoAndStop("up-star-btn");	
					break;
					
				case TutorialEvent.POWER_TRANSFER:
					if (currentLabel == "up-star-btn") {
						setConversation(1, function callbackFunc():void {
							var inventoryView:InventoryView = Manager.module.getModuleByID(ModuleID.INVENTORY_UNIT).baseView as InventoryView;
							if (inventoryView) {
								inventoryView.resetFilter();
							}
							log(1, stepID);
							increaseStepID();
							gotoAndStop("select-tab");	
						});	
					}
					break;
					
				case TutorialEvent.CHARACTER_ENHANCE_CHANGE_TAB:
					if (e.data.tab == CharacterEnhancementView.CHARACTER_EVOLUTION) {
						gotoAndStop("insert-main-char");
						for each (var char:Character in Game.database.userdata.characters) {
							if (char && char.isEvolvable()) {
								var inventoryView:InventoryView = Manager.module.getModuleByID(ModuleID.INVENTORY_UNIT).baseView as InventoryView;
								if (inventoryView) {
									log(1, stepID);
									increaseStepID();
									inventoryView.resetFilter();
									inventoryView.showDbClickTutArrow(char.ID);
									return;
								} else {
									log(0, stepID);
									increaseStepID();
								}
							}
						}
					}
					break;
					
				case TutorialEvent.LEVEL_UP_EVOLUTION:
					dispatchEvent(new EventEx(TooltipEvent.HIDE_TOOLTIP, null, true));
					inventoryView = Manager.module.getModuleByID(ModuleID.INVENTORY_UNIT).baseView as InventoryView;
					if (inventoryView) {
						inventoryView.showDbClickTutArrow( -1);
					}
					gotoAndStop("show-item");
					if (!hasEventListener(MouseEvent.CLICK)) {
						addEventListener(MouseEvent.CLICK, function onMouseClickHdl(e:MouseEvent):void {
							if (currentLabel == "show-item") {
								gotoAndStop("show-condition");	
							} else if (currentLabel == "show-condition") {
								removeEventListener(MouseEvent.CLICK, onMouseClickHdl);	
								gotoAndStop("process-up-star");
							}
						});
					}
					break;
					
				case TutorialEvent.CHARACTER_UP_CLASS:
					log(1, stepID);
					increaseStepID();
					gotoAndStop("upgrade-info-1");
					break;
					
				case TutorialEvent.CLOSE_UP_STAR_DIALOG:
					log(1, stepID);
					increaseStepID();
					gotoAndStop("upgrade-info-2");
					break;
					
				case TutorialEvent.EVOLUTION_SUCCESS:
					break;
					
				case TutorialEvent.CLOSE_UPGRADE_INFO:
					gotoAndStop("empty");
					setConversation(2, function callbackFunc():void {
						if (Game.database.inventory.getItemsByType(ItemType.SKILL_SCROLL).length > 0) {
							setConversation(3, function ():void {
								onComplete();
							});
						} else {
							onComplete();	
						}
					});
					break;
					
				case TutorialEvent.UP_STAR_NOT_ENOUGH_ITEMS:
					stepID = 200;
					log(1, stepID);
					gotoAndStop("empty");
					onComplete();
					break;
			}
		}
	}

}