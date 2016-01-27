package game
{

import core.event.EventEx;
	import deng.fzip.FZip;
	import deng.fzip.FZipFile;
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.ProgressEvent;
    import flash.external.ExternalInterface;
	import flash.filters.GlowFilter;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.ByteArray;
	import flash.utils.getDefinitionByName;
	import game.utility.Tracker;
	
	/**
	 * ...
	 * @author TrungLNM
	 */
	
	[SWF(frameRate="60", width="1260", height="650")]
	public class Launcher extends MovieClip 
	{	
		private var gameObject:Sprite;
		
		[Embed(source="../../assets/intro.jpg")]
		public static var LogoImage:Class;
		
		[Embed(source="../../assets/key.zip", mimeType="application/octet-stream")]
		public static var key:Class;
		
		private var logo:Bitmap;
		private var txtLoading:TextField;
		private var parameters:Object;
		private var processID: int = Math.random() * 999999; // Fake process ID dung de phan biet user mo 2 tab hoac refresh game
		private var tracker:Tracker;
		private var so6TrackingURL:String = "";
		
		public function Launcher():void
		{
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		protected function onAddedToStage(event:Event):void
		{
			tracker = new Tracker(root.loaderInfo.parameters["user"], processID, so6TrackingURL);
			tracker.track(0, "show launcher");
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			logo = Bitmap(new LogoImage());
			//logo.x = (stage.stageWidth - logo.width)/2;
			//logo.y = (stage.stageHeight - logo.height)/2;
			addChild(logo);
			logo.width = stage.stageWidth;
			logo.scaleY = logo.scaleX;
			
			txtLoading = new TextField();
			//txtLoading.autoSize = TextFieldAutoSize.LEFT;
			txtLoading.selectable = false;
			var format:TextFormat = txtLoading.defaultTextFormat;
			format.size = 14;
			format.font = "Arial";
			format.bold = true;
			format.letterSpacing = 1.5;
			format.align = TextFormatAlign.CENTER;
			txtLoading.defaultTextFormat = format;
			txtLoading.text = "Đang tải .";
			txtLoading.width = stage.stageWidth;
			txtLoading.textColor = 0xffff9e;
			//txtLoading.x = (1260 - txtLoading.width)/2 + 30;
			txtLoading.y = stage.stageHeight * 0.7;
			var glow:GlowFilter = new GlowFilter(0x281804, 1, 3, 3, 10, 2);
			txtLoading.filters = [glow];
			addChild(txtLoading);
			
			parameters = root.loaderInfo.parameters;
			if(ExternalInterface.available == false)
			{
				parameters.rooturl = "";
				parameters.version = "";
			} 
			
			tracker.track(1, "start loading main.swf");
			
			if (parameters["mode"] && parameters["mode"] == "1") {
				var loader:Loader = new Loader();
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadSWFComplete);
				loader.load(new URLRequest(parameters.rooturl + "main.swf?version=" + parameters.version), new LoaderContext(true, ApplicationDomain.currentDomain));
			} else {
				var binLoader:URLLoader = new URLLoader();
				binLoader.dataFormat = URLLoaderDataFormat.BINARY;
				binLoader.addEventListener(Event.COMPLETE, onLoadZipComplete);
				binLoader.addEventListener(ProgressEvent.PROGRESS, onProgressHandler);
				binLoader.load(new URLRequest(parameters.rooturl + "main.swf?version=" + parameters.version));
			}
			
			stage.addEventListener(Event.RESIZE, onResizeHdl);
		}
		
		private function onResizeHdl(e:Event):void 
		{
			logo.width = stage.stageWidth;
			logo.scaleY = logo.scaleX;
			txtLoading.width = stage.stageWidth;
			txtLoading.y = stage.stageHeight * 0.7;
		}
		
		private function onProgressHandler(e:ProgressEvent):void 
		{
			txtLoading.text = "Đang tải giao diện (" + int(e.bytesLoaded*100/e.bytesTotal) + "%)";
		}
		
		protected function onLoadZipComplete(event:Event):void
		{
			tracker.track(2, "start decoding main.swf");
			var loader:URLLoader = event.target as URLLoader;
			loader.removeEventListener(Event.COMPLETE, onLoadZipComplete);
			var k:ByteArray = new key();
			
			var data:ByteArray = loader.data as ByteArray;
			data.position = 0;
			//data.writeInt(0x504b0304);
			data.writeInt(k.readInt());
			
			var zip:FZip = new FZip();
			zip.addEventListener(Event.COMPLETE, parseZipComplete);
			zip.loadBytes(data);
		}
		
		protected function parseZipComplete(event:Event):void
		{
			tracker.track(3, "start adding main.swf");
			
			var zip:FZip = event.target as FZip;
			zip.removeEventListener(Event.COMPLETE, parseZipComplete);
			
			var file:FZipFile = zip.getFileAt(0);
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadSWFComplete);
			loader.loadBytes(file.content, new LoaderContext(false, ApplicationDomain.currentDomain));
		}
		
		private function loadSWFComplete(event:Event):void 
		{
			tracker.track(4, "complete adding main.swf");
			
			var extraInfo:Object = new Object();
			extraInfo.processID = this.processID;
			extraInfo.timestamp = tracker.getTimestamp();
			extraInfo.so6TrackingURL = so6TrackingURL;
			extraInfo.user = root.loaderInfo.parameters.user;
			
			var loaderInfo:LoaderInfo = LoaderInfo(event.target);
			loaderInfo.removeEventListener(Event.COMPLETE, loadSWFComplete);
			try
			{
				var gameClass:Class = getDefinitionByName("game.Main") as Class;
				gameObject = new gameClass() as Sprite;
				gameObject.addEventListener("game_ready", onGameReady);
				gameObject.addEventListener("update_progress", onGameUpdateProgress);
				Object(gameObject).init(stage, root.loaderInfo.parameters, extraInfo);
			}
			catch(e:Error)
			{
				trace(e.getStackTrace());
			}
		}
		
		private function onGameUpdateProgress(e:EventEx):void 
		{
			txtLoading.text = e.data as String;
		}
		
		protected function onGameReady(event:Event):void
		{
			if(stage != null)
			{
				stage.removeEventListener(Event.RESIZE, onResizeHdl);
				stage.addChild(gameObject);
				stage.removeChild(this);
			}
		}
	}
}