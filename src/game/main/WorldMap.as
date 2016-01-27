package game.main
{
	import core.util.Utility;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	import game.data.xml.CampaignData;
	import game.data.xml.DataType;
	import game.data.xml.MissionXML;
	import game.Game;
	import game.net.IntRequestPacket;
	import game.net.lobby.LobbyRequestType;
	import game.ui.Button;
	
	
	
	public class WorldMap extends Sprite
	{
		private var btnClose:Button;
		private var background:Bitmap;
		private var campaignList:ListPanel;
		private var missionList:ListPanel;
		
		public function WorldMap()
		{
			var bitmapData:BitmapData = new BitmapData(500, 300, true, 0xffffffff);
			background = new Bitmap(bitmapData);
			addChild(background);
			
			btnClose = new Button("Close");
			btnClose.x = 500 - btnClose.width;
			btnClose.addEventListener(MouseEvent.CLICK, btnClose_onClicked);
			addChild(btnClose);
			
			campaignList = new ListPanel();
			campaignList.x = 10;
			campaignList.y = 10;
			campaignList.addEventListener(ListPanel.SELECTION_CHANGED, campaignList_selectionChanged);
			addChild(campaignList);
			
			missionList = new ListPanel();
			missionList.x = 220;
			missionList.y = 10;
			missionList.addEventListener(ListPanel.SELECTION_CHANGED, missionList_selectionChanged);
			addChild(missionList);
		}
		
		protected function missionList_selectionChanged(event:Event):void
		{
			var listItem:ListItem = missionList.getSelected();
			if(listItem != null)
			{
				var missionData:MissionXML = listItem.data as MissionXML;
				Utility.log("request start game PvE, missionID: " + missionData.ID);
				Game.database.userdata.currentMissionID = missionData.ID;
				//Game.network.lobby.sendPacket(new IntRequestPacket(LobbyRequestType.CREATE_LOBBY_PVE, missionData.ID));
			}
		}
		
		protected function campaignList_selectionChanged(event:Event):void
		{
			var listItem:ListItem = campaignList.getSelected();
			if(listItem != null)
			{
				missionList.clear();
				var campaignData:CampaignData = listItem.data as CampaignData;
				for each(var missionID:int in campaignData.missionIDs)
				{
					var missionData:MissionXML = Game.database.gamedata.getData(DataType.MISSION, missionID) as MissionXML;
					if(missionData != null)
					{
						missionList.addItem(new ListItem(missionData.name, missionData));
					}
				}
			}
		}
		
		protected function btnClose_onClicked(event:MouseEvent):void
		{
			visible = false;
		}
		
		public function show():void
		{
			visible = true;
			var campaignDataTable:Dictionary = Game.database.gamedata.getTable(DataType.CAMPAIGN);
			campaignList.clear();
			for each(var campaignData:CampaignData in campaignDataTable)
			{
				campaignList.addItem(new ListItem(campaignData.name, campaignData));
			}
			if(campaignList.getSize() > 0)	campaignList.setSelected(0);
		}
	}
}