package game.ui.tutorial.scenes 
{
	import core.display.layer.Layer;
	import core.display.layer.LayerManager;
	import core.display.ViewBase;
	import core.event.EventEx;
	import core.Manager;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import game.data.model.Character;
	import game.data.vo.skill.Skill;
	import game.enum.SkillType;
	import game.Game;
	import game.ui.character_enhancement.CharacterEnhancementModule;
	import game.ui.character_enhancement.CharacterEnhancementView;
	import game.ui.dialog.DialogID;
	import game.ui.inventory.InventoryModule;
	import game.ui.inventory.InventoryView;
	import game.ui.ModuleID;
	import game.ui.tutorial.TutorialEvent;
	/**
	 * ...
	 * @author MaiPTT
	 */
	public class TutorialScene6 extends BaseScene 
	{
		
		public function TutorialScene6() {
			super(6);
			sceneName = "Thang cap ky nang";
			init();
		}
		
		override public function start():void {
			super.start();
			for each (var char:Character in Game.database.userdata.characters) {
				if (char) {
					if (char.skills) {
						for each (var skill:Skill in char.skills) {
							if (skill && skill.isEquipped && skill.level > 1) {
								stepID = 100;
								log(1, stepID);
								onComplete();
								return;
							}
						}
					}
				}
			}
			Manager.display.hideDialog(DialogID.UPGRADE_INFO);
			Manager.display.hideDialog(DialogID.UP_STAR);
			if (!Manager.display.checkVisible(ModuleID.CHARACTER_ENHANCEMENT)) {
				gotoAndStop("empty");
				setConversation(1, function callback():void {
					var inventoryModule:InventoryModule = Manager.module.getModuleByID(ModuleID.INVENTORY_UNIT) as InventoryModule;
					inventoryModule.addEventListener(ViewBase.TRANSITION_IN_COMPLETE, onInventoryTransIn);
					Manager.display.showModule(ModuleID.INVENTORY_UNIT, new Point(80, 106), LayerManager.LAYER_POPUP, "top_left", Layer.BLOCK_BLACK, null, true);	
				});
			} else {
				onCharacterEnhancementModuleTransIn(null);		
			}
		}
		
		override protected function onTutorialEventHdl(e:EventEx):void {
			super.onTutorialEventHdl(e);
			if (Manager.tutorial.getCurrentTutorialID() != sceneID) {
				return;
			}
			
			var char:Character;
			switch(e.data.type) {
				case TutorialEvent.CHARACTER_ENHANCE_CHANGE_TAB:
					if (e.data.tab == CharacterEnhancementView.SKILL_UPGRADE) {
						gotoAndStop("select-char");
						for each (char in Game.database.userdata.characters) {
							if (char && char.getEquipSkill(SkillType.ACTIVE)) {
								var inventoryView:InventoryView = Manager.module.getModuleByID(ModuleID.INVENTORY_UNIT).baseView as InventoryView;
								if (inventoryView) {
									log(1, stepID);
									increaseStepID();
									inventoryView.resetFilter();
									inventoryView.showDbClickTutArrow(char.ID);
									return;
								} else {
									log(0, stepID);
								}
							}
						}
					}
					break;
					
				case TutorialEvent.SKILL_UPGRADE_CHAR_SELECTED:
					inventoryView = Manager.module.getModuleByID(ModuleID.INVENTORY_UNIT).baseView as InventoryView;
					if (inventoryView) {
						inventoryView.showDbClickTutArrow(-1);
					}
					char = Game.database.userdata.getCharacter(e.data.slotID as int);
					if (char) {
						var skill:Skill = char.getEquipSkill(SkillType.ACTIVE);
						if (skill) {
							if (skill.level < char.level) {
								log(1, stepID);
								increaseStepID();
								gotoAndStop("expand-skill-info");	
							} else {
								Manager.display.showMessage("Nhân vật đã đạt cấp kỹ năng tối đa, hãy chọn nhân vật khác");
							}
							break;
						} else {
							skill = char.getEquipSkill(SkillType.PASSIVE);
							if (skill) {
								if (skill.level < char.level) {
									log(1, stepID);
									increaseStepID();
									gotoAndStop("expand-passive-skill-info");	
								} else {
									Manager.display.showMessage("Nhân vật đã đạt cấp kỹ năng tối đa, hãy chọn nhân vật khác");
								}
								break;
							}
						}
					}
					break;
					
				case TutorialEvent.EXPAND_SKILL_INFO:
					if (currentLabel == "expand-skill-info") {
						gotoAndStop("show-item");
					} else if (currentLabel == "expand-passive-skill-info") {
						gotoAndStop("show-item-passive");
					}
					if (!hasEventListener(MouseEvent.CLICK)) {
						addEventListener(MouseEvent.CLICK, onMouseClickHdl);
					}
					break;
					
				case TutorialEvent.UPGRADE_SKILL_SUCCESS:
					setConversation(0, function callbackFunc():void {
						gotoAndStop("empty");
						onComplete();
					});
					break;
			}
		}
		
		private function onMouseClickHdl(e:MouseEvent):void {
			removeEventListener(MouseEvent.CLICK, onMouseClickHdl);
			if (currentLabel == "show-item") {
				gotoAndStop("upgrade");	
			} else if (currentLabel == "show-item-passive") {
				gotoAndStop("upgrade-passive");
			}
		}
		
		private function onCharacterEnhancementModuleTransIn(e:Event):void {
			stepID = 1;
			log(1, stepID);
			increaseStepID();
			gotoAndStop("select-tab");	
		}
		
		private function onInventoryTransIn(e:Event):void {
			var characterEnhancementModule:CharacterEnhancementModule = Manager.module.getModuleByID(ModuleID.CHARACTER_ENHANCEMENT) as CharacterEnhancementModule;
			characterEnhancementModule.addEventListener(ViewBase.TRANSITION_IN_COMPLETE, onCharacterEnhancementModuleTransIn);
			Manager.display.showModule(ModuleID.CHARACTER_ENHANCEMENT, new Point(), LayerManager.LAYER_POPUP, "top_left", Layer.NONE, null, true);
		}
	}

}