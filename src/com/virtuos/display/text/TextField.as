
package com.virtuos.display.text
{
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.text.TextField;

	public class TextField extends DisplayObjectContainer
	{
		private var mText:starling.text.TextField;
		private var mTextBG:starling.text.TextField;
		
		public function TextField(width:int, height:int, text:String, fontName:String="Verdana",
								  fontSize:Number=12, color:uint=0x0, bold:Boolean=false)
		{
			mText=new starling.text.TextField(width, height, text, fontName,
				fontSize, color, bold);
			mTextBG=new starling.text.TextField(width, height, text, fontName,
				fontSize, 0x0, bold);
			mTextBG.x++;
			mTextBG.y++;
			if(color!=0x321803)
				addChild(mTextBG);
			addChild(mText);
		}
		
		public function get text():String
		{
			return mText.text;
		}
		
		public function set text(txt:String):void
		{
			mText.text = txt;
			mTextBG.text = txt;
		}
		
		public function get color():uint
		{
			return mText.color;
		}
		
		public function set color(txt:uint):void
		{
			mText.color = txt;
		}
	}
}