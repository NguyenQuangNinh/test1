/**
 * @author Tam Tran, Hang Tran, Thanh Tran
 * @version Latest version 1.0
 * 
 * All features in this version:
 * _ optimization.
 * _ support horizontal mode. 
 * _ support horizontal mode by transforming form vertical. 
 * _ support for text input (correspondent to text area)
 * _ switch on/off mouse wheel: enableMouseWheel = true/false; (just for movie)
 * _ set mouse wheel speed: mouseWheelSpeed = 1; (max speed: 20) (just for movie)
 * _ set scroll speed: the value is between 0.01 and 1 (just for movie)
 * _ allow resize slider in proportion to the amount of content (support for movie and textfield).
 * _ allow resize track in proportion the the height/width of the mask
 * _ enable jumping: if (true) the slider will jump to the clicked point on the track.
 * _ support snapping.
 * How to use this class?
 * ...
 * 
 * 
 */

package game.ui.components {
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	
	import core.event.EventEx;
	
	public class ScrollBar extends Sprite {
		public static var MODE_VERTICAL: String = "vertical";
		public static var MODE_HORIZONTAL: String = "horizontal";
		public static var WHEEL_CONTENT: String = "wheelContent";
		public static var WHEEL_SLIDER: String = "wheelSlider";
		public static var CONTENT_MOV_CHANGE_POS	:String = "contentMovieChangePosition";
		
		public static var PADDING: Number = 2;
		public static const WHEEL_SPEED	:Number = 6;
		
		//reference movie : control scrollbar (name of childs in scroll movieclip)
		public var sliderMovie: MovieClip;
		public var trackMovie: MovieClip;
		public var upMovie: MovieClip;
		public var downMovie: MovieClip;
		
		//reference movie : content and mask
		private var maskMovie: MovieClip;
		private var contentMovie: MovieClip;
		//reference textfield
		private var contentText: TextField;
		
		//Variables
		private var mode: String = "";
		private var partEmpty: int = 0;
		private var min: Number = 0;
		private var max: Number = 0;
		private var contentStart: Number; //NaN
		private var endPos: Number = 0;
		private var scrollRange: Number = 0;
		private var contentRange: Number = 0;
		private var percentage: Number = 0;
		//private var scrollSpeed: Number = 0.1;
		private var bounds: Rectangle;
		private var rotateFromVerticalMode: Boolean = false;
		
		private var curEasingFactor: Number = 0.2;
		private var useMouseWheel: Boolean = true;
		private var distanceSnapping: Number = 0;
		private var isMouseDown: Boolean = false;
		private var willPreventUpdateScroll: Boolean = false; //use for textfield
		private var mousePos: Number = 0; // use for content touch
		private var contentMoving: Boolean = false; //use for content touch
		private var isSnapping: Boolean = false;
		
		private var _easingFactor: Number = 0.2;
		private var _contentHeight: Number = 0;
		private var _contentWidth: Number = 0;
		private var _isInit: Boolean = false;
		private var _enableJumping: Boolean = false;
		private var _wheelSpeed: Number = WHEEL_SPEED;
		private var _wheelTarget: String = WHEEL_SLIDER;
		private var _sliderResizable: Boolean = false;
		private var _trackResizable: Boolean = false;
		private var _contentTouch: Boolean = false;
		//maiptt
		private var currentContentMovPosY:int = 0;
		
		//CONSTRUCTOR
		public function ScrollBar() {
			mode = MODE_VERTICAL;
			hideScroll();					
			
			//here comes 9-scaling
			//var grid:Rectangle = new Rectangle(3, 3, sliderMovie.width - 6, sliderMovie.height - 6);
			//sliderMovie.scale9Grid = grid;
		}
		
		//INIT FUNCTION
		/**
		 * init scrollbar
		 * @param	content			InteractiveObject	content can be a movieclip or a textfield (with type is input text)
		 * @param	mask			MovieClip			a movie to mask (if content is a textfield mask must be null)
		 * @param	mode			String				vertical or horizontal, default is vertical
		 * @param	useMouseWheel	Boolean				if (true) the scrollbar can be scroll when mouse wheel
		 * @param	sliderResizable	Boolean				which decides whether to stretch the width or height of the slider in proportion to the amount of content.
		 * @param	trackResizable	Boolean				which decides whether to stretch the width or height of the track in proportion to the mask.
		 * @param	partEmpty		int					a distance adds to bottom,
		 * @param 	contentHeight	Number				height of showed content in Vertical mode
		 * @param 	contentWidth	Number				width of showed content in horizontal mode
		 */
			
		public function init(content: InteractiveObject, 
							mask: MovieClip = null, 
							mode: String = "vertical",
							useMouseWheel: Boolean = true, 
							sliderResizable: Boolean = true, 
							trackResizable: Boolean = false, 
							partEmpty: int = 0,
							contentHeight: Number = 0, 
							contentWidth: Number = 0): void
		{
			if (content is DisplayObjectContainer) {
				contentMovie = content as MovieClip;
				maskMovie = mask;		
				contentText = null;
			} else if (content is TextField) {
				contentText = content as TextField;
				contentMovie = null;
				maskMovie = null;
			}
			
			this.useMouseWheel = useMouseWheel;
			this.mode = (mode == MODE_HORIZONTAL) ? mode : MODE_VERTICAL;
			this.sliderResizable = sliderResizable;
			this.trackResizable = trackResizable;
			this.partEmpty = partEmpty;
			this.contentHeight = contentHeight;
			this.contentWidth = contentWidth;
			_wheelSpeed = WHEEL_SPEED;
			
			if (this.stage) initialize();
			else this.addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}
		
		private function addedToStageHandler(e: Event): void {
			initialize();
		}
				
		/** called when have a change about content, mask or scrollbar */
		public function reInit(): void {
			if (!_isInit) {
				throw Error ("reInit is called before init");
				return;
			}
			
			stopSliding(null);
			if (mode == MODE_VERTICAL) reInitVertical();
			else reInitHorizontal();
		}

		/** reInit values in vertical mode */
		private function reInitVertical(): void {
			contentMovie.y = contentStart;
			enableVScrollbar();
			setValues();
		}
		
		/** reInit values in horizontal mode */
		private function reInitHorizontal(): void {
			contentMovie.x = contentStart;
			enableHScrollbar();
			setValues();
		}
		
		/** init values and events*/
		private function initialize(): void {
			if (contentMovie && maskMovie) initValues();
			else setValues();
			
			buttonMode = true;
			initEvents();
			isInit = true;
		}
		
		/** init values */
		private function initValues(): void {
			this.contentMovie.mask = this.maskMovie;
			if (mode == MODE_VERTICAL) enableVScrollbar();
			else enableHScrollbar();
			setValues();
		}
		
		/** show or hide scrollbar in vertical mode */
		private function enableVScrollbar(): void {
			var h: Number = 0;
			h = (contentHeight == 0) ? contentMovie.height : contentHeight;
			if (maskMovie.height > h) hideScroll();
			else showScroll();
		}
		
		/** show or hide scrollbar in horizontal mode */
		private function enableHScrollbar(): void {
			var w: Number = 0;
			w = (contentWidth == 0) ? contentMovie.width : contentWidth;
			if (maskMovie.width > w) hideScroll();
			else showScroll();
		}
		
		/** init events */
		private function initEvents(): void {
			this.addEventListener(Event.REMOVED_FROM_STAGE, removeFromStageHandler);
			sliderMovie.addEventListener(MouseEvent.MOUSE_DOWN, sliderMoviePressHandler);
			trackMovie.addEventListener(MouseEvent.CLICK, trackMovieClickHandler);
			
			if (useMouseWheel && stage && contentMovie) stage.addEventListener(MouseEvent.MOUSE_WHEEL, mouseWheelHandler);
			//if (contentMovie) addEventListener(Event.ENTER_FRAME, scrollUpdateHandler);
			
			if (upMovie) upMovie.addEventListener(MouseEvent.MOUSE_DOWN, arrowPressHandler);
			if (downMovie) downMovie.addEventListener(MouseEvent.MOUSE_DOWN, arrowPressHandler);
			
			if (contentText) {
				contentText.addEventListener(Event.CHANGE, contentTextChangeHandler);
				contentText.addEventListener(Event.SCROLL, contentTextScrollHandler);
			}
			
			//Dong code nay co tinh cheat de sua loi cho 1 so truong hop scrollbar ko scroll dc khi init lan dau tien
			if (this.hasEventListener(Event.ENTER_FRAME)) {
				this.removeEventListener(Event.ENTER_FRAME, scrollUpdateHandler);
			}
		}
		
		
		private function scrollUpdateHandler(e: Event): void {
			var distance: Number = 0;
			if (mode == MODE_VERTICAL) { 
				distance = endPos - contentMovie.y;
				contentMovie.y += distance * easingFactor;
				if (currentContentMovPosY != contentMovie.y) {
					currentContentMovPosY = contentMovie.y;
					dispatchEvent(new EventEx(CONTENT_MOV_CHANGE_POS, currentContentMovPosY, true));
				}
			} else {
				distance = endPos - contentMovie.x;
				contentMovie.x += distance * easingFactor;
			}
			if (distance != 0 && Math.abs(distance) <= 0.3 && hasEventListener(Event.ENTER_FRAME) && !isMouseDown) {
				_wheelSpeed = WHEEL_SPEED;
				removeEventListener(Event.ENTER_FRAME, scrollUpdateHandler);
				if (mode == MODE_VERTICAL) contentMovie.y = endPos;
				else contentMovie.x = endPos;
			}
		}
		
		private function stopSliding(e: MouseEvent): void {	
			isMouseDown = false;
			sliderMovie.stopDrag();
			if (isSnapping) {
				var per: Number = Math.abs(contentStart - endPos) / contentRange;
				per = Math.min(1, Math.max(per, 0));
				if (mode == MODE_VERTICAL) sliderMovie.y = min + per * scrollRange;
				else  {
					if (rotateFromVerticalMode) sliderMovie.y = min + per * scrollRange;
					else sliderMovie.x = min + per * scrollRange;
				}
				//percent = per;
			}
			
			if (stage && stage.hasEventListener(MouseEvent.MOUSE_UP)) {
				stage.removeEventListener(MouseEvent.MOUSE_UP, stopSliding);
			}
			if (stage && stage.hasEventListener(MouseEvent.MOUSE_MOVE)) {
				stage.removeEventListener(MouseEvent.MOUSE_MOVE, updatePercent);
			}
			if (upMovie && upMovie.hasEventListener(Event.ENTER_FRAME)) {
				upMovie.removeEventListener(Event.ENTER_FRAME, arrowPressUpdateHandler);
			}
			if (downMovie && downMovie.hasEventListener(Event.ENTER_FRAME)) {
				downMovie.removeEventListener(Event.ENTER_FRAME, arrowPressUpdateHandler);
			}
		}
		
		private function updatePercent(e: MouseEvent): void {
			if (mode == MODE_VERTICAL) percentage = (sliderMovie.y - min) / scrollRange;	
			else {
				if (rotateFromVerticalMode) percentage = (sliderMovie.y - min) / scrollRange;	
				else percentage = (sliderMovie.x - min) / scrollRange;
			}
			
			if (contentText) updateContentText();
			if (contentMovie) updateContent(percentage);
			
			e.updateAfterEvent();
		}
		
		private function sliderMoviePressHandler(e: MouseEvent): void {
			isMouseDown = true;
			sliderMovie.startDrag(false, bounds);	
			stage.addEventListener(MouseEvent.MOUSE_MOVE, updatePercent);
			stage.addEventListener(MouseEvent.MOUSE_UP, stopSliding);
			stage.addEventListener(Event.MOUSE_LEAVE, mouseLeaveHandler);
			if (contentMovie) addEventListener(Event.ENTER_FRAME, scrollUpdateHandler);
		}
		
		private function mouseLeaveHandler(e: Event): void {
			stopSliding(null);
		}
		
		/** press up or down button */
		private function arrowPressHandler(e: MouseEvent): void {
			e.currentTarget.addEventListener(Event.ENTER_FRAME, arrowPressUpdateHandler);
			stage.addEventListener(MouseEvent.MOUSE_UP, stopSliding);
		}
		
		private function arrowPressUpdateHandler(event: Event): void {
			//trace( "ScrollBar.arrowPressUpdateHandler > event : ");
			var dir: int = (event.currentTarget == upMovie) ? -1 : 1;
			if (isSnapping) percent += (distanceSnapping / contentRange) * dir;
			else percent += 0.02 * dir;
		}
		
		/** set new positon for the content when scroll */
		private function updateContent(per: Number): void {
			if (isSnapping) {
				var deltaPercent: Number = distanceSnapping / contentRange;
				var ratio: Number = Math.round(per / deltaPercent);
				per = deltaPercent * ratio;
				per = Math.min(per, 1);
			}
			endPos = contentStart - per * contentRange;
		}
		
		private function mouseWheelHandler(e: MouseEvent): void {
			if (useMouseWheel && stage && this.maskMovie.hitTestPoint(stage.mouseX, stage.mouseY, false) && this.visible && this.parent.visible) {
				if (!hasEventListener(Event.ENTER_FRAME) && contentMovie) addEventListener(Event.ENTER_FRAME, scrollUpdateHandler);
				if (_wheelSpeed < 20) {
					_wheelSpeed ++;
				} 
				scrollData(e.delta);
				updatePercent(e);
			}
		}
		
		private function scrollData(q: int): void {
			var delta: Number;
			if (isSnapping) {
				delta = distanceSnapping / contentRange * scrollRange;
				delta = (q < 0) ? delta : -delta;
			} else {
				delta = - q * mouseWheelSpeed;
			}
			
			var des: Number; 
			if (wheelTarget == WHEEL_SLIDER) {
				if (mode == MODE_VERTICAL || (mode == MODE_HORIZONTAL && rotateFromVerticalMode)) {
					if (delta > 0)  des = Math.min(max, sliderMovie.y + delta);
					if (delta < 0) des = Math.max(min, sliderMovie.y + delta);
					sliderMovie.y = des; 
				} else {
					if (delta > 0) des = Math.min(max, sliderMovie.x + delta);
					if (delta < 0) des = Math.max(min, sliderMovie.x + delta);
					sliderMovie.x = des; 
				}
			} else if (wheelTarget == WHEEL_CONTENT) {
				percent += delta / contentRange;
			}
		}
		
		//click on track
		private function trackMovieClickHandler(e: MouseEvent): void {
			if (contentMovie) addEventListener(Event.ENTER_FRAME, scrollUpdateHandler);
			if (mode == MODE_VERTICAL || (mode == MODE_HORIZONTAL && rotateFromVerticalMode)) verticalTrackMovieClick();
			else horizontalTrackMovieClick();
			updatePercent(e);
		}
		
		private function verticalTrackMovieClick(): void {
			var mc: MovieClip = sliderMovie;
			var delta: Number = 0;
			var scrollMove: Number = 0;
			
			delta = this.mouseY - mc.height / 2;
			if (!enableJumping) {
				if (mc.y < delta) scrollMove += mc.height/2;
				else scrollMove -= mc.height / 2;
			} else {
				if (mc.y < delta) scrollMove += Math.abs(delta - mc.y);
				else scrollMove -= Math.abs(delta - mc.y);
			}
			sliderMovie.y += scrollMove;
			if (sliderMovie.y <= min) sliderMovie.y = min;
			if (sliderMovie.y >= max) sliderMovie.y = max;
		}
		
		private function horizontalTrackMovieClick(): void {
			var mc: MovieClip = sliderMovie;
			var delta: Number = 0;
			var scrollMove: Number = 0;
				
			delta = this.mouseX -  mc.width / 2;
			if (!enableJumping) {
				if (mc.x < delta) scrollMove += mc.width / 2;
				else scrollMove -= mc.width / 2;
			} else {
				if (mc.x < delta) scrollMove += Math.abs(delta - mc.x);
				else scrollMove -= Math.abs(delta - mc.x);
			}
			sliderMovie.x += scrollMove;
			if (sliderMovie.x <= min) sliderMovie.x = min;
			if (sliderMovie.x >= max) sliderMovie.x = max;
		}
		
		private function setValues(): void {
			if (mode == MODE_VERTICAL) setVerticalValues();
			else setHorizontalValues();
			percent = 0;
		}
		
		private function setVerticalValues(): void {
			if (contentMovie) {
				var temp: Number = (contentHeight == 0) ? contentMovie.height : contentHeight;
				if (isNaN(contentStart)) {
					contentStart = Math.round(contentMovie.y);
				} 
				contentMovie.y = contentStart;	
				currentContentMovPosY = contentMovie.y;
				dispatchEvent(new EventEx(CONTENT_MOV_CHANGE_POS, currentContentMovPosY, true));
				contentRange = temp + partEmpty - maskMovie.height;
				if (trackResizable) {
					trackMovie.height = maskMovie.height;
					if (upMovie) upMovie.y = trackMovie.y - upMovie.height - PADDING;
					if (downMovie) downMovie.y = trackMovie.y + trackMovie.height + PADDING;
				}
				if (sliderResizable) {
					//sliderMovie.height = Math.ceil((maskMovie.height / temp) * trackMovie.height);
					//sliderMovie.height = Math.max(trackMovie.height / 20, sliderMovie.height);
					if (sliderMovie["middleMov"]) {
						sliderMovie["middleMov"].height = Math.ceil((maskMovie.height / temp) * trackMovie.height);
						sliderMovie["middleMov"].height = Math.max(trackMovie.height / 20, sliderMovie["middleMov"].height);
						sliderMovie["footMov"].y = sliderMovie["middleMov"].y + sliderMovie["middleMov"].height;
					}else {						
						sliderMovie.height = Math.ceil((maskMovie.height / temp) * trackMovie.height);
						sliderMovie.height = Math.max(trackMovie.height / 20, sliderMovie.height);
					}
				}
			}
			sliderMovie.y = trackMovie.y;
			scrollRange = Math.ceil(trackMovie.height - sliderMovie.height);
			min = trackMovie.y;
			max = trackMovie.y + trackMovie.height - sliderMovie.height;
			bounds = new Rectangle(sliderMovie.x, min, 0 , scrollRange);
			_wheelSpeed = WHEEL_SPEED;
		}
		
		private function setHorizontalValues(): void {
			if (contentMovie) {
				var temp: Number = (contentWidth == 0) ? contentMovie.width : contentWidth;
				if (isNaN(contentStart)) {
					contentStart = Math.round(contentMovie.x);
				}
				contentMovie.x = contentStart;		
				contentRange = temp + partEmpty - maskMovie.width;
				
				if (trackResizable) {
					if (rotateFromVerticalMode) {
						trackMovie.height = maskMovie.width;
						if (upMovie) upMovie.y = trackMovie.y - upMovie.height - PADDING;
						if (downMovie) downMovie.y = trackMovie.y + trackMovie.height + PADDING;
					} else {
						trackMovie.width = maskMovie.width;
						if (upMovie) upMovie.x = trackMovie.x - upMovie.width - PADDING;
						if (downMovie) downMovie.x = trackMovie.x + trackMovie.width + PADDING;
					}
				}
				if (sliderResizable) {
					if (rotateFromVerticalMode) {
						if (sliderMovie["middleMov"]) {
							sliderMovie["middleMov"].height = Math.ceil((maskMovie.height / temp) * trackMovie.height);
							sliderMovie["middleMov"].height = Math.max(trackMovie.height / 20, sliderMovie["middleMov"].height);
							sliderMovie["footMov"].y = sliderMovie["middleMov"].y + sliderMovie["middleMov"].height;
						}else {
							sliderMovie.height = Math.ceil((maskMovie.height / temp) * trackMovie.height);
							sliderMovie.height = Math.max(trackMovie.height / 20, sliderMovie.height);
						}
					} else {
						if (sliderMovie["middleMov"]) {
							sliderMovie["middleMov"].width = Math.ceil((maskMovie.width / temp) * trackMovie.width);
							sliderMovie["middleMov"].width = Math.max(trackMovie.width / 20, sliderMovie["middleMov"].width);
							sliderMovie["footMov"].x = sliderMovie["middleMov"].x + sliderMovie["middleMov"].width;
						}else {
							sliderMovie.width = Math.ceil((maskMovie.width / temp) * trackMovie.width);
							sliderMovie.width = Math.max(trackMovie.width / 20, sliderMovie.width);
						}
					}
				}
			}
			if (rotateFromVerticalMode) {
				sliderMovie.y = trackMovie.y;
				scrollRange = Math.ceil(trackMovie.height - sliderMovie.height);
				min = trackMovie.y;
				max = trackMovie.y + trackMovie.height - sliderMovie.height;
				bounds = new Rectangle(sliderMovie.x, min, 0 , scrollRange);
			} else {
				sliderMovie.x = trackMovie.x;
				scrollRange = Math.ceil(trackMovie.width - sliderMovie.width);
				min = trackMovie.x;
				max = trackMovie.x + trackMovie.width - sliderMovie.width;
				bounds = new Rectangle(min, sliderMovie.y, scrollRange, 0);
			}
		}
		
		/** hide scrollbar */
		public function hideScroll(): void { this.visible = false; }
		
		/** show scrollbar */
		public function showScroll(): void { this.visible = true; }
		
		
		//========================================================
		//					CONTENT TOUCH
		//========================================================
		private function contentMouseDownHandler(e: MouseEvent): void {
			contentMovie.addEventListener(MouseEvent.MOUSE_MOVE, contentMouseMoveHandler, false, 0, true);
			//contentMovie.addEventListener(MouseEvent.MOUSE_UP, contentMouseUpHandler, false, 0, true);
			stage.addEventListener(MouseEvent.MOUSE_UP, contentMouseUpHandler, false, 0, true);
			mousePos = (mode == MODE_VERTICAL) ? stage.mouseY : stage.mouseX;
			//contentMoving = true;
		}
		
		
		private function contentMouseMoveHandler(e: MouseEvent): void {
			//if (contentMoving = true) {
				var delta: Number;
				if (mode == MODE_VERTICAL) {
					var h: Number = (contentHeight == 0) ? contentMovie.height : contentHeight;
					delta = stage.mouseY - mousePos;
					percent -= delta / h;
				} else {
					var w: Number = (contentWidth == 0) ? contentMovie.width : contentWidth;
					delta = stage.mouseX - mousePos;
					percent -= delta / w;
				}
				e.updateAfterEvent();
				mousePos = (mode == MODE_VERTICAL) ? stage.mouseY : stage.mouseX;
			//}
		}
		
		private function contentMouseUpHandler(e: MouseEvent): void {
			contentMovie.removeEventListener(MouseEvent.MOUSE_MOVE, contentMouseMoveHandler);
			//contentMovie.removeEventListener(MouseEvent.MOUSE_UP, contentMouseUpHandler);
			stage.removeEventListener(MouseEvent.MOUSE_UP, contentMouseUpHandler);
			contentMoving = false;
		}
		
		
		
		//use for textfield
		public function updateScrollBar(): void {
			if (contentText.maxScrollV > 1) {
				if (sliderResizable) {
					sliderMovie.height = Math.ceil((contentText.height / contentText.textHeight) * trackMovie.height);
					setValues();
				}
				showScroll();
				var value: int = Math.min(contentText.scrollV, contentText.maxScrollV);
				percent = (value - 1) / (contentText.maxScrollV - 1);
			} else {
				hideScroll();
			}
		}
		
		private function updateContentText():void {
			willPreventUpdateScroll = true;
			contentText.scrollV = int(percent * (contentText.maxScrollV + 1));
			willPreventUpdateScroll = false;
		}
		
		private function contentTextChangeHandler(e: Event): void {
			if (!willPreventUpdateScroll) updateScrollBar();
		}
		
		private function contentTextScrollHandler(e: Event): void {
			if (!willPreventUpdateScroll) updateScrollBar();
		}
		
		//==========================================================
		//					GETTER AND SETTER
		//==========================================================
		
		/** The percent is represented as a value between 0 and 1. */
		public function get percent(): Number { return percentage; }
		
		/** The percent is represented as a value between 0 and 1. */
		public function set percent(value: Number): void {
			if (!hasEventListener(Event.ENTER_FRAME) && contentMovie) addEventListener(Event.ENTER_FRAME, scrollUpdateHandler);
			percentage = Math.min( 1, Math.max( 0, value ) );
			if (mode == MODE_VERTICAL) sliderMovie.y = min + percentage * scrollRange;
			else {
				if (rotateFromVerticalMode) sliderMovie.y = min + percentage * scrollRange;
				else sliderMovie.x = min + percentage * scrollRange;
			}
			updateContent(percentage);
		}
		
		public function update():void
		{
			enableVScrollbar();
			contentRange = contentMovie.height + partEmpty - maskMovie.height;
			//contentStart = contentMovie.y;
			//setValues();
			/*contentMovie.y = contentStart;
			enableVScrollbar();
			setValues();*/
		}
		
		/** The wheelSpeed is represented as an integer value between 1 and 20 */
		public function get mouseWheelSpeed(): Number { return _wheelSpeed; }
		
		/** The wheelSpeed is represented as an integer value between 1 and 20 
		 * 	The wheelSpeed will be multiplied with MouseEvent.delta 
		 *  MouseEvent.delta ~> The number of lines that that each notch on the mouse wheel represents.
		 */
		public function set mouseWheelSpeed(value: Number): void {
			value = Math.max(1, value);
			//if (value < 1) value = 1;
			//if (value > 20) value = 20;
			_wheelSpeed = value;
		}
		
		public function get enableMouseWheel(): Boolean { return useMouseWheel; }
		
		/** this function will allow you enable mouse wheel or not*/
		public function set enableMouseWheel(value: Boolean): void {
			useMouseWheel = value;
			if (useMouseWheel && stage && !stage.hasEventListener(MouseEvent.MOUSE_WHEEL)) {
				stage.addEventListener(MouseEvent.MOUSE_WHEEL, mouseWheelHandler);
			}
		}
		
		public function get wheelTarget(): String { return _wheelTarget; }
		/** 
		 * Set target when mouse wheel
		 * The target can be content or slider (please use static constant WHEEL_CONTENT or WHEEL_SLIDER)
		 * Default, target is slider
		 * It means that when mouse wheel:
		 * if target is content, the content will move follow mouse wheel speed and the slider's position will be updated automatically correspondent with the content
		 * And the contrary will be happened if the target is slider.
		 */
		public function set wheelTarget(value: String): void {
			_wheelTarget = value;
		}
		
		public function get easingFactor(): Number { return _easingFactor; }
		
		/** this function allow you set scroll speed 
		 * the scroll speed is represented as value between 0.01 and 1.
		 * and the scroll speed will effect to wheel speed.
		 * default speed is 0.2
		 */
		public function set easingFactor(value: Number): void {
			if (value < 0.01) value = 0.01;
			if (value > 1) value = 1;
			_easingFactor = value;
		}
		
		
		public function set easing(value: Boolean): void {
			if (!value) {
				curEasingFactor = easingFactor;
				_easingFactor = 1;
			} else {
				easingFactor = curEasingFactor;
			}
		}
		
		/** 
		 * This function is used for textField
		 * which decides whether to stretch the height of the slider in proportion to the amount of content. 
		 */
		public function get sliderResizable(): Boolean { return _sliderResizable; }
		public function set sliderResizable(value: Boolean): void {
			_sliderResizable = value;
			if (!_sliderResizable) {
				if (mode == MODE_VERTICAL || (mode == MODE_HORIZONTAL && rotateFromVerticalMode)) sliderMovie.scaleY = 1;
				else sliderMovie.scaleX = 1;
			}
			if (isInit) reInit();
			//if (isInit) setValues();
		}
		
		public function get trackResizable(): Boolean { return _trackResizable; }
		public function set trackResizable(value: Boolean): void { 
			_trackResizable = value; 
			if (!_trackResizable) {
				if (mode == MODE_VERTICAL) trackMovie.scaleY = 1;
				else trackMovie.scaleX = 1;
			}
			if (isInit) reInit();
		}
		
		/** use hand cursor if rollover slider, up or down arrow*/
		override public function get buttonMode(): Boolean { return sliderMovie.buttonMode; }
		override public function set buttonMode(value: Boolean): void {
			sliderMovie.buttonMode = true;
			if (upMovie) upMovie.buttonMode = true;
			if (downMovie) downMovie.buttonMode = true;
		}
		
		public function get enableJumping(): Boolean { return _enableJumping; }
		public function set enableJumping(value: Boolean): void { _enableJumping = value; }
		
		public function get isInit(): Boolean { return _isInit; }
		public function set isInit(value: Boolean): void { _isInit = value;	}
		
		/**
		 * @param 	distance	
		 */
		public function setDistanceSnapping(distance: Number): void {
			if (distance < 5) {
				enableSnapping = false;
				return;
			} else {
				enableSnapping = true;
				distanceSnapping = distance;
			}
		}
		
		public function get enableSnapping(): Boolean { return isSnapping; }
		public function set enableSnapping(value: Boolean): void { 
			isSnapping = value; 
		}
		
		
		//set/get height of content
		public function get contentHeight(): Number { return _contentHeight; }
		public function set contentHeight(value: Number): void {
			_contentHeight = value;
			if (isInit) reInit();
		}
		
		public function get contentWidth(): Number { return _contentWidth; }
		public function set contentWidth(value: Number): void {
			_contentWidth = value;
			if (isInit) reInit();
		}
		
		public function get contentTouch(): Boolean { return _contentTouch; }
		public function set contentTouch(value: Boolean): void {
			_contentTouch = value;
			if (_contentTouch) {
				contentMovie.addEventListener(MouseEvent.MOUSE_DOWN, contentMouseDownHandler, false, 0, true);
				contentMovie.buttonMode = true;
			} else {
				contentMovie.buttonMode = false;
				if (contentMovie.hasEventListener(MouseEvent.MOUSE_DOWN)) {
					contentMovie.removeEventListener(MouseEvent.MOUSE_DOWN, contentMouseDownHandler);
				}
			}
		}
		
		/**
		 * create a horizontal scrollbar from vertical scrollbar
		 */
		public function vertical2Horizontal(): void {
			rotateFromVerticalMode = true;
			this.rotation = -90;
		}
		
		private function removeFromStageHandler(e: Event = null): void {
			sliderMovie.removeEventListener(MouseEvent.MOUSE_DOWN, sliderMoviePressHandler);
			trackMovie.removeEventListener(MouseEvent.CLICK, trackMovieClickHandler);
			
			if (upMovie) upMovie.removeEventListener(MouseEvent.MOUSE_DOWN, arrowPressHandler);
			if (downMovie) downMovie.removeEventListener(MouseEvent.MOUSE_DOWN, arrowPressHandler);
			
			if (stage && stage.hasEventListener(MouseEvent.MOUSE_WHEEL)) {
				stage.removeEventListener(MouseEvent.MOUSE_WHEEL, mouseWheelHandler);
			}
				
			if (this.hasEventListener(Event.ENTER_FRAME)) {
				this.removeEventListener(Event.ENTER_FRAME, scrollUpdateHandler);
			}
			
			if (contentText) {
				contentText.removeEventListener(Event.CHANGE, contentTextChangeHandler);
				contentText.removeEventListener(Event.SCROLL, contentTextScrollHandler);
			}
		}
	}
}
