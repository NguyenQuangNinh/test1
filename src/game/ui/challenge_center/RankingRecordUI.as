package game.ui.challenge_center
{
	import core.util.FontUtil;
	
	import flash.display.MovieClip;
	import flash.text.TextField;
	
	import game.enum.Font;
	
	public class RankingRecordUI extends MovieClip
	{
		public var txtMaxFloor:TextField;
		public var txtName:TextField;
		public var txtLevel:TextField;
		
		public function RankingRecordUI()
		{
			FontUtil.setFont(txtMaxFloor, Font.TAHOMA);
			FontUtil.setFont(txtName, Font.TAHOMA);
			FontUtil.setFont(txtLevel, Font.TAHOMA);
		}
		
		public function setData(data:RankingRecordData):void
		{
			if(data != null)
			{
				//txtMaxFloor.text 	= data.maxFloor.toString();
				txtMaxFloor.text 	= data.index.toString();
				txtName.text 		= data.name;
				txtLevel.text 		= data.maxFloor.toString();
			}
			else
			{
				txtMaxFloor.text 	= "";
				txtName.text 		= "";
				txtLevel.text 		= "";
			}
		}
	}
}