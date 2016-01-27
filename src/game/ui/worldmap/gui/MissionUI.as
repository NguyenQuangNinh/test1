package game.ui.worldmap.gui 
{
	import core.display.BitmapEx;
	import core.event.EventEx;
	import core.util.FontUtil;
	import core.util.Utility;
	import flash.display.MovieClip;
import flash.display.SimpleButton;
import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import game.data.model.item.IItemConfig;
	import game.data.model.item.ItemFactory;
	import game.data.xml.MissionXML;
	import game.enum.Font;
	import game.enum.ItemType;
	import game.ui.components.SmallStar;
	import game.ui.components.StarChain;
	import game.ui.tooltip.TooltipEvent;
	import game.ui.tooltip.TooltipID;
	import game.ui.tutorial.TutorialEvent;
	import game.ui.worldmap.event.EventWorldMap;
	/**
	 * ...
	 * @author anhtinh
	 */
	public class MissionUI extends MovieClip
	{
		public static const LOCK : String = "lock";
		public static const UNLOCK : String = "unlock";
		public static const ACTIVE : String = "active";
		
		
		public var missionNameTf : TextField;
		public var quickFinishBtn:SimpleButton;
		public var hitBtn:SimpleButton;

		private var _isLock : Boolean;
		private var _isChosen : Boolean;
		public var missionXML : MissionXML;
		
		private var starChain : StarChain;
		
		private var _status : String = "";
		private var mobIcon : BitmapEx = new BitmapEx();
		
		public function MissionUI(missionData : MissionXML) 
		{
			FontUtil.setFont(missionNameTf, Font.ARIAL);

            addFrameScript(0, stopMovie);
            addFrameScript(1, stopMovie);
            addFrameScript(2, stopMovie);

            enableQuickFinish = false;

			starChain = new StarChain();
			starChain.init(SmallStar, 16, 3);
			starChain.x = 4;
			starChain.y = 55;
			starChain.visible = false;
			this.addChild(starChain);
			
			status = LOCK;
			this.missionXML = missionData;
			missionNameTf.text = missionData.name;

            hitBtn.addEventListener(MouseEvent.CLICK, onMissionClick);
			
			this.addEventListener(MouseEvent.ROLL_OVER, onRollOverHdl);
			this.addEventListener(MouseEvent.ROLL_OUT, onRollOutHdl);
			
			var mobConfig : IItemConfig = ItemFactory.buildItemConfig(ItemType.UNIT, missionData.getLastModID());
			if (mobConfig != null) {
				mobIcon.visible = false;
				mobIcon.x = 4;
				mobIcon.y = 10;
				mobIcon.load(mobConfig.getIconURL())
				this.addChildAt(mobIcon, 1);
				//this.addChild(mobIcon);
			}
		}
		
		private function onRollOutHdl(e:MouseEvent):void {
			dispatchEvent(new EventEx(TooltipEvent.HIDE_TOOLTIP, null, true));	
		}
		
		private function onRollOverHdl(e:MouseEvent):void {
			
			dispatchEvent(new EventEx(TooltipEvent.SHOW_TOOLTIP, {type:TooltipID.MISSION_TOOLTIP, value: this.missionXML}, true));
			
		}
		
		private function onMissionClick(e:MouseEvent):void 
		{
			if (this.buttonMode == true) {
				dispatchEvent(new EventEx(TutorialEvent.EVENT, { type:TutorialEvent.ENTER_NODE }, true));
				this.dispatchEvent(new EventWorldMap(EventWorldMap.PLAY_MISSION, this.missionXML, true));
			}
		}
		
		private function stopMovie():void 
		{
			stop();
		}
		
		public function get status():String 
		{
			return _status;
		}
		
		public function set status(value:String):void 
		{
			_status = value;
			switch (_status) 
			{
				case LOCK:
					this.gotoAndStop("lock");
					starChain.visible = false;
					this.buttonMode = false;
					this.mobIcon.visible = false;
					break;
					
				case UNLOCK:
					this.gotoAndStop("unlock");
					this.buttonMode = true;
					this.mobIcon.visible = true;
					break;
					
				case ACTIVE:
					this.gotoAndStop("active");
					this.buttonMode = true;
					this.mobIcon.visible = true;
					break;
					
				default:
					_status =  LOCK;
					this.gotoAndStop("lock");
					starChain.visible = false;
					this.buttonMode = false;
					this.mobIcon.visible = false;
					Utility.error("MissionUI set invalid status : " + value);
			}
		}
		
		public function setAchiveStar(amount : int) : void {
			starChain.visible = (amount > 0);
            enableQuickFinish = (amount == 3);
			starChain.setProgress(amount);
		}

        public function set enableQuickFinish(value:Boolean):void {

            if(value)
            {
                quickFinishBtn.visible = true;
                quickFinishBtn.addEventListener(MouseEvent.CLICK, quickFinishBtn_clickHandler);
            }
            else
            {
                quickFinishBtn.visible = false;
                quickFinishBtn.removeEventListener(MouseEvent.CLICK, quickFinishBtn_clickHandler);
            }
        }

        private function quickFinishBtn_clickHandler(event:MouseEvent):void {
            dispatchEvent(new EventWorldMap(EventWorldMap.QUICK_FINISH, this.missionXML, true));
        }
    }

}