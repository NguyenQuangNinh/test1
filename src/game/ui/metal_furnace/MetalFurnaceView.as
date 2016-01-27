package game.ui.metal_furnace
{
	import core.display.animation.Animator;
	import core.display.pixmafont.PixmaText;
	import core.display.ViewBase;
	import core.event.EventEx;
	import core.Manager;
	import core.util.FontUtil;
	import core.util.Utility;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import game.data.xml.DataType;
	import game.data.xml.LevelCommonXML;
	import game.data.xml.VIPConfigXML;
	import game.enum.FeatureEnumType;
	import game.enum.FlowActionEnum;
	import game.enum.Font;
	import game.enum.GameConfigID;
	import game.enum.PaymentType;
	import game.Game;
	import game.net.lobby.LobbyRequestType;
	import game.net.RequestPacket;
	import game.ui.components.AnimButton;
	import game.ui.metal_furnace.gui.MetalFurnaceInfo;
	import game.utility.GameUtil;
	import game.utility.UtilityUI;
	
	/**
	 * ...
	 * @author anhtinh
	 */
	public class MetalFurnaceView extends ViewBase
	{
        public static const SKIP_COOLDOWN_EVENT:String = "skipCooldownEvent";
        public static const REQUEST_METAL_FURNACE:String = "requestMetalFurnace";

		private var closeBtn:SimpleButton;
		
		private var scenceAnim:Animator;
		private var particleAnim:Animator;
		private var scrollAnim:Animator;
		private var incomeAnim:Animator;
		private var goldPixmaText:PixmaText;
		private var xuNeed:int;
		private var goldGet:int;
		
		public var metalFurnaceInfo:MetalFurnaceInfo = new MetalFurnaceInfo();
		
		public function MetalFurnaceView()
		{
			initView();
		}
		
		private function initView():void
		{
			scenceAnim = new Animator();
			scenceAnim.x = 650;
			scenceAnim.y = 325;
			scenceAnim.load("resource/anim/ui/alchemy2.banim");
			scenceAnim.play(0);
			this.addChild(scenceAnim);
			
			particleAnim = new Animator();
			particleAnim.x = 650;
			particleAnim.y = 325;
			particleAnim.load("resource/anim/ui/alchemy2.banim");
			particleAnim.play(1);
			this.addChild(particleAnim);
			
			scrollAnim = new Animator();
			scrollAnim.x = 965;
			scrollAnim.y = 300;
			scrollAnim.load("resource/anim/ui/alchemy_scroll.banim");
			this.addChild(scrollAnim);
			scrollAnim.play(0);
			
			closeBtn = UtilityUI.getComponent(UtilityUI.CLOSE_BTN) as SimpleButton;
			closeBtn.x = 1025;
			closeBtn.y = 125;
			closeBtn.addEventListener(MouseEvent.CLICK, closeHandler);
			this.addChild(closeBtn);
			
			incomeAnim = new Animator();
			incomeAnim.setCacheEnabled(false);
			incomeAnim.x = 650;
			incomeAnim.y = 325;
			incomeAnim.load("resource/anim/ui/alchemy2.banim");
			incomeAnim.stop();
			incomeAnim.visible = false;
			incomeAnim.addEventListener(Event.COMPLETE, incomeAnimComplete);
			this.addChild(incomeAnim);
			
			metalFurnaceInfo.addEventListener("processMetalFurnace", onMetalFurnace);
			
			goldPixmaText = new PixmaText();
			goldPixmaText.loadFont("resource/anim/font/font_item_name_yellow.banim");
			goldPixmaText.x = 804;
			goldPixmaText.y = 424;
			//this.addChild(goldPixmaText);
			
			metalFurnaceInfo.x = 775;
			metalFurnaceInfo.y = 535;
			this.addChild(metalFurnaceInfo);
		
		}
		
		private function incomeAnimComplete(e:Event):void
		{
			Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.GET_PLAYER_INFO));
		}
		
		private function closeHandler(e:MouseEvent):void
		{
			this.dispatchEvent(new EventEx("closeMetalFurnace"));
		}
		
		private function onMetalFurnace(e:Event):void
		{
			if (Game.database.userdata.xu >= xuNeed)
			{
                var autoSkip:Boolean = metalFurnaceInfo.autoSkipCoolDown.isChecked();
                this.dispatchEvent(new EventEx(REQUEST_METAL_FURNACE,{autoSkip: autoSkip}));
			}
			else
			{
				//Manager.display.showMessageID(49);
				Game.flow.doAction(FlowActionEnum.PURCHASE_RESOURCE, PaymentType.XU_NORMAL.ID);
			}
		
		}
		
		public function playCollectGoldEffect():void
		{
			var bitmapData:BitmapData = new BitmapData(goldPixmaText.width, goldPixmaText.getHeight(), true, 0);
			bitmapData.draw(goldPixmaText);
			incomeAnim.replaceFMBitmapData([0], [bitmapData]);
			
			incomeAnim.visible = true;
			incomeAnim.play(2, 1);
		}
		
		public function updateNumAlchemy():void
		{
			var nMaxAlchemyInDay:int = Game.database.gamedata.getConfigData(GameConfigID.MAX_ALCHEMY_IN_DAY) as int;
			var vipConfigXML:VIPConfigXML = Game.database.gamedata.getData(DataType.VIP, Game.database.userdata.vip) as VIPConfigXML;
			if (vipConfigXML)
			{
				nMaxAlchemyInDay += vipConfigXML.additionAlchemyInDay;
			}
			
			var nAlchemyRemain:int = nMaxAlchemyInDay - Game.database.userdata.nAlchemyInDay;
			
			metalFurnaceInfo.update(nAlchemyRemain);
		}
		
		public function setInfo():void
		{
			var arrAlchemyGoldByLevel:Array = Game.database.gamedata.getConfigData(GameConfigID.ARR_ALCHEMY_GOLD_BY_LEVEL) as Array;
			var arrAlchemyXuNeedByTime:Array = Game.database.gamedata.getConfigData(GameConfigID.ARR_ALCHEMY_XU_NEED_BY_TIME) as Array;
			var nLevel:int = Game.database.userdata.level;
			var nAlchemyInDay:int = Game.database.userdata.nAlchemyInDay;
			var remainTimeWait:int = Game.database.userdata.remainTimeWaitAlchemy;

			if (arrAlchemyGoldByLevel && arrAlchemyXuNeedByTime && nLevel < arrAlchemyGoldByLevel.length && nAlchemyInDay <= arrAlchemyXuNeedByTime.length)
			{
				if (nAlchemyInDay == arrAlchemyXuNeedByTime.length)
					nAlchemyInDay--;
				
				xuNeed = arrAlchemyXuNeedByTime[nAlchemyInDay+1];
				goldGet = arrAlchemyGoldByLevel[nLevel];
				
				goldPixmaText.setText(Utility.math.formatInteger(goldGet));
				metalFurnaceInfo.updateTrans(Utility.math.formatInteger(xuNeed), Utility.math.formatInteger(goldGet));
                if(remainTimeWait > 0) metalFurnaceInfo.showCountDown(remainTimeWait);
			}
		}
	}
}