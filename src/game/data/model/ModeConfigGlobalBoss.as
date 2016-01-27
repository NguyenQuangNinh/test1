package game.data.model 
{
	import game.enum.GameMode;

	/**
	 * ...
	 * @author MaiPTT
	 */
	public class ModeConfigGlobalBoss 
	{
		public var mode			:GameMode = null;
		public var timeOpen		:Array = [];
		public var timeClose	:Array = [];
		public var damageRequired	:Array = [];
		public var goldBuff			:int = -1;
		public var goldBuffPercent	:int = -1;
		public var xuBuff			:int = -1;
		public var xuBuffPercent	:int = -1;
		public var defaultReviveTime	:int = -1;
		public var xuRevive			:Array = [];
		public var xuAutoRevive		:int = -1;
		public var xuAutoPlay		:int = -1;
		public var dmgToGoldRatio	:Number = 0;
		public var topRewardsXML	:XML;
	}

}