package game.dragdrop
{
	import core.Manager;
	import core.util.Utility;
	import flash.display.Shape;
	import game.data.model.item.Item;
	import game.ui.inventoryitem.InventoryItemView;
	
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import game.Game;
	import game.data.model.Character;
	import game.data.model.item.SoulItem;
	import game.enum.DragDropEvent;
	import game.enum.FlowActionEnum;
	import game.ui.ModuleID;
	import game.ui.heroic.lobby.HeroicLobbyModule;
	import game.ui.heroic.lobby.HeroicLobbyView;
	import game.ui.quest_transport.QuestTransportView;
	import game.ui.soul_center.SoulCenterView;
	
	/**
	 * ...
	 * @author TrungLNM
	 */
	public class DragDropManager
	{
		private var _stage:Stage;
		private var _isDragging:Boolean = false;
		private var _objInfo:Object;
		
		public function DragDropManager()
		{
			_stage = Manager.display.getStage();
		}
		
		public function start(target:DisplayObject, info:Object):void
		{
			_isDragging = true;
			_stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMoveHdl);
			_stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUpHdl);
			
			_objInfo = info;
			if (_objInfo != null)
			{
				var objDrag:DisplayObject = target as DisplayObject;
				
				/*if (_objInfo["coordinate"] && _objInfo["coordinate"] == "center") {
				   objDrag.x = _objInfo.x;
				   objDrag.y = _objInfo.y;
				   }else {
				   //objDrag.x = _objInfo.x - objDrag.width / 2;
				   //objDrag.y = _objInfo.y - objDrag.height / 2;
				 }*/
				objDrag.x = _objInfo.x;
				objDrag.y = _objInfo.y;
				
				_stage.addChild(objDrag);
			}
			else
			{
				Utility.log("can not start drag by NULL object info");
			}
		}
		
		private function onMouseUpHdl(e:MouseEvent):void
		{
			if (_isDragging)
			{
				//Utility.log("stop drag");
				_isDragging = false;
				_stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMoveHdl);
				_stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUpHdl);
				
				var objDrag:DisplayObject = _stage.getChildByName("mov_drag");
				_stage.removeChild(objDrag);
				
				//var bound:Object = {x: objDrag.x, y: objDrag.y, w: objDrag.width, h:objDrag.height };
				//var box:Rectangle = new Rectangle(objDrag.x * 1.1, objDrag.y * 1.1, FormationSlot.ICON_WIDTH, FormationSlot.ICON_HEIGHT);
				var box:Rectangle = new Rectangle(objDrag.x + objDrag.height * 0.15, objDrag.y + objDrag.width * 0.15, objDrag.height * 0.7, objDrag.width * 0.7);
				
				/*var rectangle:Shape = new Shape(); // initializing the variable named rectangle
				   rectangle.graphics.beginFill(0xFF0000); // choosing the colour for the fill, here it is red
				   rectangle.graphics.drawRect(objDrag.x + objDrag.height * 0.15, objDrag.y + objDrag.width * 0.15, objDrag.height * 0.7, objDrag.width * 0.7); // (x spacing, y spacing, width, height)
				   rectangle.graphics.endFill(); // not always needed but I like to put it in to end the fill
				   rectangle.alpha = 0.3;
				 _stage.addChild(rectangle); // adds the rectangle to the stage*/
				
				//here check hit collision to update inventory or formation
				switch (_objInfo.type)
				{
					case DragDropEvent.TYPE_CHANGE_FORMATION: 
					case DragDropEvent.TYPE_CHANGE_FORMATION_CHALLENGE: 
						//Game.flow.changeFormation(_objInfo, bound);
						Game.flow.doAction(FlowActionEnum.CHANGE_FORMATION, {info: _objInfo, bound: box});
						break;
					
					case DragDropEvent.FROM_HEROIC_FORMATION: 
						HeroicLobbyView(HeroicLobbyModule(Manager.module.getModuleByID(ModuleID.HEROIC_LOBBY)).baseView).changeRoomFormation(_objInfo, box);
						break;
					
					case DragDropEvent.CHARACTER_LEVEL_UP: 
						//(LevelUpModule)(Manager.module.getModuleByID(ModuleID.LEVEL_UP))
						//				.insertCharacterDragAction(_objInfo, box);
						break;
					
					case DragDropEvent.REMOVE_FROM_ENHANCEMENT_LIST: 
					case DragDropEvent.REMOVE_CHARACTER_LEVEL_UP: 
						//(LevelUpModule)(Manager.module.getModuleByID(ModuleID.LEVEL_UP))
						//	.removeCharacterDragAction(_objInfo.data);
						break;
					
					case DragDropEvent.FROM_SOUL_INVENTORY: 
						//check hit
						var soulCenterView:SoulCenterView = Manager.module.getModuleByID(ModuleID.SOUL_CENTER).baseView as SoulCenterView;
						if (soulCenterView != null)
						{
							var dragObj:DisplayObject = _objInfo.target as DisplayObject;
							var soulItem:SoulItem = _objInfo.data as SoulItem;
							soulCenterView.checkHitDragFromInventory(dragObj, soulItem);							
						}
						break;
					
					/*case DragDropEvent.FROM_MERGE_SOUL: 
						//check hit
						soulCenterView = Manager.module.getModuleByID(ModuleID.SOUL_CENTER).view as SoulCenterView;
						if (soulCenterView != null)
						{
							dragObj = _objInfo.target as DisplayObject;
							soulItem = _objInfo.data as SoulItem;
							var nodeIndex:int = _objInfo.nodeIndex;
							soulCenterView.checkHitDragFromMergeSoul(dragObj, soulItem, nodeIndex);							
						}
						break;*/
						
					case DragDropEvent.FROM_NODE_OF_CHARACTER: 
						//check hit
						soulCenterView = Manager.module.getModuleByID(ModuleID.SOUL_CENTER).baseView as SoulCenterView;
						if (soulCenterView != null)
						{
							dragObj = _objInfo.target as DisplayObject;
							soulItem = _objInfo.data as SoulItem;
							soulCenterView.checkHitDragFromNodeChain(dragObj, soulItem);							
						}
						break;
					
					case DragDropEvent.FROM_SKILL_UPGRADE: 
						//check hit
						//var skillView:SkillView = Manager.module.getModuleByID(ModuleID.SKILL).view as SkillView;
						//if (skillView != null) {
						//skillView.changeSkillActive(box, _objInfo.data as Skill);
						//}						
						break;
					case DragDropEvent.FROM_QUEST_TRANSPORT: 
						//check hit
						var questView:QuestTransportView = Manager.module.getModuleByID(ModuleID.QUEST_TRANSPORT).baseView as QuestTransportView;
						if (questView != null)
						{
							questView.changeUnitSelected(box, _objInfo.data as Character);
						}
						break;
					case DragDropEvent.FROM_INVENTORY_ITEM: 
						//check hit
						var inventoryItemView:InventoryItemView = Manager.module.getModuleByID(ModuleID.INVENTORY_ITEM).baseView as InventoryItemView;
						if (inventoryItemView != null)
						{
							inventoryItemView.checkHitDragFromItemInventory(objDrag, _objInfo.data as Item);
						}
						break;
						
				}
			}
		}
		
		private function onMouseMoveHdl(e:MouseEvent):void
		{
			if (_isDragging)
			{
				var objDrag:DisplayObject = _stage.getChildByName("mov_drag");
				
				if (_objInfo["coordinate"] && _objInfo["coordinate"] == "center")
				{
					objDrag.x = e.stageX;
					objDrag.y = e.stageY;
				}
				else
				{
					objDrag.x = e.stageX - objDrag.width / 2;
					objDrag.y = e.stageY - objDrag.height / 2;
				}
			}
		}
	
	}

}