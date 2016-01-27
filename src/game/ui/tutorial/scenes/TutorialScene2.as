package game.ui.tutorial.scenes 
{
	import com.greensock.TweenMax;

	import core.display.ModuleBase;

	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import core.Manager;
	import core.display.ViewBase;
	import core.display.animation.Animator;
	import core.event.EventEx;
	
	import game.Game;
	import game.net.IntRequestPacket;
	import game.net.RequestPacket;
	import game.net.lobby.LobbyRequestType;
	import game.ui.ModuleID;
	import game.ui.hud.HUDModule;
	import game.ui.hud.HUDView;
	import game.ui.tutorial.TutorialEvent;
	import game.ui.worldmap.WorldMapModule;
	import game.ui.worldmap.WorldMapView;
	import game.ui.worldmap.gui.CampaignRewardSlot;

	/**
	 * ...
	 * @author MaiPTT
	 */
	public class TutorialScene2 extends BaseScene 
	{
		private var anim			:Animator;
		private var currentTutID	:int;
		
		public function TutorialScene2() {
			super(2);
			sceneName = "Nhiem vu chinh tuyen/ Thuong ruong sao";
			anim = new Animator();
			anim.addEventListener(Animator.LOADED, onAnimLoadedHdl);
			init();
		}
		
		public function setCurrentTutID(value:int):void {
			currentTutID = value;
		}
		
		override protected function init():void {
			super.init();
			try {
				gotoAndStop("empty");	
			} catch (e:Error) {
				trace(e);
			}
		}
		
		override public function start():void {
			super.start();
			stepID = 1;
			setConversation(0, function enterCampaign():void {
				gotoAndStop("mask-mov");
				if (charDialogue) {
					addChild(charDialogue);
					TweenMax.to(charDialogue, 1.0, { scaleX:0, scaleY:0, x:30, y:220
								,onComplete: function callBack():void {
									anim.load("resource/anim/ui/fx_motinhnang.banim");
									anim.play(0, 1);
								}});
					}});
		}
		
		override public function restart():void {
			super.restart();
			stepID = 100;
			log(1, stepID);
			increaseStepID();
			setConversation(5, function callbackFunc():void {
				if (Manager.display.getCurrentModule() != ModuleID.WORLD_MAP) {
					Manager.display.to(ModuleID.WORLD_MAP);
				} else {
					var worldMapView:WorldMapView = Manager.module.getModuleByID(ModuleID.WORLD_MAP).baseView as WorldMapView;
					if (worldMapView) {
						worldMapView.showLocalMap(false);
					}
				}
				
				gotoAndStop("world-campaign");
				currentTutID = sceneID;
			});
		}
		
		override protected function onComplete():void {
			super.onComplete();
			currentTutID = -1;
			Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.GET_TUTORIAL_FINISHED_SCENE));
		}
		
		override protected function onTutorialEventHdl(e:EventEx):void {
			if (currentTutID != sceneID) {
				return;
			}
			
			switch(e.data.type) {
				case TutorialEvent.HOME_MODULE_TRANS_IN:
					var hudModule:HUDModule = Manager.module.getModuleByID(ModuleID.HUD) as HUDModule;
					if (hudModule.baseView) {
						HUDView(hudModule.baseView).setVisibleButtonHUD(["questMainBtn"], false);
					} else {
						hudModule.addEventListener(ViewBase.TRANSITION_IN_COMPLETE, onHUDViewTransInComplete);
					}
					start();
					break;
					
				case TutorialEvent.OPEN_MAIN_QUEST:
					if (currentLabel == "local-map-close") {
						gotoAndStop("empty");
						setConversation(3, function onCompleteScene():void {
							gotoAndStop("close-quest");
						});
					} else if (currentLabel == "main-quest") {
						gotoAndStop("empty");
						if (!Manager.display.checkVisible(ModuleID.QUEST_MAIN)) {
							gotoAndStop("quest-name");
							addEventListener(MouseEvent.CLICK, onMouseClickHdl);
							log(1, stepID);
							increaseStepID();
						} else {
							gotoAndStop("close-main-quest");
						}
					}
					break;
					
				case TutorialEvent.CLOSE_QUEST_PANEL:
					if (currentLabel == "close-main-quest") {
						gotoAndStop("empty");
						setConversation(2, function callbackFunc():void {
							gotoAndStop("enter-campaign");
						});
					}
					if (currentLabel == "finish") {
						gotoAndStop("empty");
						onComplete();	
					}
					break;
					
				case TutorialEvent.WORLD_CAMPAIGN_CLICK:
					gotoAndStop("world-campaign");
					log(1, stepID);
					increaseStepID();
					break;
					
				case TutorialEvent.ENTER_CAMPAIGN:
					gotoAndStop("enter-node");
					break;
					
				case TutorialEvent.ENTER_NODE:
					gotoAndStop("in-game");
					log(1, stepID);
					increaseStepID();
					break;
					
				case TutorialEvent.END_GAME:
					gotoAndStop("end-game");
					break;
					
				case TutorialEvent.GET_REWARD:
					if(worlmap.getRewardStatus(0) == CampaignRewardSlot.GIFTED)
					{
						gotoAndStop("get-reward-done");
					}
					else
					{
						gotoAndStop("get-reward");
					}
					log(1, stepID);
					increaseStepID();
					break;
					
				case TutorialEvent.GET_REWARD_DONE:
					gotoAndStop("get-reward-done");
					log(1, stepID);
					increaseStepID();
					break;
					
				case TutorialEvent.LOCAL_MAP_CLOSE:
					gotoAndStop("local-map-close");
					break;
					
				case TutorialEvent.CLOSE_QUEST:
					Game.network.lobby.sendPacket(new IntRequestPacket(LobbyRequestType.TUTORIAL_FINISHED_SCENE, sceneID));
					gotoAndStop("empty");
					break;
					
				case TutorialEvent.LEVEL_UP:
					if (Game.database.userdata.level == 3) {
						gotoAndStop("empty");
						log(1, stepID);
						increaseStepID();
						setConversation(4, function callbackFunc():void {
							if (!Manager.display.checkVisible(ModuleID.QUEST_MAIN)) {
								gotoAndStop("empty");
								onComplete();
							} else {
								gotoAndStop("finish");
							}
						});	
					}
					break;
					
			}
		}
		
		private function onMouseClickHdl(e:MouseEvent):void {
			switch(currentLabel) {
				case "quest-name":
					gotoAndStop("quest-desc");
					break;
					
				case "quest-desc":
					gotoAndStop("quest-requirement");
					break;
					
				case "quest-requirement":
					gotoAndStop("quest-reward");
					break;
					
				case "quest-reward":
					removeEventListener(MouseEvent.CLICK, onMouseClickHdl);
					gotoAndStop("close-main-quest");
					log(1, stepID);
					increaseStepID();
					break;
			}
		}
		
		private function onHUDViewTransInComplete(e:Event):void {
			var hudModule:HUDModule = e.target as HUDModule;
			if (hudModule) {
				hudModule.removeEventListener(ViewBase.TRANSITION_IN_COMPLETE, onHUDViewTransInComplete);
				if (hudModule) {
					HUDView(hudModule.baseView).setVisibleButtonHUD(["questMainBtn"], false);
				}
			}
		}
		
		private function onAnimLoadedHdl(e:Event):void {
			anim.addEventListener(Event.COMPLETE, onAnimCompleteHdl);
			anim.x = 30;
			anim.y = 220;
			addChild(anim);
		}
		
		private function onAnimCompleteHdl(e:Event):void {
			if (anim.parent) {
				anim.parent.removeChild(anim);
			}
			removeChild(charDialogue);
			var hudModule:HUDModule = Manager.module.getModuleByID(ModuleID.HUD) as HUDModule;
			if (hudModule) {
				hudModule.setVisibleButtonHUD(["questMainBtn"], true);
			}
			gotoAndStop("main-quest");	
			log(1, stepID);
			increaseStepID();
		}

		private function get worlmap():WorldMapModule
		{
			return Manager.module.getModuleByID(ModuleID.WORLD_MAP) as WorldMapModule;
		}
	}

}