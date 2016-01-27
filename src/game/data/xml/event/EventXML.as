/**
 * Created by NinhNQ on 9/19/2014.
 */
package game.data.xml.event
{

	import core.util.Enum;
	import core.util.Utility;

	import game.data.model.event.Milestone;
	import game.data.xml.*;

	public class EventXML extends XMLData
	{
		public var type:EventType;
		public var name:String;
		public var description:String;
		public var enable:Boolean;
		public var timeBegin:Number;
		public var timeEnd:Number;
		public var timeEndReceive:Number;
		public var levelRequired:int;
		public var milestones:Array = [];

		override public function parseXML(xml:XML):void
		{
			super.parseXML(xml);

			type = Enum.getEnum(EventType, parseInt(xml.Type.toString())) as EventType;
			name = xml.Name.toString();
			description = xml.Desc.toString();
			enable = (xml.Enable.toString() == "1");
			timeBegin = Utility.parseToDate(xml.Begin.toString()).getTime();
			timeEnd = Utility.parseToDate(xml.End.toString()).getTime();
			timeEndReceive = Utility.parseToDate(xml.EndReceive.toString()).getTime();
			levelRequired = parseInt(xml.LevelRequirement.toString());

			var index:int = 0;
			for each (var record:XML in xml.Milestones.Milestone)
			{
				var milestone:Milestone = new Milestone();
				milestone.index = index++;
				milestone.title = record.Title.toString();
				milestone.value = parseInt(record.Value.toString());
				milestone.rewards = Utility.parseToIntArray(record.Rewards.toString(), ",");
				milestones.push(milestone);
			}
		}
	}
}
