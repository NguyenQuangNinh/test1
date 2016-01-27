package game.ui.present.gui
{
	import com.greensock.TweenMax;
	import core.event.EventEx;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import game.data.xml.DataType;
	import game.data.xml.ShopXML;
	import game.data.xml.VIPConfigXML;
	import game.enum.ShopID;
	import game.Game;
	
	/**
	 * ...
	 * @author chuongth2
	 */
	public class ContainerCaoThu extends MovieClip
	{
		public static const CHANGE_SELECT:String = "container_change_select";
		
		public var btnLeft:SimpleButton;
		public var btnRight:SimpleButton;
		
		private var arrCaoThu:Array = [];
		private var _nCurrentIndex:int = -1;
		
		private var arrPos:Array = [50, 230, 450];
		
		public function ContainerCaoThu()
		{
			btnLeft.addEventListener(MouseEvent.CLICK, onLeftClick);
			btnRight.addEventListener(MouseEvent.CLICK, onRightClick);
		}
		
		private function onLeftClick(e:Event):void
		{
			if (nCurrentIndex > 0)
			{
				if (nCurrentIndex + 1 < arrCaoThu.length)
				{
					this.removeChild(arrCaoThu[nCurrentIndex + 1]);
				}
				
				if (nCurrentIndex - 2 >= 0)
				{
					this.addChild(arrCaoThu[nCurrentIndex - 2]);
					arrCaoThu[nCurrentIndex - 2].x = arrPos[0];
				}
				
				this.effectCaoThu(arrCaoThu[nCurrentIndex], false);
				arrCaoThu[nCurrentIndex].x = arrPos[2];
				
				if (nCurrentIndex - 1 >= 0)
				{
					this.effectCaoThu(arrCaoThu[nCurrentIndex - 1], true);
					arrCaoThu[nCurrentIndex - 1].x = arrPos[1];
				}
				
				nCurrentIndex--;
				this.dispatchEvent(new EventEx(CHANGE_SELECT, null, true));
			}
		}
		
		private function onRightClick(e:Event):void
		{
			if (nCurrentIndex < arrCaoThu.length - 1)
			{
				if (nCurrentIndex - 1 >= 0)
				{
					this.removeChild(arrCaoThu[nCurrentIndex - 1]);
				}
				
				if (nCurrentIndex + 2 < arrCaoThu.length)
				{
					this.addChild(arrCaoThu[nCurrentIndex + 2]);
					arrCaoThu[nCurrentIndex + 2].x = arrPos[2];
				}
				
				this.effectCaoThu(arrCaoThu[nCurrentIndex], false);
				arrCaoThu[nCurrentIndex].x = arrPos[0];
				
				if (nCurrentIndex + 1 < arrCaoThu.length)
				{
					this.effectCaoThu(arrCaoThu[nCurrentIndex + 1], true);
					arrCaoThu[nCurrentIndex + 1].x = arrPos[1];
				}
				
				nCurrentIndex++;
				this.dispatchEvent(new EventEx(CHANGE_SELECT, null, true));
			}
		}
		
		public function init(nVip:int):void
		{
			var vipXML:VIPConfigXML = Game.database.gamedata.getData(DataType.VIP, nVip) as VIPConfigXML;
			var arrShopXML:Array = [];
			if (vipXML)
			{
				for each (var shopID:int in vipXML.arrItemShopVip)
				{
					var shopXML:ShopXML = Game.database.gamedata.getData(DataType.SHOP, shopID) as ShopXML;
					if (shopXML)
						arrShopXML.push(shopXML);
				}
			}
			
			var index:int = 0;
			for each (var objShopXML:ShopXML in arrShopXML)
			{
				if (objShopXML)
				{
					var itemTf:CaoThuItem = new CaoThuItem();
					if (index == 1)
					{
						nCurrentIndex = 1;
						this.effectCaoThu(itemTf, true);
					}
					else
						itemTf.scaleX = itemTf.scaleY = 0.8;
					
					itemTf.init(objShopXML);
					if (index < 3)
					{
						itemTf.x = arrPos[index];
						this.addChild(itemTf);
					}
					
					itemTf.y = 100;
					arrCaoThu.push(itemTf);
					
					index++;
				}
			}
			this.dispatchEvent(new EventEx(CHANGE_SELECT, null, true));
		}
		
		public function reset():void
		{
			if (nCurrentIndex > 0 && nCurrentIndex < arrCaoThu.length)
			{
				if (nCurrentIndex - 1 >= 0)
					this.removeChild(arrCaoThu[nCurrentIndex - 1]);
				
				this.removeChild(arrCaoThu[nCurrentIndex]);
				
				if (nCurrentIndex + 1 < arrCaoThu.length)
					this.removeChild(arrCaoThu[nCurrentIndex + 1]);
			}
			
			for each (var itemTf:CaoThuItem in arrCaoThu)
			{
				if (itemTf)
				{
					itemTf.reset();
				}
			}
			arrCaoThu = [];
			nCurrentIndex = -1;
		}
		
		private function effectCaoThu(itemTf:CaoThuItem, val:Boolean):void
		{
			if (val)
			{
				itemTf.scaleX = itemTf.scaleY = 1;
				TweenMax.to(itemTf, 0.3, {glowFilter: {color: 0xffff00, alpha: 1, blurX: 30, blurY: 30, strength: 1, quality: 5}});
			}
			else
			{
				itemTf.scaleX = itemTf.scaleY = 0.8;
				TweenMax.to(itemTf, 0, {glowFilter: {remove: true}});
			}
		}
		
		public function get nCurrentIndex():int
		{
			return _nCurrentIndex;
		}
		
		public function set nCurrentIndex(value:int):void
		{
			_nCurrentIndex = value;
		}
		
		public function getCaoThuItem():CaoThuItem
		{
			if (_nCurrentIndex >= 0 && _nCurrentIndex < arrCaoThu.length)
				return arrCaoThu[_nCurrentIndex];
			return null;
		}
		
		public function grayCaoThu(shopItemID:int):void
		{
			for each (var itemTf:CaoThuItem in arrCaoThu)
			{
				if (itemTf &&itemTf.shopXML.ID == shopItemID)
				{
					TweenMax.to(itemTf, 0, {alpha: 1, colorMatrixFilter: {saturation: 0}});
				}
			}
		}
	}

}