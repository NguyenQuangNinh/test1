package game.ui.tuu_lau_chien 
{
	import core.util.FontUtil;
	import flash.display.MovieClip;
	import flash.text.TextField;
	import game.enum.Element;
	import game.enum.Font;
	/**
	 * ...
	 * @author TrungLNM
	 */
	public class TuuLauChienStateMov extends MovieClip
	{
		
		public var nameTf: TextField;
		public var elementMov: MovieClip;
		
		public function TuuLauChienStateMov() 
		{
			initUI();
		}
		
		private function initUI():void 
		{
			//set fonts
			FontUtil.setFont(nameTf, Font.ARIAL, false);
		}
		
		public function updateState(type:Element, name:String):void 
		{
			//avatarClass.setElement(Enum.getEnum(Element, i + 1) as Element);			
			elementMov.gotoAndStop(type.ID);
			nameTf.text = name;
		}
		
	}

}