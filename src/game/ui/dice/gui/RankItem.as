/**
 * Created by NINH on 1/12/2015.
 */
package game.ui.dice.gui
{

	import core.util.FontUtil;

	import flash.display.MovieClip;
	import flash.text.TextField;

	import game.data.vo.lobby.LobbyPlayerInfo;

	import game.enum.Font;

	public class RankItem extends MovieClip
	{
		public var rankTf:TextField;
		public var nameTf:TextField;
		public var scoreTf:TextField;
		public var bg:MovieClip;

		public function RankItem()
		{
			FontUtil.setFont(rankTf, Font.ARIAL, true);
			FontUtil.setFont(nameTf, Font.ARIAL, true);
			FontUtil.setFont(scoreTf, Font.ARIAL, true);
			bg.stop();
		}

		public function setData(data:LobbyPlayerInfo):void
		{
			var rank:int = data.rank + 1;
			rankTf.text = rank.toString();
			nameTf.text = data.name.toString();
			scoreTf.text = data.eloScore.toString();

			(rank > 3) ? bg.gotoAndStop(1) : bg.gotoAndStop(2);
		}
	}
}
