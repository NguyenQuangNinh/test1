package game.ui.challenge 
{
	import components.event.BaseEvent;
	import core.display.layer.Layer;
	import core.event.EventEx;
	import core.Manager;
	import core.util.FontUtil;
	import core.util.Utility;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import game.data.vo.challenge.HistoryInfo;
	import game.data.vo.chat.ChatInfo;
	import game.data.vo.chat.ChatType;
	import game.data.vo.lobby.LobbyPlayerInfo;
	import game.enum.Font;
	import game.Game;
	import game.ui.dialog.DialogID;
	import game.ui.dialog.dialogs.YesNo;
	import game.ui.ModuleID;
	import game.ui.tooltip.TooltipEvent;
	import game.ui.tooltip.TooltipID;
	/**
	 * ...
	 * @author TrungLNM
	 */
	public class History extends MovieClip
	{
		public static const VIEW_HISTORY_CLICK:String = "viewHistoryClick";
		public static const SHARE_HISTORY_CLICK:String = "shareHistoryClick";
		public var viewBtn:SimpleButton;
		public var shareBtn:SimpleButton;
		public var contentTf:TextField;
		//public var viewBtn:SimpleButton;
		
		private var _index:int;
		private var _info:HistoryInfo;
		
		public function History() 
		{
			if (stage)
				init();
			else addEventListener(Event.ADDED_TO_STAGE, init);	
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			initUI();
		}
		
		private function initUI():void 
		{
			//set fonts
			FontUtil.setFont(contentTf, Font.ARIAL, false);
			contentTf.mouseWheelEnabled = false;
			//add events
			viewBtn.addEventListener(MouseEvent.CLICK, onViewClickHdl);
			//contentTf.addEventListener(TextEvent.LINK, onClickHyperLinkHdl);
			contentTf.addEventListener(MouseEvent.MOUSE_OVER, onContentMouseOverHdl);
			contentTf.addEventListener(MouseEvent.MOUSE_OUT, onContentMouseOutHdl);
			contentTf.addEventListener(MouseEvent.CLICK, onContentMouseClickHdl);
			
			shareBtn.addEventListener(MouseEvent.CLICK, shareBtnHdl);
		}
		
		private function shareBtnHdl(e:MouseEvent):void 
		{
			Manager.display.showDialog(DialogID.YES_NO, onAcceptShareHdl, null, {title: "THÔNG BÁO", message: "Bạn có muốn chia sẽ trận đấu này trên kênh thế giới?", option: YesNo.YES | YesNo.NO});
		}
		
		private function onAcceptShareHdl(data:Object):void 
		{
			dispatchEvent(new BaseEvent(SHARE_HISTORY_CLICK, _info));
		}
		
		private function onContentMouseClickHdl(e:MouseEvent):void 
		{
			if (_info != null)
			{
				Manager.display.showPopup(ModuleID.PLAYER_PROFILE,  Layer.BLOCK_BLACK, _info.playerID);
			}
		}
		
		private function onContentMouseOverHdl(e:MouseEvent):void 
		{
			//Utility.log("content is roll over with hyper link " + e.text);
			var startIndex:int = contentTf.text.indexOf("[");
			var endIndex:int = contentTf.text.indexOf("]");
			var startCharBound:Rectangle = contentTf.getCharBoundaries(startIndex);
			var endCharBound:Rectangle = contentTf.getCharBoundaries(endIndex);
			
			var bound:Rectangle = startCharBound && endCharBound ? new Rectangle(startCharBound.x, contentTf.y,
													endCharBound.x + endCharBound.width, contentTf.height) : null;
			if (bound && bound.containsPoint(new Point(e.localX, e.localY))) { 
				var id:int = _info ? _info.playerID : 0;
				//Utility.log("request player formation info of ID: " + id);
				//dispatchEvent(new EventEx(TooltipEvent.SHOW_TOOLTIP, { type:TooltipID.PLAYER_FORMATION_INFO, value:id, from: TooltipID.FROM_HISTORY }, true));	
			}
		}
		
		private function onContentMouseOutHdl(e:MouseEvent):void 
		{
			//dispatchEvent(new EventEx(TooltipEvent.HIDE_TOOLTIP, null, true));
		}
		
		/*private function onClickHyperLinkHdl(e:TextEvent):void 
		{
			Utility.log("content is click with hyper link " + e.text);
			dispatchEvent(new EventEx(TooltipEvent.SHOW_TOOLTIP, {type:TooltipID.PLAYER_FORMATION_INFO, value:e.text}, true));	
		}*/
		
		private function onViewClickHdl(e:MouseEvent):void 
		{
			dispatchEvent(new BaseEvent(VIEW_HISTORY_CLICK, _info));
		}
		
		public function update(index: int, info:HistoryInfo): void {
			_index = index;
			_info = info;
			var name:String = info.name;
			var maxL:int = 12;
			if (name.length > maxL) name = name.substr(0, maxL - 2) + "..";
			/*contentTf.text = info ? parseTime(info.time) + " " + info.name + " " + 
									(!info.isWin ? " win you " : " lose you ") + 
									(!info.isWin ? " down to " : " up to " + (info.rank + 1).toString()) 
								: "";*/
			var attackInfo:String = "";
			/*if (info.activeAttack) {
				attackInfo = (info.isWin ? " Bạn đã đánh bại " : "Bạn bị đánh bại bởi ") 
							+ (" [<a href='event:" + info.playerID.toString() + "'><font color='#FF0000'>" + info.name.toString() + "</font></a>]");
			}else {
				attackInfo = " [<a href='event:" + info.playerID.toString() + "'><font color='#FF0000'>" + info.name.toString() + "</font></a>]" 
							+ (info.isWin ? " đã đánh bại bạn" : " đã bị đánh bại bởi bạn");
			}
			contentTf.htmlText = info ? "<font color='#0000FF'>" + parseTime(info.time) + "</font>" + attackInfo
									+ ", hiện tại hạng: " + (info.rank + 1).toString() : "";*/	
			attackInfo = (info.isWin ? " <font color='#00FF00'>THẮNG</font> " : " <font color='#FF0000'>THUA</font> ") 
						+ " [<a href='event:" + info.playerID.toString() + "'><font color='#00FFFF'>" + name.toString() + "</font></a>]"
			var rankInfo:String = "";
			rankInfo = info.getRankStatus() != -2 ?
									"<br> Hạng" + (info.getRankStatus() == -1 ?
									" giảm: " : info.getRankStatus() == 0 ?
									" không đổi: " : info.getRankStatus() == 1 ?
									" tăng: " : "") : "";
			contentTf.htmlText = info ? ("<font color='#FFFFFF'>" + parseTime(info.time) + "</font>" + attackInfo
									+ (rankInfo != "" ? rankInfo + (info.rank + 1).toString() : "")) : "";
			/*+ (!info.isWin ? " Bạn đã bị người chơi " : " Bạn đã đánh bại ")
			+ " [<a href='event:" + info.playerID.toString() + "'><font color='#FF0000'>" + info.name + "</font></a>]" 
			+ (!info.isWin ? " đánh bại" : " người chơi")*/
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
		
	}

}