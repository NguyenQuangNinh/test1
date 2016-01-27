package game.ui.components.dynamicobject 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	/**
	 * ...
	 * @author anhtinh
	 */
	public class DynamicObject extends MovieClip
	{
		public static const MOVING : String = "moving";
		
		public var speed : Number = 2;
		public var maxSpeed : Number = 7;
		
		private var velocityVec : Point;
		private var maxVelocityVec : Point;
		
		private var targetPos : Point;
		
		private var distance : Number;
		protected var ease : Number;
		
		private var _status : uint;
		private var _direction : int;
		private var currentSpeed:Number;
		
		public function DynamicObject() 
		{
			_status = DynamicObjectStatus.STANDING;
		}
		
		public function update() : void {
			
			if (status == DynamicObjectStatus.STANDING) return;
			
			// linear moving
			if (this.ease == 0)
			{
				if (distance <= speed)
				{
					this.x = targetPos.x;
					this.y = targetPos.y;
					status = DynamicObjectStatus.STANDING;
					onReachTarget();
					return;
				}
				this.x += velocityVec.x;
				this.y += velocityVec.y;
				distance -= speed;
			}
			else // easing moving
			{
				distance = Point.distance(currentPos, targetPos);
				if (distance <= speed) 
				{
					this.x = targetPos.x;
					this.y = targetPos.y;
					status = DynamicObjectStatus.STANDING;
					onReachTarget();
					return;
				}
				
				/*var nSpeed:Number = distance * this.ease;
				if (nSpeed > maxSpeed) nSpeed = maxSpeed;
				
				velocityVec.normalize(nSpeed);
				this.x += velocityVec.x;
				this.y += velocityVec.y;
				
				if (nSpeed != currentSpeed) onChangeSpeed(nSpeed);
				currentSpeed = nSpeed;*/
				
				
				var dx:Number = (targetPos.x - this.x) * this.ease;
				if (dx*dx > maxVelocityVec.x*maxVelocityVec.x) dx = maxVelocityVec.x;
				
				var dy:Number = (targetPos.y - this.y) * this.ease;
				if (dy*dy > maxVelocityVec.y*maxVelocityVec.y) dy = maxVelocityVec.y;
	
				this.x += dx;
				this.y += dy;
				
				var nSpeed:Number = Math.round(new Point(dx, dy).length);
				if (nSpeed != currentSpeed) onChangeSpeed(nSpeed);
				currentSpeed = nSpeed;
			}
			
			this.dispatchEvent(new Event(MOVING));
		}
		
		protected function onChangeSpeed(nSpeed:Number):void 
		{
			
		}
		
		protected function onReachTarget():void 
		{
			
		}
		
		public function get currentPos() : Point {
			return new Point(x, y);
		}
		
		public function get status():uint 
		{
			return _status;
		}
		
		public function set status(value:uint):void 
		{
			_status = value;
		}
		
		public function get direction():int 
		{
			return _direction;
		}
		
		public function set direction(value:int):void 
		{
			_direction = value;
		}
		
		public function moveTo(targetPos : Point, ease : Number, byRun : Boolean = false) : void {
			this.targetPos = targetPos.clone();
			this.ease = ease;
			
			distance = Point.distance(currentPos, targetPos);
			velocityVec = new Point(targetPos.x - x, targetPos.y - y);
			velocityVec.normalize(speed);
			maxVelocityVec = new Point(targetPos.x - x, targetPos.y - y);
			maxVelocityVec.normalize(maxSpeed);
			
			status = byRun ? DynamicObjectStatus.RUNNING : DynamicObjectStatus.WALKING;
			
			var ang:Number = Math.atan2(targetPos.y - y, targetPos.x - x);
			
			ang = Math.round(ang * 180 / Math.PI);
			
			updateDirection(ang);
		}
		
		public function updateDirection(ang:Number):void 
		{
			if (ang > - 90 && ang < 90) {
				this.direction = ObjectDirection.RIGHT;
			}else {
				this.direction = ObjectDirection.LEFT;
			}
		}
		
		public function updateTargetPoint(targetPoint:Point):void {
			this.targetPos = targetPoint.clone();
		}
		
	}

}