package game.ui.arena 
{
	import core.event.EventEx;
	import core.util.FontUtil;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	//import game.data.enum.pvp.ModePVPEnum;
	import game.data.vo.lobby.LobbyInfo;
	import game.enum.Font;
	import game.enum.GameMode;
	/**
	 * ...
	 * @author TrungLNM
	 */
	public class RoomInfoUI extends MovieClip
	{
		
		public var numTf:TextField;
		public var countTf:TextField;
		public var nameTf:TextField;
		public var modeTf:TextField;
		public var lockMov:MovieClip;
		public var modeMov:MovieClip;
		public var bgSelectedMov:MovieClip;
		public var bgMov:MovieClip;
		
		private var _hitMov:Sprite;
		private var _info:LobbyInfo;
		
		public function RoomInfoUI() 
		{
			if (stage)
				init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			initUI();			
		}
		
		private function initUI():void 
		{
			//set fonts
			FontUtil.setFont(numTf, Font.ARIAL, true);
			FontUtil.setFont(countTf, Font.ARIAL, true);
			FontUtil.setFont(nameTf, Font.ARIAL, true);
			FontUtil.setFont(modeTf, Font.ARIAL, true);
			
			//init hit movie
			bgSelectedMov.alpha = 0;
			bgSelectedMov.buttonMode = true;			
			bgSelectedMov.addEventListener(MouseEvent.CLICK, onRoomClickHdl);
			
			/*var rectangle:Shape = new Shape(); // initializing the variable named rectangle
			rectangle.graphics.beginFill(0xFF0000); // choosing the colour for the fill, here it is red
			rectangle.graphics.drawRect(0, 30, 460, 30); // (x spacing, y spacing, width, height)
			rectangle.graphics.endFill(); // not always needed but I like to put it in to end the fill			
			//addChild(rectangle); // adds the rectangle to the stage
			
			_hitMov = new Sprite();
			_hitMov.addChild(rectangle);
			_hitMov.buttonMode = true;	
			_hitMov.alpha = 0;
			addChildAt(_hitMov, 0);
			_hitMov.addEventListener(MouseEvent.CLICK, onRoomClickHdl);*/
			
			//add events
			//this.buttonMode = true;			
		}
		
		public function onRoomClickHdl(e:MouseEvent = null):void 
		{
			bgSelectedMov.alpha = 1;
			dispatchEvent(new EventEx(ArenaEventName.ROOM_SELECTED, _info, true));			
		}
		
		public function updateInfo(room:LobbyInfo):void {
			_info = room;
			if (room) {
				numTf.text = room.id.toString();
				//countTf.text = room.count.toString() + "/" + (room.mode == ModePVPEnum.PVP_1vs1_FREE 
															//|| room.mode == ModePVPEnum.PvP_1vs1_MM ? "2"
																//: room.mode == ModePVPEnum.PVP_3vs3_FREE ? "6" : "3");	//here /total depend on mode
				countTf.text = room.count.toString() + "/" + (room.mode == GameMode.PVP_1vs1_FREE ? "2"
															: room.mode == GameMode.PVP_3vs3_FREE ? "6" : "3");	//here /total depend on mode
				nameTf.text = room.name;
				lockMov.visible = room.privateLobby;
				//modeTf.text = room.mode == ArenaEventName.PVP_1vs1_FREE ? "1vs1" : (room.mode == ArenaEventName.PVP_3vs3_FREE ? "3vs3" : "");
				//modeTf.text = room.mode == ModePVPEnum.PVP_1vs1_FREE ? "1vs1" : (room.mode == ModePVPEnum.PVP_3vs3_FREE ? "3vs3" : "");
				modeTf.text = room.mode == GameMode.PVP_1vs1_FREE ? "1vs1" : (room.mode == GameMode.PVP_3vs3_FREE ? "3vs3" : "");
				//bgMov.gotoAndStop(room.mode == ArenaEventName.PvP_3vs3_MATCHING 
								//|| room.mode == ArenaEventName.PvP_1vs1_MATCHING ? "matching" : "free");
				//bgMov.gotoAndStop(room.mode == ModePVPEnum.PvP_3vs3_MM 
								//|| room.mode == ModePVPEnum.PvP_1vs1_MM ? "matching" : "free");
				bgMov.gotoAndStop(room.mode == GameMode.PVP_3vs3_MM 
								|| room.mode == GameMode.PVP_1vs1_MM ? "matching" : "free");
				//depend on room display or hide mode and can select
				/*switch(room.mode) {
					case ArenaEventName.PVP_FREE:
						//show mode select
						//modeTitle = new ButtonFree();
						modeTitle = new (getDefinitionByName("ButtonFree") as Class)();
						break;
					case ArenaEventName.PvP_3vs3_MATCHING:
						//hide mode select
						//modeTitle = new Button1_1();
						modeTitle = new (getDefinitionByName("Button1_1") as Class)();
						break;
				}
				if (modeTitle) {
					MovieClipUtils.removeAllChildren(modeMov);
					modeTitle.enabled = false;
					modeTitle.mouseEnabled = false;
					modeMov.addChild(modeTitle);
				}*/
			}
		}
		
		public function setSelected(selected:Boolean):void {
			bgSelectedMov.alpha = selected ? 1 : 0;		
		}
		
	}

}