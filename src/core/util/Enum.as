package core.util
{
	import flash.utils.Dictionary;
	import flash.utils.describeType;

	public class Enum
	{
		private static const cache:Dictionary = new Dictionary();
		
		public var ID:int;
		public var name:String;
		public var constName:String;
		
		public function Enum(ID:int, name:String = "")
		{
			this.ID = ID;
			this.name = name;
		}
		
		public static function getEnum(enumClass:Class, ID:int):Enum
		{
			var enumList:Array = getAll(enumClass);
			var enum:Enum = null;
			if(enumList != null) enum = enumList[ID];
			return enum;
		}
		
		public static function getEnumIndexByID(enumClass:Class, ID:int):int
		{
			var enumList:Array = getAll(enumClass);
			if (enumList != null)
			{
				var index:int = 0;
				for each(var enum:Enum in enumList)
				{
					if (enum.ID == ID)
					{
						return index;
					}
					index++;
				}
			}
			
			return -1;
		}
		
		public static function getAll(enumClass:Class):Array
		{
			var enumList:Array = cache[enumClass];
			if(enumList == null)
			{
				enumList = [];
				var xmlType:XML = describeType(enumClass);
				var enumXMLList:XMLList = xmlType.constant;
				var enumObject:Enum = null;
				for each(var enumXML:XML in enumXMLList)
				{
					enumObject = enumClass[enumXML.@name];
					enumObject.constName = enumXML.@name;
					if(enumObject != null)	enumList[enumObject.ID] = enumObject;
				}
				cache[enumClass] = enumList;
			}
			
			return enumList;
		}
			
		public static function getString(enumClass:Class, id:int):String
		{
			var enumList:Array = cache[enumClass];
			if(enumList == null)
			{
				enumList = [];
				var xmlType:XML = describeType(enumClass);
				var enumXMLList:XMLList = xmlType.constant;
				for each(var enumXML:XML in enumXMLList)
				{
					enumList[enumClass[enumXML.@name].toString()] = enumXML.@name.toString();
				}
				cache[enumClass] = enumList;
			}
			
			return enumList[id];
		}
	}
}