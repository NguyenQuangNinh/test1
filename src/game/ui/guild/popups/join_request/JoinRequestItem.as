package game.ui.guild.popups.join_request 
{
	import core.util.FontUtil;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import game.Game;
	import game.net.IntRequestPacket;
	import game.net.lobby.LobbyRequestType;
	import game.net.lobby.response.data.GuJoinRequestInfo;
	import game.enum.Font;
	import game.net.ResponsePacket;
	/**
	 * ...
	 * @author vu anh
	 */
	public class JoinRequestItem extends MovieClip
	{
		
		public var indexTf:TextField;
		public var nameTf:TextField;
		public var levelTf:TextField;
		
		public var info:GuJoinRequestInfo;
		
		public var denyBtn:SimpleButton;
		public var acceptBtn:SimpleButton;
		
		public function JoinRequestItem() 
		{
			FontUtil.setFont(indexTf, Font.ARIAL, true);
			FontUtil.setFont(nameTf, Font.ARIAL, true);
			FontUtil.setFont(levelTf, Font.ARIAL, true);
			
			indexTf.mouseEnabled = false;
			nameTf.mouseEnabled = false;
			levelTf.mouseEnabled = false;
			
			acceptBtn.addEventListener(MouseEvent.CLICK, acceptBtnHdl);
			denyBtn.addEventListener(MouseEvent.CLICK, denyBtnHdl);
		}
		
		private function acceptBtnHdl(e:MouseEvent):void 
		{
			Game.network.lobby.sendPacket(new IntRequestPacket(LobbyRequestType.GU_JOIN_REQUEST_ACCEPT, info.nPlayerID));
			lock();
		}
		
		private function denyBtnHdl(e:MouseEvent):void 
		{
			Game.network.lobby.sendPacket(new IntRequestPacket(LobbyRequestType.GU_JOIN_REQUEST_REJECT, info.nPlayerID));
			lock();
		}
		
		public function lock():void
		{
			this.alpha = 0.5;
			this.mouseEnabled = false;
			this.mouseChildren = false;
		}
		
		public function unlock():void
		{
			this.alpha = 1;
			this.mouseEnabled = true;
			this.mouseChildren = true;
		}
		
		public function reset():void
		{
			info = null;
			indexTf.text = "";
			nameTf.text = "";
			levelTf.text = "";
			this.visible = false;
		}
		
		public function update(info:GuJoinRequestInfo):void
		{
			unlock();
			this.visible = true;
			this.info = info;
			indexTf.text = info.index.toString();
			nameTf.text = info.strRoleName;
			levelTf.text = info.nLevel.toString();
		}
		
	}

}