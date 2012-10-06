package Towers.Heroes 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	/**
	 * ...
	 * @author i am
	 */
	public class ShamanTwr extends Tower
	{
		public static const NAME:String = "ShamanTwr";
		private var bulletType:int = Bullet.EYE;
		
		public function ShamanTwr() 
		{
			//базовые характеристики
			_isHero = true;
			_baseAttackRange  = 240;
			_baseAttackSpeed = 1900;
			_baseDamageMin = 16;
			_baseDamageMax = 17;
			_baseGoldCost = 10;
			_baseWheatCost = 10;
			_baseHealth = 100;
			type = NAME;
			_damageType = DamageTypes.MAGIC;
			isAirKiller = true;
			
			//множители к базовым характеристикам
			_koefLevelToAttackSpeed = 0;
			_koefLevelToDmgMax = 0.06;
			_koefLevelToDmgMin = 0.06;
			_koefLevelToRange = 0;
			_koefLevelToHealth = 0.1;
			
			criticalChance = 0;
			criticalPower = 0;
			accuracy = 85;
			updateReferences();
			
			towerMovie = new mage_movie_full();
			towerMovie.scaleX = 0.85;
			towerMovie.scaleY = 0.85;
			towerMovie.stop();
			(towerMovie.getChildAt(0) as MovieClip).stop();
			
			_descriptionText = "His name is Redvalentor. A hermit-magician. He is able to bring down thousands of lightning upon the enemy. During his agonizing exile he has mastered magic in order to return at the most necessary moment";
			_attackTimer.delay = _attackSpeed;
			
			_skillsArray = [];
			_skillsArray.push(new RealTowerSkill(0, App.skills.knowledge));
			_skillsArray.push(new RealTowerSkill(0, App.skills.spiritpower));
			_skillsArray.push(new RealTowerSkill(0, App.skills.magicPower));
			_skillsArray.push(new RealTowerSkill(0, App.skills.godpower));
			_skillsArray.push(new RealTowerSkill(0, App.skills.strongMind));
			_skillsArray.push(new RealTowerSkill(0, App.skills.lightningStrike));
			_skillsArray.push(new RealTowerSkill(0, App.skills.lightningPower));
			_skillsArray.push(new RealTowerSkill(0, App.skills.lightningPosibility));
			calculateSkills();
			addChild(towerMovie);
		}
		
		override protected function shootTo():void 
		{
			super.shootTo();
			App.soundControl.playSound("mage");
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