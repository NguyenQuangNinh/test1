/**
 * Created by NinhNQ on 9/23/2014.
 */
package game.ui.events.gui
{

	import components.scroll.VerScroll;

	import core.event.EventEx;

	import flash.display.MovieClip;
	import flash.events.Event;

	import game.data.model.event.EventData;
	import game.data.model.event.Milestone;
	import game.data.xml.event.EventType;

	public class EventPanel extends MovieClip
	{
		public static const UPDATE_REWARD:String = "EventPanel_update_reward";
		public static const RECEIVE_REWARD:String = "EventPanel_receive_reward";
		public static const ACTIVATE:String = "EventPanel_activate";
		public static const COMBINE:String = "EventPanel_combine";
		public static const CHARGE:String = "EventPanel_charge";

		public function EventPanel()
		{
			descMov = new EventDescription();
			containerMov.addChild(descMov);

			milestones = new EventMilestoneList();
			milestones.addEventListener(UPDATE_REWARD, updateRewardHdl);
			containerMov.addChild(milestones);

			progress = new EventProgress();
			containerMov.addChild(progress);

			rewards = new EventReward();
			containerMov.addChild(rewards);

			activatePanel = new EventActivatePanel();
			containerMov.addChild(activatePanel);

			equationPanel = new EventEquationPanel();
			containerMov.addChild(equationPanel);

			vScroller = new VerScroll(maskMovie, containerMov, scrollbar);
			containerMov.x = maskMovie.x;
			containerMov.y = maskMovie.y;

			hideAllElements();
		}

		public var descMov:EventDescription;
		public var milestones:EventMilestoneList;
		public var progress:EventProgress;
		public var rewards:EventReward;
		public var activatePanel:EventActivatePanel;
		public var equationPanel:EventEquationPanel;
		public var containerMov:MovieClip;
		public var scrollbar:MovieClip;
		public var maskMovie:MovieClip;
		public var vScroller:VerScroll;
		public var loadingMov:MovieClip;
		public var data:EventData;

		public function setData(eventData:EventData):void
		{
			if(data) data.removeEventListener(EventData.UPDATE, updateDataHandler);

			hideAllElements();

			loadingMov.visible = true;

			data = eventData;
			data.addEventListener(EventData.UPDATE, updateDataHandler)
			data.requestServerInfo();
		}

		private function updateDataHandler(event:Event):void
		{
			if(stage) updateData();
		}

		private function hideAllElements():void
		{
			descMov.visible = false;
			milestones.visible = false;
			progress.visible = false;
			rewards.visible = false;
			loadingMov.visible = false;

			activatePanel.visible = false;
			equationPanel.visible = false;
		}

		private function updateData():void
		{
			loadingMov.visible = false;
			descMov.visible = true;

			milestones.visible = data.eventXML.milestones.length > 0;
			progress.visible = data.eventXML.milestones.length > 0;
			rewards.visible = data.eventXML.milestones.length > 0;

			descMov.text = data.eventXML.description;

			milestones.setData(data);
			progress.setData(data);

			switch (data.eventXML.type)
			{
				case EventType.ACTIVATE:
					activatePanel.visible = true;
					activatePanel.setData(data);

					activatePanel.y = descMov.y + descMov.height + 10;
					milestones.y = activatePanel.y + activatePanel.height + 10;
					progress.y = milestones.y + milestones.height + 10;
					rewards.y = progress.y + progress.height + 10;
					break;
				case EventType.EXCHANGE:
					equationPanel.visible = true;
					equationPanel.setData(data);

					equationPanel.y = descMov.y + descMov.height + 10;
					milestones.y = equationPanel.y + equationPanel.height + 10;
					progress.y = milestones.y + milestones.height + 10;
					rewards.y = progress.y + progress.height + 10;
					break;
				default:
					milestones.y = descMov.y + descMov.height + 10;
					progress.y = milestones.y + milestones.height + 10;
					rewards.y = progress.y + progress.height + 10;
			}

			vScroller.updateScroll(containerMov.height);
		}

		private function updateRewardHdl(event:EventEx):void
		{
			rewards.setData(event.data as Milestone);
		}
	}
}
