package game.ui.tutorial.scenes
{

	import game.enum.GameMode;
	import game.ui.challenge_center.ChallengeCenterModule;
	import game.ui.daily_task.DailyTaskModule;
	import game.ui.dialog.DialogID;
	import game.ui.dialog.DialogModule;
	import game.ui.heroic.lobby.HeroicLobbyModule;
	import game.ui.heroic.world_map.HeroicMapModule;
	import game.ui.heroic_tower.HeroicTowerModule;
	import game.ui.home.HomeModule;
	import game.ui.ingame.pve.IngamePVEModule;
	import game.ui.quest_transport.QuestTransportModule;
	import game.ui.tutorial.TutorialEvent;
	import game.ui.tutorial.scenes.*;

	import core.display.ViewBase;
	import core.event.EventEx;
	import core.Manager;
	import core.util.FontUtil;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.utils.setTimeout;

	import game.enum.Font;
	import game.Game;
	import game.net.IntRequestPacket;
	import game.net.lobby.LobbyRequestType;
	import game.ui.ModuleID;
	import game.ui.hud.HUDButtonID;
	import game.ui.hud.HUDModule;
	import game.ui.inventory.InventoryModule;
	import game.ui.worldmap.WorldMapModule;

	/**
	 * ...
	 * @author MaiPTT
	 */
	public class TutorialScene12 extends BaseScene
	{
		public function TutorialScene12() {
			super(12);
			sceneName = "Leo Tháp";
			init();
		}

		override public function start():void {
			stepID = 1;

			if(Game.database.userdata.level == 24)
			{
				if(Manager.display.checkVisible(ModuleID.HOME))
				{
					homeShowed(null);
				}
				else if(Manager.display.checkVisible(ModuleID.WORLD_MAP))
				{
					worldmap.showHintBtn();
					home.addEventListener(ViewBase.TRANSITION_IN_COMPLETE, homeShowed);
				}
				else
				{
					home.addEventListener(ViewBase.TRANSITION_IN_COMPLETE, homeShowed);
				}
			}
			else
			{
				Game.network.lobby.sendPacket(new IntRequestPacket(LobbyRequestType.TUTORIAL_FINISHED_SCENE, sceneID));
				super.onComplete();
			}
		}

		private function finishTalking():void
		{
			if(Manager.display.checkVisible(ModuleID.DAILY_TASK))
			{
				dailyTask.showHint(4);//Hint Thap Cao Thu
			}
			else
			{
				hud.showHint(HUDButtonID.DAILY_TASK, "Click chuột");
			}

			challenge.addEventListener(ViewBase.TRANSITION_IN_COMPLETE, challengeShowed);
			tower.addEventListener(ViewBase.TRANSITION_IN_COMPLETE, towerShowed);
		}

		private function homeShowed(event:Event):void
		{
			home.removeEventListener(ViewBase.TRANSITION_IN_COMPLETE, homeShowed);
			setConversation(0, finishTalking);
		}

		override protected function onTutorialEventHdl(e:EventEx):void {
			super.onTutorialEventHdl(e);
			if (Manager.tutorial.getCurrentTutorialID() != sceneID) {
				return;
			}
			
			switch(e.data.type) {
				case TutorialEvent.OPEN_DAILY_TASK:
					increaseStepID();
					Game.hint.hideHint();
					dailyTask.addEventListener(ViewBase.TRANSITION_IN_COMPLETE, dailyTaskOpened);
					break;
				case TutorialEvent.CLICK_DAILY_TASK:
					increaseStepID();
					Game.hint.hideHint();
					break;
				case TutorialEvent.OPEN_HEROIC_TOWER_ITEM_DLG:
					increaseStepID();
					dialog.showHint(DialogID.HEROIC_TOWER_ITEM);
					break;
				case TutorialEvent.START_GAME:
					increaseStepID();
					Game.hint.hideHint();
					onComplete();
					break;
				case TutorialEvent.END_GAME:
					increaseStepID();
					ingame.showHintEndGame("Click chuột");
					break;
				case TutorialEvent.INGAME_TRANS_OUT:
					endGameHdl();
					break;
			}
		}

		private function endGameHdl():void
		{
			increaseStepID();
			Game.hint.hideHint();
			setConversation(1, super.onComplete);
		}

		private function towerShowed(event:Event):void
		{
			tower.showHintButton();
		}

		private function challengeShowed(event:Event):void
		{
			challenge.showHintButton("Click Chuột");
		}

		override protected function onComplete():void
		{
			increaseStepID();
			home.removeEventListener(ViewBase.TRANSITION_IN_COMPLETE, homeShowed);
			dailyTask.removeEventListener(ViewBase.TRANSITION_IN_COMPLETE, dailyTaskOpened);
			challenge.removeEventListener(ViewBase.TRANSITION_IN_COMPLETE, challengeShowed);
			tower.removeEventListener(ViewBase.TRANSITION_IN_COMPLETE, towerShowed);

			Game.network.lobby.sendPacket(new IntRequestPacket(LobbyRequestType.TUTORIAL_FINISHED_SCENE, sceneID));
		}

		private function dailyTaskOpened(event:Event):void
		{
			dailyTask.removeEventListener(ViewBase.TRANSITION_IN_COMPLETE, dailyTaskOpened);
			dailyTask.showHint(4, "Chọn Tháp Cao Thủ");
		}

		private function get hud():HUDModule
		{
			return Manager.module.getModuleByID(ModuleID.HUD) as HUDModule;
		}

		private function get worldmap():WorldMapModule
		{
			return Manager.module.getModuleByID(ModuleID.WORLD_MAP) as WorldMapModule;
		}

		private function get home():HomeModule
		{
			return Manager.module.getModuleByID(ModuleID.HOME) as HomeModule;
		}

		private function get dailyTask():DailyTaskModule
		{
			return Manager.module.getModuleByID(ModuleID.DAILY_TASK) as DailyTaskModule;
		}

		private function get challenge():ChallengeCenterModule
		{
			return Manager.module.getModuleByID(ModuleID.CHALLENGE_CENTER) as ChallengeCenterModule;
		}

		private function get dialog():DialogModule
		{
			return Manager.module.getModuleByID(ModuleID.DIALOG) as DialogModule;
		}

		private function get tower():HeroicTowerModule
		{
			return Manager.module.getModuleByID(ModuleID.HEROIC_TOWER) as HeroicTowerModule;
		}

		private function get ingame():IngamePVEModule
		{
			return Manager.module.getModuleByID(ModuleID.INGAME_PVE) as IngamePVEModule;
		}
	}

}