package com.virtuos.Characters
{
	import com.virtuos.Managers.DataManager;
	import com.virtuos.Managers.HunterManager;
	
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import starling.display.Image;

	public class VampireHunter extends BaseEnemy
	{
		[Embed(source="Assets/hunter_view.png")]
		private var _view:Class;		
		public var _hunterTorch:Image;
		[Embed(source="Assets/hunter.png")]
		private var _temp:Class;
		public var _hunter:Image;
		
		public function VampireHunter()
		{
			super();
			_hunterTorch=Image.fromBitmap(new _view)
			addChild(_hunterTorch)
			
			_hunterTorch.dispose();
			
			_hunterTorch.width=_hunterTorch.height=DataManager._hunterTorchCollision;
			_hunterTorch.x=_hunterTorch.y=35-DataManager._hunterTorchCollision>>1;
			
			_hunter = Image.fromBitmap(new _temp());
			_hunter.x= _hunter.y = -25;
			_hunterTorch.width=_hunterTorch.height=DataManager._hunterTorchCollision;
			_hunterTorch.x=_hunterTorch.y=0-DataManager._hunterTorchCollision>>1;
			addChild(_hunter);
			_hunter.dispose();

		}
		public function setPosition(_tempX:Number,_tempY:Number):void{
			this.x=_tempX//-this.width/2;
			this.y=_tempY//-this.height/2;
		}
		
		public function _removeTorch():void{
			//removeChild(tempTorch)
			_hunterTorch.visible=false;
		}
		//
		public function startSeek():void{			
			_seekTimer = new Timer(DataManager._enemySeekingTime);			
			_seekTimer.addEventListener("timer",seekHandler)
			_seekTimer.start();		
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
				//FarmerManager.enemyAI(this,true);				
				HunterManager.enemyAI(this);
			}
		}
	}
}