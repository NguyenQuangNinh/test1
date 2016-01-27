package game.data.vo.skill 
{
	import game.data.xml.DataType;
	import game.data.xml.EffectXML;
	import game.data.xml.StanceXML;
	import game.Game;
	/**
	 * ...
	 * @author TrungLNM
	 */
	public class Stance 
	{
		public var active:Boolean;		
		public var xmlData:StanceXML;
		
		private var _effectXMLs:Array;
		
		public function Stance() 
		{
			
		}
		
		public function getEffectXMLs():Array {
			var result:Array = [];
			if (!_effectXMLs) {
				_effectXMLs = [];
				//first parse				
				for (var i:int = 0; i < xmlData.effectIDs.length; i++) {
					var effectXML:EffectXML = Game.database.gamedata.getData(DataType.EFFECT, xmlData.effectIDs[i]) as EffectXML;
					if(effectXML)
						_effectXMLs.push(effectXML);					
				}
				
			}
			result = _effectXMLs;
			return result;
		}
		
	}

}