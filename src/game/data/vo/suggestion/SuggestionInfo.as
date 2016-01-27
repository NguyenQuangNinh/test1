package game.data.vo.suggestion 
{
	import game.ui.ModuleID;
	/**
	 * ...
	 * @author TrungLNM
	 */
	public class SuggestionInfo 
	{
		public var ID	:int = -1;
		public var desc	:String = "";
		public var moduleID	:ModuleID = null;
		//current 
			//0: mean feature in HUD Module
			//1: mean feature in HOME Module
		public var featureType	:int = -1;
		public var featureID	:int = -1;
		
		public function SuggestionInfo() 
		{
			
		}
		
	}

}