package red.game.witcher3.hud.modules.radialmenu
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   import red.core.events.GameEvent;
   import red.game.witcher3.utils.CommonUtils;
   import scaleform.clik.core.UIComponent;
   
   public class RadialMenuSelectedInfo extends UIComponent
   {
       
      
      public var textField:TextField;
      
      public var tfFieldDescription:TextField;
      
      public var tfDescription:TextField;
      
      private var _IconName:String;
      
      public var mcIcon:MovieClip;
      
      private var _iconPath:String = "";
      
      private var _itemName:String = "";
      
      private var bItemField:Boolean = false;
      
      public function RadialMenuSelectedInfo()
      {
         super();
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         dispatchEvent(new GameEvent(GameEvent.REGISTER,this.name + ".decription",[this.SetItemDescription]));
      }
      
      override public function toString() : String
      {
         return this.name;
      }
      
      public function SetIcon(param1:String, param2:String, param3:String) : void
      {
         if(this.mcIcon)
         {
            if(this.bItemField)
            {
               this.mcIcon.gotoAndStop("Slot1");
               this.mcIcon.mcLoader.fallbackIconPath = "img://" + this.GetDefaultFallbackIconFromType(param3);
               this.mcIcon.mcLoader.source = "img://" + param1;
               this.tfFieldDescription.htmlText = "[[panel_hud_radaialmenu_equipped]]";
               this.tfFieldDescription.htmlText = CommonUtils.toUpperCaseSafe(this.tfFieldDescription.htmlText);
            }
            else
            {
               this.mcIcon.gotoAndStop(param1);
               this.tfFieldDescription.htmlText = "[[panel_hud_radaialmenu_activesign]]";
               this.tfFieldDescription.htmlText = CommonUtils.toUpperCaseSafe(this.tfFieldDescription.htmlText);
            }
            this._iconPath = param1;
            this.ItemName = param2;
         }
      }
      
      public function set IconName(param1:String) : void
      {
         if(this._IconName != param1)
         {
            this._IconName = param1;
         }
      }
      
      public function set ItemName(param1:String) : void
      {
         this.textField.htmlText = CommonUtils.toUpperCaseSafe(param1);
      }
      
      public function SetItemDescription(param1:String) : void
      {
         this.tfDescription.htmlText = param1;
      }
      
      public function IsItemField() : Boolean
      {
         return this.bItemField;
      }
      
      public function SetAsItemField(param1:Boolean) : void
      {
         this.bItemField = param1;
         if(param1)
         {
         }
      }
      
      protected function GetDefaultFallbackIconFromType(param1:String) : String
      {
         switch(param1)
         {
            case "additional_alchemy_ingredient":
               return "icons/inventory/Tw2_rune_earth.png";
            case "alchemy_recipe":
               return "icons/inventory/candlemakersbill_64x64.dds";
            case "armor":
               return "icons/inventory/armor-01.png";
            case "book":
               return "icons/inventory/bookofdragons_64x64.dds";
            case "boots":
               return "icons/inventory/boots-01.png";
            case "crafting_ingredient":
               return "icons/inventory/Tw2_rune_moon.png";
            case "crafting_schematic":
               return "icons/inventory/filippasnotes_64x64.dds";
            case "edibles":
               return "icons/inventory/Tw2_ingredient_cortinarius.png";
            case "gloves":
               return "icons/inventory/gauntlet-01.png";
            case "herb":
               return "icons/inventory/Tw2_ingredient_balisse.png";
            case "junk":
            case "misc":
               return "icons/inventory/Tw2_trap_nekker_small.png";
            case "key":
               return "icons/inventory/baltimoreskey_64x64.dds";
            case "oil":
               return "icons/inventory/Tw2_oil_Brown.png";
            case "pants":
               return "icons/inventory/trousers-01.png";
            case "petard":
               return "icons/inventory/bomb-01.png";
            case "potion":
               return "icons/inventory/gauntlet-01.png";
            case "trophy":
               return "icons/inventory/trophy-01.png";
            case "steelsword":
               return "icons/inventory/sword-01-B.png";
            case "silversword":
               return "icons/inventory/sword-02-B.png";
            case "lure":
               return "icons/inventory/Tw2_lure_trinket.png";
            case "trap":
               return "icons/inventory/Tw2_trap_talgarwinter_small.png";
            case "bolt":
            case "crossbow":
               return "icons/inventory/crabspidershell_64x64.dds";
            default:
               return "icons/inventory/raspberryjuice_64x64.dds";
         }
      }
   }
}
