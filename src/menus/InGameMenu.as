package menus 
{
	import adobe.utils.CustomActions;
	import Events.EndLevelEvent;
	import Events.InGameEvent;
	import Events.InterfaceEvent;
	import Events.MenuToWavesControl;
	import Events.PauseEvent;
	import Events.PlayAnimation;
	import Events.SpellCastingEvent;
	import Events.TowerBuilding;
	import Events.UniverseEvent;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.ui.Mouse;
	/**
	 * ...
	 * @author ...
	 */
	public class InGameMenu extends Sprite
	{
		private static const warriorMenuWidthDelay:int = 50;
		private static const warriorMenuHeightDelay:int = 50;
		private static const ATTACK_SPEED_KOEFF:int = 1000;
		private var downMenuMovie:MovieClip = new GameDownMenu();
		private var unitsMenu:MovieClip = new UnitsList();
		private var warriorMenu:MovieClip = new towerMenu();
		public var isMenuOnScreen:Boolean;
		private var _isWarriorMenuOnScreen:Boolean;
		private var _recruitsArray:Array;
		private var _armyArray:Array;
		private var _currentLevel:int;
		private var _frameCounter:int;
		private var _mousePositionPoint:Point = new Point();
		private var _menuPositionPoint:Point = new Point();
		private var _isChangingMenuPosition:Boolean;
		private var _cooldownMovies:Array = [];
		private var _cooldownsInUse:Array = [];
		private var _EventListenersArray:Array = [];
		private var towerForMenuUpdate:Tower;
		private var _armyIndexToDelete:int;
		private var _isDescriptionOnScreen:Boolean = false;
		private var _descriptionPoint:Point;
		private var _descriptionSkill:RealTowerSkill;
		private var _descriptionClip:MovieClip;
		
		public function InGameMenu() 
		{
			addChild(downMenuMovie);
			addChild(unitsMenu);
			addChild(App.aboutWavesWindow);
			unitsMenu.x = App.Half_W_DIV;
			unitsMenu.y = App.Half_H_DIV;
			unitsMenu.visible = false;
			unitsMenu.gotoAndStop("barracks");
			isMenuOnScreen = false;
			downMenuMovie.gotoAndStop("menu");
			downMenuMovie.pressSpace.visible = false;
		}
		
		public function Init(lvl:int):void 
		{
			addChild(App.notenoughdeneg);
			downMenuMovie.gotoAndStop("menu");
			downMenuMovie.pressSpace.visible = false;
			App.universe.addEventListener(UniverseEvent.TOWER_MENU, onTowerMenu, false, 0, true);
			App.universe.addEventListener(UniverseEvent.CLOSE_MENU, onCloseMenu, false, 0, true);
			App.universe.addEventListener(UniverseEvent.BUILDING_MENU, onBuildingMenu, false, 0, true);
			App.universe.addEventListener(UniverseEvent.ADD_KEY, onUpdateKeys, false, 0, true);
			App.universe.addEventListener(EndLevelEvent.END_LEVEL, onEndLevel, false, 0, true);
			App.universe.addEventListener(PlayAnimation.PLAY_ANIMATION, onPlayEndLevelAnimation, false, 0, false);
			App.universe.addEventListener(SpellCastingEvent.NEW_COOLDOWN, onNewCooldown, false, 0, true);
			updateButtonsBySoundStatus();
			downMenuMovie.volumeBtn1.addEventListener(MouseEvent.CLICK, onChangeSoundStatus, false, 0, true);
			downMenuMovie.musicBtn1.addEventListener(MouseEvent.CLICK, onChangeMusicStatus, false, 0, true);
			downMenuMovie.PauseBtn.addEventListener(MouseEvent.CLICK, onPauseEvent, false, 0, true);
			downMenuMovie.PauseBtn.spell_movie.mouseEnabled = false;
			downMenuMovie.UnitsBtn.addEventListener(MouseEvent.CLICK, onUnitsMenu, false, 0, true);
			downMenuMovie.addEventListener(Event.ENTER_FRAME, onUpdateDownMenu, false, 0, true);
			//_description.Init();
			
			addChildAt(App.waveLine, 1);
			
			initTowersMenu();
			_frameCounter = 0;
			_currentLevel = lvl;
			var tmpPlayer:PlayerAccount = App.currentPlayer;
			tmpPlayer.gold = PlayerAccount.MoneyForLevel[lvl];
			tmpPlayer.wheat = PlayerAccount.WheatForLevel[lvl];
			var tmpArray:Array = tmpPlayer.selectedSpells;
			var length:int = tmpArray.length;
			var tmpInterfaceSpellMovie:MovieClip;
			var tmpSpell:Spell; 
			_cooldownMovies.length = 0;
			_cooldownsInUse.length = 0;
			for (var i:int = 0; i < length; i++)
			{
				tmpSpell = tmpArray[i];
				tmpInterfaceSpellMovie = downMenuMovie.getChildByName("spell_" + String(i)) as MovieClip;
				tmpInterfaceSpellMovie.spell_movie.gotoAndStop(tmpSpell.label);
				tmpInterfaceSpellMovie.spell_movie.mouseEnabled = false;
				(downMenuMovie.getChildByName("spellCost_" + String(i)) as TextField).text = String(tmpSpell.castCost);
				tmpInterfaceSpellMovie.addEventListener(MouseEvent.CLICK, onSpellUsing, false, 0, true);
				
				initCooldownObject(i);
			}
			for (i = length; i < 3; i++)
			{
				tmpInterfaceSpellMovie = downMenuMovie.getChildByName("spell_" + String(i)) as MovieClip;
				tmpInterfaceSpellMovie.spell_movie.gotoAndStop("free");
			}
			
			addEventListener(Event.ENTER_FRAME, updateCooldowns, false, 0, true);
		}
		
		private function updateCooldowns(e:Event):void 
		{
			if (downMenuMovie.currentLabel == "menu")
			{
				var tmpObject:Object;
				for (var i:int = 0; i < _cooldownsInUse.length; i++)
				{
					tmpObject = _cooldownsInUse[i];
					if (tmpObject.inUse)
					{
						var tmpMovie:MovieClip = _cooldownMovies[i];
						
						tmpObject.timer++;
						if (tmpObject.timer >= tmpObject.cooldownTime)
						{
							tmpObject.inUse = false;
							tmpMovie.visible = false;
							tmpObject.timer = 0;
							searchForSpellInSlot(i).isCooldown = false;
							((downMenuMovie.getChildByName("spell_" + String(i)) as MovieClip).spell_movie as MovieClip).visible = true;
						}
						else
						{
							tmpMovie.cooldown.gotoAndStop(int(( tmpObject.timer / tmpObject.cooldownTime) * tmpMovie.cooldown.totalFrames));
						}
					}
				}
			}
		}
		
		private function initCooldownObject(i:int):void 
		{
			var tmpCooldownMovie:MovieClip;
			tmpCooldownMovie = downMenuMovie.getChildByName("cooldown_" + String(i)) as MovieClip;
			tmpCooldownMovie.visible = false;
			_cooldownMovies[i] = tmpCooldownMovie;
			var cooldownObject:Object = new Object();
			cooldownObject.inUse = false;
			cooldownObject.cooldownTime = 0;
			cooldownObject.timer = 0;
			_cooldownsInUse[i] = cooldownObject;
		}
		
		private function onNewCooldown(e:SpellCastingEvent = null, spell:Spell = null):void 
		{
			var currentSpell:Spell
			if (e != null)
			{
				currentSpell = e.spell_type;
			}
			else
			{
				currentSpell = spell;
			}
			
			var index:int = searchForSlotIndex(currentSpell);
			((downMenuMovie.getChildByName("spell_" + String(index)) as MovieClip).spell_movie as MovieClip).visible = false;
			var cooldownMovie:MovieClip = _cooldownMovies[index];
			cooldownMovie.cooldown.gotoAndStop(1);
			cooldownMovie.visible = true;
			trace(cooldownMovie.cooldown.currentFrame);
			var tmpObject:Object = _cooldownsInUse[index];
			tmpObject.inUse = true;
			tmpObject.cooldownTime = currentSpell.cooldownTime;
			tmpObject.timer = currentSpell.cooldownTimer;
			currentSpell.isCooldown = true;
		}
		
		private function searchForSlotIndex(currentSpell:Spell):int
		{
			var tmpArray:Array = App.currentPlayer.selectedSpells;
			var length:int = tmpArray.length;
			var tmpSpell:Spell;
			for (var i:int = 0; i < length; i++)
			{
				tmpSpell = tmpArray[i];
				if (tmpSpell.label == currentSpell.label)
				{
					return i;
				}
			}
			return 999;
		}
		
		private function searchForSpellInSlot(index:int):Spell
		{
			return App.currentPlayer.selectedSpells[index];
		}
		
		private function onPlayEndLevelAnimation(e:PlayAnimation):void 
		{
			removeEventListenersFromGameMenu();
			if (e.isWin)
			{
				downMenuMovie.gotoAndStop("Victory");
			}
			else
			{
				downMenuMovie.gotoAndStop("Defeat");
			}
		}
		
		private function onBuildingMenu(e:UniverseEvent):void 
		{
			App.universe.destroyMagicUsing();
			
			onUnitsMenu();
		}
		
		private function onEndLevel(e:EndLevelEvent):void 
		{
			destroy();
		}
		
		private function onSpellUsing(e:MouseEvent):void 
		{
			App.soundControl.playSound("click");
			App.universe.destroyMagicUsing();
			App.universe.DestroyBuildingTower();
			var index:int = (e.currentTarget as MovieClip).name.split("_")[1];
			var spellInit:String = (e.currentTarget as MovieClip).spell_movie.currentLabel;
			
			var tmpArray:Array = App.currentPlayer.spellsArray
			var length:int = tmpArray.length;
			var tmpSpell:Spell;
			var currentSpell:Spell;
			for (var i:int = 0; i < length; i++)
			{
				tmpSpell = tmpArray[i];
				if (tmpSpell.label == spellInit)
				{
					currentSpell = tmpSpell;
					break;
				}
			}
			if (App.currentPlayer.gold >= currentSpell.castCost)
			{
				if (spellInit != "Heavy_stone")
				{
					dispatchEvent(new InGameEvent(InGameEvent.SPELL_USING, true, false, spellInit, currentSpell));
				}
				else
				{
					App.currentPlayer.gold -= currentSpell.castCost;
					currentSpell.UseMagic(null);
					onNewCooldown(null, currentSpell);
				}
			} else {
				App.soundControl.playSound("no_action");
			}
		}
		
		private function onUpdateKeys(e:UniverseEvent = null):void 
		{
			App.universe.changeKeysCount(App.universe.keysCount + 1);
		}
		
		private function onUpdateDownMenu(e:Event):void 
		{
			downMenuMovie.goldField.text = String(App.currentPlayer.gold);
			downMenuMovie.wheatField.text = String(App.currentPlayer.wheat);
			downMenuMovie.scoreField.text = String(App.currentPlayer.score);
		}
		
		private function onCloseMenu(e:UniverseEvent = null):void 
		{
			if (_isWarriorMenuOnScreen)
			{
				_isChangingMenuPosition = false;
				if (warriorMenu.currentLabel == "menu")
				{
					warriorMenu.removeEventListener(Event.ENTER_FRAME, onUpdateMenu, false);
					warriorMenu.skillsBtn.removeEventListener(MouseEvent.CLICK, onTowerSkillsMenu, false);
					warriorMenu.closeBtn.removeEventListener(MouseEvent.CLICK, onCloseMenu, false);
					warriorMenu.sellBtn.removeEventListener(MouseEvent.CLICK, onReturnToBarracks, false);
					warriorMenu.removeEventListener(MouseEvent.MOUSE_DOWN, onChangeMenuPosition, false);
					warriorMenu.removeEventListener(MouseEvent.MOUSE_UP, onStopChangingMenuPosition, false);
					warriorMenu.removeEventListener(MouseEvent.MOUSE_MOVE, onUpdateMenuPosition, false);
				}
				else if (warriorMenu.currentLabel == "skills")
				{
					warriorMenu.removeEventListener(Event.ENTER_FRAME, onUpdateSkillsMenu, false);
				}
				removeChild(warriorMenu);
				App.universe.towerRangeSprite.visible = false;
				_isWarriorMenuOnScreen = false;
			}
			
		}
		
		private function onTowerMenu(e:UniverseEvent):void 
		{
			App.universe.destroyMagicUsing();
			var tmpTower:Tower = e.tower as Tower;
			if (tmpTower != null)
			{
				if (_isWarriorMenuOnScreen)
				{
					onCloseMenu();
				}
				_isWarriorMenuOnScreen = true;
				towerForMenuUpdate = tmpTower;
				
				warriorMenu.gotoAndStop("menu");
				// DAMAGE
				if (towerForMenuUpdate.addedDamage == 0)
				{
					warriorMenu.dmgField.text = String(towerForMenuUpdate.damageMin) + "-" + String(towerForMenuUpdate.damageMax);
				}
				else
				{
					var tmpString:String = " +" + String(towerForMenuUpdate.addedDamage);
					warriorMenu.dmgField.htmlText = String(towerForMenuUpdate.damageMin) + "-" + String(towerForMenuUpdate.damageMax) + "<font color='#2D710F'>" + tmpString + "</font>";
				}
				// RANGE
				if (towerForMenuUpdate.addedRange == 0)
				{
					warriorMenu.rangeField.text = String(towerForMenuUpdate.attackRange);
				}
				else
				{
					tmpString = " +" + String(towerForMenuUpdate.addedRange);
					warriorMenu.rangeField.htmlText = String(towerForMenuUpdate.attackRange) + "<font color='#2D710F'>" + tmpString + "</font>";
				}
				// CRIT CHANCE
				if (towerForMenuUpdate.addedCriticalChance == 0)
				{
					warriorMenu.critChance.text = String(towerForMenuUpdate.criticalChance);
				}
				else
				{
					tmpString = " +" + String(towerForMenuUpdate.addedCriticalChance);
					warriorMenu.critChance.htmlText = String(towerForMenuUpdate.criticalChance) + "<font color='#2D710F'>" + tmpString + "</font>";
				}
				// ACCURACY
				if (towerForMenuUpdate.addedAccuracy == 0)
				{
					warriorMenu.accuracy.text = String(towerForMenuUpdate.accuracy);
				}
				else
				{
					tmpString = " +" + String(towerForMenuUpdate.addedAccuracy);
					warriorMenu.accuracy.htmlText = String(towerForMenuUpdate.accuracy) + "<font color='#2D710F'>" + tmpString + "</font>";
				}
				// CRITICAL POWER
				if (towerForMenuUpdate.addedCriticalPower == 0)
				{
					warriorMenu.critPower.text = String(towerForMenuUpdate.criticalPower);
				}
				else
				{
					tmpString = " +" + String(towerForMenuUpdate.addedCriticalPower);
					warriorMenu.critPower.htmlText = String(towerForMenuUpdate.criticalPower) + "<font color='#2D710F'>" + tmpString + "</font>";
				}
				//ATTACK SPEED
				warriorMenu.attackSpeedField.text = String(towerForMenuUpdate.attackSpeed / ATTACK_SPEED_KOEFF);
				// others
				warriorMenu.nameField.text = String(tmpTower.title);
				warriorMenu.expField.text = MakeExpText();
				warriorMenu.expMovie.gotoAndStop(int((tmpTower.experience - tmpTower.experienceToCurrentLevel) * 100 / (tmpTower.experienceToNextLevel - tmpTower.experienceToCurrentLevel)));
				warriorMenu.levelField.text = String(tmpTower.level);
				warriorMenu.icon_movie.gotoAndStop(tmpTower.movieClipLabel);
				warriorMenu.realName.text = tmpTower.realName;
				warriorMenu.addEventListener(MouseEvent.MOUSE_DOWN, onChangeMenuPosition, false, 0, true);
				warriorMenu.addEventListener(MouseEvent.MOUSE_UP, onStopChangingMenuPosition, false, 0, true);
				warriorMenu.addEventListener(MouseEvent.MOUSE_MOVE, onUpdateMenuPosition, false, 0, true);
				searchForCoordinates(tmpTower);
				addChild(warriorMenu);
				warriorMenu.addEventListener(Event.ENTER_FRAME, onUpdateMenu, false, 0, true);
				
				// обработка кнопок в меню башни:
				if (tmpTower.skillPoints > 0)
				{ warriorMenu.skillsBtn.gotoAndStop(1); }
				else { warriorMenu.skillsBtn.gotoAndStop(2); }
				warriorMenu.skillsBtn.addEventListener(MouseEvent.CLICK, onTowerSkillsMenu, false, 0, true);
				warriorMenu.closeBtn.addEventListener(MouseEvent.CLICK, onTOCloseMenu, false, 0, true);
				warriorMenu.sellBtn.addEventListener(MouseEvent.CLICK, onReturnToBarracks, false, 0, true);
			}
		}
		
		private function onUpdateMenuPosition(e:MouseEvent):void 
		{
			if (_isChangingMenuPosition)
			{
				warriorMenu.x = _menuPositionPoint.x + (mouseX - _mousePositionPoint.x);
				warriorMenu.y = _menuPositionPoint.y + (mouseY - _mousePositionPoint.y);
			}
		}
		
		private function onChangeMenuPosition(e:MouseEvent):void 
		{
			_mousePositionPoint.x = mouseX;
			_mousePositionPoint.y = mouseY;
			_menuPositionPoint.x = warriorMenu.x;
			_menuPositionPoint.y = warriorMenu.y;
			_isChangingMenuPosition = true;
		}
		
		private function onStopChangingMenuPosition(e:MouseEvent):void 
		{
			_isChangingMenuPosition = false;
		}
		
		private function onUpdateMenu(e:Event):void 
		{
			// DAMAGE
			if (towerForMenuUpdate.addedDamage == 0)
			{
				warriorMenu.dmgField.text = String(towerForMenuUpdate.damageMin) + "-" + String(towerForMenuUpdate.damageMax);
			}
			else
			{
				var tmpString:String = " +" + String(towerForMenuUpdate.addedDamage);
				warriorMenu.dmgField.htmlText = String(towerForMenuUpdate.damageMin) + "-" + String(towerForMenuUpdate.damageMax) + "<font color='#2D710F'>" + tmpString + "</font>";
			}
			// RANGE
			if (towerForMenuUpdate.addedRange == 0)
			{
				warriorMenu.rangeField.text = String(towerForMenuUpdate.attackRange);
			}
			else
			{
				tmpString = " +" + String(towerForMenuUpdate.addedRange);
				warriorMenu.rangeField.htmlText = String(towerForMenuUpdate.attackRange) + "<font color='#2D710F'>" + tmpString + "</font>";
			}
			// CRIT CHANCE
			if (towerForMenuUpdate.addedCriticalChance == 0)
			{
				warriorMenu.critChance.text = String(towerForMenuUpdate.criticalChance);
			}
			else
			{
				tmpString = " +" + String(towerForMenuUpdate.addedCriticalChance);
				warriorMenu.critChance.htmlText = String(towerForMenuUpdate.criticalChance) + "<font color='#2D710F'>" + tmpString + "</font>";
			}
			// ACCURACY
			if (towerForMenuUpdate.addedAccuracy == 0)
			{
				warriorMenu.accuracy.text = String(towerForMenuUpdate.accuracy);
			}
			else
			{
				tmpString = " +" + String(towerForMenuUpdate.addedAccuracy);
				warriorMenu.accuracy.htmlText = String(towerForMenuUpdate.accuracy) + "<font color='#2D710F'>" + tmpString + "</font>";
			}
			// CRITICAL POWER
			if (towerForMenuUpdate.addedCriticalPower == 0)
			{
				warriorMenu.critPower.text = String(towerForMenuUpdate.criticalPower);
			}
			else
			{
				var tmpNumber:Number = towerForMenuUpdate.addedCriticalPower;
				tmpString = " +" + tmpNumber.toFixed(2);
				warriorMenu.critPower.htmlText = String(towerForMenuUpdate.criticalPower) + "<font color='#2D710F'>" + tmpString + "</font>";
			}
			
			//ATTACK SPEED && others
			warriorMenu.attackSpeedField.text = String(towerForMenuUpdate.attackSpeed / ATTACK_SPEED_KOEFF);
			
			warriorMenu.nameField.text = String(towerForMenuUpdate.title);
			warriorMenu.expField.text =  MakeExpText();
			warriorMenu.levelField.text = String(towerForMenuUpdate.level);
			warriorMenu.expMovie.gotoAndStop(int((towerForMenuUpdate.experience - towerForMenuUpdate.experienceToCurrentLevel) * 100 / (towerForMenuUpdate.experienceToNextLevel - towerForMenuUpdate.experienceToCurrentLevel)));
			
		}
		
		private function MakeExpText():String
		{
			var str1:String;
			if (towerForMenuUpdate.experience > 9999)
			{
				str1 = int(towerForMenuUpdate.experience / 1000).toString() + "k";
			}
			else
			{
				str1 = towerForMenuUpdate.experience.toString();
			}
			
			var str2:String;
			if (towerForMenuUpdate.experienceToNextLevel > 9999)
			{
				str2 = int(towerForMenuUpdate.experienceToNextLevel / 1000).toString() + "k";
			}
			else
			{
				str2 = towerForMenuUpdate.experienceToNextLevel.toString();
			}
			
			return str1 + "/" + str2;
		}
		
		private function onTOCloseMenu(e:MouseEvent):void 
		{
			App.soundControl.playSound("click");
			App.universe.towerRangeSprite.visible = false;
			onCloseMenu();
		}
		
		private function onTowerSkillsMenu(e:MouseEvent):void 
		{
			App.soundControl.playSound("click");
			warriorMenu.removeEventListener(Event.ENTER_FRAME, onUpdateMenu, false);
			var xx:int = warriorMenu.x;
			var yy:int = warriorMenu.y;
			warriorMenu.gotoAndStop("skills");
			warriorMenu.x = xx; 
			warriorMenu.y = yy;
			warriorMenu.addEventListener(Event.ENTER_FRAME, onUpdateSkillsMenu, false, 0, true);
			searchForCoordinates(towerForMenuUpdate, true);
			DrawSkillsMenu();
		}
		
		private function onUpdateSkillsMenu(e:Event):void 
		{
			warriorMenu.skillPoints.text = int(towerForMenuUpdate.skillPoints);
		}
		
		private function DrawSkillsMenu():void 
		{
			warriorMenu.closeBtn.addEventListener(MouseEvent.CLICK, onTOCloseMenu, false, 0, true);
			
			for (var i:int = 0; i < App.SKILLS_NMBR; i++)
			{
				var tmpRealTowerSkill:RealTowerSkill = towerForMenuUpdate.skillsArray[i];
				tmpRealTowerSkill.skill.iconType;
				var tmpMovie:MovieClip = warriorMenu.getChildByName("skill_" + String(i)) as MovieClip;
				if (i != 3 && i != 7)
				{
					if (tmpRealTowerSkill.currentLevel > 0)
					{
						if (towerForMenuUpdate.skillsArray[i + 1].currentLevel == 0)
						{
							towerForMenuUpdate.skillsArray[i + 1].isAvailable = true;
						}
					}
				}
				if (i == 0 || i == 4)
				{
					tmpRealTowerSkill.isAvailable = true;
					tmpMovie.gotoAndStop("true");
					tmpMovie.skill_icon.gotoAndStop(tmpRealTowerSkill.skill.iconType);
					tmpMovie.currentLevel.gotoAndStop("level_" + String(tmpRealTowerSkill.currentLevel));
					tmpMovie.skill_btn.addEventListener(MouseEvent.CLICK, onUpdateSkill, false, 0, true);
					tmpMovie.skill_btn.addEventListener(MouseEvent.MOUSE_OVER, onDescrSkill, false, 0, true);
					tmpMovie.skill_btn.addEventListener(MouseEvent.MOUSE_OUT, onCloseDescrSkill, false, 0, true);
				}
				else
				{
					if (!tmpRealTowerSkill.isAvailable)
					{
						tmpMovie.gotoAndStop("false");
						tmpMovie.currentLevel.gotoAndStop("level_0");
					}
					else
					{
						tmpMovie.gotoAndStop("true");
						tmpMovie.skill_icon.gotoAndStop(tmpRealTowerSkill.skill.iconType);
						tmpMovie.currentLevel.gotoAndStop("level_" + String(tmpRealTowerSkill.currentLevel));
						tmpMovie.skill_btn.addEventListener(MouseEvent.CLICK, onUpdateSkill, false, 0, true);
						tmpMovie.skill_btn.addEventListener(MouseEvent.MOUSE_OVER, onDescrSkill, false, 0, true);
						tmpMovie.skill_btn.addEventListener(MouseEvent.MOUSE_OUT, onCloseDescrSkill, false, 0, true);
					}
				}
			}
		}
		
		private function onCloseDescrSkill(e:MouseEvent = null):void 
		{
			if (_isDescriptionOnScreen) { _isDescriptionOnScreen = false; }
			App.appearingWindow.Hide();
		}
		
		private function onDescrSkill(e:MouseEvent = null):void 
		{
			if (e != null)
			{
				var index:int = int((e.currentTarget as SimpleButton).parent.name.split("_")[1]);
				var tmpRealSkill:RealTowerSkill = towerForMenuUpdate.skillsArray[index];
				var tmpMovieClip:MovieClip = ((e.currentTarget as SimpleButton).parent as MovieClip);
				var tmpPoint:Point = new Point(tmpMovieClip.x, tmpMovieClip.y);
				_descriptionPoint = tmpPoint;
				_descriptionSkill = tmpRealSkill;
				_descriptionClip = tmpMovieClip;
			}
			else
			{
				tmpRealSkill = _descriptionSkill;
				tmpPoint = _descriptionPoint;
				tmpMovieClip = _descriptionClip;
			}
			var tmpString:String = "<font size='18'>" + tmpRealSkill.skill.name + "</font>\n" + tmpRealSkill.skill.description;
			var valeriyPetrovich:int = (tmpRealSkill.currentLevel == 3) ? 3 : (tmpRealSkill.currentLevel + 1);
			var obj:Object = tmpRealSkill.skill.skills;
			for each (var item:* in obj)
			{
				tmpString = tmpString.replace("xx", NumberOrInt(Number(item) * valeriyPetrovich));
			}
			
			if(tmpRealSkill.currentLevel < 3)
			{
				var goldCostInt:int = tmpRealSkill.gold + tmpRealSkill.currentLevel * App.BASE_SKILL_COST_INCREASED;
				var wheatCostInt:int = tmpRealSkill.wheat + tmpRealSkill.currentLevel * App.BASE_SKILL_COST_INCREASED;
				
				var wheatCost:String = "";
				if (App.currentPlayer.wheat < wheatCostInt) {
					wheatCost = "<font color='#FF0000'>" + wheatCostInt + " wheat, " + "</font>";
				} else {
					wheatCost = "<font color='#00FF00'>" + wheatCostInt + " wheat, " + "</font>";
				}
				
				var goldCost:String = "";
				if (App.currentPlayer.gold < goldCostInt) {
					goldCost = "<font color='#FF0000'>" + goldCostInt + " gold." + "</font>";
				} else {
					goldCost = "<font color='#00FF00'>" + goldCostInt + " gold." + "</font>";
				}
				tmpString += "\nCosts : " + wheatCost + goldCost;
			}
			
			App.appearingWindow.NewText1(tmpString, tmpMovieClip.parent.localToGlobal(tmpPoint));
			_isDescriptionOnScreen = true;
		}
 
		private function NumberOrInt(value:Number):String 
		{
			var tmpVar:Number = value % 1;
			tmpVar *= 10;
			if (tmpVar == 0) { return String(value); }
			else 
			{
				var tmpVar2:Number = tmpVar % 1;
				if (tmpVar2 * 10 == 0) { return value.toFixed(1); }
				else { return value.toFixed(2); }
			}
		}
		
		private function onUpdateSkill(e:MouseEvent):void 
		{
			App.soundControl.playSound("click");
			if (towerForMenuUpdate.skillPoints > 0)
			{
				var tmpSimpleButton:SimpleButton = e.target as SimpleButton;
				var tmpSkillMovie:MovieClip = tmpSimpleButton.parent as MovieClip;
				var index:int = tmpSkillMovie.name.split("_")[1];
				var tmpRealTowerSkill:RealTowerSkill = towerForMenuUpdate.skillsArray[index];
				if (tmpRealTowerSkill.currentLevel < 3)
				{
					var goldCost:int = tmpRealTowerSkill.gold + tmpRealTowerSkill.currentLevel * App.BASE_SKILL_COST_INCREASED;
					var wheatCost:int = tmpRealTowerSkill.wheat + tmpRealTowerSkill.currentLevel * App.BASE_SKILL_COST_INCREASED;
					
					if (App.currentPlayer.gold >= goldCost && App.currentPlayer.wheat >= wheatCost)
					{
						App.currentPlayer.gold -= goldCost;
						App.currentPlayer.wheat -= wheatCost;
						towerForMenuUpdate.skillPoints--;
						tmpRealTowerSkill.currentLevel++;
						towerForMenuUpdate.calculateSkills();
						towerForMenuUpdate.calculateAddedDamage();
						DrawSkillsMenu();
						
						if (_isDescriptionOnScreen)
						{
							onCloseDescrSkill();
							onDescrSkill();
						}
					}
				}
			}
		}
		
		private function onReturnToBarracks(e:MouseEvent):void 
		{
			App.soundControl.playSound("click");
			App.soundControl.playSound("move_to_barrak");
			onCloseMenu();
			App.universe.towerRangeSprite.visible = false;
			var tmpTowerData:TowerData = App.pools.getPoolObject(TowerData.NAME);
			tmpTowerData.ImportFromTower(towerForMenuUpdate);
			if (!towerForMenuUpdate.isHero)
			{
				App.currentPlayer.armyArray.push(tmpTowerData);
			}
			else
			{
				if(towerForMenuUpdate.type == "WarriorTwr") { App.universe.warriorTwr = null; }
				App.currentPlayer.heroesArray.push(tmpTowerData);
			}
			towerForMenuUpdate.currentCell.removeTower();
		}
		
		private function searchForCoordinates(tmpTower:Tower, flag:Boolean = false):void 
		{
			var tmpPoint:Point = new Point(tmpTower.x, tmpTower.y);
			if (!flag)
			{
				warriorMenu.x = tmpTower.currentCell.localToGlobal(tmpPoint).x + warriorMenuWidthDelay;
				warriorMenu.y = tmpTower.currentCell.localToGlobal(tmpPoint).y - warriorMenuHeightDelay;
			}
			if (warriorMenu.x + warriorMenu.width > App.W_DIV)
			{
				warriorMenu.x -= (warriorMenu.x + warriorMenu.width - App.W_DIV);
			}
			if (warriorMenu.y + warriorMenu.height > App.H_DIV)
			{
				warriorMenu.y -= warriorMenu.y + warriorMenu.height - App.H_DIV;
			}
		}
		
		private function initTowersMenu():void 
		{
			_recruitsArray = [];
			//_heroesArray = [];
			var tmpUnit:Update;
			var tmpRecruit:TowerData;
			var currentIndex:int = 0;
			// инит рекрутов:
			for (var i:int = 0; i < App.ARMY_NMBR; i++)
			{
				tmpUnit = null;
				tmpRecruit = null;
				for (var j:int = currentIndex; j < App.UPDATES_NMBR; j++)
				{
					if (App.currentPlayer.updatesArray[j].isUpdated)
					{
						currentIndex = j + 1;
						tmpUnit = App.currentPlayer.updatesArray[j];
						break;
					}
				}
				if (tmpUnit != null)
				{
					tmpRecruit = App.pools.getPoolObject(TowerData.NAME);
					tmpRecruit.goldCost = tmpUnit.towerCostGold;
					tmpRecruit.whealCost = tmpUnit.towerCostWheal;
					tmpRecruit.name = tmpUnit.label;
					tmpRecruit.realTitle = tmpUnit.tower.title;
					tmpRecruit.level = tmpUnit.currentLevel;
					tmpRecruit.skillPoints = tmpRecruit.level - 1;
					_recruitsArray.push(tmpRecruit);
				}
			}
			//херои
			
			//unitsMenu.gotoAndStop("heroes");
			//unitsMenu.armyBtn.addEventListener(MouseEvent.CLICK, onArmyMenu, false, 0, true);
			//unitsMenu.heroesBtn.addEventListener(MouseEvent.CLICK, onHeroesMenu, false, 0, true);
			//unitsMenu.recruitsBtn.addEventListener(MouseEvent.CLICK, onHeroesMenu, false, 0, true);
			
			
			// TODO закончить инит армии и героев
			//unitsMenu.gotoAndStop("recruits");
		}
		
		private function onArmyMenu(e:MouseEvent = null):void 
		{
			App.soundControl.playSound("click");
			unitsMenu.armyBtn.removeEventListener(MouseEvent.CLICK, onArmyMenu, false);
			unitsMenu.heroesBtn.removeEventListener(MouseEvent.CLICK, onHeroesMenu, false);
			unitsMenu.recruitsBtn.removeEventListener(MouseEvent.CLICK, onRecruitsMenu, false);
			unitsMenu.closeBtn.removeEventListener(MouseEvent.CLICK, onCloseBuildingMenu, false);
			
			unitsMenu.gotoAndStop("army");
			var tmpArray:Array = App.currentPlayer.armyArray;
			var tmpRecruit:TowerData;
			var tmpTowerVisual:MovieClip;
			var length:int = tmpArray.length;
			var tmpUsedArmyCount:int = 0;
			for (var i:int = 0; i < length; i++)
			{
				tmpRecruit = tmpArray[i];
				/*if (tmpRecruit.justTmpData)
				{
					tmpUsedArmyCount++;
					continue;
				}*/
				tmpTowerVisual = unitsMenu.armyList.getChildByName("tower_" + String(i - tmpUsedArmyCount)) as MovieClip;
				tmpTowerVisual.icon_movie.gotoAndStop(tmpRecruit.title);
				
				if(App.currentPlayer.gold >= tmpRecruit.goldCost)
				{ tmpTowerVisual.goldField.htmlText = "<font color=\"#4E4124\">" + String(tmpRecruit.goldCost) + "</font>"; }
				else
				{ tmpTowerVisual.goldField.htmlText = "<font color=\"#FF0000\">" + String(tmpRecruit.goldCost) + "</font>"; }
				
				if(App.currentPlayer.wheat >= tmpRecruit.whealCost)
				{ tmpTowerVisual.whealField.htmlText = "<font color=\"#4E4124\">" + String(tmpRecruit.whealCost) + "</font>"; }
				else
				{ tmpTowerVisual.whealField.htmlText = "<font color=\"#FF0000\">" + String(tmpRecruit.whealCost) + "</font>"; }
				
				tmpTowerVisual.lvlField.text = String(tmpRecruit.level);
				tmpTowerVisual.exp.gotoAndStop(Math.ceil(tmpRecruit.level / App.MAX_TOWER_LVL * tmpTowerVisual.exp.totalFrames));
				tmpTowerVisual.button.addEventListener(MouseEvent.CLICK, onBuildArmy, false, 0, true);
				tmpTowerVisual.destroy.addEventListener(MouseEvent.CLICK, onRemoveArmy, false, 0, true);
				tmpTowerVisual.addEventListener(MouseEvent.MOUSE_OVER, onArmyDescription, false, 0, true);
				tmpTowerVisual.addEventListener(MouseEvent.MOUSE_OUT, onCloseDescrSkill, false, 0, true);
				tmpTowerVisual.visible = true;
			}
			for (i = length - tmpUsedArmyCount; i < App.ARMY_NMBR; i++)
			{
				tmpTowerVisual = unitsMenu.armyList.getChildByName("tower_" + String(i)) as MovieClip;
				tmpTowerVisual.visible = false;
			}
			
			unitsMenu.heroesBtn.addEventListener(MouseEvent.CLICK, onHeroesMenu, false, 0, true);
			unitsMenu.recruitsBtn.addEventListener(MouseEvent.CLICK, onRecruitsMenu, false, 0, true);
			unitsMenu.closeBtn.addEventListener(MouseEvent.CLICK, onCloseBuildingMenu, false, 0, true);
		}
		
		private function onCloseBuildingMenu(e:MouseEvent):void 
		{
			onUnitsMenu();
			App.soundControl.playSound("click");
		}
		
		private function onArmyDescription(e:MouseEvent):void 
		{
			/*var tmpMovie:MovieClip = e.currentTarget as MovieClip;
			var index:int = tmpMovie.name.split("_")[1];
			var tmpTowerData:TowerData = App.currentPlayer.armyArray[index];
			var string:String = tmpTowerData.realTitle;
			var tmpObject:DisplayObject = tmpMovie.parent as DisplayObject;
			var tmpObject2:DisplayObject = tmpObject.parent as DisplayObject;
			var tmpPoint:Point = new Point(tmpMovie.x + tmpObject.x + tmpObject2.x, tmpMovie.y + tmpObject.y + tmpObject2.y);
			App.appearingWindow.NewText1(string, tmpPoint);*/
		}
		
		private function onRemoveArmy(e:MouseEvent):void 
		{
			App.soundControl.playSound("click");
			_armyIndexToDelete = ((e.currentTarget as SimpleButton).parent.name.split("_")[1]);
			unitsMenu.gotoAndStop("deleteTower");
			unitsMenu.okBtn.addEventListener(MouseEvent.CLICK, onAcceptArmyDeleting, false, 0, true);
			unitsMenu.cancelBtn.addEventListener(MouseEvent.CLICK, onDeclineArmyDeleting, false, 0, true);
		}
		
		private function onDeclineArmyDeleting(e:MouseEvent):void 
		{
			App.soundControl.playSound("click");
			unitsMenu.okBtn.removeEventListener(MouseEvent.CLICK, onAcceptArmyDeleting, false);
			unitsMenu.cancelBtn.removeEventListener(MouseEvent.CLICK, onDeclineArmyDeleting, false);
			unitsMenu.gotoAndStop("army");
			onArmyMenu();
		}
		
		private function onAcceptArmyDeleting(e:MouseEvent):void 
		{
			App.soundControl.playSound("click");
			App.soundControl.playSound("delete_tower");
			App.currentPlayer.armyArray.splice(_armyIndexToDelete, 1);
			unitsMenu.okBtn.removeEventListener(MouseEvent.CLICK, onAcceptArmyDeleting, false);
			unitsMenu.cancelBtn.removeEventListener(MouseEvent.CLICK, onDeclineArmyDeleting, false);
			unitsMenu.gotoAndStop("army");
			onArmyMenu();
		}
		
		private function onBuildArmy(e:MouseEvent):void 
		{
			App.soundControl.playSound("click");
			var tmpButton:SimpleButton = e.target as SimpleButton;
			_armyArray = App.currentPlayer.armyArray;
			var tmpData:TowerData;
			var tmpDatasCount:int = 0;
			var index:int = tmpButton.parent.name.split("_")[1];
			for (var i:int = 0; i <= (index + tmpDatasCount); i++)
			{
				tmpData = _armyArray[i];
				/*if (tmpData.justTmpData)
				{
					tmpDatasCount++;
				}*/
			}
			index += tmpDatasCount;
			
			var tmpTowerData:TowerData = _armyArray[index];
			if ((App.currentPlayer.gold >= tmpTowerData.goldCost) && (App.currentPlayer.wheat >= tmpTowerData.whealCost))
			{
				//tmpTowerData.justTmpData = true;
				removeEventListenersFromArmyMenu();
				isMenuOnScreen = false;
				unitsMenu.visible = false;
				dispatchEvent(new TowerBuilding(TowerBuilding.BUILDING_TOWER, true, false, tmpTowerData, true));
				makePressSpaceVisible();
			}
			else
			{
				App.soundControl.playSound("no_action");
				App.notenoughdeneg.ShowMessaage(App.stage.mouseX, App.stage.mouseY);
			}
		}
		
		private function onRecruitsMenu(e:MouseEvent = null):void 
		{
			App.soundControl.playSound("click");
			unitsMenu.armyBtn.removeEventListener(MouseEvent.CLICK, onArmyMenu, false);
			unitsMenu.heroesBtn.removeEventListener(MouseEvent.CLICK, onHeroesMenu, false);
			unitsMenu.recruitsBtn.removeEventListener(MouseEvent.CLICK, onHeroesMenu, false);
			unitsMenu.closeBtn.removeEventListener(MouseEvent.CLICK, onCloseBuildingMenu, false);
			
			unitsMenu.gotoAndStop("recruits");
			
			if (App.currentPlayer.armyArray.length <= Tower.ARMY_MAX_COUNT)
			{if (unitsMenu.unitsLimit) {unitsMenu.unitsLimit.visible = false;}}
			else
			{ if (unitsMenu.unitsLimit)	{unitsMenu.unitsLimit.visible = true;}}
			
			var length:int = _recruitsArray.length;
			var tmpRecruitMovie:MovieClip;
			var tmpRecruit:TowerData;
			for (var i:int = 0; i < length; i++)
			{
				tmpRecruit = _recruitsArray[i];
				tmpRecruitMovie = unitsMenu.recruitsList.getChildByName("tower_" + String(i)) as MovieClip;
				tmpRecruitMovie.icon_movie.gotoAndStop(tmpRecruit.title);
				if(App.currentPlayer.gold >= tmpRecruit.goldCost)
				{ tmpRecruitMovie.goldField.htmlText = "<font color=\"#4E4124\">" + String(tmpRecruit.goldCost) + "</font>"; }
				else
				{ tmpRecruitMovie.goldField.htmlText = "<font color=\"#FF0000\">" + String(tmpRecruit.goldCost) + "</font>"; }
				
				if(App.currentPlayer.wheat >= tmpRecruit.whealCost)
				{ tmpRecruitMovie.whealField.htmlText = "<font color=\"#4E4124\">" + String(tmpRecruit.whealCost) + "</font>"; }
				else
				{ tmpRecruitMovie.whealField.htmlText = "<font color=\"#FF0000\">" + String(tmpRecruit.whealCost) + "</font>"; }
				tmpRecruitMovie.lvlField.text = String(tmpRecruit.level);
				tmpRecruitMovie.exp.gotoAndStop(Math.ceil(tmpRecruit.level / App.MAX_TOWER_LVL * tmpRecruitMovie.exp.totalFrames));
				tmpRecruitMovie.button.addEventListener(MouseEvent.CLICK, onBuildRecruit, false, 0, true);
				tmpRecruitMovie.addEventListener(MouseEvent.MOUSE_OVER, onRecruitDescription, false, 0, true);
				tmpRecruitMovie.addEventListener(MouseEvent.MOUSE_OUT, onCloseDescrSkill, false, 0, true);
			}
			for (i = length; i < App.ARMY_NMBR; i++)
			{
				tmpRecruitMovie = unitsMenu.recruitsList.getChildByName("tower_" + String(i)) as MovieClip;
				tmpRecruitMovie.icon_movie.gotoAndStop("free");
				tmpRecruitMovie.goldField.text = String(0);
				tmpRecruitMovie.whealField.text = String(0);
				tmpRecruitMovie.lvlField.text = String(0);
				tmpRecruitMovie.visible = false;
			}
			
			unitsMenu.armyBtn.addEventListener(MouseEvent.CLICK, onArmyMenu, false, 0, true);
			unitsMenu.heroesBtn.addEventListener(MouseEvent.CLICK, onHeroesMenu, false, 0, true);
			unitsMenu.closeBtn.addEventListener(MouseEvent.CLICK, onCloseBuildingMenu, false, 0, true);
		}
		
		private function onHeroesMenu(e:MouseEvent):void 
		{
			App.soundControl.playSound("click");
			unitsMenu.armyBtn.removeEventListener(MouseEvent.CLICK, onArmyMenu, false);
			unitsMenu.heroesBtn.removeEventListener(MouseEvent.CLICK, onHeroesMenu, false);
			unitsMenu.recruitsBtn.removeEventListener(MouseEvent.CLICK, onHeroesMenu, false);
			unitsMenu.closeBtn.removeEventListener(MouseEvent.CLICK, onCloseBuildingMenu, false);
			
			unitsMenu.gotoAndStop("heroes");
			
			var _heroesArray:Array = App.currentPlayer.heroesArray;
			var length:int = _heroesArray.length;
			var tmpHeroMovie:MovieClip;
			var tmpHero:TowerData;
			var tmpUsedHeroesCount:int = 0;
			for (var i:int = 0; i < length; i++)
			{
				tmpHero = _heroesArray[i];
				tmpHeroMovie = unitsMenu.heroesList.getChildByName("tower_" + String(i - tmpUsedHeroesCount)) as MovieClip;
				tmpHeroMovie.icon_movie.gotoAndStop(tmpHero.name);
				if(App.currentPlayer.gold >= tmpHero.goldCost)
				{ tmpHeroMovie.goldField.htmlText = "<font color=\"#4E4124\">" + String(tmpHero.goldCost) + "</font>"; }
				else
				{ tmpHeroMovie.goldField.htmlText = "<font color=\"#FF0000\">" + String(tmpHero.goldCost) + "</font>"; }
				
				if(App.currentPlayer.wheat >= tmpHero.whealCost)
				{ tmpHeroMovie.whealField.htmlText = "<font color=\"#4E4124\">" + String(tmpHero.whealCost) + "</font>"; }
				else
				{ tmpHeroMovie.whealField.htmlText = "<font color=\"#FF0000\">" + String(tmpHero.whealCost) + "</font>"; }
				tmpHeroMovie.lvlField.text = String(tmpHero.level);
				tmpHeroMovie.exp.gotoAndStop(Math.ceil(tmpHero.level / App.MAX_TOWER_LVL * tmpHeroMovie.exp.totalFrames));
				
				tmpHeroMovie.addEventListener(MouseEvent.MOUSE_OVER, onHeroAbout, false, 0, true);
				tmpHeroMovie.addEventListener(MouseEvent.MOUSE_OUT, onCloseDescrSkill, false, 0, true);
				
				if (tmpHero.isUnlocked)
				{
					(unitsMenu.heroesList.getChildByName("mask_" + String(i - tmpUsedHeroesCount)) as MovieClip).mouseEnabled = false;
					tmpHeroMovie.alpha = 1;
					//tmpHeroMovie.addEventListener(MouseEvent.MOUSE_OVER, onHeroAbout, false, 0, true);
					//tmpHeroMovie.addEventListener(MouseEvent.MOUSE_OUT, onCloseDescrSkill, false, 0, true);
					tmpHeroMovie.button.addEventListener(MouseEvent.CLICK, onBuildHero, false, 0, true);
				}
				else
				{
					(unitsMenu.heroesList.getChildByName("mask_" + String(i - tmpUsedHeroesCount)) as MovieClip).mouseEnabled = true;
					tmpHeroMovie.alpha = 0.5;
				}
			}
			for (i = length - tmpUsedHeroesCount; i < App.HEROES_NMBR; i++)
			{
				tmpHeroMovie = unitsMenu.heroesList.getChildByName("tower_" + String(i)) as MovieClip;
				tmpHeroMovie.visible = false;
			}
			
			unitsMenu.armyBtn.addEventListener(MouseEvent.CLICK, onArmyMenu, false, 0, true);
			unitsMenu.recruitsBtn.addEventListener(MouseEvent.CLICK, onRecruitsMenu, false, 0, true);
			unitsMenu.closeBtn.addEventListener(MouseEvent.CLICK, onCloseBuildingMenu, false, 0, true);
		}
		
		private function onHeroAbout(e:MouseEvent):void 
		{
			var index:int = (e.currentTarget as MovieClip).name.split("_")[1];
			var tmpHero:TowerData = App.currentPlayer.heroesArray[index];
			var descr:String;
			switch(tmpHero.title)
			{
				case "Warrior":
				descr = MainMenuDescriptions.HEROES_DESCR[4];
				break;
				case "Berserk":
				descr = MainMenuDescriptions.HEROES_DESCR[1];
				break;
				case "Gladiator":
				descr = MainMenuDescriptions.HEROES_DESCR[2];
				break;
				case "Shaman":
				descr = MainMenuDescriptions.HEROES_DESCR[0];
				break;
				case "Robin Hood":
				descr = MainMenuDescriptions.HEROES_DESCR[3];
				break;
			}
			App.appearingWindow.NewText2(descr, new Point(e.stageX, e.stageY), 350);// , 30, 30);
		}
		
		private function onBuildHero(e:MouseEvent):void 
		{
			App.soundControl.playSound("click");
			var tmpButton:SimpleButton = e.currentTarget as SimpleButton;
			var tmpIndex:int = tmpButton.parent.name.split("_")[1];
			var tmpTowerData:TowerData = App.currentPlayer.heroesArray[tmpIndex];
			if ((App.currentPlayer.gold >= tmpTowerData.goldCost) && (App.currentPlayer.wheat >= tmpTowerData.whealCost))
			{
				//tmpTowerData.justTmpData = true;
				//App.currentPlayer.heroesArray.splice(tmpIndex, 1);
				removeEventListenersFromUnitsMenu();
				isMenuOnScreen = false;
				unitsMenu.visible = false;
				dispatchEvent(new TowerBuilding(TowerBuilding.BUILDING_TOWER, true, false, tmpTowerData));
			}
			else
			{
				App.soundControl.playSound("no_action");
				App.notenoughdeneg.ShowMessaage(App.stage.mouseX, App.stage.mouseY);
			}
		}
		
		private function onUnitsMenu(e:MouseEvent = null):void 
		{
			App.universe.destroyMagicUsing();
			if (!isMenuOnScreen)
			{
				App.soundControl.playSound("click");
				onCloseMenu();
				App.universe.DestroyBuildingTower();
				unitsMenu.visible = true;
				isMenuOnScreen = !isMenuOnScreen;
			}
			else
			{
				unitsMenu.visible = false;
				isMenuOnScreen = !isMenuOnScreen;
				removeEventListenersFromUnitsMenu();
				return;
			}
			
			if (App.currentPlayer.armyArray.length > 0)
			{
				onArmyMenu();
			}
			else
			{
				onRecruitsMenu();
			}
			
			/*unitsMenu.gotoAndStop("recruits");
			var length:int = _recruitsArray.length;
			var tmpRecruitMovie:MovieClip;
			var tmpRecruit:TowerData;
			for (var i:int = 0; i < length; i++)
			{
				tmpRecruit = _recruitsArray[i];
				tmpRecruitMovie = unitsMenu.recruitsList.getChildByName("tower_" + String(i)) as MovieClip;
				tmpRecruitMovie.icon_movie.gotoAndStop(tmpRecruit.title);
				tmpRecruitMovie.goldField.text = String(tmpRecruit.goldCost);
				tmpRecruitMovie.whealField.text = String(tmpRecruit.whealCost);
				tmpRecruitMovie.lvlField.text = String(tmpRecruit.level);
				tmpRecruitMovie.exp.gotoAndStop(Math.ceil(tmpRecruit.level / App.MAX_TOWER_LVL * tmpRecruitMovie.exp.totalFrames));
				tmpRecruitMovie.button.addEventListener(MouseEvent.CLICK, onBuildRecruit, false, 0, true);
				tmpRecruitMovie.addEventListener(MouseEvent.MOUSE_OVER, onRecruitDescription, false, 0, true);
				tmpRecruitMovie.addEventListener(MouseEvent.MOUSE_OUT, onCloseDescrSkill, false, 0, true);
			}
			for (i = length; i < App.ARMY_NMBR; i++)
			{
				tmpRecruitMovie = unitsMenu.recruitsList.getChildByName("tower_" + String(i)) as MovieClip;
				tmpRecruitMovie.icon_movie.gotoAndStop("free");
				tmpRecruitMovie.goldField.text = String(0);
				tmpRecruitMovie.whealField.text = String(0);
				tmpRecruitMovie.lvlField.text = String(0);
				tmpRecruitMovie.visible = false;
			}
			
			unitsMenu.armyBtn.addEventListener(MouseEvent.CLICK, onArmyMenu, false, 0, true);
			unitsMenu.heroesBtn.addEventListener(MouseEvent.CLICK, onHeroesMenu, false, 0, true);*/
		}
		
		private function onRecruitDescription(e:MouseEvent):void 
		{
			var index:int = (e.currentTarget as MovieClip).name.split("_")[1];
			var tmpUpdate:TowerData = _recruitsArray[index];
			var string:String = tmpUpdate.realTitle;
			
			var tmpObject:DisplayObject = (e.currentTarget as MovieClip).parent as DisplayObject;
			var tmpObject2:DisplayObject = tmpObject.parent as DisplayObject;
			var tmpPoint:Point = new Point(tmpObject.x + (e.currentTarget as MovieClip).x + tmpObject2.x, tmpObject.y + (e.currentTarget as MovieClip).y + tmpObject2.y);
			App.appearingWindow.NewText1(string, tmpPoint);
		}
		
		private function onBuildRecruit(e:MouseEvent):void 
		{
			App.soundControl.playSound("click");
			if (App.currentPlayer.armyArray.length <= Tower.ARMY_MAX_COUNT)
			{
				var tmpButton:SimpleButton = e.currentTarget as SimpleButton;
				var tmpTowerData:TowerData = _recruitsArray[tmpButton.parent.name.split("_")[1]];
				if ((App.currentPlayer.gold >= tmpTowerData.goldCost) && (App.currentPlayer.wheat >= tmpTowerData.whealCost))
				{
					var tmpCount:int = App.currentPlayer.armyArray.length + App.universe.towersArray.length;
					if (tmpCount < App.ARMY_NMBR)
					{
						removeEventListenersFromUnitsMenu();
						isMenuOnScreen = false;
						unitsMenu.visible = false;
						dispatchEvent(new TowerBuilding(TowerBuilding.BUILDING_TOWER, true, false, tmpTowerData));
					}
				}
				else
				{
					App.soundControl.playSound("no_action");
					App.notenoughdeneg.ShowMessaage(App.stage.mouseX, App.stage.mouseY);
				}
			}
		}
		
		public function onPauseEvent(e:MouseEvent = null):void 
		{
			if (e != null) {
				App.soundControl.playSound("click");
			}
			App.universe.destroyMagicUsing();
			removeEventListenersFromGameMenu();
			dispatchEvent(new MenuToWavesControl(MenuToWavesControl.PAUSE, true, false));
			dispatchEvent(new PauseEvent(PauseEvent.PAUSE, true, false));
			
			// eventlisteners  -----
			_EventListenersArray.length = 0;
			var tmpObject:Object = new Object();
			tmpObject.object = this;
			tmpObject.type = Event.ENTER_FRAME;
			tmpObject.handler = updateCooldowns;
			_EventListenersArray.push(tmpObject);
			removeEventListener(Event.ENTER_FRAME, updateCooldowns, false);
			//---------------------
			
			if (isMenuOnScreen)
			{
				unitsMenu.visible = false;
				isMenuOnScreen = !isMenuOnScreen;
			}
			if (isWarriorMenuOnScreen)
			{
				onCloseMenu();
			}
			App.isPauseOn = true;
			
			downMenuMovie.gotoAndStop("pause");
			downMenuMovie.RestartBtn.addEventListener(MouseEvent.CLICK, onRestartEvent, false, 0, true);
			downMenuMovie.HelpBtn.addEventListener(MouseEvent.CLICK, onHelpEvent, false, 0, true);
			downMenuMovie.MoregamesBtn.addEventListener(MouseEvent.CLICK, onMoreGamesEvent, false, 0, true);
			downMenuMovie.QuitBtn.addEventListener(MouseEvent.CLICK, onQuitEvent, false, 0, true);
			downMenuMovie.ResumeBtn.addEventListener(MouseEvent.CLICK, onResumeEvent, false, 0, true);
			
			
			
		}
		
		private function onRestartEvent(e:MouseEvent):void 
		{
			App.soundControl.playSound("click");
			dispatchEvent(new PauseEvent(PauseEvent.UNPAUSE, true, false));
			App.universe.destroy();
			downMenuMovie.gotoAndStop("menu");
			downMenuMovie.pressSpace.visible = false;
			destroy();
			stage.frameRate = App.FRAMERATE;
			App.isPauseOn = false;
			dispatchEvent(new InGameEvent(InGameEvent.INGAME_EVENT, false, false, InGameEvent.RESTART));
		}
		
		private function onHelpEvent(e:MouseEvent):void 
		{
			App.soundControl.playSound("click");
			// TODO help
		}
		
		private function onMoreGamesEvent(e:MouseEvent):void 
		{
			App.soundControl.playSound("click");
			// TODO more games
		}
		
		public function makePressSpaceVisible():void
		{
			if (downMenuMovie.pressSpace)
			{
				downMenuMovie.pressSpace.visible = true;
			}
		}
		
		public function makePressSpaceInvisible():void
		{
			if (downMenuMovie.pressSpace)
			{
				downMenuMovie.pressSpace.visible = false;
			}
		}
		
		private function onQuitEvent(e:MouseEvent):void 
		{
			App.soundControl.playSound("click");
			dispatchEvent(new PauseEvent(PauseEvent.UNPAUSE, true, false));
			App.universe.destroy();
			downMenuMovie.gotoAndStop("menu");
			downMenuMovie.pressSpace.visible = false;
			destroy();
			stage.frameRate = App.FRAMERATE;
			App.isPauseOn = false;
			dispatchEvent(new InGameEvent(InGameEvent.INGAME_EVENT, false, false, InGameEvent.QUIT));
		}
		
		private function onResumeEvent(e:MouseEvent):void 
		{
			App.soundControl.playSound("click");
			downMenuMovie.gotoAndStop("menu");
			downMenuMovie.pressSpace.visible = false;
			dispatchEvent(new MenuToWavesControl(MenuToWavesControl.RESUME, true, false));
			dispatchEvent(new PauseEvent(PauseEvent.UNPAUSE, true, false));
			onUpdateKeys();
			downMenuMovie.PauseBtn.addEventListener(MouseEvent.CLICK, onPauseEvent, false, 0, true);
			downMenuMovie.PauseBtn.spell_movie.mouseEnabled = false;
			downMenuMovie.UnitsBtn.addEventListener(MouseEvent.CLICK, onUnitsMenu, false, 0, true);
			downMenuMovie.addEventListener(Event.ENTER_FRAME, onUpdateDownMenu, false, 0, true);
			var tmpArray:Array = App.currentPlayer.selectedSpells;
			var length:int = tmpArray.length;
			var tmpInterfaceSpellMovie:MovieClip;
			var tmpSpell:Spell;
			var tmpCooldownObject:Object;
			for (var i:int = 0; i < length; i++)
			{
				tmpSpell = tmpArray[i];
				tmpCooldownObject = _cooldownsInUse[i];
				tmpInterfaceSpellMovie = downMenuMovie.getChildByName("spell_" + String(i)) as MovieClip;
				tmpInterfaceSpellMovie.spell_movie.gotoAndStop(tmpSpell.label);
				tmpInterfaceSpellMovie.spell_movie.mouseEnabled = false;
				(downMenuMovie.getChildByName("spellCost_" + String(i)) as TextField).text = String(tmpSpell.castCost);
				_cooldownMovies[i] = downMenuMovie.getChildByName("cooldown_" + String(i)) as MovieClip;
				if (tmpCooldownObject.inUse)
				{
					_cooldownMovies[i].visible = true;
				}
				tmpInterfaceSpellMovie.addEventListener(MouseEvent.CLICK, onSpellUsing, false, 0, true);
			}
			for (i = length; i < 3; i++)
			{
				tmpInterfaceSpellMovie = downMenuMovie.getChildByName("spell_" + String(i)) as MovieClip;
				tmpInterfaceSpellMovie.spell_movie.gotoAndStop("free");
			}
			stage.frameRate = App.FRAMERATE;
			App.isPauseOn = false;
			
			// eventlisteners
			var tmpObject:Object;
			while (_EventListenersArray.length != 0)
			{
				tmpObject = _EventListenersArray.pop();
				tmpObject.object.addEventListener(tmpObject.type, tmpObject.handler, false, 0, true);
			}
		}
		
		private function removeEventListenersFromGameMenu():void 
		{
			downMenuMovie.PauseBtn.removeEventListener(MouseEvent.CLICK, onPauseEvent, false);
			downMenuMovie.UnitsBtn.removeEventListener(MouseEvent.CLICK, onUnitsMenu, false);
			downMenuMovie.removeEventListener(Event.ENTER_FRAME, onUpdateDownMenu, false);
		}
		
		private function removeEventListenersFromUnitsMenu(): void 
		{
			unitsMenu.gotoAndStop("recruits");
			var length:int = _recruitsArray.length;
			var tmpRecruitMovie:MovieClip;
			for (var i:int = 0; i < length; i++)
			{
				tmpRecruitMovie = unitsMenu.recruitsList.getChildByName("tower_" + String(i)) as MovieClip;
				tmpRecruitMovie.button.removeEventListener(MouseEvent.CLICK, onBuildRecruit, false);
			}
		}
		
		private function removeEventListenersFromArmyMenu():void
		{
			var tmpArray:Array = _armyArray;
			var tmpRecruit:TowerData;
			var tmpTowerVisual:MovieClip;
			var length:int = tmpArray.length;
			for (var i:int = 0; i < length; i++)
			{
				tmpTowerVisual = unitsMenu.armyList.getChildByName("tower_" + String(i)) as MovieClip;
				tmpTowerVisual.button.removeEventListener(MouseEvent.CLICK, onBuildArmy, false);
			}
		}
		
		public function destroy():void 
		{
			removeChild(App.notenoughdeneg);
			App.waveLine.destroy();
			removeCooldowns();
			App.currentPlayer.TakingTMPVarsToZeroAfterLevel();
			if (downMenuMovie.currentFrameLabel == "menu")
			{
				downMenuMovie.PauseBtn.removeEventListener(MouseEvent.CLICK, onPauseEvent, false);
				downMenuMovie.UnitsBtn.removeEventListener(MouseEvent.CLICK, onUnitsMenu, false);
				for (i = 0; i < 3; i++)
				{
					var tmpInterfaceSpellMovie:MovieClip = downMenuMovie.getChildByName("spell_" + String(i)) as MovieClip;
					tmpInterfaceSpellMovie.removeEventListener(MouseEvent.CLICK, onSpellUsing, false);
					downMenuMovie.removeEventListener(Event.ENTER_FRAME, onUpdateDownMenu, false);
					downMenuMovie.volumeBtn1.removeEventListener(MouseEvent.CLICK, onChangeSoundStatus, false);
					downMenuMovie.musicBtn1.removeEventListener(MouseEvent.CLICK, onChangeMusicStatus, false);
				}
			}
			else if (downMenuMovie.currentFrameLabel == "pause")
			{
				downMenuMovie.RestartBtn.removeEventListener(MouseEvent.CLICK, onRestartEvent, false);
				downMenuMovie.HelpBtn.removeEventListener(MouseEvent.CLICK, onHelpEvent, false);
				downMenuMovie.MoregamesBtn.removeEventListener(MouseEvent.CLICK, onMoreGamesEvent, false);
				downMenuMovie.QuitBtn.removeEventListener(MouseEvent.CLICK, onQuitEvent, false);
				downMenuMovie.ResumeBtn.removeEventListener(MouseEvent.CLICK, onResumeEvent, false);
				downMenuMovie.removeEventListener(Event.ENTER_FRAME, onUpdateDownMenu, false);
				downMenuMovie.volumeBtn1.removeEventListener(MouseEvent.CLICK, onChangeSoundStatus, false);
				downMenuMovie.musicBtn1.removeEventListener(MouseEvent.CLICK, onChangeMusicStatus, false);
			}
			App.universe.removeEventListener(EndLevelEvent.END_LEVEL, onEndLevel, false);
			App.universe.removeEventListener(UniverseEvent.TOWER_MENU, onTowerMenu, false);
			App.universe.removeEventListener(UniverseEvent.CLOSE_MENU, onCloseMenu, false);
			App.universe.removeEventListener(UniverseEvent.ADD_KEY, onUpdateKeys, false);
			App.universe.removeEventListener(UniverseEvent.BUILDING_MENU, onBuildingMenu, false);
			App.universe.removeEventListener(SpellCastingEvent.NEW_COOLDOWN, onNewCooldown, false);
			if (isWarriorMenuOnScreen)
			{
				onCloseMenu();
			}
			if (isMenuOnScreen)
			{
				removeEventListenersFromUnitsMenu();
				unitsMenu.visible = false;
			}
			var length:int = _recruitsArray.length;
			for (var i:int = 0; i < length; i++)
			{
				_recruitsArray[i].destroy();
			}
			_recruitsArray.length = 0;
		}
		
		private function removeCooldowns():void 
		{
			var tmpArray:Array = App.currentPlayer.selectedSpells;
			var length:int = tmpArray.length;
			var tmpSpell:Spell;
			for (var i:int = 0; i < length; i++)
			{
				tmpSpell = tmpArray[i];
				tmpSpell.isCooldown = false;
			}
		}
		
		private function onChangeSoundStatus(e:MouseEvent):void 
		{
			App.soundControl.ChangeSoundMode();
			App.soundControl.playSound("click");
			App.soundStatus = !App.soundStatus;
			updateButtonsBySoundStatus();
		}
		
		private function onChangeMusicStatus(e:MouseEvent):void 
		{
			App.soundControl.playSound("click");
			App.musicStatus = !App.musicStatus;
			updateButtonsBySoundStatus();
			App.sndManager.changeMusicMode();
		}
		
		private function updateButtonsBySoundStatus():void 
		{
			if (App.soundStatus)
			{
				downMenuMovie.volumeBtn1.gotoAndStop("on");
			}
			else
			{
				downMenuMovie.volumeBtn1.gotoAndStop("off");
			}
			if (App.musicStatus)
			{
				downMenuMovie.musicBtn1.gotoAndStop("on");
			}
			else
			{
				downMenuMovie.musicBtn1.gotoAndStop("off");
			}
		}
		
		public function get isWarriorMenuOnScreen():Boolean { return _isWarriorMenuOnScreen; }
	}

}