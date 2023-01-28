package fl.motion
{
   import flash.filters.BitmapFilter;
   import flash.geom.ColorTransform;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.utils.getDefinitionByName;
   
   public class MotionBase
   {
       
      
      public var keyframes:Array;
      
      private var _spanStart:int;
      
      private var _transformationPoint:Point;
      
      private var _transformationPointZ:int;
      
      private var _initialPosition:Array;
      
      private var _initialMatrix:Matrix;
      
      private var _duration:int = 0;
      
      private var _is3D:Boolean = false;
      
      private var _overrideScale:Boolean;
      
      private var _overrideSkew:Boolean;
      
      private var _overrideRotate:Boolean;
      
      public function MotionBase(param1:XML = null)
      {
         var _loc2_:KeyframeBase = null;
         super();
         this.keyframes = [];
         if(this.duration == 0)
         {
            _loc2_ = this.getNewKeyframe();
            _loc2_.index = 0;
            this.addKeyframe(_loc2_);
         }
         this._overrideScale = false;
         this._overrideSkew = false;
         this._overrideRotate = false;
      }
      
      motion_internal function set spanStart(param1:int) : void
      {
         this._spanStart = param1;
      }
      
      motion_internal function get spanStart() : int
      {
         return this._spanStart;
      }
      
      motion_internal function set transformationPoint(param1:Point) : void
      {
         this._transformationPoint = param1;
      }
      
      motion_internal function get transformationPoint() : Point
      {
         return this._transformationPoint;
      }
      
      motion_internal function set transformationPointZ(param1:int) : void
      {
         this._transformationPointZ = param1;
      }
      
      motion_internal function get transformationPointZ() : int
      {
         return this._transformationPointZ;
      }
      
      motion_internal function set initialPosition(param1:Array) : void
      {
         this._initialPosition = param1;
      }
      
      motion_internal function get initialPosition() : Array
      {
         return this._initialPosition;
      }
      
      motion_internal function set initialMatrix(param1:Matrix) : void
      {
         this._initialMatrix = param1;
      }
      
      motion_internal function get initialMatrix() : Matrix
      {
         return this._initialMatrix;
      }
      
      public function get duration() : int
      {
         if(this._duration < this.keyframes.length)
         {
            this._duration = this.keyframes.length;
         }
         return this._duration;
      }
      
      public function set duration(param1:int) : void
      {
         if(param1 < this.keyframes.length)
         {
            param1 = int(this.keyframes.length);
         }
         this._duration = param1;
      }
      
      public function get is3D() : Boolean
      {
         return this._is3D;
      }
      
      public function set is3D(param1:Boolean) : void
      {
         this._is3D = param1;
      }
      
      public function overrideTargetTransform(param1:Boolean = true, param2:Boolean = true, param3:Boolean = true) : void
      {
         this._overrideScale = param1;
         this._overrideSkew = param2;
         this._overrideRotate = param3;
      }
      
      private function indexOutOfRange(param1:int) : Boolean
      {
         return isNaN(param1) || param1 < 0 || param1 > this.duration - 1;
      }
      
      public function getCurrentKeyframe(param1:int, param2:String = "") : KeyframeBase
      {
         var _loc4_:KeyframeBase = null;
         if(isNaN(param1) || param1 < 0 || param1 > this.duration - 1)
         {
            return null;
         }
         var _loc3_:int = param1;
         while(_loc3_ > 0)
         {
            if((Boolean(_loc4_ = this.keyframes[_loc3_])) && _loc4_.affectsTweenable(param2))
            {
               return _loc4_;
            }
            _loc3_--;
         }
         return this.keyframes[0];
      }
      
      public function getNextKeyframe(param1:int, param2:String = "") : KeyframeBase
      {
         var _loc4_:KeyframeBase = null;
         if(isNaN(param1) || param1 < 0 || param1 > this.duration - 1)
         {
            return null;
         }
         var _loc3_:int = param1 + 1;
         while(_loc3_ < this.keyframes.length)
         {
            if((Boolean(_loc4_ = this.keyframes[_loc3_])) && _loc4_.affectsTweenable(param2))
            {
               return _loc4_;
            }
            _loc3_++;
         }
         return null;
      }
      
      public function setValue(param1:int, param2:String, param3:Number) : void
      {
         if(param1 == 0)
         {
            return;
         }
         var _loc4_:KeyframeBase;
         if(!(_loc4_ = this.keyframes[param1]))
         {
            (_loc4_ = this.getNewKeyframe()).index = param1;
            this.addKeyframe(_loc4_);
         }
         _loc4_.setValue(param2,param3);
      }
      
      public function getColorTransform(param1:int) : ColorTransform
      {
         var _loc2_:ColorTransform = null;
         var _loc3_:KeyframeBase = this.getCurrentKeyframe(param1,"color");
         if(!_loc3_ || !_loc3_.color)
         {
            return null;
         }
         var _loc4_:ColorTransform = _loc3_.color;
         var _loc5_:Number;
         if((_loc5_ = param1 - _loc3_.index) == 0)
         {
            _loc2_ = _loc4_;
         }
         return _loc2_;
      }
      
      public function getMatrix3D(param1:int) : Object
      {
         var _loc2_:KeyframeBase = this.getCurrentKeyframe(param1,"matrix3D");
         return !!_loc2_ ? _loc2_.matrix3D : null;
      }
      
      public function getMatrix(param1:int) : Matrix
      {
         var _loc2_:KeyframeBase = this.getCurrentKeyframe(param1,"matrix");
         return !!_loc2_ ? _loc2_.matrix : null;
      }
      
      public function useRotationConcat(param1:int) : Boolean
      {
         var _loc2_:KeyframeBase = this.getCurrentKeyframe(param1,"rotationConcat");
         return !!_loc2_ ? _loc2_.useRotationConcat : false;
      }
      
      public function getFilters(param1:Number) : Array
      {
         var _loc2_:Array = null;
         var _loc3_:KeyframeBase = this.getCurrentKeyframe(param1,"filters");
         if(!_loc3_ || _loc3_.filters && !_loc3_.filters.length)
         {
            return [];
         }
         var _loc4_:Array = _loc3_.filters;
         var _loc5_:Number;
         if((_loc5_ = param1 - _loc3_.index) == 0)
         {
            _loc2_ = _loc4_;
         }
         return _loc2_;
      }
      
      protected function findTweenedValue(param1:Number, param2:String, param3:KeyframeBase, param4:Number, param5:Number) : Number
      {
         return NaN;
      }
      
      public function getValue(param1:Number, param2:String) : Number
      {
         var _loc3_:Number = NaN;
         var _loc4_:KeyframeBase;
         if(!(_loc4_ = this.getCurrentKeyframe(param1,param2)) || _loc4_.blank)
         {
            return NaN;
         }
         var _loc5_:Number = _loc4_.getValue(param2);
         if(isNaN(_loc5_) && _loc4_.index > 0)
         {
            _loc5_ = this.getValue(_loc4_.index - 1,param2);
         }
         if(isNaN(_loc5_))
         {
            return NaN;
         }
         var _loc6_:Number;
         if((_loc6_ = param1 - _loc4_.index) == 0)
         {
            return _loc5_;
         }
         return this.findTweenedValue(param1,param2,_loc4_,_loc6_,_loc5_);
      }
      
      public function addKeyframe(param1:KeyframeBase) : void
      {
         this.keyframes[param1.index] = param1;
         if(this.duration < this.keyframes.length)
         {
            this.duration = this.keyframes.length;
         }
      }
      
      public function addPropertyArray(param1:String, param2:Array, param3:int = -1, param4:int = -1) : void
      {
         var _loc10_:KeyframeBase = null;
         var _loc11_:* = undefined;
         var _loc12_:int = 0;
         var _loc13_:* = undefined;
         var _loc5_:int = int(param2.length);
         var _loc6_:* = null;
         var _loc7_:Boolean = true;
         var _loc8_:Number = 0;
         if(_loc5_ > 0)
         {
            if(param2[0] is Number)
            {
               _loc7_ = false;
               if(param2[0] is Number)
               {
                  _loc8_ = Number(param2[0]);
               }
            }
         }
         if(this.duration < _loc5_)
         {
            this.duration = _loc5_;
         }
         if(param3 == -1 || param4 == -1)
         {
            param3 = 0;
            param4 = this.duration;
         }
         var _loc9_:int = param3;
         while(_loc9_ < param4)
         {
            if((_loc10_ = KeyframeBase(this.keyframes[_loc9_])) == null)
            {
               (_loc10_ = this.getNewKeyframe()).index = _loc9_;
               this.addKeyframe(_loc10_);
            }
            if(Boolean(_loc10_.filters) && _loc10_.filters.length == 0)
            {
               _loc10_.filters = null;
            }
            _loc11_ = _loc6_;
            if((_loc12_ = _loc9_ - param3) < param2.length)
            {
               if(Boolean(param2[_loc12_]) || !_loc7_)
               {
                  _loc11_ = param2[_loc12_];
               }
            }
            switch(param1)
            {
               case "blendMode":
               case "matrix3D":
               case "matrix":
               case "cacheAsBitmap":
               case "opaqueBackground":
               case "visible":
                  _loc10_[param1] = _loc11_;
                  break;
               case "rotationConcat":
                  _loc10_.useRotationConcat = true;
                  if(!this._overrideRotate && !_loc7_)
                  {
                     _loc10_.setValue(param1,(_loc11_ - _loc8_) * Math.PI / 180);
                  }
                  else
                  {
                     _loc10_.setValue(param1,_loc11_ * Math.PI / 180);
                  }
                  break;
               case "brightness":
               case "tintMultiplier":
               case "tintColor":
               case "alphaMultiplier":
               case "alphaOffset":
               case "redMultiplier":
               case "redOffset":
               case "greenMultiplier":
               case "greenOffset":
               case "blueMultiplier":
               case "blueOffset":
                  if(_loc10_.color == null)
                  {
                     _loc10_.color = new Color();
                  }
                  _loc10_.color[param1] = _loc11_;
                  break;
               case "rotationZ":
                  _loc10_.useRotationConcat = true;
                  this._is3D = true;
                  if(!this._overrideRotate && !_loc7_)
                  {
                     _loc10_.setValue("rotationConcat",_loc11_ - _loc8_);
                  }
                  else
                  {
                     _loc10_.setValue("rotationConcat",_loc11_);
                  }
                  break;
               case "rotationX":
               case "rotationY":
               case "z":
                  this._is3D = true;
                  _loc13_ = _loc11_;
                  if(!_loc7_)
                  {
                     switch(param1)
                     {
                        case "scaleX":
                        case "scaleY":
                           if(!this._overrideScale)
                           {
                              if(_loc8_ == 0)
                              {
                                 _loc13_ = _loc11_ + 1;
                              }
                              else
                              {
                                 _loc13_ = _loc11_ / _loc8_;
                              }
                           }
                           break;
                        case "skewX":
                        case "skewY":
                           if(!this._overrideSkew)
                           {
                              _loc13_ = _loc11_ - _loc8_;
                           }
                           break;
                        case "rotationX":
                        case "rotationY":
                           if(!this._overrideRotate)
                           {
                              _loc13_ = _loc11_ - _loc8_;
                           }
                     }
                  }
                  break;
            }
            _loc10_.setValue(param1,_loc13_);
            _loc6_ = _loc11_;
            _loc9_++;
         }
      }
      
      public function initFilters(param1:Array, param2:Array, param3:int = -1, param4:int = -1) : void
      {
         var _loc6_:Class = null;
         var _loc7_:int = 0;
         var _loc8_:KeyframeBase = null;
         var _loc9_:BitmapFilter = null;
         var _loc10_:int = 0;
         if(param3 == -1 || param4 == -1)
         {
            param3 = 0;
            param4 = this.duration;
         }
         var _loc5_:int = 0;
         while(_loc5_ < param1.length)
         {
            _loc6_ = getDefinitionByName(param1[_loc5_]) as Class;
            _loc7_ = param3;
            while(_loc7_ < param4)
            {
               if((_loc8_ = KeyframeBase(this.keyframes[_loc7_])) == null)
               {
                  (_loc8_ = this.getNewKeyframe()).index = _loc7_;
                  this.addKeyframe(_loc8_);
               }
               if(Boolean(_loc8_) && _loc8_.filters == null)
               {
                  _loc8_.filters = new Array();
               }
               if(Boolean(_loc8_) && Boolean(_loc8_.filters))
               {
                  _loc9_ = null;
                  switch(param1[_loc5_])
                  {
                     case "flash.filters.GradientBevelFilter":
                     case "flash.filters.GradientGlowFilter":
                        _loc10_ = int(param2[_loc5_]);
                        _loc9_ = BitmapFilter(new _loc6_(4,45,new Array(_loc10_),new Array(_loc10_),new Array(_loc10_)));
                        break;
                     default:
                        _loc9_ = BitmapFilter(new _loc6_());
                  }
                  if(_loc9_)
                  {
                     _loc8_.filters.push(_loc9_);
                  }
               }
               _loc7_++;
            }
            _loc5_++;
         }
      }
      
      public function addFilterPropertyArray(param1:int, param2:String, param3:Array, param4:int = -1, param5:int = -1) : void
      {
         var _loc10_:KeyframeBase = null;
         var _loc11_:* = undefined;
         var _loc12_:int = 0;
         var _loc6_:int = int(param3.length);
         var _loc7_:* = null;
         var _loc8_:Boolean = true;
         if(_loc6_ > 0)
         {
            if(param3[0] is Number)
            {
               _loc8_ = false;
            }
         }
         if(this.duration < _loc6_)
         {
            this.duration = _loc6_;
         }
         if(param4 == -1 || param5 == -1)
         {
            param4 = 0;
            param5 = this.duration;
         }
         var _loc9_:int = param4;
         while(_loc9_ < param5)
         {
            if((_loc10_ = KeyframeBase(this.keyframes[_loc9_])) == null)
            {
               (_loc10_ = this.getNewKeyframe()).index = _loc9_;
               this.addKeyframe(_loc10_);
            }
            _loc11_ = _loc7_;
            if((_loc12_ = _loc9_ - param4) < param3.length)
            {
               if(Boolean(param3[_loc12_]) || !_loc8_)
               {
                  _loc11_ = param3[_loc12_];
               }
            }
            switch(param2)
            {
               case "adjustColorBrightness":
               case "adjustColorContrast":
               case "adjustColorSaturation":
               case "adjustColorHue":
                  _loc10_.setAdjustColorProperty(param1,param2,_loc11_);
                  break;
               default:
                  if(param1 < _loc10_.filters.length)
                  {
                     _loc10_.filters[param1][param2] = _loc11_;
                  }
                  break;
            }
            _loc7_ = _loc11_;
            _loc9_++;
         }
      }
      
      protected function getNewKeyframe(param1:XML = null) : KeyframeBase
      {
         return new KeyframeBase(param1);
      }
   }
}
