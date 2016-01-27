/**
 * RichTextField
 * @author Alex.li - www.riaidea.com
 * @homepage http://code.google.com/p/richtextfield/
 */

package com.riaidea.text
{
	import com.riaidea.text.plugins.IRTFPlugin;
	import core.util.Utility;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.GlowFilter;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextLineMetrics;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	
	
	/**
	 * <p> RichTextField is a TextField-based graphic mixed components. </ p>
	 * <p> Known, TextField can use html way to insert a picture, but can not effectively control the location of the picture and can not be real-time editing. RichTextField to meet this demand. </ p>
	 * <p> RichTextField has the following features:
	 * <br> <ul>
	 * <li> Append text in a text and display elements. </ li>
	 * <li> Anywhere in the text replacement (delete) text and display elements. </ li>
	 * <li> Supports HTML text and display elements of the shuffle. </ li>
	 * <li> RichTextField can dynamically set the size. </ li>
	 * <li> Can import and export XML formatted text box contents. </ li>
	 * </ Ul> </ p>
	 * 
	 * 
	 * @example The following example demonstrates the basics of using RichTextField
	 * <listing>
		var rtf:RichTextField = new RichTextField();			
		rtf.x = 10;
		rtf.y = 10;
		addChild(rtf);

		//Set the size of rtf
		rtf.setSize(500, 400);
		//Set the type rtf
		rtf.type = RichTextField.INPUT;
		//Set the default text format rtf
		rtf.defaultTextFormat = new TextFormat("Arial", 12, 0x000000);

		//Append text and display elements to rtf in
		rtf.append("Hello, World!", [ { index:5, src:SpriteClassA }, { index:13, src:SpriteClassB } ]);
		//Replace the contents of the specified location for the new text and display elements
		rtf.replace(8, 13, "世界", [ { src:SpriteClassC } ]);</listing>
	 * 
	 * 
	 * @example Here is an XML content RichTextField example, you can use importXML () to import XML content with this format, or exportXML () exported XML content so easy to save and transfer:
	 * <listing>
		&lt;rtf&gt;
		  &lt;text&gt;Hello, World!&lt;/text&gt;
		  &lt;sprites&gt;
				&lt;sprite src="SpriteClassA" index="5"/&gt;
				&lt;sprite src="SpriteClassB" index="13"/&gt;
		  &lt;/sprites&gt;
		&lt;/rtf&gt;</listing>
	 */
	public class RichTextField extends Sprite
	{
		private var _width:Number;
		private var _height:Number;
		private var _textRenderer:TextRenderer;		
		private var _spriteRenderer:SpriteRenderer;	
		private var _formatCalculator:TextField;
		private var _plugins:Array;
		
		private var _placeholder:String;
		private var _placeholderColor:uint;
		private var _placeholderMarginH:int;	
		private var _placeholderMarginV:int;
		
		private var _maxLine:int;
		
		/**
		 * A Boolean value that indicates whether the text field to insert text in HTML format.
		 * @default false
		 */
		public var html:Boolean;
		/**
		 * Display elements indicating the text field row height (maximum height).
		 * @default 0
		 */
		public var lineHeight:int;
		/**
		 * A Boolean value that indicates when the additional content to RichTextField whether to automatically scroll to the bottom after.
		 * @default true
		 */
		public var autoScroll:Boolean;		
		/**
		 * Used to specify the dynamic type of RichTextField.
		 */
		public static const DYNAMIC:String = "dynamic";
		/**
		 * Used to specify the type of input RichTextField.
		 */
		public static const INPUT:String = "input";		
		/**
		 * RichTextField version number.
		 */
		public static const version:String = "2.0.2";
		
		public function setSelectEnable(value:Boolean):void
		{
			_textRenderer.selectable = value;
		}
		
		public function getTextRenderer(): TextRenderer
		{
			return _textRenderer;
		}
		
		
		/**
		 * Constructor.
		 */
		public function RichTextField()
		{
			//text renderer
			_textRenderer = new TextRenderer();
			_textRenderer.filters = [new GlowFilter(0x000000, 1, 2, 2, 10, 2)];
			addChild(_textRenderer);
			
			//sprite renderer
			_spriteRenderer = new SpriteRenderer(this);
			addChild(_spriteRenderer.container);
						
			//default settings
			setSize(100, 100);
			type = DYNAMIC;
			lineHeight = 0;
			html = false;
			autoScroll = false;
			
			//default placeholder
			_placeholder = String.fromCharCode(12288);
			_placeholderColor = 0x000000;
			_placeholderMarginH = 1;
			_placeholderMarginV = 0;
			
			//an invisible textfield for calculating placeholder's textFormat
			_formatCalculator = new TextField();			
			_formatCalculator.text = _placeholder;
			
			//make sure that can't input placeholder
			_textRenderer.restrict = "^" + _placeholder;
			
			_maxLine = -1;
		}
		
		public function setMaxLine(value:int):void
		{
			_maxLine = value;
		}
		
		/**
		 * newText parameter specifies the text and newSprites parameter specifies the display element to the end of the text field.
		 * @param	newText To append a new text。
		 * @param	newSprites To append an array of display elements, each element contains two attributes src and index, such as: {src: sprite, index: 1}.
		 * @param	autoWordWrap Indicates whether the wrap.
		 * @param	format Applied to append new text format.
		 */
		public function append(newText:String, newSprites:Array = null, autoWordWrap:Boolean = false, format:TextFormat = null):void
		{			
			//append text
			var scrollV:int = _textRenderer.scrollV;
			var oldLength:int = _textRenderer.length;
			var textLength:int = 0;
			
			if (!newText) newText = "";
			if (newText || autoWordWrap)
			{
				if(newText) newText = newText.split("\r").join("\n");
				//plus a newline(\n) only if append as normal text 
				if (autoWordWrap && !html) newText += "\n";
				_textRenderer.recoverDefaultFormat();
				if (html)
				{
					//make sure the new text have the default text format
					_textRenderer.htmlText += "<p>" + newText + "</p>";				
				}else
				{
					_textRenderer.appendText(newText);
					if (format == null) format = _textRenderer.defaultTextFormat;
					_textRenderer.setTextFormat(format, oldLength, _textRenderer.length);
				}
				//record text length added
				if (html || (autoWordWrap && !html)) textLength = _textRenderer.length - oldLength - 1;
				else textLength = _textRenderer.length - oldLength;
			}			
			
			//append sprites
			var newline:Boolean = html;// && (oldLength != 0);
			insertSprites(newSprites, oldLength, oldLength + textLength, newline);
			
			//if doesn't scroll but have sprites to render, do it
			if (newSprites != null) _spriteRenderer.render();
			_textRenderer.htmlText
			//Utility.log("" + _textRenderer.htmlText.);
			//Utility.log("" + _textRenderer.getLineLength(0));
			
			if (_maxLine > -1 && _textRenderer.numLines > _maxLine)
			{
				var offset:int  = _textRenderer.getLineLength(0);
				for (var i:int = 0; i < offset; i++)
				{
					_spriteRenderer.removeSprite(i);
				}
				_spriteRenderer.adjustSpritesIndex( - offset, -offset);
				
				//var htmlText:Array = _textRenderer.htmlText.split('</P>');
				var temp:String = _textRenderer.htmlText;
				_textRenderer.htmlText = temp.slice(temp.indexOf("</P>"));
				
				//_textRenderer.htmlText = "";
				//for (i = 1; i < htmlText.length; i++)
				//{
					//_textRenderer.htmlText += htmlText[i] + '</P>';
				//}
			}
			
			//auto scroll			
			if (autoScroll && _textRenderer.scrollV != _textRenderer.maxScrollV) 
			{
				_textRenderer.scrollV = _textRenderer.maxScrollV;
			}else if(!autoScroll && _textRenderer.scrollV != scrollV)
			{
				_textRenderer.scrollV = scrollV;
			}
		}
		
		/**
		 * Using newText and replace the contents newSprites parameters startIndex and endIndex parameters specify the position of the content.
		 * @param	startIndex To replace from the starting position.
		 * @param	endIndex replace to end position.
		 * @param	newText text to replace
		 * @param	newSprites To replace the display element array, each element contains two attributes src and index, such as: {src: sprite, index: 1}.
		 */
		public function replace(startIndex:int, endIndex:int, newText:String, newSprites:Array = null):void
		{
			//replace text			
			var oldLength:int = _textRenderer.length;
			var textLength:int = 0;
			if (endIndex > oldLength) endIndex = oldLength;
			newText = newText.split(_placeholder).join("");
			_textRenderer.replaceText(startIndex, endIndex, newText);
			textLength = _textRenderer.length - oldLength + (endIndex - startIndex);
			
			if (textLength > 0)
			{
				_textRenderer.setTextFormat(_textRenderer.defaultTextFormat, startIndex, startIndex + textLength);
			}
			
			//remove sprites which be replaced
			for (var i:int = startIndex; i < endIndex; i++)
			{
				_spriteRenderer.removeSprite(i);
			}
			
			//adjust sprites after startIndex
			var adjusted:Boolean = _spriteRenderer.adjustSpritesIndex(startIndex - 1, _textRenderer.length - oldLength);
			
			//insert sprites
			insertSprites(newSprites, startIndex, startIndex + textLength);
			
			//if adjusted or have sprites inserted, do render
			if (adjusted || (newSprites && newSprites.length > 0)) _spriteRenderer.render();
		}
		
		/**
		 * From the parameters startIndex specifies the index position, insert the number specified by the parameter newSprites display elements.
		 * @param	newSprites To insert an array of display elements, each element contains two attributes src and index, such as: {src: sprite, index: 1}.
		 * @param	startIndex starting position of display elements.
		 * @param	maxIndex element's maximum index.	
		 * @param	newline whether the text contains the new line.
		 */
		private function insertSprites(newSprites:Array, startIndex:int, maxIndex:int, newline:Boolean = false):void
		{
			if (newSprites == null) return;
			newSprites.sortOn("index", Array.NUMERIC);
			
			for (var i:int = 0; i < newSprites.length; i++)
			{
				var obj:Object = newSprites[i];
				var sprite:Object = obj.src;
				var index:int = obj.index;
				if (obj.index == undefined || index < 0 || index > maxIndex - startIndex) 
				{
					obj.index = maxIndex - startIndex;
					newSprites.splice(i, 1);
					newSprites.push(obj);
					i--;
					continue;
				}
				
				if (newline && index > 0 && index <= maxIndex - startIndex) index += startIndex + i;// - 1;
				else index += startIndex + i;		
				insertSprite(sprite, index, false, obj.cache);
			}
		}
		
		/**
		 * In the parameter index specifies the index position (zero-based) Insert the newSprite parameter specifies the display element.
		 * @param	newSprite To insert a display element.It contains two attributes Src and index, such as: {src: sprite, index: 1}.
		 * @param	index Position of the display element
		 * @param	autoRender Indicates whether the inserted automatically render display elements.
		 * @param	cache Indicates whether the display element using the cache.
		 */
		public function insertSprite(newSprite:Object, index:int = -1, autoRender:Boolean = true, cache:Boolean = false):void
		{
			//create a instance of sprite
			var spriteObj:DisplayObject = getSpriteFromObject(newSprite);
			if (spriteObj == null) throw Error("Specific sprite:" + newSprite + " is not a valid display object!");
			
			if (cache) spriteObj.cacheAsBitmap = true;
			//resize spriteObj if lineHeight is specified
			if (lineHeight > 0 && spriteObj.height > lineHeight)
			{
				var scaleRate:Number = lineHeight / spriteObj.height;
				spriteObj.height = lineHeight;
				spriteObj.width = spriteObj.width * scaleRate;
			}
			
			//verify the index to insert
			if (index < 0 || index > _textRenderer.length) index = _textRenderer.length;			
			//insert a placeholder into textfield by using replaceText method
			_textRenderer.replaceText(index, index, _placeholder);			
			//calculate a special textFormat for spriteObj's placeholder
			var format:TextFormat = calcPlaceholderFormat(spriteObj.width, spriteObj.height);
			//apply the textFormat to placeholder to make it as same size as the spriteObj
			_textRenderer.setTextFormat(format, index, index + 1);	
			
			//adjust sprites index which come after this sprite
			_spriteRenderer.adjustSpritesIndex(index, 1);
			//insert spriteObj to specific index and render it if it's visible
			_spriteRenderer.insertSprite(spriteObj, index);
			
			//if autoRender, just do it
			if (autoRender) _spriteRenderer.render();
		}
		
		private function getSpriteFromObject(obj:Object):DisplayObject
		{
			if (obj is String) 
			{
				var clazz:Class = getDefinitionByName(String(obj)) as Class;
				return new clazz() as DisplayObject;				
			}else if (obj is Class)
			{
				return new obj() as DisplayObject;
			}else 
			{
				return obj as DisplayObject;
			}
		}
		
		/**
		 * Calculations show that the element's placeholder text format (if using a different placeholder, you can override this method).
		 * @param	width width
		 * @param	height height
		 * @return
		 */
		private function calcPlaceholderFormat(width:Number, height:Number):TextFormat
		{
			var format:TextFormat = new TextFormat();
			format.color = _placeholderColor;
			format.size = height + 2 * _placeholderMarginV;		
			
			//calculate placeholder text metrics with certain size to get actual letterSpacing
			_formatCalculator.setTextFormat(format);
			var metrics:TextLineMetrics = _formatCalculator.getLineMetrics(0);
			
			//letterSpacing is the key value for placeholder
			format.letterSpacing = width - metrics.width + 2 * _placeholderMarginH;
			format.underline = format.italic = format.bold = false;
			return format;
		}
		
		/**
		 * Set the size RichTextField (length and width).
		 * @param	width width
		 * @param	height height
		 */
		public function setSize(width:Number, height:Number):void
		{
			if (_width == width && _height == height) return;
			_width = width;
			_height = height;
			_textRenderer.width = _width;
			_textRenderer.height = _height;
			this.scrollRect = new Rectangle(0, 0, _width, _height);
			_spriteRenderer.render();
		}
		
		/**
		 * Index parameter indicating whether the specified index location for the display element.
		 * @param	index The specified index position.
		 * @return
		 */
		public function isSpriteAt(index:int):Boolean
		{
			if (index < 0 || index >= _textRenderer.length) return false;
			return _textRenderer.text.charAt(index) == _placeholder;
		}
		
		private function scrollHandler(e:Event):void 
		{
			_spriteRenderer.render();
		}
		
		private function changeHandler(e:Event):void 
		{
			var index:int = _textRenderer.caretIndex;
			var offset:int = _textRenderer.length - _textRenderer.oldLength;
			if (offset > 0)
			{
				_spriteRenderer.adjustSpritesIndex(index - 1, offset);
			}else
			{
				//remove sprites
				for (var i:int = index; i < index - offset; i++)
				{
					_spriteRenderer.removeSprite(i);
				}
				_spriteRenderer.adjustSpritesIndex(index + offset, offset);
			}
			_spriteRenderer.render();
		}
		
		/**
		 * Clear all text and display elements.
		 */
		public function clear():void
		{
			_spriteRenderer.clear();
			_textRenderer.clear();
		}
		
		/**
		 * Indicates RichTextField type.
		 * @default RichTextField.DYNAMIC
		 */
		public function get type():String 
		{ 
			return _textRenderer.type;
		}
		
		public function set type(value:String):void 
		{
			_textRenderer.type = value;
			_textRenderer.addEventListener(Event.SCROLL, scrollHandler);
			if (value == INPUT)
			{
				_textRenderer.addEventListener(Event.CHANGE, changeHandler);
			}
		}
		
		/**
		 * TextField instance.
		 */
		public function get textfield():TextField 
		{ 
			return _textRenderer;
		}
		
		/**
		 * Indicates the level of display elements placeholder margins.
		 * @default 1
		 */
		public function set placeholderMarginH(value:int):void 
		{
			_placeholderMarginH = value;
		}
		
		/**
		 * 指示显示元素占位符的垂直边距。
		 * @default 0
		 */
		public function set placeholderMarginV(value:int):void 
		{
			_placeholderMarginV = value;
		}
		
		/**
		 * Display elements placeholder indicating vertical margin.
		 */
		public function get viewWidth():Number
		{
			return _width;
		}
		
		/**
		 * RichTextField object visible height.
		 */
		public function get viewHeight():Number
		{
			return _height
		}
		
		/**
		 * the contents of the text field (including the display element placeholder).
		 */
		public function get content():String
		{
			return _textRenderer.text;
		}
		
		/**
		 * the contents of the text field length (including the display element placeholder).
		 */
		public function get contentLength():int
		{
			return _textRenderer.length;
		}
		
		/**
		 * text in a text field (not including display elements placeholder).
		 */
		public function get text():String
		{
			return _textRenderer.text.split(_placeholder).join("");
		}
		
		/**
		 * text in a text field length (not including display elements placeholder).
		 */
		public function get textLength():int
		{
			return _textRenderer.length - _spriteRenderer.numSprites;
		}
		
		/**
		 *  the index specified by the index parameter location of display elements.
		 * @param	index
		 * @return
		 */
		public function getSprite(index:int):DisplayObject
		{
			return _spriteRenderer.getSprite(index);
		}
		
		/**
		 * Return RichTextField in the number of display elements.
		 */
		public function get numSprites():int
		{
			return _spriteRenderer.numSprites;
		}
		
		/**
		 * Specify the location of the mouse pointer.
		 */
		public function get caretIndex():int
		{
			return _textRenderer.caretIndex;
		}		
		
		public function set caretIndex(index:int):void
		{
			_textRenderer.setSelection(index, index);
		}
		
		/**
		 * Specify a text field's default text format.
		 */
		public function get defaultTextFormat():TextFormat
		{
			return _textRenderer.defaultTextFormat;
		}		
		
		public function set defaultTextFormat(format:TextFormat):void
		{
			if (format.color != null) _placeholderColor = uint(format.color);
			_textRenderer.defaultTextFormat = format;
		}
		
		/**
		 * Exported in XML format RichTextField text and display element content.
		 * @return
		 */
		public function exportXML():XML
		{
			var xml:XML =<rtf/>;
			if (html) 
			{
				xml.htmlText = _textRenderer.htmlText.split(_placeholder).join("");
			}else
			{
				xml.text = _textRenderer.text.split(_placeholder).join("");
			}
			
			xml.sprites = _spriteRenderer.exportXML();
			return xml;
		}
		
		/**
		 * Imports the specified XML formatted text and display element content.
		 * @param	data XML content with the specified format.
		 */
		public function importXML(data:XML):void
		{
			//
			var content:String = "";		
			if (data.hasOwnProperty("htmlText")) content += data.htmlText;
			if (data.hasOwnProperty("text")) content += data.text;						
			
			var sprites:Array = [];
			for (var i:int = 0; i < data.sprites.sprite.length(); i++)
			{
				var node:XML = data.sprites.sprite[i];
				var sprite:Object = { };
				sprite.src = String(node.@src);
				//correct the index if import as html
				if (html) sprite.index = int(node.@index);// + 1;
				else sprite.index = int(node.@index);
				sprites.push(sprite);
			}	
			
			append(content, sprites);
		}
		
		/**
		 * To increase RichTextField plug.
		 * @param	plugin To add plug-ins.
		 */
		public function addPlugin(plugin:IRTFPlugin):void
		{			
			plugin.setup(this);
			if (_plugins == null) _plugins = [];	
			_plugins.push(plugin);
		}
	}	
}