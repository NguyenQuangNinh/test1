package game.ui.worldmap.gui 
{
	import core.event.EventEx;
	import core.Manager;
	import core.util.FontUtil;
	import core.util.Utility;

	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.utils.setTimeout;

	import game.Game;
	import game.data.xml.CampaignXML;
	import game.enum.Font;
	import game.enum.SuggestionEnum;
	import game.ui.tutorial.TutorialEvent;
	import game.ui.worldmap.event.EventWorldMap;
	import game.utility.TimerEx;

	/**
	 * ...
	 * @author anhtinh
	 */
	public class CampaignNodeUI extends EventDispatcher
	{
		public static const LOCK_STATUS : String = "lock";
		public static const NEXT_OPEN : String = "next_open";
		public static const OPEN : String = "open";

		public var nameMov:MovieClip;

		private var _status : String = LOCK_STATUS;
		
		private var campaignData : CampaignXML;

		private var asset:MovieClip;

		public function CampaignNodeUI() 
		{

		}
		
		public function destroy():void {
			campaignData = null;
			asset.removeEventListener(MouseEvent.CLICK, onClick);
			asset.removeEventListener(MouseEvent.ROLL_OVER, onRollOver);
			asset.removeEventListener(MouseEvent.ROLL_OUT, onRollOut);
			asset = null;
		}
		
		private function onRollOver(e:MouseEvent):void 
		{
			if (status != LOCK_STATUS) {
				asset.gotoAndStop("hover");
			}
		}
		
		private function onRollOut(e:MouseEvent):void 
		{
			if (status != LOCK_STATUS) {
				asset.gotoAndStop("normal");
			}
		}
		
		private function onClick(e:MouseEvent):void 
		{
			if (status == OPEN) {
				asset.dispatchEvent(new EventEx(TutorialEvent.EVENT, { type:TutorialEvent.ENTER_CAMPAIGN }, true));
				asset.dispatchEvent(new EventWorldMap(EventWorldMap.ENTER_CAMPAIGN, this.campaignData, true));
			} else {
				if (campaignData)
				{
					Manager.display.showMessage("Cần đạt cấp: " + campaignData.levelRequirement + " để chinh phạt");
					setTimeout(Game.suggestion.show, 1500, SuggestionEnum.SUGGEST_LEVEL_UP);
				}
			}
			
		}

		public function setData(campaignData : CampaignXML): void {
			this.campaignData = campaignData;
		}

		public function getData():CampaignXML
		{
			return this.campaignData;
		}

		public function setAsset(asset:MovieClip):void
		{
			this.asset = asset;
			asset.gotoAndStop("normal");
			status = LOCK_STATUS;

			asset.addEventListener(MouseEvent.CLICK, onClick);
			asset.addEventListener(MouseEvent.ROLL_OVER, onRollOver);
			asset.addEventListener(MouseEvent.ROLL_OUT, onRollOut);
		}

		public function get status():String 
		{
			return _status;
		}
		
		public function set status(value:String):void 
		{
			_status = value;
			switch (value)
			{
				case LOCK_STATUS:
					asset.nameMov.visible = false;
					asset.buttonMode = false;
					asset.mouseEnabled = false;
					break;
				case NEXT_OPEN:
					asset.nameMov.visible = true;
					Utility.setGrayscale(asset.nameMov, true);
					asset.buttonMode = true;
					asset.mouseEnabled = true;
					break;
				case OPEN:
					asset.nameMov.visible = true;
					Utility.setGrayscale(asset.nameMov, false);
					asset.buttonMode = true;
					asset.mouseEnabled = true;
					break;
			}
		}
	}

}