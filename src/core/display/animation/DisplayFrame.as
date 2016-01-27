package core.display.animation 
{
	import core.Manager;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author vu anh
	 */
	public class DisplayFrame extends Sprite
	{
		public var isHasBitmap:Boolean;
		public var animationFrame:AnimationFrame;
		private var mBitmap:Bitmap;
		public function DisplayFrame() 
		{
			mBitmap = null;
			isHasBitmap = false;
		}
		
		public function clean():void
		{
			animationFrame = null;
			removeBitmap();
		}
		
		public function addBitmap(bm:Bitmap):void
		{
			if (isHasBitmap) throw new Error("DisplayFrame dupplicate bitmap!");
			this.mBitmap = bm;
			addChild(this.mBitmap);
			isHasBitmap = true;
		}
		
		public function removeBitmap():void
		{
			if (this.mBitmap) 
			{
				removeChild(this.mBitmap);
				this.mBitmap.bitmapData = null;
				Manager.pool.push(this.mBitmap);
			}
			this.mBitmap = null;
			isHasBitmap = false;
		}
		
	}

}