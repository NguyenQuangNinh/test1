package game.ui.heroic.world_map 
{
	import core.display.BitmapEx;
	import core.event.EventEx;
	import core.Manager;
	import core.util.FontUtil;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import game.data.xml.CharacterXML;
	import game.data.xml.DataType;
	import game.data.xml.MissionXML;
	import game.enum.Font;
	import game.Game;
	import game.ui.heroic.HeroicEvent;
	import game.ui.tooltip.TooltipEvent;
	import game.ui.tooltip.TooltipID;
	import game.ui.tutorial.TutorialEvent;

	/**
	 * ...
	 * @author MaiPTT
	 */
	public class CampaignView extends MovieClip
	{
		public var movBossIcon	:MovieClip;
		public var movLock		:MovieClip;
		public var txtName		:TextField;
		public var txtFree		:TextField;
		public var txtPremium	:TextField;
		
		private var bitmap		:BitmapEx;
		private var data		:CampaignData;
		private var enable		:Boolean;
		
		public function CampaignView() {
			initUI();
			initHandlers();
		}
		
		public function setData(value:CampaignData):void {
			data = value;
			if (data) {
				txtName.text = data.name;
				txtFree.text = data.freePlayingTimes + "/" + data.freeMax;
				txtPremium.text = data.premiumPlayingTimes + "/" + data.premiumMax;
				this.x = data.posX;
				this.y = data.posY;
				
				var hardModeMissionIDs:Array = data.missionIDs[data.missionIDs.length - 1];
				if (hardModeMissionIDs) {
					var lastMissionID:int = hardModeMissionIDs[hardModeMissionIDs.length - 1];
					var lastMissionXML:MissionXML = Game.database.gamedata.getData(DataType.MISSION, lastMissionID) as MissionXML;
					if (lastMissionXML) {
						var bossID:int = lastMissionXML.getLastModID();
						var bossXML:CharacterXML = Game.database.gamedata.getData(DataType.CHARACTER, bossID) as CharacterXML;
						bitmap.load(bossXML.getIconURL());
					}
				}
				
				if (data.levelRequired <= Game.database.userdata.level) {
					movLock.visible = false;
					enable = true;
				} else {
					movLock.visible = true;
					enable = false;
					txtLevelRequired.text = "Cấp " + data.levelRequired;
				}
			}
		}
		
		private function initUI():void {
			FontUtil.setFont(txtFree, Font.ARIAL, true);
			FontUtil.setFont(txtName, Font.ARIAL);
			FontUtil.setFont(txtPremium, Font.ARIAL, true);
			FontUtil.setFont(txtLevelRequired, Font.ARIAL, true);
			
			txtName.mouseEnabled = false;
			txtFree.mouseEnabled = false;
			txtPremium.mouseEnabled = false;
			
			bitmap = new BitmapEx();
			bitmap.addEventListener(BitmapEx.LOADED, onBitmapLoadedHdl);
			movBossIcon.addChild(bitmap);
			
			this.buttonMode = true;
		}
		
		private function get txtLevelRequired():TextField {
			return movLock.txtLevelRequired;
		}
		
		private function onBitmapLoadedHdl(e:Event):void {
			bitmap.x = - bitmap.width / 2;
			bitmap.y = - bitmap.height / 2;
		}
		
		private function initHandlers():void {
			addEventListener(MouseEvent.CLICK, onClickHdl);
		}
		
		private function onClickHdl(e:MouseEvent):void {
			if (data) {
				if (enable) {
					dispatchEvent(new EventEx(HeroicEvent.EVENT, {type:HeroicEvent.ENTER_CAMPAIGN, data:data}, true));
				} else {
					Manager.display.showMessage("Bạn cần đạt cấp " + data.levelRequired + " để vào động này");
				}
			}
		}

		public function get isReady():Boolean
		{
			return (enable && data.freePlayingTimes < data.freeMax);
		}
	}

}