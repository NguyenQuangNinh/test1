package core.display 
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * ...
	 * @author bangnd2
	 */
	public class DynamicMovie extends MovieClip 
	{
		public static const LOADED:String = "loaded";
		
		private var _className:String = "";
		private var _content:DisplayObject;
		private var _isLoaded:Boolean = false;
		private var _cloneRefs:Array = [];
		
		public function DynamicMovie(pContent:DisplayObject = null):void
		{
			setContent(pContent);
		}
		
		public function setContent(pContent:DisplayObject):void
		{
			if (pContent)
			{
				_content = pContent;
				_className = getQualifiedClassName(_content);
				addChild(_content);
				_isLoaded = true;
				dispatchEvent(new Event(LOADED, true));
				for each(var movie:DynamicMovie in _cloneRefs)
				{
					if (movie) movie.setContent(pContent);
				}
			}
		}
		
		public function clone():DynamicMovie
		{
			var movie:DynamicMovie = new DynamicMovie();
			if (_isLoaded)
			{
				var contentClass:Class = getDefinitionByName(_className) as Class;
				movie.setContent(new contentClass());
			}
			_cloneRefs.push(movie);
			return movie;
		}
		
		public function get isLoaded():Boolean { return _isLoaded; }
		
		public function destroy():void
		{
			for each(var movie:DynamicMovie in _cloneRefs)
			{
				if (movie) movie.destroy();
			}
			_cloneRefs = [];
			while (numChildren > 0)
			{
				removeChildren(0);
			}
			_content = null;
			_isLoaded = false;
		}
	}
}