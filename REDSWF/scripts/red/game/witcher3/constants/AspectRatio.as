package red.game.witcher3.constants
{
   public class AspectRatio
   {
      
      public static const ASPECT_RATIO_UNDEFINED:int = 0;
      
      public static const ASPECT_RATIO_DEFAULT:int = 1;
      
      public static const ASPECT_RATIO_4_3:int = 2;
      
      public static const ASPECT_RATIO_21_9:int = 3;
       
      
      public function AspectRatio()
      {
         super();
      }
      
      public static function getCurrentAspectRatio(param1:int, param2:int) : int
      {
         var _loc3_:Number = param1 / param2;
         if(Math.abs(_loc3_ - 4 / 3) < 0.1 || Math.abs(_loc3_ - 5 / 4) < 0.1)
         {
            return ASPECT_RATIO_4_3;
         }
         if(Math.abs(_loc3_ - 21 / 9) < 0.1 || Math.abs(_loc3_ - 43 / 18) < 0.1)
         {
            return ASPECT_RATIO_21_9;
         }
         return ASPECT_RATIO_DEFAULT;
      }
   }
}
