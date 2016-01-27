package core.display 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import game.ui.message.MessageView;
	import game.ui.ModuleID;
	
	import core.Manager;
	import core.display.layer.Layer;
	import core.enum.Align;
	
	import game.utility.PathManager;
	/**
	 * ...
	 * @author ...
	 */
	public class ModuleBase extends EventDispatcher
	{
		private static const LOADED:int = 0;
		private static const LOADING:int = 1;
		private static const NOT_YET:int = 2;
		public static const SHOW:int = 3;
		public static const HIDE:int = 4;
		private static const NONE:int = 5;
		public static const UI_MODULE_LOADED:String = "ModuleLoaded";
		
		public var swfURL:String;
		public var x:Number = 0;
		public var y:Number = 0;
		public var layer:int = 0;
		public var baseView:ViewBase;
		public var align:String = Align.TOP_LEFT;
		public var extraInfo:Object;
		public var block:int;
		public var action:int = NONE;

		protected var relatedModuleIDs:Array = [];
		
		private var _relatedModules:Array;
		private var _loadingStatus:int = NOT_YET;
		private var numOfLoading:int = 0;
		private var numOfTotalLoaded:int = 0;
		private var loadFinishCallbacks:Array = [];
		
		public var id:ModuleID;
		
		public function ModuleBase() 
		{
			this.id = id;
		}
		
		public function unload():void
		{
			if(_loadingStatus == LOADED)
			{
				Manager.resource.unload([PathManager.getUiModulePath(swfURL)]);
				if(baseView != null)
				{
					baseView.destroy();
					baseView = null;
				}
			}
		}
		
		/**
		 * Khoi tao view. createView duoc goi duy nhat 1 lan duy nhat ngay khi file swf cua module duoc load xong.
		 */
		protected function createView():void {
			//subclasses must override this method
		}
		
		/**
		 * preTransitionIn duoc goi ngay truoc khi hanh dong Transition In cua module dien ra.
		 */
		protected function preTransitionIn():void {
			//subclasses must override this method
			for (var i:int = 0; i < relatedModules.length; i++) 
			{
				ModuleBase(relatedModules[i]).baseView.visible = true;
				ModuleBase(relatedModules[i]).baseView.alpha = 1;
				ModuleBase(relatedModules[i]).baseView.mouseEnabled = true;
				ModuleBase(relatedModules[i]).baseView.mouseChildren = true;
				ModuleBase(relatedModules[i]).baseView.dispatchEvent(new Event(ViewBase.PRE_TRANSITION_IN));
			}
		}
		
		/**
		 * Implement transition in cua module. Mac dinh transitionIn cua module goi ham transitionIn cua view.
		 * Neu muon dong bo transition in cua nhieu module thi override ham nay. Khi do phai goi onTransitionInComplete() ngay sau khi module transition in xong.
		 */
		protected function transitionIn():void {
			baseView.setViewData(extraInfo);
			baseView.transitionIn();
		}
		
		/**
		 * Implement transition out cua module. Mac dinh transitionOut cua module goi ham transitionOut cua view.
		 * Neu muon dong bo transition out cua nhieu module thi override ham nay. Khi do phai goi onTransitionOutComplete() ngay sau khi module transition out xong.
		 */
		protected function transitionOut():void 
		{
			baseView.transitionOut();
		}
		
		/**
		 * preTransitionOut duoc goi ngay truoc khi hanh dong Transition Out cua module dien ra.
		 */
		protected function preTransitionOut():void {
			for (var i:int = 0; i < relatedModules.length; i++) 
			{
				if (!ModuleBase(relatedModules[i]).baseView.stage) {
					ModuleBase(relatedModules[i]).baseView.dispatchEvent(new Event(ViewBase.PRE_TRANSITION_OUT));
				}
			}
		}
		
		protected function onTransitionInComplete():void {
			action = NONE;
			
			for (var i:int = 0; i < relatedModules.length; i++) 
			{
				if (!ModuleBase(relatedModules[i]).baseView.stage) {
					ModuleBase(relatedModules[i]).baseView.showWithoutTween();
				}
			}
			
			dispatchEvent(new Event(ViewBase.TRANSITION_IN_COMPLETE));	
		}
		
		protected function onTransitionOutComplete():void {
			action = NONE;
			
			if (baseView.parent) {
				if (baseView.parent is Layer) {
					Manager.layer.removeFromLayer(baseView, layer);
				} else {
					baseView.parent.removeChild(baseView);
				}
			}
			
			for (var i:int = 0; i < relatedModules.length; i++) 
			{
				if (!ModuleBase(relatedModules[i]).baseView.stage) {
					ModuleBase(relatedModules[i]).baseView.hideWithoutTween();
				}
			}
			
			dispatchEvent(new Event(ViewBase.TRANSITION_OUT_COMPLETE));
		}
		
		public function show():void {
			action = SHOW;
			switch(_loadingStatus) {
				case NOT_YET:
					loadUIModule();
				break;
				case LOADED:
					processShow();
				break;
				case LOADING:
				break;
			}
		}
		
		private function processShow():void {
			Manager.layer.addToLayer(baseView, layer, block);
			if (!this.visible) {
				preTransitionIn();
				alignUI();
				transitionIn();
			} else {
				onTransitionInComplete();
			}
		}
		
		private function alignUI():void 
		{
			switch (align) 
			{
				case Align.TOP_LEFT:
					baseView.x = x;
					baseView.y = y;
				break;
				case Align.CENTER:
					baseView.x = x + (Manager.display.getWidth() - baseView.width)/2;
					baseView.y = y + (Manager.display.getHeight() - baseView.height)/2;
				break;
				case Align.TOP_RIGHT:
					baseView.x = x + Manager.display.getWidth() - baseView.width;
					baseView.y = y
				break;
				case Align.BOTTOM_LEFT:
					baseView.x = x;
					baseView.y = y + Manager.display.getHeight() - baseView.height;
				break;
				case Align.BOTTOM_RIGHT:
					baseView.x = x + Manager.display.getWidth() - baseView.width;
					baseView.y = y + Manager.display.getHeight() - baseView.height;
				break;
			}
		}
		
		private function viewPreTransitionInHdl(e:Event):void 
		{
			preTransitionIn();
		}
		
		private function viewTransInCompleteHdl(e:Event):void 
		{
			onTransitionInComplete();
		}
		
		public function hide():void {
			action = HIDE;
			switch(_loadingStatus) {
				case LOADED:
					processHide();
				break;
				case NOT_YET:
				case LOADING:
				break;
			}
		}
		
		private function processHide():void {
			if (visible) {
				preTransitionOut();
				transitionOut();
			} else {
				onTransitionOutComplete();
			}
		}
		
		private function viewTransOutCompleteHdl(e:Event):void 
		{
			onTransitionOutComplete();
		}
		
		private function viewPreTransitionOutHdl(e:Event):void 
		{
			preTransitionOut();
		}
		
		public function loadUIModule(finishCallback:Function = null,progressCallback:Function = null):void {
			switch(_loadingStatus) {
				case NOT_YET:
					setMiniLoadingVisible(true);
					_loadingStatus = LOADING;
					if (finishCallback != null) loadFinishCallbacks.push(finishCallback);
					loadChildren();
					numOfLoading++;
					if (swfURL.length > 0)	Manager.resource.load([PathManager.getUiModulePath(swfURL)], onModuleLoaded, progressCallback);
					else checkFinish();
				break;
				case LOADING:
					setMiniLoadingVisible(true);	
					if (finishCallback != null) loadFinishCallbacks.push(finishCallback);
				break;
				case LOADED:
					setMiniLoadingVisible(false);
					if (finishCallback != null) finishCallback();
				break;
			}
		}
		
		private function onModuleLoaded():void
		{
			checkFinish();
		}
		
		private function loadChildren():void {
			for (var i:int = 0; i < relatedModules.length; i++) 
			{
				var uiModule:ModuleBase = relatedModules[i] as ModuleBase;
				if (uiModule.loadingStatus == ModuleBase.NOT_YET) {
					uiModule.addEventListener(ModuleBase.UI_MODULE_LOADED, checkFinish);
					uiModule.loadUIModule();
					numOfLoading++;
				} else if (uiModule.loadingStatus == ModuleBase.LOADING) {
					uiModule.addEventListener(ModuleBase.UI_MODULE_LOADED, checkFinish);
					numOfLoading++;
				}
			}
		}
		
		private function checkFinish(e:Event = null):void {
			if (e) e.target.removeEventListener(ModuleBase.UI_MODULE_LOADED, checkFinish);
			
			numOfTotalLoaded++;
			if (numOfTotalLoaded == numOfLoading) {
				loadModuleComplete();
			}
		}
		
		protected function loadModuleComplete():void {
			setMiniLoadingVisible(false);
			_loadingStatus = ModuleBase.LOADED;
			createView();
			baseView.addEventListener(ViewBase.TRANSITION_IN_COMPLETE, viewTransInCompleteHdl);
			baseView.addEventListener(ViewBase.TRANSITION_OUT_COMPLETE, viewTransOutCompleteHdl);
			baseView.addEventListener(ViewBase.PRE_TRANSITION_IN, viewPreTransitionInHdl);
			baseView.addEventListener(ViewBase.PRE_TRANSITION_OUT, viewPreTransitionOutHdl);
			
			switch(action) {
				case SHOW:
					processShow();
				break;
				case HIDE:
					processHide();
				break;
			}
			
			for each (var callback:Function in loadFinishCallbacks) 
			{
				callback();
			}
			
			loadFinishCallbacks = [];
			
			dispatchEvent(new Event(UI_MODULE_LOADED));
		}
		
		public function getURLs():Array 
		{
			var rs:Array = [PathManager.getUiModulePath(swfURL)];
			for (var i:int = 0; i < relatedModuleIDs.length; i++) 
			{
				rs.push(PathManager.getUiModulePath(relatedModuleIDs[i].url));
			}
			return rs;
		}
		
		public function get loadingStatus():int 
		{
			return _loadingStatus;
		}
		
		public function get visible():Boolean {
			if (baseView && baseView.stage) 
			{
				return baseView.visible;
			} else {
				return false;
			}
		}
		
		protected function get modulesManager():ModulesManager
		{
			return Manager.module;
		}
		
		private function get relatedModules():Array {
			if(!_relatedModules) {
				_relatedModules = [];
				for (var i:int = 0; i < relatedModuleIDs.length; i++) 
				{
					_relatedModules.push(modulesManager.getModuleByID(relatedModuleIDs[i]));
				}
			}
			return _relatedModules;
		}
		
		private function setMiniLoadingVisible(value:Boolean):void {
			var messageView:MessageView = Manager.module.getModuleByID(ModuleID.MESSAGE).baseView as MessageView;
			if (messageView) {
				if (messageView.getMiniLoadingVisible() != value) {
					messageView.setMiniLoadingVisible(value);
				}
			}
		}
	}
}