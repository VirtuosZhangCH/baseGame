package com.virtuos.OBJ3D
{
	import com.virtuos.SpriteContainer3D;
	
	import starling.display.Image;
	
	public class ResetUI extends SpriteContainer3D
	{
		[Embed(source="Assets/reset.png")]
		public var ResetGame:Class;
		private var _resetImage:Image;
		public function ResetUI()
		{
			super();
			
			_resetImage=Image.fromBitmap(new ResetGame)
			_resetImage.x = 497;
			_resetImage.y = 359;
			addChild(_resetImage);
			_resetImage.dispose();
		}
	}
}