package fl.motion
{
   import flash.geom.Matrix3D;
   import flash.geom.Vector3D;
   
   public class MatrixTransformer3D
   {
      
      public static const AXIS_X:int = 0;
      
      public static const AXIS_Y:int = 1;
      
      public static const AXIS_Z:int = 2;
       
      
      public function MatrixTransformer3D()
      {
         super();
      }
      
      public static function rotateAboutAxis(param1:Number, param2:int) : Matrix3D
      {
         var _loc3_:Number = Math.cos(param1);
         var _loc4_:Number = Math.sin(param1);
         var _loc5_:Vector.<Number> = new Vector.<Number>();
         switch(param2)
         {
            case AXIS_X:
               _loc5_[0] = 1;
               _loc5_[1] = 0;
               _loc5_[2] = 0;
               _loc5_[3] = 0;
               _loc5_[4] = 0;
               _loc5_[5] = _loc3_;
               _loc5_[6] = _loc4_;
               _loc5_[7] = 0;
               _loc5_[8] = 0;
               _loc5_[9] = -_loc4_;
               _loc5_[10] = _loc3_;
               _loc5_[11] = 0;
               _loc5_[12] = 0;
               _loc5_[13] = 0;
               _loc5_[14] = 0;
               _loc5_[15] = 1;
               break;
            case AXIS_Y:
               _loc5_[0] = _loc3_;
               _loc5_[1] = 0;
               _loc5_[2] = -_loc4_;
               _loc5_[3] = 0;
               _loc5_[4] = 0;
               _loc5_[5] = 1;
               _loc5_[6] = 0;
               _loc5_[7] = 0;
               _loc5_[8] = _loc4_;
               _loc5_[9] = 0;
               _loc5_[10] = _loc3_;
               _loc5_[11] = 0;
               _loc5_[12] = 0;
               _loc5_[13] = 0;
               _loc5_[14] = 0;
               _loc5_[15] = 1;
               break;
            case AXIS_Z:
               _loc5_[0] = _loc3_;
               _loc5_[1] = _loc4_;
               _loc5_[2] = 0;
               _loc5_[3] = 0;
               _loc5_[4] = -_loc4_;
               _loc5_[5] = _loc3_;
               _loc5_[6] = 0;
               _loc5_[7] = 0;
               _loc5_[8] = 0;
               _loc5_[9] = 0;
               _loc5_[10] = 1;
               _loc5_[11] = 0;
               _loc5_[12] = 0;
               _loc5_[13] = 0;
               _loc5_[14] = 0;
               _loc5_[15] = 1;
         }
         return new Matrix3D(_loc5_);
      }
      
      public static function getVector(param1:Matrix3D, param2:int) : Vector3D
      {
         switch(param2)
         {
            case 0:
               return new Vector3D(param1.rawData[0],param1.rawData[1],param1.rawData[2],param1.rawData[3]);
            case 1:
               return new Vector3D(param1.rawData[4],param1.rawData[5],param1.rawData[6],param1.rawData[7]);
            case 2:
               return new Vector3D(param1.rawData[8],param1.rawData[9],param1.rawData[10],param1.rawData[11]);
            case 3:
               return new Vector3D(param1.rawData[12],param1.rawData[13],param1.rawData[14],param1.rawData[15]);
            default:
               return new Vector3D(0,0,0,0);
         }
      }
      
      public static function getMatrix3D(param1:Vector3D, param2:Vector3D, param3:Vector3D, param4:Vector3D) : Matrix3D
      {
         var _loc5_:Vector.<Number>;
         (_loc5_ = new Vector.<Number>())[0] = param1.x;
         _loc5_[1] = param1.y;
         _loc5_[2] = param1.z;
         _loc5_[3] = param1.w;
         _loc5_[4] = param2.x;
         _loc5_[5] = param2.y;
         _loc5_[6] = param2.z;
         _loc5_[7] = param2.w;
         _loc5_[8] = param3.x;
         _loc5_[9] = param3.y;
         _loc5_[10] = param3.z;
         _loc5_[11] = param3.w;
         _loc5_[12] = param4.x;
         _loc5_[13] = param4.y;
         _loc5_[14] = param4.z;
         _loc5_[15] = param4.w;
         return new Matrix3D(_loc5_);
      }
      
      public static function rotateAxis(param1:Matrix3D, param2:Number, param3:int) : Matrix3D
      {
         var _loc7_:Vector3D = null;
         var _loc8_:Array = null;
         var _loc9_:int = 0;
         var _loc10_:Vector.<Number> = null;
         var _loc11_:Vector3D = null;
         var _loc4_:Matrix3D = new Matrix3D();
         var _loc5_:Vector3D = getVector(param1,param3);
         _loc4_.prependRotation(param2 * 180 / Math.PI,_loc5_);
         var _loc6_:int = 0;
         while(_loc6_ < 3)
         {
            if(_loc6_ != param3)
            {
               _loc7_ = getVector(param1,_loc6_);
               _loc8_ = new Array(3);
               _loc9_ = 0;
               while(_loc9_ < 3)
               {
                  _loc11_ = getVector(_loc4_,_loc9_);
                  _loc8_[_loc9_] = _loc7_.dotProduct(_loc11_);
                  _loc9_++;
               }
               _loc7_.x = _loc8_[0];
               _loc7_.y = _loc8_[1];
               _loc7_.z = _loc8_[2];
               _loc7_.w = 0;
               _loc7_ = normalizeVector(_loc7_);
               (_loc10_ = Vector.<Number>(getRawDataVector(param1)))[_loc6_ * 4] = _loc7_.x;
               _loc10_[_loc6_ * 4 + 1] = _loc7_.y;
               _loc10_[_loc6_ * 4 + 2] = _loc7_.z;
               _loc10_[_loc6_ * 4 + 3] = _loc7_.w;
               param1 = new Matrix3D(Vector.<Number>(_loc10_));
            }
            _loc6_++;
         }
         return param1;
      }
      
      public static function normalizeVector(param1:Vector3D) : Vector3D
      {
         var _loc2_:Number = 1 / param1.length;
         var _loc3_:Vector3D = new Vector3D();
         _loc3_.x = param1.x * _loc2_;
         _loc3_.y = param1.y * _loc2_;
         _loc3_.z = param1.z * _loc2_;
         _loc3_.w = param1.w;
         return _loc3_;
      }
      
      public static function getRawDataVector(param1:Matrix3D) : Vector.<Number>
      {
         var _loc2_:Vector.<Number> = new Vector.<Number>();
         _loc2_[0] = param1.rawData[0];
         _loc2_[1] = param1.rawData[1];
         _loc2_[2] = param1.rawData[2];
         _loc2_[3] = param1.rawData[3];
         _loc2_[4] = param1.rawData[4];
         _loc2_[5] = param1.rawData[5];
         _loc2_[6] = param1.rawData[6];
         _loc2_[7] = param1.rawData[7];
         _loc2_[8] = param1.rawData[8];
         _loc2_[9] = param1.rawData[9];
         _loc2_[10] = param1.rawData[10];
         _loc2_[11] = param1.rawData[11];
         _loc2_[12] = param1.rawData[12];
         _loc2_[13] = param1.rawData[13];
         _loc2_[14] = param1.rawData[14];
         _loc2_[15] = param1.rawData[15];
         return _loc2_;
      }
   }
}
