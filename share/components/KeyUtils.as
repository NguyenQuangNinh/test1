/**
 * Created by anhnnv on 22/08/2014.
 */
package components
{
    import flash.display.Stage;
    import flash.events.KeyboardEvent;
    import flash.utils.Dictionary;

    public class KeyUtils
    {

        public static var stage : Stage;
        public static var keysDown : Array = new Array();
        public static var initialised : Boolean = false;
		
        public static var keyDownCallbacks : Dictionary = new Dictionary(false);

        public function KeyUtils()
        {
        }


        static public function init(s:Stage) : void
        {
            if(initialised)
            {
               return;
            }

            stage = s;
            stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
            stage.addEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
            initialised = true;

        }

        static public function keyDownHandler(event : KeyboardEvent) : void
        {
            keysDown[event.keyCode] = true;
            //trace("keyDown", keyDownCallbacks, event.charCode);
            for(var key : * in keyDownCallbacks)
            {
                if(key is Function)
                {
                    var callBack : Function = key as Function;
                    callBack(event.charCode, event.clone());
                    //trace("callBack", key);
                }

            }

        }
        static public function keyUpHandler(event : KeyboardEvent) : void
        {
            keysDown[event.keyCode] = false;

        }

        static public function isDown(index : int) : Boolean
        {
            if(!initialised)
            {
                return false;


            }
            return keysDown[index];

        }

        static public function addKeyDownCallback(callback : Function) : void
        {
            //      trace("adding callback");
            keyDownCallbacks[callback] = true;

        }
		
		static public function removeKeyDownCallback(callback : Function) : void
        {
            //      trace("adding callback");
            keyDownCallbacks[callback] = false;

        }

    }

}
