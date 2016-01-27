package game.ui.worldmap.gui 
{
	import com.greensock.TweenLite;

	import core.util.Utility;

	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.utils.Dictionary;
	import game.data.xml.CampaignXML;
	import game.Game;
	import game.ui.worldmap.event.EventWorldMap;
	import game.utility.UtilityUI;
	/**
	 * ...
	 * @author anhtinh
	 */
	public class GlobalMap extends Sprite
	{
		public var campaignContainer : MovieClip;

		public var nodesContainer:Array = [];
		
		private var campaignDataTable:Dictionary;
		
		public var closeBtn:SimpleButton;
		
		public function GlobalMap() 
		{
			closeBtn = UtilityUI.getComponent(UtilityUI.BACK_BTN) as SimpleButton;
			
			var closeBtnPoint:Point = UtilityUI.getComponentPosition(UtilityUI.BACK_BTN) as Point;
			if (closeBtn != null) {
				closeBtn.x = closeBtnPoint.x;
				closeBtn.y = closeBtnPoint.y;
				addChild(closeBtn);
				closeBtn.addEventListener(MouseEvent.CLICK, closeWorldMapHandler);
			}

		}
		
		private function closeWorldMapHandler(e:MouseEvent):void 
		{
			this.dispatchEvent(new EventWorldMap(EventWorldMap.HIDE_WORLD_MAP, null, true));
		}
		
		public function initData(campaignDataTable : Dictionary) : void {
			
			this.campaignDataTable = campaignDataTable;
		}

		public function showPlacesIcon():void 
		{
			var nextUnlockCampaign:CampaignNodeUI;

			var campaignNode:CampaignNodeUI;

			while(nodesContainer.length > 0)
			{
				campaignNode = nodesContainer.pop() as CampaignNodeUI;
				campaignNode.destroy();
			}

			for each(var campaignData:CampaignXML in campaignDataTable)
			{
				var asset:MovieClip = campaignContainer[campaignData.uiBtn] as MovieClip;
				if(asset == null) {
					Utility.error("GlobalMap > node name error :" + campaignData.uiBtn);
					continue;
				}

				if(campaignData.uiBtn == "donghaiBtn")
				{
					asset.visible = false;
					asset.mouseEnabled = false;
				}

				campaignNode = new CampaignNodeUI();
				campaignNode.setAsset(asset);
				campaignNode.setData(campaignData);
				campaignNode.status = CampaignNodeUI.LOCK_STATUS;
				nodesContainer.push(campaignNode);

				if (Game.database.userdata.level >= campaignData.levelRequirement)
				{
					campaignNode.status = CampaignNodeUI.OPEN;
				}
				else
				{		//Tim node duoc unlock ke tiep
					if (nextUnlockCampaign == null)
					{
						nextUnlockCampaign = campaignNode;
						nextUnlockCampaign.status = CampaignNodeUI.NEXT_OPEN;
					}
					else
					{
						if (campaignData.levelRequirement < campaignNode.getData().levelRequirement)
						{
							nextUnlockCampaign.status = CampaignNodeUI.LOCK_STATUS;
							nextUnlockCampaign = campaignNode;
							nextUnlockCampaign.status = CampaignNodeUI.NEXT_OPEN;
						}
					}
				}
				
			}
			
			campaignContainer.visible = true;
		}

	}

}