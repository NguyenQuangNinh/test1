package game.data.gamemode
{
	import game.ui.challenge_center.HeroicTowerData;

	public class ModeDataHeroicTower extends ModeDataPvE
	{
		public var heroicTowers:Array = [];
		public var currentTower:int;
		public var nextFloorReady:Boolean;
		public var isDead:Boolean;
		public var itemActivated:Boolean;
		
		public function getCurrentTowerData():HeroicTowerData { return heroicTowers[currentTower]; }
		
		override public function setResult(result:Boolean):void
		{
			super.setResult(result);
			if(result)
			{
				getCurrentTowerData().nextFloor();
				nextFloorReady = true;
			}
			else
			{
				isDead = true;
			}
		}
	}
}