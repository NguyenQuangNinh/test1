package game.ui.train.home 
{
	import core.util.FontUtil;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.utils.setTimeout;
	import game.Game;
	import game.enum.Font;
	import game.net.lobby.request.RequestJoinRoomPvP;
	import game.ui.train.data.RoomInfo;
	/**
	 * ...
	 * @author vu anh
	 */
	public class RoomItem extends MovieClip
	{
		public var joinBtn:SimpleButton;
		
		public var indexTf:TextField;
		public var nameTf:TextField;
		public var levelTf:TextField;
		
		public var info:RoomInfo;
		public var isActived:Boolean;
		
		public function RoomItem() 
		{
			FontUtil.setFont(indexTf, Font.ARIAL, true);
			FontUtil.setFont(nameTf, Font.ARIAL, true);
			FontUtil.setFont(levelTf, Font.ARIAL, true);
			
			indexTf.mouseEnabled = false;
			nameTf.mouseEnabled = false;
			levelTf.mouseEnabled = false;
			
			joinBtn.addEventListener(MouseEvent.CLICK, joinBtnHdl);
		}
		
		private function joinBtnHdl(e:MouseEvent):void
		{
			Game.network.lobby.sendPacket(new RequestJoinRoomPvP(info.roomId, false));
			joinBtn.mouseEnabled = false;
			setTimeout(enableBtn, 2000);
		}
		
		private function enableBtn():void 
		{
			joinBtn.mouseEnabled = true;
		}
		
		public function setEnable(enable:Boolean):void
		{
			joinBtn.mouseEnabled = enable;
			joinBtn.alpha = enable ? 1 : 0.5;
			var color:uint = enable ? 0xffffff : 0xDDDDDD;
			indexTf.textColor = color;
			nameTf.textColor = color;
			levelTf.textColor = color;
		}
		
		private function outHdl(e:MouseEvent):void 
		{
			if (!info) return;
		}
		
		private function overHdl(e:MouseEvent):void 
		{
			if (!info) return;
		}
		
		public function reset():void
		{
			info = null;
			indexTf.text = "";
			nameTf.text = "";
			levelTf.text = "";
			setEnable(true);
			joinBtn.visible = false;
		}
		
		public function update(info:RoomInfo):void
		{
			this.info = info;
			joinBtn.visible = true;
			indexTf.text = info.index.toString();
			nameTf.text = info.strRoleName;
			levelTf.text = info.nLevel.toString();
			
			//if (info.playerNum == 2) setEnable(false);
			//else setEnable(true);
		}
		
		public function active():void
		{
			isActived = true;
		}
		
		public function deactive():void
		{
			isActived = false;
		}
		
	}

}