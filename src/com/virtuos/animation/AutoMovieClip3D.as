package com.virtuos.animation
{
	import com.virtuos.Managers.DataManager;
	import com.virtuos.display.MovieClip;
	import com.virtuos.display.SWF;
	import com.virtuos.loader.Loader3D;
	
	
	/**
	 * 播放完自动移除的MovieClip 
	 * 
	 * @author yuyaling
	 * 
	 */	
	public class AutoMovieClip3D extends BaseElem3D
	{
		/** 播放完后的回调 */
		private var _callback:Function;
		private var _timerId:int=-1;
		
		public function AutoMovieClip3D($className:String,$callback:Function=null)
		{
			_bg=(Loader3D.getInstance().resourceLibrary["UI"] as SWF).getMCInstance($className);
			_callback=$callback;
			super();
		}
		
		protected override function init():void
		{
			addChild(_bg);
			_timerId=GlobalValue.timer.addCallBack(onEnterFrame,1,false,false);
		}
		
		private function onEnterFrame($time:int):void
		{
			if(_mc.currentFrame==_mc.totalFrames)
			{
				if(_callback!=null)
					_callback();
				destroy();
			}
		}
		
		public function get mc():MovieClip
		{
			return _mc;
		}
		
		public override function removeAllListener():void
		{
			super.removeAllListener();
			GlobalValue.timer.removeCallBack(_timerId);
		}
		
		public override function nullAllReference():void
		{
			super.nullAllReference();
			_callback=null;
		}
	}
}