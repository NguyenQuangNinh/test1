package game.ui.worldmap.gui 
{
	import core.util.Utility;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.Dictionary;
	import game.data.xml.CampaignXML;
	import game.data.xml.DataType;
	import game.data.xml.MissionXML;
	import game.Game;
	import game.ui.components.PagingMov;
	import game.ui.worldmap.event.EventWorldMap;
	/**
	 * ...
	 * @author anhtinh
	 */
	public class MissionPanel extends Sprite
	{
		private static const CELL_PER_PAGE : int = 15;
		
		private var container : Sprite = new Sprite();
		private var missionList : Array;
		public var currentChosenMission : MissionUI;
		private var pagingMov : PagingMov = new PagingMov();
		private var totalPage : int;
		private var currentPage : int;
		private var campaignData:CampaignXML;
		private var missionInfoDict:Dictionary;
		private var highlightNewestMission:Boolean;
		private var missionDatas:Array;
		private var pageHighlight:int;
		
		public function MissionPanel() 
		{
			
			pagingMov.x = 175;
			pagingMov.y = 297;
			this.addChild(pagingMov);
			pagingMov.addEventListener(PagingMov.GO_TO_PREV, prevHandler);
			pagingMov.addEventListener(PagingMov.GO_TO_NEXT, nextHandler);
			pagingMov.update(1, 1);
			
			container.x = 0;
			container.y = 0;
			
			this.addChild(container);
		}
		
		private function prevHandler(e:Event):void 
		{
			currentPage--;
			pagingMov.update(currentPage, totalPage);
			updatePage();
		}
		
		private function nextHandler(e:Event):void 
		{
			currentPage++;
			pagingMov.update(currentPage, totalPage);
			updatePage();
		}
		
		public function renderWithData(campaignData : CampaignXML, missionInfoDict : Dictionary, highlightNewestMission : Boolean = false): void {
			
			this.campaignData = campaignData;
			this.missionInfoDict = missionInfoDict;
			this.highlightNewestMission = highlightNewestMission;
			
			missionDatas = [];
			for each (var missionID: int in campaignData.missionIDs) 
			{
				var missionData: MissionXML = Game.database.gamedata.getData(DataType.MISSION, missionID) as MissionXML;
				missionDatas.push(missionData);
			}
			
			totalPage = Math.ceil(campaignData.missionIDs.length / CELL_PER_PAGE);
			
			currentPage = 1;
				
			//if (highlightNewestMission) {
				
				for (var i:int = missionDatas.length - 1; i >= 0; i--) 
				{
					if (missionInfoDict[MissionXML(missionDatas[i]).ID] > 0) {	// so sao > 0
						currentPage = Math.ceil( Math.min(missionDatas.length, i + 2) / CELL_PER_PAGE);
						pageHighlight = currentPage;
						break;
					}
				}
			//}
			
			pagingMov.update(currentPage, totalPage);
			updatePage();
			
		}
		
		private function updatePage():void 
		{
			var beginIndex : int = (currentPage - 1) * CELL_PER_PAGE;
			var endIndex : int = Math.min(currentPage * CELL_PER_PAGE, missionDatas.length);
			var numItem : int = endIndex - beginIndex;
			
			// remove last UI	
			while (container.numChildren != 0) 
			{
				container.removeChildAt(0);
			}
			
			missionList = [];
			
			var finishPreMission : Boolean = false;
			
			for (var i:int = 0; i < numItem; i++) 
			{
				var missionData: MissionXML;
				
				if (i + beginIndex == 0) { 			//mission dau tien
					finishPreMission = true;
				}else {
					 missionData = missionDatas[i + beginIndex - 1];
					 if (missionInfoDict[missionData.ID] != null && missionInfoDict[missionData.ID] > 0) {
						finishPreMission = true;
					 }else {
						finishPreMission = false; 
					 }
				}
				
				missionData = missionDatas[i + beginIndex];
				var missionUI : MissionUI = new MissionUI(missionData);
				
				missionUI.x = (i % 5)* 92 + 10;
				missionUI.y = Math.floor(i / 5) * 100;
				 
				missionUI.status =  (finishPreMission) ? MissionUI.UNLOCK : MissionUI.LOCK;
					
				if (missionInfoDict[missionData.ID] != null) {
					missionUI.setAchiveStar(missionInfoDict[missionData.ID]);
				}
				
				container.addChild(missionUI);
				
				missionList.push(missionUI);
			}
			
			if (highlightNewestMission && currentPage == pageHighlight) {
				for (var j:int = missionList.length - 1; j >= 0 ; j--) 
				{
					if (MissionUI(missionList[j]).status != MissionUI.LOCK) {
						MissionUI(missionList[j]).status = MissionUI.ACTIVE;
						break;
					}
				}	
			}
		}
		
	}

}