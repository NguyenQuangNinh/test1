package core 
{
	import core.display.DisplayManager;
	import core.display.layer.LayerManager;
	import core.display.ModulesManager;
	import core.memory.MemoryPool;
	import core.resource.ResourceManager;
	import core.time.TimeManager;
	import core.tutorial.TutorialManager;
	import flash.display.Stage;

	/**
	 * ...
	 * @author bangnd2
	 */
	public class Manager 
	{
		public static var resource:ResourceManager;
		public static var time:TimeManager;
		public static var display:DisplayManager;
		public static var module:ModulesManager;
		public static var layer:LayerManager;
		public static var pool:MemoryPool;
		public static var tutorial:TutorialManager;
		
		public static function initialize(stage:Stage, gameWidth:int, gameHeight:int, rootURL:String, version:String):void 
		{
			resource = new ResourceManager(rootURL, version);
			time = new TimeManager(stage);
			display = new DisplayManager(stage, gameWidth, gameHeight);
			module = new ModulesManager();
			layer = new LayerManager();
			pool = new MemoryPool();
			tutorial = new TutorialManager(stage);
		}
	}

}