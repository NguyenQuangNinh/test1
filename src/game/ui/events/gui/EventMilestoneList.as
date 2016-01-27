/**
 * Created by NinhNQ on 9/23/2014.
 */
package game.ui.events.gui
{
	import com.greensock.TweenMax;

	import core.event.EventEx;

	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;

	import game.data.model.event.EventData;
	import game.data.model.event.Milestone;
	import game.data.xml.event.MilestoneStatus;

	public class EventMilestoneList extends MovieClip
	{
		public function EventMilestoneList()
		{
			contentMov.mask = masker;

			nextBtn.addEventListener(MouseEvent.CLICK, navigate_clicked);
			prevBtn.addEventListener(MouseEvent.CLICK, navigate_clicked);
		}

		public var contentMov:MovieClip;
		public var masker:MovieClip;
		public var nextBtn:SimpleButton;
		public var prevBtn:SimpleButton;

		public var selectedItem:EventMilestone;

		public function setData(eventData:EventData):void
		{
			reset();

			var milestones:Array = eventData.eventXML.milestones;

			for (var i:int = 0; i < milestones.length; i++)
			{
				var data:Milestone = milestones[i] as Milestone;
				var view:EventMilestone = new EventMilestone();
				view.setData(data);
				view.x = i * view.width;
				view.addEventListener(MouseEvent.CLICK, milestone_clicked);

				contentMov.addChild(view);

				if (selectedItem == null && data.status != MilestoneStatus.RECEIVED)
				{
					selectMileStone(view);
				}
			}

			if (selectedItem == null && milestones.length > 0)
			{
				selectMileStone(contentMov.getChildAt(0) as EventMilestone);
			}

			nextBtn.visible = (contentMov.width > masker.width);
			prevBtn.visible = (contentMov.width > masker.width);
		}

		private function move(delta:int):void
		{
			TweenMax.killAll(true);

			var lastPos:int = contentMov.x + contentMov.numChildren * EventMilestone.WIDTH;
			var upperBound:int = masker.x + masker.width;

			if ((delta < 0) && (lastPos <= upperBound)) return;
			if ((delta > 0) && (contentMov.x >= masker.x)) return;

			if (contentMov.width > masker.width)
			{
				var newX:int = contentMov.x + delta;
				TweenMax.to(contentMov, 0.3, {x: newX});
			}
		}

		private function reset():void
		{
			while (contentMov.numChildren > 0)
			{
				var m:EventMilestone = contentMov.removeChildAt(0) as EventMilestone;
				m.removeEventListener(MouseEvent.CLICK, milestone_clicked);
			}

			contentMov.x = masker.x;

			selectedItem = null;
		}

		private function selectMileStone(target:EventMilestone):void
		{
			if (selectedItem) selectedItem.select(false);

			selectedItem = target;
			selectedItem.select(true);
			dispatchEvent(new EventEx(EventPanel.UPDATE_REWARD, selectedItem.data, true));
		}

		private function navigate_clicked(event:MouseEvent):void
		{
			var delta:int = (event.currentTarget == nextBtn) ? -EventMilestone.WIDTH : EventMilestone.WIDTH;
			move(delta);
		}

		private function milestone_clicked(event:MouseEvent):void
		{
			var target:EventMilestone = event.currentTarget as EventMilestone;
			if (target != selectedItem)
			{
				selectMileStone(target);
			}
		}
	}
}
