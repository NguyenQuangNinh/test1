/**
 * Created by NinhNQ on 12/25/2014.
 */
package game.ui.express.gui
{

	import core.event.EventEx;
	import core.util.FontUtil;

	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;

	import game.data.model.Character;
	import game.data.vo.express.PorterVO;

	import game.enum.Font;
	import game.enum.PorterType;
	import game.ui.express.ExpressView;
	import game.utility.GameUtil;
	import game.utility.UtilityUI;

	public class Porter extends MovieClip
	{
		public var image:MovieClip;
		public var owner:MovieClip;
		public var typeTf:TextField;
		public var type:PorterType;
		private var _data:PorterVO;

		public function Porter()
		{
			FontUtil.setFont(typeTf, Font.ARIAL, true);
			FontUtil.setFont(ownerNameTf, Font.ARIAL, true);

			ownerNameTf.autoSize = TextFieldAutoSize.LEFT;
			typeTf.visible = false;
			ownerElement.gotoAndStop(1);
			image.gotoAndStop(1);

			addEventListener(MouseEvent.CLICK, selectPorterHdl)

		}

		private function selectPorterHdl(event:MouseEvent):void
		{
			if(_data)
			{
				dispatchEvent(new EventEx(ExpressView.SELECT_PORTER, _data.playerID, true));
			}
		}

		public function setData(data:PorterVO):void
		{
			_data = data;
			setType(data.porterType);
			ownerNameTf.text = data.name;
			ownerElement.gotoAndStop(data.element);
		}

		public function setType(type:PorterType, showTypeName:Boolean = false):void
		{
			this.type = type;
			owner.visible = !showTypeName;
			typeTf.visible = showTypeName;
			typeTf.text = type.name;
			typeTf.textColor = type.color;
			image.gotoAndStop(type.ID);
		}

		public function setHighlight(value:Boolean):void
		{
			if(value)
			{
				this.filters = [GameUtil.glowFilterYellow];
			}
			else
			{
				this.filters = [];
			}
		}

		private function get ownerNameTf():TextField
		{
			return owner.nameTf as TextField;
		}

		private function get ownerElement():MovieClip
		{
			return owner.element as MovieClip;
		}
	}
}
