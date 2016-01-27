package game.enum 
{
	import core.util.Enum;
	import game.data.xml.CampaignXML;
	import game.data.xml.DataType;
	import game.data.xml.MissionXML;
	import game.Game;
	/**
	 * ...
	 * @author TrungLNM
	 */
	public class TuuLauType extends Enum 
	{		
		public static const BA_LANG_TUU_LAU: TuuLauType = new TuuLauType(10, "ba_lang_huyen");
		public static const GIANG_TAN_TUU_LAU: TuuLauType = new TuuLauType(11, "giang_tan_thon");
		public static const THACH_CO_TUU_LAU: TuuLauType = new TuuLauType(12, "thach_co_tran");
		public static const LONG_TUYEN_TUU_LAU: TuuLauType = new TuuLauType(13, "long_tuyen_thon");
		public static const VINH_LAC_TUU_LAU: TuuLauType = new TuuLauType(14, "vinh_lac_tran");
		
		public function TuuLauType(id:int, name:String):void
		{
			super(id, name);			
		}
		
	}

}