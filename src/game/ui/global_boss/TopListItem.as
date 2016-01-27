package game.ui.global_boss 
{
	import core.util.FontUtil;
	import flash.display.MovieClip;
	import flash.text.TextField;
	import game.enum.Font;
	
	/**
	 * ...
	 * @author MaiPTT
	 */
	public class TopListItem extends MovieClip 
	{
		public var txtNum		:TextField;
		public var txtName		:TextField;
		public var txtPoint		:TextField;
		public var id			:int;
		
		public function TopListItem() {
			FontUtil.setFont(txtNum, Font.ARIAL, true);
			FontUtil.setFont(txtName, Font.ARIAL);
			FontUtil.setFont(txtPoint, Font.ARIAL);
		}
		
		public function setNum(value:int):void {
			txtNum.text = value.toString();
		}
		
		public function setName(value:String):void {
			txtName.text = value;
		}
		
		public function setPoint(value:int):void {
			txtPoint.text = value.toString();
		}
		
		public function setXY(x:int, y:int):void {
			this.x = x;
			this.y = y;
		}
		
		public function reset():void {
			txtNum.text = "";
			txtName.text = "";
			txtPoint.text = "";
		}
	}

}