package Towers 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	/**
	 * ...
	 * @author i am
	 */
	public class RegularSpearmanTwr extends Tower
	{
		public static const NAME:String = "RegularSpearmanTwr";
		
		public function RegularSpearmanTwr() 
		{
			//базовые характеристики
			_baseAttackRange  = 100;
			_baseAttackSpeed = 1200;
			_baseDamageMin = 12;
			_baseDamageMax = 30;
			_baseGoldCost = TowerData.baseGoldCostsArray[3];
			_baseWheatCost = TowerData.baseWhealCostsArray[3];
			_baseHealth = 100;
			type = NAME;
			_damageType = DamageTypes.PIKE;
			
			//множители к базовым характеристикам
			_koefLevelToAttackSpeed = 0.0;
			_koefLevelToDmgMax = 0.035;
			_koefLevelToDmgMin = 0.09;
			_koefLevelToRange = 0.0;
			_koefLevelToHealth = 0.1;
			
			criticalChance = 5;
			criticalPower = 2.6;
			accuracy = 65;
			updateReferences();
			
			towerMovie = new regular_spearman_movie_fullcopy();
			towerMovie.stop();
			towerMovie.scaleX = 0.85;
			towerMovie.scaleY = 0.85;
			towerMovie.stop();
			(towerMovie.getChildAt(0) as MovieClip).stop();
			
			_descriptionText = "He strikes blows with a spear and a shield by turns. Years of training make a killing machine out of a soldier. One of the best patrol men in the camp";
			_attackTimer.delay = _attackSpeed;
			
			_skillsArray = [];
			_skillsArray.push(new RealTowerSkill(0, App.skills.lightPike));
			_skillsArray.push(new RealTowerSkill(0, App.skills.accuracy));
			_skillsArray.push(new RealTowerSkill(0, App.skills.longWeapons));
			_skillsArray.push(new RealTowerSkill(0, App.skills.breakingStrike));
			_skillsArray.push(new RealTowerSkill(0, App.skills.shildStrike));
			_skillsArray.push(new RealTowerSkill(0, App.skills.heavyShield));
			_skillsArray.push(new RealTowerSkill(0, App.skills.perfectEye));
			_skillsArray.push(new RealTowerSkill(0, App.skills.piercingShot));
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