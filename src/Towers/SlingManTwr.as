package Towers 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	/**
	 * ...
	 * @author i am
	 */
	public class SlingManTwr extends Tower
	{
		public static const NAME:String = "SlingManTwr";
		private var bulletType:int = Bullet.SMALL_STONE;
		
		public function SlingManTwr() 
		{
			//базовые характеристики
			_baseAttackRange  = 200;
			_baseAttackSpeed = 2500;
			_baseDamageMin = 14;
			_baseDamageMax = 22;
			_baseGoldCost = TowerData.baseGoldCostsArray[6];
			_baseWheatCost = TowerData.baseWhealCostsArray[6];
			_baseHealth = 100;
			type = NAME;
			_damageType = DamageTypes.BLUNT;
			isAirKiller = true;
			
			//множители к базовым характеристикам
			_koefLevelToAttackSpeed = 0.0;
			_koefLevelToDmgMax = 0.04;
			_koefLevelToDmgMin = 0.04;
			_koefLevelToRange = 0.0;
			_koefLevelToHealth = 0.1;
			
			criticalChance = 12;
			criticalPower = 3.6;
			accuracy = 65;
			updateReferences();
			
			towerMovie = new sling_movie_full();
			towerMovie.stop();
			towerMovie.scaleX = 0.85;
			towerMovie.scaleY = 0.85;
			towerMovie.stop();
			(towerMovie.getChildAt(0) as MovieClip).stop();
			
			_descriptionText = "Forest hunters merge with nature becoming an integration. They are able to strike even a squirrel between eyes with small stones";
			_attackTimer.delay = _attackSpeed;
			
			_skillsArray = [];
			_skillsArray.push(new RealTowerSkill(0, App.skills.training));
			_skillsArray.push(new RealTowerSkill(0, App.skills.piercingShot));
			_skillsArray.push(new RealTowerSkill(0, App.skills.accuracy)); 
			_skillsArray.push(new RealTowerSkill(0, App.skills.heavyweapons));
			_skillsArray.push(new RealTowerSkill(0, App.skills.bodybuilding)); 
			_skillsArray.push(new RealTowerSkill(0, App.skills.perfectEye));
			_skillsArray.push(new RealTowerSkill(0, App.skills.mortalBlow));
			_skillsArray.push(new RealTowerSkill(0, App.skills.armorBreaker));
			calculateSkills();
			addChild(towerMovie);
		}
		
		override protected function shootTo():void 
		{
			super.shootTo();
			App.soundControl.playSound("sling_stroke");
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