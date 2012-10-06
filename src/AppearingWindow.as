package  
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	/**
	 * ...
	 * @author i am
	 */
	public class AppearingWindow extends Sprite
	{
		private const STRING_MAX_LENGTH:int = 70;
		private const TEXT_FIELD_LENGTH:int = 200;
		private var _tile:MovieClip = new DescrWindow();
		private var _text:TextField = _tile.descrText;
		
		public function AppearingWindow()
		{
			_tile.stop();
			addChild(_tile);
			_text.autoSize = TextFieldAutoSize.LEFT;
			_text.multiline = true;
			_text.textColor = 0xFFFFFF;
			visible = false;
			_text.mouseEnabled = false;
			_tile.mouseEnabled = false;
			this.mouseEnabled = false;
			_tile.bgr.mouseEnabled = false;
			
			for (var i:int = 0; i < _tile.bgr.numChildren; i++)
			{
				if (_tile.bgr.getChildAt(i) is MovieClip)
				{
					_tile.bgr.getChildAt(i).mouseEnabled = false;
				}
			}
		}
		
		public function Init():void 
		{
			
		}
		
		public function NewText(text:String, displayObj:DisplayObject):void 
		{
			this.x = displayObj.x + 40;
			this.y = displayObj.y + displayObj.height / 2 + 10;
			this.visible = true;
			var string:String = "";
			var counter:int = 0;
			_text.htmlText = text;
			_text.width = text.length * 2 + 50;
			if (_text.width > 400) { _text.width = 400; }
			searchForScale();
			
			if (this.x + this.width > App.W_DIV)
			{
				this.x -= this.x + this.width - App.W_DIV;
			}
			if (this.y + this.height > App.H_DIV)
			{
				this.y -= this.y + this.height - App.H_DIV;
			}
		}
		
		public function NewText1(text:String, point:Point, Xdelay:int = 0, Ydelay:int = 0 ):void 
		{
			this.x = (Xdelay == 0) ? (point.x + 40) : (point.x + Xdelay);
			this.y = (Ydelay == 0) ? (point.y + 40) : (point.y + Ydelay);
			
			var string:String = "";
			var counter:int = 0;
			_text.htmlText = text;
			_text.width = text.length * 3 + 50;
			if (_text.width > 400) { _text.width = 400; }
			searchForScale();
			
			if (this.x + this.width > App.W_DIV)
			{
				this.x -= this.x + this.width - App.W_DIV + 50;
			}
			if (this.y + this.height > App.H_DIV)
			{
				this.y -= this.y + this.height + 50 - App.H_DIV;
			}
			this.visible = true;
		}
		
		private function searchForScale():void 
		{
			var center:MovieClip = _tile.bgr.center;
			
			var lt_corner:MovieClip = _tile.bgr.lt_corner;
			var rt_corner:MovieClip = _tile.bgr.rt_corner;
			var lb_corner:MovieClip = _tile.bgr.lb_corner;
			var rb_corner:MovieClip = _tile.bgr.rb_corner;
			
			var t_slide:MovieClip = _tile.bgr.t_slide;
			var l_slide:MovieClip = _tile.bgr.l_slide;
			var r_slide:MovieClip = _tile.bgr.r_slide;
			var b_slide:MovieClip = _tile.bgr.b_slide;
			
			var widthTF:int = _text.width;
			var heightTF:int = _text.height;
			
			t_slide.width = widthTF;
			rt_corner.x = lt_corner.width + t_slide.width;
			
			l_slide.height = heightTF;
			center.width = widthTF;
			center.height = heightTF;
			r_slide.x = lt_corner.width + t_slide.width;
			r_slide.height = heightTF;
			
			lb_corner.y = l_slide.height + lt_corner.height;
			b_slide.y = l_slide.height + lt_corner.height;
			b_slide.width = widthTF;
			rb_corner.x = lt_corner.width + t_slide.width;
			rb_corner.y = l_slide.height + lt_corner.height;
		}
		
		public function Hide():void 
		{
			this.visible = false;
		}
		
		public function Destroy():void 
		{
			removeChild(_tile);
			parent.removeChild(this);
		}
		
		public function NewText2(text:String, point:Point, length:int, Xdelay:int = 0, Ydelay:int = 0 ):void 
		{
			this.x = (Xdelay == 0) ? (point.x + 40) : (point.x + Xdelay);
			this.y = (Ydelay == 0) ? (point.y + 40) : (point.y + Ydelay);
			
			var string:String = "";
			var counter:int = 0;
			_text.htmlText = text;
			if (length > 400) { length = 400; }
			_text.width = length;
			searchForScale();
			
			if (this.x + this.width > App.W_DIV)
			{
				this.x -= this.x + this.width - App.W_DIV + 50;
			}
			if (this.y + this.height > App.H_DIV)
			{
				this.y -= this.y + this.height + 50 - App.H_DIV;
			}
			this.visible = true;
		}
	}

}