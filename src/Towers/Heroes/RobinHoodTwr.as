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
	public class RobinHoodTwr extends Tower
	{
		public static const NAME:String = "RobinHoodTwr";
		private static const AURA_RANGE:int = 300;
		private var bulletType:int = Bullet.ARROW;
		private var _auraTimer:Timer = new Timer(5000);
		
		public function RobinHoodTwr() 
		{
			//базовые характеристики
			_isHero = true;
			_baseAttackRange  = 200;
			_baseAttackSpeed = 1100;
			_baseDamageMin = 8;
			_baseDamageMax = 22;
			_baseGoldCost = 10;
			_baseWheatCost = 10;
			_baseHealth = 100;
			type = NAME;
			_damageType = DamageTypes.PIKE;
			isAirKiller = true;
			
			//множители к базовым характеристикам
			_koefLevelToAttackSpeed = 0.0;
			_koefLevelToDmgMax = 0.07;
			_koefLevelToDmgMin = 0.13;
			_koefLevelToRange = 0.0;
			_koefLevelToHealth = 0.1;
			
			criticalChance = 12;
			criticalPower = 3.2;
			accuracy = 72;
			updateReferences();
			
			towerMovie = new robin_hood_movie_full();
			towerMovie.stop();
			towerMovie.scaleX = 0.85;
			towerMovie.scaleY = 0.85;
			towerMovie.stop();
			(towerMovie.getChildAt(0) as MovieClip).stop();
			
			_descriptionText = "His name is Fragonor. A forest inhabitant, the best hunter, the best teacher. He conducts trainings in the camp showing young soldiers all the most vulnerable parts of animals";
			_attackTimer.delay = _attackSpeed;
			
			_skillsArray = [];
			_skillsArray.push(new RealTowerSkill(0, App.skills.perfectEye));
			_skillsArray.push(new RealTowerSkill(0, App.skills.tripleShot));
			_skillsArray.push(new RealTowerSkill(0, App.skills.exactBleedingStrike));
			_skillsArray.push(new RealTowerSkill(0, App.skills.deadlyStrike));
			_skillsArray.push(new RealTowerSkill(0, App.skills.steelArrows));
			_skillsArray.push(new RealTowerSkill(0, App.skills.ancientsPower));
			_skillsArray.push(new RealTowerSkill(0, App.skills.perfectAccuracy));
			_skillsArray.push(new RealTowerSkill(0, App.skills.auraCriticalPower));
			calculateSkills();
			addChild(towerMovie);
		}
		
		override public function Init(cellOwner:Grid, SkillsArray:Array = null):void 
		{
			super.Init(cellOwner, SkillsArray);
			_auraTimer.start();
			_auraTimer.addEventListener(TimerEvent.TIMER, onFindTowersForAura, false, 0, true);
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
		
		override protected function shootTo():void 
		{
			super.shootTo();
			App.soundControl.playSound("arrow_shooting");
		}
		
		private function onFindTowersForAura(e:TimerEvent):void 
		{
			if (_skillsArray[7].currentLevel > 0)
			{
				var tmpArray:Array = App.universe.towersArray;
				var length:int = tmpArray.length;
				var tmpTower:Tower;
				for (var i:int = 0; i < length; i++)
				{
					tmpTower = tmpArray[i];
					if (tmpTower.BonusesObject.auraCritPower == 0)
					{
						tmpTower.BonusesObject.auraCritPower = _skillsInfluence.addedCriticalPowerAura;
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
				var tmpBullet:Bullet = App.pools.getPoolObject(Bullet.NAME);
				tmpBullet.Init(bulletType, this, _curEnemyToAttack, false);
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