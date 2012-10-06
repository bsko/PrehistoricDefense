package  
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author 
	 */
	public class AboutWavesWindow extends Sprite
	{
		private var _arrow:MovieClip = new popup_wave_arrow();
		private var _window:MovieClip = new wave_window();
		private var _window_length:int;
		private var _window_height:int;
		private var _arrow_length:int;
		private var _arrow_height:int;
		private var _arrow_y_delay:int = 2;
		private var _window_x_delay:int = -20;
		
		public function AboutWavesWindow() 
		{
			addChild(_window);
			addChild(_arrow);
			_window_length = _window.width;
			_window_height = _window.height;
			_arrow_length = _arrow.width;
			_arrow_height = _arrow.height - _arrow_y_delay;
			_arrow.x = 0;
			_arrow.y = 0;
			_window.x = _window_x_delay;
			_window.y = _arrow_height;
			
			x = -100;
			y = -100;
			visible = false;
		}
		
		public function Init(xx:int, yy:int, wave:Wave, y_delay:int = 15):void
		{
			searchForCoordinates(xx, yy);
			x = xx;
			y = yy + y_delay;
			visible = true;
			
			_window.nameField.text = wave.name;
			_window.countField.text = wave.numberOfType;
			_window.healthField.text = wave.enemyHP;
			_window.armorField.text = wave.enemyArmor;
			_window.swordField.text = wave.resistToSword;
			_window.pikeField.text = wave.resistToPike;
			_window.bluntField.text = wave.resistToBlunt;
			_window.magicField.text = wave.resistToMagic;
		}
		
		private function searchForCoordinates(xx:int, yy:int):void 
		{
			if ((xx + _window_x_delay + _window_length) > App.W_DIV)
			{
				var a:int = xx + _window_x_delay + _window_length - App.W_DIV;
				_window.x = _window_x_delay - a;
			}
		}
		
		public function CloseWindow():void
		{
			visible = false;
			x = -100;
			y = -100;
			_window.x = _window_x_delay;
		}
	}

}