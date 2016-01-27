package game.ui.guild.popups 
{
	import components.enum.PopupAction;
	import components.popups.OKCancelPopup;
	import components.scroll.VerScroll;
	import core.Manager;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import game.Game;
	import game.net.IntRequestPacket;
	import game.net.lobby.LobbyRequestType;
	import game.net.lobby.request.RequestGetListFromTo;
	import game.net.lobby.response.data.GuMemberInfo;
	import game.net.RequestPacket;
	/**
	 * ...
	 * @author vu anh
	 */
	public class RefusePresidentPopup extends OKCancelPopup
	{
		
		public var scrollMov:MovieClip;
		public var masker:MovieClip;
		public var list:MovieClip;
		public var scroller:VerScroll;
		public var activeItem:MemberItem2;
		
		public function RefusePresidentPopup() 
		{
			scroller = new VerScroll(masker, list, scrollMov);
		}
		
		override public function show(callback:Function = null, title:String = "", msg:String = "", data:Object = null, isHideCancelBtn:Boolean = false):void
		{
			super.show(callback, title, msg, data);
			Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.GU_GET_ELDER_LIST));
		}
		
		public function updateList(arr:Array):void
		{
			var item:MemberItem2;
			while (list.numChildren)
			{
				item = list.removeChildAt(0) as MemberItem2;
				item.removeEventListener(MouseEvent.CLICK, itemHdl);
				Manager.pool.push(item);
			}
			var info:GuMemberInfo;
			
			var posY:Number = 20;
			for (var i:int = 0; i < arr.length; i++) 
			{
				info = arr[i] as GuMemberInfo;
				item = Manager.pool.pop(MemberItem2) as MemberItem2;
				item.x = 0;
				item.y = posY;
				posY += 29;
				list.addChild(item);
				item.update(info);
				item.addEventListener(MouseEvent.CLICK, itemHdl);
			}
			//list.y = masker.y;
			//scroller.updateScroll(list.height + 20);
		}
		
		private function itemHdl(e:MouseEvent):void 
		{
			if (activeItem) activeItem.deactive();
			activeItem = MemberItem2(e.currentTarget);
			activeItem.active();
		}
		
		override protected function okBtnClickHdl(e:Event):void 
		{
			//hide(PopupAction.OK);
			if (!activeItem) 
			{
				Manager.display.showMessage("Bạn vui lòng chọn người kế nhiệm");
				return;
			}
			
			GuildPopupMng.messagePopup.show(onRefusePresidentConfirmHdl, "", "Bạn có muốn nhường vị trí bang chủ cho thành viên: " + activeItem.info.strRoleName + "?");
		}
		
		private function onRefusePresidentConfirmHdl(action:int, data:Object):void 
		{
			if (action == PopupAction.OK)
			{
				Game.network.lobby.sendPacket(new IntRequestPacket(LobbyRequestType.GU_PROMOTE_TO_PRESIDENT, activeItem.info.nPlayerID));
				hide(PopupAction.OK);
			}
		}
	}

}