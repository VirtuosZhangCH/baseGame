package com.virtuos.OBJ3D
{
	import com.virtuos.Managers.DataManager;
	import com.virtuos.SpriteContainer3D;
	
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import starling.events.Event;
	import starling.text.BitmapFont;
	import starling.text.TextField;

	/*
	 *杀死敌人后获得的点数 	
	*/
	public class PointUI extends SpriteContainer3D
	{	
		//private var _tex:TextField=new TextField(100,10,'+10');
		private var mTextField:TextField;
		private var myTimer:Timer=new Timer(100);
		private var _time:uint=0;
		private static var _instance:PointUI;
		public function PointUI()
		{
			super();
			//addEventListener(Event.ADDED_TO_STAGE, init2);
		}
		public static function getInstance():PointUI
		{
			if(!_instance)
				_instance=new PointUI();
			return _instance;
		}
		override protected function init(e:starling.events.Event):void{
			mTextField = new TextField(128, 32, "+10", BitmapFont.MINI,30, 0xff0000);
			addChild(mTextField);
			mTextField.x=20;
		}
		public function _changePoint(str:String):void{	
			_time=0;
			this.y=359;
			mTextField.text=str;
			myTimer.addEventListener("timer",timerHandler);
			myTimer.start();
			
		}
		private function timerHandler(event:TimerEvent):void {
				if(DataManager._playerDeath){
					myTimer.removeEventListener("timer",timerHandler);
					myTimer.stop();
					_time=0;
					this.y=359;
					this.visible=false;
					return
				}
				_time++
				
				if(mTextField.text=='+10'){
					this.y-=2
				}else{
					//this.visible=false;
					if(_time>=10){
						this.visible=true;
						this.y-=2
					}
				}
				if(mTextField.text=='+10'){
					if(_time>=20){
						this.y=359;
						this.visible=false;
						myTimer.removeEventListener("timer",timerHandler);
						myTimer.stop();
						_time=0;
					}
				}else{
					if(_time>=25){
						this.y=359;
						this.visible=false;
						myTimer.removeEventListener("timer",timerHandler);
						myTimer.stop();
						_time=0;
					}
				}
		}			
	}
}