package core.display 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author bangnd2
	 */
	public class DynamicBitmap extends Bitmap 
	{
		static public const LOADED:String = "loaded";
		
		private var _isLoaded:Boolean = false;
		private var _cloneRefs:Array = [];
		
		public function DynamicBitmap(pBitmap:Bitmap = null) 
		{
			setContent(pBitmap);
		}
		
		public function setContent(pBitmap:Bitmap):void
		{
			if (pBitmap)
			{
				bitmapData = pBitmap.bitmapData;
				_isLoaded = true;
				dispatchEvent(new Event(LOADED, true));
				for each(var bitmap:DynamicBitmap in _cloneRefs)
				{
					if (bitmap)	bitmap.setContent(pBitmap);
				}
			}
		}
		
		public function get isLoaded():Boolean { return _isLoaded; }
		
		public function clone():DynamicBitmap
		{
			var bitmap:DynamicBitmap = new DynamicBitmap(new Bitmap(bitmapData));
			_cloneRefs.push(bitmap);
			return bitmap;
		}
		
		public function destroy():void
		{
			for each(var bitmap:DynamicBitmap in _cloneRefs)
			{
				if (bitmap) bitmap.destroy();
			}
			_cloneRefs = [];
			if(bitmapData) bitmapData.dispose();
			bitmapData = null;
			_isLoaded = false;
		}
	}

}