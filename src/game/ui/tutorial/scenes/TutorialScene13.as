package game.ui.tutorial.scenes
{

	import game.enum.FormationType;
	import game.enum.GameMode;
	import game.ui.challenge_center.ChallengeCenterModule;
	import game.ui.change_formation.ChangeFormationModule;
	import game.ui.daily_task.DailyTaskModule;
	import game.ui.dialog.DialogID;
	import game.ui.dialog.DialogModule;
	import game.ui.formation_type.FormationTypeModule;
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
	public class TutorialScene13 extends BaseScene
	{
		public function TutorialScene13() {
			super(13);
			sceneName = "Trận Hình";
			init();
		}

		override public function start():void {
			stepID = 1;

			if(Game.database.userdata.level == 35)
			{
				if(Manager.display.checkVisible(ModuleID.INGAME_PVE))
				{
					ingame.addEventListener(ViewBase.TRANSITION_OUT_COMPLETE, ingameHide);
				}
				else
				{
					ingameHide(null);
				}
			}
			else
			{
				Game.network.lobby.sendPacket(new IntRequestPacket(LobbyRequestType.TUTORIAL_FINISHED_SCENE, sceneID));
				super.onComplete();
			}
		}

		private function ingameHide(event:Event):void
		{
			ingame.removeEventListener(ViewBase.TRANSITION_OUT_COMPLETE, ingameHide);
			setConversation(0, finishTalking);
		}

		private function finishTalking():void
		{
			increaseStepID();
			hud.showHint(HUDButtonID.CHANGE_FORMATION, "Click Chuột");
		}

		override protected function onTutorialEventHdl(e:EventEx):void {
			super.onTutorialEventHdl(e);
			if (Manager.tutorial.getCurrentTutorialID() != sceneID) {
				return;
			}
			
			switch(e.data.type) {
				case TutorialEvent.CHANGE_FORMATION:
					increaseStepID();
					Game.hint.hideHint();
					formation.addEventListener(ViewBase.TRANSITION_IN_COMPLETE, changeFormationShowed);
					break;
				case TutorialEvent.SELECT_FORMATION_TYPE:
					increaseStepID();
					formationType.showHint();
					break;
				case TutorialEvent.UPGRADE_FORMATION_TYPE:
					Game.hint.hideHint();
					onComplete();
					break;
			}
		}

		private function changeFormationShowed(event:Event):void
		{
			formation.showHintButton();
			formationType.addEventListener(ViewBase.TRANSITION_IN_COMPLETE, formationTypeShowed);
		}

		private function formationTypeShowed(event:Event):void
		{
			formationType.showHint();
		}

		override protected function onComplete():void
		{
			increaseStepID();
			formation.removeEventListener(ViewBase.TRANSITION_IN_COMPLETE, changeFormationShowed);
			formationType.removeEventListener(ViewBase.TRANSITION_IN_COMPLETE, formationTypeShowed);

			Game.network.lobby.sendPacket(new IntRequestPacket(LobbyRequestType.TUTORIAL_FINISHED_SCENE, sceneID));
			setConversation(1, super.onComplete);
		}

		private function get hud():HUDModule
		{
			return Manager.module.getModuleByID(ModuleID.HUD) as HUDModule;
		}

		private function get formation():ChangeFormationModule
		{
			return Manager.module.getModuleByID(ModuleID.CHANGE_FORMATION) as ChangeFormationModule;
		}

		private function get formationType():FormationTypeModule
		{
			return Manager.module.getModuleByID(ModuleID.FORMATION_TYPE) as FormationTypeModule;
		}

		private function get ingame():IngamePVEModule
		{
			return Manager.module.getModuleByID(ModuleID.INGAME_PVE) as IngamePVEModule;
		}
	}

}