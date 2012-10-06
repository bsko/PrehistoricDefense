package Towers 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	/**
	 * ...
	 * @author i am
	 */
	public class EliteSpearmanTwr extends Tower
	{
		public static const NAME:String = "EliteSpearmanTwr";
		
		public function EliteSpearmanTwr() 
		{
			//базовые характеристики
			_baseAttackRange  = 100;
			_baseAttackSpeed = 1200;
			_baseDamageMin = 18;
			_baseDamageMax = 38;
			_baseGoldCost = TowerData.baseGoldCostsArray[4];
			_baseWheatCost = TowerData.baseWhealCostsArray[4];
			_baseHealth = 100;
			type = NAME;
			_damageType = DamageTypes.PIKE;
			
			//множители к базовым характеристикам
			_koefLevelToAttackSpeed = 0.0;
			_koefLevelToDmgMax = 0.04;
			_koefLevelToDmgMin = 0.06;
			_koefLevelToRange = 0.0;
			_koefLevelToHealth = 0.1;
			
			criticalChance = 10;
			criticalPower = 2.6;
			accuracy = 73;
			updateReferences();
			
			towerMovie = new elite_spearman_movie_full();
			towerMovie.stop();
			towerMovie.scaleX = 0.85;
			towerMovie.scaleY = 0.85;
			towerMovie.stop();
			(towerMovie.getChildAt(0) as MovieClip).stop();
			
			_descriptionText = "Iron was a rare material, only elite soldiers wore iron-framed shields and spears with iron points. He has big destruction radius, reaching even far targets";
			_attackTimer.delay = _attackSpeed;
			
			_skillsArray = [];
			_skillsArray.push(new RealTowerSkill(0, App.skills.lightPike));
			_skillsArray.push(new RealTowerSkill(0, App.skills.accuracy));
			_skillsArray.push(new RealTowerSkill(0, App.skills.longWeapons));
			_skillsArray.push(new RealTowerSkill(0, App.skills.breakingStrike));
			_skillsArray.push(new RealTowerSkill(0, App.skills.shildStrike));
			_skillsArray.push(new RealTowerSkill(0, App.skills.heavyShield));
			_skillsArray.push(new RealTowerSkill(0, App.skills.exploreTarget));
			_skillsArray.push(new RealTowerSkill(0, App.skills.deadlyHit));
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