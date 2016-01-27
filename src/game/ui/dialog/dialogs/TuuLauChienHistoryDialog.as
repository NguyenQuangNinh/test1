package game.ui.dialog.dialogs 
{
	import components.scroll.VerScroll;
	import core.event.EventEx;
	import core.util.TextFieldUtil;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import game.data.vo.challenge.HistoryInfo;
	import game.enum.Font;
	/**
	 * ...
	 * @author ...
	 */
	public class TuuLauChienHistoryDialog extends Dialog
	{
		public var closeBtn: SimpleButton;
		public var historyContainer: MovieClip;
		
		public var maskMovie:MovieClip;
		public var contentMovie:MovieClip;
		public var scrollbar:MovieClip;
		public var vScroller:VerScroll;
		
		public static const ON_REQUEST_VIEW_HISTORY_RESOURCE_MATCH:String = "requestViewHistoryResourceMatch";
		
		private static const HISTORY_START_FROM_X:int = 0;
		private static const HISTORY_START_FROM_Y:int = 0;
		private static const HISTORY_DISTANCE_FROM_Y:int = 50;
		
		public function TuuLauChienHistoryDialog() 
		{
			initUI();		
			
			vScroller = new VerScroll(maskMovie, historyContainer, scrollbar);
			historyContainer.x = maskMovie.x;
			historyContainer.y = maskMovie.y;
			
			vScroller.updateScroll(historyContainer.height + 10);
		}
		
		private function initUI():void 
		{
			closeBtn.addEventListener(MouseEvent.CLICK, onCloseClickHdl)
		}
		
		private function onCloseClickHdl(e:MouseEvent):void 
		{
			this.close();			
		}
		
		override public function set data(value:Object):void 
		{			
			var historyArr:Array = value.data;
			if (historyArr)
			{				
				//remove all info before				
				while (historyContainer.numChildren > 0)
				{
					historyContainer.removeChildAt(0);
				}
					
				for (var i:int = 0; i < historyArr.length; i++)
				{
					/*1. Obama tiến hành cuớp tửu lâu của bạn thành công, bạn bị mất 12,000 bạc [chiến báo]
					2. Biladen tiến hành chiếm tửu lâu của bạn thất bại [chiến báo]*/
					
					var history:HistoryInfo = historyArr[i] as HistoryInfo
					var name:String = history.name;
					//var maxL:int = 12;
					//if (name.length > maxL) name = name.substr(0, maxL - 2) + "..";
					var attackInfo:String = "";
					attackInfo = " [ <font color='#006600'>" + name.toString() + "</font> ]" + (history.isWin 
									? " tiến hành " + (history.type == 1 ? "chiếm" : history.type == 3 ? "cướp" : "") + " tửu lâu của bạn <font color='#0000FF'>thành công</font>"
													+ (history.type == 3 ? ", bạn bị mất " + history.numResourceRob + " bạc" : (history.type == 1 ? ", bạn bị mất tửu lâu" : ""))
									: " tiến hành " + (history.type == 1 ? "chiếm" : history.type == 3 ? "cướp" : "") + " tửu lâu của bạn <font color='#FF0000'>thất bại</font> ")
								+ " [<a href='event:" + history.playerID.toString() + "'><font color='#FF6600'>"
								+ " xem chiếu báo " + "</font></a>]";
								
					var contentTf:TextField = TextFieldUtil.createTextfield(Font.ARIAL, 13, 360, 50, 0x333333, true);
					contentTf.mouseEnabled = true;
					contentTf.multiline = true;
					contentTf.wordWrap = true;
					contentTf.autoSize = TextFieldAutoSize.LEFT;
					contentTf.x = HISTORY_START_FROM_X;
					contentTf.y = HISTORY_START_FROM_Y + i * HISTORY_DISTANCE_FROM_Y;
					contentTf.htmlText = history ? ("<font color='#0033FF'>" + parseTime(history.time) + "</font>" + attackInfo) : "";
					contentTf.addEventListener(MouseEvent.CLICK,
						function(e:MouseEvent) : void
						{
							// request to replay match	 								
							var index:int = historyContainer.getChildIndex(e.target as DisplayObject);
							dispatchEvent(new EventEx(ON_REQUEST_VIEW_HISTORY_RESOURCE_MATCH, historyArr[index], true));
						}
					);
					
					historyContainer.addChild(contentTf);
				}
				
				vScroller.updateScroll(historyContainer.height + 10);
			}
		}	
		
		private function parseTime(time:String):String {
			//var index:int = time.indexOf("T");
			//return time.substr(index,time.length);
			var split:Array = time.split("T");
			var temp:String = split[1];
			
			//var milliseconds:int = parseInt(temp);			
			//var hours:int = minutes / 60;
			//var minutes:int = seconds / 60;
			//var seconds:int = milliseconds / 1000;
			var hours:String = temp.substr(0, 2);
			var minutes:String = temp.substr(2, 2);
			var seconds:String = temp.substr(4, 2);
			
			//seconds %= 60;
			//minutes %= 60;
			
			return hours + "h:" + minutes + "m";
		}
		
		public function lock():void
		{
			this.mouseEnabled = false;
			this.mouseChildren = false;
		}
		
		public function unlock():void
		{
			this.mouseEnabled = true;
			this.mouseChildren = true;
		}
		
		override public function get height():Number
		{
			return maskMovie.height * 1.1;
		}
	}
}