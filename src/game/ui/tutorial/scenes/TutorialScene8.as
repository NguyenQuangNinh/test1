package game.ui.tutorial.scenes 
{

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
	import game.ui.ingame.pve.IngamePVEModule;
	import game.ui.quest_daily.QuestDailyModule;
	import game.ui.tutorial.TutorialEvent;
	import game.utility.UtilityUI;
	/**
	 * ...
	 * @author MaiPTT
	 */
	public class TutorialScene8 extends BaseScene
	{
		private var finished:Boolean = false;

		public function TutorialScene8() {
			super(8);
			sceneName = "Hướng dẫn nhiệm vụ Dã Tẩu";
			init();
		}

		override public function start():void {
			stepID = 1;
			gotoAndStop("empty");

			if(Game.database.userdata.level == 10)
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
			hud.showHint(HUDButtonID.QUEST_DAILY, "Nhận nhiệm vụ");
		}
		
		override protected function onTutorialEventHdl(e:EventEx):void {
			super.onTutorialEventHdl(e);
			if (Manager.tutorial.getCurrentTutorialID() != sceneID) {
				return;
			}

			if(finished) {
				Game.hint.hideHint();
				return;
			}

			switch(e.data.type) {
				case TutorialEvent.OPEN_DAILY_QUEST:
					increaseStepID();
					Game.hint.hideHint();
					dailyQuest.addEventListener(ViewBase.TRANSITION_IN_COMPLETE, onDailyQuestShowed);
					break;
				case TutorialEvent.START_DAILY_QUEST:
					increaseStepID();
					break;
				case TutorialEvent.FINISH_DAILY_QUEST:
					onComplete();
					break;
				case TutorialEvent.HILIGHT_ACC_BAR_DAILY_QUEST:
					finished = true;
					Game.hint.hideHint();
					setConversation(1, super.onComplete);
					break;
			}
		}

		override protected function onComplete():void
		{
			increaseStepID();
			dailyQuest.removeEventListener(ViewBase.TRANSITION_IN_COMPLETE, onDailyQuestShowed);
			setTimeout(dailyQuest.showHintAccumulateBar, 2000);
			Game.network.lobby.sendPacket(new IntRequestPacket(LobbyRequestType.TUTORIAL_FINISHED_SCENE, sceneID));
		}

		private function onDailyQuestShowed(event:Event):void
		{
			increaseStepID();
			dailyQuest.showHintButton();
		}

		private function get hud():HUDModule
		{
			return Manager.module.getModuleByID(ModuleID.HUD) as HUDModule;
		}

		private function get dailyQuest():QuestDailyModule
		{
			return Manager.module.getModuleByID(ModuleID.QUEST_DAILY) as QuestDailyModule;
		}

		private function get ingame():IngamePVEModule
		{
			return Manager.module.getModuleByID(ModuleID.INGAME_PVE) as IngamePVEModule;
		}
	}

}