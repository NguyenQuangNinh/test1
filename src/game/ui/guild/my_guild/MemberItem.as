package game.ui.guild.my_guild 
{
	import core.util.FontUtil;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import game.Game;
	import game.net.lobby.response.data.GuMemberInfo;
	import game.enum.Font;
	import game.net.lobby.response.data.GuMemberInfo;
	import game.net.ResponsePacket;
	import game.ui.guild.GuildUtils;
	/**
	 * ...
	 * @author vu anh
	 */
	public class MemberItem extends MovieClip
	{
		
		public var indexTf:TextField;
		public var nameTf:TextField;
		public var roleTf:TextField;
		public var levelTf:TextField;
		public var dedicatedPointTf:TextField;
		
		public var info:GuMemberInfo;
		public var bg:MovieClip;
		public var isActived:Boolean;
		
		public function MemberItem() 
		{
			FontUtil.setFont(indexTf, Font.ARIAL, true);
			FontUtil.setFont(nameTf, Font.ARIAL, true);
			FontUtil.setFont(levelTf, Font.ARIAL, true);
			FontUtil.setFont(roleTf, Font.ARIAL, true);
			FontUtil.setFont(dedicatedPointTf, Font.ARIAL, true);
			
			bg.visible = false;
			this.addEventListener(MouseEvent.MOUSE_OVER, overHdl);
			this.addEventListener(MouseEvent.MOUSE_OUT, outHdl);
			indexTf.mouseEnabled = false;
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
			indexTf.text = "";
			nameTf.text = "";
			roleTf.text = "";
			levelTf.text = "";
			dedicatedPointTf.text = "";
			var color:uint = 0xFFFFFF;
			indexTf.textColor = color;
			nameTf.textColor = color;
			roleTf.textColor = color;
			levelTf.textColor = color;
			dedicatedPointTf.textColor = color;
		}
		
		public function update(info:GuMemberInfo):void
		{
			this.info = info;
			var color:uint;
			if (info.nPlayerID == Game.database.userdata.userID) 
			{
				this.mouseEnabled = false;
				this.mouseChildren = false;
				color = 0xFFFF00;
			}
			else 
			{
				this.mouseEnabled = true;
				this.mouseChildren = true;
				
				color = info.nOfflineTime > 0 ? 0xCCCCCC : 0xFFFFFF;
			}
			this.buttonMode = true;
			indexTf.text = info.index.toString();
			nameTf.text = info.strRoleName;
			levelTf.text = info.nLevel.toString();
			roleTf.text = GuildUtils.getRoleName(info.nMemberType);
			dedicatedPointTf.text = info.nTotalDedicationPoint.toString();
			
			indexTf.textColor = color;
			nameTf.textColor = color;
			roleTf.textColor = color;
			levelTf.textColor = color;
			dedicatedPointTf.textColor = color;
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