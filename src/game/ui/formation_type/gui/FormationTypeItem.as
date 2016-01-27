package game.ui.formation_type.gui
{
	import com.greensock.TweenMax;
	import core.display.BitmapEx;
	import core.event.EventEx;
	import core.util.FontUtil;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	import game.Game;
	import game.data.xml.FormationTypeXML;
	import game.enum.Font;
	import game.ui.tutorial.TutorialEvent;

	/**
	 * ...
	 * @author chuongth2
	 */
	public class FormationTypeItem extends MovieClip
	{
		public static const NORMAL:String = "normal";
		public static const ACTIVE:String = "active";
		public static const LOCK:String = "lock";
		
		public static const EVENT_SELECT_FORMATION_TYPE:String = "event_select_formation_type";
		public static const EVENT_ACTIVE_FORMATION_TYPE:String = "event_active_formation_type";
		
		public var nameTf:TextField;
		public var descriptionTf:TextField;
		public var activeTf:TextField;
		public var btnActive:SimpleButton;
		public var btnRemove:SimpleButton;
		public var hitMovie:MovieClip;
		
		private var iconBmp:BitmapEx;
		private var _bUsing:Boolean;
		public var nFormationTypeID:int = 0;
		public var nIndex:int = -1;
		public var _isLock:Boolean = false; //chua co tran hinh nay
		
		public var levelUnlock:int = 0;
		
		public function FormationTypeItem()
		{
			FontUtil.setFont(nameTf, Font.ARIAL, true);
			FontUtil.setFont(descriptionTf, Font.ARIAL);
			FontUtil.setFont(activeTf, Font.ARIAL, true);
			bUsing = false;
			this.setStatus(NORMAL);
			
			iconBmp = new BitmapEx();
			iconBmp.x = 8;
			iconBmp.y = 9;
			this.addChild(iconBmp);
			hitMovie.buttonMode = true;
			hitMovie.addEventListener(MouseEvent.CLICK, onHitHandler);
			btnActive.addEventListener(MouseEvent.CLICK, onActiveHandler);
			btnRemove.addEventListener(MouseEvent.CLICK, onRemoveHandler);
			btnRemove.visible = false;
			btnActive.visible = false;
		}
		
		private function onRemoveHandler(e:Event):void
		{
			if (this.currentLabel == LOCK)
				return;
			var obj:Object = [];
			obj.nID = nFormationTypeID;
			this.dispatchEvent(new EventEx(EVENT_ACTIVE_FORMATION_TYPE, obj, true));
		}
		
		private function onActiveHandler(e:Event):void
		{
			if (this.currentLabel == LOCK)
				return;
			var obj:Object = [];
			obj.nID = nFormationTypeID;
			this.dispatchEvent(new EventEx(EVENT_ACTIVE_FORMATION_TYPE, obj, true));
		}
		
		private function onHitHandler(e:Event):void
		{
			//if (this.currentLabel == LOCK)
			//return;
			
			var obj:Object = [];
			obj.nID = nFormationTypeID;
			obj.nIndex = nIndex;
			this.dispatchEvent(new EventEx(EVENT_SELECT_FORMATION_TYPE, obj, true));
			Game.stage.dispatchEvent(new EventEx(TutorialEvent.EVENT, {type: TutorialEvent.SELECT_FORMATION_TYPE}, true));
		}
		
		public function setStatus(val:String):void
		{
			TweenMax.to(this, 0, {alpha: 1, colorMatrixFilter: {saturation: 1}});
			switch (val)
			{
				case NORMAL: 
					btnActive.visible = false;
					this.gotoAndStop(val);
					break;
				case ACTIVE: 
					btnActive.visible = !_bUsing;
					btnRemove.visible = _bUsing;
					this.gotoAndStop(val);
					break;
				case LOCK: 
					btnActive.visible = false;
					TweenMax.to(this, 0, {alpha: 1, colorMatrixFilter: {saturation: 0}});
					this.gotoAndStop(val);
					break;
				default: 
					this.gotoAndStop(NORMAL);
					break;
			}
		}
		
		public function get bUsing():Boolean
		{
			return _bUsing;
		}
		
		public function set bUsing(value:Boolean):void
		{
			_bUsing = value;
			activeTf.visible = value;
		}
		
		public function init(formationTypeXML:FormationTypeXML, nCurrentLevel:int, element:int, levelFormationType:int, using:Boolean, isLock:Boolean):void
		{
			if (formationTypeXML)
			{
				levelUnlock = formationTypeXML.arrLevelUnlock[element];
				nFormationTypeID = formationTypeXML.ID;
				nameTf.text = formationTypeXML.name.toLocaleUpperCase();
				iconBmp.load(formationTypeXML.iconUrl);
				if (isLock)
				{
					descriptionTf.text = "(Cấp level " + formationTypeXML.arrLevelUnlock[element] + " mở)";
					setStatus(LOCK);
					_isLock = true;
				}
				else
				{
					if (nCurrentLevel >= formationTypeXML.arrLevelUnlock[element])
					{
						descriptionTf.text = "Cấp trận hình: " + levelFormationType;
						setStatus(NORMAL);
						_isLock = false;
					}
				}
				bUsing = using;
			}
		}
	
	}

}