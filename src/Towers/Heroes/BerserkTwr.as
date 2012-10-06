package Towers.Heroes 
{
	import Events.PauseEvent;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	/**
	 * ...
	 * @author i am
	 */
	public class BerserkTwr extends Tower
	{
		public static const NAME:String = "BerserkTwr";
		private static const AURA_RANGE:int = 300;
		private var _auraTimer:Timer = new Timer(5000);
		
		public function BerserkTwr() 
		{
			//базовые характеристики
			_isHero = true;
			_baseAttackRange  = 100;
			_baseAttackSpeed = 900;
			_baseDamageMin = 20;
			_baseDamageMax = 28;
			_baseGoldCost = 10;
			_baseWheatCost = 10;
			_baseHealth = 100;
			type = NAME;
			_damageType = DamageTypes.SWORD;
			
			//множители к базовым характеристикам
			_koefLevelToAttackSpeed = 0.0;
			_koefLevelToDmgMax = 0.09;
			_koefLevelToDmgMin = 0.1;
			_koefLevelToRange = 0.0;
			_koefLevelToHealth = 0.13;
			
			criticalChance = 3;
			criticalPower = 2;
			accuracy = 45;
			updateReferences();
			
			towerMovie = new berserk_movie_full();
			towerMovie.stop();
			towerMovie.scaleX = 0.85;
			towerMovie.scaleY = 0.85;
			towerMovie.stop();
			(towerMovie.getChildAt(0) as MovieClip).stop();
			
			_descriptionText = "His name is Malcolin. A muscular dark skinned soldier. He has lived all his life wandering in deserts. He is able to encourage all other soldiers surrounding him. And two yataghans can kill not one enemy. ";
			_attackTimer.delay = _attackSpeed;
			
			_skillsArray = [];
			_skillsArray.push(new RealTowerSkill(0, App.skills.bladeMastery));
			_skillsArray.push(new RealTowerSkill(0, App.skills.demoralization));
			_skillsArray.push(new RealTowerSkill(0, App.skills.exactBleedingStrike));
			_skillsArray.push(new RealTowerSkill(0, App.skills.strongMagicPower));
			_skillsArray.push(new RealTowerSkill(0, App.skills.mortalBlow));
			_skillsArray.push(new RealTowerSkill(0, App.skills.piercingShot));
			_skillsArray.push(new RealTowerSkill(0, App.skills.ancientsPower));
			_skillsArray.push(new RealTowerSkill(0, App.skills.auraDamage));
			calculateSkills();
			addChild(towerMovie);
		}
		
		override public function Init(cellOwner:Grid, SkillsArray:Array = null):void 
		{
			super.Init(cellOwner, SkillsArray);
			_auraTimer.start();
			_auraTimer.addEventListener(TimerEvent.TIMER, onFindTowersForAura, false, 0, true);
		}
		
		private function onFindTowersForAura(e:TimerEvent):void 
		{
			if (_skillsArray[6].currentLevel > 0)
			{
				var tmpArray:Array = App.universe.towersArray;
				var length:int = tmpArray.length;
				var tmpTower:Tower;
				for (var i:int = 0; i < length; i++)
				{
					tmpTower = tmpArray[i];
					if (tmpTower.BonusesObject.auraDamage == 0)
					{
						tmpTower.BonusesObject.auraDamage = _skillsInfluence.addedDamageAura;
						tmpTower.calculateAddedDamage();
					}
				}
			}
		}
		
		override protected function onShoot(e:Event):void 
		{
			super.onShoot(e);
			if (_curEnemyToAttack != null)
			{
				_curEnemyToAttack.enemyTakingDamage(this);
				App.soundControl.playSound("hit_sword");
			}
		}
		
		override protected function onPauseEvent(e:PauseEvent):void 
		{
			super.onPauseEvent(e);
			var tmpTimer:Timer;
			if (_auraTimer.running)
			{
				tmpTimer = _auraTimer;
				tmpTimer.stop();
				_TimersArray.push(tmpTimer);
			}
		}
		
		override public function destroy():void 
		{
			_auraTimer.reset();
			_auraTimer.removeEventListener(TimerEvent.TIMER, onFindTowersForAura, false);
			super.destroy();
			App.pools.returnPoolObject(NAME, this);
		}
	}

}