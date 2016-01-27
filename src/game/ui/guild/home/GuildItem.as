package game.ui.guild.home 
{
	import core.util.FontUtil;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import game.net.lobby.response.data.GuLadderInfo;
	import game.enum.Font;
	import game.net.ResponsePacket;
	/**
	 * ...
	 * @author vu anh
	 */
	public class GuildItem extends MovieClip
	{
		
		public var rankTf:TextField;
		public var nameTf:TextField;
		public var levelTf:TextField;
		
		public var info:GuLadderInfo;
		public var bg:MovieClip;
		public var isActived:Boolean;
		
		public function GuildItem() 
		{
			FontUtil.setFont(rankTf, Font.ARIAL, true);
			FontUtil.setFont(nameTf, Font.ARIAL, true);
			FontUtil.setFont(levelTf, Font.ARIAL, true);
			
			bg.visible = false;
			this.addEventListener(MouseEvent.MOUSE_OVER, overHdl);
			this.addEventListener(MouseEvent.MOUSE_OUT, outHdl);
			rankTf.mouseEnabled = false;
			nameTf.mouseEnabled = false;
			levelTf.mouseEnabled = false;
		}
		
		private function outHdl(e:MouseEvent):void 
		{
			if (!info) return;
			if (!isActived) bg.visible = false;
		}
		
		private function overHdl(e:MouseEvent):void 
		{
			if (!info) return;
			bg.visible = true;
		}
		
		public function reset():void
		{
			info = null;
			this.buttonMode = false;
			rankTf.text = "";
			nameTf.text = "";
			levelTf.text = "";
		}
		
		public function update(info:GuLadderInfo):void
		{
			this.info = info;
			this.buttonMode = true;
			rankTf.text = info.nRank.toString();
			nameTf.text = info.strName;
			levelTf.text = info.nLevel.toString();
		}
		
		public function active():void
		{
			bg.visible = true;
			isActived = true;
		}
		
		public function deactive():void
		{
			bg.visible = false;
			isActived = false;
		}
		
	}

}