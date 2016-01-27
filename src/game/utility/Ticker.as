
package game.utility {
	//import com.demonsters.debugger.MonsterDebugger;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.utils.getTimer;
	//import utils.time.event.TickEvent;
	
	/**
	 * ...
	 * @author ninh
	 */
	public class Ticker
	{
		public static const FRAME_RATE:int = 30;
		public static const FRAME_TIME:int = int(1000 / FRAME_RATE);
		
		private static var instance	:Ticker;
		
		private var before		:int = 0;
		private var after		:int = 0;
		private var seed		:Shape;
		private var period		:int = 0;
		private var delta		:int = 0;
		
		private var enterFrameFunctionList	:Array;
		private var enterTickFunctionList	:Array;
		private var _updateCallbacks:Array/*<Function>*/ = [];
		
		private var frameCount:int = 0;
		private var time:int = 0;
		
		public function Ticker(p_key:SingletonBlocker) {
			if (p_key != null) {
				enterFrameFunctionList	= new Array();
				enterTickFunctionList	= new Array();
				period 		= 1000 / FRAME_RATE;
				before 		= getTimer();
				seed		= new Shape();
				seed.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
			} else {
				throw new Error("Error: Instantiation failed: Use Ticker.getInstance() instead of new.");
			}
		}
		
		public static function getInstance():Ticker {
			if (instance == null)
				instance = new Ticker(new SingletonBlocker());
			return instance;
		}
		
		private function enterFrameHandler(e:Event):void {
			var elapsedTime:int;
			
			after 		= getTimer();
			elapsedTime	= after - before;
			before		= after;
			
			delta += elapsedTime - period;
			var i:int = 0;
			if (delta >= period)
			{
				while (delta >= period) {
					delta -= period;
					for (i = 0; i < enterTickFunctionList.length; i++) 
						enterTickFunctionList[i]();
				}
			}
			
			var isWait:Boolean = false;
			if (delta <= - period) {
				delta += period;
				isWait = true;
				// do nothing to sync update and enterframe
			}
			
			if (!isWait) // normal call
			{
				for (i = 0; i < enterTickFunctionList.length; i++) 
					enterTickFunctionList[i]();
			}
				
			for (var j:int = 0; j < enterFrameFunctionList.length; j++) 
				enterFrameFunctionList[j]();
			
			for each(var callback:Function in _updateCallbacks)
			{
				if (callback != null)
				{
					callback(Number(elapsedTime)/1000);
				}
			}
		}
		
		public function addUpdateCallbackFunction(f:Function):void
		{
			var index:int = _updateCallbacks.indexOf(f);
			if (index == -1)
				_updateCallbacks.push(f);
		}
		
		public function removeUpdateCallbackFunction(f:Function):void
		{
			var index:int = _updateCallbacks.indexOf(f);
			if (index > -1)
				_updateCallbacks.splice(index,1);
		}
		
		public function addEnterFrameFunction(f:Function):void {
			var index:int = enterFrameFunctionList.indexOf(f);
			if (index == -1){
				enterFrameFunctionList.push(f);
				//Logger.log( "Ticker.addEnterFrameFunction > f : " + f );
			}
		}
		
		public function removeEnterFrameFunction(f:Function):void {
			var index:int = enterFrameFunctionList.indexOf(f);
			if (index > -1) {
				enterFrameFunctionList.splice(index, 1);
				//Logger.log( "Ticker.removeEnterFrameFunction > f : " + f );
			}
		}
		
		public function addEnterTickFunction(f:Function):void {
			var index:int = enterTickFunctionList.indexOf(f);
			if (index == -1)
				enterTickFunctionList.push(f);
		}
		
		public function removeEnterTickFunction(f:Function):void {
			var index:int = enterTickFunctionList.indexOf(f);
			if (index > -1)
				enterTickFunctionList.splice(index, 1);
		}
	}
}

internal class SingletonBlocker {}