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
	 * @author hailua54@gmail.com	hailua54@gmail.com
	 */
	public class VerScroll extends Sprite
	{
		public var masker:Sprite;
		public var content:Sprite;
		public var track:MovieClip;
		public var face:MovieClip;
		public var upBtn:MovieClip;
		public var downBtn:MovieClip;
	
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
		
		public function VerScroll( masker:Sprite, content:Sprite, scroll:Sprite, isFull:Boolean = false, contentSize:int = -1, duration:Number = 0, speed:int = 5, isAutoSize:Boolean = false ) 
		{
			direction = -1;
			content.mask = masker;
			this.masker = masker;
			this.content = content;
			this.scroll = scroll;
			this.face = scroll["face"];
			this.track = scroll["track"];
			this.isFull = isFull;
			this.duration = duration;
			this.speed = speed;
			this.isAutoSize = isAutoSize;
			
			if (isFull) 
			{
				upBtn = scroll["upBtn"];
				downBtn = scroll["downBtn"];
				if (!upBtn || !downBtn) throw new Error("upBtn or downBtn is null!");
				this.sSize = upBtn.height - 1;
			} else
			{
				this.sSize = 0;
				if (!track || !face) throw new Error("track or face is null!");
			}
			this.content.y = this.masker.y;
			face.y = track.y;

			updateScroll(contentSize);
			
			MouseWheel.getInstance().register(scroll, mouseWheelHdl);
			this.face.addEventListener(MouseEvent.MOUSE_DOWN, faceMouseDownHandler);
			
			if (this.masker.stage) initStageEvents();
			else this.masker.addEventListener(Event.ADDED_TO_STAGE, initStageEvents);
			
			if (isFull) 
			{
				upBtn.addEventListener(MouseEvent.MOUSE_DOWN, upBtnMouseDownHdl);
				upBtn.addEventListener(MouseEvent.MOUSE_UP, upBtnMouseUpHdl);
				upBtn.addEventListener(MouseEvent.MOUSE_OUT, upBtnMouseUpHdl);
				
				downBtn.addEventListener(MouseEvent.MOUSE_DOWN, downBtnMouseDownHdl);
				downBtn.addEventListener(MouseEvent.MOUSE_UP, downBtnMouseUpHdl);
				downBtn.addEventListener(MouseEvent.MOUSE_OUT, downBtnMouseUpHdl);
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
		private function upBtnMouseDownHdl(e:MouseEvent):void 
		{
			if (direction == -1) this.masker.stage.addEventListener(Event.ENTER_FRAME, enterFrameHdl);
			direction = 0;
		}
		
		private function upBtnMouseUpHdl(e:MouseEvent):void 
		{		
			direction = -1;
			this.masker.stage.removeEventListener(Event.ENTER_FRAME, enterFrameHdl);
		}
		// -------------
		
		// right btn ---
		private function downBtnMouseDownHdl(e:MouseEvent):void 
		{
			if (direction == -1) this.masker.stage.addEventListener(Event.ENTER_FRAME, enterFrameHdl);
			direction = 1;
		}
		
		private function downBtnMouseUpHdl(e:MouseEvent):void 
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
			face.startDrag(false, new Rectangle(face.x, track.y, 0, track.height - face.height));
		}
		
		public function updateScroll(contentSize:int = -1, isReset:Boolean = false):void 
		{
			if (isReset) this.content.y = this.masker.y;
			
			if (contentSize == -1) contentSize = content.height;
			if (contentSize <= masker.height)
			{
				setScrollVisible(false);
				this.content.y = this.masker.y;
				return;
			} else setScrollVisible(true);
			
			this.cSize = contentSize;
			//update content position
			
			if (content.y > masker.y) content.y = masker.y;
			if (content.y < masker.y - (cSize - masker.height)) content.y = masker.y - (cSize - masker.height);
			
			if (isAutoSize)
			{
				if (!isFull) 
				{
					track.height = masker.height;
					track.y = 0;
				} else 
				{
					track.height = masker.height - 2 * sSize; // subtract 2 button's size
					track.y = sSize;
					upBtn.y = 0;
					downBtn.y = masker.height - 1;
				}
				face.height = track.height * (masker.height / content.height);
			}
			sRange = track.height - face.height;
			cRange = cSize - masker.height;
			
			face.y = track.y + ((masker.y - content.y) / cRange) * sRange;
		}
		
		private function setScrollVisible(visi:Boolean):void
		{
			scroll.visible = visi;
		}
		
		private function mouseMoveHandler(e:MouseEvent):void 
		{
			if (isScrolled) {
				var contentY:int = masker.y - ((face.y - track.y) / sRange) * cRange;
				if (duration == 0) {
					content.y = contentY;
				} 
				else TweenMax.to( content, duration, { y: contentY } );
			}
		}
		
		public function setContentPos(pos:int, duration:Number = 0.5):void 
		{
			var newY:int = pos;
			if (newY > masker.y) newY = masker.y;
			if (newY < masker.y - (cSize - masker.height)) newY = masker.y - (cSize - masker.height);
			TweenMax.to( this.content, duration, { y: newY } );
			var newFacePos:int = track.y + ((masker.y - content.y) / cRange) * sRange;
			TweenMax.to( this.face, duration, { y: newFacePos } );
		}
		
		private function enterFrameHdl(e:Event):void 
		{
			if (direction == -1) return;
			if (direction == 0) { // top
				moveScroll(speed);
			}
			if (direction == 1) { // bottom
				moveScroll(- speed);
			}
		}
		
		private function mouseWheelHdl(e:MouseEvent):void 
		{
			if (scroll.visible) moveScroll(e.delta * speed);
		}
		
		private function moveScroll(dis:Number):void
		{
			content.y += dis;
			if (content.y > masker.y) content.y = masker.y;
			if (content.y < masker.y - cRange) content.y = masker.y - cRange;
			face.y = track.y + ((masker.y - content.y) / cRange) * sRange;
		}
		
	}
	
}