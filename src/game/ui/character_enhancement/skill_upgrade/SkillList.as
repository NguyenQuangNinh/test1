package game.ui.character_enhancement.skill_upgrade 
{
	import com.greensock.TweenLite;
	import core.event.EventEx;
	import core.util.MovieClipUtils;
	import core.util.Utility;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import game.data.vo.skill.Skill;
	import game.ui.components.ScrollBar;
	import game.ui.components.VerScroll;
	import game.ui.tutorial.TutorialEvent;
	/**
	 * ...
	 * @author TrungLNM
	 */
	public class SkillList extends MovieClip
	{
		
		private static const BACK_TWEEN:String = "backTween";
		
		public var contentMovie	:MovieClip;
		public var maskMovie	:MovieClip;
		public var scrollbar	:MovieClip;
		private var _skills		:Array = [];
		
		private var _subSkillInfo:SubSkillInfo;
		private var _isTweening:Boolean = false;
		private var _currentOpen:int = -1;
		private var _nextOpen:int = -1;
		
		private var _vScroll:VerScroll;
		
		public function SkillList() {		
			//add event
			addEventListener(SkillInfo.SKILL_CLICK, onSkillClickHdl);
			
			//sub skill info
			_subSkillInfo = new SubSkillInfo();				
			addEventListener(SkillInfo.ANIMATION_COMPLETED, onBackTweenHdl);
			
			_vScroll = new VerScroll(maskMovie, contentMovie, scrollbar, false, -1, 0, 5, false);
			_vScroll.x = scrollbar.x;
			_vScroll.y = scrollbar.y;
			addChild(_vScroll);
		}
		
		private function onBackTweenHdl(e:EventEx):void 
		{
			update(_skills, false);
			if (_nextOpen != -1 && _nextOpen != _currentOpen) {			
				_currentOpen = _nextOpen;
				contentMovie;
				onExpandSkill(_currentOpen);
			}else {
				_currentOpen = e.data == "close" ? -1 : _currentOpen;				
				_nextOpen = -1;				
				_isTweening = false;
			}
			_vScroll.updateScroll();
		}
		
		private function onSkillClickHdl(e:EventEx):void 
		{
			var skill:Skill = e.data as Skill;		
			var selectedIndex:int = _skills.indexOf(skill);
			if (!_isTweening && (selectedIndex >= 0 || selectedIndex <= contentMovie.numChildren - 1)) {
				_nextOpen = selectedIndex;
				_currentOpen = _currentOpen == -1 || _currentOpen == _nextOpen ? _nextOpen : _currentOpen;
				onExpandSkill(_currentOpen);
			}
		}
		
		public function update(info:Array, needReset:Boolean):void {
			_skills = info;
			if(needReset) {
				MovieClipUtils.removeAllChildren(contentMovie);			
				for (var i:int = 0; i < info.length; i++ ) {
					var skill:SkillInfo = new SkillInfo();
					contentMovie.addChild(skill);	
					
					skill.updateInfo(info[i]);
					skill.y += SkillInfo.HEIGHT_CLOSE * i;
				}		
				_currentOpen = _nextOpen = -1;
			}else {
				for (i = 0; i < info.length; i++) {
					var sumHeight:int = 0;
					for (var j:int = 0; j < i; j++) {
						sumHeight += (contentMovie.getChildAt(j) as SkillInfo).getHeightByState();
					}
					skill = contentMovie.getChildAt(i) as SkillInfo;
					skill.y = sumHeight;
					skill.updateInfo(info[i]);
				}
			}		
			_vScroll.updateScroll();
		}
		
		private function onExpandSkill(index: int): void {	
			var skillInfo:SkillInfo = contentMovie.getChildAt(index) as SkillInfo;
			if (skillInfo && skillInfo.getState() == "close") {
				_isTweening = true;
				//open skill click
				skillInfo.openSubInfo(_subSkillInfo);
				
				var timeTween:Number = skillInfo.getDeltaExpand() / SkillInfo.HEIGHT_CLOSE * 0.05;
				timeTween = Number(timeTween.toFixed(1));
				//Utility.log( "SkillList.timeTween --> open : " + timeTween );
				for (var i:int = contentMovie.numChildren - 1; i > index; i--) {
					//TweenLite.to(contentMovie.getChildAt(i), 0.4, 
					TweenLite.to(contentMovie.getChildAt(i), timeTween, 
								//{ y: int(contentMovie.getChildAt(i).y) + (SkillInfo.HEIGHT_OPEN - SkillInfo.HEIGHT_CLOSE)} );
								{ y: int(contentMovie.getChildAt(i).y) + skillInfo.getDeltaExpand()} );
				}
				dispatchEvent(new EventEx(TutorialEvent.EVENT, { type:TutorialEvent.EXPAND_SKILL_INFO }, true));
			}else if(skillInfo && skillInfo.getState() == "open") {
				_isTweening = true;
				//close skill click
				skillInfo.closeSubInfo();
				
				timeTween = skillInfo.getDeltaExpand() / SkillInfo.HEIGHT_CLOSE * 0.05;
				timeTween = Number(timeTween.toFixed(1));
				//Utility.log( "SkillList.timeTween --> close : " + timeTween );
				for (i = contentMovie.numChildren - 1; i > index; i--) {
					//TweenLite.to(contentMovie.getChildAt(i), 0.4, 
					TweenLite.to(contentMovie.getChildAt(i), timeTween, 
								//{ y: int(contentMovie.getChildAt(i).y) - (SkillInfo.HEIGHT_OPEN - SkillInfo.HEIGHT_CLOSE)} );
								{ y: int(contentMovie.getChildAt(i).y) - skillInfo.getDeltaExpand()} );
				}
			}				
		}
	}

}