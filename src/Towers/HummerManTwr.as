package Towers 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	/**
	 * ...
	 * @author i am
	 */
	public class HummerManTwr extends Tower
	{
		public static const NAME:String = "HummerManTwr";
		
		public function HummerManTwr() 
		{
			//базовые характеристики
			_baseAttackRange  = 100;
			_baseAttackSpeed = 2000;
			_baseDamageMin = 16;
			_baseDamageMax = 36;
			_baseGoldCost = TowerData.baseGoldCostsArray[10];
			_baseWheatCost = TowerData.baseWhealCostsArray[10];
			_baseHealth = 100;
			type = NAME;
			_damageType = DamageTypes.BLUNT;
			
			//множители к базовым характеристикам
			_koefLevelToAttackSpeed = 0.0;
			_koefLevelToDmgMax = 0.025;
			_koefLevelToDmgMin = 0.05;
			_koefLevelToRange = 0.0;
			_koefLevelToHealth = 0.1;
			
			criticalChance = 3;
			criticalPower = 2;
			accuracy = 50;
			updateReferences();
			
			towerMovie = new hummer_movie_full();
			towerMovie.stop();
			towerMovie.scaleX = 0.85;
			towerMovie.scaleY = 0.85;
			towerMovie.stop();
			(towerMovie.getChildAt(0) as MovieClip).stop();
			
			_descriptionText = "Two-handled hammers changed bludgeons. High damage is typical for rare strikes";
			_attackTimer.delay = _attackSpeed;
			
			_skillsArray = [];
			_skillsArray.push(new RealTowerSkill(0, App.skills.training));
			_skillsArray.push(new RealTowerSkill(0, App.skills.bigClub));
			_skillsArray.push(new RealTowerSkill(0, App.skills.accuracy)); 
			_skillsArray.push(new RealTowerSkill(0, App.skills.heavyweapons));
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
				App.soundControl.playSound("hit_molot");
			}
		}
		
		override public function destroy():void 
		{
			super.destroy();
			App.pools.returnPoolObject(NAME, this);
		}
		
	}

}