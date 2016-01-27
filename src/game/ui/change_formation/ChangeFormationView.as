package game.ui.change_formation
{
	import com.greensock.TweenMax;
	import core.display.ViewBase;
	import core.event.EventEx;
	import core.util.FontUtil;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import game.data.model.Character;
	import game.data.model.UserData;
	import game.data.xml.DataType;
	import game.data.xml.FeatureXML;
	import game.data.xml.FormationTypeXML;
	import game.enum.Direction;
	import game.enum.Font;
	import game.enum.FormationType;
	import game.Game;
	import game.ui.hud.HUDButtonID;
	import game.ui.tutorial.TutorialEvent;
	
	/**
	 * ...
	 * @author MaiPTT
	 */
	public class ChangeFormationView extends ViewBase
	{
		static public const CLOSE:String = "change_formation_close";
		static public const CHANGE_FORMATION_TYPE:String = "change_formation_type";
		public var closeBtn:SimpleButton;
		//public var movContainer	:MovieClip;
		
		public var fTypeNameTf:TextField;
		public var fTypeLevelTf:TextField;
		public var txtNormalSlot:TextField;
		public var txtLegendarySlot:TextField;
		public var fTypeBtn:SimpleButton;
		
		public function ChangeFormationView()
		{
			//closeBtn = UtilityUI.getComponent(UtilityUI.CLOSE_BTN) as SimpleButton;
			//closeBtn.x = 905;
			//closeBtn.y = 55;
			//addChild(closeBtn);
			initUI();
		}
		
		private function initUI():void
		{
			FontUtil.setFont(fTypeNameTf, Font.ARIAL, true);
			FontUtil.setFont(fTypeLevelTf, Font.ARIAL, true);
			FontUtil.setFont(txtNormalSlot, Font.ARIAL, true);
			FontUtil.setFont(txtLegendarySlot, Font.ARIAL, true);
			
			closeBtn.addEventListener(MouseEvent.CLICK, onBtnClickHdl);
			fTypeBtn.addEventListener(MouseEvent.CLICK, onBtnClickHdl);
		}
		
		private function onBtnClickHdl(e:MouseEvent):void
		{
			switch (e.target)
			{
				case closeBtn: 
					dispatchEvent(new EventEx(TutorialEvent.EVENT, {type: TutorialEvent.CLOSE_CHANGE_FORMATION}, true));
					dispatchEvent(new Event(CLOSE, true));
					break;
				case fTypeBtn: 
					dispatchEvent(new Event(CHANGE_FORMATION_TYPE, true));
					break;
			}
		}
		
		override public function transitionIn():void {
			Game.database.userdata.addEventListener(UserData.UPDATE_FORMATION, onUpdateFormation);
			super.transitionIn();
			updateUI();
		}
		
		override public function transitionOut():void {
			super.transitionOut();
			Game.database.userdata.removeEventListener(UserData.UPDATE_FORMATION, onUpdateFormation);
		}
		
		override protected function transitionInComplete():void
		{
			super.transitionInComplete();
			this.update();
		}
		
		public function update():void
		{
			
			var featureXML:FeatureXML = Game.database.gamedata.getData(DataType.FEATURE, HUDButtonID.FORMATION_TYPE.ID) as FeatureXML;
			if (featureXML)
			{
				if (Game.database.userdata.level >= featureXML.levelRequirement)
				{
					fTypeBtn.mouseEnabled = true;
					TweenMax.to(fTypeBtn, 0, {alpha: 1, colorMatrixFilter: {saturation: 1}});
					var formationTypeXml:FormationTypeXML = Game.database.gamedata.getData(DataType.FORMATION_TYPE, Game.database.userdata.formationStat.ID) as FormationTypeXML;
					if (formationTypeXml)
					{
						fTypeNameTf.text = formationTypeXml.name;
					}
					else
					{
						fTypeNameTf.text = "Chưa chọn trận hình";
					}
				}
				else
				{
					fTypeBtn.mouseEnabled = false;
					TweenMax.to(fTypeBtn, 0, {alpha: 1, colorMatrixFilter: {saturation: 0}});
					fTypeNameTf.text = "Tính năng trận hình mở ở cấp " + featureXML.levelRequirement;
				}
			}
			fTypeLevelTf.visible = formationTypeXml != null;
			fTypeLevelTf.text = "Cấp: " + Game.database.userdata.formationStat.level;
		}
	
		private function onUpdateFormation(e:EventEx):void {
			var type:FormationType = e.data.formationType as FormationType;
			if (type == FormationType.FORMATION_MAIN) {
				updateUI();
			}
		}
		
		private function updateUI():void {
			var numCharNormal:int = 0;
			var numCharLegend:int = 0;
			for each (var char:Character in Game.database.userdata.formation) {
				if (char && !char.isMainCharacter) {
					if (char.isLegendary()) {
						numCharLegend ++;
					} else {
						numCharNormal ++;
					}
				}
			}
			
			txtNormalSlot.text = numCharNormal + "/" + Game.database.userdata.numNormalFormationSlot;
			txtLegendarySlot.text = numCharLegend + "/" + Game.database.userdata.numLegendFormationSlot;
		}

		//TUTORIAL
		public function showHintButton():void
		{
			Game.hint.showHint(fTypeBtn, Direction.DOWN, fTypeBtn.x + fTypeBtn.width - 80, fTypeBtn.y, "Mở Trận Hình");
		}
	}

}