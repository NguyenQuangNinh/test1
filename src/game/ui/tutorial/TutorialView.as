package game.ui.tutorial 
{
	import core.display.ViewBase;
	import core.event.EventEx;
	import core.Manager;
	import flash.utils.Dictionary;
	import game.Game;
	import game.ui.tutorial.scenes.BaseScene;
	import game.ui.tutorial.scenes.TutorialScene1;
	import game.ui.tutorial.scenes.TutorialScene10;
	import game.ui.tutorial.scenes.TutorialScene11;
	import game.ui.tutorial.scenes.TutorialScene12;
	import game.ui.tutorial.scenes.TutorialScene13;
	import game.ui.tutorial.scenes.TutorialScene2;
	import game.ui.tutorial.scenes.TutorialScene3;
	import game.ui.tutorial.scenes.TutorialScene4;
	import game.ui.tutorial.scenes.TutorialScene5;
	import game.ui.tutorial.scenes.TutorialScene6;
	import game.ui.tutorial.scenes.TutorialScene7;
	import game.ui.tutorial.scenes.TutorialScene8;
	import game.ui.tutorial.scenes.TutorialScene9;


	/**
	 * ...
	 * @author MaiPTT
	 */
	public class TutorialView extends ViewBase 
	{
		private var mapping	:Dictionary;
		
		public function TutorialView() {
			mapping = new Dictionary();
			
			mapping[TutorialSceneID.SCENE_1] = new TutorialScene1();
			mapping[TutorialSceneID.SCENE_2] = new TutorialScene2();
			mapping[TutorialSceneID.SCENE_3] = new TutorialScene3();
			mapping[TutorialSceneID.SCENE_4] = new TutorialScene4();
			mapping[TutorialSceneID.SCENE_5] = new TutorialScene5();
			mapping[TutorialSceneID.SCENE_6] = new TutorialScene6();
			mapping[TutorialSceneID.SCENE_7] = new TutorialScene7();
			mapping[TutorialSceneID.SCENE_8] = new TutorialScene8();
			mapping[TutorialSceneID.SCENE_9] = new TutorialScene9();
			mapping[TutorialSceneID.SCENE_10] = new TutorialScene10();
			mapping[TutorialSceneID.SCENE_11] = new TutorialScene11();
			mapping[TutorialSceneID.SCENE_12] = new TutorialScene12();
			mapping[TutorialSceneID.SCENE_13] = new TutorialScene13();

			for each (var tutorialScene:BaseScene in mapping) {
				tutorialScene.addEventListener(BaseScene.COMPLETE, onSceneCompleteHdl);
			}
		}
		
		public function getSceneFinished(sceneID:int):Boolean {
			if (mapping[sceneID] != null) {
				return BaseScene(mapping[sceneID]).isComplete;
			}
			
			return false;
		}
		
		public function setTutorialStep(value:int):void {
			for each (var tutorialScene:BaseScene in mapping) {
				if (tutorialScene && tutorialScene.parent) {
					tutorialScene.parent.removeChild(tutorialScene);
				}
			}
			
			if (mapping[value] != null) {
				switch(value) {
					case TutorialSceneID.SCENE_1:
					case TutorialSceneID.SCENE_4:
					case TutorialSceneID.SCENE_5:
					case TutorialSceneID.SCENE_6:
					case TutorialSceneID.SCENE_8:
					case TutorialSceneID.SCENE_9:
					case TutorialSceneID.SCENE_10:
					case TutorialSceneID.SCENE_11:
					case TutorialSceneID.SCENE_12:
					case TutorialSceneID.SCENE_13:
						addChild(mapping[value]);
						BaseScene(mapping[value]).start();
						break;
						
					case TutorialSceneID.SCENE_3:
						if (Game.database.userdata.finishedMissions 
						&& Game.database.userdata.finishedMissions[1] > 0) {
							addChild(mapping[value]);
							BaseScene(mapping[value]).start();
						} else {
							addChild(mapping[TutorialSceneID.SCENE_2]);
							BaseScene(mapping[TutorialSceneID.SCENE_2]).restart();
						}
						break;
						
					case TutorialSceneID.SCENE_2:
						TutorialScene2(mapping[value]).setCurrentTutID(2);
						addChild(mapping[value]);
						break;
						
					case TutorialSceneID.SCENE_7:
						addChild(mapping[value]);
						break;
				}
			}
		}
		
		public function restart(sceneID:int):void {
			for each (var tutorialScene:BaseScene in mapping) {
				if (tutorialScene && tutorialScene.parent) {
					tutorialScene.parent.removeChild(tutorialScene);
				}
			}
			
			addChild(mapping[TutorialSceneID.SCENE_3]);
			BaseScene(mapping[TutorialSceneID.SCENE_3]).restart();
		}
		
		private function onSceneCompleteHdl(e:EventEx):void {
			var sceneID:int = e.data as int;
			var currentScene:BaseScene = mapping[sceneID];
			if (currentScene && currentScene.parent) {
				currentScene.parent.removeChild(currentScene);
			}
			
			Manager.tutorial.playNextTutorial();
			Manager.tutorial.onTriggerCondition();
		}
	}

}