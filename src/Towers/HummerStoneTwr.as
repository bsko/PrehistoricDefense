package Towers 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	/**
	 * ...
	 * @author author
	 */
	public class HummerStoneTwr extends Tower
	{
		static public const NAME:String = "HummerStoneTwr";
		
		public function HummerStoneTwr() 
		{
			//базовые характеристики
			_baseAttackRange  = 100;
			_baseAttackSpeed = 1800;
			_baseDamageMin = 24;
			_baseDamageMax = 40;
			_baseGoldCost = TowerData.baseGoldCostsArray[11];
			_baseWheatCost = TowerData.baseWhealCostsArray[11];
			_baseHealth = 100;
			type = NAME;
			_damageType = DamageTypes.BLUNT;
			
			//множители к базовым характеристикам
			_koefLevelToAttackSpeed = 0.0;
			_koefLevelToDmgMax = 0.035;
			_koefLevelToDmgMin = 0.035;
			_koefLevelToRange = 0.0;
			_koefLevelToHealth = 0.1;
			
			criticalChance = 3;
			criticalPower = 2.2;
			accuracy = 60;
			updateReferences();
			
			
			towerMovie = new HummerStone_movie_full();
			towerMovie.stop();
			towerMovie.scaleX = 0.85;
			towerMovie.scaleY = 0.85;
			towerMovie.stop();
			(towerMovie.getChildAt(0) as MovieClip).stop();
			
			_descriptionText = "More experienced and muscular soldiers can lift heavy hammers that increases damage";
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