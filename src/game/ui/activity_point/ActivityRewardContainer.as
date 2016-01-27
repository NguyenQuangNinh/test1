package game.ui.activity_point 
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import game.enum.GameConfigID;
	import game.Game;
	import game.net.ByteRequestPacket;
	import game.net.lobby.LobbyRequestType;
	/**
	 * ...
	 * @author vu anh
	 */
	public class ActivityRewardContainer extends MovieClip
	{
		private var scoreArr:Array;
		private var rewardIds:Array;
		
		public var baseItem:MovieClip;
		public var itemList:Array;
		
		public function ActivityRewardContainer() 
		{
			baseItem.visible = false;
			
			itemList = [];
			var item:ActivityRewardItem;
			var pos:Number = baseItem.x;
			scoreArr = Game.database.gamedata.getConfigData(GameConfigID.GUILD_ACTIVITY_REWARD_POINT_ARR);
			for (var i:int = 0; i < scoreArr.length; i++) 
			{
				item = new ActivityRewardItem();
				itemList.push(item);
				item.x = pos;
				item.y = baseItem.y;
				item.index = i;
				addChild(item);
				pos += 170;
				if (i == scoreArr.length - 1) item.arrow.visible = false;
				item.addEventListener(MouseEvent.CLICK, itemHdl);
			}
		}
		
		private function itemHdl(e:MouseEvent):void 
		{
			var item:ActivityRewardItem = e.currentTarget as ActivityRewardItem;
			if (item.isLocked) return;
			Game.network.lobby.sendPacket(new ByteRequestPacket(LobbyRequestType.AC_GET_ACTIVITY_REWARD, item.index));
		}
		
		public function updateReward(currentScore:int, opennedArr:Array):void
		{
		
			var configID:int = (Game.database.userdata.guildId >= 0 ? GameConfigID.GUILD_ACTIVITY_REWARD_ITEM_ARR : GameConfigID.AC_ACTIVITY_REWARD_ITEM_ARR);
			rewardIds = Game.database.gamedata.getConfigData(configID);
			
			var item:ActivityRewardItem;
			
			for (var i:int = 0; i < itemList.length; i++) 
			{
				item = itemList[i];
				item.initReward(scoreArr[i], rewardIds[i]);
			}
			
			for (i = 0; i < scoreArr.length; i++) 
			{
				if (currentScore >= scoreArr[i]) ActivityRewardItem(itemList[i]).unlock();
				else ActivityRewardItem(itemList[i]).lock();
			}
			
			for (var j:int = 0; j < opennedArr.length; j++) 
			{
				ActivityRewardItem(itemList[opennedArr[j]]).setOpenned();
			}
		}
	}

}