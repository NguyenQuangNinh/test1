package game.ui.present.gui
{
	import flash.display.MovieClip;
	import flash.utils.Dictionary;
	import game.data.xml.LevelRewardRequireLevelXML;
	import game.enum.FeatureEnumType;
	import game.net.lobby.response.ResponseGetRewardRequireLevelInfo;
	import game.ui.components.ScrollbarEx;
	import game.utility.GameUtil;
	
	/**
	 * ...
	 * @author chuongth2
	 */
	public class RewardLevelView extends MovieClip
	{
		public var contentMask:MovieClip;
		public var track:MovieClip;
		public var slider:MovieClip;
		
		private var scrollbar:ScrollbarEx;
		private var _contentScrollBar:MovieClip = new MovieClip();
	
		
		public function RewardLevelView()
		{
			contentMask.visible = false;
			scrollbar = new ScrollbarEx();
			_contentScrollBar.x = contentMask.x;
			_contentScrollBar.y = contentMask.y;
		
			this.addChild(_contentScrollBar);
		}
		
		public function init(packet:ResponseGetRewardRequireLevelInfo):void
		{
			while (_contentScrollBar.numChildren > 0)
			{
				_contentScrollBar.removeChildAt(0);
			}
			
			
			var dics:Dictionary = GameUtil.getRewardRequireLevelXMLs(FeatureEnumType.REWARD_REQUIRE_LEVEL);
			if (dics)
			{
				var rewardLevelItem:RewardLevelItem;
				var rewardRequireLevelXML:LevelRewardRequireLevelXML;
				var i:int = 0;
				for each (var obj:Object in dics)
				{
					rewardRequireLevelXML = obj as LevelRewardRequireLevelXML;
					if (rewardRequireLevelXML)
					{
						rewardLevelItem = new RewardLevelItem();
						rewardLevelItem.init(rewardRequireLevelXML);
						
						if (packet.currentLevel < rewardRequireLevelXML.nLevelRequire)
							rewardLevelItem.setStatus(RewardLevelItem.RECEIVE);
						else
						{
							if (packet.arrRewardLevelID.indexOf(rewardRequireLevelXML.ID) != -1)
								rewardLevelItem.setStatus(RewardLevelItem.RECEIVED);
							else
								rewardLevelItem.setStatus(RewardLevelItem.NORMAL);
						}
						
						rewardLevelItem.x = 0;
						rewardLevelItem.y = 32 * i++;
						_contentScrollBar.addChild(rewardLevelItem);
					}
				}
			}
			scrollbar.init(_contentScrollBar, contentMask, track, slider);
			scrollbar.verifyHeight();
		}
	}

}