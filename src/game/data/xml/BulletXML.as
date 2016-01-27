package game.data.xml 
{
	/**
	 * ...
	 * @author bangnd2
	 */
	public class BulletXML extends XMLData 
	{
		public var bulletAnim:String;
		public var explosionAnim:String;
		public var width:int;
		public var height:int;
		public var y:int;
		public var effectID:int;
		
		override public function parseXML(xml:XML):void 
		{
			super.parseXML(xml);
			bulletAnim = xml.BulletAnim.toString();
			explosionAnim = xml.ExplosionAnim.toString();
			width = xml.Width.toString();
			height = xml.Height.toString();
			y = xml.PositionY.toString();
			effectID = xml.ArrClientEffectID.toString();
		}
	}

}