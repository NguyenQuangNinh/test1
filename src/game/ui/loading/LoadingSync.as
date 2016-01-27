package game.ui.loading
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.Timer;
	/**
	 * ...
	 * @author hailua54@gmail.com
	 */
	public class LoadingSync extends MovieClip
	{
		public var titleTf:TextField;
		
		private var title:String;
		
		public var bg:Sprite;
		public var timer:Timer;
		private var dotCount:int;
		
		private var bgHeight:uint = 30;
		private var isShowPercent:Boolean;
		
		public function LoadingSync() 
		{
			bg = new Sprite();
			addChild(bg);
			bg.y = - bgHeight / 2;
			
			titleTf = new TextField();
			var tfm:TextFormat = new TextFormat("arial", 11, 0xFFFFFF, false, false); 
			titleTf.defaultTextFormat = tfm;
			addChild(titleTf);
			titleTf.height = 20;
			titleTf.y = - 9;
			
			timer = new Timer(500);
			timer.addEventListener(TimerEvent.TIMER, onTimerHdl);
			if (stage) init();
			else this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			this.x = stage.stageWidth / 2;
			this.y = stage.stageHeight / 2;
			var hit:Sprite = new Sprite();
			addChildAt(hit, 0);
			graphics.beginFill(0x333333, 0.3);
			graphics.drawRect(- stage.stageWidth / 2, - stage.stageHeight / 2, stage.stageWidth, stage.stageHeight);
			graphics.endFill();
		}
		
		private function onTimerHdl(e:TimerEvent):void 
		{
			var str:String = title + " ";
			for ( var i:int = 0; i < dotCount; i++ ) str += ".";
			titleTf.text = str;
			dotCount++;
			if (dotCount > 3) dotCount = 0;
		}
		
		public function show(title:String, isShowPercent:Boolean = false):void
		{
			this.isShowPercent = isShowPercent;
			this.visible = true;
			this.title = title;
			
			if (!isShowPercent) 
			{
				titleTf.text = title + " ...";
				timer.start();
			} else titleTf.text = title + " 100%";
			updateView();
		}
		
		public function hide():void
		{
			this.visible = false;
			timer.stop();
		}
		
		public function updatePercent(percent:uint):void
		{
			if (isShowPercent) titleTf.text = title + " " + percent.toString() + "%";
		}
		
		private function updateView():void
		{
			titleTf.width = titleTf.textWidth + 3;
			titleTf.x = - titleTf.width / 2;
			bg.graphics.clear();
			bg.graphics.lineStyle(2, 0x000000);
			bg.graphics.beginFill(0x333333, 0.6);
			bg.graphics.drawRect(0, 0, titleTf.width + 6, bgHeight);
			bg.graphics.endFill();
			bg.x = - bg.width / 2;
			titleTf.text = title;
		}
	}

}