package com.virtuos.display
{		
	import starling.core.RenderSupport;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public dynamic class MovieClip extends Sprite
	{
		/*Data structure*/
		private var _xml:XML;
		private var _swf:SWF;
		private var _textureFactoryInstance:AltasTextureFactory;
		private var _layers:Array = new Array();
		private var _totalFrames:int = 1;
		/*Class states*/
		private var _isPlaying:Boolean = true;
		private var _isFramePreset:Boolean = false;
		private var _isReversePlay:Boolean = false;
		private var _currentFrame:int = 1;
		private var _labelFrame:Object = {};
		private var _mTintFactor:int;
		
		private var _children:Vector.<DisplayObject> = new Vector.<DisplayObject>();
		
		public static var FINIAL_EVENT:String = "finialevent";
		
		public function MovieClip()
		{
			super();
		}
		
		public function set isPlaying(value:Boolean):void
		{
			_isPlaying = value;
		}
		
		public function get isPlaying():Boolean
		{
			return _isPlaying;
		}
		
		public function get children():Vector.<DisplayObject>
		{
			return _children;
		}
		
		public function reversePlay(isReverse:Boolean):void
		{
			_isReversePlay = isReverse;
		}
		
		public function get isReversePlay():Boolean
		{
			return _isReversePlay;
		}
		
		public function setLabelFrame(frameName:String, frame:int):void
		{
			_labelFrame[frameName] = frame;
		}
				
		/**
		 * Return the prototype of this instance, exclude the instance current state.
		 * All state of new instance return to the init states.
		 * @return New MovieClip instance.
		 * 
		 */		
		public function clone():MovieClip
		{
			var mc:MovieClip = new MovieClip();
			mc.setData(_swf, _xml, _textureFactoryInstance);
			return mc;
		}
		
		public function realParent():*
		{
			var realParent:*;
			if (this.parent)
			{
				if (this.parent is Layer)
					realParent = this.parent.parent as MovieClip;
				else
					realParent = this.parent;
			}
			return realParent;
		}
		
		public function setData(swf:SWF, movieClip:XML, factoryInstance:AltasTextureFactory):void
		{
			_xml = movieClip;
			_swf = swf;
			_textureFactoryInstance = factoryInstance;
			var layer:XMLList = _xml.children();
			var layerLen:uint=layer.length();
			for (var i:int = layerLen - 1; i >= 0; --i)
			{
				soluveLayer(layer[i]);
			}
			layer = null;
		}
		
		public function setTintFactor(color:uint):void
		{
			_mTintFactor = color;
		}
		
		public function removeTintFactor():void
		{
			_mTintFactor = -1;
		}
		
		private function soluveLayer(layerXML:XML):void
		{
			var layer:Layer = new Layer();
			addChild(layer);
			var frameCount:int = layer.setData(_swf, layerXML, _textureFactoryInstance);
			_totalFrames = _totalFrames < frameCount ? frameCount : _totalFrames;
			_layers.push(layer);
			layerXML = null;
		}
		
		public override function render(support:RenderSupport, alpha:Number):void
		{
			var layersLen:uint=_layers.length;
			for (var i:int = 0; i < layersLen; ++i)
				_layers[i].gotoAndStop(_currentFrame);
			
			if (_mTintFactor)
			{
				support.finishQuadBatch();
				support.setTintFactor(_mTintFactor);
				super.render(support, alpha);
				support.finishQuadBatch();
				support.removeTintFactor();
			}
			else
			{
				super.render(support, alpha);
			}
			if (currentFrame == totalFrames)
				dispatchEvent(new Event(FINIAL_EVENT));
			advanceFrame();
		}
		
		public override function removeChild(child:DisplayObject, dispose:Boolean=false):void
		{
			var layerLen:uint=_layers.length;
			if (this.contains(child))
			{
				super.removeChild(child, dispose);

				for (var i:int = 0; i <layerLen; ++i)
				{
					if (_layers[i].contains(child))
					{
						_layers[i].removeFromDisplayList(child);
						_layers[i].removeChild(child, dispose);
						
						break;
					}
				}
			}
		}
		
		public override function removeFromParent(dispose:Boolean=false):void
		{
			var realParent:* = realParent();
			if (realParent)
				realParent.removeChild(this, dispose);
		}
		
		private function advanceFrame():void
		{
			if (this.isPlaying)
			{
				if (!_isFramePreset)
				{
					if (!_isReversePlay)
						_currentFrame = ++_currentFrame > _totalFrames ? 1 : _currentFrame;
					else
						_currentFrame = --_currentFrame < 1 ? _totalFrames : _currentFrame;
				}
				else
					_isFramePreset = false;
			}
		}
		
		public function stop():void
		{
			isPlaying = false;	
		}
		
		public function play():void
		{
			isPlaying = true;
		}
		
		public function gotoAndStop(frame:*):void
		{
			var targetFrame:int = 1;
			if (frame is String)
			{
				if (_labelFrame[frame])
					targetFrame = _labelFrame[frame];
			}
			else
			{
				targetFrame = frame;
			}
			_currentFrame = targetFrame;
			isPlaying = false;
		}
				
		public function gotoAndPlay(frame:*):void
		{
			var targetFrame:int = 1;
			if (frame is String)
			{
				if (_labelFrame[frame])
					targetFrame = _labelFrame[frame];
			}
			else
			{
				targetFrame = frame;
			}
			_currentFrame = targetFrame;
			isPlaying = true;
			_isFramePreset = true;
		}
		
		public function get totalFrames():int
		{
			return _totalFrames;
		}
		
		public function get currentFrame():int
		{
			return _currentFrame;
		}
		
		public override function dispose():void
		{
			var layerLength:int = _layers.length;
			for (var i:int = 0; i < layerLength; ++i)
			{
				_layers[i].dispose();
			}
			_xml = null;
			super.dispose();
		}			
	}
}
		