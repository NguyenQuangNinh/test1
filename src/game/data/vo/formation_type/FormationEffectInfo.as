package game.data.vo.formation_type 
{
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author anhtinh
	 */
	public class FormationEffectInfo 
	{
		public var levelUnlockEffect:int;
		public var requiredElements : Array;
		public var bonusAttributes : Array;
		public var targetType:int;
		public var arrTargets:Array;
		public function FormationEffectInfo()
		{
			requiredElements = [];
			bonusAttributes = [];
			arrTargets = [];
		}
		
	}

}