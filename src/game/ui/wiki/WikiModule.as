package game.ui.wiki {

    import core.Manager;
    import core.display.ModuleBase;

    import flash.events.Event;

    import game.ui.ModuleID;

    import game.ui.hud.HUDModule;

    /**
 * ...
 * @author ninhnq
 */
public class WikiModule extends ModuleBase {

    public function WikiModule() {

    }

    override protected function createView():void {
        super.createView();
        baseView = new WikiView();
        baseView.addEventListener("close", closeHandler);

    }


    override protected function preTransitionIn():void
    {
        super.preTransitionIn();

        view.init();
    }

    private function closeHandler(e:Event):void
    {
        var hudModule:HUDModule = Manager.module.getModuleByID(ModuleID.HUD) as HUDModule;
        if (hudModule != null)
        {
            hudModule.updateHUDButtonStatus(ModuleID.WIKI, false);
        }
    }

    private function get view():WikiView
    {
        return baseView as WikiView;
    }
}

}