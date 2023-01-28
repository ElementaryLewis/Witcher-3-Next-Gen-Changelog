package red.game.witcher3.menus.gwint
{
   import flash.utils.Dictionary;
   
   public class CardTemplate
   {
      
      public static const FactionId_Error:int = -1;
      
      public static const FactionId_Neutral:int = 0;
      
      public static const FactionId_No_Mans_Land:int = 1;
      
      public static const FactionId_Nilfgaard:int = 2;
      
      public static const FactionId_Northern_Kingdom:int = 3;
      
      public static const FactionId_Scoiatael:int = 4;
      
      public static const FactionId_Skellige:int = 5;
      
      public static const CardType_None:uint = 0;
      
      public static const CardType_Melee:uint = 1;
      
      public static const CardType_Ranged:uint = 2;
      
      public static const CardType_RangedMelee:uint = 3;
      
      public static const CardType_Siege:uint = 4;
      
      public static const CardType_SeigeRangedMelee:uint = 7;
      
      public static const CardType_Creature:uint = 8;
      
      public static const CardType_Weather:uint = 16;
      
      public static const CardType_Spell:uint = 32;
      
      public static const CardType_Row_Modifier:uint = 64;
      
      public static const CardType_Hero:uint = 128;
      
      public static const CardType_Spy:uint = 256;
      
      public static const CardType_Friendly_Effect:uint = 512;
      
      public static const CardType_Offsensive_Effect:uint = 1024;
      
      public static const CardType_Global_Effect:uint = 2048;
      
      public static const CardEffect_None:int = 0;
      
      public static const CardEffect_Backstab:int = 1;
      
      public static const CardEffect_Morale_Boost:int = 2;
      
      public static const CardEffect_Ambush:int = 3;
      
      public static const CardEffect_ToughSkin:int = 4;
      
      public static const CardEffect_Bin2:int = 5;
      
      public static const CardEffect_Bin3:int = 6;
      
      public static const CardEffect_MeleeScorch:int = 7;
      
      public static const CardEffect_11th_card:int = 8;
      
      public static const CardEffect_Clear_Weather:int = 9;
      
      public static const CardEffect_Pick_Weather:int = 10;
      
      public static const CardEffect_Pick_Rain:int = 11;
      
      public static const CardEffect_Pick_Fog:int = 12;
      
      public static const CardEffect_Pick_Frost:int = 13;
      
      public static const CardEffect_View_3_Enemy:int = 14;
      
      public static const CardEffect_Resurect:int = 15;
      
      public static const CardEffect_Resurect_Enemy:int = 16;
      
      public static const CardEffect_Bin2_Pick1:int = 17;
      
      public static const CardEffect_Melee_Horn:int = 18;
      
      public static const CardEffect_Range_Horn:int = 19;
      
      public static const CardEffect_Siege_Horn:int = 20;
      
      public static const CardEffect_Siege_Scorch:int = 21;
      
      public static const CardEffect_Counter_King:int = 22;
      
      public static const CardEffect_Melee:int = 23;
      
      public static const CardEffect_Ranged:int = 24;
      
      public static const CardEffect_Siege:int = 25;
      
      public static const CardEffect_UnsummonDummy:int = 26;
      
      public static const CardEffect_Horn:int = 27;
      
      public static const CardEffect_Draw:int = 28;
      
      public static const CardEffect_Scorch:int = 29;
      
      public static const CardEffect_ClearSky:int = 30;
      
      public static const CardEffect_SummonClones:int = 31;
      
      public static const CardEffect_ImproveNeighbours:int = 32;
      
      public static const CardEffect_Nurse:int = 33;
      
      public static const CardEffect_Draw2:int = 34;
      
      public static const CardEffect_SameTypeMorale:int = 35;
      
      public static const CardEffect_AgileReposition:int = 36;
      
      public static const CardEffect_RandomRessurect:int = 37;
      
      public static const CardEffect_DoubleSpy:int = 38;
      
      public static const CardEffect_RangedScorch:int = 39;
      
      public static const CardEffect_SuicideSummon:int = 40;
      
      public static const CardEffect_Mushroom:int = 41;
      
      public static const CardEffect_Morph:int = 42;
      
      public static const CardEffect_WeatherResistant:int = 43;
      
      public static const CardEffect_GraveyardShuffle:int = 44;
       
      
      public var index:int;
      
      public var title:String;
      
      public var description:String;
      
      public var power:int;
      
      public var imageLoc:String;
      
      public var factionIdx:int;
      
      public var typeArray:uint;
      
      public var effectFlags:Array;
      
      public var summonFlags:Array;
      
      public function CardTemplate()
      {
         super();
      }
      
      public static function getFactionStringFromId(factionId:int) : String
      {
         switch(factionId)
         {
            case FactionId_Neutral:
               return "Neutral";
            case FactionId_No_Mans_Land:
               return "NoMansLand";
            case FactionId_Nilfgaard:
               return "Nilfgaard";
            case FactionId_Northern_Kingdom:
               return "NorthKingdom";
            case FactionId_Scoiatael:
               return "Scoiatael";
            case FactionId_Skellige:
               return "Skellige";
            default:
               return "None";
         }
      }
      
      public function isType(typeID:uint) : Boolean
      {
         if(typeID == CardType_None && this.typeArray != 0)
         {
            return false;
         }
         return (this.typeArray & typeID) == typeID;
      }
      
      public function getFirstEffect() : int
      {
         if(this.effectFlags == null || this.effectFlags.length == 0)
         {
            return CardEffect_None;
         }
         return this.effectFlags[0];
      }
      
      public function hasEffect(effectFlag:int) : Boolean
      {
         var i:int = 0;
         for(i = 0; i < this.effectFlags.length; i++)
         {
            if(this.effectFlags[i] == effectFlag)
            {
               return true;
            }
         }
         return false;
      }
      
      public function GetBonusValue() : Number
      {
         var i:int = 0;
         var effectBonus:Number = NaN;
         var totalBonus:Number = 0;
         var bonusDictionary:Dictionary = CardManager.getInstance().cardValues.getEffectValueDictionary();
         for(i = 0; i < this.effectFlags.length; i++)
         {
            effectBonus = Number(bonusDictionary[this.effectFlags[i]]);
            if(effectBonus)
            {
               totalBonus += effectBonus;
            }
         }
         return totalBonus;
      }
      
      public function GetDeployBonusValue() : Number
      {
         var i:int = 0;
         var effectBonus:Number = NaN;
         var totalBonus:Number = 0;
         var bonusDictionary:Dictionary = CardManager.getInstance().cardValues.getEffectValueDictionary();
         if(this.hasEffect(CardTemplate.CardEffect_Draw))
         {
            totalBonus += bonusDictionary[CardTemplate.CardEffect_Draw];
         }
         if(this.hasEffect(CardTemplate.CardEffect_Draw2))
         {
            totalBonus += bonusDictionary[CardTemplate.CardEffect_Draw2];
         }
         if(this.hasEffect(CardTemplate.CardEffect_SummonClones))
         {
            totalBonus += bonusDictionary[CardTemplate.CardEffect_SummonClones];
         }
         if(this.hasEffect(CardTemplate.CardEffect_Nurse))
         {
            totalBonus += bonusDictionary[CardTemplate.CardEffect_Draw];
         }
         return totalBonus;
      }
      
      public function getFactionString() : String
      {
         return getFactionStringFromId(this.factionIdx);
      }
      
      public function getPlacementType() : int
      {
         return this.typeArray & CardType_SeigeRangedMelee;
      }
      
      public function getTypeString() : String
      {
         if(this.isType(CardType_Row_Modifier))
         {
            if(this.hasEffect(CardEffect_Mushroom))
            {
               return "mushroom";
            }
            return "horn";
         }
         if(this.isType(CardType_Weather))
         {
            if(this.hasEffect(CardEffect_ClearSky) || this.hasEffect(CardEffect_Clear_Weather))
            {
               return "clearsky";
            }
            if(this.hasEffect(CardEffect_Melee))
            {
               return "frost";
            }
            if(this.hasEffect(CardEffect_Ranged))
            {
               if(this.hasEffect(CardEffect_Siege))
               {
                  return "storm";
               }
               return "fog";
            }
            if(this.hasEffect(CardEffect_Siege))
            {
               return "rain";
            }
         }
         else if(this.isType(CardType_Spell))
         {
            if(this.hasEffect(CardEffect_UnsummonDummy))
            {
               return "dummy";
            }
         }
         else if(this.isType(CardType_Global_Effect))
         {
            if(this.hasEffect(CardEffect_Scorch))
            {
               return "scorch";
            }
         }
         else if(this.isType(CardType_Hero))
         {
            return "Hero";
         }
         return this.getPlacementTypeString();
      }
      
      public function getPlacementTypeString() : String
      {
         if(this.isType(CardType_Creature))
         {
            if(this.isType(CardType_RangedMelee))
            {
               return "RangedMelee";
            }
            if(this.isType(CardType_Melee))
            {
               return "Melee";
            }
            if(this.isType(CardType_Ranged))
            {
               return "Ranged";
            }
            if(this.isType(CardType_Siege))
            {
               return "Siege";
            }
         }
         return "None";
      }
      
      public function getEffectsAsPlacementType() : int
      {
         var totalTypeAffected:* = int(CardType_None);
         if(this.hasEffect(CardEffect_Melee))
         {
            totalTypeAffected |= CardType_Melee;
         }
         if(this.hasEffect(CardEffect_Ranged))
         {
            totalTypeAffected |= CardType_Ranged;
         }
         if(this.hasEffect(CardEffect_Siege))
         {
            totalTypeAffected |= CardType_Siege;
         }
         return totalTypeAffected;
      }
      
      public function getEffectString() : String
      {
         if(this.isType(CardType_Creature))
         {
            if(this.hasEffect(CardEffect_SummonClones))
            {
               return "summonClones";
            }
            if(this.hasEffect(CardEffect_Nurse))
            {
               return "nurse";
            }
            if(this.hasEffect(CardEffect_Draw2))
            {
               return "spy";
            }
            if(this.hasEffect(CardEffect_SameTypeMorale))
            {
               return "stMorale";
            }
            if(this.hasEffect(CardEffect_ImproveNeighbours))
            {
               return "impNeighbours";
            }
            if(this.hasEffect(CardEffect_Horn))
            {
               return "horn";
            }
            if(this.isType(CardType_RangedMelee))
            {
               return "agile";
            }
            if(this.hasEffect(CardEffect_Scorch))
            {
               return "scorch";
            }
            if(this.hasEffect(CardEffect_Mushroom))
            {
               return "mushroom";
            }
            if(this.hasEffect(CardEffect_MeleeScorch))
            {
               return "spe_scorch";
            }
            if(this.hasEffect(CardEffect_RangedScorch))
            {
               return "spe_scorch";
            }
            if(this.hasEffect(CardEffect_Siege_Scorch))
            {
               return "spe_scorch";
            }
            if(this.hasEffect(CardEffect_Morph))
            {
               return "morph";
            }
            if(this.hasEffect(CardEffect_SuicideSummon))
            {
               return "suicide_summon";
            }
         }
         return "None";
      }
      
      public function getCreatureType() : int
      {
         return this.typeArray & CardType_SeigeRangedMelee;
      }
      
      public function get tooltipIcon() : String
      {
         if(this.isType(CardType_Row_Modifier))
         {
            if(this.hasEffect(CardEffect_Mushroom))
            {
               return "mushroom";
            }
            return "horn";
         }
         if(this.isType(CardType_Weather))
         {
            if(this.hasEffect(CardEffect_ClearSky) || this.hasEffect(CardEffect_Clear_Weather))
            {
               return "clearsky";
            }
            if(this.hasEffect(CardEffect_Melee))
            {
               return "frost";
            }
            if(this.hasEffect(CardEffect_Ranged))
            {
               if(this.hasEffect(CardEffect_Siege))
               {
                  return "storm";
               }
               return "fog";
            }
            if(this.hasEffect(CardEffect_Siege))
            {
               return "rain";
            }
         }
         else if(this.isType(CardType_Spell))
         {
            if(this.hasEffect(CardEffect_UnsummonDummy))
            {
               return "dummy";
            }
         }
         else if(this.isType(CardType_Global_Effect))
         {
            if(this.hasEffect(CardEffect_Scorch))
            {
               return "scorch";
            }
         }
         else if(this.isType(CardType_Creature))
         {
            if(this.hasEffect(CardEffect_SummonClones))
            {
               return "summonClones";
            }
            if(this.hasEffect(CardEffect_Nurse))
            {
               return "nurse";
            }
            if(this.hasEffect(CardEffect_Draw2))
            {
               return "spy";
            }
            if(this.hasEffect(CardEffect_SameTypeMorale))
            {
               return "stMorale";
            }
            if(this.hasEffect(CardEffect_ImproveNeighbours))
            {
               return "impNeighbours";
            }
            if(this.hasEffect(CardEffect_Horn))
            {
               return "horn";
            }
            if(this.isType(CardType_RangedMelee))
            {
               return "agile";
            }
            if(this.hasEffect(CardEffect_MeleeScorch))
            {
               return "spe_scorch";
            }
            if(this.hasEffect(CardEffect_RangedScorch))
            {
               return "spe_scorch";
            }
            if(this.hasEffect(CardEffect_Siege_Scorch))
            {
               return "spe_scorch";
            }
            if(this.hasEffect(CardEffect_Mushroom))
            {
               return "mushroom";
            }
            if(this.hasEffect(CardEffect_Morph))
            {
               return "morph";
            }
            if(this.hasEffect(CardEffect_Scorch))
            {
               return "scorch";
            }
            if(this.hasEffect(CardEffect_SuicideSummon))
            {
               return "suicide_summon";
            }
         }
         return "None";
      }
      
      public function get tooltipString() : String
      {
         if(this.isType(CardType_Row_Modifier))
         {
            if(this.hasEffect(CardEffect_Mushroom))
            {
               return "gwint_card_tooltip_mushroom";
            }
            return "gwint_card_tooltip_horn";
         }
         if(this.isType(CardType_Weather))
         {
            if(this.hasEffect(CardEffect_ClearSky) || this.hasEffect(CardEffect_Clear_Weather))
            {
               return "gwint_card_tooltip_clearsky";
            }
            if(this.hasEffect(CardEffect_Melee))
            {
               return "gwint_card_tooltip_frost";
            }
            if(this.hasEffect(CardEffect_Ranged))
            {
               if(this.hasEffect(CardEffect_Siege))
               {
                  return "gwint_card_tooltip_skel_rain";
               }
               return "gwint_card_tooltip_fog";
            }
            if(this.hasEffect(CardEffect_Siege))
            {
               return "gwint_card_tooltip_rain";
            }
         }
         else if(this.isType(CardType_Spell))
         {
            if(this.hasEffect(CardEffect_UnsummonDummy))
            {
               return "gwint_card_tooltip_dummy";
            }
         }
         else if(this.isType(CardType_Global_Effect))
         {
            if(this.hasEffect(CardEffect_Scorch))
            {
               return "gwint_card_tooltip_scorch";
            }
         }
         else if(this.isType(CardType_Creature))
         {
            if(this.hasEffect(CardEffect_SummonClones))
            {
               if(this.index == 502)
               {
                  return "gwint_card_tooltip_summon_sm";
               }
               if(this.index == 26 || this.index == 27)
               {
                  return "gwint_card_tooltip_summon_roach";
               }
               return "gwint_card_tooltip_summon_clones";
            }
            if(this.hasEffect(CardEffect_SuicideSummon))
            {
               return "gwint_card_tooltip_suicide_summon";
            }
            if(this.hasEffect(CardEffect_Nurse))
            {
               return "gwint_card_tooltip_nurse";
            }
            if(this.hasEffect(CardEffect_Draw2))
            {
               return "gwint_card_tooltip_spy";
            }
            if(this.hasEffect(CardEffect_SameTypeMorale))
            {
               return "gwint_card_tooltip_same_type_morale";
            }
            if(this.hasEffect(CardEffect_ImproveNeighbours))
            {
               return "gwint_card_tooltip_improve_neightbours";
            }
            if(this.hasEffect(CardEffect_Horn))
            {
               return "gwint_card_tooltip_horn";
            }
            if(this.isType(CardType_RangedMelee))
            {
               return "gwint_card_tooltip_agile";
            }
            if(this.hasEffect(CardEffect_MeleeScorch))
            {
               return "gwint_card_villen_melee_scorch";
            }
            if(this.hasEffect(CardEffect_RangedScorch))
            {
               return "gwint_card_ranged_scorch";
            }
            if(this.hasEffect(CardEffect_Siege_Scorch))
            {
               return "gwint_card_siege_scorch";
            }
            if(this.hasEffect(CardEffect_Scorch))
            {
               return "gwint_card_tooltip_scorch";
            }
            if(this.hasEffect(CardEffect_Mushroom))
            {
               return "gwint_card_tooltip_mushroom";
            }
            if(this.hasEffect(CardEffect_Morph))
            {
               return "gwint_card_tooltip_morph";
            }
            if(this.isType(CardType_Hero))
            {
               return "gwint_card_tooltip_hero";
            }
         }
         else if(this.isType(CardType_None))
         {
            switch(this.getFirstEffect())
            {
               case CardTemplate.CardEffect_Clear_Weather:
                  return "gwint_card_tooltip_ldr_clear_weather";
               case CardTemplate.CardEffect_Pick_Fog:
                  return "gwint_card_tooltip_ldr_pick_fog";
               case CardTemplate.CardEffect_Siege_Horn:
                  return "gwint_card_tooltip_ldr_siege_horn";
               case CardTemplate.CardEffect_Siege_Scorch:
                  return "gwint_card_tooltip_ldr_siege_scorch";
               case CardTemplate.CardEffect_Pick_Frost:
                  return "gwint_card_tooltip_ldr_pick_frost";
               case CardTemplate.CardEffect_Range_Horn:
                  return "gwint_card_tooltip_ldr_range_horn";
               case CardTemplate.CardEffect_11th_card:
                  return "gwint_card_tooltip_ldr_eleventh_card";
               case CardTemplate.CardEffect_MeleeScorch:
                  return "gwint_card_tooltip_ldr_melee_scorch";
               case CardTemplate.CardEffect_Pick_Rain:
                  return "gwint_card_tooltip_ldr_pick_rain";
               case CardTemplate.CardEffect_View_3_Enemy:
                  return "gwint_card_tooltip_ldr_view_enemy";
               case CardTemplate.CardEffect_Resurect_Enemy:
                  return "gwint_card_tooltip_ldr_resurect_enemy";
               case CardTemplate.CardEffect_Counter_King:
                  return "gwint_card_tooltip_ldr_counter_king";
               case CardTemplate.CardEffect_Bin2_Pick1:
                  return "gwint_card_tooltip_ldr_bin_pick";
               case CardTemplate.CardEffect_Pick_Weather:
                  return "gwint_card_tooltip_ldr_pick_weather";
               case CardTemplate.CardEffect_Resurect:
                  return "gwint_card_tooltip_ldr_resurect";
               case CardTemplate.CardEffect_Melee_Horn:
                  return "gwint_card_tooltip_ldr_melee_horn";
               case CardTemplate.CardEffect_AgileReposition:
                  return "gwint_card_tooltip_ldr_agile_reposition";
               case CardTemplate.CardEffect_RandomRessurect:
                  return "gwint_card_tooltip_ldr_random_ressurect";
               case CardTemplate.CardEffect_DoubleSpy:
                  return "gwint_card_tooltip_ldr_double_spy";
               case CardTemplate.CardEffect_RangedScorch:
                  return "gwint_card_tooltip_ldr_ranged_scorch";
               case CardTemplate.CardEffect_WeatherResistant:
                  return "gwint_card_tooltip_ldr_weather_resistant";
               case CardTemplate.CardEffect_GraveyardShuffle:
                  return "gwint_card_tooltip_ldr_graveyard_shuffle";
            }
         }
         return "";
      }
      
      public function toString() : String
      {
         return "[Gwint CardTemplate] index:" + this.index + ", title:" + this.title + ", imageLoc:" + this.imageLoc + ", power:" + this.power + ", facionIdx:" + this.factionIdx + ", type:" + this.typeArray + ", effectString: " + this.getEffectString();
      }
   }
}
