/**
 * Created by NINH on 12/30/2014.
 */
package game.enum
{

	import core.util.Enum;

	public class PorterType extends Enum
	{
		public static const WHITE:PorterType = new PorterType(1, "Bạch Tiêu Xa", 207, 0xf2f2f2);
		public static const GREEN:PorterType = new PorterType(2, "Lục Tiêu Xa", 208, 0x56e707);
		public static const BLUE:PorterType = new PorterType(3, "Thanh Tiêu Xa", 209, 0x59e9ea);
		public static const RED:PorterType = new PorterType(4, "Hồng Tiêu Xa", 210, 0xe40605);
		public static const YELLOW:PorterType = new PorterType(5, "Kim Tiêu Xa", 211, 0xdf8e00);

		public var configID:int;
		public var color:int;

		public function PorterType(ID:int, name:String, configID:int, color:int)
		{
			super(ID, name);
			this.configID = configID;
			this.color = color;
		}
	}
}
