package game.ui.create_character 
{
	import core.display.layer.Layer;
	import flash.events.Event;
	import game.net.ByteResponsePacket;
	import game.ui.dialog.DialogID;
	import game.ui.dialog.dialogs.YesNo;
	
	import core.Manager;
	import core.display.ModuleBase;
	import core.event.EventEx;
	import core.util.Utility;
	
	import game.Game;
	import game.data.model.UserData;
	import game.net.IntResponsePacket;
	import game.net.RequestPacket;
	import game.net.ResponsePacket;
	import game.net.Server;
	import game.net.lobby.LobbyRequestType;
	import game.net.lobby.LobbyResponseType;
	import game.net.lobby.response.ResponseLogin;
	import game.ui.ModuleID;
	import game.ui.message.MessageID;
	import game.ui.preloader.PreloaderView;
	
	/**
	 * ...
	 * @author MaiPTT
	 */
	public class CreateCharacterModule extends ModuleBase 
	{
		
		public function CreateCharacterModule() {
			
		}
		
		override protected function createView():void {
			baseView = new CreateCharacterView();
		}
		
		override protected function onTransitionInComplete():void
		{
			super.onTransitionInComplete();
			Game.network.lobby.addEventListener(Server.SERVER_DATA, onLobbyServerData);
			Manager.resource.load(["resource/txt/sensitive_words_createcharacter.txt"], onComplete);
		}
		
		private function onComplete():void {
			
		}
		
		override protected function onTransitionOutComplete():void
		{
			super.onTransitionOutComplete();
			Game.network.lobby.removeEventListener(Server.SERVER_DATA, onLobbyServerData);
			Manager.resource.unload(["resource/txt/sensitive_words_createcharacter.txt"]);
		}
		
		private function onLobbyServerData(e:EventEx):void
		{
			var packet:ResponsePacket = ResponsePacket(e.data);
			switch(packet.type)
			{
				case LobbyResponseType.LOGIN:
					onLogin(packet as ResponseLogin);						
					break;
				case LobbyResponseType.LOGIN_CONFLICT_ACC:
					onConflictAcc(packet as ByteResponsePacket);
					break;
			}
		}
		
		private function onConflictAcc(packet:ByteResponsePacket):void {
			if (packet.value == 1) {
				//Manager.display.showMessageID(MessageID.LOGIN_CONFLICT_ACC);
				var dialogData:Object = {};
				dialogData.title = "Đăng nhập trùng";
				dialogData.message = "Tài khoản này đã bị đăng nhập ở nơi khác";
				dialogData.option = YesNo.CLOSE;
				Manager.display.showDialog(DialogID.YES_NO, onConflictAccYes, null, dialogData, Layer.BLOCK_BLACK);
			}
		}
		
		private function onConflictAccYes(data:Object):void {
			
		}
		
		private function onLogin(packet:ResponseLogin):void 
		{
			Utility.log("login create Character result: " + packet.errorCode);
			switch(packet.errorCode)
			{
				case 0:
					//login success
					//Game.database.userdata.userID = packet.userID;
					//Manager.display.to(ModuleID.PRELOADER);
					break;
				//case 1:
					//login fail by normal error					
					//break;
				case 2:
					//login fail by wrong id
					break;
				case 3:
					//login fail by full-player
					break;
				case 4:
					//login fail by null-player
					break;
				case 1:
				case 5:
					//login fail by existed role name
					//Manager.display.showMessage(MessageID.REGISTER_EXISTED_ROLE_NAME);
					var module:CreateCharacterModule = Manager.module.getModuleByID(ModuleID.CREATE_CHARACTER) as CreateCharacterModule;
					(module.baseView as CreateCharacterView).checkNameResult = true;
					break;
				case 6:
					//login fail by not existed account name 
					//Manager.module.load(ModuleID.CREATE_CHARACTER, function():void {
					//	Manager.display.to(ModuleID.CREATE_CHARACTER);
					//} );
					break;
			}
		}
	}

}