package game.ui.tutorial.scenes
{

	import flash.display.Sprite;

	import game.enum.GameMode;
	import game.ui.daily_task.DailyTaskModule;
	import game.ui.dialog.DialogID;
	import game.ui.dialog.DialogModule;
	import game.ui.heroic.lobby.HeroicLobbyModule;
	import game.ui.heroic.world_map.HeroicMapModule;
	import game.ui.home.HomeModule;
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
	public class TutorialScene11 extends BaseScene
	{
		private var masker:Sprite;

		public function TutorialScene11() {
			super(11);
			sceneName = "Anh Hùng Ải";
			init();
		}

		override public function start():void {
			stepID = 1;

			if(Game.database.userdata.level == 21)
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
				dailyTask.showHint(6);//Hint Anh Hung Ai
			}
			else
			{
				hud.showHint(HUDButtonID.DAILY_TASK, "Click chuột");
			}

			masker = new Sprite();
			masker.graphics.beginFill(0xffffff, 0);
			masker.graphics.drawRect(0, 0, Game.WIDTH, Game.HEIGHT);
			masker.graphics.endFill();

			heroicMap.addEventListener(ViewBase.TRANSITION_IN_COMPLETE, heroicMapOpened);
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
				case TutorialEvent.OPEN_CREATE_HEROIC_ROOM_DLG:
					increaseStepID();
					dialog.showHint(DialogID.HEROIC_CREATE_ROOM);
					break;
				case TutorialEvent.CLICK_CREATE_HEROIC_ROOM:
					increaseStepID();
					Game.hint.hideHint();
					lobby.addEventListener(ViewBase.TRANSITION_IN_COMPLETE, lobbyHeroicShowed);
					break;
				case TutorialEvent.INTRO_BTN_COMPLETE:
					removeEventListener(MouseEvent.CLICK, mouseClickHdl);
					removeChild(masker);
					lobby.showHintButton("Click Đổi Đội Hình");
					break;
				case TutorialEvent.CLICK_INVENTORY_BTN_HEROIC_ROOM:
					inventoryBtnClickHdl();
					break;
				case TutorialEvent.CHAR_INVENTORY_DCLICK:
					increaseStepID();
					lobby.showHintButton("Đóng");
					break;
				case TutorialEvent.INSERT_CHAR_HEROIC_ROOM:
					increaseStepID();
					inventory.showHintSlotByIndex(1);
					break;
				case TutorialEvent.START_GAME:
					increaseStepID();
					Game.hint.hideHint();
					onComplete();
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
			if(Game.database.userdata.getModeData(GameMode.PVE_HEROIC).result)
			{
				setConversation(1, super.onComplete);
			}
			else
			{
				setConversation(2, super.onComplete);
			}
		}

		private function inventoryBtnClickHdl():void
		{
			if(!inventory.baseView || !inventory.baseView.parent || !inventory.baseView.parent.visible)
			{
				inventory.showHintSlotByIndex(1);
			}
			else
			{
				lobby.showHintNode();
			}
		}

		private function lobbyHeroicShowed(event:Event):void
		{
			lobby.removeEventListener(ViewBase.TRANSITION_IN_COMPLETE, lobbyHeroicShowed);
			lobby.introButton();
			addChild(masker);
			addEventListener(MouseEvent.CLICK, mouseClickHdl);
		}

		private function mouseClickHdl(event:MouseEvent):void
		{
			lobby.introButton();
		}

		private function heroicMapOpened(event:Event):void
		{
			heroicMap.showHintNode();
		}

		override protected function onComplete():void
		{
			increaseStepID();
			home.removeEventListener(ViewBase.TRANSITION_IN_COMPLETE, homeShowed);
			dailyTask.removeEventListener(ViewBase.TRANSITION_IN_COMPLETE, dailyTaskOpened);
			heroicMap.removeEventListener(ViewBase.TRANSITION_IN_COMPLETE, heroicMapOpened);
			lobby.removeEventListener(ViewBase.TRANSITION_IN_COMPLETE, lobbyHeroicShowed);

			Game.network.lobby.sendPacket(new IntRequestPacket(LobbyRequestType.TUTORIAL_FINISHED_SCENE, sceneID));
		}

		private function dailyTaskOpened(event:Event):void
		{
			dailyTask.removeEventListener(ViewBase.TRANSITION_IN_COMPLETE, dailyTaskOpened);
			dailyTask.showHint(6, "Chọn Anh Hùng Ải");
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

		private function get inventory():InventoryModule
		{
			return Manager.module.getModuleByID(ModuleID.INVENTORY_UNIT) as InventoryModule;
		}

		private function get heroicMap():HeroicMapModule
		{
			return Manager.module.getModuleByID(ModuleID.HEROIC_MAP) as HeroicMapModule;
		}

		private function get dialog():DialogModule
		{
			return Manager.module.getModuleByID(ModuleID.DIALOG) as DialogModule;
		}

		private function get lobby():HeroicLobbyModule
		{
			return Manager.module.getModuleByID(ModuleID.HEROIC_LOBBY) as HeroicLobbyModule;
		}
	}

}