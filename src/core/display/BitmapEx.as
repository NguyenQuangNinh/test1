package core.display
{
	import core.util.Utility;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BitmapDataChannel;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import core.Manager;
	
	public class BitmapEx extends Bitmap
	{
		public static const LOADED:String = "bitmapex_loaded";
		
		public var url:String;
		
		private var source:BitmapData;
		private var clipWidth:int;
		private var clipHeight:int;
		private var clipRect:Rectangle = new Rectangle();
		private var useAlphaMask:Boolean;
		private var maskURL:String;
		
		public function BitmapEx(width:int = 0, height:int = 0)
		{
			setSize(width, height);
		}
		
		public function setSize(width:int, height:int):void
		{
			clipWidth = width;
			clipHeight = height;
		}
		
		public function destroy():void
		{
			reset();
			clipRect = null;
			url = null;
			maskURL = null;
		}
		
		public function reset():void
		{
			filters = [];
			if (source != null)
			{
				source = null;
				bitmapData.dispose();
			}
			else
				bitmapData = null;
			setSize(0, 0);
			scrollTo(0, 0);
			useAlphaMask = false;
			this.scaleX = 1;
			this.scaleY = 1;
			this.x = 0;
			this.y = 0;
		}
		
		public function load(url:String, useAlphaMask:Boolean = false):void
		{
			this.url = url;
			this.useAlphaMask = useAlphaMask;
			this.bitmapData = null;
			if (useAlphaMask)
			{
				maskURL = url.replace(".", "_mask.");
				Manager.resource.load([url, maskURL], onLoadBitmapComplete);
			}
			else
			{
				Manager.resource.load([url], onLoadBitmapComplete);
			}
			
		}
		
		private function onLoadBitmapComplete():void
		{
			var bitmapData:BitmapData = null;
			if (useAlphaMask)
			{
				var source:BitmapData = Manager.resource.getResourceByURL(url);
				var alphaMask:BitmapData = Manager.resource.getResourceByURL(maskURL);
				bitmapData = new BitmapData(source.width, source.height, true, 0);
				bitmapData.copyPixels(source, source.rect, new Point());
				bitmapData.copyChannel(alphaMask, alphaMask.rect, new Point(), BitmapDataChannel.RED, BitmapDataChannel.ALPHA);
			}
			else
			{
				source = Manager.resource.getResourceByURL(url);
				bitmapData = source;
			}
			if (bitmapData != null)
			{
				if (clipWidth > 0 || clipHeight > 0)
				{
					this.source = bitmapData;
					clipRect.width = clipWidth > 0 ? clipWidth : bitmapData.width;
					clipRect.height = clipHeight > 0 ? clipHeight : bitmapData.height;
					this.bitmapData = new BitmapData(clipRect.width, clipRect.height, true, 0);
					update();
				}
				else
					this.bitmapData = bitmapData;
				
				this.smoothing = true;
				dispatchEvent(new Event(LOADED, true));
			}
		}
		
		public function scroll(deltaX:int, deltaY:int):void
		{
			clipRect.x += deltaX;
			//clipRect.y += deltaY;
			update();
		}
		
		public function scrollTo(x:int, y:int):void
		{
			clipRect.x = x;
			//clipRect.y = y;
			update();
		}
		
		private function update():void
		{
			if (source != null && bitmapData != null)
			{
				if (clipRect.x < 0)
					clipRect.x = source.width + clipRect.x;
				else if (clipRect.x > source.width)
					clipRect.x = clipRect.x - source.width;
				
				var point:Point = Manager.pool.pop(Point) as Point;
				if (clipRect.right <= source.width)
				{
					point.setTo(0, 0);
					bitmapData.copyPixels(source, clipRect, point);
				}
				else
				{
					var rect:Rectangle = Manager.pool.pop(Rectangle) as Rectangle;
					var clipX:int = source.width - clipRect.x;
					rect.x = clipRect.x;
					rect.y = clipRect.y;
					rect.width = clipX;
					rect.height = source.height;
					point.setTo(0, 0);
					bitmapData.copyPixels(source, rect, point);
					rect.x = 0;
					rect.width = clipRect.width - clipX;
					point.setTo(clipX, 0);
					bitmapData.copyPixels(source, rect, point);
				}
				Manager.pool.push(point, Point);
			}
		}
		
		public function getDataWidth():int
		{
			return source ? source.width : 0;
		}
		
		public function getDataHeight():int
		{
			return source ? source.height : 0;
		}
	
	}
}