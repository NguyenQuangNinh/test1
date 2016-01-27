package game.data.xml 
{
	import core.util.Enum;
	import game.enum.SoundType;
	/**
	 * ...
	 * @author TrungLNM
	 */
	public class SoundXML extends XMLData
	{
		
		public var type:SoundType;
		public var src:String;
		
		public function SoundXML() 
		{
			
		}
		
		override public function parseXML(xml:XML):void 
		{
			super.parseXML(xml);
			src = xml.Src.toString();
			type = Enum.getEnum(SoundType, parseInt(xml.Type.toString())) as SoundType;
		}
	}	

}