package game.main 
{
	import com.greensock.TimelineMax;
	import com.greensock.TweenMax;
	import com.greensock.easing.Linear;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.utils.clearTimeout;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;
	
	import core.Manager;
	import core.display.BitmapEx;
	import core.display.animation.Animator;
	import core.event.EventEx;
	import core.util.FontUtil;
	import core.util.Utility;
	
	import game.data.vo.skill.Skill;
	import game.enum.DragDropEvent;
	import game.enum.Font;
	import game.ui.tooltip.TooltipEvent;
	import game.ui.tooltip.TooltipID;
	
	/**
	 * ...
	 * @author bangnd2
	 */
	public class SkillSlot extends MovieClip 
	{
		public static const NONE		:int = 1;
		public static const INGAME		:int = 2;
		
		public static const WIDTH		:int = 36;
		public static const HEIGHT		:int = 36;
		
		static public const SKILL_SLOT_CLICK	:String = "skill_slot_click";
		static public const SKILL_SLOT_DCLICK	:String = "skill_slot_double_click";	
		static public const SKILL_SLOT_DRAG		:String = "skill_slot_drag";
		
		public var movIconContainer	:MovieClip;
		public var movLeft		:MovieClip;
		public var movLeftMask	:MovieClip;
		public var movRight		:MovieClip;
		public var movRightMask	:MovieClip;
		public var txtHotkey	:TextField;
		
		private var _data		:Skill;
		private var bmpSkillIcon:BitmapEx;
		private var cooldownTimeline	:TimelineMax;
		private var skillEnabled		:Boolean;
		private var type				:int;
		private var animSkillEnabled	:Animator;
		private var coolingDown:Boolean = false;
		private var _isMouseDown:Boolean = false;
		private var _clickStarted:int = -1;
		private var _mouseTimeOut:int;
		private var _isEnableDrag:Boolean = true;		
		
		public function SkillSlot() 
		{
			bmpSkillIcon = new BitmapEx();
			movIconContainer.addChild(bmpSkillIcon);
			bmpSkillIcon.addEventListener(BitmapEx.LOADED, onBitmapLoadedHdl);
			mouseChildren = false;
			
			
			cooldownTimeline = new TimelineMax({paused:true, onStart:onStartCooldown, onComplete:onCompleteCooldown});
			cooldownTimeline.append(new TweenMax(movRightMask, 0.5, { rotation:180, ease:Linear.easeNone} ));
			cooldownTimeline.append(new TweenMax(movLeftMask, 0.5, { rotation:180, ease:Linear.easeNone} ));
			cooldownTimeline.totalProgress(1);
			
			FontUtil.setFont(txtHotkey, Font.TAHOMA, true);
			setHotkey(0);
			
			buttonMode = true;
			type = NONE;
			
			animSkillEnabled = Manager.pool.pop(Animator) as Animator;
			animSkillEnabled.reset();
			//animSkillEnabled.x = 18;
			//animSkillEnabled.y = 18;
			animSkillEnabled.load("resource/anim/ui/fx_skillingame.banim");
			animSkillEnabled.stop();
			animSkillEnabled.visible = false;
			movIconContainer.addChild(animSkillEnabled);

			addEventListener(MouseEvent.ROLL_OVER, onIconMouseOverHdl);
			addEventListener(MouseEvent.ROLL_OUT, onIconMouseOutHdl);
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDownHdl);
			addEventListener(MouseEvent.CLICK, onMouseClickHdl);
		}
		
		private function onStartCooldown():void
		{
			coolingDown = true;
		}
		
		private function onCompleteCooldown():void
		{
			coolingDown = false;
		}
		
		public function enableDrag(enable:Boolean): void {
			_isEnableDrag = enable;
		}
		
		private function onMouseClickHdl(e:MouseEvent):void 
		{
			if (_clickStarted && (getTimer() - _clickStarted < DragDropEvent.MAX_TIME_FOR_CLICK)) {
				//this is a double click
				clearTimeout(_mouseTimeOut);
				Utility.log("skill slot double click event fired");
				_clickStarted = -1;				
				dispatchEvent(new EventEx(SKILL_SLOT_DCLICK, _data, true));
			}else {
				_clickStarted = getTimer();
				_mouseTimeOut = setTimeout(clickHdl, DragDropEvent.MAX_TIME_FOR_CLICK);	
			}
		}
		
		private function clickHdl():void 
		{
			Utility.log("skill slot click event fired");
			_clickStarted = -1;
			dispatchEvent(new EventEx(SKILL_SLOT_CLICK, _data, true));
		}
		
		private function onMouseDownHdl(e:MouseEvent):void 
		{						
			if (_data != null) {
				addEventListener(MouseEvent.MOUSE_OUT, onMouseOutHdl);
				addEventListener(MouseEvent.MOUSE_UP, onMouseUpHdl);
				_isMouseDown = true;
			}
		}
		
		private function onMouseOutHdl(e:MouseEvent):void 
		{
			removeEventListener(MouseEvent.MOUSE_UP, onMouseUpHdl);
			removeEventListener(MouseEvent.MOUSE_OUT, onMouseOutHdl);			
			if (_isMouseDown && _isEnableDrag) {
				//reset flag
				_isMouseDown = false;
				
				//this is a drag
				var objDrag:BitmapEx = new BitmapEx(34, 34);
				objDrag.load(bmpSkillIcon.url);
				objDrag.name = "mov_drag";
				dispatchEvent(new EventEx(SKILL_SLOT_DRAG, {target: objDrag, data: _data, x:e.stageX, y:e.stageY,
							from: DragDropEvent.FROM_SKILL_UPGRADE }, true));
			}
		}
		
		private function onMouseUpHdl(e:MouseEvent):void
		{
			removeEventListener(MouseEvent.MOUSE_UP, onMouseUpHdl);
			removeEventListener(MouseEvent.MOUSE_OUT, onIconMouseOutHdl);	
			_isMouseDown = false;
		}
		
		public function setHotkey(hotkey:int):void
		{
			txtHotkey.visible = hotkey > 0;
			txtHotkey.text = hotkey.toString();
		}
		
		public function destroy():void {
			_data = null;
			if (bmpSkillIcon.hasEventListener(BitmapEx.LOADED)) {
				bmpSkillIcon.removeEventListener(BitmapEx.LOADED, onBitmapLoadedHdl);
			}
			bmpSkillIcon = null;
	
			Manager.pool.push(animSkillEnabled);
		}
		
		private function onIconMouseOutHdl(e:MouseEvent):void {
			if (_data) {
				dispatchEvent(new EventEx(TooltipEvent.HIDE_TOOLTIP, null, true));	
			}
		}
		
		private function onIconMouseOverHdl(e:MouseEvent):void 
		{
			if (_data) {
				switch(type) {
					case NONE:
						dispatchEvent(new EventEx(TooltipEvent.SHOW_TOOLTIP, {type:TooltipID.SKILL_SLOT, value: _data}, true));
						break;
						
					case INGAME:
						if (_data.xmlData) {
							dispatchEvent(new EventEx(TooltipEvent.SHOW_TOOLTIP, { type:TooltipID.SIMPLE, value: _data.xmlData.name }, true));
						}
						break;
				}
			}
		}
		
		public function cooldown(time:Number):void
		{
			cooldownTimeline.timeScale(1 / time);
			cooldownTimeline.restart();
		}
		
		public function setEnabled(value:Boolean):void
		{
			if (_data) {
				if (value) {
					animSkillEnabled.visible = true;
					animSkillEnabled.play(0, -1);	
				} else {
					animSkillEnabled.visible = false;
					animSkillEnabled.stop();
				}	
			} else {
				animSkillEnabled.visible = false;
				animSkillEnabled.stop();
			}
			skillEnabled = value;
			TweenMax.to(bmpSkillIcon, 0, { colorMatrixFilter: { saturation: value ? 1 : 0 } } );
		}
		
		private function onBitmapLoadedHdl(e:Event):void {
			if (bmpSkillIcon) {
				bmpSkillIcon.x = - bmpSkillIcon.width / 2;
				bmpSkillIcon.y = -bmpSkillIcon.height / 2;
			}
		}
		
		public function setType(value:int):void {
			type = value;
		}
		
		public function getData():Skill { return _data; }
		public function setData(data:Skill):void
		{
			_data = data;
			if (data != null && data.xmlData != null){
				bmpSkillIcon.load(data.xmlData.iconURL);
			} else {
				bmpSkillIcon.reset();
			}
		}
		
		public function isUsable():Boolean
		{
			return (_data != null && isCoolingDown() == false && skillEnabled);
		}
		
		public function showHotKey(show:Boolean): void {
			txtHotkey.visible = show;
		}
		
		public function isCoolingDown():Boolean { return coolingDown; }
		public function pauseCooldown():void { cooldownTimeline.pause(); }
		public function resumeCooldown():void { cooldownTimeline.resume(); }
		public function getRemainCooldown():Number 
		{
			var result:Number = 0;
			if(_data != null && _data.xmlData != null) result = (1 - cooldownTimeline.totalProgress()) * _data.xmlData.cooldown;
			return result;
		};
		public function resetCooldown():void 
		{
			cooldownTimeline.totalProgress(1, false);
		}
	}

}