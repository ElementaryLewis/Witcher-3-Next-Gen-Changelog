package fl.motion
{
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.geom.Matrix;
   import flash.geom.Matrix3D;
   import flash.geom.Point;
   import flash.geom.Vector3D;
   
   public class Animator3D extends AnimatorBase
   {
      
      private static var IDENTITY_MATRIX:Matrix = new Matrix();
      
      protected static const EPSILON:Number = 1e-8;
       
      
      private var _initialPosition:Vector3D;
      
      private var _initialMatrixOfTarget:Matrix3D;
      
      public function Animator3D(param1:XML = null, param2:DisplayObject = null)
      {
         super(param1,param2);
         this.transformationPoint = new Point(0,0);
         this._initialPosition = null;
         this._initialMatrixOfTarget = null;
         this._isAnimator3D = true;
      }
      
      protected static function getSign(param1:Number) : int
      {
         return param1 < -EPSILON ? -1 : (param1 > EPSILON ? 1 : 0);
      }
      
      protected static function convertMatrixToMatrix3D(param1:Matrix) : Matrix3D
      {
         var _loc2_:Vector.<Number> = new Vector.<Number>(16);
         _loc2_[0] = param1.a;
         _loc2_[1] = param1.b;
         _loc2_[2] = 0;
         _loc2_[3] = 0;
         _loc2_[4] = param1.c;
         _loc2_[5] = param1.d;
         _loc2_[6] = 0;
         _loc2_[7] = 0;
         _loc2_[8] = 0;
         _loc2_[9] = 0;
         _loc2_[10] = 1;
         _loc2_[11] = 0;
         _loc2_[12] = param1.tx;
         _loc2_[13] = param1.ty;
         _loc2_[14] = 0;
         _loc2_[15] = 1;
         return new Matrix3D(_loc2_);
      }
      
      protected static function matrices3DEqual(param1:Matrix3D, param2:Matrix3D) : Boolean
      {
         var _loc3_:Vector.<Number> = param1.rawData;
         var _loc4_:Vector.<Number> = param2.rawData;
         if(_loc3_ == null || _loc3_.length != 16 || _loc4_ == null || _loc4_.length != 16)
         {
            return false;
         }
         var _loc5_:int = 0;
         while(_loc5_ < 16)
         {
            if(_loc3_[_loc5_] != _loc4_[_loc5_])
            {
               return false;
            }
            _loc5_++;
         }
         return true;
      }
      
      override public function set initialPosition(param1:Array) : void
      {
         if(param1.length == 3)
         {
            this._initialPosition = new Vector3D();
            this._initialPosition.x = param1[0];
            this._initialPosition.y = param1[1];
            this._initialPosition.z = param1[2];
         }
      }
      
      override protected function setTargetState() : void
      {
         if(!motionArray && this._target.transform.matrix != null)
         {
            this._initialMatrixOfTarget = convertMatrixToMatrix3D(this._target.transform.matrix);
         }
      }
      
      override protected function setTime3D(param1:int, param2:MotionBase) : Boolean
      {
         var _loc4_:Matrix3D = null;
         var _loc5_:Matrix3D = null;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:Matrix = null;
         var _loc13_:Matrix3D = null;
         var _loc3_:Matrix3D = param2.getMatrix3D(param1) as Matrix3D;
         if(Boolean(motionArray) && param2 != _lastMotionUsed)
         {
            this.transformationPoint = !!param2.motion_internal::transformationPoint ? param2.motion_internal::transformationPoint : new Point(0,0);
            if(param2.motion_internal::initialPosition)
            {
               this.initialPosition = param2.motion_internal::initialPosition;
            }
            else
            {
               this._initialPosition = null;
            }
            _lastMotionUsed = param2;
         }
         if(_loc3_)
         {
            if(!motionArray || !_lastMatrix3DApplied || !matrices3DEqual(_loc3_,Matrix3D(_lastMatrix3DApplied)))
            {
               _loc4_ = _loc3_.clone();
               if(this._initialMatrixOfTarget)
               {
                  _loc4_.append(this._initialMatrixOfTarget);
               }
               this._target.transform.matrix3D = _loc4_;
               _lastMatrix3DApplied = _loc3_;
            }
            return true;
         }
         if(param2.is3D)
         {
            _loc5_ = new Matrix3D();
            _loc6_ = param2.getValue(param1,Tweenables.ROTATION_X) * Math.PI / 180;
            _loc7_ = param2.getValue(param1,Tweenables.ROTATION_Y) * Math.PI / 180;
            _loc8_ = param2.getValue(param1,Tweenables.ROTATION_CONCAT) * Math.PI / 180;
            _loc5_.prepend(MatrixTransformer3D.rotateAboutAxis(_loc8_,MatrixTransformer3D.AXIS_Z));
            _loc5_.prepend(MatrixTransformer3D.rotateAboutAxis(_loc7_,MatrixTransformer3D.AXIS_Y));
            _loc5_.prepend(MatrixTransformer3D.rotateAboutAxis(_loc6_,MatrixTransformer3D.AXIS_X));
            _loc9_ = param2.getValue(param1,Tweenables.X);
            _loc10_ = param2.getValue(param1,Tweenables.Y);
            _loc11_ = param2.getValue(param1,Tweenables.Z);
            if(getSign(_loc9_) != 0 || getSign(_loc10_) != 0 || getSign(_loc11_) != 0)
            {
               _loc5_.appendTranslation(_loc9_,_loc10_,_loc11_);
            }
            _loc5_.prependTranslation(-this.transformationPoint.x,-this.transformationPoint.y,-this.transformationPointZ);
            if(this._initialPosition)
            {
               _loc5_.appendTranslation(this._initialPosition.x,this._initialPosition.y,this._initialPosition.z);
            }
            _loc12_ = this.getScaleSkewMatrix(param2,param1,this.transformationPoint.x,this.transformationPoint.y);
            _loc13_ = convertMatrixToMatrix3D(_loc12_);
            _loc5_.prepend(_loc13_);
            if(this._initialMatrixOfTarget)
            {
               _loc5_.append(this._initialMatrixOfTarget);
            }
            if(!motionArray || !_lastMatrix3DApplied || !matrices3DEqual(_loc5_,Matrix3D(_lastMatrix3DApplied)))
            {
               this._target.transform.matrix3D = _loc5_;
               _lastMatrix3DApplied = _loc5_;
            }
         }
         return false;
      }
      
      override protected function removeChildTarget(param1:MovieClip, param2:DisplayObject, param3:String) : void
      {
         super.removeChildTarget(param1,param2,param3);
         if(param2.transform.matrix3D != null)
         {
            param2.transform.matrix = IDENTITY_MATRIX;
         }
      }
      
      private function getScaleSkewMatrix(param1:MotionBase, param2:int, param3:Number, param4:Number) : Matrix
      {
         var _loc5_:Number = param1.getValue(param2,Tweenables.SCALE_X);
         var _loc6_:Number = param1.getValue(param2,Tweenables.SCALE_Y);
         var _loc7_:Number = param1.getValue(param2,Tweenables.SKEW_X);
         var _loc8_:Number = param1.getValue(param2,Tweenables.SKEW_Y);
         var _loc9_:Matrix;
         (_loc9_ = new Matrix()).translate(-param3,-param4);
         var _loc10_:Matrix;
         (_loc10_ = new Matrix()).scale(_loc5_,_loc6_);
         _loc9_.concat(_loc10_);
         var _loc11_:Matrix;
         (_loc11_ = new Matrix()).a = Math.cos(_loc8_ * (Math.PI / 180));
         _loc11_.b = Math.sin(_loc8_ * (Math.PI / 180));
         _loc11_.c = -Math.sin(_loc7_ * (Math.PI / 180));
         _loc11_.d = Math.cos(_loc7_ * (Math.PI / 180));
         _loc9_.concat(_loc11_);
         _loc9_.translate(param3,param4);
         return _loc9_;
      }
   }
}
