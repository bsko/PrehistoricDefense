package Towers 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	/**
	 * ...
	 * @author i am
	 */
	public class WoodcutterTwr extends Tower
	{
		public static const NAME:String = "WoodcutterTwr";
		
		public function WoodcutterTwr() 
		{
			//базовые характеристики
			_baseAttackRange  = 100;
			_baseAttackSpeed = 1300;
			_baseDamageMin = 20;
			_baseDamageMax = 45;
			_baseGoldCost = TowerData.baseGoldCostsArray[12];
			_baseWheatCost = TowerData.baseWhealCostsArray[12];
			_baseHealth = 100;
			type = NAME;
			_damageType = DamageTypes.SWORD;
			
			//множители к базовым характеристикам
			_koefLevelToAttackSpeed = 0.0;
			_koefLevelToDmgMax = 0.025;
			_koefLevelToDmgMin = 0.07;
			_koefLevelToRange = 0.0;
			_koefLevelToHealth = 0.1;
			
			criticalChance = 3;
			criticalPower = 4.2;
			accuracy = 60;
			updateReferences();
			
			towerMovie = new woodcutter_movie_full();
			towerMovie.stop();
			towerMovie.scaleX = 0.85;
			towerMovie.scaleY = 0.85;
			towerMovie.stop();
			(towerMovie.getChildAt(0) as MovieClip).stop();
			
			_descriptionText = "Axes are not only the best means against trees. Woodcutters have proved to be the best soldiers in the camp guarding striking crushing blows to all living creatures";
			_attackTimer.delay = _attackSpeed;
			
			_skillsArray = [];
			_skillsArray.push(new RealTowerSkill(0, App.skills.sharps));
			_skillsArray.push(new RealTowerSkill(0, App.skills.accuracy));
			_skillsArray.push(new RealTowerSkill(0, App.skills.longWeapons));
			_skillsArray.push(new RealTowerSkill(0, App.skills.breakingStrike));
			_skillsArray.push(new RealTowerSkill(0, App.skills.lightAxe));
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
				App.soundControl.playSound("hit_axe");
			}
		}
		
		override public function destroy():void 
		{
			super.destroy();
			App.pools.returnPoolObject(NAME, this);
		}
		
	}

}