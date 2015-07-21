package com.virtuos.Characters
{
	import MyEvent.MyEvents;
	
	import com.virtuos.Managers.DataManager;
	import com.virtuos.OBJ3D.PointUI;
	import com.virtuos.SpriteContainer3D;
	import com.virtuos.display.MovieClip;
	import com.virtuos.display.SWF;
	import com.virtuos.loader.Loader3D;
	
	import flash.geom.Point;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class Player extends SpriteContainer3D
	{
		//[Embed(source="Assets/dracula.gif")]
		//private var dracula:Class;
		private static var _instance:Player;
		//point
		private var point:PointUI=PointUI.getInstance();
		//movement
		//public static var _isMove:Boolean=false;
		
		public  var _playStatus:com.virtuos.display.MovieClip;
		
		public function Player():void
		{
			super();
		}
		public static function getInstance():Player
		{
			if(!_instance)
				_instance=new Player();
			return _instance;
		}
		override protected function init(e:Event):void{			
			_playStatus= getMC();
			this.addChild(_playStatus);
			//point
			addChild(point);					
			point.x=512-25;
			point.y=384-25
			point.visible=false;
		}
		
		public function getMC():MovieClip
		{
			var _mc:MovieClip = (Loader3D.getInstance().resourceLibrary["UI"] as SWF).getMCInstance("ui.play.VampireStatus");
			_mc.x= (DataManager._stageWidth>>1)+10;
			_mc.y = (DataManager._stageHeight>>1)+8;
			_mc.gotoAndStop(1);
			return _mc;
		}
		
		//get and change point
		public function changePoint(PointStr:String):void
		{
			// xianshidianshu
			point._changePoint(PointStr);
			if(PointStr=="+10")
				point.visible=true;		
		}
		public function reset():void
		{
			point.visible=false;	
			this._playStatus.gotoAndStop(1);
			DataManager._playerFeeding=false;
			DataManager._playerMoving=false;
			DataManager._playerDeath=false;
		}
	}
}