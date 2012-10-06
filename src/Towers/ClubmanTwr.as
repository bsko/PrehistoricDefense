package Towers 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	/**
	 * ...
	 * @author author
	 */
	public class ClubmanTwr extends Tower
	{
		public static const NAME:String = "ClubmanTwr";
		
		public function ClubmanTwr() 
		{
			//базовые характеристики
			_baseAttackRange  = 100;
			_baseAttackSpeed = 1500;
			_baseDamageMin = 4;
			_baseDamageMax = 16;
			_baseGoldCost = TowerData.baseGoldCostsArray[9];
			_baseWheatCost = TowerData.baseWhealCostsArray[9];
			_baseHealth = 100;
			type = NAME;
			_damageType = DamageTypes.BLUNT;
			
			//множители к базовым характеристикам
			_koefLevelToDmgMaxAbsolute = 1;
			_koefLevelToDmgMinAbsolute = 1;
			_koefLevelToAttackSpeed = 0.0;
			_koefLevelToDmgMax = 0.05;
			_koefLevelToDmgMin = 0.05;
			_koefLevelToRange = 0.0;
			_koefLevelToHealth = 0.1;
			
			criticalChance = 5;
			criticalPower = 2.2;
			accuracy = 70;
			updateReferences();
			
			towerMovie = new Clubman_movie_full();
			towerMovie.stop();
			towerMovie.scaleX = 0.85;
			towerMovie.scaleY = 0.85;
			towerMovie.stop();
			
			(towerMovie.getChildAt(0) as MovieClip).stop();
			
			_descriptionText = "Everything started when a monkey took a stick. This is an absolutely inexperienced soldier; his strong point is good luck. More experienced soldiers can break animals’ bones";
			_attackTimer.delay = _attackSpeed;
			
			_skillsArray = [];
			_skillsArray.push(new RealTowerSkill(0, App.skills.training));
			_skillsArray.push(new RealTowerSkill(0, App.skills.armorBreaker));
			_skillsArray.push(new RealTowerSkill(0, App.skills.longWeapons)); 
			_skillsArray.push(new RealTowerSkill(0, App.skills.heavyClub));
			_skillsArray.push(new RealTowerSkill(0, App.skills.bonebraker)); 
			_skillsArray.push(new RealTowerSkill(0, App.skills.slowPercentage));
			_skillsArray.push(new RealTowerSkill(0, App.skills.mortalBlow));
			_skillsArray.push(new RealTowerSkill(0, App.skills.heavyStrike));
			calculateSkills();
			addChild(towerMovie);
		}
		
		override protected function onShoot(e:Event):void 
		{
			super.onShoot(e);
			if (_curEnemyToAttack != null)
			{
				_curEnemyToAttack.enemyTakingDamage(this);
				App.soundControl.playSound("hit_blunt");
			}
		}
		
		override public function destroy():void 
		{
			super.destroy();
			App.pools.returnPoolObject(NAME, this);
		}
		
	}

}