/**
 * Created by NinhNQ on 12/3/2014.
 */
package game.data.model
{

	public class WikiSubTab
	{
		public var name:String;
		public var content:String;
		public var link:String;

		public function parse(record:XML):void
		{
			name = record.Name.toString();
			content = record.Content.toString();
			link = record.Link.toString();
		}
	}
}
