package game.ui.lucky_gift.gui
{
	import com.greensock.easing.Circ;
	import com.greensock.easing.Elastic;
	import com.greensock.easing.Expo;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import core.display.animation.Animator;
	import core.Manager;
	import core.util.Utility;
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import game.data.model.item.IItemConfig;
	import game.data.model.item.ItemFactory;
	import game.data.xml.DataType;
	import game.data.xml.RewardXML;
	import game.enum.GameConfigID;
	import game.enum.ItemType;
	import game.enum.PlayerAttributeID;
	import game.Game;
	import game.net.lobby.LobbyRequestType;
	import game.net.RequestPacket;
	import game.ui.components.ItemSlot;
	import game.ui.lucky_gift.LuckyGiftView;
	import game.ui.tooltip.TooltipID;
	import game.utility.UtilityEffect;
	
	/**
	 * ...
	 * @author xxx
	 */
	public class CellGiftContainer extends Sprite
	{
		
		private var _nRound:int = 8;
		private var _nDelay:int = 8;
		private var _arrCellGift:Array;
		private var _myTimer:Timer;
		private var _currentIndex:int;
		private var _currentRound:int;
		private var _rewardIndex:int;
		
		private var _view:LuckyGiftView;
		private var _activeAnim:Animator;
	
		private var _itemSlot:ItemSlot;
		private var onAnimCompleteHdl:Function;
		
		private var posArr:Array = [[531.65, 131.9], [659.65, 186.3], [708.1, 309.3], [660.45, 437.1], [531.65, 488.65], [400.6, 437.1], [353.85, 310.1], [400.6, 187.1]]
		
		private function calDelay(x:int):int
		{
			return Math.round((x * x) + _nDelay);
		}
		
		public function CellGiftContainer(view:LuckyGiftView)
		{

			_currentIndex = 0;
			_currentRound = -_nRound;
			
			_arrCellGift = new Array();
			_myTimer = new Timer(calDelay(_currentRound), _nRound * _nRound);
			_myTimer.addEventListener(TimerEvent.TIMER, timerListener);
			_view = view;
			_activeAnim = new Animator();
			_activeAnim.load("resource/anim/ui/hieuung_nhanqua.banim");
			
			this.addChildAt(_activeAnim, 0);
			_activeAnim.visible = false;
		
		}
		
		private function timerListener(e:TimerEvent):void
		{
			setCellStatus(_currentIndex, CellGift.NORMAL);
			_currentIndex = (_currentIndex + 1) % posArr.length;
			setCellStatus(_currentIndex, CellGift.ACTIVE);
			
			if (_currentIndex == posArr.length - 1)
			{
				_currentRound += 2;
				if (_currentRound < 0)
					_myTimer.delay = calDelay(_currentRound);
				else
					_myTimer.delay += calDelay(_currentRound + 3) * 2;
				//trace("_currentRound:" + _currentRound);
				//trace("_myTimer.delay:" + _myTimer.delay);
			}
			
			if (_currentRound == _nRound - 2)
			{
				if (_currentIndex == _rewardIndex)
				{
					stopAnim();
					var cell:CellGift = _arrCellGift[_currentIndex] as CellGift;
					if (cell != null)
					{
						cell.status = CellGift.NORMAL;
						/*
						_activeAnim.x = cell.x;
						_activeAnim.y = cell.y;
						_activeAnim.visible = true;
						_activeAnim.play(0, 0);
						*/
					}
					showReward();
				}
			}
		}
		
		public function init(arrRewardIDs:Array):void
		{
			this.reset();
			// reset _arrCellGift
			for (var i:int = 0; i < _arrCellGift.length; i++)
			{
				var child:CellGift = _arrCellGift[i] as CellGift;
				child.destroy();
				removeChild(child);
			}
			_arrCellGift = [];
			
			for (i = 0; i < arrRewardIDs.length && i < posArr.length; i++)
			{
				var rewardXml:RewardXML = Game.database.gamedata.getData(DataType.REWARD, arrRewardIDs[i]) as RewardXML;
				if (rewardXml != null)
				{
					var cell:CellGift = new CellGift();
					cell.init(rewardXml.itemID, rewardXml.type, rewardXml.quantity);
					cell.bg.visible = false;
					
					cell.x = posArr[i][0];
					cell.y = posArr[i][1];
					_arrCellGift.push(cell);
					this.addChild(cell);
				}
			}
		}
		
		private function setCellStatus(cellIndex:int, status:String):void
		{
			var cell:CellGift = _arrCellGift[cellIndex] as CellGift;
			if (cell != null)
				cell.status = status;
		}
		
		public function startAnim(onAnimCompleteHdl:Function):void
		{
			this.onAnimCompleteHdl = onAnimCompleteHdl;
			_myTimer.reset();
			_myTimer.start();
		}
		
		public function stopAnim():void
		{
			_view.btnLuckyGift.mouseEnabled = true;
			_view.closeBtn.mouseEnabled = true;
			_myTimer.stop();
		}
		
		public function reset():void
		{
			_myTimer.reset();
			setCellStatus(_currentIndex, CellGift.NORMAL);
			_currentIndex = 0;
			_currentRound = -_nRound;
			_rewardIndex = -1;
			_activeAnim.visible = false;
			_myTimer.delay = calDelay(_currentRound);
		}
		
		public function get rewardIndex():int
		{
			return _rewardIndex;
		}
		
		public function set rewardIndex(value:int):void
		{
			_rewardIndex = value;
		}
		
		public function showReward():void
		{
			this.onAnimCompleteHdl();
			/*
			var arrRewardIDs:Array = Game.database.gamedata.getConfigData(GameConfigID.REWARD_LUCKY_GIFT_LIST) as Array;
			
			if (_rewardIndex >= 0 && _rewardIndex < arrRewardIDs.length)
			{
				var rewardXml:RewardXML = Game.database.gamedata.getData(DataType.REWARD, arrRewardIDs[_rewardIndex]) as RewardXML;
				if (rewardXml != null)
				{
					var item:IItemConfig = ItemFactory.buildItemConfig(rewardXml.type, rewardXml.itemID);
					if (item != null)
					{
						tweenItem(rewardXml.type, rewardXml.itemID, _rewardIndex, rewardXml.quantity);
						Manager.display.showMessage("Bạn nhận được " + rewardXml.quantity.toString() + " " + item.getName());
					}
					else
						Utility.log("ERROR: onRequestLuckyGiftResponse no itemID: " + rewardXml.itemID);
				}
				else
					Utility.log("ERROR: onRequestLuckyGiftResponse no itemID: " + arrRewardIDs[_rewardIndex]);
			}
			*/
		}
		
		private function tweenItem(type:ItemType, id:int, index:int, quantity:int):void
		{
			//var itemSlot:ItemSlot = new ItemSlot();
			_itemSlot = Manager.pool.pop(ItemSlot) as ItemSlot;
			_itemSlot.setConfigInfo(ItemFactory.buildItemConfig(type, id), TooltipID.ITEM_COMMON);
			_itemSlot.setQuantity(quantity);

			_itemSlot.x = posArr[_currentIndex][0];
			_itemSlot.y = posArr[_currentIndex][1];
			
			UtilityEffect.tweenItemEffect(_itemSlot, type, onCompletedFunc);
		}
		
		private function onCompletedFunc():void
		{
			if (_itemSlot)
			{
				_itemSlot.reset();
				Manager.pool.push(_itemSlot, ItemSlot);
			}
		}
	}

}