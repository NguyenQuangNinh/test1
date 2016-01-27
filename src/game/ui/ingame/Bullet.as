package game.ui.ingame
{
	import core.display.animation.Animator;
	import core.Manager;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import game.data.xml.BulletXML;
	import game.enum.TeamID;
	import game.Game;
	
	public class Bullet extends BaseObject
	{
		public static const NORMAL		:int = 0;
		public static const EXPLOSION	:int = 1;
		
		private var animator:Animator;
		private var xmlData:BulletXML;
		
		public function Bullet():void
		{
			animator = new Animator();
			animator.addEventListener(Animator.LOADED, onAnimationLoaded);
			animator.addEventListener(Event.COMPLETE, onAnimationComplete);
			addChild(animator);
		}
		
		public function explode():void
		{
			if (xmlData.explosionAnim.length > 0)
			{
				animator.load(xmlData.explosionAnim);
				animator.play(0, 1);
			}
			else isDead = true;
		}
		
		private function onAnimationComplete(e:Event):void 
		{
			isDead = true;
		}
		
		private function onAnimationLoaded(e:Event):void 
		{
			switch(teamID)
			{
				case TeamID.LEFT:
					animator.scaleX = 1;
					animator.x = (xmlData.width >> 1);
					animator.y = (xmlData.height >> 1);
					break;
				case TeamID.RIGHT:
					animator.scaleX = -1;
					animator.x = (xmlData.width >> 1);
					animator.y = (xmlData.height >> 1);
					break;
			}
		}
		
		public function setXMLData(xmlData:BulletXML):void
		{
			this.xmlData = xmlData;
			if (xmlData != null)
			{
				animator.load(xmlData.bulletAnim);
				animator.play();
				graphics.lineStyle(1);
				//graphics.drawRect(0, 0, xmlData.width, xmlData.height);
			}
		}
		
		public function getXMLData():BulletXML { return xmlData; }
		
		public override function update(delta:Number):void
		{
			if(acceleration != 0)
			{
				var nextVelocity:Number = currentVelocity + acceleration * delta;
				if ((currentVelocity > 0 && nextVelocity < 0) ||
					(currentVelocity < 0 && nextVelocity > 0))
				{
					currentVelocity = 0;
				}
				else
				{
					currentVelocity = nextVelocity;
				}
			}
			if(currentVelocity != 0)
			{
				x += delta * currentVelocity;
			}
		}
		
		override public function pause():void { animator.pause(); }
		override public function resume():void { animator.resume(); }
	}
}