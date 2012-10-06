package Towers 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	/**
	 * ...
	 * @author i am
	 */
	public class JavelinThrowerTwr extends Tower
	{
		public static const NAME:String = "JavelinThrowerTwr";
		private var bulletType:int = Bullet.SPEAR;
		
		public function JavelinThrowerTwr() 
		{
			//базовые характеристики
			_baseAttackRange  = 200;
			_baseAttackSpeed = 2500;
			_baseDamageMin = 26;
			_baseDamageMax = 58;
			_baseGoldCost = TowerData.baseGoldCostsArray[2];
			_baseWheatCost = TowerData.baseWhealCostsArray[2];
			_baseHealth = 100;
			type = NAME;
			_damageType = DamageTypes.PIKE;
			isAirKiller = true;
			
			//множители к базовым характеристикам
			_koefLevelToAttackSpeed = 0.0;
			_koefLevelToDmgMax = 0.025;
			_koefLevelToDmgMin = 0.05;
			_koefLevelToRange = 0.0;
			_koefLevelToHealth = 0.1;
			
			criticalChance = 9;
			criticalPower = 2.9;
			accuracy = 65;
			updateReferences();
			
			towerMovie = new JavelinThr_movie_full();
			towerMovie.stop();
			towerMovie.scaleX = 0.85;
			towerMovie.scaleY = 0.85;
			towerMovie.stop();
			(towerMovie.getChildAt(0) as MovieClip).stop();
			
			_descriptionText = "A spear thrower; he brings death to all living creatures. Spears with silicon points can pierce the thickest skin, causing crushing damages and mutilating injuries"
			_attackTimer.delay = _attackSpeed;
			
			_skillsArray = [];
			_skillsArray.push(new RealTowerSkill(0, App.skills.lightPike));
			_skillsArray.push(new RealTowerSkill(0, App.skills.accuracy));
			_skillsArray.push(new RealTowerSkill(0, App.skills.longThrow));
			_skillsArray.push(new RealTowerSkill(0, App.skills.perfectAccuracy));
			_skillsArray.push(new RealTowerSkill(0, App.skills.piercingShot));
			_skillsArray.push(new RealTowerSkill(0, App.skills.perfectEye));
			_skillsArray.push(new RealTowerSkill(0, App.skills.bodybuilding));
			_skillsArray.push(new RealTowerSkill(0, App.skills.criticalStrike));
			calculateSkills();
			addChild(towerMovie);
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
			super.destroy();
			App.pools.returnPoolObject(NAME, this);
		}
	}

}