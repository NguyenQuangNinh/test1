package game.ui.formation_type.gui
{
	import com.adobe.protocols.dict.Dict;
	import flash.display.MovieClip;
	import flash.utils.Dictionary;
	import game.data.model.Character;
	import game.data.vo.formation.FormationStat;
	import game.data.xml.DataType;
	import game.data.xml.FormationTypeXML;
	import game.Game;
	import game.enum.Direction;
	import game.ui.components.ScrollbarEx;
	
	/**
	 * ...
	 * @author chuongth2
	 */
	public class FormationTypeContainer extends MovieClip
	{
		
		public var contentMask:MovieClip;
		public var track:MovieClip;
		public var slider:MovieClip;
		
		private var _contentScrollBar:MovieClip = new MovieClip();
		private var _arrFormationTypeItem:Array = [];
		private var _previousIndex:int = -1;
		
		private var scrollbar:ScrollbarEx;
		
		public function FormationTypeContainer()
		{
			contentMask.visible = false;
			scrollbar = new ScrollbarEx();
			_contentScrollBar.x = 0;
			_contentScrollBar.y = 0;
			this.addChild(_contentScrollBar);
		}
		
		public function setStatus(index:int, value:String):void
		{
			var formationStat:FormationStat = Game.database.userdata.formationStat;
			if (index >= 0 && index < _arrFormationTypeItem.length)
			{
				var ftItem:FormationTypeItem;
				if (_previousIndex != -1)
				{
					ftItem = _arrFormationTypeItem[_previousIndex] as FormationTypeItem;
					if (ftItem._isLock)
						ftItem.setStatus(FormationTypeItem.LOCK);
					else
						ftItem.setStatus(FormationTypeItem.NORMAL);
					ftItem.btnRemove.visible = false;
				}
				_previousIndex = index;
				ftItem = _arrFormationTypeItem[index] as FormationTypeItem;
				ftItem.setStatus(value);
				ftItem.btnRemove.visible = ftItem.bUsing;
			}
		}
		
		public function init():void
		{
			while (_contentScrollBar.numChildren > 0)
			{
				_contentScrollBar.removeChildAt(0);
			}
			_arrFormationTypeItem = [];
			
			var nCurrentLevel:int = Game.database.userdata.level;
			
			var tableFormationType:Dictionary = Game.database.gamedata.getTable(DataType.FORMATION_TYPE);
			
			var arrFormationType:Array = Game.database.userdata.arrFormationType;
			var formationStat:FormationStat = Game.database.userdata.formationStat;
			
			var mainCharacter:Character = Game.database.userdata.mainCharacter;
			if (mainCharacter)
			{
				for each (var formationTypeXML:FormationTypeXML in tableFormationType)
				{
					var ftItem:FormationTypeItem = new FormationTypeItem();
					var flag:Boolean = false;
					for (var i:int = 0; i < arrFormationType.length; i++)
					{
						if (formationTypeXML.ID == arrFormationType[i].id)
						{
							var bUsing:Boolean = formationTypeXML.ID == formationStat.ID; //current using
							ftItem.init(formationTypeXML, nCurrentLevel, mainCharacter.element, arrFormationType[i].level, bUsing, false);
							flag = true;
							break;
						}
					}
					if (!flag)
					{
						ftItem.init(formationTypeXML, nCurrentLevel, mainCharacter.element, 0, false, true);
					}

					if(formationTypeXML.enable) _arrFormationTypeItem.push(ftItem);
				}
				//sort by level unlock
				(_arrFormationTypeItem).sortOn("levelUnlock", Array.NUMERIC);
				var index:int = 0;
				for each(var ftItemObj:FormationTypeItem in _arrFormationTypeItem)
				{
					ftItemObj.x = 0;
					ftItemObj.y = 57 * index;
					ftItemObj.nIndex = index++;
					_contentScrollBar.addChild(ftItemObj);
				}
			}
			scrollbar.init(_contentScrollBar, contentMask, track, slider);
			scrollbar.verifyHeight();
		}
		
		public function reset():void
		{
			_previousIndex = -1;
		}
		
		public function activeStatusFormationTypeContainer(formationTypeID:int, deactive:Boolean):void
		{
			for each (var ftItem:FormationTypeItem in _arrFormationTypeItem)
			{
				if (formationTypeID > 0)
				{
					ftItem.bUsing = ftItem.nFormationTypeID == formationTypeID;
					if (ftItem.nFormationTypeID == formationTypeID)
					{
						ftItem.btnRemove.visible = deactive;
						ftItem.btnActive.visible = !deactive;
						ftItem.bUsing = deactive;
					}
					else
						ftItem.btnRemove.visible = false;
					
				}
			}
		}
		
		public function resetFormationTypeContainer(val:Boolean):void
		{
			for each (var ftItem:FormationTypeItem in _arrFormationTypeItem)
			{
				if (!ftItem.bUsing)
					ftItem.btnRemove.visible = val;
			}
		}
		
		public function getFormationTypeItemByID(formationTypeID:int):FormationTypeItem
		{
			for each (var obj:FormationTypeItem in _arrFormationTypeItem)
			{
				if (obj.nFormationTypeID == formationTypeID)
					return obj;
			}
			return null;
		}

		//TUTORIAL

		public function getItemAt(index:int):FormationTypeItem
		{
			return _arrFormationTypeItem[index];
		}
	}

}