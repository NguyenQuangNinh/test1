package game.ui.tutorial.scenes 
{
	import core.display.animation.Animator;
	import core.display.ViewBase;
	import core.event.EventEx;
	import core.Manager;
	import flash.events.Event;
	import game.data.gamemode.ModeDataPvE;
	import game.data.model.Character;
	import game.Game;
	import game.ui.ModuleID;
	import game.ui.tooltip.TooltipEvent;
	import game.ui.tutorial.TutorialEvent;
	import game.ui.worldmap.WorldMapModule;
	import game.ui.worldmap.WorldMapView;
	/**
	 * ...
	 * @author MaiPTT
	 */
	public class TutorialScene3 extends BaseScene 
	{
		private static const CAMPAIGN_NODE		:String = "world-campaign-";
		private static const NODE				:String = "enter-node-";
		private static const INGAME				:String = "in-game-";
		private static const END_GAME			:String = "end-game-";
		private static const CLOSE_LOCAL_MAP	:String = "close-local-map-";
		private static const OPEN_MAIN_QUEST	:String = "open-main-quest-";
		private static const CLOSE_QUEST		:String = "close-quest";
		private static const CLOSE_QUEST_PANEL	:String = "close-quest-panel-";
		
		private var playingTime				:int;
		private var animInsertFormation		:Animator;
		private var isWinMission3			:Boolean;
		
		public function TutorialScene3() {
			super(3);
			sceneName = "Trang bi nhan vat vao doi hinh";
			init();
		}
		
		override protected function init():void {
			super.init();
			
			animInsertFormation = new Animator();
		} 
		
		override public function start():void {
			super.start();
			stepID = 1;
			var numOfFormationChars:int = 0;
			if (Game.database.userdata.formation) {
				for each (var char:Character in Game.database.userdata.formation) {
					if (char) {
						numOfFormationChars ++;
					}
				}
			}
			if (numOfFormationChars > 1) {
				gotoAndStop("empty");
				onComplete();
				stepID = 100;
				log(1, stepID);
				increaseStepID();
			} else {
				if (Manager.display.getCurrentModule() != ModuleID.WORLD_MAP) {
					gotoAndStop("empty");
					setConversation(4, function callbackFunc():void {
						Manager.display.to(ModuleID.WORLD_MAP);	
					});
				}
				playingTime = 1;
				gotoAndStop(CAMPAIGN_NODE + playingTime);	
			}
		}
		
		override public function restart():void {
			gotoAndStop("empty");
			setConversation(7, function callbackFunc():void {
				gotoAndStop("restart-enter-campaign");
				playingTime = 2;
			});
		}
		
		override protected function onTutorialEventHdl(e:EventEx):void {
			if (Manager.tutorial.getCurrentTutorialID() != sceneID || isComplete) {
				return;
			}
			
			switch(e.data.type) {
				case TutorialEvent.WORLD_CAMPAIGN_CLICK:
					if (currentLabel == "restart-enter-campaign") {
						gotoAndStop("restart-world-campaign");
					}
					break;
					
				case TutorialEvent.ENTER_CAMPAIGN:
					if (currentLabel == "restart-world-campaign") {
						gotoAndStop("restart-enter-node");
					} else if (playingTime != 2) {
						gotoAndStop(NODE + playingTime);	
					}
					break;
					
				case TutorialEvent.ENTER_NODE:
					gotoAndStop(INGAME + playingTime);
					if (playingTime != 2) {
						log(1, stepID);
						increaseStepID();	
					}
					break;
					
				case TutorialEvent.END_GAME:
					if (playingTime != 2) {
						gotoAndStop(END_GAME + playingTime);
					}
					break;
					
				case TutorialEvent.GET_REWARD:
					switch(playingTime) {
						case 1:
							gotoAndStop(OPEN_MAIN_QUEST + playingTime);
							log(1, stepID);
							increaseStepID();
							break;
							
						case 2:
							var modePVE:ModeDataPvE = Game.database.userdata.getCurrentModeData() as ModeDataPvE;
							isWinMission3 = false;
							if (modePVE) {
								gotoAndStop("empty");
								if (modePVE.missionID == 3 && modePVE.result) {
									isWinMission3 = true;
									stepID = 200;
									log(1, stepID);
									increaseStepID();
									setConversation(5, function callbackFunc():void {
										gotoAndStop("formation-unlock");
									});	
								} else {
									log(1, stepID);
									increaseStepID();
									setConversation(1, function callbackFunc():void {
										gotoAndStop("formation-unlock");
									});		
								}
							}
							break;
							
						case 3:
							log(1, stepID);
							increaseStepID();
							gotoAndStop(OPEN_MAIN_QUEST + playingTime);
							break;
					}
					break;
					
				case TutorialEvent.CHANGE_FORMATION:
					if (currentLabel == "formation-unlock") {
						var numOfChar:int = 0;
						for each (var char:Character in Game.database.userdata.characters) {
							if (char) {
								numOfChar ++;
							}
						}
						if (numOfChar >= 2) {
							gotoAndStop("insert-character");
							log(1, stepID);
							increaseStepID();	
						} else {
							stepID = 300;
							onComplete();
						}
					}
					break;
					
				case TutorialEvent.UPDATE_FORMATION:
					if (e.data.length == 2) {
						dispatchEvent(new EventEx(TooltipEvent.HIDE_TOOLTIP, null, true));
						gotoAndStop("play-effect");
						log(1, stepID);
						increaseStepID();
						animInsertFormation.addEventListener(Animator.LOADED, onAnimLoadedHdl);
						animInsertFormation.load("resource/anim/ui/fx_menhkhi.banim");
					} 
					break;
					
				case TutorialEvent.CLOSE_CHANGE_FORMATION:
					if (currentLabel == "close-change-formation") {
						gotoAndStop("empty");
						if (!isWinMission3) {
							setConversation(2, function callbackFunc():void {
								if (!Manager.display.checkVisible(ModuleID.WORLD_MAP)) {
									var worldMapModule:WorldMapModule = Manager.module.getModuleByID(ModuleID.WORLD_MAP) as WorldMapModule;
									worldMapModule.addEventListener(ViewBase.TRANSITION_IN_COMPLETE, onWorldMapViewTransInComplete);
									Manager.display.to(ModuleID.WORLD_MAP);
								}
								var worldmapView:WorldMapView = Manager.module.getModuleByID(ModuleID.WORLD_MAP).baseView as WorldMapView;
								if (worldmapView) {
									worldmapView.showLocalMap(true);
									playingTime = 3;
									gotoAndStop(NODE + playingTime);
								}
							});
						} else {
							setConversation(6, function callbackFunc():void {
								onComplete();
							});
						}
					}
					break;
					
				case TutorialEvent.LOCAL_MAP_CLOSE:
					switch(playingTime) {
						case 1:
							gotoAndStop(OPEN_MAIN_QUEST + playingTime);
							break;
							
						case 3:
							gotoAndStop(OPEN_MAIN_QUEST + playingTime);
							break;
					}
					break;
					
				case TutorialEvent.OPEN_MAIN_QUEST:
					if (currentLabel == (OPEN_MAIN_QUEST + playingTime)) {
						gotoAndStop(CLOSE_QUEST);	
					}
					break;
					
				case TutorialEvent.CLOSE_QUEST:
					switch(playingTime) {
						case 1:
							playingTime = 2;
							log(1, stepID);
							increaseStepID();
							break;
							
						case 2:
							break;
							
						case 3:
							log(1, stepID);
							increaseStepID();
							break;
					}
					gotoAndStop(CLOSE_QUEST_PANEL + playingTime);
					break;
					
				case TutorialEvent.CLOSE_QUEST_PANEL:
					switch(playingTime) {
						case 1:
							gotoAndStop(CAMPAIGN_NODE + playingTime);
							break;
							
						case 2:
							gotoAndStop("empty");
							if (Game.database.userdata.finishedMissions
								&& Game.database.userdata.finishedMissions[3] > 0) {
								gotoAndStop("empty");
								setConversation(0, function callbackFunc():void {
									
								});		
							}
							break;
							
						case 3:
							gotoAndStop("empty");
							setConversation(3, function callbackFunc():void {
								onComplete();
							});
							break;
					}
					break;
					
				case TutorialEvent.LEVEL_UP:
					break;
					
				case TutorialEvent.HOME_MODULE_TRANS_IN:
					break;
			}
		}
		
		private function onWorldMapViewTransInComplete(e:Event):void {
			var worldMapModule:WorldMapModule = e.target as WorldMapModule;
			if (worldMapModule && worldMapModule.baseView) {
				worldMapModule.removeEventListener(ViewBase.TRANSITION_IN_COMPLETE, onWorldMapViewTransInComplete);
				var worldMapView:WorldMapView = worldMapModule.baseView as WorldMapView;
				worldMapView.showLocalMap(true);
				playingTime = 3;
				gotoAndStop(NODE + playingTime);
			}
		}
		
		private function onAnimLoadedHdl(e:Event):void {
			addChild(animInsertFormation);
			animInsertFormation.x = 650;
			animInsertFormation.y = 280;
			animInsertFormation.addEventListener(Event.COMPLETE, onAnimPlayCompleteHdl);
			animInsertFormation.play(0, 1);
		}
		
		private function onAnimPlayCompleteHdl(e:Event):void {
			gotoAndStop("close-change-formation");
		}
	}

}