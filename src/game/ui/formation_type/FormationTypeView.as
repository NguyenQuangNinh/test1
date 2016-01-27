package game.ui.formation_type
{
	import core.display.ViewBase;
	import core.event.EventEx;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import game.data.vo.formation.FormationStat;
	import game.data.xml.DataType;
	import game.data.xml.FormationTypeXML;
	import game.Game;
	import game.enum.Direction;
	import game.net.IntRequestPacket;
	import game.net.lobby.LobbyRequestType;
	import game.ui.formation_type.gui.FormationTypeContainer;
	import game.ui.formation_type.gui.FormationTypeContent;
	import game.ui.formation_type.gui.FormationTypeItem;
	import game.utility.UtilityUI;
	
	/**
	 * ...
	 * @author anhtinh/chuongth2
	 */
	public class FormationTypeView extends ViewBase
	{
		private var closeBtn:SimpleButton;
		public var formationTypeContainer:FormationTypeContainer;
		public var formationTypeContent:FormationTypeContent;
		
		private var currentFomationTypeID:int = -1;
		
		public function FormationTypeView()
		{
			closeBtn = UtilityUI.getComponent(UtilityUI.CLOSE_BTN) as SimpleButton;
			
			if (closeBtn != null)
			{
				closeBtn.x = Game.WIDTH - 2 * closeBtn.width - 140;
				closeBtn.y = 2 * closeBtn.height + 40;
				addChild(closeBtn);
				closeBtn.addEventListener(MouseEvent.CLICK, onBtnCloseHandler);
			}
			
			this.addEventListener(FormationTypeItem.EVENT_SELECT_FORMATION_TYPE, onSelectFormationType);
			this.addEventListener(FormationTypeItem.EVENT_ACTIVE_FORMATION_TYPE, activeFormationTypeHandler);
		
		}
		
		private function activeFormationTypeHandler(e:EventEx):void
		{
			var obj:Object = e.data as Object;
			if (!obj)
				return;
			var nID:int = obj.nID;
			if (nID > 0)
			{
				currentFomationTypeID = nID;
				Game.network.lobby.sendPacket(new IntRequestPacket(LobbyRequestType.ACTIVE_FORMATION_TYPE, nID));
			}
		}
		
		private function onSelectFormationType(e:EventEx):void
		{
			var obj:Object = e.data as Object;
			if (!obj)
				return;
			var nID:int = obj.nID;
			var nIndex:int = obj.nIndex;
			//set status
			if (nID > 0)
			{
				var arrFormationType:Array = Game.database.userdata.arrFormationType;
				var flag:Boolean = false;
				for each (var objTemp:Object in arrFormationType)
				{
					if (objTemp.id == nID)
					{
						flag = true;
						break;
					}
				}
				if (flag)
					formationTypeContainer.setStatus(nIndex, FormationTypeItem.ACTIVE);
				else
					formationTypeContainer.setStatus(nIndex, FormationTypeItem.LOCK);
				currentFomationTypeID = nID;
				formationTypeContainer.resetFormationTypeContainer(false);
				this.showContent();
			}
		}
		
		private function onBtnCloseHandler(e:Event):void
		{
			this.dispatchEvent(new EventEx(FormationTypeModule.CLOSE_FORMATION_TYPE_VIEW));
		}
		
		public function init():void
		{
			formationTypeContainer.init();
		}
		
		public function reset():void
		{
			currentFomationTypeID = -1;
			formationTypeContent.reset();
			formationTypeContainer.reset();
		}
		
		private function showContent():void
		{
			if (currentFomationTypeID > 0)
			{
				var nCurrentLevel:int = Game.database.userdata.level;
				var formationTypeXML:FormationTypeXML = Game.database.gamedata.getData(DataType.FORMATION_TYPE, currentFomationTypeID) as FormationTypeXML;
				if (formationTypeXML)
				{
					var objFormationType:Object = Game.database.userdata.getFormationTypeByID(currentFomationTypeID);
					if (objFormationType)
					{
						//show content
						formationTypeContent.showContent(formationTypeXML, objFormationType.level, nCurrentLevel);
					}
					else
					{
						//troll
						formationTypeContent.showContent(formationTypeXML, 0, nCurrentLevel);
							//formationTypeContent.reset();
					}
				}
			}
		}
		
		public function activeStatusFormationTypeContainer(deactive:Boolean):void
		{
			formationTypeContainer.activeStatusFormationTypeContainer(currentFomationTypeID, deactive);
			formationTypeContent.reUpdate();
		}
		
		public function preShowContent():void
		{
			showContent();
			var item:FormationTypeItem = formationTypeContainer.getFormationTypeItemByID(currentFomationTypeID);
			if (item)
			{
				var objFormationType:Object = Game.database.userdata.getFormationTypeByID(currentFomationTypeID);
				if (objFormationType)
					item.descriptionTf.text = "Cấp trận hình: " + objFormationType.level;
			}
		}

		//TUTORIAL

		public function showHint():void
		{
			if(currentFomationTypeID == -1)
			{
				showHintByIndex(0);
			}
			else
			{
				var button:SimpleButton = formationTypeContent.btnUpgrade;
				Game.hint.showHint(button, Direction.UP, button.x + button.width/2, button.y + button.height, "Nâng cấp Trận Hình");
			}
		}

		public function showHintByIndex(index:int):void
		{
			var item:FormationTypeItem = formationTypeContainer.getItemAt(index);
			if(item)
			{
				Game.hint.showHint(item, Direction.RIGHT, item.x, item.y + item.height/2, "Chọn Trận Hình");
			}
		}
	}

}