/**
 * Created by NinhNQ on 8/21/2014.
 */
package game.utility {
import flash.display.Shape;
import flash.events.Event;
import flash.utils.Dictionary;
import flash.utils.getTimer;

public class TimerEx {

    private static var notifiedList:Array;
    private static var dictionary:Dictionary;
    private static var before:int = 0; // thoi diem enterframe truoc
    private static var after:int = 0; // thoi diem enterframe hien tai
    private static var seed:Shape;
    private static var incresement:int = 0;

    /*static initializer */
    {
        before 		= getTimer();
        notifiedList= new Array();
        dictionary 	= new Dictionary();
        seed		= new Shape();
        seed.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
    }

    static public function startTimer(interval:int = 1000, repeat:int = 0, updateHandler:Function = null, finishHandler:Function = null):int {

        if (interval > 0) {

            var id:int = incresement;
            var timer:Timer = new Timer(id, interval, repeat, updateHandler, finishHandler);
            timer.addEventListener(Timer.FINISHED, finishedTimerHandler);

            notifiedList.push(timer);
            dictionary[id] = timer;

            incresement++;

            return id;
        } else {

            Logger.log("TimerManager > startTimer() > interval param can't be 0 or less");
            return -1;
        }
    }

    static public function stopTimer(timerID:int):void {
        var timer:Timer = dictionary[timerID] as Timer;

        if (timer) {
            var index:int = notifiedList.indexOf(timer);
            notifiedList.splice(index, 1);
            dictionary[timerID] = null;

            timer.reset();
            timer.removeEventListener(Timer.FINISHED, finishedTimerHandler);
        }
    }

	static public function getElapsedTime(timerID:int):int {
		var timer:Timer = dictionary[timerID] as Timer;

		if (timer) {
			return timer.totalTimeElapsed;
		}

		return 0;
	}

	static public function getRemainTime(timerID:int):int {
		var timer:Timer = dictionary[timerID] as Timer;

		if (timer) {
			return timer.interval - timer.totalTimeElapsed;
		}

		return 0;
	}

    static public function isRunning(timerID:int):Boolean
    {
        return dictionary[timerID] != null;
    }

    static private function finishedTimerHandler(e:Event):void {
        var timer:Timer = e.target as Timer;
        timer.removeEventListener(Timer.FINISHED, finishedTimerHandler);
        timer.reset();

        var index:int = notifiedList.indexOf(timer);
        notifiedList.splice(index, 1);
        dictionary[timer.id] = null;
    }

    static private function enterFrameHandler(e:Event):void {
        var timer:Timer;
        var elapsedTime:int;

        after = getTimer();
        elapsedTime = after - before;
        before = after;

        for (var i:int = 0; i < notifiedList.length; i++) {

            timer = notifiedList[i] as Timer;
            timer.notify(elapsedTime);

        }
    }
}
}
import flash.events.Event;
import flash.events.EventDispatcher;

internal class Timer extends EventDispatcher {

    public static const FINISHED:String = "finished";
    public var id:int = 0;
    public var interval:int = 1000;
    public var updateHandler:Function;
    public var finishHandler:Function;
    public var repeat:int = 0;

    public var totalTimeElapsed:int = 0;

    public function Timer(id:int, interval:int, repeat:int, updateHandler:Function, finishHandler:Function):void {
        this.id = id;
        this.interval = interval;
        this.updateHandler = updateHandler;
        this.finishHandler = finishHandler;
        this.repeat = repeat;
        totalTimeElapsed = 0;
    }

    public function reset():void {
        interval = 1000;
        updateHandler = null;
        finishHandler = null;
        repeat = 0;
        totalTimeElapsed = 0;
    }

    public function notify(timeElapsed:int):void {

        totalTimeElapsed += timeElapsed;

        while (totalTimeElapsed >= interval) {

            update();

            totalTimeElapsed -= interval;

            if (repeat > 0) { // lap voi so lan co gioi han

                repeat--;
                if (repeat <= 0) {
                    finish();
                    return;
                }
            }

        }
    }

    private function update():void {
        if (updateHandler != null) updateHandler();
    }

    private function finish():void {
        if (finishHandler != null) finishHandler();
        dispatchEvent(new Event(FINISHED));
    }
}