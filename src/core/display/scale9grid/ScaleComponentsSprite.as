package core.display.scale9grid
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.PixelSnapping;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.display.DisplayObject;
	
	/**
	 * ...
	 * @author alex winx (www.winx.ws)
	 */
	public class ScaleComponentsSprite extends Sprite
		{
			/** Scale9grid pieces. **/
			private var _tl:Bitmap;
			private var _tc:Bitmap;
			private var _tr:Bitmap;
			private var _ml:Bitmap;
			private var _mc:Bitmap;
			private var _mr:Bitmap;
			private var _bl:Bitmap;
			private var _bc:Bitmap;
			private var _br:Bitmap;
			
			private var _scaleGrid:Rectangle;
			private var _originalW:Number;
			private var _originalH:Number;
			private var _originalBitmapData:BitmapData;
		
			
			/** Constructor. **/
			public function ScaleComponentsSprite()
			{
				_originalW = this.width;
				_originalH = this.height;
				
				_originalBitmapData = new BitmapData(_originalW, _originalH, true, 0);
				_originalBitmapData.draw(this, new Matrix(), null, null, null, true);
				
				removeAll();
			}
			
			/** Create a slice. **/
			private function slice(x:Number, y:Number, width:Number, height:Number):Bitmap
			{
				
				
				var bd:BitmapData = new BitmapData(width, height, true, 0);
				//bd.copyPixels(_originalBitmapData, new Rectangle(x, y, width, height),new Point(0,0),null,null,true);
				bd.draw(_originalBitmapData, new Matrix(1, 0, 0, 1, -x, -y));
				// create and position the bitmap
				var bitmap:Bitmap = new Bitmap(bd, PixelSnapping.AUTO, true);
				bitmap.x = x;
				bitmap.y = y;
				addChild(bitmap);
				return bitmap;
				
				
			}
			
			
			
			/** Width. **/
			override public function set width(value:Number):void
			{
				if (_scaleGrid)
				{
				//removeAll();
				
				
				_tc.width = _mc.width = _bc.width = value - _tl.width - _tr.width;
				_tr.x = _mr.x = _br.x = value - _tr.width;
				}
				else
				super.width = value;
			}
			
			/** Height. **/
			override public function set height(value:Number):void
			{
				if (_scaleGrid)
				{
				//removeAll();
				
				_ml.height = _mc.height = _mr.height = value - _tl.height - _bl.height;
				_bl.y = _bc.y = _br.y = value - _bl.height;
				}
				else
				super.height = value;
			}
			
			public function get scaleGrid():Rectangle { return _scaleGrid; }
			
			public function set scaleGrid(value:Rectangle):void 
			{
				
				
				_scaleGrid = value;
				
				partition();
				
				
			}
			
			private function partition():void
			{
				_tl = slice(0, 0, _scaleGrid.left, _scaleGrid.top);
				
				_tc = slice(_scaleGrid.left, 0, _scaleGrid.width, _scaleGrid.top);
				_tr = slice(_scaleGrid.right, 0, _originalW - _scaleGrid.right, _scaleGrid.top);
				_ml = slice(0, _scaleGrid.top, _scaleGrid.left, _scaleGrid.height);
				_mc = slice(_scaleGrid.left, _scaleGrid.top, _scaleGrid.width, _scaleGrid.height);
				_mr = slice(_scaleGrid.right, _scaleGrid.top, _originalW - _scaleGrid.right, _scaleGrid.height);
				_bl = slice(0, _scaleGrid.bottom, _scaleGrid.left, _originalH - _scaleGrid.bottom);
				_bc = slice(_scaleGrid.left, _scaleGrid.bottom, _scaleGrid.width, _originalH - _scaleGrid.bottom);
				_br = slice(_scaleGrid.right, _scaleGrid.bottom, _originalW - scaleGrid.right, _originalH- scaleGrid.bottom);
	
			}
			
			public function removeAll():void
			{
				var i:int = 0
				var num:int = this.numChildren;
				
				for (; i < num; i++)
				removeChildAt(0);
			}
		}
	
}
	
