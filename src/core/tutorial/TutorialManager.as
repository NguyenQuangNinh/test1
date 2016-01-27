package core.tutorial 
{
	import core.display.layer.LayerManager;
	import core.Manager;
	import core.util.Utility;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	import game.data.model.Character;
	import game.data.model.UserData;
	import game.data.xml.DataType;
	import game.data.xml.TutorialXML;
	import game.enum.ItemType;
	import game.enum.LogType;
	import game.enum.TutorialTriggerType;
	import game.Game;
	import game.net.IntRequestPacket;
	import game.net.lobby.LobbyRequestType;
	import game.net.lobby.request.RequestLogTutorial;
	import game.ui.ModuleID;
	import game.ui.tutorial.TutorialModule;
	import game.ui.tutorial.TutorialView;
	/**
	 * ...
	 * @author MaiPTT
	 */
	public class TutorialManager 
	{
		public var tutorialIngame	:TutorialIngame;
		private var stage					:Stage;
		private var currentTutorialID		:int = -1;
		private var nextTutorialID			:int;
		private var triggerRestartScene3	:Boolean;
		private var _playingTutorial:Boolean = false;

		public function TutorialManager(stage:Stage) {
			this.stage = stage;
			tutorialIngame = new TutorialIngame(stage);
			triggerRestartScene3 = false;
		}
		
		public function updateFinishIDs():void {
			var finishTutorialScenes:Array = Game.database.userdata.getFinishTutorialScenes();
			if (finishTutorialScenes.length == 0) {
				finishTutorialScenes = [1];
				Game.database.userdata.updateFinishTutorialID(1);
			}
			var nextSceneID:int = -1;
			if (finishTutorialScenes[finishTutorialScenes.length - 1] != null) {
				nextSceneID = finishTutorialScenes[finishTutorialScenes.length - 1] + 1;
			}

			var tutorialXMLDict:Dictionary = Game.database.gamedata.getTable(DataType.TUTORIAL);
			if (nextSceneID > -1) {
				for each (var tutorialXML:TutorialXML in tutorialXMLDict) {
					if (tutorialXML && (tutorialXML.sceneID == nextSceneID)) {
						if (checkTriggerCondition(tutorialXML)) {
							setCurrentTutorialID(tutorialXML.ID);
							nextTutorialID = -1;
						} else {
							nextTutorialID = tutorialXML.ID;
							_playingTutorial = false;
						}
						return;
					}
				}
			}
		}
		
		public function setCurrentTutorialID(value:int):void {
			if (value > -1 && value != currentTutorialID) {
				currentTutorialID = value;
				var module:TutorialModule = TutorialModule(Manager.module.getModuleByID(ModuleID.TUTORIAL));
				if (module && module.baseView) {
					onTutorialModuleLoaded();
				} else {
					Manager.module.load(ModuleID.TUTORIAL, onTutorialModuleLoaded);
				}
			} else if (value == -1) {
				if (Manager.display.checkVisible(ModuleID.TUTORIAL)) {
					Manager.display.hideModule(ModuleID.TUTORIAL);
				}
			}
		}
		
		public function playNextTutorial():void {
			Game.database.userdata.updateFinishTutorialID(currentTutorialID);
			var tutorialXML:TutorialXML = Game.database.gamedata.getData(DataType.TUTORIAL, currentTutorialID) as TutorialXML;
			if (tutorialXML) {
				var sceneID:int = tutorialXML.sceneID;
				var nextSceneID:int = sceneID + 1;

				_playingTutorial = false;
				currentTutorialID = -1;
				nextTutorialID = -1;
				var tutorialXMLDict:Dictionary = Game.database.gamedata.getTable(DataType.TUTORIAL);
				if (nextSceneID > -1) {
					for each (tutorialXML in tutorialXMLDict) {
						if (tutorialXML && (tutorialXML.sceneID == nextSceneID)) {
							if (checkTriggerCondition(tutorialXML)) {
								setCurrentTutorialID(tutorialXML.ID);
								nextTutorialID = -1;
							} else {
								nextTutorialID = tutorialXML.ID;
							}
							return;
						}
					}
				}
			}
		}

		public function get isPlayingTutorial():Boolean
		{
			return _playingTutorial;
		}

		public function getCurrentTutorialID():int {
			return currentTutorialID;
		}
		
		public function onTriggerCondition():void {
			var tutorialXML:TutorialXML = Game.database.gamedata.getData(DataType.TUTORIAL, nextTutorialID) as TutorialXML;
			if (tutorialXML) {
				if (checkTriggerCondition(tutorialXML)) {
					setCurrentTutorialID(tutorialXML.ID);
				}
			}
		}
		
		public function log(sceneID:int, sceneName:String, duration:int, result:int, subScene:String):void {
			Utility.log("Log Tutorial > SceneID: " + sceneID + "(" + sceneName + ")"
					+ " \n \t SubScene: " + subScene
					+ " \n \t Duration: " + duration + "(s)" 
					+ " \n \t Result: " + result);
			
			var packetRequest:RequestLogTutorial = new RequestLogTutorial(sceneID, sceneName, duration, result, subScene);
			Game.network.lobby.sendPacket(packetRequest);
		}
		
		private function checkTriggerCondition(tutorialXML:TutorialXML):Boolean {
			switch(tutorialXML.triggerConditionType) {
				case TutorialTriggerType.NONE.enum:
					return true;
					break;
					
				case TutorialTriggerType.ACC_LEVEL_UP.enum:
					if (Game.database.userdata.level >= tutorialXML.triggerConditionValue) {
						return true;
					}
					break;
					
				case TutorialTriggerType.CHAR_LEVEL_UP.enum:
					for each (var char:Character in Game.database.userdata.characters) {
						if (char) {
							if (char.isEvolvable() || (!char.isMystical() && char.currentStar > 0)) {
								return true;	
							}
						}
					}
					break;
					
				case TutorialTriggerType.NEXT_LOOSE_END_GAME.enum: //cheat: level = 5, scene 4
					if (Utilities.getElementIndex(Game.database.userdata.getFinishTutorialScenes(),
						tutorialXML.triggerConditionValue) != -1) {
							if (Game.database.userdata.getCurrentModeData()
							&& Game.database.userdata.getCurrentModeData().result == false
							&& Game.database.userdata.finishedMissions 
							&& Game.database.userdata.finishedMissions[4] > 0
							&& Game.database.userdata.level >= 5) {
								return true;
							} 
							if (Game.database.userdata.finishedMissions) {
								if (Game.database.userdata.finishedMissions[5] > 0) {
									return true;	
								}
								
								if (!Game.database.userdata.finishedMissions[3]
									&& Game.database.userdata.finishedMissions[2] > 0
									&& Manager.display.checkVisible(ModuleID.HOME)) { //restart step 3
									currentTutorialID = 3;
									var module:TutorialModule = TutorialModule(Manager.module.getModuleByID(ModuleID.TUTORIAL));
									if (module && module.baseView) {
										restartStep3();
									} else {
										Manager.module.load(ModuleID.TUTORIAL, restartStep3);
									}
								}
							}
							if (Game.database.userdata.mainCharacter) {
								if (Game.database.userdata.mainCharacter.exp > 0
								|| Game.database.userdata.mainCharacter.level > 1) {
									return true;
								}
							}
							if (Game.database.userdata.isEXPTransfer) {
								return true;
							}
						}
					break;
					
				case TutorialTriggerType.PREV_SCENE_COMPLETE.enum:
					if (Utilities.getElementIndex(Game.database.userdata.getFinishTutorialScenes(),
						tutorialXML.triggerConditionValue) != -1) {
							return true;
						}
					break;
					
				case TutorialTriggerType.UP_STAR.enum: //required sceneID: 5
					if (Utilities.getElementIndex(Game.database.userdata.getFinishTutorialScenes(),
						5) != -1) {
							var tutorialView:TutorialView = Manager.module.getModuleByID(ModuleID.TUTORIAL).baseView as TutorialView;
							if (tutorialView) {
								if (!tutorialView.getSceneFinished(5)) {
									return false;
								}
							}
							
							for each (char in Game.database.userdata.characters) {
								if (char) {
									if (!char.isLegendary() && char.currentStar > 0
										&& (Game.database.inventory.getItemsByType(ItemType.SKILL_SCROLL).length > 0)) {
										return true;	
									}
								}
							}
						}
					break;
					
				case TutorialTriggerType.OCCUR_ONCE.enum:
					if (Utilities.getElementIndex(Game.database.userdata.getFinishTutorialScenes()
						, tutorialXML.triggerConditionValue) == -1) {
						return true;
					}
					break;
			}
			return false;
		}
		
		private function restartStep3():void {
			if (!triggerRestartScene3) {
				triggerRestartScene3 = true;
				Manager.display.showModule(ModuleID.TUTORIAL, new Point(), LayerManager.LAYER_MESSAGE, "top_left");
				TutorialModule(Manager.module.getModuleByID(ModuleID.TUTORIAL)).restart(3);	
			}
		}
		
		private function onTutorialModuleLoaded():void {
			_playingTutorial = true;
			Manager.display.showModule(ModuleID.TUTORIAL, new Point(), LayerManager.LAYER_MESSAGE, "top_left");
			TutorialModule(Manager.module.getModuleByID(ModuleID.TUTORIAL)).setTutorialScene(currentTutorialID);
		}
	}

}