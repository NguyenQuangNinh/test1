package  {
	import br.com.stimuli.string.printf;
	import flash.external.ExternalInterface;
	import flash.system.Capabilities;
	import flash.system.Security;
	
	/**
	 * Utility class to output logging message to flash log or browser's console.
	 * <p>
	 * As our convention, all <code>trace()</code> calls must be replaced with <code>Logger.log()</code>
	 * @example
	 * <listing>
	 * import com.pyco.framework.utils.Logger
	 * 
	 * //Send a simple message to flash log (trace) or console:
	 * Logger.log("Hello World!");
	 * 
	 * //Send a formatted message:
	 * var name: String = "PFF";
	 * Logger.logf("%s rules", name); //output: PFF rules
	 * 
	 * //Send a warning message:
	 * Logger.warn("Cannot load asset", id, url); //output: ?? Warning: Cannot load asset,galleryXML,xml/gallery.xml
	 * 
	 * //Filter
	 * Logger.filter = "conan";
	 * Logger.log("conan trace something"); //only this log is output
	 * Logger.log("mickey trace something"); //this log is suppressed
	 * 
	 * //Get the call stack where this script is invoked:
	 * Logger.traceCallStack("I'm here");
	 * 
	 * //Turn console log off:
	 * Logger.useConsole = false;
	 * 
	 * //Turn Logger off:
	 * Logger.enabled = false;
	 * </listing>
	 * </p>
	 * @author Thanh Tran
	 */
	public class Logger {
		/** 
		 * Set this to <code>false</code> to disable all log outputs.
		 * @default true
		 * @see #useTrace
		 * @see #useConsole
		 */
		public static var enabled: Boolean = true;
		/**
		 * Set this to <code>false</code> to suppress all <code>trace()</code> outputs.
		 * @default true
		 * @see #enabled
		 * @see #useConsole
		 */
		public static var useTrace: Boolean = true;
		/**
		 * Set this to <code>false</code> to suppress all console outputs.
		 * @default true
		 * @see #enabled
		 * @see #useTrace
		 */
		public static var useConsole: Boolean = true;
		/**
		 * Set filter string to display a group of log.
		 * <p>
		 * Regular expressions are allowed; case is insensitive.<br>
		 * Note: this filter is only applied to <code>log()</code> and <code>logf()</code>.
		 * @example
		 * <listing>
		 * Logger.filter = "complete$";
		 * Logger.log("Preload complete");
		 * Logger.log("Prestartup Complete");
		 * Logger.log("Complete transition in");
		 * //Only "Preload complete" and "Prestartup Complete" are output
		 * </listing>
		 * </p>
		 * @default null
		 * @see #log()
		 * @see #logf()
		 */
		public static var filter: String;
		
		private static var loggerHelper: LoggerHelper;
		
		/**
		 * Send a formatted message to flash log or browser's console.
		 * <p>The format syntax is similar to <code>com.pyco.framework.utils.StringUtil.format()</code>.</p>
		 * @param	format	The base text to be parsed
		 * @param	...args	list of values to substitute
		 * @see	com.pyco.framework.utils.StringUtil#format()
		 * @see #log()
		 */
		public static function logf(format: String, ...args): void {
			args.unshift(format);
			log(printf.apply(null, args));
		}
		
		/**
		 * Send a simple message to flash log or browser's console
		 * @param	...args	list of values to log
		 * @see #logf()
		 * @see #filter
		 */
		public static function log(...args): void {
			output("", "console.log", args);
		}
		
		/**
		 * Send a formatted INFO message to flash log or browser's console.
		 * <p>The format syntax is similar to <code>com.pyco.framework.utils.StringUtil.format()</code>.</p>
		 * @param	format	The base text to be parsed
		 * @param	...args	list of values to substitute
		 * @see	com.pyco.framework.utils.StringUtil#format()
		 * @see #info()
		 */
		public static function infof(format: String, ...args): void {
			args.unshift(format);
			info(printf.apply(null, args));
		}
		
		/**
		 * Send an info message to flash log or browser's console.
		 * <p>
		 * In flash log, the message is preceded with <code>INFO:</code><br/>
		 * In console, it is marked as an info message (i).
		 * </p>
		 * @param	...args	list of values to output
		 * @see #infof()
		 */
		public static function info(...args): void {
			output("INFO: ", "console.info", args);
		}
		
		/**
		 * Send a formatted WARNING message to flash log or browser's console.
		 * <p>The format syntax is similar to <code>com.pyco.framework.utils.StringUtil.format()</code>.</p>
		 * @param	format	The base text to be parsed
		 * @param	...args	list of values to substitute
		 * @see	com.pyco.framework.utils.StringUtil#format()
		 * @see #warn()
		 */
		public static function warnf(format: String, ...args): void {
			args.unshift(format);
			warn(printf.apply(null, args));
		}
		
		/**
		 * Send a warning message to flash log or browser's console.
		 * <p>
		 * In flash log, the message is preceded with <code>?? Warning:</code><br/>
		 * In console, it is marked as a warning message (!).
		 * </p>
		 * @param	...args	list of values to output
		 * @see #warnf()
		 */
		public static function warn(...args): void {
			output("?? Warning: ", "console.warn", args);
		}
		
		/**
		 * Send a formatted ERROR message to flash log or browser's console.
		 * <p>The format syntax is similar to <code>com.pyco.framework.utils.StringUtil.format()</code>.</p>
		 * @param	format	The base text to be parsed
		 * @param	...args	list of values to substitute
		 * @see	com.pyco.framework.utils.StringUtil#format()
		 * @see #error()
		 */
		public static function errorf(format: String, ...args): void {
			args.unshift(format);
			error(printf.apply(null, args));
		}
		
		/**
		 * Send an error message to flash log or browser's console.
		 * <p>
		 * In flash log, the message is preceded with <code>!! Error:</code><br/>
		 * In console, it is marked as an error message (X).
		 * </p>
		 * @param	...args	list of values to output
		 * @see #errorf()
		 */
		public static function error(...args): void {
			output("!! Error: ", "console.error", args);
		}
		
		/**
		 * @private
		 * @param	...args
		 */
		public static function version(...args): void {
			output("", "console.info", args);
		}
		
		private static function output(tracePrefix: String, consoleFunction: String, args: Array): void {
			if (enabled) {
				if (!loggerHelper) loggerHelper = new LoggerHelper();
				var output: String = args.join(", ");
				var reg: RegExp = new RegExp(filter,"i");//apply filter here
				if (consoleFunction != "console.log" || !filter || reg.test(output)) {
					if (useConsole && loggerHelper.consoleAvailable) ExternalInterface.call(consoleFunction , output);
					if (useTrace) trace(tracePrefix + output);
				}
			}
		}
		
		/**
		 * Get the call stack where this function is invoked.
		 * <p>
		 * Compile the project with <code>debug=true</code> to see line numbers.<br/>
		 * @example
		 * <listing>
		 * //In Main's contructor, we call this method:
		 * Logger.traceCallStack("I'm in Main's constructor");
		 * 
		 * //Here's the output:
		 * ----------------------------------------
		 *    Viewing the call stack: I'm in Main's constructor
		 *    at Main()[D:/FlashProjects/pycoflashminisite/trunk/src/src/Main.as:82]
		 *    at AppDoc/startup()[D:/FlashProjects/pycoflashminisite/trunk/src/src/AppDoc.as:62]
		 *    at com.pyco.framework.core::AppDocBase/enterFrameHandler()[D:/FlashProjects/pycoflashminisite/trunk/src/lib/com/pyco/framework/core/AppDocBase.as:64]
		 * ----------------------------------------
		 * </listing>
		 * </p>
		 * @param	extraNote
		 */
		public static function traceCallStack(extraNote: String = ""): void {
			var st: String;
			try {
				throw new Error("Viewing the call stack: " + extraNote);
			} catch (e:Error) {
				st = e.getStackTrace();
				st = st.replace("Error: ", "----------------------------------------\n");
				st = st.replace(/\tat utils.tools::Logger[^ ]*\n/, "");	//remove the stack trace of this function
				st = st.replace(/\\/g, "/"); //replace back slash (\) with forward slash (/) for console display compatibility
				st += "\n----------------------------------------";
				log(st);
			}
			
		}
		
		public static var debug:Boolean = true;
		public static function _trace(string:String):void
		{
			if (debug)
			{
				trace(string);
			}
		}
	}

}
import flash.external.ExternalInterface;
import flash.system.Capabilities;
import flash.system.Security;

internal class LoggerHelper {
	private var inBrowser:Boolean;
	private var canCallContainer:Boolean;
	private var hasConsole: Boolean = false;
	private var checkConsoleJS: String = "function (){ if(typeof(console) != 'undefined' && console != null) return true; else return false;}";
	
	public function LoggerHelper() {
		inBrowser = (Capabilities.playerType == "ActiveX" || Capabilities.playerType == "PlugIn");
		//trace( "inBrowser : " + inBrowser );
		canCallContainer = ExternalInterface.available && (Security.sandboxType == "remote" || Security.sandboxType == "localTrusted");
		//trace( "canCallBrowser : " + canCallContainer );
		if (inBrowser && canCallContainer)
			hasConsole = (String(ExternalInterface.call(checkConsoleJS)) == "true")? true : false;
		//trace( "hasConsole : " + hasConsole );
	}
	
	public function get consoleAvailable(): Boolean {
		return hasConsole;
	}
	
}