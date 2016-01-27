package game.ui.waitting
{
	import core.display.animation.Animator;
	import core.display.ViewBase;
	import core.event.EventEx;
	import core.util.FontUtil;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormatAlign;
	import game.enum.Font;
	import game.Game;
	import game.net.lobby.LobbyResponseType;
	import game.net.ResponsePacket;
	import game.net.Server;
	
	/**
	 * ...
	 * @author chuongth2
	 */
	public class WaittingView extends ViewBase
	{
		public var txtMessage:TextField;
		private var anim:Animator;
		public function WaittingView()
		{
			addEventListener(Event.ADDED_TO_STAGE, onInit);
		}
		
		private function onInit(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onInit);
			FontUtil.setFont(txtMessage, Font.ARIAL);
			anim = new Animator();
			anim.setCacheEnabled(true);
			anim.load("resource/anim/ui/fx_button.banim");
			anim.x = stage.width/2;
			anim.y = stage.height/2;
			this.addChild(anim);
			
			txtMessage.x = stage.width/2 - txtMessage.width/2;
			txtMessage.y = stage.height/2 -txtMessage.height;
		}
		
		public function showWaitting(msg:String):void
		{
			anim.play();
			txtMessage.text = msg;
		}
		public function hideWaitting():void
		{
			anim.stop();
			txtMessage.text = "";
		}
		override public function transitionIn():void
		{
			super.transitionIn();
			Game.network.lobby.addEventListener(Server.SERVER_DATA, onLobbyServerData);
		
		}
		
		override public function transitionOut():void
		{
			super.transitionOut();
			Game.network.lobby.removeEventListener(Server.SERVER_DATA, onLobbyServerData);
		
		}
		
		override protected function transitionInComplete():void
		{
			super.transitionInComplete();
			this.mouseChildren = false;
			this.mouseEnabled = false;
		}
		
		private function onLobbyServerData(e:EventEx):void
		{
			var packet:ResponsePacket = ResponsePacket(e.data);
			switch (packet.type)
			{
				case LobbyResponseType.LOGIN_CONFLICT_ACC:
					
					break;
			}
		}
	}

}