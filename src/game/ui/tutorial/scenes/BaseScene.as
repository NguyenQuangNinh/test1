package game.ui.tutorial.scenes 
{
	import core.event.EventEx;
	import core.Manager;
	import core.util.Utility;

	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.getTimer;
	import game.data.xml.DataType;
	import game.data.xml.TutorialXML;
	import game.Game;
	import game.net.IntRequestPacket;
	import game.net.lobby.LobbyRequestType;
	import game.ui.components.CharacterDialogue;
	import game.ui.ModuleID;
	import game.ui.top_bar.TopBarView;
	import game.ui.tutorial.TutorialEvent;
	
	/**
	 * ...
	 * @author MaiPTT
	 */
	public class BaseScene extends MovieClip 
	{
		public static const COMPLETE		:String = "scene_play_complete";
		
		public var isComplete				:Boolean;
		protected var sceneID				:int;
		protected var sceneName				:String;
		protected var xmlData				:TutorialXML;
		protected var conversations			:Array;
		protected var conversationIndex		:int;
		protected var container				:Sprite;
		protected var callbackConversation	:Function;
		protected var charDialogue			:CharacterDialogue;
		protected var timeStart				:int;
		protected var stepID				:int;
		
		public function BaseScene(id:int) {
			sceneID = id;
			isComplete = false;
			xmlData = Game.database.gamedata.getData(DataType.TUTORIAL, sceneID) as TutorialXML;
		}
		
		public function start():void {
			timeStart = getTimer();
			if (sceneID != 1 && sceneID != 2) {
				Game.network.lobby.sendPacket(new IntRequestPacket(LobbyRequestType.TUTORIAL_FINISHED_SCENE, sceneID));		
				Manager.tutorial.log(sceneID, sceneName, 0, 1, "Begin");
			}
			var topbarView:TopBarView = Manager.module.getModuleByID(ModuleID.TOP_BAR).baseView as TopBarView;
			if (topbarView) {
				topbarView.setClickEnable(false);
			}
		}
		
		public function restart():void {
			
		}
		
		protected function init():void {
			conversations = [];
			conversationIndex = -1;
			
			container = new Sprite();
			addChild(container);
			
			addEventListener(Event.ADDED_TO_STAGE, onAddToStageHdl);
		}
		
		protected function onTutorialEventHdl(e:EventEx):void {
			Utility.log("Tutorial Event >> " + e.data.type);
		}

		override public function gotoAndStop(frame:Object, scene:String = null):void
		{
			Utility.log("SceneID: " + sceneID + ", goTo: " + frame);
			super.gotoAndStop(frame, scene);
		}

		protected function setConversation(actionID:int, callbackFunc:Function):void {
			if (xmlData && xmlData.actions[actionID] != null) {
				conversations = xmlData.actions[actionID].conversations;
				setConversationIndex(0);
				callbackConversation = callbackFunc;
			}
		}
		
		protected function onComplete():void {
			if (sceneID != 1) {
				Manager.tutorial.log(sceneID, sceneName, (getTimer() - timeStart) / 1000 , 1, "End");	
			}
			var topbarView:TopBarView = Manager.module.getModuleByID(ModuleID.TOP_BAR).baseView as TopBarView;
			if (topbarView) {
				topbarView.setClickEnable(true);
			}
			isComplete = true;
			dispatchEvent(new EventEx(COMPLETE, sceneID, true));
		}
		
		protected function log(result:int, stepID:int):void {
			var action:String = sceneID + "_";
			if (stepID < 10) {
				action += "00" + stepID;
			} else if (stepID < 100) {
				action += "0" + stepID;
			} else {
				action += stepID
			}
			Manager.tutorial.log(sceneID, sceneName, (getTimer() - timeStart) / 1000, result, action);
		}
		
		protected function increaseStepID():int {
			stepID = stepID + 1;
			return stepID;
		}
		
		private function onAddToStageHdl(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, onAddToStageHdl);
			stage.addEventListener(TutorialEvent.EVENT, onTutorialEventHdl);
		}
		
		private function setConversationIndex(number:int):void {
			conversationIndex = number;
			if (conversationIndex < conversations.length) {
				var dialogue:CharacterDialogue = new CharacterDialogue();
				dialogue.setData(conversations[conversationIndex]);
				addChild(container);
				container.addChild(dialogue);
				dialogue.setCallbackFunc(function increaseIndex():void {
					charDialogue = dialogue;
					if (dialogue.parent) {
						dialogue.parent.removeChild(dialogue);
					}
					if (conversationIndex + 1 < conversations.length) {
						setConversationIndex(conversationIndex + 1);	
					} else {
						callbackConversation();
					}
				});
			} 
		}
		
	}

}