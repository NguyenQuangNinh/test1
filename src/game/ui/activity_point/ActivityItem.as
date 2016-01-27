package game.ui.activity_point {
	import core.util.FontUtil;
	import flash.display.MovieClip;
	import flash.text.TextField;
	import game.enum.Font;
	/**
	 * ...
	 * @author vu anh
	 */
	public class ActivityItem extends MovieClip
	{
		
		public var taskTf:TextField;
		public var actionPointTf:TextField;
		public var limitTimeTf:TextField;
		
		public function ActivityItem() 
		{
			
			FontUtil.setFont(taskTf, Font.ARIAL, true);
			FontUtil.setFont(actionPointTf, Font.ARIAL, true);
			FontUtil.setFont(limitTimeTf, Font.ARIAL, true);
			
			taskTf.mouseEnabled = false;
			actionPointTf.mouseEnabled = false;
			limitTimeTf.mouseEnabled = false;
		}
		
		public function reset():void
		{
			taskTf.text = "";
			actionPointTf.text = "";
			limitTimeTf.text = "";
		}
		
		public function update(info:ActivityItemInfo):void
		{
			taskTf.text = info.taskName;
			actionPointTf.text = info.receivePoint.toString();
			limitTimeTf.text = info.usedTime + " / " + info.maxTime;
		}
	}

}