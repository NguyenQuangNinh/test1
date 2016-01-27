package game.enum 
{
	import core.util.Enum;
	
	/**
	 * ...
	 * @author MaiPTT
	 */
	public class LogType extends Enum 
	{
		public static const LOG_TUTORIAL	:LogType = new LogType(20, "log tutorial");
		public static const TUTORIAL_BEGIN	:LogType = new LogType(1000, "begin");
		public static const TUTORIAL_END	:LogType = new LogType(1001, "end");
		public static const TUTORIAL_ACTION	:LogType = new LogType(1002, "action");
		
		public function LogType(id:int, name:String) {
			super(id, name);
		}
		
	}

}