package game.ui.character_enhancement.skill_upgrade 
{
	import com.greensock.TweenLite;
	import core.event.EventEx;
	import core.Manager;
	import core.util.FontUtil;
	import core.util.Utility;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import game.data.vo.skill.Skill;
	import game.enum.Font;
	import game.enum.GameConfigID;
	import game.enum.SkillType;
	import game.Game;
	import game.main.SkillSlot;
	/**
	 * ...
	 * @author TrungLNM
	 */
	public class SkillInfo extends MovieClip
	{
		
		public static const SKILL_CLICK:String = "skillClick";
		public static const EQUIP_SKILL:String = "equipSkill";
		public static const ANIMATION_COMPLETED:String = "animationCompleted";
		public static const CHANGE_SKILL:String = "SKILL_INFO_CHANGE_SKILL";

		private static const SUB_INFO_START_FROM_X:int = 10;
		private static const SUB_INFO_START_FROM_Y:int = 56;
		
		public static const HEIGHT_CLOSE:int = 50;
		public static const HEIGHT_OPEN:int = 210;
		
		public var nameTf				:TextField;
		public var levelTf				:TextField;
		public var equipTf				:TextField;
		public var skillSlotContainer	:MovieClip;
		public var equipBtn				:SimpleButton;
		public var changeBtn				:SimpleButton;
		public var bgMov				:MovieClip;
		public var hitMov				:MovieClip;
		
		private var _skill			:Skill;
		private var _subInfo		:MovieClip;
		private var _state			:String = "close";

		public function SkillInfo() {
			initUI();
		}
		
		private function initUI():void 	{
			FontUtil.setFont(nameTf, Font.ARIAL, false);
			FontUtil.setFont(levelTf, Font.ARIAL, false);
			FontUtil.setFont(equipTf, Font.ARIAL, true);
			
			//skill slot
			var skillSlot:SkillSlot = new SkillSlot();
//			skillSlot.x = skillSlot.y = 1;
			skillSlot.showHotKey(false);
			skillSlotContainer.addChild(skillSlot);
			skillSlotContainer.mouseChildren = true;
			
			//hit mov
			//hitMov.visible = false;
			//hitMov.visible = true;
			hitMov.buttonMode = true;
			hitMov.addEventListener(MouseEvent.CLICK, onHitClickHdl);
			/*var rectangle:Shape = new Shape(); // initializing the variable named rectangle
			   rectangle.graphics.beginFill(0xFF0000); // choosing the colour for the fill, here it is red
			   rectangle.graphics.drawRect(0, 0, hitMov.width, hitMov.height); // (x spacing, y spacing, width, height)
			   rectangle.graphics.endFill(); // not always needed but I like to put it in to end the fill
			   //rectangle.alpha = 0.3;
			 hitMov.addChild(rectangle); // adds the rectangle to the stage*/
			
			equipBtn.addEventListener(MouseEvent.CLICK, onEquipClickHdl);
			changeBtn.addEventListener(MouseEvent.CLICK, onChangeSkillHdl);

			changeBtn.visible = false;
		}

		private function onChangeSkillHdl(event:MouseEvent):void
		{
			dispatchEvent(new EventEx(CHANGE_SKILL, _skill, true));
		}
		
		private function onHitClickHdl(e:MouseEvent):void 
		{
			dispatchEvent(new EventEx(SKILL_CLICK, _skill, true));
		}
		
		private function onEquipClickHdl(e:MouseEvent):void 
		{
			dispatchEvent(new EventEx(EQUIP_SKILL, _skill, true));
		}
		
		/*private function onOpenCompleteHdl(e:Event = null):void 
		{
			if (_subInfo) {
				_subInfo.x = SUB_INFO_START_FROM_X;
				_subInfo.y = SUB_INFO_START_FROM_Y;
				_subInfo.visible = true;
				addChild(_subInfo);
				equipBtn.visible = _skill ? !_skill.isEquipped : false;
				_state = "open";
			}
			dispatchEvent(new EventEx(ANIMATION_COMPLETED, "open", true));
		}
		
		private function onCloseCompleteHdl(e:Event):void 
		{
			bgMov.gotoAndStop(_skill.isEquipped ? "equiped" : "normal");
			_state = "close";		
			dispatchEvent(new EventEx(ANIMATION_COMPLETED, "close", true));
		}*/
		
		public function updateInfo(info:Skill): void {
			_skill = info;
			if (info) {
				var skillSlot:SkillSlot = skillSlotContainer.getChildAt(0) as SkillSlot;
				skillSlot.setData(info);
				
				nameTf.text = _skill.xmlData ? _skill.xmlData.name : "";
				levelTf.text = "Cấp " + _skill.level.toString();
				
				(bgMov["bgNormalMov"] as MovieClip).visible = !_skill.isEquipped && (_skill.xmlData && _skill.xmlData.type != SkillType.PASSIVE);
				(bgMov["bgSelectedMov"] as MovieClip).visible = _skill.isEquipped || (_skill.xmlData && _skill.xmlData.type == SkillType.PASSIVE);
				//bgMov.gotoAndStop(_skill.isEquipped ? "equiped" : "normal");
				
				equipTf.text = _skill.isEquipped || (_skill.xmlData && _skill.xmlData.type == SkillType.PASSIVE) ? "Đang trang bị" : "";
				if (_state == "open" && _subInfo) {
					openSubInfo(_subInfo, false);
				}
				
				var changableSkillList:Array = Game.database.gamedata.getConfigData(277);
				var validQuality:Array = Game.database.gamedata.getConfigData(274);
				
				changeBtn.visible = ((changableSkillList.indexOf(info.xmlData.ID) != -1) && validQuality.indexOf(info.owner.rarity) != -1);
			}else {				
				Utility.log("can not update skill info with NULL info or xmldata");
			}
		}
		
		public function openSubInfo(subInfo:MovieClip, needTween:Boolean = true):void {
			//Utility.log( "SkillInfo.openSubInfo > subInfo : " + subInfo + ", needTween : " + needTween );
			_subInfo = subInfo;
			(_subInfo as SubSkillInfo).updateInfo(_skill);
			hitMov.scaleX = 1;
			(bgMov["bgNormalMov"] as MovieClip).visible = false;
			(bgMov["bgSelectedMov"] as MovieClip).visible = false;
			if (needTween) 
				openAction();
			else 
				openActionComplete(needTween);
		}
		
		private function openAction():void {
			//Utility.log( "SkillInfo.openAction" );
			
			(bgMov["bgHeadMov"] as MovieClip).visible = true;
			(bgMov["bgContentMov"] as MovieClip).height = 0;
			(bgMov["bgContentMov"] as MovieClip).visible = true;
			(bgMov["bgFootMov"] as MovieClip).visible = false;
			
			var timeTween:Number = (_subInfo as SubSkillInfo).height / HEIGHT_CLOSE * 0.05;
			timeTween = Number(timeTween.toFixed(1));
			//Utility.log( "SkillInfo.timeTween --> open action : " + timeTween );
			TweenLite.to(bgMov["bgContentMov"] as MovieClip, timeTween , { height: (_subInfo as SubSkillInfo).height, onComplete:openActionComplete } );				
			//TweenLite.to(bgMov["bgContentMov"] as MovieClip, 0.6 , { height: (_subInfo as SubSkillInfo).height, onComplete:openActionComplete } );				
		}
		
		private function openActionComplete(tween:Boolean = true):void {
			//(bgMov["bgHeadMov"] as MovieClip).visible = true;
			(bgMov["bgFootMov"] as MovieClip).visible = true;
			(bgMov["bgFootMov"] as MovieClip).y = (bgMov["bgContentMov"] as MovieClip).y + (_subInfo as SubSkillInfo).height - 72;
			(bgMov["bgContentMov"] as MovieClip).height = (_subInfo as SubSkillInfo).height - 72;
			//Utility.log( "SkillInfo.openActionComplete " + (bgMov["bgFootMov"] as MovieClip).visible);
			
			if (_subInfo) {
				_subInfo.x = SUB_INFO_START_FROM_X;
				_subInfo.y = SUB_INFO_START_FROM_Y;
				_subInfo.visible = true;
				addChild(_subInfo);
				equipBtn.visible = _skill && _skill.xmlData ? !_skill.isEquipped && _skill.xmlData.type != SkillType.PASSIVE : false;
				_state = "open";
			}
			if(tween)
				dispatchEvent(new EventEx(ANIMATION_COMPLETED, "open", true));
		}
		
		public function closeSubInfo(needTween:Boolean = true):void {
			//Utility.log( "SkillInfo.closeSubInfo > needTween : " + needTween );
			if (_subInfo) 
				_subInfo.visible = false;
			hitMov.scaleX = 1.75;
			equipBtn.visible = false;	
			if (needTween) 
				closeAction();
			else 
				closeActionComplete(needTween);
		}
		
		private function closeAction():void {
			//Utility.log( "SkillInfo.closeAction" );
			_subInfo.visible = false;
			(bgMov["bgFootMov"] as MovieClip).visible = false;
			var timeTween:Number = (_subInfo as SubSkillInfo).height / HEIGHT_CLOSE * 0.05;
			timeTween = Number(timeTween.toFixed(1));
			//Utility.log( "SkillInfo.timeTween --> close action : " + timeTween );
			//TweenLite.to(bgMov["bgContentMov"] as MovieClip, 0.6 , { height: 0, onComplete:closeActionComplete } );
			TweenLite.to(bgMov["bgContentMov"] as MovieClip, timeTween , { height: 0, onComplete:closeActionComplete } );
		}
		
		private function closeActionComplete(tween:Boolean = true):void {
			//Utility.log( "SkillInfo.closeActionComplete" );
			(bgMov["bgHeadMov"] as MovieClip).visible = false;
			(bgMov["bgContentMov"] as MovieClip).visible = false;			
			(bgMov["bgNormalMov"] as MovieClip).visible = !_skill.isEquipped;
			(bgMov["bgSelectedMov"] as MovieClip).visible = _skill.isEquipped;
			
			_state = "close";		
			dispatchEvent(new EventEx(ANIMATION_COMPLETED, "close", true));
		}
		
		public function getState():String {
			return _state;
		}
		
		public function getHeightByState():int {
			var totalOpen:int = (bgMov["bgHeadMov"] as MovieClip).height
								+ (bgMov["bgContentMov"] as MovieClip).height
								+ (bgMov["bgFootMov"] as MovieClip).height;
			var totalClose:int = (bgMov["bgNormalMov"] as MovieClip).height;
			//return _state == "open" ? HEIGHT_OPEN : HEIGHT_CLOSE;
			return _state == "open" ? totalOpen : totalClose;
		}
		
		public function getDeltaExpand():int {
			return _subInfo.height;
		}
	}

}