package com.virtuos.display
{	
	import starling.display.DisplayObject;
	import starling.events.TouchEvent;

	public class SimpleButton extends MovieClip
	{
		public function SimpleButton(displayObject:DisplayObject)
		{
			super();
			addChild(displayObject);
			addEventListener(TouchEvent.TOUCH, onTouchEvent);
		}
		
		private function onTouchEvent(e:TouchEvent):void
		{
			dispatchEvent(e);
		}
		
		public function set mouseEnabled(value:Boolean):void
		{
			if (value == false)
				removeEventListener(TouchEvent.TOUCH, onTouchEvent);
			else
				addEventListener(TouchEvent.TOUCH, onTouchEvent);
		}
		
	}
}