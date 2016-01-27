package core.memory 
{
	import flash.events.EventDispatcher;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;

	/**
	 * ...
	 * @author bangnd2
	 */
	public class MemoryPool 
	{
		private var pools:Dictionary = new Dictionary();
		
		public function pop(objectClass:Class):Object
		{
			var pool:Vector.<Object> = pools[objectClass];
			var object:Object = null;
			if (pool == null || pool.length == 0)
			{
				object = new objectClass();
			}
			else
			{
				object = pool.pop();
			}
			
			return object;
		}
		
		public function push(object:Object, objectClass:Class = null):void
		{
			if (object == null) return;
			if(objectClass == null)
			{
				var className:String = getQualifiedClassName(object);
				objectClass = getDefinitionByName(className) as Class;
			}
			
			if (objectClass != null)
			{
				var pool:Vector.<Object> = pools[objectClass];
				if (pool == null)
				{
					pool = new Vector.<Object>();
					pools[objectClass] = pool;
				}
				if (pool.indexOf(object) > -1) 
				{
					trace("ERROR: try to push object multiple times");
				}
				pool.push(object);
			}
		}
		
		public function reserve(objectClass:Class, numObjects:int):void
		{
			var pool:Array = pools[objectClass];
			if (pool == null)
			{
				pool = new Array();
				pools[objectClass] = pool;
			}
			for (var i:int = 0; i < numObjects; ++i)
			{
				pool.push(new objectClass());
			}
		}
	}
}