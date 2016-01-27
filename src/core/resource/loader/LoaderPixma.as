package core.resource.loader
{
	import flash.display.BitmapData;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	
	import core.display.animation.Animation;
	import core.display.animation.AnimationFrame;
	import core.display.animation.Frame;
	import core.display.animation.FrameModule;
	import core.display.animation.PixmaData;
	import core.display.pixmafont.FontModule;
	import core.display.pixmafont.PixmaFont;

	public class LoaderPixma extends LoaderBase
	{
		private var animationData:Array;
		private var imageURL:String;
		
		public function LoaderPixma()
		{
			super();
		}
		
		override public function processData(data:*):void
		{
			var byteArray:ByteArray = ByteArray(data);
			try {
				if(byteArray.readBoolean())
				{
					var temp:ByteArray = new ByteArray();
					byteArray.readBytes(temp);
					byteArray.clear();
					temp.uncompress();
					byteArray = temp;
				}
			} catch(e:Error) {}
			var numModules:int = byteArray.readInt();
			var modules:Array = [];
			var frames:Array = [];
			var animations:Array = [];
			var rect:Rectangle = new Rectangle();
			var moduleByteArray:ByteArray = new ByteArray();
			for(var i:int = 0; i < numModules; ++i)
			{
				var moduleWidth:int = byteArray.readShort();
				var moduleHeight:int = byteArray.readShort();
				var module:BitmapData = new BitmapData(moduleWidth, moduleHeight, true, 0);
				rect.x = 0;
				rect.y = 0;
				rect.width = moduleWidth;
				rect.height = moduleHeight;
				moduleByteArray.clear();
				byteArray.readBytes(moduleByteArray, 0, moduleWidth * moduleHeight * 4);
				module.setPixels(rect, moduleByteArray);
				modules.push(module);
			}
			moduleByteArray.clear();
			var numFrames:int = byteArray.readInt();
			for(i = 0; i < numFrames; ++i)
			{
				var frame:Frame = new Frame();
				var numFrameModules:int = byteArray.readInt();
				if(numFrameModules > 0)
				{
					for(var j:int = 0; j < numFrameModules; ++j)
					{
						var frameModule:FrameModule = new FrameModule();
						var moduleID:int = byteArray.readInt();
						frameModule.id = moduleID;
						var matrix:Matrix = new Matrix();
						matrix.a = byteArray.readFloat();
						matrix.b = byteArray.readFloat();
						matrix.c = byteArray.readFloat();
						matrix.d = byteArray.readFloat();
						matrix.tx = byteArray.readFloat();
						matrix.ty = byteArray.readFloat();
						var colorTransform:ColorTransform = new ColorTransform();
						var useColorTransform:Boolean = byteArray.readBoolean();
						if(useColorTransform)
						{
							colorTransform.alphaMultiplier = byteArray.readFloat();
							colorTransform.alphaOffset = byteArray.readFloat();
							colorTransform.redMultiplier = byteArray.readFloat();
							colorTransform.redOffset = byteArray.readFloat();
							colorTransform.greenMultiplier = byteArray.readFloat();
							colorTransform.greenOffset = byteArray.readFloat();
							colorTransform.blueMultiplier = byteArray.readFloat();
							colorTransform.blueOffset = byteArray.readFloat();
						}
						frameModule.bitmapData = modules[moduleID];
						frameModule.matrix = matrix;
						frameModule.colorTransform = colorTransform;
						frameModule.blendmode = byteArray.readUTF();
						frame.frameModules.push(frameModule);
					}
					frame.rect.x = byteArray.readFloat();
					frame.rect.y = byteArray.readFloat();
					frame.rect.width = byteArray.readFloat();
					frame.rect.height = byteArray.readFloat();
				}
				frames.push(frame);
			}
			var numAnimations:int = byteArray.readInt();
			if(numAnimations > 0)
			{
				var pixmaData:PixmaData = new PixmaData();
				for(i = 0; i < numAnimations; ++i)
				{
					var animation:Animation = new Animation();
					animation.rect = new Rectangle(Number.MAX_VALUE, Number.MAX_VALUE, -Infinity, -Infinity);
					var numAnimationFrames:int = byteArray.readInt();
					for(j = 0; j < numAnimationFrames; ++j)
					{
						var animationFrame:AnimationFrame = new AnimationFrame();
						var frameID:int = byteArray.readInt();
						frame = frames[frameID];
						animationFrame.frame = frame;
						animationFrame.time = byteArray.readInt() * 0.033;
						animationFrame.x = byteArray.readFloat();
						animationFrame.y = byteArray.readFloat();
						animation.frames.push(animationFrame);
						if(frame.rect.left < animation.rect.left) animation.rect.left = frame.rect.left;
						if(frame.rect.right > animation.rect.right) animation.rect.right = frame.rect.right;
						if(frame.rect.top < animation.rect.top) animation.rect.top = frame.rect.top;
						if(frame.rect.bottom > animation.rect.bottom) animation.rect.bottom = frame.rect.bottom;
					}
					pixmaData.setAnimation(animation, i);
					pixmaData.moduleBitmapDatas = modules;
				}
				resource = pixmaData;
			}
			else
			{
				var pixmaFont:PixmaFont = new PixmaFont();
				var fontModule:FontModule;
				for(i = 0; i < numFrames; ++i)
				{
					frame = frames[i];
					frameModule = frame.frameModules[0];
					fontModule = new FontModule();
					fontModule.bitmapData = frameModule.bitmapData;
					fontModule.deltaY = frameModule.matrix.ty;
					fontModule.colorTransform = frameModule.colorTransform;
					pixmaFont.fontModules.push(fontModule);
				}
				resource = pixmaFont;
			}
			byteArray.clear();
			complete();
		}
	}
}