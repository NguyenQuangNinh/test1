package game.ui.worldmap.gui 
{
	import core.display.animation.Animator;
	import core.event.EventEx;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import game.data.model.CampaignRewardData;
	import game.data.xml.CampaignXML;
	import game.data.xml.RewardXML;
	import game.net.lobby.response.ResponseCampaignInfo;
	import game.ui.tooltip.TooltipEvent;
	import game.ui.tutorial.TutorialEvent;
	/**
	 * ...
	 * @author anhtinh
	 */
	public class RewardPanel extends Sprite
	{
		private var _campaignData : CampaignXML;
		private var _rewardList : Array;
		private var _container : Sprite = new Sprite();
		private var _animCollect:Animator;
		private var _currentReceiveGiftIndex:int;
		
		public function RewardPanel() 
		{
			this.addChild(_container);
			
			_animCollect = new Animator();
			_animCollect.x = 100;		
			_animCollect.y = 50 - 21;
			_animCollect.load("resource/anim/ui/fx_menhkhi.banim");
			_animCollect.stop();
			_animCollect.visible = false;
			_animCollect.addEventListener(Event.COMPLETE, onCollectComplete);
			addChild(_animCollect);
		}
		
		private function onCollectComplete(e:Event):void 
		{
			_animCollect.visible = false;
			_animCollect.stop();
			dispatchEvent(new EventEx(TutorialEvent.EVENT, { type:TutorialEvent.GET_REWARD_DONE }, true));
			//CampaignRewardSlot(rewardList[_currentReceiveGiftIndex]).setState(CampaignRewardSlot.GIFTED);
			
		}
		
		public function renderWithData(campaignData : CampaignXML, responseCampaignInfo : ResponseCampaignInfo) : void {
			while (this._container.numChildren != 0) 
			{
				var child:CampaignRewardSlot = _container.getChildAt(0) as CampaignRewardSlot;
				child.destroy();
				_container.removeChild(child);
				//this.container.removeChildAt(0);
			}
			
			_rewardList = [];
			
			this._campaignData = campaignData;
			
			for (var i:int = 0; i < this._campaignData.rewards.length ; i++) 
			{
				var rewardXML : RewardXML = this._campaignData.rewards[i] as RewardXML;
				if(rewardXML != null)
				{
					var campaignRewardSlot : CampaignRewardSlot = new CampaignRewardSlot();
					campaignRewardSlot.setData(rewardXML, campaignData.ID, i, responseCampaignInfo);
					campaignRewardSlot.x = i * 90 + 20;
					_container.addChild(campaignRewardSlot);
					_rewardList.push(campaignRewardSlot);
				}
			}
		}
		
		public function setGiftedForSlot(index : int) : void {
			
			this._currentReceiveGiftIndex = index;
			CampaignRewardSlot(_rewardList[_currentReceiveGiftIndex]).setState(CampaignRewardSlot.GIFTED);
			playReceiveGiftEffect(index);
			dispatchEvent(new EventEx(TooltipEvent.HIDE_TOOLTIP, null, true));	
		}
		
		private function playReceiveGiftEffect(index : int) : void {
			_animCollect.x = 33 + index * 78;
			_animCollect.play(0, 1);
			_animCollect.visible = true;
		}
		
		public function getWidth() : Number {
			return _container.width;
		}

		public function getRewardStatus(index:int = 0):int
		{
			var campaignRewardSlot:CampaignRewardSlot = _rewardList[index] as CampaignRewardSlot;
			if(campaignRewardSlot)
			{
				return campaignRewardSlot.state;
			}

			return 0;
		}
	}

}