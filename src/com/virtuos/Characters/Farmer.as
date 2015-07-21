package com.virtuos.Characters
{
	import com.virtuos.Managers.DataManager;
	import com.virtuos.Managers.FarmerManager;
	import com.virtuos.display.MovieClip;
	import com.virtuos.display.SWF;
	import com.virtuos.loader.Loader3D;
	
	import flash.events.TimerEvent;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	
	import starling.core.RenderSupport;
	import starling.display.Image;
	
	public class Farmer extends BaseEnemy
	{		
		[Embed(source="Assets/farmer_view.png")]
		private var _Torch:Class;		
		public var tempTorch:Image;
		public  var _farmerStatus:com.virtuos.display.MovieClip;
		//向左向上，遇到enemy的位置
		public var _hitEnemyX:uint
		public var _hitEnemyY:uint
		//	
		//alert
		public var _alert_Distance:Number;
		public var _alert_DistanceX:Number;
		public var _alert_DistanceY:Number;
		public var _alert_RatioX:Number;
		public var _alert_RatioY:Number;
		public function Farmer()
		{
			super();
			tempTorch=Image.fromBitmap(new _Torch)
			addChild(tempTorch)

			tempTorch.dispose();

			tempTorch.width=tempTorch.height=DataManager._torchCollision;
			tempTorch.x=tempTorch.y=35-DataManager._torchCollision>>1;
			
			_farmerStatus=(Loader3D.getInstance().resourceLibrary["UI"] as SWF).getMCInstance("ui.farmer.FarmerStatus");
			_farmerStatus.x= _farmerStatus.y = 25;
			addChild(_farmerStatus);
			_farmerStatus.gotoAndStop(1);
		}
		public function startSeek():void{			
				_seekTimer = new Timer(DataManager._enemySeekingTime);			
				_seekTimer.addEventListener("timer",seekHandler)
				_seekTimer.start();		
		}
		public function stopSeek():void{
			if(this.visible){
				FarmerManager.enemyAI(this,true);			
				_seekTimer.removeEventListener("timer",seekHandler)
				_seekTimer.stop();	
			}			
		}
		private function seekHandler(e:TimerEvent):void{
			
			xD=this.x-DataManager._playerPoint.x;
			yD=this.y-DataManager._playerPoint.y;
			newPX=(int(DataManager._playerPoint.x)-int(DataManager._playerPoint.x)%50)/50
			newPY=(int(DataManager._playerPoint.y)-int(DataManager._playerPoint.y)%50)/50
			if(Math.sqrt(xD*xD+yD*yD)<=DataManager._seekRadius&&this.visible){
				//trace(this,this._id,this.x,this.y)			
				this.myDistinationX=newPY//DataManager._wayPointArray[0].j;
				this.myDistinationY=newPX//DataManager._wayPointArray[0].i;
				this._seekedPlayer=true;
				if(this._farmerStatus.currentFrame!=4){
					this._farmerStatus.gotoAndStop(1);
				}
				trace(this._id,this.x,this.y)
				//FarmerManager.enemyAI(this,true);				
				FarmerManager.enemyAI(this);
			}
		}
		public function setPosition(_tempX:Number,_tempY:Number):void{
			this.x=_tempX-25;
			this.y=_tempY-25;
			tempTorch.visible=true;
			_isFeed=false;
		}
		//torch disapp
		public function _removeTorch():void{
			tempTorch.visible=false;
			//removeChild(tempTorch)
			
		}
		
		public function removeAllChildren():void
		{
			while(this.numChildren>0)
			{
				removeChildAt(0,true);
			}
			_farmerStatus.dispose();
		}
	}
}