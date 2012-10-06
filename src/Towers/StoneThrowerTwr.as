package Towers 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	/**
	 * ...
	 * @author i am
	 */
	public class StoneThrowerTwr extends Tower
	{
		public static const NAME:String = "StoneThrowerTwr";
		private var bulletType:int = Bullet.BIG_STONE;
		
		public function StoneThrowerTwr() 
		{
			//базовые характеристики
			_baseAttackRange  = 200;
			_baseAttackSpeed = 2500;
			_baseDamageMin = 12;
			_baseDamageMax = 22;
			_baseGoldCost = TowerData.baseGoldCostsArray[5];
			_baseWheatCost = TowerData.baseWhealCostsArray[5];
			_baseHealth = 100;
			type = NAME;
			_damageType = DamageTypes.BLUNT;
			isAirKiller = true;
			
			//множители к базовым характеристикам
			_koefLevelToAttackSpeed = 0.0;
			_koefLevelToDmgMax = 0.05;
			_koefLevelToDmgMin = 0.04;
			_koefLevelToRange = 0.0;
			_koefLevelToHealth = 0.1;
			
			criticalChance = 2;
			criticalPower = 4;
			accuracy = 50;
			updateReferences();
			
			towerMovie = new Stonethrower_movie_full();
			towerMovie.stop();
			towerMovie.scaleX = 0.85;
			towerMovie.scaleY = 0.85;
			towerMovie.stop();
			(towerMovie.getChildAt(0) as MovieClip).stop();
			
			_descriptionText = "There is no place for old people here. The soldier must have really bestial strength. Heavy stones can cause a very serious splintering damage, but next spurt demands much time to get ready";
			_attackTimer.delay = _attackSpeed;
			
			_skillsArray = [];
			_skillsArray.push(new RealTowerSkill(0, App.skills.training));
			_skillsArray.push(new RealTowerSkill(0, App.skills.armorBreaker));
			_skillsArray.push(new RealTowerSkill(0, App.skills.longThrow)); 
			_skillsArray.push(new RealTowerSkill(0, App.skills.heavyStone));
			_skillsArray.push(new RealTowerSkill(0, App.skills.bonebraker)); 
			_skillsArray.push(new RealTowerSkill(0, App.skills.slowPercentage));
			_skillsArray.push(new RealTowerSkill(0, App.skills.mortalBlow));
			_skillsArray.push(new RealTowerSkill(0, App.skills.perfectEye));
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