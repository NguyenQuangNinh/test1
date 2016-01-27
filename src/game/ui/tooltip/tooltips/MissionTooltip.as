package game.ui.tooltip.tooltips 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.filters.GlowFilter;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormatAlign;
	
	import core.Manager;
	import core.util.FontUtil;
	import core.util.TextFieldUtil;
	
	import game.data.model.item.ItemFactory;
	import game.data.vo.reward.RewardInfo;
	import game.data.xml.MissionXML;
	import game.enum.Font;
	import game.enum.ItemType;
	import game.ui.components.ItemSlot;
	import game.ui.tooltip.TooltipBase;
	import game.utility.GameUtil;
	/**
	 * ...
	 * @author anhtinh
	 */
	public class MissionTooltip extends TooltipBase
	{
		private static const MOB_WIDTH:int = 70;
		private static const MOB_HEIGHT:int = 80;
		private static const ITEM_WIDTH:int = 65;
		private static const ITEM_HEIGHT:int = 65;
		private static const glow : GlowFilter = new GlowFilter(0x990000, 1, 3, 3, 5);
		private static const MIN_WIDTH	:int = 180;
			
		public var nameTf : TextField;
		public var requireApTf : TextField;
		public var mobTitleTf : TextField;
		public var rewardTitleTf : TextField;
		public var bgMov : MovieClip;
		public var lbRandomRewards:TextField;
		
		private var _mobContainer : Sprite = new Sprite();
		private var _rewardContainer : Sprite = new Sprite();
		private var containerRandomRewards:Sprite = new Sprite();
		private var _missionXML : MissionXML;
		
		public function MissionTooltip() 
		{
			FontUtil.setFont(nameTf, Font.ARIAL, true);
			FontUtil.setFont(requireApTf, Font.ARIAL, true);
			FontUtil.setFont(mobTitleTf, Font.ARIAL);
			FontUtil.setFont(rewardTitleTf, Font.ARIAL);
			bgMov.scale9Grid = new Rectangle(100, 100, 30, 80);
			
			_mobContainer.x = 10;
			_mobContainer.y = 90;
			this.addChild(_mobContainer);
			
			_rewardContainer.x = 10;
			this.addChild(_rewardContainer);
			containerRandomRewards.x = 10;
			addChild(containerRandomRewards);
			
			//rewardTitleTf.visible = false;
		}
		
		public function set content(missionXML : MissionXML) : void {
			
			if (this._missionXML == missionXML) return ;
			
			this._missionXML = missionXML;
			
			while (_mobContainer.numChildren > 0) 
			{
				//mobContainer.removeChildAt(0);
				var wave:Sprite = _mobContainer.getChildAt(0) as Sprite
				for (var z:int = 0; z < wave.numChildren; z++) {
					var slot:Sprite = wave.getChildAt(z) as Sprite;
					if (slot is ItemSlot) {
						(slot as ItemSlot).reset();
						Manager.pool.push(slot, ItemSlot);
					}
				}
				_mobContainer.removeChild(wave);
			}
			
			while (_rewardContainer.numChildren > 0) 
			{
				//rewardContainer.removeChildAt(0);
				var child:ItemSlot = _rewardContainer.getChildAt(0) as ItemSlot;
				child.reset();
				Manager.pool.push(child, ItemSlot);
				_rewardContainer.removeChild(child);
			}
			
			while(containerRandomRewards.numChildren > 0)
			{
				child = containerRandomRewards.getChildAt(0) as ItemSlot;
				child.reset();
				Manager.pool.push(child, ItemSlot);
				containerRandomRewards.removeChildAt(0);
			}
			
			nameTf.text = missionXML.name;
			nameTf.width = nameTf.textWidth + 20;
			
			requireApTf.text = "" + missionXML.aPRequirement;
			
			var waves : Array =  missionXML.waves;
			var waveMobLevels : Array =  missionXML.waveMobLevels;
			
			var maxWidth : int = 0;
			var waveContainer : Sprite;
			for (var i:int = 0; i < waves.length; i++) 
			{
				waveContainer = new Sprite();
				
				var waveLength : int =  waves[i].length;
				maxWidth = Math.max(maxWidth, waveLength * MOB_WIDTH);
				
				for (var j:int = 0; j < waveLength; j++) 
				{
					//var itemSlot : ItemSlot = new ItemSlot();
					var itemSlot: ItemSlot = Manager.pool.pop(ItemSlot) as ItemSlot;
					itemSlot.x = j * MOB_WIDTH;
					itemSlot.y = 0;
					itemSlot.setConfigInfo(ItemFactory.buildItemConfig(ItemType.UNIT, waves[i][j]));
					itemSlot.setUnitLevel(waveMobLevels[i][j]);
					waveContainer.addChild(itemSlot);
				}
				waveContainer.x = 0 ;
				waveContainer.y = i * MOB_HEIGHT ;
				_mobContainer.addChild(waveContainer);
			}
			
			var rewardInfos : Array = GameUtil.getRewardConfigs(missionXML.fixRewardIDs);
			for (var k:int = 0; k < rewardInfos.length; k++) 
			{
				//var rewardSlot : ItemSlot = new ItemSlot();
				var rewardSlot: ItemSlot = Manager.pool.pop(ItemSlot) as ItemSlot;
				rewardSlot.x = (k % 5) * ITEM_WIDTH;
				rewardSlot.y = Math.floor(k /5) * ITEM_HEIGHT;
				rewardSlot.setConfigInfo(RewardInfo(rewardInfos[k]).itemConfig);
				rewardSlot.setQuantity(RewardInfo(rewardInfos[k]).quantity);
				_rewardContainer.addChild(rewardSlot);
			}
			
			rewardTitleTf.y =  waves.length * MOB_HEIGHT + 95;
			_rewardContainer.y = waves.length * MOB_HEIGHT + 120;
			
			maxWidth = Math.max(maxWidth, Math.min(rewardInfos.length, 5) * ITEM_WIDTH);
			var currentY:int = _rewardContainer.y + int((rewardInfos.length + 4) / 5) * ITEM_HEIGHT;
			
			rewardInfos = GameUtil.getRewardConfigs(missionXML.randomRewardIDs);
			if(rewardInfos.length == 0)
			{
				lbRandomRewards.visible = false;
			}
			else
			{
				lbRandomRewards.visible = true;
				lbRandomRewards.y = currentY;
				maxWidth = Math.max(maxWidth, lbRandomRewards.width);
				currentY += lbRandomRewards.height + 5;
			}
			for(i = 0; i < rewardInfos.length; ++i)
			{
				rewardSlot = Manager.pool.pop(ItemSlot) as ItemSlot;
				rewardSlot.x = (i % 5) * ITEM_WIDTH;
				rewardSlot.y = int(i / 5) * ITEM_HEIGHT;
				rewardSlot.setConfigInfo(RewardInfo(rewardInfos[i]).itemConfig);
				rewardSlot.setQuantity(RewardInfo(rewardInfos[i]).quantity);
				containerRandomRewards.addChild(rewardSlot);
			}
			containerRandomRewards.y = currentY;
			maxWidth = Math.max(maxWidth, Math.min(rewardInfos.length, 5) * ITEM_WIDTH, MIN_WIDTH);
			currentY += int((rewardInfos.length + 4) / 5) * ITEM_HEIGHT;
			
			this.bgMov.width = maxWidth + 10;
			this.bgMov.height = currentY;
		}
		
		override public function get height() : Number {
			return this.bgMov.height;
		}
		
		override public function get width() : Number {
			return this.bgMov.width;
		}
	}

}