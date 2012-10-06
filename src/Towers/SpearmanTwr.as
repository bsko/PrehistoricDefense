package Towers 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	/**
	 * ...
	 * @author i am
	 */
	public class SpearmanTwr extends Tower
	{
		public static const NAME:String = "SpearmanTwr";
		
		public function SpearmanTwr() 
		{
			//базовые характеристики
			_baseAttackRange  = 100;
			_baseAttackSpeed = 1100;
			_baseDamageMin = 6;
			_baseDamageMax = 9;
			_baseGoldCost = TowerData.baseGoldCostsArray[0];
			_baseWheatCost = TowerData.baseWhealCostsArray[0];
			_baseHealth = 100;
			type = NAME;
			_damageType = DamageTypes.PIKE;
			
			//множители к базовым характеристикам
			_koefLevelToAttackSpeed = 0.0;
			_koefLevelToDmgMax = 0.07;
			_koefLevelToDmgMin = 0.07;
			_koefLevelToRange = 0.0;
			_koefLevelToHealth = 0.1;
			
			criticalChance = 3;
			criticalPower = 2.6;
			accuracy = 60;
			updateReferences();
			
			towerMovie = new elite_spearman_movie_fullcopy222();
			towerMovie.stop();
			towerMovie.scaleX = 0.85;
			towerMovie.scaleY = 0.85;
			towerMovie.stop();
			(towerMovie.getChildAt(0) as MovieClip).stop();
			
			_descriptionText = "danceman yweeeeeeeeeeeeeeeeeee tra ta ti ta ti ta ta bla bla bla!"
			_attackTimer.delay = _attackSpeed;
			
			_skillsArray = [];
			_skillsArray.push(new RealTowerSkill(0, App.skills.lightPike));
			_skillsArray.push(new RealTowerSkill(0, App.skills.accuracy));
			_skillsArray.push(new RealTowerSkill(0, App.skills.longWeapons));
			_skillsArray.push(new RealTowerSkill(0, App.skills.breakingStrike));
			_skillsArray.push(new RealTowerSkill(0, App.skills.penetratingEdge));
			_skillsArray.push(new RealTowerSkill(0, App.skills.perfectEye));
			_skillsArray.push(new RealTowerSkill(0, App.skills.bodybuilding));
			_skillsArray.push(new RealTowerSkill(0, App.skills.PikeBreaker));
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