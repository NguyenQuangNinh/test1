package game.ui.ingame
{
	import flash.display.Sprite;

	public class BaseObject extends Sprite
	{
		public var ID:int = 0;
		public var currentVelocity:Number = 0;
		public var acceleration:Number = 0;
		public var damage:Number = 1;
		public var teamID:int = 1;
		public var isDead:Boolean = false;
		public var attackRange:Number = 0;
		public var knockbackChance:Number = 0;
		public var lastUpdateTarget:int;
		public var attackSpeed:int = 1000;
		public var layer:int;
		public var target:int = -1;
		
		protected var paused:Boolean;
		
		public function setTeamID(teamID:int):void
		{
			this.teamID = teamID;
		}
		
		public function reset():void 
		{ 
			ID = 0;
			isDead = false; 
			currentVelocity = 0;
			acceleration = 0;
			target = -1;
			visible = true;
			paused = false;
		}
		
		public function runTo(target:int, speed:int):void
		{
			this.target = target;
			if (target > x) currentVelocity = speed;
			else currentVelocity = -speed;
			acceleration = 0;
		}
		
		public function hasReachedTarget():Boolean
		{ 
			return (target == -1);
		}
		
		public function update(delta:Number):void
		{
			
		}
		
		public function pause():void { paused = true; }
		public function resume():void { paused = false; }
	}
}