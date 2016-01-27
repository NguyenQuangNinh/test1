/**
 * Created by NINH on 1/12/2015.
 */
package game.ui.dice.gui
{

	import core.event.EventEx;
	import core.util.MovieClipUtils;

	import flash.display.MovieClip;
	import flash.events.Event;

	import game.data.vo.lobby.LobbyPlayerInfo;

	import game.ui.components.PagingMov;
	import game.ui.dice.DiceView;

	public class RankList extends MovieClip
	{
		public static const NUM_ROW:int = 8;

		private var content:MovieClip = new MovieClip();
		private var pagingMov : PagingMov = new PagingMov();
		private var currentPage : int;
		private var totalPage : int = 0;

		public function RankList()
		{
			addChild(content);
			addChild(pagingMov);

			currentPage = 1;
			pagingMov.x = 62;
			pagingMov.y = 296;
			pagingMov.addEventListener(PagingMov.GO_TO_PREV, prevHandler);
			pagingMov.addEventListener(PagingMov.GO_TO_NEXT, nextHandler);
			pagingMov.update(currentPage, 0);
		}

		private function prevHandler(e:Event):void
		{
			currentPage--;
			pagingMov.update(currentPage, totalPage);
			updatePage();
		}

		private function nextHandler(e:Event):void
		{
			currentPage++;
			pagingMov.update(currentPage, totalPage);
			updatePage();
		}

		public function updatePage():void
		{
			var from:int = (currentPage - 1)*RankList.NUM_ROW;
			var to:int = (currentPage) * RankList.NUM_ROW;
			dispatchEvent(new EventEx(DiceView.UPDATE_RANKING, {from:from, to:to}, true));
		}

		public function updateData(players:Array):void
		{
			MovieClipUtils.removeAllChildren(content);

			for (var i:int = 0; i < players.length; i++)
			{
				var info:LobbyPlayerInfo = players[i] as LobbyPlayerInfo;
				var item:RankItem = new RankItem();
				item.setData(info);
				item.y = i*32;
				content.addChild(item);
			}
		}
	}
}
