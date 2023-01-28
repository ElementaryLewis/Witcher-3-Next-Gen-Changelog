package witcher3.utils
{
   public class InputUtils
   {
       
      
      public function InputUtils()
      {
         super();
      }
      
      public static function toggleAnalogInput(param1:Boolean) : void
      {
      }
      
      public static function getAngleRadians(param1:Number, param2:Number) : Number
      {
         var _loc3_:Number = Math.atan2(param2,param1);
         if(_loc3_ < 0)
         {
            _loc3_ += 2 * Math.PI;
         }
         return _loc3_;
      }
      
      public static function getMagnitudeSquared(param1:Number, param2:Number) : Number
      {
         return param1 * param1 + param2 * param2;
      }
      
      public static function getMagnitude(param1:Number, param2:Number) : Number
      {
         return Math.sqrt(param1 * param1 + param2 * param2);
      }
      
      public static function radiansToDegrees(param1:Number) : Number
      {
         return param1 * 180 / Math.PI;
      }
      
      public static function degreesToRadians(param1:Number) : Number
      {
         return param1 * Math.PI / 180;
      }
   }
}
