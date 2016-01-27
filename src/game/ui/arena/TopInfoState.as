package game.ui.arena 
{
	import core.util.FontUtil;
	import flash.display.MovieClip;
	import flash.text.TextField;
	import game.data.xml.DataType;
	import game.enum.GameMode;
	//import game.data.enum.pvp.ModePVPEnum;
	import game.data.xml.ModeConfigXML;
	import game.enum.Font;
	import game.enum.GameConfigID;
	import game.Game;
	import game.utility.GameUtil;
	/**
	 * ...
	 * @author TrungLNM
	 */
	public class TopInfoState extends MovieClip
	{
		
		public var numPlayTf:TextField;
		public var rankTf:TextField;
		public var hornorTf:TextField;
		public var eloTf:TextField;
		
		private var _mode:GameMode;
		
		public function TopInfoState() 
		{
			initUI();
		}
		
		private function initUI():void 
		{
			FontUtil.setFont(numPlayTf, Font.ARIAL, true);
			FontUtil.setFont(rankTf, Font.ARIAL, true);
			FontUtil.setFont(hornorTf, Font.ARIAL, true);
			FontUtil.setFont(eloTf, Font.ARIAL, true);
		}
		
		public function updateState(mode:GameMode, numPlayed:int, rank:int, hornorPoint:int, eloPoint:int):void 
		{
			_mode = mode;
			
			var modeXML:ModeConfigXML = Game.database.gamedata.getData(DataType.MODE_CONFIG, mode.ID) as ModeConfigXML;
			var limitHornorPoint:int = modeXML ? modeXML.getMaxHornorInDay() : -1;
			var limitNumPlay:int = modeXML ? modeXML.getMaxFreeGame() : -1;

			switch (_mode)
			{
				case GameMode.PVP_2vs2_MM:
					numPlayTf.text = "--";
					rankTf.text = rank.toString();
					hornorTf.text = eloPoint.toString();
					eloTf.text = "--";
					break;
				case GameMode.PVP_1vs1_MM:
					numPlayTf.text = "--";
					rankTf.text = rank.toString();
					hornorTf.text = eloPoint.toString();
					eloTf.text = "--";
					break;
				default :
					numPlayTf.text = numPlayed.toString() + "/" + limitNumPlay.toString();
					rankTf.text = rank.toString();
					hornorTf.text = eloPoint.toString();
					eloTf.text = hornorPoint.toString() + "/" + limitHornorPoint.toString();
					break;
			}
		}
	}

}