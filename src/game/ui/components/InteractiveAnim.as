package game.ui.components
{
	import core.display.animation.Animator;
	import core.display.BitmapEx;
	import core.Manager;
	import core.util.Utility;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import game.enum.CharacterAnimation;
	import game.ui.components.dynamicobject.DynamicObject;
	import game.ui.components.dynamicobject.DynamicObjectStatus;
	import game.ui.home.scene.CharacterManager;
	import game.utility.Ticker;
	
	/**
	 * ...
	 * @author anhtinh
	 */
	public class InteractiveAnim extends DynamicObject
	{
		public static const LEFT:int = -1;
		public static const RIGHT:int = 1;
		private static const glowFilter:GlowFilter = new GlowFilter(0xffff00, 1, 8, 8, 2);
		
		public var positionIndex:int;
		protected var animator:Animator;
		private var hitRectangle:Rectangle;
		private var elapsedTime:uint;
		private var standingTime:uint;
		private var _enableInteractive:Boolean;
		private var _direction:int;
		
		//private var iconNpc:BitmapEx;
		private var iconNpc:MovieClip;
		
		public function InteractiveAnim()
		{
			this.animator = new Animator();
			
			addEventListener(Event.ENTER_FRAME, onEnterFrameHdl);
			this.animator.addEventListener(Animator.LOADED, onAnimatorLoaded);
			this.addChild(this.animator);
			enableInteractive = true;
			direction = RIGHT;
			positionIndex = 0;
			enableMoving(false);
			
			//iconNpc = new BitmapEx();
			iconNpc = new MovieClip();
			iconNpc.name = "iconNPC";
			addChild(iconNpc);
		}
		
		
		public function setHitArea(hitArea:Rectangle, bCenter:Boolean = false):Boolean
		{
			this.hitRectangle = hitArea;
			
			if (enableInteractive)
			{
				var hitBmd:BitmapData = new BitmapData(hitArea.width, hitArea.height, true, 0x000000ff);
				var hitBm:Bitmap = new Bitmap(hitBmd);
				
				var hitArea1:Sprite = new Sprite();
				if (!bCenter)
				{
					hitArea1.x = -hitArea.width / 2;
					hitArea1.y = -hitArea.height;
				}
				hitArea1.addChild(hitBm);
				this.hitArea = hitArea1;
				this.addChild(hitArea1);
				
			}
			
			/*var rectangle:Shape = new Shape(); // initializing the variable named rectangle
			rectangle.graphics.beginFill(0x00FF00); // choosing the colour for the fill, here it is red
			rectangle.graphics.drawRect(hitRectangle.x, hitRectangle.y, hitRectangle.width, hitRectangle.height); // (x spacing, y spacing, width, height)
			rectangle.graphics.endFill(); // not always needed but I like to put it in to end the fill
			rectangle.alpha = 0.3;
			this.addChild(rectangle); // adds the rectangle to the stage*/
			
			return enableInteractive;
		}
		
		public function enableMoving(value:Boolean):void
		{
			if (value)
			{
				if (!hasEventListener(Event.ENTER_FRAME))
				{
					addEventListener(Event.ENTER_FRAME, onEnterFrameHdl);
				}
			}
			else
			{
				if (hasEventListener(Event.ENTER_FRAME))
				{
					removeEventListener(Event.ENTER_FRAME, onEnterFrameHdl);
				}
			}
		}
		
		public function get enableInteractive():Boolean
		{
			return _enableInteractive;
		}
		
		public function set enableInteractive(value:Boolean):void
		{
			_enableInteractive = value;
			this.buttonMode = _enableInteractive;
			this.mouseChildren = _enableInteractive;
			this.mouseEnabled = _enableInteractive;
			
			if (_enableInteractive)
			{
				if (!this.hasEventListener(MouseEvent.ROLL_OVER))
				{
					this.addEventListener(MouseEvent.ROLL_OVER, onRollOver);
				}
				if (!this.hasEventListener(MouseEvent.ROLL_OUT))
				{
					this.addEventListener(MouseEvent.ROLL_OUT, onRollOut);
				}
				
				if (this.hitRectangle != null)
				{
					setHitArea(hitRectangle, false);
					//setHitArea(hitRectangle, true);
				}
				
			}
			else
			{
				if (this.hasEventListener(MouseEvent.ROLL_OVER))
					this.removeEventListener(MouseEvent.ROLL_OVER, onRollOver);
				if (this.hasEventListener(MouseEvent.ROLL_OUT))
					this.removeEventListener(MouseEvent.ROLL_OUT, onRollOut);
			}
		}
		
		public function loadAnim(url:String):void
		{
			animator.addEventListener(Animator.LOADED, LoadAnimatorCompleteHdl);
			animator.load(url);
		}
		
		private function LoadAnimatorCompleteHdl(e:Event):void 
		{
			iconNpc.x = - animator.width / 3;
			iconNpc.y = - animator.height - 15;
		}
		
		public function changeAnimation(animationIndex:int):void
		{
			if (this.animator != null)
				this.animator.play(animationIndex, -1);
		}
		
		override public function get direction():int
		{
			return super.direction;
		}
		
		override public function set direction(value:int):void
		{
			super.direction = value;
			animator.scaleX = value;
		}
		
		override public function get status():uint
		{
			return super.status;
		}
		
		override public function set status(value:uint):void
		{
			super.status = value;
			switch (status)
			{
				case DynamicObjectStatus.STANDING: 
					standingTime = Utility.math.random(1000, 8000);
					elapsedTime = 0;
					if (animator != null)
					{
						changeAnimation(CharacterAnimation.STAND);
					}
					break;
				case DynamicObjectStatus.WALKING: 
					if (animator != null)
					{
						changeAnimation(CharacterAnimation.WALKING);
					}
					
					break;
				case DynamicObjectStatus.RUNNING: 
					if (animator != null)
					{
						changeAnimation(CharacterAnimation.RUN);
					}
					
					break;
				default: 
					changeAnimation(CharacterAnimation.STAND);
			}
		}
		
		override public function update():void
		{
			super.update();
			if (this.status == DynamicObjectStatus.STANDING && this.animator != null)
			{
				elapsedTime += Ticker.FRAME_TIME;
				if (elapsedTime >= standingTime)
				{
					this.moveToRandomPos();
					elapsedTime = 0;
				}
			}
		}
		
		private function moveToRandomPos():void
		{
			var posX:Number = Utility.math.random(CharacterManager.CHARACTER_AREA.x, CharacterManager.CHARACTER_AREA.x + CharacterManager.CHARACTER_AREA.width);
			var posY:Number = Utility.math.random(CharacterManager.CHARACTER_AREA.y, CharacterManager.CHARACTER_AREA.y + CharacterManager.CHARACTER_AREA.height);
			
			this.moveTo(new Point(posX, posY), 0);
		}
		
		protected function onRollOut(e:MouseEvent):void
		{
			this.filters = null;
		}

		protected function onRollOver(e:MouseEvent):void
		{
			this.filters = [glowFilter];
		}
		
		private function onAnimatorLoaded(e:Event):void
		{
			this.animator.play(0, 0);
			this.status = DynamicObjectStatus.STANDING;
			//animator.x = animator.width / 2;		
			//animator.y = animator.height;
			//Utility.log("animator pos is: " + animator.x + " // " + animator.y + " // " + animator.width + " // " + animator.height);
			
			/*var rectangle:Shape = new Shape(); // initializing the variable named rectangle
			rectangle.graphics.beginFill(0xFF0000); // choosing the colour for the fill, here it is red
			rectangle.graphics.drawRect(0, 0, animator.width, animator.height); // (x spacing, y spacing, width, height)
			rectangle.graphics.endFill(); // not always needed but I like to put it in to end the fill
			rectangle.alpha = 0.3;
			this.addChild(rectangle); // adds the rectangle to the stage*/
		}
		
		private function onEnterFrameHdl(e:Event):void
		{
			update();
		}
		
		public function loadIcon(url:String):void
		{
			var icon:BitmapEx = new BitmapEx();
			icon.load(url);
			//iconNpc.x = - this.width / 2;
			//iconNpc.y = - this.height - 20;
			//iconNpc.visible = false;
			iconNpc.addChild(icon);
			//icon.addEventListener(BitmapEx.LOADED, onBitmapLoadedHdl);
		}
		
		private function onBitmapLoadedHdl(e:Event):void 
		{
			/*var rectangle:Shape = new Shape(); // initializing the variable named rectangle
			rectangle.graphics.beginFill(0xFF0000); // choosing the colour for the fill, here it is red
			rectangle.graphics.drawRect(iconNpc.x, iconNpc.y, iconNpc.width, iconNpc.height); // (x spacing, y spacing, width, height)
			rectangle.graphics.endFill(); // not always needed but I like to put it in to end the fill
			rectangle.alpha = 0.5;
			Manager.display.getStage().addChild(rectangle); // adds the rectangle to the stage*/
		}
		
		public function setVisibleIcon(val:Boolean):void
		{
			iconNpc.visible = val;
		}
		
		public function getIconNPC():MovieClip {
			return iconNpc;
		}
	}

}