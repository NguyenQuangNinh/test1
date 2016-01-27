/**
 * Created by NinhNQ on 11/26/2014.
 */
package game.ui.tutorial
{

	import core.util.FontUtil;
	import core.util.Utility;

	import flash.display.DisplayObject;

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;

	import game.Game;

	import game.enum.Direction;

	import game.enum.Font;

	import game.utility.UtilityUI;

	public class Hint
	{
		private var arrowInstruction:MovieClip;
		private var target:DisplayObject;

		public function Hint()
		{
		}

		public function init():void
		{
			arrowInstruction = UtilityUI.getComponent(UtilityUI.HINT_ARROW) as MovieClip;
			arrowInstruction.gotoAndStop(3);

			arrowInstruction.mouseChildren = false;
			arrowInstruction.mouseEnabled = false;
			Game.stage.addChild(arrowInstruction);
			Game.stage.addEventListener(Event.ENTER_FRAME, checkVisible);
		}

		private function checkVisible(event:Event):void
		{
			arrowInstruction.visible = target && target.stage && target.visible && (target.alpha != 0)
										&& target.parent && target.parent.visible && (target.parent.alpha != 0);
		}

		private function setContent(value:String):void
		{
			TextField(arrowInstruction.txtInfo).wordWrap = true;
			TextField(arrowInstruction.txtInfo).autoSize = TextFieldAutoSize.LEFT;
			arrowInstruction.txtInfo.text = value;
			FontUtil.setFont(arrowInstruction.txtInfo, Font.ARIAL);
		}

		public function showHint(target:DisplayObject, direction:Direction, x:Number = 0, y:Number = 0, content:String = ""):void
		{
			if(target && target.parent)
			{
				Utility.log("Hint >>> show hint > " + target);
				var point:Point = target.parent.localToGlobal(new Point(x, y));

				this.target = target;

				switch (direction)
				{
					case Direction.LEFT:
						arrowInstruction.gotoAndStop(1);
						break;
					case Direction.RIGHT:
						arrowInstruction.gotoAndStop(2);
						break;
					case Direction.UP:
						arrowInstruction.gotoAndStop(4);
						break;
					case Direction.DOWN:
						arrowInstruction.gotoAndStop(3);
						break;
				}

				arrowInstruction.x = point.x;
				arrowInstruction.y = point.y;

				setContent(content);
			}
		}

		public function hideHint():void
		{
			Utility.log("Hint >>> hide");
			target = null;
		}

		public function get currTarget():DisplayObject
		{
			return target;
		}
	}
}
