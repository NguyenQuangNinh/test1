package game.ui.tutorial.scenes
{

	import com.facebook.facebook_internal;

	import game.data.vo.quest_transport.MissionInfo;
	import game.enum.QuestState;
	import game.net.IntResponsePacket;
	import game.net.RequestPacket;
	import game.net.ResponsePacket;
	import game.net.Server;
	import game.net.lobby.LobbyResponseType;
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
	public class TutorialScene10 extends BaseScene
	{
		private var finished:Boolean = false;

		public function TutorialScene10() {
			super(10);
			sceneName = "Đưa Thư";
			init();
		}

		override public function start():void {
			stepID = 1;

			if(Game.database.userdata.level == 14)
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

		private function homeShowed(event:Event):void
		{
			home.removeEventListener(ViewBase.TRANSITION_IN_COMPLETE, homeShowed);
			setConversation(0, finishTalking);
			Game.network.lobby.addEventListener(Server.SERVER_DATA, onLobbyResponse);
		}

		private function finishTalking():void
		{
			increaseStepID();
			hud.showHint(HUDButtonID.QUEST_TRANSPORT, "Nhiệm vụ đưa thư");
		}
		
		override protected function onTutorialEventHdl(e:EventEx):void {
			super.onTutorialEventHdl(e);
			if (Manager.tutorial.getCurrentTutorialID() != sceneID) {
				return;
			}

			if(finished) return;

			switch(e.data.type) {
				case TutorialEvent.OPEN_TRANSPORT:
					increaseStepID();
					Game.hint.hideHint();
					transport.addEventListener(ViewBase.TRANSITION_IN_COMPLETE, transportOpened);
					break;
				case TutorialEvent.SELECT_TRANSPORT_QUEST:
				case TutorialEvent.SKIP_TRANSPORT_QUEST_SHOWED:
					transport.showHintButton();
					break;
				case TutorialEvent.CHAR_LIST_INVENTORY_UPDATED:
					charListUpdateHdl();
					break;
				case TutorialEvent.CHAR_INVENTORY_DCLICK:
					break;
				case TutorialEvent.RECEIVE_REWARD_TRANSPORT_QUEST:
					Game.hint.hideHint();
					onComplete();
					break;
			}
		}

		private function charListUpdateHdl():void
		{
			var info:MissionInfo = transport.selectedQuest;
			if(info)
			{
				switch (info.state)
				{
					case QuestState.STATE_RECEIVED:
						if(info.hasUnit())
						{
							transport.showHintButton();
						} else
						{
							inventory.showHintSlot();
						}
						break;
					case QuestState.STATE_ACTIVED:
						transport.showHintButton();
						break;
					case QuestState.STATE_FINISHED_SUCCESS:
						transport.showHintButton();
						break;
				}
			}
		}

		private function onLobbyResponse(event:EventEx):void
		{
			var packet:ResponsePacket = event.data as ResponsePacket;
			switch (packet.type)
			{
				case LobbyResponseType.TUTORIAL_RESPONSE_TRANSPORT_INDEX:
					transport.showHintQuest(IntResponsePacket(packet).value, "Chọn nhiệm vụ");
					break;
			}
		}

		override protected function onComplete():void
		{
			finished = true;
			increaseStepID();
			Game.network.lobby.removeEventListener(Server.SERVER_DATA, onLobbyResponse);
			transport.removeEventListener(ViewBase.TRANSITION_IN_COMPLETE, transportOpened);
			Game.network.lobby.sendPacket(new IntRequestPacket(LobbyRequestType.TUTORIAL_FINISHED_SCENE, sceneID));
			setConversation(1, super.onComplete);
		}

		private function transportOpened(event:Event):void
		{
			transport.removeEventListener(ViewBase.TRANSITION_IN_COMPLETE, transportOpened);
			Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.TUTORIAL_GET_TRANSPORT_INDEX));
		}

		private function get hud():HUDModule
		{
			return Manager.module.getModuleByID(ModuleID.HUD) as HUDModule;
		}

		private function get transport():QuestTransportModule
		{
			return Manager.module.getModuleByID(ModuleID.QUEST_TRANSPORT) as QuestTransportModule;
		}

		private function get inventory():InventoryModule
		{
			return Manager.module.getModuleByID(ModuleID.INVENTORY_UNIT) as InventoryModule;
		}

		private function get worldmap():WorldMapModule
		{
			return Manager.module.getModuleByID(ModuleID.WORLD_MAP) as WorldMapModule;
		}

		private function get home():HomeModule
		{
			return Manager.module.getModuleByID(ModuleID.HOME) as HomeModule;
		}
	}

}