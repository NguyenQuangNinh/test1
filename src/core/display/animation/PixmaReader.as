package core.display.animation
{
	
	import flash.display.BitmapData;
	import flash.display.BitmapDataChannel;
	import flash.display.BlendMode;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	
	import core.Manager;
	import core.display.pixmafont.FontModule;
	import core.display.pixmafont.PixmaFont;
	import core.geom.Polygon;
	
	
	public class PixmaReader
	{
		
		//general flags
	private static const  	_EXPORT_QUALITY_FREE_TRANSFORM:uint	= (1 << 0);
	private static const 	_EXPORT_MULTI_MODULE_TYPE:uint 	=			(1 << 1);
	private static const 	_EXPORT_COLOR_TRANSFORM	:uint = 			(1 << 2);
	private static const		_EXPORT_REARRANGE_TEXTURE 	:uint = 		(1 << 3);
	private static const _EXPORT_SINGLE_PNG_IMAGE	:uint = 		(1 << 4);
	//quality type
	private static const		_EXPORT_QUALITY_TRUE_COLOR :uint = 			(1 << 0);
	private static const		_EXPORT_QUALITY_INDEX_COLOR		:uint = 	(1 << 1);
	//image data type
	private static const		_EXPORT_TYPE_3D_TEXTURE	:uint = 			(1 << 0);
	private static const		_EXPORT_TYPE_MODULE_IMAGE	:uint = 		(1 << 1);
	private static const		_EXPORT_TYPE_SINGLE_IMAGE:uint = 		(1 << 2);
	//pixel format type	
	private static const		_EXPORT_PIXEL_32BITS	:uint = 				(1 << 0);
	private static const		_EXPORT_PIXEL_16BITS	:uint = 				(1 << 1);

	//image format
	private static const 	_IMAGE_FORMAT_INDEX			:uint = 			(1 << 0);
	private static const 	_IMAGE_FORMAT_INDEX_ALPHA	:uint = 			(1 << 1);
	private static const 	_IMAGE_FORMAT_RAW_0888	 	:uint = 			(1 << 2);
	private static const 	_IMAGE_FORMAT_RAW_8888	 	:uint = 			(1 << 3);
	private static const 	_IMAGE_FORMAT_RAW_1888	 	:uint = 			(1 << 4);
	private static const 	_IMAGE_FORMAT_PNG	 		:uint = 			(1 << 5);
	private static const 	_IMAGE_FORMAT_JPG		 	:uint = 			(1 << 6);

	private static const		_FLIP_H				:uint = 					(1 << 0);
	private static const		_FLIP_V				:uint = 					(1 << 1);
	private static const		_FREE_TRANSFORM			:uint = 				(1 << 2);
	private static const		_COLOR_TRANSFORM		:uint = 				(1 << 3);

	private static const		_LEFT					:uint = 				(1 << 0);
	private static const		_RIGHT					:uint = 				(1 << 1);
	private static const		_HCENTER				:uint = 				(1 << 2);
	private static const		_TOP					:uint = 				(1 << 3);
	private static const		_BOTTOM					:uint = 				(1 << 4);
	private static const		_VCENTER				:uint = 				(1 << 5);
	
		//CDN url
	public static var	_cdn_server:String = "";
		public var _external_path	:String = "";
		
		//export format flag
		public var		_export_flags:int = 0;
		public var		_export_quality:int = 0;
		public var		_export_image_type:int = 0;
		public var		_export_pixel_type:int = 0;
		
		//image info
		public var 		_image_format:int = 0;
		public var		_num_colors:int = 0;
		public var		_img_files:Vector.<String> = null;
		public var		_alpha_mask_files:Vector.<String> = null;
		
		//palette info
		public var		_num_pals:int = 0;
		public var		_current_pal:int = 0;
		public var		_pal_data:Array = null;
		
		//module info
		public var 		_num_modules:int = 0;
		private var		_module_raw_data:Vector.<ByteArray> = null;
		private var		_module_bitmap_data:Vector.<BitmapData> = null;
		private var 	_module_w:Vector.<int> = null;
		private var 	_module_h:Vector.<int> = null;
		
		private var 	_module_x:Vector.<int> = null;
		private var 	_module_y:Vector.<int> = null;
		private var 	_module_img_id:Vector.<int> = null;
		
		//frame info
		public var		_num_frames:int = 0;
		private var		_frame_offset:Vector.<int> = null;
		private var		_frame_rects:Vector.<Rectangle> = null; //@Chao add frame rect
		
		private var		_num_fmodules:int = 0;
		private var		_fmodule_id:Vector.<int> = null;
		private var		_fmodule_x:Vector.<int> = null;
		private var		_fmodule_y:Vector.<int> = null;
		private var		_fmodule_transf:Vector.<int> = null;
		
		private var		_is_free_transform:Boolean = false;
		private var		_fmodule_fx:Vector.<Number> = null;
		private var		_fmodule_fy:Vector.<Number> = null;
		
		private var		_fmodule_m11:Vector.<Number> = null;
		private var		_fmodule_m12:Vector.<Number> = null;
		private var		_fmodule_m21:Vector.<Number> = null;
		private var		_fmodule_m22:Vector.<Number> = null;
		
		private var		_fmodule_alpha_mul:Vector.<Number> = null;
		//private var	_fmodule_alpha_off:Vector.<Number> = null;
		private var		_fmodule_red_mul:Vector.<Number> = null;
		private var		_fmodule_red_off:Vector.<int> = null;
		private var		_fmodule_green_mul:Vector.<Number> = null;
		private var		_fmodule_green_off:Vector.<int> = null;
		private var		_fmodule_blue_mul:Vector.<Number> = null;
		private var		_fmodule_blue_off:Vector.<int> = null;
		
		private var		_fmodule_blend_mode:Vector.<String> = null;
		
		//anim info
		public var		_num_anims:int = 0;
		private var		_anim_offset:Vector.<int> = null;
		
		private var		_num_aframes:int = 0;
		private var		_aframe_id:Vector.<int> = null;
		private var		_aframe_x:Vector.<int> = null;
		private var		_aframe_y:Vector.<int> = null;
		private var		_aframe_transf:Vector.<int> = null;
		private var		_aframe_time:Vector.<int> = null;
	
		//animation control var
		public var		_current_anim:int = -1;
		public var		_min_aframes:int = 0;
		public var		_max_aframes:int = 0;
		public var		_current_aframes:int = 0;
		public var		_current_aframes_time:int = 0;
		public var		_is_current_anim_stop:Boolean = true;//run or stop
		
		//custom font
		public var		_char_spacing:int = 0;
		public var		_line_spacing:int = 3;
		
		//color transform
		private var		_fm_color_transform:ColorTransform = new ColorTransform();
		
		private var		_use_color_transform:Boolean = false;
		private var		_color_transform:ColorTransform = null;
		
		//blend mode
		private var		_blend_mode:String = BlendMode.NORMAL;
		public var		_is_loaded:Boolean = false;
	
		public function PixmaReader()
		{
		}
		
		public function dispose():void
		{
			var length:int;
			var i:int;
			var byteArray:ByteArray;
			if (_module_raw_data != null)
			{
				length = _module_raw_data.length;
				for (i = 0; i < length; ++i)
				{
					byteArray = _module_raw_data[i];
					if (byteArray != null) byteArray.clear();
					_module_raw_data[i] = null;
				}
				_module_raw_data = null;
			}
			_module_bitmap_data = null;
		}
		
		public function Load(bin:ByteArray, color_transform:Number = 1.0):void
		{
			_is_load_finished = false;
			
			var i:int = 0;
			bin.position = 0;
			
			//read export flags
			_export_flags = (bin.readByte()&0xFF) | ((bin.readByte()&0xFF)<<8) | ((bin.readByte()&0xFF)<<16) | ((bin.readByte()&0xFF)<<24);
			
			if ((_export_flags&_EXPORT_QUALITY_FREE_TRANSFORM) != 0)
			{
				_is_free_transform = true;
			}
			else
			{
				_is_free_transform = false;
			}
			
			//read num modules
			_num_modules  = (bin.readByte()&0xFF) | ((bin.readByte()&0xFF)<<8);
	
			if (_num_modules > 0)
			{
				_module_bitmap_data = new Vector.<BitmapData>(_num_modules, true);
				_module_w = new Vector.<int>(_num_modules, true);
				_module_h = new Vector.<int>(_num_modules, true);
				
				if ((_export_flags&_EXPORT_SINGLE_PNG_IMAGE) != 0)
				{
					_module_x = new Vector.<int>(_num_modules, true);
					_module_y = new Vector.<int>(_num_modules, true);
					_module_img_id = new Vector.<int>(_num_modules, true);
				}
		
				//read module info
				for (i = 0; i < _num_modules; i++)
				{
					_module_w[i] = (bin.readByte()&0xFF) | ((bin.readByte()&0xFF)<<8);
					_module_h[i] = (bin.readByte()&0xFF) | ((bin.readByte()&0xFF)<<8);
					
					if ((_export_flags&_EXPORT_SINGLE_PNG_IMAGE) != 0)
					{
						_module_x[i] = (bin.readByte()&0xFF) | ((bin.readByte()&0xFF)<<8);
						_module_y[i] = (bin.readByte()&0xFF) | ((bin.readByte()&0xFF)<<8);
						
						_module_img_id[i] = bin.readByte()&0xFF;
					}
				}
			}
	
			//num frame
			_num_frames = (bin.readByte() & 0xFF) | ((bin.readByte() & 0xFF) << 8);
	
			if (_num_frames > 0)
			{
				//anim pos in aframe list
				_frame_offset = new Vector.<int>(_num_frames, true);
				_frame_rects = new Vector.<Rectangle>(_num_frames, true);//@Chao add frame rect
				_num_fmodules = 0;
				
				for (i = 0; i < _num_frames; i++)
				{
					var fmodules:int = (bin.readByte()&0xFF) | ((bin.readByte()&0xFF)<<8);
					
					_frame_offset[i] = _num_fmodules;
					
					_num_fmodules += fmodules;
				}
				
				_fmodule_id = new Vector.<int>(_num_fmodules, true);
				_fmodule_transf = new Vector.<int>(_num_fmodules, true);
				
				if (_is_free_transform)
				{
					_fmodule_fx = new Vector.<Number>(_num_fmodules, true);
					_fmodule_fy = new Vector.<Number>(_num_fmodules, true);
		
					_fmodule_m11 = new Vector.<Number>(_num_fmodules, true);
					_fmodule_m12 = new Vector.<Number>(_num_fmodules, true);
					_fmodule_m21 = new Vector.<Number>(_num_fmodules, true);
					_fmodule_m22 = new Vector.<Number>(_num_fmodules, true);
				}
				else
				{
					_fmodule_x = new Vector.<int>(_num_fmodules, true);
					_fmodule_y = new Vector.<int>(_num_fmodules, true);
					
				}
				
				//color transform info
				if ((_export_flags&_EXPORT_COLOR_TRANSFORM) != 0)
				{
					_fmodule_alpha_mul = new Vector.<Number>(_num_fmodules, true);
					//_fmodule_alpha_off = new Vector.<Number>(_num_fmodules, true);
					_fmodule_red_mul = new Vector.<Number>(_num_fmodules, true);
					_fmodule_red_off = new Vector.<int>(_num_fmodules, true);
					_fmodule_green_mul = new Vector.<Number>(_num_fmodules, true);
					_fmodule_green_off = new Vector.<int>(_num_fmodules, true);
					_fmodule_blue_mul = new Vector.<Number>(_num_fmodules, true);
					_fmodule_blue_off = new Vector.<int>(_num_fmodules, true);
				}
				
				_fmodule_blend_mode = new Vector.<String>(_num_fmodules, true);
				
				for (i = 0; i < _num_fmodules; i++)
				{
					var transf:int = 0;
					var int_val:int = 0;
					
					_fmodule_id[i] = (bin.readByte()&0xFF) | ((bin.readByte()&0xFF)<<8);
					transf = bin.readByte()&0xFF;
					_fmodule_transf[i] = transf;
					
					if (_is_free_transform)
					{
						if ((transf&_FREE_TRANSFORM) != 0)
						{
							_fmodule_fx[i] = bin.readFloat();
							_fmodule_fy[i] = bin.readFloat();
					
							_fmodule_m11[i] = bin.readFloat();
							_fmodule_m12[i] = bin.readFloat();
							_fmodule_m21[i] = bin.readFloat();
							_fmodule_m22[i] = bin.readFloat();
						}
						else
						{
							int_val = (bin.readByte()&0xFF) | (bin.readByte()<<8);
							_fmodule_fx[i] = int_val;
							int_val = (bin.readByte()&0xFF) | (bin.readByte()<<8);
							_fmodule_fy[i] = int_val;
						
							_fmodule_m11[i] = 1;
							_fmodule_m12[i] = 0;
							_fmodule_m21[i] = 0;
							_fmodule_m22[i] = 1;
						}
					}
					else
					{
						_fmodule_x[i] = (bin.readByte()&0xFF) | (bin.readByte()<<8);
						_fmodule_y[i] = (bin.readByte()&0xFF) | (bin.readByte()<<8);
					}
					
					//get color transform info
					if ((_export_flags&_EXPORT_COLOR_TRANSFORM) != 0)
					{
						if ((transf&_COLOR_TRANSFORM) != 0)
						{
							_fmodule_alpha_mul[i] = bin.readFloat();
							
							//skip alpha offset
							bin.readByte();
							bin.readByte()
							
							_fmodule_red_mul[i] = bin.readFloat();
							_fmodule_red_off[i] = (bin.readByte()&0xFF) | (bin.readByte()<<8);
							
							_fmodule_green_mul[i] = bin.readFloat();
							_fmodule_green_off[i] = (bin.readByte()&0xFF) | (bin.readByte()<<8);
							
							_fmodule_blue_mul[i] = bin.readFloat();
							_fmodule_blue_off[i] = (bin.readByte()&0xFF) | (bin.readByte()<<8);
						}
						else
						{
							_fmodule_alpha_mul[i] = 1.0;
							_fmodule_red_mul[i] = 1.0;
							_fmodule_red_off[i] = 0;
							_fmodule_green_mul[i] = 1.0;
							_fmodule_green_off[i] = 0;
							_fmodule_blue_mul[i] = 1.0;
							_fmodule_blue_off[i] = 0;
						}
					}
					
					_fmodule_blend_mode[i] = GetBlendMode(bin.readByte());
				}
				
				//@Chao add frame rect
				for (i = 0; i < _num_frames; i++)
				{
					_frame_rects[i] = CreateFrameRect(i);
				}
			}
			
			//num anim
			_num_anims = (bin.readByte()&0xFF) | ((bin.readByte()&0xFF)<<8);
			
			if (_num_anims > 0)
			{
				//anim pos in aframe list
				_anim_offset = new Vector.<int>(_num_anims, true);
				_num_aframes = 0;
				
				for (i = 0; i < _num_anims; i++)
				{
					var aframes:int = (bin.readByte()&0xFF) | ((bin.readByte()&0xFF)<<8);
					
					_anim_offset[i] = _num_aframes;
					
					_num_aframes += aframes;
				}
				
				//aframe list
				_aframe_id = new Vector.<int>(_num_aframes, true);
				_aframe_x = new Vector.<int>(_num_aframes, true);
				_aframe_y = new Vector.<int>(_num_aframes, true);
				_aframe_transf = new Vector.<int>(_num_aframes, true);
				_aframe_time = new Vector.<int>(_num_aframes, true);
				
				for (i = 0; i < _num_aframes; i++)
				{
					_aframe_id[i] = (bin.readByte()&0xFF) | ((bin.readByte()&0xFF)<<8);
					
					_aframe_x[i] = (bin.readByte()&0xFF) | (bin.readByte()<<8);
					
					_aframe_y[i] = (bin.readByte()&0xFF) | (bin.readByte()<<8);
					
					_aframe_transf[i] = bin.readByte()&0xFF;
					_aframe_time[i] = bin.readByte()&0xFF;
				}
			}
			
			//read export info
			_export_quality = bin.readByte() & 0xFF;
			_export_image_type = bin.readByte() & 0xFF;
			_export_pixel_type = bin.readByte() & 0xFF;
			
			//read gfx data
			if (_export_image_type == _EXPORT_TYPE_SINGLE_IMAGE)
			{
				_current_loading_img_module = 0;
				
				var num_img:int = bin.readByte() & 0xFF;
				//read img file name
				_img_files = new Vector.<String>(num_img);
				_alpha_mask_files = new Vector.<String>(num_img);
				
				var filename_length:int = 0;
				for (i = 0; i < num_img; i++)
				{
					filename_length = bin.readByte()&0xFF;
					
					_img_files[i] = bin.readMultiByte(filename_length, "us-ascii");
					
					//load from cdn
					var url_req:URLRequest = new URLRequest(_external_path + _img_files[i]);
					var img_loader:Loader = new Loader();
					img_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, OnSingleImageLoaderComplete);
					img_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, OnSingleImageLoaderError);
					img_loader.load(url_req);
					
					
					//load alha mask
					filename_length = bin.readByte()&0xFF;
					if (filename_length > 0)
					{
						_alpha_mask_files[i] = bin.readMultiByte(filename_length, "us-ascii");
						
						var url_req_alpha_mask:URLRequest = new URLRequest(_external_path + _alpha_mask_files[i]);
						var alpha_mask_loader:Loader = new Loader();
						alpha_mask_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, OnAlphaMaskImageLoaderComplete);
						alpha_mask_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, OnAlphaMaskImageLoaderError);
						alpha_mask_loader.load(url_req_alpha_mask);
					}
				}
			}
			else if (_export_image_type == _EXPORT_TYPE_MODULE_IMAGE)
			{
				_image_format = bin.readByte() & 0xFF;
				
				var w:int = 0;
				var h:int = 0;
				var module_bmp_data:BitmapData = null;
				
				if (_image_format == _IMAGE_FORMAT_RAW_8888 || 
					_image_format == _IMAGE_FORMAT_RAW_1888 || 
					_image_format == _IMAGE_FORMAT_RAW_0888)
				{
					for (i = 0; i < _num_modules; i++)
					{
						w = _module_w[i];
						h = _module_h[i];
						if (w != 0 && h != 0)
						{
							module_bmp_data = new BitmapData(w, h, true, 0);
							
							UnzipRAWImage(bin, bin.position, w, h, module_bmp_data, color_transform);
							
							_module_bitmap_data[i] = module_bmp_data;
						}
					}
					
					_is_loaded = true;
					_is_load_finished = true;
				}
				else if (_image_format == _IMAGE_FORMAT_INDEX || _image_format == _IMAGE_FORMAT_INDEX_ALPHA)
				{
					//read num colors
					_num_colors = bin.readByte()&0xFF;
					
					if (_num_colors == 0)
					{
						_num_colors = 256;
					}
					
					//read num pals
					_num_pals = bin.readByte()&0xFF;
					_current_pal = 0;
					
					//read pals data
					var color:int = 0x00000000;
					var pal:Vector.<int> = null;
					
					_pal_data = new Array(_num_pals);
					for (i = 0; i < _num_pals; i++)
					{
						pal = new Vector.<int>(_num_colors, true);
						
						for (var j:int = 0; j < _num_colors; j++)
						{
							color = (bin.readByte()&0xFF) | ((bin.readByte()&0xFF)<<8) | ((bin.readByte()&0xFF)<<16);
							
							if (color != 0xFF00FF)
							{
								color |= 0xFF000000;
							}
							
							pal[j] = color;
						}
						
						_pal_data[i] = pal;
					}
					
					//read module's bitmap data
					if (_num_pals > 1)
					{
						_module_raw_data = new Vector.<ByteArray>(_num_modules, true);
					}
					
					var raw_data_size:int = 0;
					var raw_data:ByteArray = null;
					for (i = 0; i < _num_modules; i++)
					{
						w = _module_w[i];
						h = _module_h[i];
						
						if (w != 0 && h != 0)
						{
							raw_data_size = (bin.readByte()&0xFF) | ((bin.readByte()&0xFF)<<8) | ((bin.readByte()&0xFF)<<16) | ((bin.readByte()&0xFF)<<24);
							
							if (_num_pals > 1)
							{
								//store module's raw data
								raw_data = new ByteArray();	
								bin.readBytes(raw_data, 0, raw_data_size);
								_module_raw_data[i] = raw_data;
							}
							else
							{
								//unzip module's raw data
								module_bmp_data = new BitmapData(w, h, true, 0);

								UnzipIndexImage(bin, bin.position, w, h, _current_pal, module_bmp_data, color_transform);

								_module_bitmap_data[i] = module_bmp_data;
							}
						}
					}
					
					_is_loaded = true;
					_is_load_finished = true;
				}
				else if (_image_format == _IMAGE_FORMAT_PNG || _image_format == _IMAGE_FORMAT_JPG)
				{
					_current_loading_img_module = 0;
					_current_bin = bin;
					_current_color_transform = color_transform;
					LoadPNGJPGModules();
				}
			}
		}
		
		public function read():PixmaData
		{
			var data:PixmaData = new PixmaData();
			var frames:Array = [];
			var frame:Frame;
			var frameModule:FrameModule;
			var i:int, j:int, id:int;
			var offset:int;
			var count:int;
			for(i = 0; i < _num_frames; ++i)
			{
				if (_frame_rects[i] != null)
				{
					frame = new Frame();
					frame.rect = _frame_rects[i];
					offset = _frame_offset[i];
					if(i < _num_frames - 1) count = _frame_offset[i + 1] - offset;
					else count = _num_fmodules - offset;
					for(j = offset; j < offset + count; ++j)
					{
						frameModule = new FrameModule();
						id = _fmodule_id[j];
						frameModule.id = id;
						frameModule.bitmapData = _module_bitmap_data[id];
						frameModule.blendmode = _fmodule_blend_mode[j] != null ? _fmodule_blend_mode[j] : BlendMode.NORMAL;
						var matrix:Matrix = new Matrix();
						if (_is_free_transform)
						{
							if((_fmodule_transf[j] & _FREE_TRANSFORM) != 0)
							{
								matrix.a = _fmodule_m11[j];
								matrix.b = _fmodule_m12[j];
								matrix.c = _fmodule_m21[j];
								matrix.d = _fmodule_m22[j];
							}
							matrix.tx = _fmodule_fx[j];
							matrix.ty = _fmodule_fy[j];
						}
						else
						{
							matrix.tx = _fmodule_x[j];
							matrix.ty = _fmodule_y[j];
						}
						
						if((_fmodule_transf[j] & _FLIP_H) != 0)
						{
							matrix.a *= -1;
							matrix.tx += _module_w[id];
						}
						if((_fmodule_transf[j] & _FLIP_V) != 0)
						{
							matrix.d *= -1;
							matrix.ty += _module_h[id];
						}
						frameModule.matrix = matrix;
						if ((_fmodule_transf[j] & _COLOR_TRANSFORM) != 0)
						{
							var colorTransform:ColorTransform = new ColorTransform();
							colorTransform.redMultiplier	= _fmodule_red_mul[j];
							colorTransform.greenMultiplier 	= _fmodule_green_mul[j];
							colorTransform.blueMultiplier 	= _fmodule_blue_mul[j];
							colorTransform.alphaMultiplier 	= _fmodule_alpha_mul[j];
							colorTransform.redOffset		= _fmodule_red_off[j];
							colorTransform.greenOffset 		= _fmodule_green_off[j];
							colorTransform.blueOffset 		= _fmodule_blue_off[j];
							frameModule.colorTransform = colorTransform;
						}
						
						frame.frameModules[j - offset] = frameModule;
					}
					frames[i] = frame;
				}
			}
			var animRect:Rectangle = Manager.pool.pop(Rectangle) as Rectangle;
			var animation:Animation;
			var animationFrame:AnimationFrame;
			for(i = 0; i < _num_anims; ++i)
			{
				offset = _anim_offset[i];
				if(i < _num_anims - 1) count = _anim_offset[i + 1] - offset;
				else count = _num_aframes - offset;
				if (count == 0) continue;
				animation = new Animation();
				for(j = offset; j < offset + count; ++j)
				{
					id = _aframe_id[j];
					animationFrame = new AnimationFrame();
					animationFrame.frame = frames[id];
					animationFrame.x = _aframe_x[j];
					animationFrame.y = _aframe_y[j];
					animationFrame.time = _aframe_time[j] * 0.033;
					
					animation.frames[j - offset] = animationFrame;
					
					if (animationFrame.frame != null)
					{
						animRect.copyFrom(animationFrame.frame.rect);
						animRect.x += animationFrame.x;
						animRect.y += animationFrame.y;
						if (animation.rect == null)
						{
							animation.rect = new Rectangle();
							animation.rect.copyFrom(animRect);
						}
						else 
						{
							if(animRect.left < animation.rect.left) animation.rect.left = animRect.left;
							if(animRect.right > animation.rect.right) animation.rect.right = animRect.right;
							if(animRect.top < animation.rect.top) animation.rect.top = animRect.top;
							if(animRect.bottom > animation.rect.bottom) animation.rect.bottom = animRect.bottom;
						}
					}
				}
				data.setAnimation(animation, i);
			}
			Manager.pool.push(animRect, Rectangle);
			data.moduleBitmapDatas = _module_bitmap_data;
			
			return data;
		}
		
		public function readPixmaFont():PixmaFont {
			var data:PixmaFont = new PixmaFont();
			var frames:Array = [];
			var frame:Frame;
			var fontModule:FontModule;
			var i:int, j:int, id:int;
			var offset:int;
			var count:int;
			var matrix:Matrix;
			for(i = 0; i < _num_frames; ++i)
			{
				if (_frame_rects[i] != null)
				{
					frame = new Frame();
					frame.rect = _frame_rects[i];
					offset = _frame_offset[i];
					if(i < _num_frames - 1) count = _frame_offset[i + 1] - offset;
					else count = _num_fmodules - offset;
					for(j = offset; j < offset + count; ++j)
					{
						fontModule = new FontModule();
						id = _fmodule_id[j];
						fontModule.bitmapData = _module_bitmap_data[id];
						if (_fmodule_y && _fmodule_y[j]) {
							fontModule.deltaY = _fmodule_y[j];				
						}
						if ((_fmodule_transf[j] & _COLOR_TRANSFORM) != 0)
						{
							var colorTransform:ColorTransform = new ColorTransform();
							colorTransform.redMultiplier	= _fmodule_red_mul[j];
							colorTransform.greenMultiplier 	= _fmodule_green_mul[j];
							colorTransform.blueMultiplier 	= _fmodule_blue_mul[j];
							colorTransform.alphaMultiplier 	= _fmodule_alpha_mul[j];
							colorTransform.redOffset		= _fmodule_red_off[j];
							colorTransform.greenOffset 		= _fmodule_green_off[j];
							colorTransform.blueOffset 		= _fmodule_blue_off[j];
							fontModule.colorTransform 		= colorTransform;
						}
						
						data.fontModules.push(fontModule);
					}
				}
			}
			return data;
		}
		
		private var _current_loading_img_module:int = 0;
		public var _current_bin:ByteArray = null;
		public var _is_load_finished:Boolean = false;
		public var _current_color_transform:Number = 1.0;
		
		private function LoadPNGJPGModules():void
		{
			var module_img_size:int = 0;
			var module_img_data:ByteArray = new ByteArray();
			var img_loader:Loader = new Loader();
		
			var w:int = _module_w[_current_loading_img_module];
			var h:int = _module_h[_current_loading_img_module];
			
			if (w != 0 && h != 0)
			{
				_module_bitmap_data[_current_loading_img_module] = new BitmapData(w, h, true, 0);
				
				module_img_size = (_current_bin.readByte()&0xFF) | ((_current_bin.readByte()&0xFF)<<8) | ((_current_bin.readByte()&0xFF)<<16) | ((_current_bin.readByte()&0xFF)<<24);

				module_img_data.clear();
				_current_bin.readBytes(module_img_data, 0, module_img_size);
				
				img_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, OnImageLoaderComplete);
				img_loader.loadBytes(module_img_data);
			}
			else
			{
				_current_loading_img_module++;
				
				if (_current_loading_img_module < _num_modules)
				{
					LoadPNGJPGModules();
				}
				else
				{
					_current_bin.clear();
					_current_bin = null;
					
					_is_loaded = true;
					_is_load_finished = true;
				}
			}
		}
		
		private function OnImageLoaderComplete(e:Event):void
		{
			var module_bmp:BitmapData = _module_bitmap_data[_current_loading_img_module];
			
			if (_current_color_transform < 1.0)
			{
				module_bmp.draw(e.target.content, null, new ColorTransform(_current_color_transform, _current_color_transform, _current_color_transform, 1.0));
			}
			else
			{
				module_bmp.draw(e.target.content);
			}
			
			//set alpha channel
			if (_image_format == _IMAGE_FORMAT_JPG)
			{
				var alpha_size:int = (_current_bin.readByte()&0xFF) | ((_current_bin.readByte()&0xFF)<<8) | ((_current_bin.readByte()&0xFF)<<16) | ((_current_bin.readByte()&0xFF)<<24);
				
				if (alpha_size > 0)
				{
					var x:int = 0;
					var y:int = 0;
					var w:int = _module_w[_current_loading_img_module];
					var h:int = _module_h[_current_loading_img_module];
					var val:int = 0;
					var rlen:int = 0;
					var color:int = 0;

					//unzip alpha data
					while (y < h)
					{
						val = _current_bin.readByte()&0xFF;

						if (val == 0xFE)
						{
							rlen = _current_bin.readByte()&0xFF;
							val = _current_bin.readByte()&0xFF;

							for (var i:int = 0; i < rlen; i++)
							{
								if (val != 0xFF)
								{
									color = module_bmp.getPixel(x, y);
									color |= (val<<24);
									module_bmp.setPixel32(x, y, color);
								}

								x++;
								if (x >= w)
								{
									x = 0;
									y++;
								}
							}
						}
						else
						{
							if (val != 0xFF)
							{
								color = module_bmp.getPixel(x, y);
								color |= (val<<24);
								module_bmp.setPixel32(x, y, color);
							}

							x++;
							if (x >= w)
							{
								x = 0;
								y++;
							}
						}
					}
				}
			}
			
			//load next module
			_current_loading_img_module++;
			if (_current_loading_img_module < _num_modules)
			{
				LoadPNGJPGModules();
			}
			else
			{
				_current_bin.clear();
				_current_bin = null;
				
				_is_loaded = true;
				_is_load_finished = true;
			}
		}
		
		private function OnSingleImageLoaderComplete(e:Event):void
		{
			var loader:Loader = Loader(e.target.loader);
            var info:LoaderInfo = LoaderInfo(loader.contentLoaderInfo);
			
			var w:int = loader.content.width;
			var h:int = loader.content.height;
			
			var module_bmp:BitmapData = new BitmapData(w, h, true, 0);
			module_bmp.draw(loader.content);
			
			//load single image false
			var current_img:int = -1;
			var i:int = 0;
			for (; i < _img_files.length; i++)
			{
				if (info.url.indexOf(_img_files[i]) >= 0)
				{
					current_img = i;
				}
			}
			
			if (current_img >= 0)
			{
				var rect:Rectangle = new Rectangle();
				var point:Point = new Point(0, 0);
				var module_bmp_data:BitmapData = null;
				
				for (i = 0; i < _num_modules; i++)
				{
					if (_module_img_id[i] == current_img)
					{
						rect.x = _module_x[i];
						rect.y = _module_y[i];
						rect.width = _module_w[i];
						rect.height = _module_h[i];
						
						if (_module_bitmap_data[i] == null)
						{
							module_bmp_data = new BitmapData(rect.width, rect.height, true, 0);
							module_bmp_data.copyPixels(module_bmp, rect, point, null, null, true);
							
							_module_bitmap_data[i] = module_bmp_data;
						}
						else
						{
							module_bmp_data = _module_bitmap_data[i];
							
							module_bmp_data.copyChannel(module_bmp, rect, point, BitmapDataChannel.RED, BitmapDataChannel.RED);
							module_bmp_data.copyChannel(module_bmp, rect, point, BitmapDataChannel.GREEN, BitmapDataChannel.GREEN);
							module_bmp_data.copyChannel(module_bmp, rect, point, BitmapDataChannel.BLUE, BitmapDataChannel.BLUE);
						}
						
						_current_loading_img_module++;
					}
				}
			}
			
			module_bmp.dispose();
			module_bmp = null;
			
			if (_current_loading_img_module >= _num_modules)
			{
				_is_loaded = true;
				_is_load_finished = true;
			}
		}
		
		private function OnSingleImageLoaderError(e:IOErrorEvent):void
		{
			trace("OnSingleImageLoaderError = " + e);
		}
		
		private function OnAlphaMaskImageLoaderComplete(e:Event):void
		{
			var loader:Loader = Loader(e.target.loader);
            var info:LoaderInfo = LoaderInfo(loader.contentLoaderInfo);
			
			var w:int = loader.content.width;
			var h:int = loader.content.height;
			
			var module_bmp:BitmapData = new BitmapData(w, h, true, 0);
			module_bmp.draw(loader.content);
			
			//load single image false
			var current_img:int = -1;
			var i:int = 0;
			for (; i < _alpha_mask_files.length; i++)
			{
				if (info.url.indexOf(_alpha_mask_files[i]) >= 0)
				{
					current_img = i;
				}
			}
			
			if (current_img >= 0)
			{
				var rect:Rectangle = new Rectangle();
				var point:Point = new Point(0, 0);
				var module_bmp_data:BitmapData = null;
				
				for (i = 0; i < _num_modules; i++)
				{
					if (_module_img_id[i] == current_img)
					{
						rect.x = _module_x[i];
						rect.y = _module_y[i];
						rect.width = _module_w[i];
						rect.height = _module_h[i];
						
						if (_module_bitmap_data[i] == null)
						{
							module_bmp_data = new BitmapData(rect.width, rect.height, true, 0);
							module_bmp_data.copyChannel(module_bmp, rect, point, BitmapDataChannel.BLUE, BitmapDataChannel.ALPHA);
							
							_module_bitmap_data[i] = module_bmp_data;
						}
						else
						{
							module_bmp_data = _module_bitmap_data[i];
							module_bmp_data.copyChannel(module_bmp, rect, point, BitmapDataChannel.BLUE, BitmapDataChannel.ALPHA);
						}
					}
				}
			}
			
			module_bmp.dispose();
			module_bmp = null;
		}
		
		private function OnAlphaMaskImageLoaderError(e:IOErrorEvent):void
		{
			trace("OnAlphaMaskImageLoaderError = " + e);
		}
		
		public function Unload():void
		{
			var i:int = 0;
			var module_bmp_data:BitmapData = null;
			
			for (i = 0; i < _num_modules; i++)
			{
				module_bmp_data = _module_bitmap_data[i];
				
				if (module_bmp_data != null)
				{
					module_bmp_data.dispose();
					_module_bitmap_data[i] = null;
					module_bmp_data = null;
				}
			}
		}
		
		private function UnzipRAWImage(bin:ByteArray, offset:int, w:int, h:int, module_bmp_data:BitmapData, color_transform:Number = 1.0):void
		{
			var x:int = 0;
			var y:int = 0;
			
			var rlen:int = 0;
			var val:int = 0;
			var a:int = 0;
			var r:int = 0;
			var g:int = 0;
			var b:int = 0;
			var color:uint = 0;
			
			module_bmp_data.lock();
			while (y < h)
			{
				val = bin.readByte()&0xFF;
		
				if (val == 0xFE)
				{
					rlen = bin.readByte()&0xFF;
					
					if (_image_format == _IMAGE_FORMAT_RAW_8888)
					{
						if (_export_pixel_type == _EXPORT_PIXEL_16BITS)
						{
							val = bin.readByte();
							
							b = val&0x0F;
							b = b | (b<<4);
							
							g = val&0xF0;
							g = g | (g>>4);
							
							val = bin.readByte();
							
							r = val&0x0F;
							r = r | (r<<4);
							
							a = val&0xF0;
							a = a | (a>>4);
						}
						//_EXPORT_PIXEL_32BITS
						else
						{
							b = bin.readByte()&0xFF;
							g = bin.readByte()&0xFF;
							r = bin.readByte()&0xFF;
							a = bin.readByte()&0xFF;
						}
					}
					//_IMAGE_FORMAT_RAW_0888 or _IMAGE_FORMAT_RAW_1888
					else
					{
						if (_export_pixel_type == _EXPORT_PIXEL_16BITS)
						{
							val = bin.readByte();
							
							b = val&0x1F;
							b = (b&0x07) | (b<<3);
							
							g = (val&0xE0)>>5;
							val = bin.readByte();
							g = (g&0x03) | (g<<2) | ((val&0x07)<<5);
							
							r = val&0xF8;
							r = r | ((r>>3)&0x07);
							
							if (r == 0xFF && g == 0 && b == 0xFF)
							{
								a = 0;
							}
							else
							{
								a = 0xFF;
							}
						}
						else
						{
							b = bin.readByte()&0xFF;
							g = bin.readByte()&0xFF;
							r = bin.readByte()&0xFF;
							
							if (r == 0xFF && g == 0 && b == 0xFF)
							{
								a = 0;
							}
							else
							{
								a = 0xFF;
							}
						}
					}
					
					if (color_transform != 1.0)
					{
						r = (int)(r*color_transform + 0.5);
						g = (int)(g*color_transform + 0.5);
						b = (int)(b*color_transform + 0.5);
						
						color = (a<<24) | (r<<16) | (g<<8) | b;
					}
					else
					{
						color = (a<<24) | (r<<16) | (g<<8) | b;
					}
					
					for (var i:int = 0; i < rlen; i++)
					{
						module_bmp_data.setPixel32(x, y, color);
						
						x++;
						if (x >= w)
						{
							x = 0;
							y++;
						}
					}
				}
				else
				{
					if (_image_format == _IMAGE_FORMAT_RAW_8888)
					{
						if (_export_pixel_type == _EXPORT_PIXEL_16BITS)
						{
							b = val&0x0F;
							b = b | (b<<4);
							
							g = val&0xF0;
							g = g | (g>>4);
							
							val = bin.readByte();
							
							r = val&0x0F;
							r = r | (r<<4);
							
							a = val&0xF0;
							a = a | (a>>4);
						}
						//_EXPORT_PIXEL_32BITS
						else
						{
							b = val&0xFF;
							g = bin.readByte()&0xFF;
							r = bin.readByte()&0xFF;
							a = bin.readByte()&0xFF;
						}
					}
					else
					{
						if (_export_pixel_type == _EXPORT_PIXEL_16BITS)
						{
							b = val&0x1F;
							b = (b&0x07) | (b<<3);
							
							g = (val&0xE0)>>5;
							val = bin.readByte();
							g = (g&0x03) | (g<<2) | ((val&0x07)<<5);
							
							r = val&0xF8;
							r = r | ((r>>3)&0x07);
							
							if (r == 0xFF && g == 0 && b == 0xFF)
							{
								a = 0;
							}
							else
							{
								a = 0xFF;
							}
						}
						else
						{
							b = val&0xFF;
							g = bin.readByte()&0xFF;
							r = bin.readByte()&0xFF;
							
							if (r == 0xFF && g == 0 && b == 0xFF)
							{
								a = 0;
							}
							else
							{
								a = 0xFF;
							}
						}
					}

					if (color_transform != 1.0)
					{
						r = (int)(r*color_transform + 0.5);
						g = (int)(g*color_transform + 0.5);
						b = (int)(b*color_transform + 0.5);
						
						color = (a<<24) | (r<<16) | (g<<8) | b;
					}
					else
					{
						color = (a<<24) | (r<<16) | (g<<8) | b;
					}
					
					module_bmp_data.setPixel32(x, y, color);
					x++;
					if (x >= w)
					{
						x = 0;
						y++;
					}
				}
			}
			module_bmp_data.unlock();
		}
		
		private function UnzipIndexImage(bin:ByteArray, offset:int, w:int, h:int, pal:int, module_bmp_data:BitmapData, color_transform:Number = 1.0):void
		{
			var i:int = 0;
			var x:int = 0;
			var y:int = 0;
			var color:uint = 0;
			var a:int = 0;
			var r:int = 0;
			var g:int = 0;
			var b:int = 0;
			
			var rlen:int = 0;
			var val:int = 0;
			
			var pal_data:Vector.<int> = Vector.<int>(_pal_data[pal]);
			
			module_bmp_data.lock();
			while (y < h)
			{
				//unzip index data
				if (_num_colors == 256)
				{
					val = bin.readByte()&0xFF;
					
					color = pal_data[val];
					
					if (color_transform != 1.0)
					{
						a = (color>>24)&0xFF;
						r = (color>>16)&0xFF;
						g = (color>>8)&0xFF;
						b = color&0xFF;
						
						r = (int)(r*color_transform + 0.5);
						g = (int)(g*color_transform + 0.5);
						b = (int)(b*color_transform + 0.5);
						
						module_bmp_data.setPixel32(x, y, (a<<24) | (r<<16) | (g<<8) | b);
					}
					else
					{
						module_bmp_data.setPixel32(x, y, color);
					}
					
					x++;
					if (x >= w)
					{
						x = 0;
						y++;
					}
				}
				else
				{
					val = bin.readByte()&0xFF;
					
					if (val == 0xFF)
					{
						rlen = bin.readByte()&0xFF;
						val = bin.readByte()&0xFF;
						
						for (i = 0; i < rlen; i++)
						{
							color = pal_data[val];
							
							if (color_transform != 1.0)
							{
								a = (color>>24)&0xFF;
								r = (color>>16)&0xFF;
								g = (color>>8)&0xFF;
								b = color&0xFF;
								
								r = (int)(r*color_transform + 0.5);
								g = (int)(g*color_transform + 0.5);
								b = (int)(b*color_transform + 0.5);
								
								module_bmp_data.setPixel32(x, y, (a<<24) | (r<<16) | (g<<8) | b);
							}
							else
							{
								module_bmp_data.setPixel32(x, y, color);
							}
					
							x++;
							if (x >= w)
							{
								x = 0;
								y++;
							}
						}
					}
					else
					{
						color = pal_data[val];
						
						if (color_transform != 1.0)
						{
							a = (color>>24)&0xFF;
							r = (color>>16)&0xFF;
							g = (color>>8)&0xFF;
							b = color&0xFF;
							
							r = (int)(r*color_transform + 0.5);
							g = (int)(g*color_transform + 0.5);
							b = (int)(b*color_transform + 0.5);
							
							module_bmp_data.setPixel32(x, y, (a<<24) | (r<<16) | (g<<8) | b);
						}
						else
						{
							module_bmp_data.setPixel32(x, y, color);
						}
					
						x++;
						if (x >= w)
						{
							x = 0;
							y++;
						}
					}
				}
			}
			
			if (_image_format == _IMAGE_FORMAT_INDEX_ALPHA)
			{
				x = 0;
				y = 0;

				//unzip alpha data
				while (y < h)
				{
					val = bin.readByte()&0xFF;

					if (val == 0xFE)
					{
						rlen = bin.readByte()&0xFF;
						val = bin.readByte()&0xFF;

						for (i = 0; i < rlen; i++)
						{
							if (val != 0xFF)
							{
								color = module_bmp_data.getPixel(x, y);
								color |= (val<<24);
								module_bmp_data.setPixel32(x, y, color);
							}

							x++;
							if (x >= w)
							{
								x = 0;
								y++;
							}
						}
					}
					else
					{
						if (val != 0xFF)
						{
							color = module_bmp_data.getPixel(x, y);
							color |= (val<<24);
							module_bmp_data.setPixel32(x, y, color);
						}

						x++;
						if (x >= w)
						{
							x = 0;
							y++;
						}
					}
				}
			}
			module_bmp_data.unlock();
		}
		
		//use with index image
		public function CachePalette(pal:int):void
		{
			//free old palette bitmap data
			var i:int = 0;
			var module_bmp_data:BitmapData = null;
			
			for (i = 0; i < _num_modules; i++)
			{
				module_bmp_data = _module_bitmap_data[i];
				
				if (module_bmp_data != null)
				{
					module_bmp_data.dispose();
					_module_bitmap_data[i] = null;
					module_bmp_data = null;
				}
			}
			
			//cache new palette
			_current_pal = pal;
			var raw_data_size:int = 0;
			var raw_data:ByteArray = null;
			var w:int = 0;
			var h:int = 0;
			for (i = 0; i < _num_modules; i++)
			{
				w = _module_w[i];
				h = _module_h[i];
				raw_data = _module_raw_data[i];
				
				if (w != 0 && h != 0)
				{
					//unzip module's raw data
					module_bmp_data = new BitmapData(w, h, true, 0);
					
					UnzipIndexImage(raw_data, raw_data.position, w, h, _current_pal, module_bmp_data);
					
					_module_bitmap_data[i] = module_bmp_data;
				}
			}
		}
		
		public function DrawModuleLite(back_buffer:BitmapData, module_id:int, x:int, y:int):void
		{
			var module_bmp_data:BitmapData = _module_bitmap_data[module_id];
			var w:int = _module_w[module_id];
			var h:int = _module_h[module_id];
			
			if (w == 0 || h == 0)
			{
				return;
			}
			
			back_buffer.copyPixels(module_bmp_data, new Rectangle(0, 0, w, h), new Point(x, y), null, null, _image_format == _IMAGE_FORMAT_RAW_0888 ? false : true);
		}
		
		public function DrawModule(back_buffer:BitmapData, module_id:int, x:int, y:int, blend_mode:String = null):void
		{
			var module_bmp_data:BitmapData = _module_bitmap_data[module_id];
			
			if ((!_use_color_transform) && (blend_mode == null))
			{
				var w:int = _module_w[module_id];
				var h:int = _module_h[module_id];
				
				if (w == 0 || h == 0)
				{
					return;
				}
				
				back_buffer.copyPixels(module_bmp_data, new Rectangle(0, 0, w, h), new Point(x, y), null, null, _image_format == _IMAGE_FORMAT_RAW_0888 ? false : true);
			}
			else
			{	
				var trans_matrix:Matrix = new Matrix(1, 0, 0, 1, x, y);
				
				if (_use_color_transform)
				{
					back_buffer.draw(module_bmp_data, trans_matrix, _color_transform, _blend_mode == null ? blend_mode : _blend_mode, null, true);
				}
				else
				{
					back_buffer.draw(module_bmp_data, trans_matrix, null, _blend_mode == null ? blend_mode : _blend_mode, null, true);
				}
			}
		}
		
		public function DrawModuleTransform(back_buffer:BitmapData, module_id:int, trans_matrix:Matrix, blend_mode:String = null):void
		{
			var w:int = _module_w[module_id];
			var h:int = _module_h[module_id];

			if (w == 0 || h == 0)
			{
				return;
			}
			
			var module_bmp_data:BitmapData = _module_bitmap_data[module_id];
			
			if (_use_color_transform)
			{
				back_buffer.draw(module_bmp_data, trans_matrix, _color_transform, _blend_mode == null ? blend_mode : _blend_mode, null, true);
			}
			else
			{
				back_buffer.draw(module_bmp_data, trans_matrix, null, _blend_mode == null ? blend_mode : _blend_mode, null, true);
			}
		}
		
		public function DrawModuleTransform2(back_buffer:BitmapData, module_id:int, trans_matrix:Matrix, cmatrix:ColorTransform, blend_mode:String = null):void
		{
			var w:int = _module_w[module_id];
			var h:int = _module_h[module_id];

			if (w == 0 || h == 0)
			{
				return;
			}
			
			var module_bmp_data:BitmapData = _module_bitmap_data[module_id];
			
			if (_use_color_transform)
			{
				cmatrix.concat(_color_transform);
				
				back_buffer.draw(module_bmp_data, trans_matrix, cmatrix, _blend_mode == null ? blend_mode : _blend_mode, null, true);
			}
			else
			{
				back_buffer.draw(module_bmp_data, trans_matrix, cmatrix, _blend_mode == null ? blend_mode : _blend_mode, null, true);
			}
		}
		
		public function DrawFrameLite(back_buffer:BitmapData, frame_id:int, x:int, y:int):void
		{
			var fmodule_min:int = 0;
			var fmodule_max:int = 0;
			
			var module:int = 0;
			var fmodule_transf:int = 0;
			var ox:int = 0;
			var oy:int = 0;
			var i:int = 0;
			
			
			if (frame_id < (_num_frames - 1))
			{
				fmodule_min = _frame_offset[frame_id];
				fmodule_max = _frame_offset[int(frame_id + 1)] - 1;
			}
			else if (frame_id == (_num_frames - 1))
			{
				fmodule_min = _frame_offset[frame_id];
				fmodule_max = _num_fmodules - 1;
			}
			
			var fm_trans_matrix:Matrix = new Matrix();
			
			for (i = fmodule_min; i <= fmodule_max; i++)
			{
				module = _fmodule_id[i];
				ox = _fmodule_x[i];
				oy = _fmodule_y[i];
				fmodule_transf = _fmodule_transf[i];
				
				//draw fmodule
				if (fmodule_transf == 0)
				{
					DrawModuleLite(	back_buffer,
									module,
									ox + x,
									oy + y
									);
				}
				else
				{
					fm_trans_matrix.identity();
					fm_trans_matrix.tx = ox;
					fm_trans_matrix.ty = oy;
					
					if ((fmodule_transf & _FLIP_H) != 0)
					{
						fm_trans_matrix.a = -fm_trans_matrix.a;
						//fm_trans_matrix.b = -fm_trans_matrix.b;
						fm_trans_matrix.tx = -fm_trans_matrix.tx;
					}
					
					if ((fmodule_transf & _FLIP_V) != 0)
					{
						//fm_trans_matrix.c = -fm_trans_matrix.c;
						fm_trans_matrix.d = -fm_trans_matrix.d;
						fm_trans_matrix.ty = -fm_trans_matrix.ty;
					}
					
					fm_trans_matrix.tx += x;
					fm_trans_matrix.ty += y;
					
					DrawModuleTransform(	back_buffer,
											module,
											fm_trans_matrix
											);
				}
			}
		}
	
		public function DrawFrame(back_buffer:BitmapData, frame_id:int, x:int, y:int, transform:int = 0, angle:Number = 0, scale:Number = 1):void
		{
			var fmodule_min:int = 0;
			var fmodule_max:int = 0;
			
			var module:int = 0;
			var fmodule_transf:int = 0;
			var ox:Number = 0;
			var oy:Number = 0;
			var blend_mode:String = null;
			var i:int = 0;
			
			var fm_trans_matrix:Matrix = new Matrix();
			
			if (frame_id < (_num_frames - 1))
			{
				fmodule_min = _frame_offset[frame_id];
				fmodule_max = _frame_offset[int(frame_id + 1)] - 1;
			}
			else if (frame_id == (_num_frames - 1))
			{
				fmodule_min = _frame_offset[frame_id];
				fmodule_max = _num_fmodules - 1;
			}
			
			if (transform == 0)
			{
				for (i = fmodule_min; i <= fmodule_max; i++)
				{
					module = _fmodule_id[i];
					
					if (_is_free_transform)
					{
						ox = _fmodule_fx[i];
						oy = _fmodule_fy[i];
					}
					else
					{
						ox = _fmodule_x[i];
						oy = _fmodule_y[i];
					}
					
					fmodule_transf = _fmodule_transf[i];
					
					blend_mode = _fmodule_blend_mode[i];
					
					//draw fmodule
					if (fmodule_transf == 0)
					{
						DrawModule(	back_buffer,
									module,
									ox + x,
									oy + y,
									blend_mode
									);
					}
					else
					{
						if ((fmodule_transf & _FREE_TRANSFORM) != 0)
						{
							fm_trans_matrix.a = _fmodule_m11[i];
							fm_trans_matrix.b = _fmodule_m12[i];
							fm_trans_matrix.c = _fmodule_m21[i];
							fm_trans_matrix.d = _fmodule_m22[i];
							fm_trans_matrix.tx = ox;
							fm_trans_matrix.ty = oy;
						}
						else
						{
							fm_trans_matrix.identity();
							fm_trans_matrix.tx = ox;
							fm_trans_matrix.ty = oy;
						}
						
						if ((fmodule_transf & _FLIP_H) != 0)
						{
							fm_trans_matrix.a = -fm_trans_matrix.a;
							fm_trans_matrix.b = -fm_trans_matrix.b;
							fm_trans_matrix.tx = -fm_trans_matrix.tx;
						}
						
						if ((fmodule_transf & _FLIP_V) != 0)
						{
							fm_trans_matrix.c = -fm_trans_matrix.c;
							fm_trans_matrix.d = -fm_trans_matrix.d;
							fm_trans_matrix.ty = -fm_trans_matrix.ty;
						}
						
						fm_trans_matrix.tx += x;
						fm_trans_matrix.ty += y;
						
						if ((fmodule_transf & _COLOR_TRANSFORM) != 0)
						{
							_fm_color_transform.alphaMultiplier = _fmodule_alpha_mul[i];
							_fm_color_transform.alphaOffset = 0;
							_fm_color_transform.redMultiplier = _fmodule_red_mul[i];
							_fm_color_transform.redOffset = _fmodule_red_off[i];
							_fm_color_transform.greenMultiplier = _fmodule_green_mul[i];
							_fm_color_transform.greenOffset = _fmodule_green_off[i];
							_fm_color_transform.blueMultiplier = _fmodule_blue_mul[i];
							_fm_color_transform.blueOffset = _fmodule_blue_off[i];
							
							DrawModuleTransform2(	back_buffer,
													module,
													fm_trans_matrix,
													_fm_color_transform,
													blend_mode
													);
						}
						else
						{
							DrawModuleTransform(	back_buffer,
													module,
													fm_trans_matrix,
													blend_mode
													);
						}
					}
				}
			}
			else
			{
				var trans_matrix:Matrix = new Matrix();
				
				if ((transform & _FLIP_H) != 0)
				{
					trans_matrix.a = -1;
				}
				
				if ((transform & _FLIP_V) != 0)
				{
					trans_matrix.d = -1;
				}
				
				if (scale != 1)
				{
					trans_matrix.a *= scale;
					trans_matrix.d *= scale;
				}
				
				if (angle == 0)
				{
					trans_matrix.rotate(Math.PI*angle/180);
				}
				
				for (i = fmodule_min; i <= fmodule_max; i++)
				{
					module = _fmodule_id[i];
					if (_is_free_transform)
					{
						ox = _fmodule_fx[i];
						oy = _fmodule_fy[i];
					}
					else
					{
						ox = _fmodule_x[i];
						oy = _fmodule_y[i];
					}
					fmodule_transf = _fmodule_transf[i];
					blend_mode = _fmodule_blend_mode[i];
					
					if ((fmodule_transf & _FREE_TRANSFORM) != 0)
					{
						fm_trans_matrix.a = _fmodule_m11[i];
						fm_trans_matrix.b = _fmodule_m12[i];
						fm_trans_matrix.c = _fmodule_m21[i];
						fm_trans_matrix.d = _fmodule_m22[i];
						fm_trans_matrix.tx = ox;
						fm_trans_matrix.ty = oy;
					}
					else
					{
						fm_trans_matrix.identity();
						fm_trans_matrix.tx = ox;
						fm_trans_matrix.ty = oy;
					}
					
					
					fm_trans_matrix.concat(trans_matrix);
					
					fm_trans_matrix.tx += x;
					fm_trans_matrix.ty += y;
					
					if ((fmodule_transf & _COLOR_TRANSFORM) != 0)
					{
						_fm_color_transform.alphaMultiplier = _fmodule_alpha_mul[i];
						_fm_color_transform.alphaOffset = 0;
						_fm_color_transform.redMultiplier = _fmodule_red_mul[i];
						_fm_color_transform.redOffset = _fmodule_red_off[i];
						_fm_color_transform.greenMultiplier = _fmodule_green_mul[i];
						_fm_color_transform.greenOffset = _fmodule_green_off[i];
						_fm_color_transform.blueMultiplier = _fmodule_blue_mul[i];
						_fm_color_transform.blueOffset = _fmodule_blue_off[i];
						
						
						DrawModuleTransform2(	back_buffer,
												module,
												fm_trans_matrix,
												_fm_color_transform,
												blend_mode
												);
					}
					else
					{
						DrawModuleTransform(	back_buffer,
												module,
												fm_trans_matrix,
												blend_mode
												);
					}
				}
			}
		}
		
		public function DrawFrame2(back_buffer:BitmapData, frame_id:int, x:Number, y:Number, transform:int = 0, angle:Number = 0, scale:Number = 1):void
		{
			var fmodule_min:int = 0;
			var fmodule_max:int = 0;
			
			var module:int = 0;
			var fmodule_transf:int = 0;
			var ox:Number = 0;
			var oy:Number = 0;
			var blend_mode:String = null;
			var i:int = 0;
			
			var fm_trans_matrix:Matrix = new Matrix();
			
			if (frame_id < (_num_frames - 1))
			{
				fmodule_min = _frame_offset[frame_id];
				fmodule_max = _frame_offset[int(frame_id + 1)] - 1;
			}
			else if (frame_id == (_num_frames - 1))
			{
				fmodule_min = _frame_offset[frame_id];
				fmodule_max = _num_fmodules - 1;
			}
			
			if (transform == 0)
			{
				for (i = fmodule_min; i <= fmodule_max; i++)
				{
					module = _fmodule_id[i];
					
					if (_is_free_transform)
					{
						ox = _fmodule_fx[i];
						oy = _fmodule_fy[i];
					}
					else
					{
						ox = _fmodule_x[i];
						oy = _fmodule_y[i];
					}
					
					fmodule_transf = _fmodule_transf[i];
					blend_mode = _fmodule_blend_mode[i];
					
					//draw fmodule
					if (fmodule_transf == 0)
					{
						DrawModule(	back_buffer,
									module,
									ox + x,
									oy + y,
									blend_mode
									);
					}
					else
					{
						if ((fmodule_transf & _FREE_TRANSFORM) != 0)
						{
							fm_trans_matrix.a = _fmodule_m11[i];
							fm_trans_matrix.b = _fmodule_m12[i];
							fm_trans_matrix.c = _fmodule_m21[i];
							fm_trans_matrix.d = _fmodule_m22[i];
							fm_trans_matrix.tx = ox;
							fm_trans_matrix.ty = oy;
						}
						else
						{
							fm_trans_matrix.identity();
							fm_trans_matrix.tx = ox;
							fm_trans_matrix.ty = oy;
						}
						
						if ((fmodule_transf & _FLIP_H) != 0)
						{
							fm_trans_matrix.a = -fm_trans_matrix.a;
							fm_trans_matrix.b = -fm_trans_matrix.b;
							fm_trans_matrix.tx = -fm_trans_matrix.tx;
						}
						
						if ((fmodule_transf & _FLIP_V) != 0)
						{
							fm_trans_matrix.c = -fm_trans_matrix.c;
							fm_trans_matrix.d = -fm_trans_matrix.d;
							fm_trans_matrix.ty = -fm_trans_matrix.ty;
						}
						
						fm_trans_matrix.tx += x;
						fm_trans_matrix.ty += y;
						
						if ((fmodule_transf & _COLOR_TRANSFORM) != 0)
						{
							_fm_color_transform.alphaMultiplier = _fmodule_alpha_mul[i];
							_fm_color_transform.alphaOffset = 0;
							_fm_color_transform.redMultiplier = _fmodule_red_mul[i];
							_fm_color_transform.redOffset = _fmodule_red_off[i];
							_fm_color_transform.greenMultiplier = _fmodule_green_mul[i];
							_fm_color_transform.greenOffset = _fmodule_green_off[i];
							_fm_color_transform.blueMultiplier = _fmodule_blue_mul[i];
							_fm_color_transform.blueOffset = _fmodule_blue_off[i];
							
							
							DrawModuleTransform2(	back_buffer,
													module,
													fm_trans_matrix,
													_fm_color_transform,
													blend_mode
													);
						}
						else
						{
							DrawModuleTransform(	back_buffer,
													module,
													fm_trans_matrix,
													blend_mode
													);
						}
					}
				}
			}
			else
			{	
				var concat:Boolean = true;
				if (scale == 1 && angle == 0)
				{
					concat = false;
				}
				
				var trans_matrix:Matrix = new Matrix();
				if (concat)
				{
					trans_matrix.a *= scale;
					trans_matrix.d *= scale;
					trans_matrix.rotate(Math.PI*angle/180);
				}
				
				
				for (i = fmodule_min; i <= fmodule_max; i++)
				{
					module = _fmodule_id[i];
					if (_is_free_transform)
					{
						ox = _fmodule_fx[i];
						oy = _fmodule_fy[i];
					}
					else
					{
						ox = _fmodule_x[i];
						oy = _fmodule_y[i];
					}
					fmodule_transf = _fmodule_transf[i];
					blend_mode = _fmodule_blend_mode[i];
						
					if ((fmodule_transf & _FREE_TRANSFORM) != 0)
					{
						fm_trans_matrix.a = _fmodule_m11[i];
						fm_trans_matrix.b = _fmodule_m12[i];
						fm_trans_matrix.c = _fmodule_m21[i];
						fm_trans_matrix.d = _fmodule_m22[i];
						fm_trans_matrix.tx = ox;
						fm_trans_matrix.ty = oy;
					}
					else
					{
						fm_trans_matrix.identity();
						fm_trans_matrix.tx = ox;
						fm_trans_matrix.ty = oy;
					}
					
					fmodule_transf ^= transform;
					
					if ((fmodule_transf & _FLIP_H) != 0)
					{
						fm_trans_matrix.a = -fm_trans_matrix.a;
						fm_trans_matrix.b = -fm_trans_matrix.b;
						fm_trans_matrix.tx = -fm_trans_matrix.tx;
					}
					
					if ((fmodule_transf & _FLIP_V) != 0)
					{
						fm_trans_matrix.c = -fm_trans_matrix.c;
						fm_trans_matrix.d = -fm_trans_matrix.d;
						fm_trans_matrix.ty = -fm_trans_matrix.ty;
					}
					
					if (concat)
					{
						fm_trans_matrix.concat(trans_matrix);
					}
					
					fm_trans_matrix.tx += x;
					fm_trans_matrix.ty += y;
					
					if ((fmodule_transf & _COLOR_TRANSFORM) != 0)
					{
						_fm_color_transform.alphaMultiplier = _fmodule_alpha_mul[i];
						_fm_color_transform.alphaOffset = 0;
						_fm_color_transform.redMultiplier = _fmodule_red_mul[i];
						_fm_color_transform.redOffset = _fmodule_red_off[i];
						_fm_color_transform.greenMultiplier = _fmodule_green_mul[i];
						_fm_color_transform.greenOffset = _fmodule_green_off[i];
						_fm_color_transform.blueMultiplier = _fmodule_blue_mul[i];
						_fm_color_transform.blueOffset = _fmodule_blue_off[i];
						
						
						DrawModuleTransform2(	back_buffer,
												module,
												fm_trans_matrix,
												_fm_color_transform,
												blend_mode
												);
					}
					else
					{
						DrawModuleTransform(	back_buffer,
												module,
												fm_trans_matrix,
												blend_mode
												);
					}
				}
			}
		}
		
		public function DrawFrame3(back_buffer:BitmapData, frame_id:int, m:Matrix, transform:int, angle:Number = 0, scale:Number = 1):void
		{
			var fmodule_min:int = 0;
			var fmodule_max:int = 0;
			
			var module:int = 0;
			var fmodule_transf:int = 0;
			var ox:Number = 0;
			var oy:Number = 0;
			var blend_mode:String = null;
			var i:int = 0;
			
			var fm_trans_matrix:Matrix = new Matrix();
			
			if (frame_id < (_num_frames - 1))
			{
				fmodule_min = _frame_offset[frame_id];
				fmodule_max = _frame_offset[int(frame_id + 1)] - 1;
			}
			else if (frame_id == (_num_frames - 1))
			{
				fmodule_min = _frame_offset[frame_id];
				fmodule_max = _num_fmodules - 1;
			}
		
			var trans_matrix:Matrix = new Matrix();
			
			trans_matrix.a *= scale;
			trans_matrix.d *= scale;
			trans_matrix.rotate(Math.PI*angle/180);
			trans_matrix.concat(m);
			
			for (i = fmodule_min; i <= fmodule_max; i++)
			{
				module = _fmodule_id[i];
				if (_is_free_transform)
				{
					ox = _fmodule_fx[i];
					oy = _fmodule_fy[i];
				}
				else
				{
					ox = _fmodule_x[i];
					oy = _fmodule_y[i];
				}
				fmodule_transf = _fmodule_transf[i];
				blend_mode = _fmodule_blend_mode[i];
					
				if ((fmodule_transf & _FREE_TRANSFORM) != 0)
				{
					fm_trans_matrix.a = _fmodule_m11[i];
					fm_trans_matrix.b = _fmodule_m12[i];
					fm_trans_matrix.c = _fmodule_m21[i];
					fm_trans_matrix.d = _fmodule_m22[i];
					fm_trans_matrix.tx = ox;
					fm_trans_matrix.ty = oy;
				}
				else
				{
					fm_trans_matrix.identity();
					fm_trans_matrix.tx = ox;
					fm_trans_matrix.ty = oy;
				}
				
				fmodule_transf ^= transform;
				
				if ((fmodule_transf & _FLIP_H) != 0)
				{
					fm_trans_matrix.a = -fm_trans_matrix.a;
					fm_trans_matrix.b = -fm_trans_matrix.b;
					fm_trans_matrix.tx = -fm_trans_matrix.tx;
				}
				
				if ((fmodule_transf & _FLIP_V) != 0)
				{
					fm_trans_matrix.c = -fm_trans_matrix.c;
					fm_trans_matrix.d = -fm_trans_matrix.d;
					fm_trans_matrix.ty = -fm_trans_matrix.ty;
				}
				
				fm_trans_matrix.concat(trans_matrix);
				
				if ((fmodule_transf & _COLOR_TRANSFORM) != 0)
				{
					_fm_color_transform.alphaMultiplier = _fmodule_alpha_mul[i];
					_fm_color_transform.alphaOffset = 0;
					_fm_color_transform.redMultiplier = _fmodule_red_mul[i];
					_fm_color_transform.redOffset = _fmodule_red_off[i];
					_fm_color_transform.greenMultiplier = _fmodule_green_mul[i];
					_fm_color_transform.greenOffset = _fmodule_green_off[i];
					_fm_color_transform.blueMultiplier = _fmodule_blue_mul[i];
					_fm_color_transform.blueOffset = _fmodule_blue_off[i];
					
					
					DrawModuleTransform2(	back_buffer,
											module,
											fm_trans_matrix,
											_fm_color_transform,
											blend_mode
											);
				}
				else
				{
					DrawModuleTransform(	back_buffer,
											module,
											fm_trans_matrix,
											blend_mode
											);
				}
			}
		}
		
		public function DrawCurrentAFrameLite(back_buffer:BitmapData, anim_id:int, x:int, y:int):void
		{
			if (!_is_current_anim_stop)
			{
				var aframe_id:int = _aframe_id[_current_aframes];
				var ox:int = _aframe_x[_current_aframes];
				var oy:int = _aframe_y[_current_aframes];
				var transf:int = _aframe_transf[_current_aframes];
				
				DrawFrameLite(	back_buffer, aframe_id, ox + x, oy + y);
			}
		}
		
		public function DrawCurrentAFrame(back_buffer:BitmapData, anim_id:int, x:int, y:int, transform:int = 0, angle:Number = 0, scale:Number = 1):void
		{
			if (_current_anim != anim_id)
			{
				_current_anim = anim_id;
				_min_aframes = _anim_offset[_current_anim];
				if (_current_anim == (_num_anims - 1))
				{
					_max_aframes = _num_aframes - 1;
				}
				else
				{
					_max_aframes = _anim_offset[int(_current_anim + 1)] - 1;
				}
				_current_aframes = _min_aframes;
				_current_aframes_time = _aframe_time[_current_aframes];
				_is_current_anim_stop = false;
			}
			
			if (!_is_current_anim_stop)
			{
				var aframe_id:int = _aframe_id[_current_aframes];
				var ox:int = _aframe_x[_current_aframes];
				var oy:int = _aframe_y[_current_aframes];
				var transf:int = _aframe_transf[_current_aframes];
				
				if (transform == 0)
				{
					DrawFrame(	back_buffer, 
								aframe_id, 
								ox + x, 
								oy + y,							
								transf);
				}
				else
				{
					if ((transform & _FLIP_H) != 0)
					{
						ox = -ox;
					}
					
					if ((transform & _FLIP_V) != 0)
					{
						oy = -oy;		
					}
				
					DrawFrame(	back_buffer, 
								aframe_id, 
								ox*scale + x, 
								oy*scale + y,							
								transf ^ transform,
								angle,
								scale);
				}
			}
		}
		
		public function DrawCurrentAFrame2(back_buffer:BitmapData, anim_id:int, m:Matrix, transform:int = 0, angle:Number = 0, scale:Number = 1):void
		{
			if (_current_anim != anim_id)
			{
				_current_anim = anim_id;
				_min_aframes = _anim_offset[_current_anim];
				if (_current_anim == (_num_anims - 1))
				{
					_max_aframes = _num_aframes - 1;
				}
				else
				{
					_max_aframes = _anim_offset[int(_current_anim + 1)] - 1;
				}
				_current_aframes = _min_aframes;
				_current_aframes_time = _aframe_time[_current_aframes];
				_is_current_anim_stop = false;
			}
			
			if (!_is_current_anim_stop)
			{
				var aframe_id:int = _aframe_id[_current_aframes];
				var ox:int = _aframe_x[_current_aframes];
				var oy:int = _aframe_y[_current_aframes];
				var transf:int = _aframe_transf[_current_aframes];
			
				m.translate(ox*scale, oy*scale);
				DrawFrame3(	back_buffer, 
							aframe_id, 
							m,
							transform,
							angle,
							scale);
				
			}
		}
		
		public function NextAFrame(is_loop:Boolean = false):void
		{
			_current_aframes_time--;
	
			if (_current_aframes_time == 0)
			{
				_current_aframes++;
				
				if (_current_aframes <= _max_aframes)
				{
					_current_aframes_time = _aframe_time[_current_aframes];
				}
				else if (is_loop)
				{
					_current_aframes = _min_aframes;
					_current_aframes_time = _aframe_time[_current_aframes];
				}
				else
				{
					_is_current_anim_stop = true;
				}
			}
		}
		
		public function PreviousAFrame(is_loop:Boolean = false):void
		{
			_current_aframes_time--;
	
			if (_current_aframes_time == 0)
			{
				_current_aframes--;
				
				if (_current_aframes >= _min_aframes)
				{
					_current_aframes_time = _aframe_time[_current_aframes];
				}
				else if (is_loop)
				{
					_current_aframes = _max_aframes;
					_current_aframes_time = _aframe_time[_current_aframes];
				}
				else
				{
					_is_current_anim_stop = true;
				}
			}
		}
		
		public function SetAnim(anim:int, aframe:int, cur_aframe_time:int, is_loop:Boolean):void
		{
			//set current anim
			_current_anim = anim;
			
			//get min max aframe
			_min_aframes = _anim_offset[_current_anim];
			if (_current_anim == (_num_anims - 1))
			{
				_max_aframes = _num_aframes - 1;
			}
			else
			{
				_max_aframes = _anim_offset[int(_current_anim + 1)] - 1;
			}
			
			//set aframe and aframe time
			_current_aframes = aframe;
			_current_aframes_time = cur_aframe_time;
			
			_is_current_anim_stop = false;
			//check is anim stop
			if (_current_aframes_time == 0)
			{
				_current_aframes++;
				
				if (_current_aframes <= _max_aframes)
				{
					_current_aframes_time = _aframe_time[_current_aframes];
				}
				else if (is_loop)
				{
					_current_aframes = _min_aframes;
					_current_aframes_time = _aframe_time[_current_aframes];
				}
				else
				{
					_is_current_anim_stop = true;
				}
			}
		}
		
		public function GetFirstAFrameID(anim:int):int
		{
			//get min aframe
			return _anim_offset[anim]&0xFFFF;
		}
		
		public function GetFirstAFrameTime(anim:int):int
		{
			var aframe:int = _anim_offset[anim]&0xFFFF;
			return _aframe_time[aframe];
		}
		
		public function GetFirstFrameID(anim:int):int
		{
			var aframe:int = _anim_offset[anim]&0xFFFF;
			return _aframe_id[aframe];
		}
		
		public function GetTotalAnimTime(anim:int):int
		{
			if (anim < 0 || anim >= _num_anims)
			{
				return 0;
			}
			
			//get min max aframe
			var min_aframes:int = _anim_offset[anim];
			var max_aframes:int = 0;
			if (anim == (_num_anims - 1))
			{
				max_aframes = _num_aframes - 1;
			}
			else
			{
				max_aframes = _anim_offset[int(anim + 1)] - 1;
			}
			
			var total_anim_time:int = 0;
			for (var i:int = min_aframes; i <= max_aframes; i++)
			{
				total_anim_time += _aframe_time[i];
			}
			
			return total_anim_time;
		}
		
		public function IsAnimStop(anim_id:int):Boolean
		{
			if (_current_anim != anim_id)
			{
				return true;
			}
			
			return _is_current_anim_stop;
		}
		
		public function GetTotalAFrame(anim:int):int
		{
			if (anim < 0 || anim >= _num_anims)
			{
				return 0;
			}
			
			//get min max aframe
			var min_aframes:int = _anim_offset[anim];
			var max_aframes:int = 0;
			if (anim == (_num_anims - 1))
			{
				max_aframes = _num_aframes - 1;
			}
			else
			{
				max_aframes = _anim_offset[int(anim + 1)] - 1;
			}
			
			return max_aframes - min_aframes + 1;
		}
		
		public function DrawPage(back_buffer:BitmapData, text:String, length:int, x:int, y:int, w:int, anchor:int):void
		{
			var yy:int = y;
			var character:int;
			var c:int;
			var width:int = 0;
			var start_off:int = 0;
			var end_off:int = 0;
			var fmodule_min:int = 0;
			var	ox:int = 0;
			var mw:int = 0;
			var fid:int = 0;
			
			var blockwidth:int = 0;
			var start_block:int = 0;
			var end_block:int = 0;
			
			for (var i:int = 0; i < length; i++)
			{
				character = text.charCodeAt(i);
				c = character - 33;
				
				if (c < 0)
				{
					c = 0;
				}
				
				if(character == 92 && text.charCodeAt(i+1) == 110) //newline: "\n" = 92 + 110
				{
					width += blockwidth;
					
					if (width >= w)
					{
						width -= blockwidth;
						
						DrawString(back_buffer, text, start_off, start_block - start_off, width, x, yy, anchor);
						yy += (_module_w[int(0)]&0xFFFF) + _line_spacing;
						
						width = blockwidth;
						start_off = start_block;
					}
					
					DrawString(back_buffer, text, start_off, i - start_off, width, x, yy, anchor);
					yy += (_module_w[int(0)]&0xFFFF) + _line_spacing;
					
					start_block = i+2;
					start_off = start_block;
					blockwidth = 0;
					width = blockwidth;
					i++;
				}
				else
				{
					fmodule_min = _frame_offset[c];
					ox = _fmodule_x[fmodule_min];
					fid = _fmodule_id[fmodule_min];
					mw = _module_w[fid];
								
					blockwidth += ox + mw + _char_spacing;
					
					//endline marker: space char(unicode = 32)
					if (character == 32)
					{		
						width += blockwidth;
						
						if (width >= w)
						{
							width -= blockwidth;
							
							DrawString(back_buffer, text, start_off, start_block - start_off, width, x, yy, anchor);
							yy += (_module_w[int(0)]&0xFFFF) + _line_spacing;
							
							width = blockwidth;
							start_off = start_block;
						}
						
						start_block = i+1;
						blockwidth = 0;
					}
				}				
			}
			
			DrawString(back_buffer, text, start_off, length - start_off, width + blockwidth, x, yy, anchor);
		}
		
		public function DrawText(back_buffer:BitmapData, text:String, x:int, y:int, anchor:int, isNumeral:Boolean=false):void
		{
			var textwidth:int = 0;
			
			//optimize
			if ((anchor&_LEFT) == 0 || (anchor&_TOP) == 0)
			{
				textwidth = GetTextWidth(text, 0, text.length, isNumeral);
			}
	
			DrawString(back_buffer, text, 0, text.length, textwidth, x, y, anchor, isNumeral);
		}
		
		private function DrawString(back_buffer:BitmapData, text:String, offset:int, length:int, textwidth:int, x:int, y:int, anchor:int, isNumeral:Boolean=false):void
		{
			var xx:int = x;
			var yy:int = y;
			
			if ((anchor&_RIGHT) != 0)
			{
				xx -= textwidth;
			}
			else if ((anchor&_HCENTER) != 0)
			{
				xx -= (textwidth>>1);
			}
			
			if ((anchor&_BOTTOM) != 0)
			{
				yy -= (_module_h[int(0)]&0xFFFF);
			}
			else if ((anchor&_VCENTER) != 0)
			{
				yy -= ((_module_h[int(0)]&0xFFFF)>>1);
			}
			
			var end_offset:int = offset + length;
			
			var fmodule_min:int = 0;
			var	ox:int = 0;
			var w:int = 0;
			var fid:int = 0;
			
			for (var i:int = offset; i < end_offset; i++)
			{
				var c:int;

				if(!isNumeral)
				{					
					c = text.charCodeAt(i) - 33;					
				}
				else
				{
					c = text.charCodeAt(i) - 48;	
				}
				
				if (c >= 0)
				{
					DrawFrame(back_buffer, c, xx, yy);
					fmodule_min = _frame_offset[c];
				}
				else
				{
					fmodule_min = _frame_offset[int(0)];
				}
				
				ox = _fmodule_x[fmodule_min];
				fid = _fmodule_id[fmodule_min];
				w = _module_w[fid];
				
				xx += ox + w + _char_spacing;
			}
		}
				
		public function GetTextWidth(text:String, offset:int, length:int, isNumeral:Boolean=false):int
		{
			var width:int = 0;
	
			var end_offset:int = offset + length;
			var fmodule_min:int = 0;
			var	ox:int = 0;
			var w:int = 0;
			var fid:int = 0;
			
			for (var i:int = offset; i < end_offset; i++)
			{
				var c:int;

				if(!isNumeral)
				{					
					c = text.charCodeAt(i) - 33;					
				}
				else
				{
					c = text.charCodeAt(i) - 48;	
				}
				
				if (c < 0)
				{
					c = 0;
				}
				
				fmodule_min = _frame_offset[c];
				ox = _fmodule_x[fmodule_min];
				fid = _fmodule_id[fmodule_min];
				w = _module_w[fid];
				
				width += ox + w + _char_spacing;	
			}
			
			return width;
		}
		
		public function GetCharWidth(c:int):int
		{
			var i:int = c - 33;

			if (i < 0)
			{
				i = 0;
			}
			
			var fmodule_min:int = _frame_offset[i];
			var	ox:int = _fmodule_x[fmodule_min];
			var fid:int = _fmodule_id[fmodule_min];
			var w:int = _module_w[fid];
			
			return (ox + w);
		}
		
		public function GetFontHeight():int
		{
			var	oy:int = _fmodule_y[int(0)];
			var fid:int = _fmodule_id[int(0)];
			var h:int = _module_h[fid];
			
			return oy + h;
		}		
		
		//@Chao add frame rect
		public function CreateFrameRect(frame_id:int):Rectangle
		{
			var frame_rect:Rectangle;		
			
			var fmodule_min:int = 0;
			var fmodule_max:int = 0;			
			
			var module:int = 0;						
			
			if (frame_id < (_num_frames - 1))
			{
				fmodule_min = _frame_offset[frame_id];
				fmodule_max = _frame_offset[int(frame_id + 1)] - 1;
			}
			else if (frame_id == (_num_frames - 1))
			{
				fmodule_min = _frame_offset[frame_id];
				fmodule_max = _num_fmodules - 1;
			}			
			
			var matrix:Matrix = Manager.pool.pop(Matrix) as Matrix;
			var polygon:Polygon = Manager.pool.pop(Polygon) as Polygon;
			var i:int;
			for (i = 0; i < 4; ++i)
			{
				polygon.points[i] = Manager.pool.pop(Point) as Point;
			}
			
			for (i = fmodule_min; i <= fmodule_max; i++)
			{					
				module = _fmodule_id[i];
				
				Point(polygon.points[0]).setTo(	0				, 0);
				Point(polygon.points[1]).setTo(	0				, _module_h[module]);
				Point(polygon.points[2]).setTo(_module_w[module], _module_h[module]);
				Point(polygon.points[3]).setTo(_module_w[module], 0);
				
				
				if (_is_free_transform)
				{
					matrix.a = _fmodule_m11[i];
					matrix.b = _fmodule_m12[i];
					matrix.c = _fmodule_m21[i];
					matrix.d = _fmodule_m22[i];
					matrix.tx = _fmodule_fx[i];
					matrix.ty = _fmodule_fy[i];
				}
				else
				{
					matrix.a = 1;
					matrix.b = 0;
					matrix.c = 0;
					matrix.d = 1;
					matrix.tx = _fmodule_x[i];
					matrix.ty = _fmodule_y[i];
				}
				
				
				polygon.transform(matrix);
				
				var aabb:Rectangle = polygon.getAABB();
				if(i == fmodule_min) frame_rect = aabb;
				else 
				{
					if(aabb.left < frame_rect.left) frame_rect.left = aabb.left;
					if(aabb.right > frame_rect.right) frame_rect.right = aabb.right;
					if(aabb.top < frame_rect.top) frame_rect.top = aabb.top;
					if(aabb.bottom > frame_rect.bottom) frame_rect.bottom = aabb.bottom;
					Manager.pool.push(aabb, Rectangle);
				}
			}
			for (i = 0; i < 4; ++i)
			{
				Manager.pool.push(polygon.points[i], Point);
			}
			Manager.pool.push(polygon, Polygon);
			Manager.pool.push(matrix, Matrix);
			if (frame_rect != null)
			{
				frame_rect.x = Math.floor(frame_rect.x);
				frame_rect.y = Math.floor(frame_rect.y);
			}
			return frame_rect;			
		}
		
		//@Chao add frame rect
		public function GetFrameRect(frame_id:int):Rectangle
		{
			return _frame_rects[frame_id];
		}

		public function GetAFrameRect(aframe_id:int):Rectangle
		{			
			return _frame_rects[int(_aframe_id[aframe_id])];
		}

		public function GetAnimRect(animRect:Rectangle, aframe_id:int, transform:int = 0):void
		{
			var afRect:Rectangle = GetAFrameRect(aframe_id);
			
			animRect.x = afRect.x;
			animRect.y = afRect.y;
			animRect.width = afRect.width;
			animRect.height = afRect.height;
			
			var ox:int = _aframe_x[aframe_id];
			var oy:int = _aframe_y[aframe_id];
			
			if ((transform & _FLIP_H) != 0)
			{
				animRect.x = -(animRect.x + animRect.width);
				ox = -ox;
			}
			
			if ((transform & _FLIP_V) != 0)
			{
				animRect.y = -(animRect.y + animRect.height);
				oy = -oy;		
			}
					
			animRect.x += ox;
			animRect.y += oy;
		}
		
		public function GetFrameBitmapData(frame_id:int):BitmapData
		{
			var module:int = _fmodule_id[int(_frame_offset[frame_id])];						
			return _module_bitmap_data[module];
		}

		public function GetAFrameBitmapData(aframe_id:int):BitmapData
		{
			var module:int = _fmodule_id[int(_frame_offset[int(_aframe_id[aframe_id])])];						
			return _module_bitmap_data[module];
		}
		
		public function GetVirtualMatrix(x:int, y:int, marker_index:int = 0, scale:Number = 1):Matrix
		{
			var fmodule_max:int = 0;
		
			var aframe_id:int = _aframe_id[_current_aframes];
			var af_ox:int = _aframe_x[_current_aframes];
			var af_oy:int = _aframe_y[_current_aframes];				
			
			if (aframe_id < (_num_frames - 1))
			{
				fmodule_max = _frame_offset[int(aframe_id + 1)] - 1;
			}
			else if (aframe_id == (_num_frames - 1))
			{			
				fmodule_max = _num_fmodules - 1;
			}
			
			var i:int = fmodule_max - marker_index;
			
			if (i >= 2) //@Chao cheat
			{
				if (_is_free_transform)
				{
					return new Matrix(_fmodule_m11[i], _fmodule_m12[i], _fmodule_m21[i], _fmodule_m22[i], x + (_fmodule_fx[i] + af_ox)*scale, y + (_fmodule_fy[i] + af_oy) * scale);
				}
				else
				{
					return new Matrix(1, 0, 0, 1, x + (_fmodule_x[i] + af_ox) * scale, y + (_fmodule_y[i] + af_oy) * scale);
				}
			}
			
			return null;				
		}	
		
		public function SetColorTransform(	redMultiplier:Number = 1.0, 
											greenMultiplier:Number = 1.0, 
											blueMultiplier:Number = 1.0, 
											alphaMultiplier:Number = 1.0):void
		{
			_use_color_transform = true;
			
			if (_color_transform == null)
			{
				_color_transform = new ColorTransform(redMultiplier, greenMultiplier, blueMultiplier, alphaMultiplier);
			}
			else
			{
				_color_transform.redMultiplier = redMultiplier;
				_color_transform.redOffset = 0;
				_color_transform.greenMultiplier = greenMultiplier;
				_color_transform.greenOffset = 0;
				_color_transform.blueMultiplier = blueMultiplier;
				_color_transform.blueOffset = 0;
				_color_transform.alphaMultiplier = alphaMultiplier;
				_color_transform.alphaOffset = 0;
			}
		}
		
		public function ClearColorTransform():void
		{
			_use_color_transform = false;
			_color_transform = null;
		}
		
		public function SetAlpha(alphaMultiplier:Number = 1.0, alphaOffset:Number = 0):void
		{
			_use_color_transform = true;
			
			if (_color_transform == null)
			{
				_color_transform = new ColorTransform();
				_color_transform.alphaMultiplier = alphaMultiplier;
				_color_transform.alphaOffset = alphaOffset;
			}
			else
			{
				_color_transform.alphaMultiplier = alphaMultiplier;
				_color_transform.alphaOffset = alphaOffset;
			}
		}
		
		public function ClearAlpha():void
		{
			_use_color_transform = false;
			_color_transform = new ColorTransform();
		}
		
		public function SetBlendMode(mode:String):void
		{
			_blend_mode = mode;
		}
		
		public function ClearBlendMode():void
		{
			_blend_mode = null;
		}

		private function GetBlendMode(mode_code:int):String
		{
			switch (mode_code)
			{
				case 0:
					return null;
				case 1:
					return BlendMode.ADD;
				case 2:
					return BlendMode.ALPHA;
				case 3:
					return BlendMode.DARKEN;
				case 4:
					return BlendMode.DIFFERENCE;
				case 5:
					return BlendMode.ERASE;
				case 6:
					return BlendMode.HARDLIGHT;
				case 7:
					return BlendMode.INVERT;
				case 8:
					return BlendMode.LAYER;
				case 9:
					return BlendMode.LIGHTEN;
				case 10:
					return BlendMode.MULTIPLY;
				case 11:
					return BlendMode.OVERLAY;
				case 12:
					return BlendMode.SCREEN;
				case 13:
					return BlendMode.SHADER;
				case 14:
					return BlendMode.SUBTRACT;
			}
			
			return null;
		}
		
		
		
		
	}
}