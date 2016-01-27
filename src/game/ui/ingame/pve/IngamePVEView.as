package game.ui.ingame.pve
{
	import core.display.layer.Layer;
	import core.display.layer.LayerManager;
	import core.event.EventEx;
	import core.Manager;
	import core.util.FontUtil;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import game.data.gamemode.ModeDataPvE;
	import game.data.xml.DataType;
	import game.data.xml.MissionXML;
	import game.enum.Font;
	import game.enum.TeamID;
	import game.Game;
	import game.ui.ingame.IngameView;
	import game.ui.ingame.pvp.Team;
	import game.ui.ModuleID;
	
	
	
	public class IngamePVEView extends IngameView
	{
		public var hpBar:MovieClip;
		public var txtCurrentWave:TextField;
		public var btnChat1:SimpleButton;
		
		public var showTopBtn:SimpleButton;
		public var hideTopBtn:SimpleButton;
		
		public function IngamePVEView()
		{
			super();
			hideTopBtn.visible = false;
			showTopBtn.visible = false;
			Team(teams[TeamID.RIGHT]).hpBar = hpBar;
			FontUtil.setFont(txtCurrentWave, Font.ARIAL);
			
			showTopBtn.addEventListener(MouseEvent.CLICK, showTopBtnHdl);
			hideTopBtn.addEventListener(MouseEvent.CLICK, hideTopBtnHdl);
		}
		
		public function disableTopBtns():void 
		{
			hideTop();
			hideTopBtn.visible = false;
			showTopBtn.visible = false;
		}
		
		private function hideTopBtnHdl(e:MouseEvent):void 
		{
			hideTop();
		}
		
		public function showTopBtnHdl(e:MouseEvent):void 
		{
			showTop();
		}
		
		public function showTop():void
		{
			hideTopBtn.visible = true;
			showTopBtn.visible = false;
			Manager.display.showModule(ModuleID.GLOBAL_BOSS_TOP, new Point( - 70, 20), LayerManager.LAYER_POPUP, "top_left", Layer.NONE, {missionID: Game.database.userdata.globalBossData.currentMissionID, isHideBg:true});
		}
		
		public function hideTop():void
		{
			hideTopBtn.visible = false;
			showTopBtn.visible = true;
			Manager.display.hideModule(ModuleID.GLOBAL_BOSS_TOP);
		}
		
		override protected function onChangeWave(event:EventEx):void
		{
			var modeData:ModeDataPvE = Game.database.userdata.getCurrentModeData() as ModeDataPvE;
			var missionData:MissionXML = Game.database.gamedata.getData(DataType.MISSION, modeData.missionID) as MissionXML;
			txtCurrentWave.text = "Đợt " + modeData.currentWave + "/" + missionData.waves.length;
			super.onChangeWave(event);
		}
	}
}