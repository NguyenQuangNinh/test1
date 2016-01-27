package core.display 
{
	import core.util.Enum;
	import flash.utils.Dictionary;
	import flash.utils.describeType;
	
	import game.ui.ModuleID;
	import game.ui.PopupID;
	import game.ui.ScreenID;
	/**
	 * ...
	 * @author bangnd2
	 */
	public class ModulesManager 
	{
		private var moduleList:Array = [];
		private var dict:Dictionary = new Dictionary();
		
		private function addModules(enumList:Array):void 
		{
			for each (var clas:Class in enumList) 
			{
				var description:XML = describeType(clas);
				var moduleBase:ModuleBase;
				//var moduleID:ModuleID;
				
				/*for each(var constant:XML in description.constant) {
					moduleID = clas[constant.@moduleID];
					module = new moduleID.clas();
					module.swfURL = moduleID.name;
					addModule(moduleID, module);
				}*/
				for each (var module:ModuleID in Enum.getAll(ModuleID)) {
					moduleBase = new module.clas();
					moduleBase.id = module;
					moduleBase.swfURL = module.name;
					addModule(module, moduleBase)
				}
			}
			
		}
		
		public function	load(moduleID:ModuleID, completeCallback:Function, progressCallback:Function = null):void {
			getModuleByID(moduleID).loadUIModule(completeCallback, progressCallback);
		}
		
		public function unload(moduleID:ModuleID):void
		{
			var module:ModuleBase = dict[moduleID];
			if(module != null)
			{
				module.unload();
			}
		}
		
		private function addModule(moduleID:ModuleID, module:ModuleBase):void {
			moduleList.push(module);
			dict[moduleID] = module;
		}
		
		public function getModuleByID(name:ModuleID):ModuleBase {
			return dict[name] as ModuleBase;
		}
		
		public function getModuleByView(view:ViewBase):ModuleBase {
			for each (var module:ModuleBase in moduleList) 
			{
				if (module.baseView == view) return module;
			}
			
			return null;
		}
		
		public function ModulesManager() 
		{
			addModules([ModuleID, PopupID]);
		}
		
		public function moduleIsVisible(moduleID:ModuleID) : Boolean {
			return (getModuleByID(moduleID) && getModuleByID(moduleID).visible);
		}
	}
}