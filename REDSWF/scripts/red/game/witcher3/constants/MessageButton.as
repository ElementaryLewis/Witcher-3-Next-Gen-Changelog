package red.game.witcher3.constants
{
   import scaleform.clik.constants.NavigationCode;
   
   public class MessageButton
   {
      
      public static const MB_OK:uint = 0;
      
      public static const MB_CANCEL:uint = 1;
      
      public static const MB_ABORT:uint = 2;
      
      public static const MB_YES:uint = 3;
      
      public static const MB_NO:uint = 4;
       
      
      public function MessageButton()
      {
         super();
      }
      
      public static function getLocalizedLabel(param1:uint) : String
      {
         var _loc2_:String = "ERROR";
         switch(param1)
         {
            case MB_OK:
               _loc2_ = "OK";
               break;
            case MB_CANCEL:
               _loc2_ = "CANCEL";
               break;
            case MB_ABORT:
               _loc2_ = "ABORT";
               break;
            case MB_YES:
               _loc2_ = "YES";
               break;
            case MB_NO:
               _loc2_ = "NO";
         }
         return _loc2_;
      }
      
      public static function getGamepadNavCode(param1:uint) : String
      {
         var _loc2_:String = "ERROR";
         switch(param1)
         {
            case MB_OK:
            case MB_YES:
               _loc2_ = NavigationCode.GAMEPAD_A;
               break;
            case MB_CANCEL:
            case MB_NO:
               _loc2_ = NavigationCode.GAMEPAD_B;
               break;
            case MB_ABORT:
               _loc2_ = NavigationCode.GAMEPAD_Y;
         }
         return _loc2_;
      }
      
      public static function getPcKeyCode(param1:uint) : uint
      {
         var _loc2_:uint = 0;
         switch(param1)
         {
            case MB_OK:
            case MB_YES:
               _loc2_ = KeyCode.ENTER;
               break;
            case MB_CANCEL:
            case MB_NO:
               _loc2_ = KeyCode.ESCAPE;
               break;
            case MB_ABORT:
               _loc2_ = 0;
         }
         return _loc2_;
      }
      
      public static function isPositive(param1:uint) : Boolean
      {
         switch(param1)
         {
            case MB_OK:
            case MB_YES:
               return true;
            case MB_CANCEL:
            case MB_NO:
            case MB_ABORT:
               return false;
            default:
               return false;
         }
      }
   }
}
