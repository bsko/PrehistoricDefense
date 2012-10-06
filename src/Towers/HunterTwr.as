package Towers 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	/**
	 * ...
	 * @author i am
	 */
	public class HunterTwr extends Tower
	{
		public static const NAME:String = "HunterTwr";
		
		public function HunterTwr() 
		{
			//базовые характеристики
			_baseAttackRange  = 100;
			_baseAttackSpeed = 1400;
			_baseDamageMin = 8;
			_baseDamageMax = 18;
			_baseGoldCost = TowerData.baseGoldCostsArray[1];
			_baseWheatCost = TowerData.baseWhealCostsArray[1];
			_baseHealth = 100;
			type = NAME;
			_damageType = DamageTypes.PIKE;
			
			//множители к базовым характеристикам
			_koefLevelToAttackSpeed = 0.0;
			_koefLevelToDmgMax = 0.08;
			_koefLevelToDmgMin = 0.08;
			_koefLevelToRange = 0.0;
			_koefLevelToHealth = 0.1;
			
			criticalChance = 4;
			criticalPower = 2.6;
			accuracy = 60;
			updateReferences();
			
			towerMovie = new double_spearman_movie_full();
			towerMovie.stop();
			towerMovie.scaleX = 0.85;
			towerMovie.scaleY = 0.85;
			towerMovie.stop();
			(towerMovie.getChildAt(0) as MovieClip).stop();
			
			_descriptionText = "A more experienced soldier. He can’t be called “elite” yet, but long trainings let the hunter use shaft arms more effectively";
			_attackTimer.delay = _attackSpeed;
			
			_skillsArray = [];
			_skillsArray.push(new RealTowerSkill(0, App.skills.lightPike));
			_skillsArray.push(new RealTowerSkill(0, App.skills.accuracy));
			_skillsArray.push(new RealTowerSkill(0, App.skills.longWeapons));
			_skillsArray.push(new RealTowerSkill(0, App.skills.breakingStrike));
			_skillsArray.push(new RealTowerSkill(0, App.skills.eyesBreaker));
			_skillsArray.push(new RealTowerSkill(0, App.skills.perfectEye));
			_skillsArray.push(new RealTowerSkill(0, App.skills.bodybuilding));
			_skillsArray.push(new RealTowerSkill(0, App.skills.thiefMastery));
			calculateSkills();
			addChild(towerMovie);
		}
		
		override protected function onShoot(e:Event):void 
		{
			super.onShoot(e);
			if (_curEnemyToAttack != null)
			{
				_curEnemyToAttack.enemyTakingDamage(this);
				App.soundControl.playSound("hit_flesh");
			}
		}
		
		override public function destroy():void 
		{
			super.destroy();
			App.pools.returnPoolObject(NAME, this);
		}
		
	}

}