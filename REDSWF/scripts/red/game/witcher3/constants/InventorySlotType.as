package red.game.witcher3.constants
{
   public class InventorySlotType
   {
      
      public static const InvalidSlot:int = 0;
      
      public static const SilverSword:int = 1;
      
      public static const SteelSword:int = 2;
      
      public static const Armor:int = 3;
      
      public static const Boots:int = 4;
      
      public static const Pants:int = 5;
      
      public static const Gloves:int = 6;
      
      public static const Petard1:int = 7;
      
      public static const Petard2:int = 8;
      
      public static const RangedWeapon:int = 9;
      
      public static const Quickslot1:int = 10;
      
      public static const Quickslot2:int = 11;
      
      public static const Trophy:int = 12;
      
      public static const Potion1:int = 14;
      
      public static const Potion2:int = 15;
      
      public static const Unused1:int = 16;
      
      public static const Bolt:int = 17;
      
      public static const Mutagen1:int = 18;
      
      public static const Mutagen2:int = 19;
      
      public static const Mutagen3:int = 20;
      
      public static const Mutagen4:int = 21;
      
      public static const SkillMutagen1:int = 22;
      
      public static const SkillMutagen2:int = 23;
      
      public static const SkillMutagen3:int = 24;
      
      public static const SkillMutagen4:int = 25;
      
      public static const HorseBlinders:int = 26;
      
      public static const HorseSaddle:int = 27;
      
      public static const HorseBag:int = 28;
      
      public static const HorseTrophy:int = 29;
      
      public static const Potion3:int = 30;
      
      public static const Potion4:int = 31;
      
      public static const _COUNT:int = 32;
       
      
      public function InventorySlotType()
      {
         super();
      }
      
      public static function getSortingWeight(param1:int) : int
      {
         switch(param1)
         {
            case Potion1:
            case Potion2:
            case Potion3:
            case Potion4:
               return 1;
            case Petard1:
            case Petard2:
               return 2;
            default:
               return param1;
         }
      }
   }
}
