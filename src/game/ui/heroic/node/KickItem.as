package game.ui.heroic.node 
{
	import com.greensock.TweenMax;
	import core.event.EventEx;
	import core.util.FontUtil;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import game.data.vo.lobby.LobbyPlayerInfo;
	import game.enum.Font;
	import game.Game;
	
	/**
	 * ...
	 * @author MaiPTT
	 */
	public class KickItem extends MovieClip 
	{
		static public const SELECTED:String = "kick_item_selected";
		
		public var txtName		:TextField;
		public var movStatus	:MovieClip;
		private var data		:LobbyPlayerInfo;
		private var selected	:Boolean;
		
		public function KickItem() {
			initUI();
			setSelect(false);
			this.addEventListener(MouseEvent.CLICK, onMouseClickHdl);
		}
		
		public function reset():void {
			data = null;
			if (this.hasEventListener(MouseEvent.CLICK)) {
				this.removeEventListener(MouseEvent.CLICK, onMouseClickHdl);
			}
		}
		
		public function setData(value:LobbyPlayerInfo):void {
			data = value;
			if (data) {
				txtName.text = data.name;
				if (data.id == Game.database.userdata.userID) {
					setEnable(false);
				} else {
					setEnable(true);
				}
			}
		}
		
		public function setSelect(value:Boolean):void {
			selected = value;
			if (selected) {
				movStatus.gotoAndStop(2);
			} else {
				movStatus.gotoAndStop(1);
			}
		}
		
		private function setEnable(value:Boolean):void {
			if (value) {
				TweenMax.to(this, 0, { colorMatrixFilter: { saturation:1.0 }} );
				if (!this.hasEventListener(MouseEvent.CLICK)) {
					this.addEventListener(MouseEvent.CLICK, onMouseClickHdl);
				}
			} else {
				TweenMax.to(this, 0, { colorMatrixFilter: { saturation:0.05 }} );
				if (this.hasEventListener(MouseEvent.CLICK)) {
					this.removeEventListener(MouseEvent.CLICK, onMouseClickHdl);
				}
			}
		}
		
		private function onMouseClickHdl(e:MouseEvent):void {
			if (data) {
				if (!selected) {
					dispatchEvent(new EventEx(SELECTED, { id:data.id }, true));	
				} else {
					dispatchEvent(new EventEx(SELECTED, { id: -1 }, true));
				}
			}
		}
		
		private function initUI():void {
			this.buttonMode = true;
			FontUtil.setFont(txtName, Font.ARIAL);
		}
	}

}