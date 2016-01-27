package game.ui.soul_center.gui
{
	import com.greensock.easing.Quart;
	import com.greensock.events.TweenEvent;
	import com.greensock.TweenMax;
	import core.display.animation.Animator;
	import core.Manager;
	import core.event.EventEx;
	import core.util.Utility;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.setTimeout;
	import game.data.model.item.SoulItem;
	import game.Game;
	import game.net.IntRequestPacket;
	import game.net.lobby.LobbyRequestType;
	import game.net.lobby.response.ResponseSoulCraftAuto;
	import game.net.lobby.response.ResponseSoulInfo;
	import game.net.RequestPacket;
	import game.ui.components.ThreeStateMov;
	import game.ui.soul_center.event.EventSoulCenter;
	import game.ui.soul_center.gui.toggle.NPCAvatar;
	import game.ui.soul_center.gui.toggle.ProgressNPC1;
	import game.ui.soul_center.gui.toggle.ProgressNPC2;
	import game.ui.tutorial.TutorialEvent;

	/**
	 * ...
	 * @author anhtinh
	 */
	public class DivineSoulPanel extends Sprite
	{
		private static const COLLECT_EFFECT_X:int = 874;
		private static const COLLECT_EFFECT_Y:int = -81;
		
		private static const X_SLOT_DISTANCE:int = 76;
		private static const Y_SLOT_DISTANCE:int = 77;
		private static const NUM_SLOT_PER_ROW:int = 10;
		private static const INV_TEMP_CAPACITY:int = 20;
		
		public var getAllSoulBtn:SimpleButton;
		public var sellAllNonsoulBtn:SimpleButton;
		public var normalDivineBtn:SimpleButton;
		public var autoDivineBtn:SimpleButton;
		public var stopAutoDivineBtn:SimpleButton;
		
		public var divineInfoPanel:DivineInfoPanel;
		
		public var progressNPC1:ProgressNPC1;
		public var progressNPC2:ProgressNPC1;
		public var progressNPC3:ProgressNPC1;
		public var progressNPC4:ProgressNPC1;
		public var progressNPC5:ProgressNPC2;
		
		public var avatar1:NPCAvatar;
		public var avatar2:NPCAvatar;
		public var avatar3:NPCAvatar;
		public var avatar4:NPCAvatar;
		public var avatar5:NPCAvatar;
		
		public var exchangePointInfo:ExchangePointInfo;
		
		private var progressList:Array;
		private var avatarList:Array;
		
		private var content:Sprite = new Sprite();
		private var soulSlots:Array = [];
		private var currentSouls:Array = [];
		private var animCollect:Animator;
		
		private var currentCollectIndex:int;
		private var isCollectAll:Boolean;
		private var animDivine:Animator;
		private var currentNPC:int;
		private var npcXs:Array = [193, 319, 447, 573, 695];
		private var isAutoCraft:Boolean;
		private var soulCraftAutoInfo:ResponseSoulCraftAuto;
		private var isSetCurrentNPC:Boolean;
		private var requiredGolds:Array;
		private var soulInfo:ResponseSoulInfo;
		
		public function DivineSoulPanel()
		{
			
			progressList = [progressNPC1, progressNPC2, progressNPC3, progressNPC4, progressNPC5];
			avatarList = [avatar1, avatar2, avatar3, avatar4, avatar5];
			
			progressNPC1.state = ThreeStateMov.ACTIVE_STATE;
			avatar1.state = ThreeStateMov.ACTIVE_STATE;
			
			setCurrentNPC(0);
			
			normalDivineBtn.addEventListener(MouseEvent.CLICK, onNormalDivine);
			autoDivineBtn.addEventListener(MouseEvent.CLICK, onAutoDivine);
			stopAutoDivineBtn.visible = false;
			stopAutoDivineBtn.addEventListener(MouseEvent.CLICK, onStopAutoDivine);
			getAllSoulBtn.addEventListener(MouseEvent.CLICK, onGetAllSoul);
			sellAllNonsoulBtn.addEventListener(MouseEvent.CLICK, onSellAllNonsoul);
			
			//set gia vang cho moi NPC
			requiredGolds = Game.database.gamedata.getConfigData(36) as Array;
			var numItem:int = Math.min(5, requiredGolds.length);
			if (requiredGolds != null)
			{
				for (var i:int = 0; i < numItem; i++)
				{
					NPCAvatar(avatarList[i]).setGold(requiredGolds[i]);
				}
			}
			
			avatar1.setAvatar("resource/image/soul/boi1.png");
			avatar1.setAvatarPos(51, 13);
			avatar1.setNpcName("Tiểu Đạo Đồng");
			
			avatar2.setAvatar("resource/image/soul/boi2.png");
			avatar2.setAvatarPos(32, 3);
			avatar2.setNpcName("Đạo Sĩ Bói Đạo");
			
			avatar3.setAvatar("resource/image/soul/boi3.png");
			avatar3.setAvatarPos(31, 9);
			avatar3.setNpcName("Ẩn Cư Đạo Sĩ");
			
			avatar4.setAvatar("resource/image/soul/boi4.png");
			avatar4.setAvatarPos(30, 4);
			avatar4.setNpcName("Thiên Tuế Chân Nhân");
			
			avatar5.setAvatar("resource/image/soul/boi5.png");
			avatar5.setAvatarPos(18, 4);
			avatar5.setNpcName("Trường Sinh Chân Nhân");
			
			animCollect = new Animator();
			animCollect.x = 970;
			animCollect.y = 260;
			animCollect.load("resource/anim/ui/fx_menhkhi.banim");
			animCollect.stop();
			animCollect.visible = false;
			animCollect.addEventListener(Event.COMPLETE, onCollectComplete);
			addChild(animCollect);
			
			animDivine = new Animator();
			animDivine.x = 165;
			animDivine.y = 182;
			
			animDivine.load("resource/anim/ui/fx_boi.banim");
			animDivine.stop();
			animDivine.visible = false;
			animDivine.addEventListener(Event.COMPLETE, onDivineComplete);
			addChild(animDivine);
			
			content.x = 30;
			content.y = 280;
			this.addChild(content);
		
		}
		
		public function invTempIsFull():Boolean
		{
			return currentSouls.length >= INV_TEMP_CAPACITY;
		}
		
		public function playAutoCraft(soulCraftAutoInfo:ResponseSoulCraftAuto):void
		{
			this.soulCraftAutoInfo = soulCraftAutoInfo;
			
			isAutoCraft = true;
			playNpcDivineEffect();
		}
		
		public function normalDivine():void
		{
			playNpcDivineEffect();
		}
		
		private function playNpcDivineEffect():void
		{
			animDivine.x = npcXs[currentNPC] - 65;
			animDivine.y = 100;
			animDivine.visible = true;
			animDivine.play(0, 1);
			
			if (isAutoCraft)
			{
				
				divineInfoPanel.onAutoCraftStep();
				
				var soulItem:SoulItem = this.soulCraftAutoInfo.souls.shift() as SoulItem;
				soulItem.index = currentSouls.length;
				currentSouls.push(soulItem);
				addNewSoul();
			}
		}
		
		private function onDivineComplete(e:Event):void
		{
			if (isAutoCraft)
			{
				
				currentNPC = this.soulCraftAutoInfo.npcs.shift();
				setCurrentNPC(currentNPC);
				
				if (this.soulCraftAutoInfo.souls.length > 0)
				{
					playNpcDivineEffect();
				}
				else
				{
					isAutoCraft = false;
					Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.GET_SOUL_INFO));
					Game.mouseEnable = true;
				}
				
			}
			else
			{
				setCurrentNPC(currentNPC);
				isSetCurrentNPC = true;
				animDivine.visible = false;
				animDivine.stop();
				
				dispatchEvent(new EventSoulCenter(EventSoulCenter.COMPLETE_EFFECT_DIVINE, null, true));
			}
		}
		
		private function onCollectComplete(e:Event):void
		{
			animCollect.visible = false;
			setTimeout(updatePositions, 100);
			
			if (isCollectAll)
			{
				Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.COLLECT_FAST_SOUL));
				
			}
			else
			{
				Game.network.lobby.sendPacket(new IntRequestPacket(LobbyRequestType.COLLECT_SOUL, currentCollectIndex));
			}
			
			isCollectAll = false;
		}
		
		private function playCollectedEffect():void
		{
			animCollect.play(0, 1);
			animCollect.visible = true;
		}
		
		private function onAutoDivine(e:MouseEvent):void
		{
			if (canDivineFree() || Game.database.userdata.getGold() >= requiredGolds[currentNPC])
			{
				this.dispatchEvent(new EventSoulCenter(EventSoulCenter.AUTO_DIVINE, null, true));
				//stopAutoDivineBtn.visible = !stopAutoDivineBtn.visible;
				//autoDivineBtn.visible = !autoDivineBtn.visible;
			}
			else
			{
				Manager.display.showMessageID(28);
			}		
		}
		
		private function onStopAutoDivine(e:MouseEvent):void
		{
			//stopAutoDivineBtn.visible = !stopAutoDivineBtn.visible;
			//autoDivineBtn.visible = !autoDivineBtn.visible;					
			//activeAutoDivine(false);
			this.dispatchEvent(new EventSoulCenter(EventSoulCenter.STOP_AUTO_DIVINE, null, true));
		}
		
		private function onSellAllNonsoul(e:MouseEvent):void
		{
			this.dispatchEvent(new EventSoulCenter(EventSoulCenter.SELL_FAST_SOUL, null, true));
		}
		
		private function onGetAllSoul(e:MouseEvent):void
		{
			this.dispatchEvent(new EventSoulCenter(EventSoulCenter.COLLECT_FAST_SOUL, null, true));
		}
		
		private function onNormalDivine(e:MouseEvent):void
		{
			if (canDivineFree() || Game.database.userdata.getGold() >= requiredGolds[currentNPC])
			{
				this.dispatchEvent(new EventSoulCenter(EventSoulCenter.NORMAL_DIVINE, null, true));
				dispatchEvent(new EventEx(TutorialEvent.EVENT, {type: TutorialEvent.DEVINE_SOUL_CENTER}, true));
			}
			else
			{
				Manager.display.showMessageID(28);
			}
		}
		
		private function canDivineFree():Boolean
		{
			if (soulInfo != null)
			{
				return soulInfo.freeDivineRemain > 0 || soulInfo.freeDivineTotal == -1
			}
			else
				return false;
		}
		
		public function setData(responseSoulInfo:ResponseSoulInfo):void
		{
			this.soulInfo = responseSoulInfo;
			
			exchangePointInfo.setExchangePoint(responseSoulInfo.exchangePoint);
			
			//cap nhat thong tin so lan boi con lai
			divineInfoPanel.setData(responseSoulInfo);
			
			currentNPC = responseSoulInfo.npcIndex;
			//cap nhat thong tin NPC dang boi
			if (!isSetCurrentNPC)
			{
				setCurrentNPC(currentNPC);
			}
			
			isSetCurrentNPC = false;
			//currentNPC = responseSoulInfo.npcIndex;
			
			if (isNeedUpdateInventory(responseSoulInfo.souls))
			{
				//Utility.log("Need update Inventory");
				while (content.numChildren > 0)
				{
					content.removeChildAt(0);
				}
				soulSlots = [];
				for (var i:int = 0; i < this.currentSouls.length; i++)
				{
					
					var slot:SellableSoulSlot = new SellableSoulSlot();
					slot.x = (i % NUM_SLOT_PER_ROW) * X_SLOT_DISTANCE;
					slot.y = Math.floor(i / NUM_SLOT_PER_ROW) * Y_SLOT_DISTANCE - 17;
					
					slot.setData(this.currentSouls[i]);
					content.addChild(slot);
					soulSlots.push(slot);
				}
			}
			/*else
			{
				Utility.log("No need update Inventory");
			}*/
		
		}

		public function countGoodSoul():int
		{
			var rs:int = 0;
			for (var i:int = 0; i < soulSlots.length; i++)
			{
				var slot:SellableSoulSlot = soulSlots[i] as SellableSoulSlot;
				if(!slot.isBad) rs++;
			}

			return rs;
		}

		public function collectAllSoul(numEmptySlotRemain:int):void
		{
			
			isCollectAll = true;
			
			var goodSouls:Array = [];
			for (var i:int = 0; i < currentSouls.length; i++)
			{
				if (SoulItem(currentSouls[i]).isGoodSoul())
				{
					goodSouls.push(soulSlots[i]);
					
				}
				
			}
			
			var numSoulCollect:int = Math.min(numEmptySlotRemain, goodSouls.length);
			var tx:TweenMax
			var endIndex:int = goodSouls.length - 1;
			var beginIndex:int = endIndex - numSoulCollect + 1;
			
			for (var j:int = beginIndex; j <= endIndex; j++)
			{
				
				SellableSoulSlot(goodSouls[j]).prepairForRemove();
				removeSoulItem(SellableSoulSlot(goodSouls[j]).getIndex());
				soulSlots.splice(SellableSoulSlot(goodSouls[j]).getIndex(), 1);
				
				tx = TweenMax.to(goodSouls[j], 1, {ease: Quart.easeOut, x: COLLECT_EFFECT_X, y: COLLECT_EFFECT_Y});
				
				if (j < endIndex)
				{
					tx.addEventListener(TweenEvent.COMPLETE, onFirstCollectsAnimComplete);
				}
				else
				{
					tx.addEventListener(TweenEvent.COMPLETE, onLastCollectAnimComplete);
				}
			}
		
		}
		
		private function onLastCollectAnimComplete(e:TweenEvent):void
		{
			
			playCollectedEffect();
			
			var tweenTarget:TweenMax = e.target as TweenMax;
			tweenTarget.removeEventListener(TweenEvent.COMPLETE, onLastCollectAnimComplete);
			
			var slot:SellableSoulSlot = tweenTarget.target as SellableSoulSlot;
			slot.visible = false;
			slot.reset();
			if (slot.parent)
				slot.parent.removeChild(slot);
		
		}
		
		private function onFirstCollectsAnimComplete(e:TweenEvent):void
		{
			
			var tweenTarget:TweenMax = e.target as TweenMax;
			tweenTarget.removeEventListener(TweenEvent.COMPLETE, onFirstCollectsAnimComplete);
			
			var slot:SellableSoulSlot = tweenTarget.target as SellableSoulSlot;
			slot.visible = false;
			slot.reset();
			if (slot.parent)
				slot.parent.removeChild(slot);
		
		}
		
		public function sellAllBadSoul():void
		{
			var badSouls:Array = [];
			for (var i:int = 0; i < currentSouls.length; i++)
			{
				if (SoulItem(currentSouls[i]).isBadSoul())
				{
					SellableSoulSlot(soulSlots[i]).prepairForRemove();
					badSouls.push(soulSlots[i]);
					removeSoulItem(i);
					soulSlots.splice(i, 1);
					i--;
				}
				
			}
			
			var tx:TweenMax
			var endIndex:int = badSouls.length - 1;
			
			for (var j:int = 0; j <= endIndex; j++)
			{
				
				tx = TweenMax.to(badSouls[j].itemSlot, 1, {alpha: 0, scaleX: 1.6, scaleY: 1.6});
				
				if (j < endIndex)
				{
					tx.addEventListener(TweenEvent.COMPLETE, onFirstSellsAnimComplete);
				}
				else
				{
					tx.addEventListener(TweenEvent.COMPLETE, onLastSellAnimComplete);
				}
				
			}
		}
		
		private function onFirstSellsAnimComplete(e:TweenEvent):void
		{
			
			var tweenTarget:TweenMax = e.target as TweenMax;
			tweenTarget.removeEventListener(TweenEvent.COMPLETE, onFirstSellsAnimComplete);
			
			var tweenObj:SellableSoulSlot = Sprite(tweenTarget.target).parent as SellableSoulSlot;
			
			if (tweenObj != null)
			{
				tweenObj.visible = false;
				tweenObj.reset();
				if (content.contains(tweenObj))
					content.removeChild(tweenObj);
			}
		}
		
		private function onLastSellAnimComplete(e:TweenEvent):void
		{
			Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.SELL_FAST_SOUL));
			setTimeout(updatePositions, 100);
			
			var tweenTarget:TweenMax = e.target as TweenMax;
			tweenTarget.removeEventListener(TweenEvent.COMPLETE, onLastSellAnimComplete);
			
			var tweenObj:SellableSoulSlot = Sprite(tweenTarget.target).parent as SellableSoulSlot;
			
			if (tweenObj != null)
			{
				tweenObj.visible = false;
				tweenObj.reset();
				if (content.contains(tweenObj))
					content.removeChild(tweenObj);
			}
		}
		
		public function removeSlot(index:int, isSell:Boolean = false):void
		{
			
			if (currentSouls != null && index >= 0 && index < currentSouls.length)
			{
				
				if (!isSell)
					currentCollectIndex = index;
				
				var soulItem:SoulItem = currentSouls[index] as SoulItem;
				var soulSlotTemp:SellableSoulSlot = soulSlots[index] as SellableSoulSlot;
				
				removeSoulItem(index);
				soulSlots.splice(index, 1);
				
				soulSlotTemp.prepairForRemove();
				content.swapChildren(soulSlotTemp, content.getChildAt(content.numChildren - 1));
				
				var tweenTime:Number = 0.5;
				var tx:TweenMax;
				
				if (isSell)
				{
					tweenTime = 1;
					
					tx = TweenMax.to(soulSlotTemp.itemSlot, tweenTime, {alpha: 0, scaleX: 1.6, scaleY: 1.6});
					
					tx.addEventListener(TweenEvent.COMPLETE, onSellAnimComplete);
					
				}
				else
				{
					Utility.log("@@@@ isCollect : " + soulSlotTemp.name);
					tweenTime = 1;
					tx = TweenMax.to(soulSlotTemp, tweenTime, {ease: Quart.easeOut, x: COLLECT_EFFECT_X, y: COLLECT_EFFECT_Y});
					tx.addEventListener(TweenEvent.COMPLETE, onCollectAnimComplete);
				}
				
			}
		
		}
		
		private function onSellAnimComplete(e:TweenEvent):void
		{
			
			var tweenTarget:TweenMax = e.target as TweenMax;
			tweenTarget.removeEventListener(TweenEvent.COMPLETE, onSellAnimComplete);
			
			var tweenObj:SellableSoulSlot = Sprite(tweenTarget.target).parent as SellableSoulSlot;
			
			if (tweenObj != null)
			{
				
				Game.network.lobby.sendPacket(new IntRequestPacket(LobbyRequestType.SELL_SOUL, tweenObj.getIndex()));
				
				tweenObj.visible = false;
				tweenObj.reset();
				if (content.contains(tweenObj))
					content.removeChild(tweenObj);
				setTimeout(updatePositions, 100);
			}
			Utility.log("onSellAnimComplete  target :" + e.target);
		}
		
		private function onCollectAnimComplete(e:TweenEvent):void
		{
			
			playCollectedEffect();
			
			var tweenTarget:TweenMax = e.target as TweenMax;
			tweenTarget.removeEventListener(TweenEvent.COMPLETE, onCollectAnimComplete);
			
			var tweenObj:SellableSoulSlot = (tweenTarget.target) as SellableSoulSlot;
			if (tweenObj != null)
			{
				
				tweenObj.visible = false;
				tweenObj.reset();
				if (content.contains(tweenObj))
					content.removeChild(tweenObj);
			}
			Utility.log("onCollectAnimComplete  target :" + e.target);
		}
		
		private function removeSoulItem(index:int):void
		{
			
			currentSouls.splice(index, 1);
			for (var i:int = index; i < currentSouls.length; i++)
			{
				SoulItem(currentSouls[i]).index = i;
			}
		}
		
		private function updatePositions():void
		{
			for (var i:int = 0; i < soulSlots.length; i++)
			{
				soulSlots[i].x = (i % NUM_SLOT_PER_ROW) * X_SLOT_DISTANCE;
				soulSlots[i].y = Math.floor(i / NUM_SLOT_PER_ROW) * Y_SLOT_DISTANCE - 17;
			}
		}
		
		private function isNeedUpdateInventory(responseSouls:Array):Boolean
		{
			
			if (currentSouls == null || responseSouls.length != this.currentSouls.length)
			{
				
				if (responseSouls.length - 1 == this.currentSouls.length)
				{ //boi duoc menh khi moi
					currentSouls.push(responseSouls[responseSouls.length - 1]);
					addNewSoul();
					return false;
				}
				else
				{
					this.currentSouls = responseSouls;
					return true;
				}
				
			}
			else
			{
				
				for (var i:int = 0; i < responseSouls.length; i++)
				{
					if (!SoulItem.compare(responseSouls[i], currentSouls[i]))
					{
						this.currentSouls = responseSouls;
						return true;
					}
				}
			}
			
			return false;
		}
		
		private function addNewSoul():void
		{
			var index:int = this.currentSouls.length - 1;
			
			var slot:SellableSoulSlot = new SellableSoulSlot();
			slot.x = (index % NUM_SLOT_PER_ROW) * X_SLOT_DISTANCE;
			slot.y = Math.floor(index / NUM_SLOT_PER_ROW) * Y_SLOT_DISTANCE - 17;
			
			slot.setData(this.currentSouls[index]);
			slot.alpha = 0;
			content.addChild(slot);
			soulSlots.push(slot);
			
			TweenMax.to(slot, 0.3, {delay: 0.3, alpha: 1});
		}
		
		public function setCurrentNPC(index:int):void
		{
			index = Utility.math.clamp(index, 0, 4);
			
			currentNPC = index;
			
			for (var i:int = 0; i < 5; i++)
			{
				if (i < index)
				{ //passed
					ThreeStateMov(progressList[i]).state = ThreeStateMov.COMPLETE_STATE;
					ThreeStateMov(avatarList[i]).state = ThreeStateMov.COMPLETE_STATE;
				}
				else if (i == index)
				{ //active
					ThreeStateMov(progressList[i]).state = ThreeStateMov.ACTIVE_STATE;
					ThreeStateMov(avatarList[i]).state = ThreeStateMov.ACTIVE_STATE;
				}
				else
				{ //inactive
					ThreeStateMov(progressList[i]).state = ThreeStateMov.INACTIVE_STATE;
					ThreeStateMov(avatarList[i]).state = ThreeStateMov.INACTIVE_STATE;
				}
				
				if (i == index)
				{
					NPCAvatar(avatarList[i]).isDivinable = true;
				}
				else
				{
					NPCAvatar(avatarList[i]).isDivinable = false;
				}
			}
		}
		public function updateExchangePoint():void
		{
			exchangePointInfo.setExchangePoint(Game.database.userdata.soulExchangePoint);
		}
		
		public function activeAutoDivine(active:Boolean):void {
			stopAutoDivineBtn.visible = active;
			autoDivineBtn.visible = !active;
		}
	}

}