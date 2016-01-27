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
	import game.ui.inventory.InventoryModule;
	import game.ui.quest_daily.QuestDailyModule;
	import game.ui.soul_center.SoulCenterModule;
	import game.ui.tutorial.TutorialEvent;
	import game.utility.UtilityUI;
	/**
	 * ...
	 * @author MaiPTT
	 */
	public class TutorialScene9 extends BaseScene
	{
		private var collectedSoul:Boolean = false;
		private var mergedSoul:Boolean = false;
		private var charSelected:Boolean = false;

		public function TutorialScene9() {
			super(9);
			sceneName = "Hướng dẫn Bói Mệnh Khí";
			init();
		}

		override public function start():void {
			stepID = 1;

			if(Game.database.userdata.level == 12)
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
			hud.showHint(HUDButtonID.SOUL, "Bói Mệnh Khí");
		}
		
		override protected function onTutorialEventHdl(e:EventEx):void {
			super.onTutorialEventHdl(e);
			if (Manager.tutorial.getCurrentTutorialID() != sceneID) {
				return;
			}
			
			switch(e.data.type) {
				case TutorialEvent.OPEN_SOUL_CENTER:
					increaseStepID();
					Game.hint.hideHint();
					soul.addEventListener(ViewBase.TRANSITION_IN_COMPLETE, onSoulCenterShowed);
					break;
				case TutorialEvent.COLLECT_SOUL_CENTER:
					increaseStepID();
					collectedSoul = true;
					soul.showHintTab(1);
					break;
				case TutorialEvent.DEVINE_SOUL_CENTER:
					increaseStepID();
					soul.showHintButton();
					break;
				case TutorialEvent.TAB_CLICK_SOUL_CENTER:
					increaseStepID();
					tabClickHdl(e.data.index);
					break;
				case TutorialEvent.SOUL_DCLICK_SOUL_CENTER:
					increaseStepID();
					soul.showHintButton();
					break;
				case TutorialEvent.AUTO_MERGE_SOUL_CENTER:
					increaseStepID();
					soul.showHintButton();
					break;
				case TutorialEvent.MERGE_SOUL_CENTER:
					increaseStepID();
					mergedSoul = true;
					soul.showHintTab(2);
					break;
				case TutorialEvent.CHAR_INVENTORY_DCLICK:
					increaseStepID();
					charSelected = true;
					soul.showHintButton();
					break;
				case TutorialEvent.ATTACHED_SUCCESS_SOUL_CENTER:
					onComplete();
					break;
			}
		}

		private function tabClickHdl(index:int):void
		{
			if(mergedSoul)
			{
				if(index != 2) //Merged roi nhung click qua tab khac buoc 3 thi hint tab buoc 3
					soul.showHintTab(2);
				else
				{//Click tab Buoc 3
					if(charSelected)
					{
						soul.showHintButton();
					}
					else
					{ // Chua chon nhan vat de gan menh khi -> Chi vao character slot trong inventory
						inventory.showHintSlotByIndex();
					}
				}
			}
			else if(collectedSoul)
			{
				if(index != 1)
					soul.showHintTab(1);
				else
					soul.showHintButton();
			}
			else
			{
				soul.showHintButton();
			}
		}

		override protected function onComplete():void
		{
			increaseStepID();
			soul.removeEventListener(ViewBase.TRANSITION_IN_COMPLETE, onSoulCenterShowed);
			Game.network.lobby.sendPacket(new IntRequestPacket(LobbyRequestType.TUTORIAL_FINISHED_SCENE, sceneID));
			setConversation(1, super.onComplete);
		}

		private function onSoulCenterShowed(event:Event):void
		{
			if(mergedSoul)
			{
				soul.showHintTab(2);
			}
			else if(collectedSoul)
			{
				soul.showHintTab(1);
			}
			else
			{
				soul.showHintButton();
			}
			soul.removeEventListener(ViewBase.TRANSITION_IN_COMPLETE, onSoulCenterShowed);
		}

		private function get hud():HUDModule
		{
			return Manager.module.getModuleByID(ModuleID.HUD) as HUDModule;
		}

		private function get soul():SoulCenterModule
		{
			return Manager.module.getModuleByID(ModuleID.SOUL_CENTER) as SoulCenterModule;
		}

		private function get inventory():InventoryModule
		{
			return Manager.module.getModuleByID(ModuleID.INVENTORY_UNIT) as InventoryModule;
		}

		private function get ingame():IngamePVEModule
		{
			return Manager.module.getModuleByID(ModuleID.INGAME_PVE) as IngamePVEModule;
		}
	}

}