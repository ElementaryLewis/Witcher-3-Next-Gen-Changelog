package red.game.witcher3.constants
{
   public class SkillColor
   {
      
      public static var none:String = "SC_None";
      
      public static var blue:String = "SC_Blue";
      
      public static var green:String = "SC_Green";
      
      public static var yellow:String = "SC_Yellow";
      
      public static var red:String = "SC_Red";
       
      
      public function SkillColor()
      {
         super();
      }
      
      public static function nameToEnum(param1:String) : uint
      {
         switch(param1)
         {
            case none:
               return 0;
            case blue:
               return 1;
            case green:
               return 2;
            case red:
               return 3;
            case yellow:
               return 4;
            default:
               return 0;
         }
      }
      
      public static function enumToName(param1:uint) : String
      {
         switch(param1)
         {
            case 0:
               return none;
            case 1:
               return blue;
            case 2:
               return green;
            case 3:
               return red;
            case 4:
               return yellow;
            default:
               return none;
         }
      }
      
      public static function enumToColor(param1:uint) : Number
      {
         switch(param1)
         {
            case 0:
               return 16777215;
            case 1:
               return 6666237;
            case 2:
               return 9960805;
            case 3:
               return 16601939;
            case 4:
               return 16777049;
            default:
               return 16777215;
         }
      }
   }
}
