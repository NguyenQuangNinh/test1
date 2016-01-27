package game.ui.present.gui
{
	import com.greensock.TweenMax;

	import core.display.BitmapEx;
	import core.util.Enum;
	import core.util.FontUtil;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import game.data.model.item.ItemFactory;
	import game.data.xml.DataType;
	import game.data.xml.LevelRewardRequireLevelXML;
	import game.data.xml.RewardXML;
	import game.enum.Font;
	import game.enum.ItemType;
	import game.Game;
	import game.net.IntRequestPacket;
	import game.net.lobby.LobbyRequestType;
	
	/**
	 * ...
	 * @author chuongth2
	 */
	public class RewardLevelItem extends MovieClip
	{
		public static const NORMAL:String = "normal";
		public static const ACTIVE:String = "active";
		public static const RECEIVE:String = "receive";
		public static const RECEIVED:String = "received";
		
		public var levelTf:TextField;
		public var receiveBtn:MovieClip;
		public var levelID:int;
		public var rewardsMov:MovieClip;

		private var status:String = NORMAL;
		private const SCALE:Number = 0.6;

		public function RewardLevelItem()
		{
			FontUtil.setFont(levelTf, Font.ARIAL, true);
			receiveBtn.mouseEnabled = false;
			receiveBtn.buttonMode = true;
			receiveBtn.addEventListener(MouseEvent.CLICK, onReceiveBtn);
			receiveBtn.addEventListener(MouseEvent.ROLL_OVER, onRollOverReceiveBtn);
			receiveBtn.addEventListener(MouseEvent.ROLL_OUT, onRollOutReceiveBtn);

			rewardsMov.scaleX = SCALE;
			rewardsMov.scaleY = SCALE;
		}
		
		private function onRollOutReceiveBtn(e:MouseEvent):void
		{
			TweenMax.to(receiveBtn, 0, {glowFilter: {color: 0xffff00, alpha: 0}});
		}
		
		private function onRollOverReceiveBtn(e:MouseEvent):void
		{
			TweenMax.to(receiveBtn, 0, {glowFilter: {color: 0xffff00, alpha: 1, strength: 4}});
		}
		
		private function onReceiveBtn(e:MouseEvent):void
		{
			if (levelID > 0)
				Game.network.lobby.sendPacket(new IntRequestPacket(LobbyRequestType.RECEIVE_REWARD_REQUIRE_LEVEL, levelID));
		}
		
		public function setStatus(value:String):void
		{
			status = value;
			receiveBtn.mouseEnabled = false;
			switch (value)
			{
				case NORMAL: 
					receiveBtn.mouseEnabled = true;
				case RECEIVE: 
				case RECEIVED: 
					receiveBtn.gotoAndStop(value);
					break;
				default: 
					receiveBtn.gotoAndStop(NORMAL);
			}
		}
		
		public function init(rewardRequireLevelXML:LevelRewardRequireLevelXML):void
		{
			if (rewardRequireLevelXML == null)
				return;
			levelTf.text = "Lv:" + rewardRequireLevelXML.nLevelRequire.toString();
			levelID = rewardRequireLevelXML.ID;
			//build item slot
			
			for (var i:int = 0; i < rewardRequireLevelXML.arrRewardLevel.length; i++)
			{
				var rewardXml:RewardXML = Game.database.gamedata.getData(DataType.REWARD, rewardRequireLevelXML.arrRewardLevel[i]) as RewardXML;
				if (rewardXml != null)
				{
					var itemSlot:TopItem = new TopItem();
					itemSlot.addEventListener(BitmapEx.LOADED, onItemLoadedHdl);
					itemSlot.setConfigInfo(ItemFactory.buildItemConfig(rewardXml.type, rewardXml.itemID));
					itemSlot.setQuantity(rewardXml.quantity);
				}
			}
		}

		private function onItemLoadedHdl(event:Event):void
		{
			var itemSlot:TopItem = event.currentTarget as TopItem;
			itemSlot.removeEventListener(BitmapEx.LOADED, onItemLoadedHdl);
			itemSlot.x = rewardsMov.width/SCALE;
			itemSlot.y = 0;
			rewardsMov.addChild(itemSlot);
		}
	}

}