package com.virtuos.Managers
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.getTimer;
	
	public class TimerManager extends Sprite
	{
		private var _id:int;
		private var _callbacks:Object;
		
		public function TimerManager()
		{
			_id=1;
			_callbacks={};
			addEventListener(Event.ENTER_FRAME,onEnterFrame);
		}
		
		private function onEnterFrame(event:Event):void
		{
			for each(var callback:Callback in _callbacks)
			{
				callback.call();
			}
		}
		
		/**
		 * 添加回调函数 
		 * @param $key 函数唯一关键字
		 * @param $fun 函数
		 * @param $freq 调用频率
		 * @param $isms 频率的单位：是为毫秒，否为帧频
		 * 
		 */
		public function addCallBack($fun:Function,$freq:int=1,$isms:Boolean=false,$callFirst:Boolean=true):int
		{
			if(!_callbacks[_id])
			{
				var callback:Callback=new Callback($fun,$freq,$isms,$callFirst);
				_callbacks[_id]=callback;
				return _id++;
			}
			return -1;
		}
		
		/**
		 * 移除回调函数 
		 * @param $key 函数唯一关键字
		 * 
		 */
		public function removeCallBack($id:int):void
		{
			if(_callbacks[$id])
			{
				(_callbacks[$id] as Callback).destroy();
				delete _callbacks[$id];
			}			
		}
		
		/** 是否包含该ID的回调 */
		public function hasCallBack($id:int):Boolean
		{
			return _callbacks.hasOwnProperty($id);
		}
	}
}
import flash.utils.getTimer;

class Callback
{
	private var _fun:Function;
	private var _time:int;
	private var _freq:int;
	private var _isms:Boolean;
	private var _k:int;
	
	public function Callback($fun:Function,$freq:int,$isms:Boolean,$callFirst:Boolean=true)
	{
		_fun=$fun;
		_time=getTimer();
		_freq=$freq;
		_isms=$isms;
		if($callFirst)
			_fun(0);
	}
	
	public function destroy():void
	{
		_fun=null;
	}
	
	public function call():void
	{
		var t:int=getTimer()-_time;
		if(_isms)
		{
			var n:int=(t-_k)/_freq;
			for(var i:int=1;i<=n;i++)
				if(_fun!=null)
					_fun(t);
			_k=t-(t-_k)%_freq;
		}
		else
		{
			if(_freq==1)
			{
				if(_fun!=null)
					_fun(t);
			}
			else
			{
				_k++;
				if(_k==_freq)
				{
					_k=0;
					if(_fun!=null)
						_fun(t);
				}
			}
		}
	}
}