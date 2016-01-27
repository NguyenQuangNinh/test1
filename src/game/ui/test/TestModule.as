package game.ui.test 
{
	import core.Manager;
	import core.display.ModuleBase;
	import core.display.animation.Animator;

	import flash.display.Bitmap;

	import flash.display.BitmapData;
	import flash.display.BitmapDataChannel;
	import flash.geom.Point;

	/**
	 * ...
	 * @author bangnd2
	 */
	public class TestModule extends ModuleBase 
	{
		private var index:int = 0;
		public function TestModule() 
		{
			
		}
		
		override protected function createView():void 
		{
			baseView = new TestView();
			Manager.resource.load(["resource/image/background/bg_hangsonthienphonglinh1_2.jpg","resource/image/background/bg_hangsonthienphonglinh1_2_mask.jpg", "resource/image/background/bg_hangsonthienphonglinh1_1.jpg"], loadDataComplete);
		}

		private function loadDataComplete():void
		{

			var bg:BitmapData = Manager.resource.getResourceByURL("resource/image/background/bg_hangsonthienphonglinh1_1.jpg");
			var source:BitmapData = Manager.resource.getResourceByURL("resource/image/background/bg_hangsonthienphonglinh1_2.jpg");
			var alphaMask:BitmapData = Manager.resource.getResourceByURL("resource/image/background/bg_hangsonthienphonglinh1_2_mask.jpg");
			var bitmapData:BitmapData;
			bitmapData = new BitmapData(source.width, source.height, true, 0);
			bitmapData.copyPixels(source, source.rect, new Point());
			bitmapData.copyChannel(alphaMask, alphaMask.rect, new Point(), BitmapDataChannel.RED, BitmapDataChannel.ALPHA);
			baseView.addChild(new Bitmap(bg));
			baseView.addChild(new Bitmap(bitmapData));
		}


	}

}