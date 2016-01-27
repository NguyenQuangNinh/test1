package game.ui.components 
{
	import com.greensock.TweenMax;
	import core.util.Enum;
	import core.util.Utility;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.geom.Point;
	import game.enum.FocusSignalType;
	import game.utility.UtilityUI;
	/**
	 * ...
	 * @author TrungLNM
	 */
	public class FocusSignal
	{
		
		//public static function showFocus(ID:int, target:MovieClip, show:Boolean, pos:Point):void {
		public static function showFocus(ID:int, target:MovieClip, show:Boolean):void {
			var _signal:DisplayObject;
			var _tween:TweenMax;
			var focusType:FocusSignalType = Enum.getEnum(FocusSignalType, ID) as FocusSignalType;
			if (!focusType) {
				Utility.log("can not focus by error ID");
				return;
			}
			
			if (!target) {
				Utility.log("can not focus on null target");
				return;
			}
			
			var checkExist:Boolean = focusType && target.getChildByName(focusType.name) != null;
			if (!checkExist) {				
				switch(ID) {
					case FocusSignalType.SIGNAL_COMPLETE.ID:
						_signal = UtilityUI.getComponent(UtilityUI.SIGNAL_COMPLETE);
						break;
					case FocusSignalType.SIGNAL_RED_ALERT.ID:
						_signal = UtilityUI.getComponent(UtilityUI.SIGNAL_RED_ALERT);
						break;
					case FocusSignalType.SIGNAL_NEW.ID:
						_signal = UtilityUI.getComponent(UtilityUI.SIGNAL_NEW);					
						break;
				}
				_signal.name = focusType.name;
				_signal.x = target.width - _signal.width;
				_signal.y = -_signal.height / 2;
				//_signal.x = pos.x - _signal.width;
				//_signal.y = pos.y - _signal.height / 2;
				target.addChild(_signal);
				//_tween = new TweenMax(_signal, 0.4, { y: _signal.y - 20, yoyo: true, repeat: -1 } );
				_tween = new TweenMax(_signal, 0.4, { y: - 20, yoyo: true, repeat: -1 } );
			}else {
				_signal = target.getChildByName(focusType.name);
				_tween = TweenMax.getTweensOf(_signal)[0];
			}			
			
			if(_signal && _tween) {
				_signal.visible = show;
				_tween._active = show;
			}
		}
		
		public static function removeAllFocus(target:MovieClip):void {
			if (!target) {
				Utility.log("can not remove focus on null target");
				return;
			}
			
			for each(var focusType:FocusSignalType in Enum.getAll(FocusSignalType)) {
				var _signal:DisplayObject = target.getChildByName(focusType.name);
				if(_signal) {
					_signal.visible = false;
					//TweenMax.killTweensOf(_signal, false);
					var tweenArr:Array = TweenMax.getTweensOf(_signal);
					for each(var tween:TweenMax in tweenArr) {
						tween._active = false;
					}
				}
			}
		}
	}

}