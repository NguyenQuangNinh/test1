package core.display
{

	import core.Manager;
	import core.display.layer.Layer;
	import core.display.layer.LayerManager;
	import core.enum.Align;
	import core.event.EventEx;
	import core.util.Utility;
	import flash.utils.Dictionary;
	import game.Game;
	import game.ui.hud.HUDModule;

	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	import game.ui.ModuleID;
	import game.ui.dialog.DialogModule;
	import game.ui.message.MessageModule;
	import game.ui.tooltip.TooltipEvent;
	import game.ui.waitting.WaittingModule;

	/**
	 * ...
	 * @author ninhnq
	 */
	public class DisplayManager extends EventDispatcher
	{
		public static const CHANGE_SCREEN:String = "changeScreen";
		public static var SCREEN_WIDTH:int;
		public static var SCREEN_HEIGHT:int;
		private var previousModule:ModuleBase;
		private var keepedModuleMap:Dictionary;
		private var hudModuleMap:Dictionary;

		public function DisplayManager(stage:Stage, gameWidth:int, gameHeight:int)
		{
			this.stage = stage;
			SCREEN_WIDTH = stage.stageWidth;
			SCREEN_HEIGHT = stage.stageHeight;
			stage.stageFocusRect = false;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.addEventListener(Event.RESIZE, onResize);
			width = gameWidth;
			height = gameHeight;
			container = new Sprite();
			container.mouseEnabled = false;
			container.graphics.beginFill(0, 0);
			container.graphics.drawRect(0, 0, width, height);
			container.scrollRect = new Rectangle(0, 0, width, height);
			stage.addChild(container);
			
			keepedModuleMap = new Dictionary();
			//keepedModuleMap[ModuleID.ARENA] = true;
			keepedModuleMap[ModuleID.QUEST_DAILY] = true;
			keepedModuleMap[ModuleID.QUEST_MAIN] = true;
			//keepedModuleMap[ModuleID.QUEST_TRANSPORT] = true;
			
			hudModuleMap = new Dictionary();
			hudModuleMap[ModuleID.QUEST_MAIN] = true;
			hudModuleMap[ModuleID.QUEST_DAILY] = true;
			
			onResize(null);
		}
		
		private var queue:Array = [];
		private var actionQueue:Array = [];
		private var history:Array = [];
		private var currentScreen:ModuleID;
		private var width:int;
		private var height:int;
		private var container:Sprite;
		private var stage:Stage;

		/**
		 * Hien 1 dialog co id nao do
		 * @param    dialogID
		 * @param    oKCallback
		 * @param    cancelCallback
		 * @param    dialogData Thong tin truyen cho Dialog. Data nay cung se duoc truyen vao param cua oKCallback va cancelCallback.
		 * @param    block Co khoa cac UI ben duoi hay khong.
		 */
		
		public function isModulePrevious(mID:ModuleID):Boolean
		{
			if (!previousModule) return false;
			return mID == previousModule.id;
		}
		
		public function showDialog(dialogID:String, oKCallback:Function = null, cancelCallback:Function = null, dialogData:Object = null, block:int = 0):void
		{
			(DialogModule)(Manager.module.getModuleByID(ModuleID.DIALOG)).showDialog(dialogID, oKCallback, cancelCallback, dialogData, block);
		}

		public function closeAllDialog():void
		{
			(DialogModule)(Manager.module.getModuleByID(ModuleID.DIALOG)).closeAll();
		}

		public function hideDialog(dialogID:String):void
		{
			DialogModule(Manager.module.getModuleByID(ModuleID.DIALOG)).hideDialog(dialogID);
		}

		public function isPreviousModuleAvailable():Boolean
		{
			return previousModule != null;
		}
		
		/**
		 * Hien 1 popup
		 * @param    popupID lay trong ModuleID
		 */
		public function showPopup(popupID:ModuleID, block:int = 2, extraInfo:Object = null):void
		{
			showModule(popupID, new Point(0, 0), LayerManager.LAYER_POPUP, Align.TOP_LEFT, block, extraInfo);
		}

		public function closeAllPopup():void
		{
			Manager.layer.clearLayer(LayerManager.LAYER_POPUP);
		}

		/**
		 * Hien 1 message
		 * @param    messageID lay trong MessageID
		 */
		public function showMessageID(messageID:int):void
		{
			if (Manager.module.getModuleByID(ModuleID.MESSAGE))
			{
				(MessageModule)(Manager.module.getModuleByID(ModuleID.MESSAGE)).showMessageID(messageID);
			}
		}

		public function showMessage(message:String):void
		{
			var messageModule:MessageModule = Manager.module.getModuleByID(ModuleID.MESSAGE) as MessageModule;
			if (messageModule != null) messageModule.showMessage(message);
		}

		public function showWaitting(msg:String):void
		{
			Manager.display.showModule(ModuleID.WAITTING, new Point(0, 0), LayerManager.LAYER_MESSAGE, "top_left", Layer.BLOCK_BLACK);

			var waittingModule:WaittingModule = Manager.module.getModuleByID(ModuleID.WAITTING) as WaittingModule;
			if (waittingModule)
			{
				waittingModule.showWaitting(msg);
			}
		}

		public function hideWaitting():void
		{
			var waittingModule:WaittingModule = Manager.module.getModuleByID(ModuleID.WAITTING) as WaittingModule;
			if (waittingModule)
			{
				waittingModule.hideWaitting();
			}
			Manager.display.hideModule(ModuleID.WAITTING);
		}

		/**
		 * Di den 1 screen
		 * @param    screenID lay trong ScreenID
		 * @param    tracked co back duoc hay khong
		 * @param    extraInfo thong tin truyen cho module
		 */
		public function to(screenID:ModuleID, tracked:Boolean = true, extraInfo:Object = null, layer:int = 0):void
		{
			if (screenID == currentScreen)
			{
				Utility.log("warning --> go to the same screen: " + screenID.clas);
			}

			if (screenID /*&& screenID != currentScreen*/)
			{
				hideModule(currentScreen, true);
				closeAllDialog();
				closeAllPopup();
				Manager.layer.clearLayer(LayerManager.LAYER_SCREEN);
				stage.dispatchEvent(new EventEx(TooltipEvent.HIDE_TOOLTIP));
				currentScreen = screenID;
				dispatchEvent(new Event(CHANGE_SCREEN));
				if (tracked) addToHistory(screenID);
				showModule(screenID, new Point(0, 0), layer, Align.TOP_LEFT, Layer.NONE, extraInfo, true);
			}
		}

		/**
		 * Quay lai trang truoc do
		 */
		public function back():void
		{
			if (history.length == 0 || (history.length == 1 && history[history.length - 1] == currentScreen)) return;

			var index:int = history.indexOf(currentScreen);
			var prevModule:ModuleID;

			if (index == -1)
			{
				prevModule = history[history.length - 1] as ModuleID;
			}
			else
			{
				prevModule = history[index - 1] as ModuleID;
			}

			if (prevModule) to(prevModule);
		}

		/**
		 * Doi thu tu hien thi trong display list giua 2 module
		 * @param    module1
		 * @param    module2
		 */
		public function swap(module1:ModuleID, module2:ModuleID):void
		{
			var view1:ViewBase = Manager.module.getModuleByID(module1).baseView;
			var view2:ViewBase = Manager.module.getModuleByID(module2).baseView;

			if (!(view1 && view2 && view1.visible && view2.visible)) return;

			if (view1.parent == view2.parent)
			{
				var parent:DisplayObjectContainer = view1.parent;
				parent.swapChildren(view1, view2);
			}
		}

		/**
		 * Hien 1 module
		 * @param    moduleName ten Module trong ModuleID
		 * @param    position toa do x, y
		 * @param    layer thu tu tren duoi (xem trong LayerManager)
		 * @param    extraInfo thong tin phu
		 */
		
		public function showPreviousModule():void
		{
			if (previousModule) 
			{
				if (!hudModuleMap[previousModule.id]) previousModule.show();
				else 
				{
					var hudModule:HUDModule = Manager.module.getModuleByID(ModuleID.HUD) as HUDModule;
					if (hudModule) hudModule.updateHUDButtonStatus(previousModule.id, true);
				}
			}
		}
		
		public function showModule(moduleName:ModuleID, position:Point, layer:int = 0, align:String = "top_left", block:int = 2, extraInfo:Object = null, queued:Boolean = false):void
		{
			var module:ModuleBase = Manager.module.getModuleByID(moduleName);
			
			if (keepedModuleMap[moduleName]) 
			{
				// hard code for tutorial mode
				if (Game.database.userdata.level >= 8 && !previousModule) previousModule = module;
			}
			
			module.x = position.x;
			module.y = position.y;
			module.layer = layer;
			module.align = align;
			module.block = block;
			module.extraInfo = extraInfo;
			module.action = ModuleBase.SHOW;
			if (queued)
			{
				queue.push(module);
				actionQueue.push(ModuleBase.SHOW);
				if (queue.length == 1)
				{
					module.addEventListener(ViewBase.TRANSITION_IN_COMPLETE, displayCompleteHdl);
					module.show();
				}
			}
			else
			{
				module.show();
			}
			
			if (moduleName == ModuleID.HOME) 
			{
				showPreviousModule();
			}
		}

		/**
		 * An 1 module
		 * @param    moduleName ten Module trong ModuleID
		 */
		public function hideModule(moduleName:ModuleID, queued:Boolean = false):void
		{
			if (moduleName)
			{
				var module:ModuleBase = Manager.module.getModuleByID(moduleName);
				module.action = ModuleBase.HIDE;
				if (queued)
				{
					queue.push(module);
					actionQueue.push(ModuleBase.HIDE);
					if (queue.length == 1)
					{
						module.addEventListener(ViewBase.TRANSITION_OUT_COMPLETE, displayCompleteHdl);
						module.hide();
					}
				}
				else
				{
					module.hide();
				}
				
				if (Manager.module.moduleIsVisible(ModuleID.HOME)) 
				{
					showPreviousModule();
				}
			}
		}

		public function clearKeepedModule(callerModuleID:ModuleID):void
		{
			if (callerModuleID == ModuleID.HUD)
			{
				if (!previousModule) return;
				if (hudModuleMap[previousModule.id])  
				{
					var hudModule:HUDModule = Manager.module.getModuleByID(ModuleID.HUD) as HUDModule;
					if (hudModule.getSelectedModule() != previousModule.id) hudModule.updateHUDButtonStatus(previousModule.id, false, null, false);
				}
				previousModule = null;
				return;
			}
			
			previousModule = null;
			if (previousModule == Manager.module.getModuleByID(callerModuleID)) previousModule = null;
		}
		/**
		 * Kiem tra 1 module co dang duoc hien thi hay khong
		 * @param    moduleName ten module can kiem tra (xem trong ModuleID)
		 * @return true neu dang hien, false neu khong hien
		 */
		public function checkVisible(moduleName:ModuleID):Boolean
		{
			var module:ModuleBase = Manager.module.getModuleByID(moduleName);
			return module.visible;
		}

		public function getWidth():int { return width; }

		public function getHeight():int { return height; }

		public function getContainer():Sprite { return container; }

		public function getStage():Stage { return stage; }

		public function getMouseX():int
		{
			return (stage.mouseX - container.x) / container.scaleX;
		}

		public function getMouseY():int
		{
			return (stage.mouseY - container.y) / container.scaleY;
		}

		public function getCurrentModule():ModuleID { return currentScreen; }

		private function addToHistory(screenID:ModuleID):void
		{
			var index:int = history.indexOf(screenID);
			if (index != -1)
			{
				//Ton tai Screen trong history
				//Xoa moi phan tu phia sau vi tri cua Screen.
				var numofItems:int = history.length - index;
				history.splice(index, numofItems);
			}

			history.push(screenID);
		}

		private function displayNext():void
		{
			queue.splice(0, 1);
			actionQueue.splice(0, 1);
			if (queue.length > 0)
			{
				var module:ModuleBase = queue[0] as ModuleBase;
				var action:int = actionQueue[0];
				if (action == ModuleBase.SHOW)
				{
					module.addEventListener(ViewBase.TRANSITION_IN_COMPLETE, displayCompleteHdl);
					module.show();
				}
				else if (action == ModuleBase.HIDE)
				{
					module.addEventListener(ViewBase.TRANSITION_OUT_COMPLETE, displayCompleteHdl);
					module.hide();
				}
				else
				{
					displayCompleteHdl(null);
				}
			}
		}

		private function displayCompleteHdl(e:Event):void
		{
			var module:ModuleBase = queue[0] as ModuleBase;
			module.removeEventListener(ViewBase.TRANSITION_IN_COMPLETE, displayCompleteHdl);
			module.removeEventListener(ViewBase.TRANSITION_OUT_COMPLETE, displayCompleteHdl);
			displayNext();
		}

		private function onResize(e:Event):void
		{
			var scaleX:Number = stage.stageWidth / width;
			var scaleY:Number = stage.stageHeight / height;
			container.scaleX = container.scaleY = Math.min(1, scaleX, scaleY);

			container.x = (stage.stageWidth - container.width) / 2;
			container.y = (stage.stageHeight - container.height) / 2;
		}

	}
}