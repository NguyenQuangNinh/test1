package components.scroll
{
    import com.greensock.TweenMax;
	import components.MouseWheel;
	import components.ObjectUtils;
	import flash.display.DisplayObject;
	import flash.display.SimpleButton;
	import flash.display.Stage;
	import flash.text.TextField;

	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author DefaultUser (Tools -> Custom Arguments...)
	 */
	public class VerScrollText 
	{
		public var masker:Sprite;
		public var content:TextField;
		public var track:DisplayObject;
		public var face:DisplayObject;
		public var upBtn:DisplayObject;
		public var downBtn:DisplayObject;
		private var stage:Stage;
	
		protected var sSize:int;
		protected var sRange:int;
		protected var _duration:Number;
		protected var isScrolled:Boolean = false;
		protected var scroll:Sprite;
		protected var isFull:Boolean;
		protected var direction:int;
		protected var speed:int;
		
		public function VerScrollText( content:TextField, scroll:Sprite, isFull:Boolean = false, speed:int = 1 ) 
		{
			this.stage = scroll.stage;
			direction = -1;
			content.mask = masker;
			this.content = content;
			this.scroll = scroll;
			this.face = scroll["face"];
			this.track = scroll["track"];
			this.isFull = isFull;
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
			face.y = track.y;

			updateScroll();
			
			MouseWheel.getInstance().register(scroll, mouseWheelHdl);
			MouseWheel.getInstance().register(content, mouseWheelHdl);
			
			this.face.addEventListener(MouseEvent.MOUSE_DOWN, faceMouseDownHandler);
			initStageEvents();

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
	
		public function setContent(content:TextField):void
		{
			this.content = content;
			MouseWheel.getInstance().register(content, mouseWheelHdl);
			updateScroll();
		}
		
		protected function initStageEvents(e:Event = null):void 
		{
			if (isFull) this.stage.addEventListener(Event.ENTER_FRAME, enterFrameHdl);
		}
		
		// left btn ---
		protected function upBtnMouseDownHdl(e:MouseEvent):void 
		{
			if (direction == -1) this.stage.addEventListener(Event.ENTER_FRAME, enterFrameHdl);
			direction = 0;
		}
		
		protected function upBtnMouseUpHdl(e:MouseEvent):void 
		{		
			direction = -1;
			this.stage.removeEventListener(Event.ENTER_FRAME, enterFrameHdl);
		}
		// -------------
		
		// right btn ---
		protected function downBtnMouseDownHdl(e:MouseEvent):void 
		{
			if (direction == -1) this.stage.addEventListener(Event.ENTER_FRAME, enterFrameHdl);
			direction = 1;
		}
		
		protected function downBtnMouseUpHdl(e:MouseEvent):void 
		{
			direction = - 1;
			this.stage.removeEventListener(Event.ENTER_FRAME, enterFrameHdl);
		}
		// -------------
		
		protected function faceMouseDownHandler(e:MouseEvent):void 
		{
			ObjectUtils.getInstance().startDrag(face, new Rectangle(track.x, track.y, 0, track.height - face.height));
			this.stage.addEventListener(MouseEvent.MOUSE_UP, stageMouseUpHandler);	
			this.stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);	
		}
		
		protected function stageMouseUpHandler(e:MouseEvent):void 
		{
			ObjectUtils.getInstance().stopDrag(face);
			this.stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);	
			this.stage.removeEventListener(MouseEvent.MOUSE_UP, stageMouseUpHandler);
		}
		
		public function updateScroll():void 
		{
			sRange = track.height - face.height;
			face.y = (content.scrollV / content.maxScrollV) * sRange + track.y;
		}
		
		protected function setScrollVisible(visi:Boolean):void
		{
			scroll.visible = visi;
		}
		
		protected function mouseMoveHandler(e:MouseEvent):void 
		{
			var newScroll:int = ((face.y - track.y) / sRange) * content.maxScrollV;
			content.scrollV = newScroll;
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
			content.scrollV = ((face.y - track.y) / sRange) * content.maxScrollV;
		}
		
		protected function mouseWheelHdl(e:MouseEvent):void 
		{
			//if (scroll.visible) moveScroll(e.delta * 3);
			updateScroll();
		}
		
		protected function moveScroll(dis:Number):void
		{
			var newScroll:int = content.scrollV + dis;
			if (newScroll < 0) newScroll = 0;
			if (newScroll > content.maxScrollV) newScroll = content.maxScrollV;
			this.content.scrollV = newScroll;
			face.y = (content.scrollV / content.maxScrollV) * sRange + track.y;
		}
		
		public function isEndScroll():Boolean
		{
			return content.scrollV == content.maxScrollV;
		}
	}
	
}