package game.ui.train.home 
{
	import game.enum.Font;
	import core.util.FontUtil;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import game.data.xml.DataType;
	import game.data.xml.MessageXML;
	import game.enum.FlowActionEnum;
	import game.enum.GameConfigID;
	import game.enum.GameMode;
	import game.Game;
	import game.net.lobby.request.RequestCreateBasicRoom;
	import game.net.lobby.request.RequestQuickJoinBasicRoom;
	/**
	 * ...
	 * @author vu anh
	 */
	public class TrainHome extends MovieClip
	{
		public var closeBtn:SimpleButton;
		
		private var createRoomPacket:RequestCreateBasicRoom;
		private var quickJoinPacket:RequestQuickJoinBasicRoom;
		
		public var roomList:RoomList;
		
		public var trainHostRemainTf:TextField;
		public var trainPartnerRemainTf:TextField;
		public var contentTf:TextField;
		
		public var quickJoinBtn:SimpleButton;
		public var createRoomBtn:SimpleButton;
		
		
		public function TrainHome() 
		{
			FontUtil.setFont(contentTf, Font.ARIAL, true);
			FontUtil.setFont(trainHostRemainTf, Font.ARIAL, true);
			FontUtil.setFont(trainPartnerRemainTf, Font.ARIAL, true);
			
			var messageXML:MessageXML = Game.database.gamedata.getData(DataType.MESSAGE, 149) as MessageXML;
			contentTf.text = 
			//messageXML.content  
			'\n\n' + "Số lần chỉ điểm tối đa: " + Game.database.gamedata.getConfigData(GameConfigID.KUNGFU_TRAIN_MASTER_MAX_TIME)
			+ '\n\n' + "Số lần được chỉ điểm tối đa: " + Game.database.gamedata.getConfigData(GameConfigID.KUNGFU_TRAIN_PARTNER_MAX_TIME);
			
			trainHostRemainTf.text = Game.database.userdata.nKungfuTrainHostRemainTime.toString();
			trainPartnerRemainTf.text = Game.database.userdata.nKungfuTrainPartnerRemainTime.toString();
			
			createRoomPacket = new RequestCreateBasicRoom();
			createRoomPacket.nGameMode = GameMode.PVP_TRAINING.ID;
			
			quickJoinPacket = new RequestQuickJoinBasicRoom();
			quickJoinPacket.nModeID = GameMode.PVP_TRAINING.ID;
			
			createRoomBtn.addEventListener(MouseEvent.CLICK, createRoomBtnHdl);
			quickJoinBtn.addEventListener(MouseEvent.CLICK, quickJoinBtnHdl);
		}
		
		private function quickJoinBtnHdl(e:MouseEvent):void 
		{
			Game.network.lobby.sendPacket(quickJoinPacket);
		}
		
		private function createRoomBtnHdl(e:MouseEvent):void 
		{
			Game.network.lobby.sendPacket(createRoomPacket);
		}
		
	}

}