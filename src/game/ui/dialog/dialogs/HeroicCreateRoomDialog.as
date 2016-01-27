package game.ui.dialog.dialogs 
{
	import core.event.EventEx;
	import core.Manager;
	import core.util.FontUtil;
	import core.util.Utility;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import game.data.vo.lobby.LobbyInfo;
	import game.data.xml.DataType;
	import game.data.xml.MissionXML;
	import game.enum.Direction;
	import game.enum.FlowActionEnum;
	import game.enum.Font;
	import game.enum.GameMode;
	import game.flow.FlowManager;
	import game.Game;
	import game.net.lobby.LobbyRequestType;
	import game.net.RequestPacket;
	import game.ui.components.OptionGroup;
	import game.ui.dialog.HeroicDifficulty;
	import game.ui.heroic.world_map.CampaignData;
	import game.ui.ModuleID;
	import game.ui.tutorial.TutorialEvent;
	import game.utility.UtilityUI;
	
	
	
	/**
	 * ...
	 * @author MaiPTT
	 */
	public class HeroicCreateRoomDialog extends Dialog
	{	
		public var txtMessage		:TextField;
		public var btnJoin			:SimpleButton;
		public var btnCreate		:SimpleButton;
		public var containerDifficulties:MovieClip;
		public var containerRewards:MovieClip;
		
		private var dificultyOption:OptionGroup;
		private var difficulties:Array = [];
		
		public function HeroicCreateRoomDialog() 
		{
			txtMessage.mouseEnabled = false;
			FontUtil.setFont(txtMessage, Font.ARIAL, true);
			
			dificultyOption = new OptionGroup();
			for(var i:int = 0; i < 4; ++i)
			{
				var difficulty:HeroicDifficulty = new HeroicDifficulty();
				difficulty.setData(i + 1);
				difficulty.y = i * 91;
				containerDifficulties.addChild(difficulty);
				dificultyOption.addOption(difficulty.checkbox);
				difficulties.push(difficulty);
			}
			dificultyOption.setSelected(0);
			
			btnJoin.addEventListener(MouseEvent.CLICK, btnJoin_onClicked);
			btnCreate.addEventListener(MouseEvent.CLICK, btnCreate_onClicked);			
		}
		
		/*private function onFlowActionCompletedHdl(e:EventEx):void 
		{
			switch(e.data.type) {
				case FlowActionEnum.CREATE_LOBBY_SUCCESS:
					Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.NOTIFY_JOIN_ROOM_READY));
					break;
				case FlowActionEnum.UPDATE_LOBBY_INFO_SUCCESS:
					Manager.display.to(ModuleID.HEROIC_LOBBY);
					close();					
					break;
				case FlowActionEnum.CREATE_LOBBY_FAIL:
					onCreateRoomFail(e.data.error);
					break;
				case FlowActionEnum.QUICK_JOIN_SUCCESS:
					Manager.display.to(ModuleID.HEROIC_LOBBY);
					close();
					break;
				case FlowActionEnum.QUICK_JOIN_FAIL:
					btnCreate_onClicked(null);
					break;
			}
		}*/
		
		private function onCreateRoomFail(nErrorCode:int):void 
		{
			switch(nErrorCode) {
				case 4:
					Manager.display.showMessage("Bạn chưa đủ cấp để vào");
					break;
				default:
					Utility.log("Heroic Create Room >> Create Room Error Code: " + nErrorCode);
					break;
			}
		}
		
		protected function btnJoin_onClicked(event:MouseEvent):void
		{	
			var lobbyInfo:LobbyInfo = new LobbyInfo();
			lobbyInfo.backModule = ModuleID.HEROIC_MAP;
			lobbyInfo.mode = GameMode.PVE_HEROIC;
			lobbyInfo.campaignID = data.campaignID;
			lobbyInfo.difficultyLevel = dificultyOption.getSelected();
			Game.flow.doAction(FlowActionEnum.QUICK_JOIN, lobbyInfo);
		}
		
		protected function btnCreate_onClicked(event:MouseEvent = null):void
		{
			var lobbyInfo:LobbyInfo = new LobbyInfo();
			lobbyInfo.backModule = ModuleID.HEROIC_MAP;
			lobbyInfo.mode = GameMode.PVE_HEROIC;
			lobbyInfo.campaignID = data.campaignID;
			lobbyInfo.difficultyLevel = dificultyOption.getSelected();
			Game.flow.doAction(FlowActionEnum.CREATE_BASIC_LOBBY, lobbyInfo);
			dispatchEvent(new EventEx(TutorialEvent.EVENT, {type: TutorialEvent.CLICK_CREATE_HEROIC_ROOM}, true));
		}
		
		override public function onShow():void
		{
			while(containerRewards.numChildren > 0)
			{
				var reward:RewardHeroic = containerRewards.removeChildAt(0) as RewardHeroic;
				Manager.pool.push(reward, RewardHeroic);
			}
			if (data)
			{
				txtMessage.text = "Bạn muốn vào " + data.content + "?";
				
				var campaignData:CampaignData = Game.database.gamedata.getHeroicConfig(data.campaignID);
				if(campaignData != null)
				{
					for(var i:int = 0; i < difficulties.length; ++i)
					{
						var difficulty:HeroicDifficulty = difficulties[i];
						var missionIDs:Array = campaignData.missionIDs[i];
						if(missionIDs != null && missionIDs.length > 0)
						{
							var items:Array = [];
							var randomItems:Array = [];
							var levelRequired:int = 0;
							for(var j:int = 0; j < missionIDs.length; ++j)
							{
								var missionID:int = missionIDs[j];
								var missionXML:MissionXML = Game.database.gamedata.getData(DataType.MISSION, missionID) as MissionXML;
								if(missionXML != null)
								{
									UtilityUI.sumRewards(items, missionXML.fixRewardIDs);
									UtilityUI.sumRewards(randomItems, missionXML.randomRewardIDs);
									levelRequired = Math.max(levelRequired, missionXML.levelRequired);
								}
								else
								{
									Utility.error("ERROR > heroic campaignID=" + data.campaignID + " missionID=" + missionID + " is undefined");
								}
							}
							for(j = 0; j < items.length; ++j)
							{
								reward = Manager.pool.pop(RewardHeroic) as RewardHeroic;
								reward.setData(items[j], false);
								reward.x = j * 72;
								reward.y = i * 91;
								containerRewards.addChild(reward);
							}
							for(j = 0; j < randomItems.length; ++j)
							{
								reward = Manager.pool.pop(RewardHeroic) as RewardHeroic;
								reward.setData(randomItems[j], true);
								reward.x = (j + items.length) * 72;
								reward.y = i * 91;
								containerRewards.addChild(reward);
							}
							difficulty.setLevelRequired(levelRequired);
							difficulty.visible = true;
						}
						else
						{
							difficulty.visible = false;
						}
					}
				}
			}
			
			dificultyOption.setSelected(0);
			Game.stage.dispatchEvent(new EventEx(TutorialEvent.EVENT, {type: TutorialEvent.OPEN_CREATE_HEROIC_ROOM_DLG}, true));
			//Game.flow.addEventListener(FlowManager.ACTION_COMPLETED, onFlowActionCompletedHdl);
			super.onShow();
		}
		
		override protected function close():void
		{
			//Game.flow.removeEventListener(FlowManager.ACTION_COMPLETED, onFlowActionCompletedHdl);
			super.close();
		}


		override public function showHint():void
		{
			super.showHint();
			Game.hint.showHint(btnCreate, Direction.LEFT, btnCreate.x + btnCreate.width, btnCreate.y + btnCreate.height/2, "Click Chuột");
		}
	}
}