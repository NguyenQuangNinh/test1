package game.data.xml
{
	
	public class TopConfigXML extends XMLData
	{
		/*<ID>1</ID>
		   <Desc>Top PVP AI, Hoa Son Luan Kiem</Desc>
		   <ResetDaily>-1<ResetDaily>
		   <ResetWeekly>2</ResetWeekly>
		   <ResetInterval>-1<ResetInterval>
		   <TopRewards>
		   <TopReward>
		   <From>1</From>
		   <To>10</To>
		   <RewardDaily>-1</RewardDaily>
		   <RewardWeekly>1</RewardWeekly>
		   <RewardInterval>-1</RewardInterval>
		   </TopReward>
		   <TopReward>
		   <From>11</From>
		   <To>100</To>
		   <RewardDaily>-1</RewardDaily>
		   <RewardWeekly>1</RewardWeekly>
		   <RewardInterval>-1</RewardInterval>
		   </TopReward>
		 </TopRewards>*/
		private var _topReward:Array = [];
		
		public function TopConfigXML()
		{
		
		}
		
		override public function parseXML(xml:XML):void
		{
			super.parseXML(xml);
			
			if (xml.TopRewards.length() > 0)
			{
				var listTopRewards:XML = xml.TopRewards[0] as XML;
				for each (var listReward:XML in listTopRewards.TopReward as XMLList)
				{
					var topReward:Object = {};
					topReward.from = parseInt(listReward.From.toString());
					topReward.to = parseInt(listReward.To.toString());
					topReward.rewardDaily = parseInt(listReward.RewardDaily.toString());
					topReward.rewardWeekly = parseInt(listReward.RewardWeekly.toString());
					topReward.rewardInterval = parseInt(listReward.RewardInterval.toString());
					this._topReward.push(topReward);
				}
			}
		
		}
		
		public function getTopReward():Array
		{
			return _topReward;
		}
		
		public function getRewardIntervalAtIndex(index:int):int
		{
			if (index >= 0 && index < _topReward.length)
				return _topReward[index].rewardInterval;
			return -1;
		}
	}
}