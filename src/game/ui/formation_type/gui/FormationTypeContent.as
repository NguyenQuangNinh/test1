package game.ui.formation_type.gui
{
	import core.event.EventEx;
	import core.util.FontUtil;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import game.data.model.item.ItemFactory;
	import game.data.vo.formation.FormationStat;
	import game.data.xml.FormationTypeXML;
	import game.enum.Font;
	import game.enum.ItemType;
	import game.Game;
	import game.ui.components.ItemSlot;
	import game.ui.tooltip.TooltipID;
	import game.ui.tutorial.TutorialEvent;

	/**
	 * ...
	 * @author chuongth2
	 */
	public class FormationTypeContent extends MovieClip
	{
		
		public static const EVENT_UPGRADE_FORMATION_TYPE:String = "event_upgrade_formation_type";
		
		public var nameTf:TextField;
		public var descriptionTf:TextField;
		public var rateTf:TextField;
		public var goldTf:TextField;
		public var levelTf:TextField;
		public var btnUpgrade:SimpleButton;
		public var formationTypeEffectContainer:FormationTypeEffectContainer;
		
		private var currentFormationTypeID:int = 0;
		private var itemSlot:ItemSlot = new ItemSlot();
		
		private var hasItem:int;
		private var needItem:int;
		private var needGold:int;

		public function FormationTypeContent()
		{
			FontUtil.setFont(nameTf, Font.ARIAL, true);
			FontUtil.setFont(descriptionTf, Font.ARIAL);
			FontUtil.setFont(rateTf, Font.ARIAL, true);
			FontUtil.setFont(goldTf, Font.ARIAL, true);
			FontUtil.setFont(levelTf, Font.ARIAL);
			
			btnUpgrade.addEventListener(MouseEvent.CLICK, onBtnUpgradeHandler);
			btnUpgrade.visible = false;
			itemSlot.x = 130;
			itemSlot.y = 80;
			itemSlot.setScaleItemSlot(0.7);
			this.addChild(itemSlot);
			itemSlot.visible = false;
		}
		
		private function onBtnUpgradeHandler(e:Event):void
		{
			
			if (currentFormationTypeID > 0)
			{
				var obj:Object = [];
				obj.nID = currentFormationTypeID;
				this.dispatchEvent(new EventEx(EVENT_UPGRADE_FORMATION_TYPE, obj, true));
				Game.stage.dispatchEvent(new EventEx(TutorialEvent.EVENT, {type: TutorialEvent.UPGRADE_FORMATION_TYPE}, true));
				itemSlot.setTextQuantity(hasItem + "/" + needItem);
			}
		}
		
		public function showContent(formationTypeXML:FormationTypeXML, levelFormationType:int, level:int):void
		{
			if (formationTypeXML && levelFormationType < formationTypeXML.arrRateUpgrade.length && levelFormationType >= 0)
			{
				currentFormationTypeID = formationTypeXML.ID;
				nameTf.text = formationTypeXML.name.toLocaleUpperCase();
				descriptionTf.text = formationTypeXML.description;
				rateTf.text = "Tỷ lệ " + formationTypeXML.arrRateUpgrade[levelFormationType] + "%";
				goldTf.text = "x" + formationTypeXML.arrGoldUpgrade[levelFormationType];
				levelTf.text = "Cấp trận hình:" + levelFormationType;
				itemSlot.setConfigInfo(ItemFactory.buildItemConfig(ItemType.FORMATION_TYPE_SCROLL, formationTypeXML.upgradeItemID), TooltipID.ITEM_COMMON);
				
				hasItem = Game.database.inventory.getItemQuantity(ItemType.FORMATION_TYPE_SCROLL, formationTypeXML.upgradeItemID);
				needItem = formationTypeXML.arrItemQuantityUpgrade[levelFormationType];
				needGold = formationTypeXML.arrGoldUpgrade[levelFormationType];

				itemSlot.setTextQuantity(hasItem + "/" + needItem);
				
				itemSlot.visible = true;
				btnUpgrade.visible = true;
				formationTypeEffectContainer.reset();
				
				formationTypeEffectContainer.init(formationTypeXML, levelFormationType, level);
			}
		}
		
		public function reset():void
		{
			nameTf.text = "";
			descriptionTf.text = "";
			rateTf.text = "Tỷ lệ";
			goldTf.text = "";
			levelTf.text = "Cấp trận hình:";
			btnUpgrade.visible = false;
			currentFormationTypeID = 0;
			itemSlot.visible = false;
			formationTypeEffectContainer.reset();
		}
		
		public function reUpdate():void
		{
			if (currentFormationTypeID > 0)
			{
				var formationStat:FormationStat = Game.database.userdata.formationStat;
				var bUsing:Boolean = currentFormationTypeID == formationStat.ID; //current using
				formationTypeEffectContainer.reUpdate(bUsing);
			}
		}
	}

}