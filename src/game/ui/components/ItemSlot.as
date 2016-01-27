package game.ui.components
{
	import core.display.animation.Animator;
	import core.Manager;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormatAlign;
	
	import core.display.BitmapEx;
	import core.event.EventEx;
	import core.util.TextFieldUtil;
	import core.util.Utility;
	
	import game.Game;
	import game.data.model.item.IItemConfig;
	import game.data.xml.CharacterXML;
	import game.data.xml.DataType;
	import game.enum.Font;
	import game.enum.ItemType;
	import game.enum.UnitType;
	import game.ui.tooltip.TooltipEvent;
	import game.ui.tooltip.TooltipID;
	import game.utility.UtilityUI;
	
	/**
	 * ...
	 * @author anhtinh
	 */
	public class ItemSlot extends Sprite
	{
		public static const ICON_LOADED:String = "icon_loaded";
		public static const ITEM_SLOT_DOUBLE_CLICK:String = "item_slot_double_click";
		public static const WIDTH		:int = 50;
		public static const HEIGHT		:int = 50;
		
		private var _quantityTf:TextField;
		private var _bonusText:TextField;
		
		protected var _iconBmp:BitmapEx;
		//protected var _iconAnim:Animator;
		
		private var _itemConfig:IItemConfig;
		private var _toolTipType:String;
		private var _subInfo:Array = [];
		private var _quantity:int;
		private var txtLevel:TextField;
		private var tooltipQuantityVisible:Boolean;
		
		public function ItemSlot()
		{
			_toolTipType = TooltipID.ITEM_COMMON;
			_iconBmp = new BitmapEx();
			_iconBmp.addEventListener(BitmapEx.LOADED, onBitmapLoaded)
			
			//_iconAnim = new Animator();
			//_iconAnim.addEventListener(Animator.LOADED, onAnimLoaded);			
			
			var glow:GlowFilter = new GlowFilter();
			glow.color = 0x000000;
			glow.strength = 4;
			glow.quality = BitmapFilterQuality.HIGH;
			glow.blurX = glow.blurY = 2;
			
			_quantityTf = TextFieldUtil.createTextfield(Font.ARIAL, 12, 70, 20, 0xFFFFFF, true, TextFormatAlign.RIGHT, [glow]);
			_quantityTf.x = -20;
			_quantityTf.y = 40;
			addChild(_quantityTf);
			
			txtLevel = TextFieldUtil.createTextfield(Font.ARIAL, 12, 50, 20, 0xFFFFFF, true, TextFormatAlign.CENTER, [glow]);
			addChild(txtLevel);
			
			this.addEventListener(MouseEvent.DOUBLE_CLICK, onDBClicked);
			doubleClickEnabled = true;
			
			_bonusText = TextFieldUtil.createTextfield(Font.ARIAL, 18, 50, 20, 0x00FF00, true, TextFormatAlign.RIGHT, [glow]);
			//_bonusText.x = 40;
			addChild(_bonusText);
			
		}
		
		override public function get width () : Number
		{
			return WIDTH;
		}
		
		/*private function onAnimLoaded(e:Event):void 
		{
			addChildAt(_iconAnim, 0);
			_iconAnim.play(0);
		}*/
		
		private function onDBClicked(event:MouseEvent):void
		{
			this.dispatchEvent(new EventEx(ITEM_SLOT_DOUBLE_CLICK, null, true));
		}
		
		private function onBitmapLoaded(e:Event):void
		{
			addChildAt(_iconBmp, 0);
			this.dispatchEvent(new Event(ICON_LOADED));
			
			/*var rectangle:Shape = new Shape(); // initializing the variable named rectangle
			rectangle.graphics.beginFill(0xFF0000); // choosing the colour for the fill, here it is red
			rectangle.graphics.drawRect(_iconBmp.x, _iconBmp.y, _iconBmp.width, _iconBmp.height); // (x spacing, y spacing, width, height)
			Utility.log( "ItemSlot.rectangle : " + _iconBmp.x + " // " + _iconBmp.y + " // " + _iconBmp.width + " // " + _iconBmp.height );
			rectangle.graphics.endFill(); // not always needed but I like to put it in to end the fill
			rectangle.alpha = 0.3;
			var local2Global:Point = localToGlobal(new Point(rectangle.x, rectangle.y));
			rectangle.x = local2Global.x;
			rectangle.y = local2Global.y;
			Manager.display.getStage().addChild(rectangle);*/	
		}
		
		public function reset():void
		{
			_quantityTf.text = "";
			_bonusText.text = "";			
			_itemConfig = null;
			_toolTipType = TooltipID.ITEM_COMMON;
			iconBmp.reset();
			this.scaleX = 1;
			this.scaleY = 1;
		}
		
		public function setConfigInfo(info:IItemConfig, typeToolTip:String = "", tooltipQuantityVisible:Boolean = true):void
		{
			this.iconBmp.reset();
			this._itemConfig = info;
			this._toolTipType = typeToolTip != "" ? typeToolTip : _toolTipType;
			this.tooltipQuantityVisible = tooltipQuantityVisible;
			
			if (info != null)
			{
				switch(info.getType())
				{
					case ItemType.UNIT:
                        var characterXML:CharacterXML = Game.database.gamedata.getData(DataType.CHARACTER, info.getID()) as CharacterXML;
                        if (characterXML && characterXML.quality.length >= 1 && characterXML.type != UnitType.MONSTER) {
                            var nCharacterQuality:int = characterXML.quality[0] as int;
                            var bitmapGlow:GlowFilter = new GlowFilter(UtilityUI.getTxtColorUINT(nCharacterQuality, false, false), 1, 5, 5, 2, BitmapFilterQuality.HIGH, false, false);
                            iconBmp.filters = [bitmapGlow];
                            var nCurrentLevel:int = characterXML.beginStar * 12 + characterXML.level;
                            txtLevel.text = "Lv." + nCurrentLevel;
                        }
					break;
					default:
						txtLevel.text = "";
					break;
				}
				//if (info.getIconURL() == "" && info.getAnimURL() != "")
					//_iconAnim.load(info.getAnimURL());
				//else
					//default load bitmap icon
					_iconBmp.load(info.getIconURL());
				
				if (!this.hasEventListener(MouseEvent.ROLL_OVER))
				{
					this.addEventListener(MouseEvent.ROLL_OVER, onRollOverHdl);
				}
				
				if (!this.hasEventListener(MouseEvent.ROLL_OUT))
				{
					this.addEventListener(MouseEvent.ROLL_OUT, onRollOutHdl);
				}
			}
		}
		
		public function setUnitLevel(value:int):void {
			if (value > 0) {
				txtLevel.text = "Lv." + value.toString();
			}
		}
		
		private function onRollOutHdl(e:MouseEvent):void
		{
			dispatchEvent(new EventEx(TooltipEvent.HIDE_TOOLTIP, null, true));
		}
		
		private function onRollOverHdl(e:MouseEvent):void
		{
			if (tooltipQuantityVisible && _quantity) {
				dispatchEvent(new EventEx(TooltipEvent.SHOW_TOOLTIP, {type: _toolTipType, value: _itemConfig, quantity: _quantity}, true));		
			} else {
				dispatchEvent(new EventEx(TooltipEvent.SHOW_TOOLTIP, {type: _toolTipType, value: _itemConfig, quantity: 0}, true));		
			}
		}
		
		public function setTextQuantity(txt:String):void
		{
			_quantityTf.text = txt;
		}
		
		public function setBonusquantity(txt:String):void 
		{
			_bonusText.text = txt;
		}
		
		public function setQuantity(quantity:int, visible:Boolean = true ):void
		{
			_quantity = quantity;
			_quantityTf.text = Utility.math.formatInteger(quantity);
			_quantityTf.visible = visible;
		}
		
		public function setScaleItemSlot(scale:Number):void
		{
			iconBmp.scaleX = iconBmp.scaleY = scale;
			_quantityTf.y = 40 * scale;
		}
		
		public function getItemType():ItemType
		{
			return _itemConfig.getType();
		}
		
		public function getItemConfig():IItemConfig
		{
			return _itemConfig;
		}
		
		public function get iconBmp():BitmapEx
		{
			return _iconBmp;
		}
		
		public function get quantity():int {
			return _quantity;
		}
	}

}