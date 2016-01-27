/**
 * Created by NINH on 1/5/2015.
 */
package game.ui.express.gui
{

	import core.event.EventEx;

	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	import game.Game;
	import game.data.model.Character;
	import game.data.vo.express.PorterVO;

	import game.net.lobby.response.ResponsePorterPlayerInfo;
	import game.ui.express.ExpressView;

	public class PortersContainer extends MovieClip
	{
		public var porter1:Porter;
		public var porter2:Porter;
		public var porter3:Porter;
		public var porter4:Porter;
		public var porter5:Porter;
		public var porter6:Porter;
		public var porter7:Porter;
		public var porter8:Porter;
		public var porter9:Porter;
		public var porter10:Porter;
		public var porter11:Porter;
		public var porter12:Porter;

		private var path:Array = [new Point(72,347), new Point(171,270), new Point(285,202), new Point(383,272),
									new Point(489,347), new Point(618,382), new Point(749,317), new Point(891,250),
									new Point(1038,244), new Point(1142,294), new Point(279,470)];

		private var myPorter:Porter;
		private var list:Array = [];

		public function PortersContainer()
		{
			myPorter = new Porter();
			addChild(myPorter);

			for(var i:int = 1; i < 13; i++)
			{
				var p:Porter = this["porter" + i];
				p.visible = false;
				p.mouseEnabled = true;
				p.buttonMode = true;
				list.push(p);
			}

			myPorter.visible = false;
			myPorter.mouseEnabled = true;
			myPorter.buttonMode = true;
		}

		public function updateMyPorter(packet:ResponsePorterPlayerInfo):void
		{
			var totalTime:int = Game.database.gamedata.getConfigData(216) * 60;
			var percent:int = Math.floor((1 -packet.elapsedTransportTime / totalTime)*10);
			var coordinate:Point = path[percent];
			var mainChar:Character = Game.database.userdata.mainCharacter;

			var data:PorterVO = new PorterVO();
			data.element = mainChar.element;
			data.name = mainChar.name;
			data.porterType = packet.porterType;
			data.playerID = Game.database.userdata.userID;

			myPorter.x = coordinate.x;
			myPorter.y = coordinate.y;
			myPorter.visible = true;
			myPorter.setData(data);
			myPorter.setHighlight(true);
		}

		public function updateList(porters:Array):void
		{
			for each (var porter:Porter in list)
			{
				porter.visible = false;
			}

			var length:int = Math.min(list.length, porters.length);

			for(var i:int = 0; i < length; i++)
			{
				var vo:PorterVO = porters[i] as PorterVO;
				porter = list[i] as Porter;
				porter.setData(vo);
				porter.visible = true;
			}
		}

		public function resetMyPorter():void
		{
			myPorter.visible = false;
		}
	}
}
