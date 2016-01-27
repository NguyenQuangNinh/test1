package game.ui.create_character
{
	import flash.display.GraphicsPathCommand;
	import flash.display.MovieClip;
	import flash.filters.GlowFilter;
	
	import game.Game;
	import game.data.xml.DataType;
	import game.data.xml.ElementData;
	import game.enum.Element;
	
	public class ThanhNT7 extends MovieClip
	{
		private var axes:Array;
		private var saveElement:Element;
		private var arrDrawValue:Array;
		private var arrCurrentValue:Array;
		private static var nScaleDelta:int = 2;
		
		public function ThanhNT7()
		{
			axes = [];
			var degree:int = 72;
			var beginDegree:Number = -90;
			var axis:Axis;
			
			for(var i:int = 0; i < 5; ++i)
			{
				axis = new Axis();
				axis.rotation = beginDegree + i * degree;
				addChild(axis);
				axes.push(axis);
			}
			
			filters = [new GlowFilter(0x0099ff, 1, 10, 10, 2, 10)];
			arrDrawValue = [0, 0, 0, 0, 0];
			arrCurrentValue = [0, 0, 0, 0, 0];
		}
		
		
		
		public function setElement(element:Element):void
		{
			saveElement = element;
			var xmlData:ElementData = Game.database.gamedata.getData(DataType.ELEMENT, element.ID) as ElementData;
			if(xmlData != null)
			{
				var axis:Axis;
				var commands:Vector.<int> = new Vector.<int>();
				var data:Vector.<Number> = new Vector.<Number>();
				for(var i:int = 0; i < 5; ++i)
				{
					axis = axes[i];
					axis.setValue(xmlData.attributeBalance[i]);
					arrCurrentValue[i] = xmlData.attributeBalance[i];
					commands.push(i == 0 ? GraphicsPathCommand.MOVE_TO : GraphicsPathCommand.LINE_TO);
					data.push(axis.getPoint().x);
					data.push(axis.getPoint().y);
				}
				//graphics.clear();
				//graphics.beginFill(0xffffff);
				//graphics.drawPath(commands, data);
			}
		}
		
		public function update():void {
			//Scale vi tri cac Axis
			for(var j:int = 0; j < 5; j++)
			{
				if (j < arrDrawValue.length 
					&& j < arrCurrentValue.length)
				{
					if (Math.abs(arrDrawValue[j] - arrCurrentValue[j]) > nScaleDelta)
					{
						if (arrDrawValue[j] < arrCurrentValue[j])
						{
							arrDrawValue[j] += nScaleDelta;
						}
						if (arrDrawValue[j] > arrCurrentValue[j])
						{
							arrDrawValue[j] -= nScaleDelta;
						}
					}
					else
					{
						arrDrawValue[j] = arrCurrentValue[j];
					}
				}
			}
			
			//Bat dau ve
			var axis:Axis;
			var commands:Vector.<int> = new Vector.<int>();
			var data:Vector.<Number> = new Vector.<Number>();
			for(var i:int = 0; i < 5; ++i)
			{
				if (i < arrDrawValue.length)
				{
					axis = axes[i];
					axis.setValue(arrDrawValue[i]);
					commands.push(i == 0 ? GraphicsPathCommand.MOVE_TO : GraphicsPathCommand.LINE_TO);
					data.push(axis.getPoint().x);
					data.push(axis.getPoint().y);
				}
			}
			commands.push(GraphicsPathCommand.LINE_TO);
			data.push(axes[0].getPoint().x);
			data.push(axes[0].getPoint().y);
			
			
			graphics.clear();
			graphics.lineStyle(3, 0xffffff, 1);
			graphics.beginFill(0xffffff, 0.3);
			graphics.drawPath(commands, data);
			 
			/*var filtersArray:Array = new Array(glow);
			graphics.beginFill(0xffffff, 1.0);
			graphics.lineStyle(3, 0xffffff, 1);
			
			for(var k:int = 0; k < 5; ++k)
			{
				if (k < arrDrawValue.length)
				{
					axis = axes[k];
					if (k == 0)
					{
						graphics.moveTo(axis.getPoint().x, axis.getPoint().y);
					}
					else
					{
						graphics.lineTo(axis.getPoint().x, axis.getPoint().y);
						graphics.moveTo(axis.getPoint().x, axis.getPoint().y);
					}
					
					if ( k == 4)
					{
						axis = axes[0];
						graphics.lineTo(axis.getPoint().x, axis.getPoint().y);
					}
				}
			}*/
		}
	}
}