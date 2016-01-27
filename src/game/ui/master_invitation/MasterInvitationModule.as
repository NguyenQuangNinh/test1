package game.ui.master_invitation
{
	import core.display.ModuleBase;
	
	public class MasterInvitationModule extends ModuleBase
	{
		override protected function createView():void
		{
			baseView = new MasterInvitationView();
		}
	}
}