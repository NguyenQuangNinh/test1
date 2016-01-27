package game.ui.treasure.gui
{

	import core.Manager;
	import core.display.animation.Animator;

	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	import game.Game;
	import game.data.model.item.ItemFactory;
	import game.data.xml.DataType;
	import game.data.xml.RewardXML;
	import game.enum.ItemType;
	import game.ui.components.ItemSlot;
	import game.ui.tooltip.TooltipID;
	import game.ui.treasure.TreasureView;
	import game.utility.UtilityEffect;

	/**
	 * ...
	 * @author xxx
	 */
	public class CellTreasureContainer extends Sprite
	{
		private var _nRound:int = 8;
		private var _nDelay:int = 8;
		private var _arrCellGift:Array;
		private var _myTimer:Timer;
		private var _currentIndex:int;
		private var _currentRound:int;
		private var _rewardIndex:int;

		private var _view:TreasureView;
		private var _activeAnim:Animator;

		private var _itemSlot:ItemSlot;
		private var onAnimCompleteHdl:Function;

		private var posArr:Array = [[277,134],[350,134],[424,134],[498,134],[571.8,134],[645.6,134]
			,[645.6,208.5],[645.6,283],[645.6,357.5],[645.6,432]
			,[572,432],[498,432],[424.5,432],[351,432],[277,432]
			,[277,358],[277,283.5],[277,209]];

		private function calDelay(x:int):int
		{
			return Math.round((x * x) + _nDelay);
		}

		public function CellTreasureContainer(view:TreasureView)
		{

			_currentIndex = 0;
			_currentRound = -_nRound;

			_arrCellGift = new Array();
			_myTimer = new Timer(calDelay(_currentRound), posArr.length * _nRound);
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
				{
					_myTimer.delay = calDelay(_currentRound);
				}
				else
				{
					_myTimer.delay += calDelay(_currentRound + 3) * 2;
				}
				//trace("----_currentRound:" + _currentRound);
				//trace("-----_myTimer.delay:" + _myTimer.delay);
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
					cell.bg.visible = true;

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
			{
				cell.status = status;
			}
		}

		public function startAnim(onAnimCompleteHdl:Function):void
		{
			this.onAnimCompleteHdl = onAnimCompleteHdl;
			_myTimer.reset();
			_myTimer.start();
		}

		public function stopAnim():void
		{
			_view.oneBtn.mouseEnabled = true;
			_view.tenBtn.mouseEnabled = true;
			_view.fiftyBtn.mouseEnabled = true;
			_view.closeBtn.mouseEnabled = true;
			_myTimer.stop();
		}

		public function isRunning():Boolean
		{
			return _myTimer.running;
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