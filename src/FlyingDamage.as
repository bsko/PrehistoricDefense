package  
{
	import Events.PauseEvent;
	import Events.UniverseDestroying;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	/**
	 * ...
	 * @author 
	 */
	public class FlyingDamage extends Sprite
	{
		public static const NAME:String = "FlyingDamage";
		public static const ANIMATION_LENGTH:int = 20;
		public static const FIRST_PHASE_LENGTH:int = 10;
		public static var layer:Sprite;
		private var _damageMovie:MovieClip = new flying_damage_full();
		//private var _dmg_movie1:MovieClip = _damageMovie.damage;
		//private var _dmg_movie:MovieClip = _damageMovie.dmg_movie;
		//private var _txt_field:TextField = _dmg_movie.dmg_text;
		//private var _damageMovie:TextField = new TextField();
		//private var _textFormat:TextFormat = new TextFormat();
		//private var _direction:int = (Math.random() - 0.5 > 0)? 1 : -1;
		private var _startingPosition:Point;
		private var _frames_counter:int = 0;
		//private var _currentScale:Number = 0;
		private var _layer:Sprite;
		
		public function FlyingDamage() 
		{
			addChild(_damageMovie);
			_damageMovie.stop();
			(_damageMovie.getChildAt(0) as MovieClip).stop();
			((_damageMovie.getChildAt(0) as MovieClip).getChildAt(0) as MovieClip).stop();
			
			//_textFormat.align = "center";
			//_textFormat.font = "AcademyC";
			//_textFormat.color = 0xD0330D;
			//_textFormat.color = 0xF99D17;
			//_textFormat.size = 14;
			//_textFormat.bold = true;
			//_damageMovie.autoSize = TextFieldAutoSize.CENTER;
			//_damageMovie.defaultTextFormat = _textFormat;
		}
		
		public function Init(startPoint:Point, number:int, additionalDamage:int = 0, kritPower:Number = 0, isSeno:Boolean = false, isAddedHealth:Boolean = false):void
		{
			layer.addChild(this);
			_startingPosition = startPoint;
			x = _startingPosition.x;
			y = _startingPosition.y;
			_frames_counter = 0;
			
			//scaleX = scaleY = _currentScale = 0;
			/*var tmpString:String; 
			if (additionalDamage == 0 && kritPower == 0)
			{
				tmpString = "-" + number.toString();
			}
			else if (additionalDamage != 0 && kritPower == 0)
			{
				tmpString = "-" + number.toString() + "+" + "<font color='#FF1122'>" + String(additionalDamage) + "</font>";//additionalDamage.toString() + "</font>";
				
			}
			else if (additionalDamage == 0 && kritPower != 0)
			{
				tmpString = "-" + number.toString() + "*" + "<font color='#2D710F'>" + kritPower.toString() + "</font>";	
			}
			else if (additionalDamage != 0 && kritPower != 0)
			{
				tmpString = "-" + number.toString() + "*" + "<font color='#2D710F'>" + kritPower.toString() + "</font>" + "+" + "<font color='#2D710F'>" + additionalDamage.toString() + "</font>";
			}*/
			
			/*_damageMovie.stop();
			(_damageMovie.getChildAt(0) as MovieClip).stop();
			((_damageMovie.getChildAt(0) as MovieClip).getChildAt(0) as MovieClip).stop();*/
			
			if (isSeno)
			{
				var tmpString:String = "+" + String(number);
				_damageMovie.gotoAndStop("seno");
				(_damageMovie.getChildAt(0) as MovieClip).gotoAndPlay(1);
				//(_damageMovie.getChildAt(0) as MovieClip).dmg_movie.gotoAndPlay(1);
				(_damageMovie.getChildAt(0) as MovieClip).dmg_movie1.dmg_text1.text = tmpString;
				//tmpString = "<font color='#D0C126'>" + "+" + String(number) + "</font>";
			}
			else if (isAddedHealth)
			{
				tmpString = "+" + String(number);
				_damageMovie.gotoAndStop("regenerate");
				(_damageMovie.getChildAt(0) as MovieClip).gotoAndPlay(1);
				//(_damageMovie.getChildAt(0) as MovieClip).dmg_movie.gotoAndPlay(1);
				(_damageMovie.getChildAt(0) as MovieClip).dmg_movie2.dmg_text2.text = tmpString;
				//tmpString = "<font color='#D0C126'>" + "+" + String(number) + "</font>";
			}
			else
			{
				_damageMovie.gotoAndStop("damage");
				(_damageMovie.getChildAt(0) as MovieClip).gotoAndPlay(1);
				//(_damageMovie.getChildAt(0) as MovieClip).dmg_movie.gotoAndPlay(1);
				(_damageMovie.getChildAt(0) as MovieClip).dmg_movie.dmg_text.text = "-" + String(number);
			}
			//_damageMovie.htmlText = tmpString;
			_damageMovie.x = - _damageMovie.width / 2;
			addEventListener(Event.ENTER_FRAME, onUpdateDamagePosition, false, 0, true);
			App.universe.addEventListener(UniverseDestroying.DESTROYING, onDestroy, false, 0, true);
			App.ingameInterface.addEventListener(PauseEvent.PAUSE, onPauseEvent, false, 0, true);
			App.ingameInterface.addEventListener(PauseEvent.UNPAUSE, onResumeEvent, false, 0, true);
		}
		
		private function onUpdateDamagePosition(e:Event):void 
		{
			/*x += (_direction > 0) ? 1 : -1;
			y -= 3;*/
			_frames_counter++;
			/*if (_frames_counter <= FIRST_PHASE_LENGTH)
			{
				_currentScale += 1 / FIRST_PHASE_LENGTH;
				scaleX = scaleY = _currentScale;
			}
			else if (_frames_counter < ANIMATION_LENGTH)
			{
				//_currentScale += 0.1;
				alpha -= 1 / (ANIMATION_LENGTH - FIRST_PHASE_LENGTH);
			}
			else
			{
				_frames_counter = 0;
				Destroy();
			}*/
			if (_frames_counter == ANIMATION_LENGTH)
			{
				_frames_counter = 0;
				Destroy();
			}
		}
		
		private function onResumeEvent(e:PauseEvent):void 
		{
			addEventListener(Event.ENTER_FRAME, onUpdateDamagePosition, false, 0, true);
		}
		
		private function onPauseEvent(e:PauseEvent):void 
		{
			removeEventListener(Event.ENTER_FRAME, onUpdateDamagePosition, false);
		}
		
		private function onDestroy(e:UniverseDestroying):void 
		{
			Destroy();
		}
		
		public function Destroy():void
		{
			_frames_counter = 0;
			layer.removeChild(this);
			App.pools.returnPoolObject(NAME, this);
			removeEventListener(Event.ENTER_FRAME, onUpdateDamagePosition, false);
			App.universe.removeEventListener(UniverseDestroying.DESTROYING, onDestroy, false);
			App.ingameInterface.removeEventListener(PauseEvent.PAUSE, onPauseEvent, false);
			App.ingameInterface.removeEventListener(PauseEvent.UNPAUSE, onResumeEvent, false);
		}
		
	}

}