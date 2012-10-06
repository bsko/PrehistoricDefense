package Towers.Heroes 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	/**
	 * ...
	 * @author i am
	 */
	public class GladiatorTwr extends Tower
	{
		public static const NAME:String = "GladiatorTwr";
		
		public function GladiatorTwr() 
		{
			//базовые характеристики
			_isHero = true;
			_baseAttackRange  = 100;
			_baseAttackSpeed = 1100;
			_baseDamageMin = 12;
			_baseDamageMax = 15;
			_baseGoldCost = 10;
			_baseWheatCost = 10;
			_baseHealth = 100;
			type = NAME;
			_damageType = DamageTypes.SWORD;
			
			//множители к базовым характеристикам
			_koefLevelToAttackSpeed = 0;
			_koefLevelToDmgMax = 0.12;
			_koefLevelToDmgMin = 0.12;
			_koefLevelToRange = 0;
			_koefLevelToHealth = 0.12;
			
			criticalChance = 4;
			criticalPower = 2.5;
			accuracy = 70;
			updateReferences();
			
			towerMovie = new gladiator_movie_full();
			towerMovie.stop();
			towerMovie.scaleX = 0.85;
			towerMovie.scaleY = 0.85;
			towerMovie.stop();
			(towerMovie.getChildAt(0) as MovieClip).stop();
			
			_descriptionText = "His name is Garpacius. He has a bad Balkan character, but he is the best in his work. He can cut dozens or even more offenders during a second causing severe injuries to each of tem";
			_attackTimer.delay = _attackSpeed;
			
			_skillsArray = [];
			_skillsArray.push(new RealTowerSkill(0, App.skills.bladeMastery));
			_skillsArray.push(new RealTowerSkill(0, App.skills.piercingStrike));
			_skillsArray.push(new RealTowerSkill(0, App.skills.deepWounds));
			_skillsArray.push(new RealTowerSkill(0, App.skills.strongMagicPower));
			_skillsArray.push(new RealTowerSkill(0, App.skills.mortalBlow));
			_skillsArray.push(new RealTowerSkill(0, App.skills.exactStrike));
			_skillsArray.push(new RealTowerSkill(0, App.skills.ancientsPower));
			_skillsArray.push(new RealTowerSkill(0, App.skills.demoralization));
			calculateSkills();
			addChild(towerMovie);
		}
		
		override protected function onShoot(e:Event):void 
		{
			super.onShoot(e);
			if (_curEnemyToAttack != null)
			{
				_curEnemyToAttack.enemyTakingDamage(this);
				App.soundControl.playSound("hit_sword");
			}
		}
		
		override public function destroy():void 
		{
			super.destroy();
			App.pools.returnPoolObject(NAME, this);
		}
	}

}