package game.ui.heroic.lobby 
{
	import com.greensock.TweenMax;
	import core.display.BitmapEx;
	import core.event.EventEx;
	import core.util.FontUtil;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import game.data.gamemode.ModeDataPVEHeroic;
	import game.data.xml.CharacterXML;
	import game.data.xml.DataType;
	import game.data.xml.MissionXML;
	import game.enum.Font;
	import game.Game;
	import game.ui.heroic.HeroicEvent;
	import game.ui.tooltip.TooltipEvent;
	import game.ui.tooltip.TooltipID;
	
	/**
	 * ...
	 * @author MaiPTT
	 */
	public class HeroicNode extends MovieClip 
	{
		public var movIcon		:MovieClip;
		public var movReward	:MovieClip;
		public var movBg		:MovieClip;
		private var data		:MissionXML;
		private var mobBitmap	:BitmapEx;
		private var enable		:Boolean;
		
		public function HeroicNode() {
			initUI();
			addEventListener(MouseEvent.ROLL_OVER, onMouseOverHdl);
			addEventListener(MouseEvent.ROLL_OUT, onMouseOutHdl);
		}
		
		public function reset():void {
			mobBitmap.reset();
			isNextNode(false);
			setNodeEnable(false);
			data = null;
			if (hasEventListener(MouseEvent.CLICK)) {
				removeEventListener(MouseEvent.CLICK, onClickHdl);
			}
		}
		
		public function setData(missionID:int):void {
			data = Game.database.gamedata.getData(DataType.MISSION, missionID) as MissionXML;
			if (data) {
				var lastMobID:int = data.getLastModID();
				var lastModData:CharacterXML = Game.database.gamedata.getData(DataType.CHARACTER, lastMobID) as CharacterXML;
				if (lastModData) {
					mobBitmap.load(lastModData.getIconURL());
				}
				
				if (data.fixRewardIDs && data.fixRewardIDs.length > 0) {
					movReward.visible = true;
				} else {
					movReward.visible = false;
				}
			}
			setNodeEnable(true);
		}
		
		public function isNextNode(value:Boolean):void {
			if (value) {
				movBg.gotoAndStop(2);
			} else {
				movBg.gotoAndStop(1);
			}
		}
		
		public function getMissionID():int {
			if (data) {
				return data.ID;
			}
			return -1;
		}
		
		public function getData():MissionXML {
			return data;
		}
		
		public function setNodeEnable(value:Boolean):void {
			enable = value;
			if (enable) {
				TweenMax.to(this, 0, { colorMatrixFilter: { saturation:1.0 }} );
				if (!hasEventListener(MouseEvent.CLICK)) {
					addEventListener(MouseEvent.CLICK, onClickHdl);
				}
			} else {
				TweenMax.to(this, 0, { colorMatrixFilter: { saturation:0.0 }} );
				if (hasEventListener(MouseEvent.CLICK)) {
					removeEventListener(MouseEvent.CLICK, onClickHdl);
				}
				isNextNode(false);
			}
		}
		
		private function onMouseOutHdl(e:MouseEvent):void {
			dispatchEvent(new EventEx(TooltipEvent.HIDE_TOOLTIP, null, true));
		}
		
		private function onMouseOverHdl(e:MouseEvent):void {
			dispatchEvent(new EventEx(TooltipEvent.SHOW_TOOLTIP, { type:TooltipID.MISSION_TOOLTIP, 
																value:data }, true));
		}
		
		private function onClickHdl(e:MouseEvent):void {
			if (data) {
				ModeDataPVEHeroic(Game.database.userdata.getCurrentModeData()).missionID = data.ID;
				dispatchEvent(new EventEx(HeroicEvent.EVENT, { type:HeroicEvent.START_GAME, missionID:data.ID }, true));
			}
		}
		
		private function initUI():void {
			mobBitmap = new BitmapEx();
			mobBitmap.addEventListener(BitmapEx.LOADED, onBitmapLoadedHdl);
			movIcon.addChild(mobBitmap);
			movBg.gotoAndStop(1);
			this.buttonMode = true;
		}
		
		private function onBitmapLoadedHdl(e:Event):void {
			mobBitmap.x = - mobBitmap.width / 2;
			mobBitmap.y = - mobBitmap.height / 2;
		}

		public function get isEnable():Boolean
		{
			return enable;
		}
	}

}