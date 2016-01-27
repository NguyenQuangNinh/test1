package game.ui.consume_event.gui
{
	import core.util.MovieClipUtils;
	import flash.display.MovieClip;
	import game.net.lobby.response.ResponseGetConsumeEventInfo;
	import game.ui.components.HorScroll;
	
	/**
	 * ...
	 * @author chuongth2
	 */
	public class ConsumeEventContainer extends MovieClip
	{
		
		public var maskMovie:MovieClip;
		public var scrollbar:MovieClip;
		
		private var contentMovie:MovieClip = new MovieClip();
		private var _hScroll:HorScroll;
		
		public function ConsumeEventContainer()
		{
			_hScroll = new HorScroll(maskMovie, contentMovie, scrollbar);
			_hScroll.x = scrollbar.x;
			_hScroll.y = scrollbar.y;
			this.addChild(_hScroll);
			
			contentMovie.x = maskMovie.x;
			contentMovie.y = maskMovie.y;
			this.addChild(contentMovie);
		}
		
		public function update(strBeign:String, responseGetConsumeEventInfo:ResponseGetConsumeEventInfo):void
		{
			if (responseGetConsumeEventInfo)
			{
				MovieClipUtils.removeAllChildren(contentMovie);
				for (var i:int = 0; i < responseGetConsumeEventInfo.totalDay && i < responseGetConsumeEventInfo.arrReward.length; i++)
				{
					var eventItem:ConsumeEventItem = new ConsumeEventItem();
					eventItem.x = 10 + i * 105;
					eventItem.y = 8;
					eventItem.init(i, responseGetConsumeEventInfo.arrReward[i], strBeign);
					contentMovie.addChild(eventItem);
				}
				_hScroll.updateScroll(contentMovie.width + 20);
			}
		}
	
	}
}