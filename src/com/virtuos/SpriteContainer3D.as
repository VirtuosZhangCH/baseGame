package com.virtuos
{
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class SpriteContainer3D extends Sprite
	{
		
		public function SpriteContainer3D()
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		protected function init(e:Event):void{
			
		}
	}
}