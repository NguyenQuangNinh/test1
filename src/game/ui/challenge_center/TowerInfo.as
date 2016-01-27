package game.ui.challenge_center
{
	import core.event.EventEx;
	import core.util.FontUtil;
	
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import game.enum.Font;
	
	public class TowerInfo extends MovieClip
	{
		public static const ENTER_TOWER:String = "enter_tower";
		public static const AUTOPLAY:String = "autoplay";
		
		public var txtName:TextField;
		public var txtPeakFloor:TextField;
		public var txtCurrentFloor:TextField;
		public var btnEnter:SimpleButton;
		public var btnAuto:SimpleButton;
		public var locked:MovieClip;
		
		private var data:HeroicTowerData;
		
		public function TowerInfo():void
		{
			locked.visible = false;
			
			FontUtil.setFont(txtPeakFloor, Font.TAHOMA, true);
			FontUtil.setFont(txtName, Font.TAHOMA, true);
			FontUtil.setFont(txtCurrentFloor, Font.TAHOMA, true);
			
			btnEnter.addEventListener(MouseEvent.CLICK, btnEnter_onClicked);
			btnAuto.addEventListener(MouseEvent.CLICK, btnAuto_onClicked);
		}
		
		protected function btnAuto_onClicked(event:MouseEvent):void
		{
			if(data != null)
			{
				dispatchEvent(new EventEx(AUTOPLAY, data.getXMLData().ID, true));
			}
		}
		
		protected function btnEnter_onClicked(event:MouseEvent):void
		{
			if(data != null)
			{
				dispatchEvent(new EventEx(ENTER_TOWER, data.getXMLData().ID, true));
			}
		}
		
		public function setData(data:HeroicTowerData):void
		{
			this.data = data;
			if(data != null)
			{
				data.addEventListener(HeroicTowerData.UPDATE, onDataChanged);
				update();
			}
		}
		
		protected function onDataChanged(event:Event):void
		{
			update();
		}
		
		public function update():void
		{
			if(data != null && data.getXMLData() != null)
			{
				txtName.text = data.getXMLData().name;
				txtPeakFloor.text = data.getMaxFloor().toString();
				txtCurrentFloor.text = data.getCurrentFloor().toString();
			}
		}
	}
}