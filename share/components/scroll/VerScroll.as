package components.scroll
{
    import com.greensock.TweenMax;
	import components.event.BaseEvent;
	import components.MouseWheel;
	import components.ObjectUtils;
	import flash.display.DisplayObject;
	import flash.events.EventDispatcher;

	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author DefaultUser (Tools -> Custom Arguments...)
	 */
	public class VerScroll extends EventDispatcher
	{
		public static const VERSCROLL_CHANGE_POS:String = "VERSCROLL_CHANGE_POS";
		public var masker:Sprite;
		public var content:Sprite;
		public var track:DisplayObject;
		public var face:DisplayObject;
		public var upBtn:DisplayObject;
		public var downBtn:DisplayObject;
	
		protected var sSize:int;
		protected var cSize:int;
		protected var sRange:int;
		protected var cRange:int;
		protected var _duration:Number;
		protected var isScrolled:Boolean = false;
		protected var scroll:Sprite;
		protected var isFull:Boolean;
		protected var direction:int;
		protected var speed:int;
		
		public function VerScroll( masker:Sprite, content:Sprite, scroll:Sprite, contentSize:int = -1, isFull:Boolean = false, duration:Number = 0.3, speed:int = 3 ) 
		{
			direction = -1;
			content.mask = masker;
			this.masker = masker;
			this.content = content;
			this.scroll = scroll;
			this.face = scroll["face"];
			this.track = scroll["track"];
			this.isFull = isFull;
			this._duration = duration;
			this.speed = speed;
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
			MouseWheel.getInstance().register(content, mouseWheelHdl);
			
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
	
		protected function initStageEvents(e:Event = null):void 
		{
			this.masker.removeEventListener(Event.ADDED_TO_STAGE, initStageEvents);
			if (isFull) this.masker.stage.addEventListener(Event.ENTER_FRAME, enterFrameHdl);
		}
		
		// left btn ---
		protected function upBtnMouseDownHdl(e:MouseEvent):void 
		{
			if (direction == -1) this.masker.stage.addEventListener(Event.ENTER_FRAME, enterFrameHdl);
			direction = 0;
		}
		
		protected function upBtnMouseUpHdl(e:MouseEvent):void 
		{		
			direction = -1;
			this.masker.stage.removeEventListener(Event.ENTER_FRAME, enterFrameHdl);	
		}
		// -------------
		
		// right btn ---
		protected function downBtnMouseDownHdl(e:MouseEvent):void 
		{
			if (direction == -1) this.masker.stage.addEventListener(Event.ENTER_FRAME, enterFrameHdl);
			direction = 1;
		}
		
		protected function downBtnMouseUpHdl(e:MouseEvent):void 
		{
			direction = - 1;
			this.masker.stage.removeEventListener(Event.ENTER_FRAME, enterFrameHdl);
		}
		// -------------
		
		protected function stageMouseUpHandler(e:MouseEvent):void 
		{
			ObjectUtils.getInstance().stopDrag(face);
			this.masker.stage.removeEventListener(MouseEvent.MOUSE_UP, stageMouseUpHandler);
			this.masker.stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
		}
		
		protected function faceMouseDownHandler(e:MouseEvent):void 
		{
			ObjectUtils.getInstance().startDrag(face, new Rectangle(track.x, track.y, 0, track.height - face.height));
			this.masker.stage.addEventListener(MouseEvent.MOUSE_UP, stageMouseUpHandler);
			this.masker.stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);	
		}
		
		public function updateScroll(contentSize:int = -1):void 
		{
			if (contentSize == -1) contentSize = content.height;
			this.cSize = contentSize;
	
			if (content.y < masker.y - (cSize - masker.height)) content.y = masker.y - (cSize - masker.height);
			if (content.y > masker.y) content.y = masker.y;
			
			if (contentSize <= masker.height)
			{
				setScrollVisible(false);
				return;
			} else setScrollVisible(true);

			sRange = track.height - face.height;
			cRange = cSize - masker.height;
			
			face.y = track.y + ((masker.y - content.y) / cRange) * sRange;
		}
		
		protected function setScrollVisible(visi:Boolean):void
		{
			scroll.visible = visi;
		}
		
		protected function mouseMoveHandler(e:MouseEvent):void 
		{
			var contentY:int = masker.y - ((face.y - track.y) / sRange) * cRange;
			TweenMax.to( content, _duration, { y: contentY } );
			dispatchEvent(new BaseEvent(VERSCROLL_CHANGE_POS, contentY));
		}
		
		public function setContentPos(pos:int, duration:Number = 0.5):void 
		{
			var newY:int = pos;
			if (newY < masker.y - (cSize - masker.height)) newY = masker.y - (cSize - masker.height);
			if (newY > masker.y) newY = masker.y;
			TweenMax.to( this.content, duration, { y: newY } );
			var newFacePos:int = track.y + ((masker.y - newY) / cRange) * sRange;
			TweenMax.to( this.face, duration, { y: newFacePos } );
			dispatchEvent(new BaseEvent(VERSCROLL_CHANGE_POS, newY));
		}
		
		protected function enterFrameHdl(e:Event):void 
		{
			if (direction == -1) return;
			if (direction == 0) { // left
				if (face.y - speed > track.y) {
					face.y -= speed;
				} else {
					face.y = track.y;
				}
			}
			if (direction == 1) { // right
				if (face.y + speed < track.y + sRange) {
					face.y += speed;
				} else {
					face.y = track.y + sRange;
				}
			}
			content.y = masker.y - ((face.y - track.y) / sRange) * cRange;
			dispatchEvent(new BaseEvent(VERSCROLL_CHANGE_POS, content.y));
		}
		
		protected function mouseWheelHdl(e:MouseEvent):void 
		{
			if (scroll.visible) moveScroll(e.delta * 10 * speed);
		}
		
		protected function moveScroll(dis:Number):void
		{
			var newY:int = content.y + dis;
			if (newY < masker.y - (cSize - masker.height)) newY = masker.y - (cSize - masker.height);
			if (newY > masker.y) newY = masker.y;
			//this.content.y = newY;
			TweenMax.to( this.content, _duration, { y: newY } );
			var newFacePos:int = track.y + ((masker.y - newY) / cRange) * sRange;
			//face.y = newFacePos;
			TweenMax.to( this.face, _duration, { y: newFacePos } );
			dispatchEvent(new BaseEvent(VERSCROLL_CHANGE_POS, newY));
		}
		
		public function reset():void
		{
			setContentPos(masker.y, 0);
		}
	}
	
}