package game.data
{
	import game.data.model.Inventory;
	import game.data.model.UserData;
	import game.data.vo.flashvar.FlashVar;
	import game.data.xml.GameData;

	public class Database
	{
		public function Database()
		{
			userdata = new UserData();
			inventory = new Inventory();
			gamedata = new GameData();
			flashVar = new FlashVar();
		}

		public var userdata:UserData;
		public var inventory:Inventory;
		public var gamedata:GameData;
		public var flashVar:FlashVar;
	}
}