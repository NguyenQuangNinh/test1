package game.ui.tutorial.scenes 
{
	import core.event.EventEx;
	import core.Manager;
	import core.util.FontUtil;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.text.TextField;
	import game.enum.Font;
	import game.Game;
	import game.net.IntRequestPacket;
	import game.net.lobby.LobbyRequestType;
	import game.ui.tutorial.TutorialEvent;
	import game.utility.UtilityUI;
	/**
	 * ...
	 * @author MaiPTT
	 */
	public class TutorialScene7 extends BaseScene 
	{
		public var arrowInstruction		:MovieClip;
		public var txtInfo				:TextField;
		
		public function TutorialScene7() {
			super(7);
			sceneName = "Su dung ky nang lan dau tien";
			init();
		}
		
		override protected function init():void {
			super.init();
			arrowInstruction = UtilityUI.getComponent(UtilityUI.ARROW_INFO) as MovieClip;
			arrowInstruction.gotoAndStop(3);
			txtInfo = arrowInstruction.txtInfo;
			
			FontUtil.setFont(txtInfo, Font.ARIAL);
		}
		
		override public function start():void {
			addChild(arrowInstruction);
		}
		
		override protected function onTutorialEventHdl(e:EventEx):void {
			super.onTutorialEventHdl(e);
			if (Manager.tutorial.getCurrentTutorialID() != sceneID) {
				return;
			}
			
			switch(e.data.type) {
				case TutorialEvent.SKILL_ACTIVED:
					arrowInstruction.x = e.data.x - 50;
					arrowInstruction.y = e.data.y - arrowInstruction.height;
					txtInfo.text = "Kỹ năng đã kích hoạt. Nhấn chuột hoặc nhấn phím " + (e.data.index + 1);
					start();
					break;
					
				case TutorialEvent.USE_SKILL:
					Game.network.lobby.sendPacket(new IntRequestPacket(LobbyRequestType.TUTORIAL_FINISHED_SCENE, sceneID));	
					onComplete();
					break;
					
				case TutorialEvent.INGAME_TRANS_OUT:
					if (arrowInstruction.parent) {
						arrowInstruction.parent.removeChild(arrowInstruction);
					}
					break;
			}
		}
	}

}