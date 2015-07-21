package com.virtuos.animation
{
	import com.virtuos.display.MovieClip;
	
	import flash.system.System;
	
	import starling.display.DisplayObject;
	import starling.display.Sprite;

	
	public class BaseElem3D extends Sprite implements IDestroy
	{
		protected var _bg:DisplayObject;	
		
		public function BaseElem3D()
		{
			super();
			init();
		}
		
		protected function get _mc():com.virtuos.display.MovieClip
		{
			if(_bg is com.virtuos.display.MovieClip)
				return _bg as com.virtuos.display.MovieClip;
			return null;
		}
		
		public function get bg():DisplayObject
		{
			return _bg;
		}
		

		protected function init():void
		{

		}
		
		public function destroy(isDel:Boolean=true):void
		{
			removeAllListener();
			removeAllChildren();
			if(isDel && parent)
				parent.removeChild(this,true);
			nullAllReference();
			System.gc();
		}
		
		public function removeAllChildren():void
		{
			var child:DisplayObject;
			while(this.numChildren>0)
			{
				child=getChildAt(0) as DisplayObject;
				if(child is IDestroy)
				{
					(child as IDestroy).destroy(true);
				}
				else
				{
					removeChildAt(0,true);	
				}
			}
		}
		
		public function removeAllListener():void
		{
		}
		
		public function nullAllReference():void
		{
			_bg=null;
		}
	}
}