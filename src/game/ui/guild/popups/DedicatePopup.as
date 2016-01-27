package game.ui.guild.popups 
{
	import components.event.BaseEvent;
	import components.ExRadioButtonGroup;
	import components.popups.OKCancelPopup;
	import core.util.FontUtil;
	import flash.display.SimpleButton;
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import game.enum.GameConfigID;
	import game.enum.PaymentType;
	import game.Game;
	import game.net.lobby.LobbyRequestType;
	import game.net.lobby.request.RequestBasePacket;
	import game.ui.guild.components.GuildExButtonCheckBox;
	import game.enum.Font;
	
	/**
	 * ...
	 * @author vu anh
	 */
	public class DedicatePopup extends OKCancelPopup
	{
		public var xuBtn:SimpleButton;
		public var goldBtn:SimpleButton;
		
		public var xu0Tf:TextField;
		public var xu1Tf:TextField;
		public var xu2Tf:TextField;
		
		public var goldTf:TextField;
		
		public var xuDPTf:TextField;
		public var goldDPTf:TextField;
		
		public var cb0:GuildExButtonCheckBox;
		public var cb1:GuildExButtonCheckBox;
		public var cb2:GuildExButtonCheckBox;
		
		public var xuRBGroup:ExRadioButtonGroup;
		
		public function DedicatePopup() 
		{
			FontUtil.setFont(xu0Tf, Font.ARIAL, true);
			FontUtil.setFont(xu1Tf, Font.ARIAL, true);
			FontUtil.setFont(xu2Tf, Font.ARIAL, true);
			FontUtil.setFont(xuDPTf, Font.ARIAL, true);
			FontUtil.setFont(goldTf, Font.ARIAL, true);
			FontUtil.setFont(goldDPTf, Font.ARIAL, true);
			goldTf.text = Game.database.gamedata.getConfigData(GameConfigID.GUILD_DEDICATED_GOLD_COST_ARR)[0];
			goldDPTf.text = Game.database.gamedata.getConfigData(GameConfigID.GUILD_DEDICATED_GOLD_RECEIVE_ARR)[0];
			xuDPTf.text = Game.database.gamedata.getConfigData(GameConfigID.GUILD_DEDICATED_XU_RECEIVE_ARR)[0];
			for (var i:int = 0; i < 3; i++) 
			{
				this["xu" + i + "Tf"].text = Game.database.gamedata.getConfigData(GameConfigID.GUILD_DEDICATED_XU_COST_ARR)[i];
			}
			
			xuBtn.addEventListener(MouseEvent.CLICK, xuBtnHdl);
			goldBtn.addEventListener(MouseEvent.CLICK, goldBtnHdl);
			
			xuRBGroup = new ExRadioButtonGroup();
			xuRBGroup.addItem(0, cb0);
			xuRBGroup.addItem(1, cb1);
			xuRBGroup.addItem(2, cb2);
			xuRBGroup.addEventListener(ExRadioButtonGroup.RADIO_BUTTON_CHANGE, xuRBGroupChangeHdl);
			xuRBGroup.setActiveItem(0);
		}
		
		private function xuRBGroupChangeHdl(e:Event):void 
		{
			var index:int = xuRBGroup.activeItem.info as int;
			xuDPTf.text = Game.database.gamedata.getConfigData(GameConfigID.GUILD_DEDICATED_XU_RECEIVE_ARR)[index];
		}
		
		private function goldBtnHdl(e:MouseEvent):void 
		{
			var packet:RequestBasePacket = new RequestBasePacket(LobbyRequestType.GU_DEDICATED);
			packet.ba.writeByte(PaymentType.GOLD.ID); // payment type: gold : 1
			packet.ba.writeByte(0); // index: 0
			Game.network.lobby.sendPacket(packet); 
		}
		
		private function xuBtnHdl(e:MouseEvent):void 
		{
			var packet:RequestBasePacket = new RequestBasePacket(LobbyRequestType.GU_DEDICATED);
			packet.ba.writeByte(7); // payment type: xu : 7
			packet.ba.writeByte(xuRBGroup.activeItem.info as int);
			Game.network.lobby.sendPacket(packet); 
		}
		
	}

}