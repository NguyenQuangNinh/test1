package game.ui.components
{
	import com.greensock.TweenMax;
	//import components.MouseWheel;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author hailua54@gmail.comhailua54@gmail.com
	 */
	public class HorScroll extends Sprite
	{
		public var masker:Sprite;
		public var content:Sprite;
		public var track:MovieClip;
		public var face:MovieClip;
		public var leftBtn:MovieClip;
		public var rightBtn:MovieClip;
	
		private var sSize:int;
		private var cSize:int;
		private var sRange:int;
		private var cRange:int;
		private var duration:Number;
		private var isScrolled:Boolean = false;
		private var scroll:Sprite;
		private var isFull:Boolean;
		private var direction:int;
		private var speed:int;
		private var isAutoSize:Boolean;
		
		public function HorScroll( masker:Sprite, content:Sprite, scroll:Sprite, isFull:Boolean = false, contentSize:int = -1, duration:Number = 0, speed:int = 3, isAutoSize:Boolean = false ) 
		{
			direction = -1;
			content.mask = masker;
			this.masker = masker;
			this.content = content;
			this.scroll = scroll;
			this.face = scroll["face"];
			this.face.buttonMode = true;
			this.track = scroll["track"];
			this.isFull = isFull;
			this.duration = duration;
			this.speed = speed;
			this.isAutoSize = isAutoSize;
			
			if (isFull) 
			{
				leftBtn = scroll["leftBtn"];
				rightBtn = scroll["rightBtn"];
				if (!leftBtn || !rightBtn) throw new Error("leftBtn or rightBtn is null!");
				this.sSize = leftBtn.width - 1;
			} else 
			{
				this.sSize = 0;
				if (!track || !face) throw new Error("track or face is null!");
			}
			this.content.x = this.masker.x;
			face.x = track.x;

			updateScroll(contentSize);
			
			MouseWheel.getInstance().register(scroll, mouseWheelHdl);
			this.face.addEventListener(MouseEvent.MOUSE_DOWN, faceMouseDownHandler);
			
			if (this.masker.stage) initStageEvents();
			else this.masker.addEventListener(Event.ADDED_TO_STAGE, initStageEvents);
			
			if (isFull) 
			{
				leftBtn.addEventListener(MouseEvent.MOUSE_DOWN, leftBtnMouseDownHdl);
				leftBtn.addEventListener(MouseEvent.MOUSE_UP, leftBtnMouseUpHdl);
				leftBtn.addEventListener(MouseEvent.MOUSE_OUT, leftBtnMouseUpHdl);
				
				rightBtn.addEventListener(MouseEvent.MOUSE_DOWN, rightBtnMouseDownHdl);
				rightBtn.addEventListener(MouseEvent.MOUSE_UP, rightBtnMouseUpHdl);
				rightBtn.addEventListener(MouseEvent.MOUSE_OUT, rightBtnMouseUpHdl);
			}
		}
		
		private function initStageEvents(e:Event = null):void 
		{
			this.masker.removeEventListener(Event.ADDED_TO_STAGE, initStageEvents);
			this.masker.stage.addEventListener(MouseEvent.MOUSE_UP, faceMouseUpHandler);
			this.masker.stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);		
			if (isFull) this.masker.stage.addEventListener(Event.ENTER_FRAME, enterFrameHdl);
		}
	
		// left btn ---
		private function leftBtnMouseDownHdl(e:MouseEvent):void 
		{
			if (direction == -1) this.masker.stage.addEventListener(Event.ENTER_FRAME, enterFrameHdl);
			direction = 0;
		}
		
		private function leftBtnMouseUpHdl(e:MouseEvent):void 
		{		
			direction = -1;
			this.masker.stage.removeEventListener(Event.ENTER_FRAME, enterFrameHdl);
		}
		// -------------
		
		// right btn ---
		private function rightBtnMouseDownHdl(e:MouseEvent):void 
		{
			if (direction == -1) this.masker.stage.addEventListener(Event.ENTER_FRAME, enterFrameHdl);
			direction = 1;
		}
		
		private function rightBtnMouseUpHdl(e:MouseEvent):void 
		{
			direction = - 1;
			this.masker.stage.removeEventListener(Event.ENTER_FRAME, enterFrameHdl);
		}
		// -------------
		
		private function faceMouseUpHandler(e:MouseEvent):void 
		{
			isScrolled = false;
			face.stopDrag();
		}
		
		private function faceMouseDownHandler(e:MouseEvent):void 
		{
			isScrolled = true;
			face.startDrag(false, new Rectangle(track.x, face.y, track.width - face.width, 0));
		}
		
		public function updateScroll(contentSize:int = -1, isReset:Boolean = false):void 
		{
			if (isReset) content.x = masker.x;
			if (contentSize == -1) contentSize = content.width;
			
			if (contentSize <= masker.width)
			{
				setScrollVisible(false);
				content.x = masker.x;
				return;
			} else setScrollVisible(true);
			this.cSize = contentSize;
			//update content position
			if (content.x > masker.x) content.x = masker.x;
			if (content.x < masker.x - (cSize - masker.width)) content.x = masker.x - (cSize - masker.width);
			
			if (isAutoSize)
			{
				if (!isFull) 
				{
					track.width = masker.width - 2;
					track.x = 0;
				} else 
				{
					track.width = masker.width - 2 * sSize; // subtract 2 button's size
					track.x = sSize;
					leftBtn.x = 0;
					rightBtn.x = masker.width - 1;
				}
				face.width = track.width * (masker.width / content.width);
			}
			
			sRange = track.width - face.width;
			cRange = cSize - masker.width;
			
			face.x = track.x + ((masker.x - content.x) / cRange) * sRange;
		}
		
		private function setScrollVisible(visi:Boolean):void
		{
			scroll.visible = visi;
		}
		
		private function mouseMoveHandler(e:MouseEvent):void 
		{
			if (isScrolled) {
				var contentX:int = masker.x - ((face.x - track.x) / sRange) * cRange;
				if (duration == 0) {
					content.x = contentX;
				} 
				else TweenMax.to( content, duration, { x: contentX } );
			}
		}
		
		public function setContentPos(pos:int, duration:Number = 0.5):void 
		{
			var newX:int = pos;
			if (newX > masker.x) newX = masker.x;
			if (newX < masker.x - (cSize - masker.width)) newX = masker.x - (cSize - masker.width);
			TweenMax.to( this.content, duration, { x: newX } );
			var newFacePos:int = track.x + ((masker.x - content.x) / cRange) * sRange;
			TweenMax.to( this.face, duration, { x: newFacePos } );
		}
		
		private function enterFrameHdl(e:Event):void 
		{
			if (direction == -1) return;
			if (direction == 0) { // left
				moveScroll(speed);
			}
			if (direction == 1) { // right
				moveScroll(- speed);
			}
		}
		
		private function mouseWheelHdl(e:MouseEvent):void 
		{
			if (scroll.visible) moveScroll(e.delta * speed);
		}
		
		private function moveScroll(dis:Number):void
		{
			content.x += dis;
			if (content.x > masker.x) content.x = masker.x;
			if (content.x < masker.x- cRange) content.x = masker.x - cRange;
			face.x = track.x + ((masker.x - content.x) / cRange) * sRange;
		}
	}
	
}