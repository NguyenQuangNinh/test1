package core.util {
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Scene;
	import flash.filters.BitmapFilter;
	import flash.filters.ColorMatrixFilter;
	import flash.filters.GlowFilter;
	import flash.filters.GradientGlowFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	/**
	 * ...
	 * @author ninhnq
	 */
	public class MovieClipUtils {
		static public const YELLOW	:String = "yellow";
		public static var RED		:String = "red";
		public static var GREEN		:String = "green";
		public static var BLUE		:String = "blue";
		
		public static function removeAllChildren(mc:MovieClip):void {
			while (mc.numChildren > 0) {
				mc.removeChildAt(0);
			}
		}
		
		public static function applyGrayScale(mov:DisplayObject):void
		{
			var grayScaleMatrix:Array = [0.4, 0.4, 0.4, 0, -25,
										 0.4, 0.4, 0.4, 0, -25,
										 0.4, 0.4, 0.4, 0, -25,
										 0.5, 0.5, 0.5, 1, 0];
			var grayScaleFilter:ColorMatrixFilter = new ColorMatrixFilter(grayScaleMatrix);
			mov.filters = [grayScaleFilter];
		}
		
		//will adjust to be flexible
		public static function hueAdjust(mov:DisplayObject, type:String):void
		{
			var adjustMatrix:Array = getMatrixByType(type);
			var colorMatrix	:ColorMatrixFilter = new ColorMatrixFilter(adjustMatrix);
			mov.filters = [colorMatrix];
		}
		
		public static function removeColorTransform(mov:DisplayObject):void
		{
			mov.transform.colorTransform = new ColorTransform();
		}
		
		//starUI hue color
		public static function starHueAdjust(mov:DisplayObject, desColor:uint):void
		{
			var offsetRed:uint = extractRed(desColor);
			var offsetGreen:uint = extractGreen(desColor);
			var offsetBlue:uint = extractBlue(desColor);
			
			var mulRed:Number = (255 - offsetRed) / 255;
			var mulGreen:Number = (255 - offsetGreen) / 255;
			var mulBlue:Number = (255 - offsetBlue) / 255;
			
			var colorTrans:ColorTransform = new ColorTransform(mulRed, mulGreen, mulBlue, 1, offsetRed, offsetGreen, offsetBlue);
			mov.transform.colorTransform = colorTrans;
		}
		
		public static function adjustBrightness(mov:DisplayObject, value:Number):void {
			if (value < 0 || value > 1) return
			var grayScaleMatrix:Array = [value, 0, 0, 0, 0,
										 0, value, 0, 0, 0,
										 0, 0, value, 0, 0,
										 1, 1, 1, 1, 0];
			var grayScaleFilter:ColorMatrixFilter = new ColorMatrixFilter(grayScaleMatrix);
			mov.filters = [grayScaleFilter];
		}
		
		static private function extractBlue(desColor:uint):uint 
		{
			return (desColor & 0xFF);
		}
		
		static private function extractGreen(desColor:uint):uint 
		{
			return ((desColor >> 8) & 0xFF);
		}
		
		static private function extractRed(desColor:uint):uint 
		{
			return ((desColor >> 16) & 0xFF);
		}
		
		static public function getMatrixByType(type:String):Array 
		{
			//trace( "type : " + type );
			var returnMatrix:Array = [];
			switch(type)
			{
				case RED:
					returnMatrix = 	[ 1, 0, 0, 0, 0,
									  0, 0, 0, 0, 0,
									  0, 0, 0, 0, 0,
									  0, 0, 0, 1, 0	];
				break;
				
				case GREEN:
					returnMatrix = 	[ 0, 0, 0, 0, 0,
									  0, 1, 0, 0, 0,
									  0, 0, 0, 0, 0,
									  0, 0, 0, 1, 0	];
				break;
				
				case BLUE:
					returnMatrix = 	[ 0, 0, 0, 0, 0,
									  0, 0, 0, 0, 0,
									  0, 0, 1, 0, 0,
									  0, 0, 0, 1, 0	];
				break;
				
				case YELLOW:
					
				break;
			}
			
			return returnMatrix;
		}
		
		public static function removeAllFilters(mov:DisplayObject):void
		{
			mov.filters = [];
		}
		
		public static function glow(mov:DisplayObject, color:uint = 0xffff00, blurX:int = 4, blurY:int = 4,
									strength:int = 4, quality:int = 100):void {
			if (mov) {
				var glow:GlowFilter = new GlowFilter(color, 1, blurX, blurY, strength, quality);	
				mov.filters = [glow];
			}
		}
		
		public static function removeGlow(mov:DisplayObject):void
		{
			mov.filters = [];
		}
		
		public static function getFrameByLabel(mc:MovieClip, frameLabel: String ):int
		{
		    var scene:Scene = mc.currentScene;
		    var frameNumber:int = -1;
		    for( var i:int = 0; i < scene.labels.length ; ++i )
			{
				if( scene.labels[i].name == frameLabel )
					frameNumber = scene.labels[i].frame;
			}
			return frameNumber;
		}
	}

}