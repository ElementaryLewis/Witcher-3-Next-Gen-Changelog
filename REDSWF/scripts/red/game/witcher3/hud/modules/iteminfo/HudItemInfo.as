package red.game.witcher3.hud.modules.iteminfo
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   import red.game.witcher3.constants.CommonConstants;
   import red.game.witcher3.controls.InputFeedbackButton;
   import red.game.witcher3.controls.W3UILoader;
   import scaleform.clik.core.UIComponent;
   import scaleform.clik.managers.InputDelegate;
   
   public class HudItemInfo extends UIComponent
   {
       
      
      public var mcIconLoader:W3UILoader;
      
      public var textField:TextField;
      
      public var tfAmmo:TextField;
      
      public var mcButton:InputFeedbackButton;
      
      public var mcError:MovieClip;
      
      public var mcTextBackground:MovieClip;
      
      public var mcDefaultIcon:MovieClip;
      
      private var _IconName:String;
      
      private var _ItemCategory:String;
      
      public var defaultIconName:String = "potion1";
      
      private var _initialBackgroundWidth:Number;
      
      private var _minimalSize:Number = 0;
      
      protected var _showButtonHint:Boolean = false;
      
      public function HudItemInfo()
      {
         super();
         if(this.mcButton)
         {
            this.mcButton.visible = false;
            this.mcButton.clickable = false;
         }
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         if(this.mcTextBackground)
         {
            this._initialBackgroundWidth = this.mcTextBackground.width;
         }
         if(this.mcDefaultIcon)
         {
            this.mcDefaultIcon.gotoAndStop(this.defaultIconName);
         }
         this.ItemAmmo = "";
      }
      
      public function get minimalSize() : Number
      {
         return this._minimalSize;
      }
      
      public function set minimalSize(param1:Number) : void
      {
         this._minimalSize = param1;
      }
      
      public function get showButtonHint() : Boolean
      {
         return this._showButtonHint;
      }
      
      public function set showButtonHint(param1:Boolean) : void
      {
         this._showButtonHint = param1;
         this.mcButton.visible = this._showButtonHint;
      }
      
      override public function toString() : String
      {
         return this.name;
      }
      
      private function updateIcon() : void
      {
         if(this._IconName && this._IconName != "" && this._IconName != "icons/items/None_64x64.dds")
         {
            if(this.mcIconLoader)
            {
               this.mcIconLoader.source = "img://" + this._IconName;
            }
            if(this.mcTextBackground)
            {
               this.mcTextBackground.visible = true;
            }
            if(this.mcDefaultIcon)
            {
               this.mcDefaultIcon.visible = false;
            }
         }
         else
         {
            if(this.mcIconLoader)
            {
               this.mcIconLoader.source = "";
            }
            if(this.mcTextBackground)
            {
               this.mcTextBackground.visible = false;
            }
            if(this.mcDefaultIcon)
            {
               this.mcDefaultIcon.visible = true;
            }
         }
      }
      
      public function get IconName() : String
      {
         return this._IconName;
      }
      
      public function set IconName(param1:String) : void
      {
         if(this._IconName != param1)
         {
            this._IconName = param1;
            this.updateIcon();
         }
      }
      
      public function set ItemName(param1:String) : void
      {
         this.textField.htmlText = param1;
         if(this.mcTextBackground)
         {
            this.mcTextBackground.width = this.mcTextBackground.x - this.textField.x + this.textField.textWidth + CommonConstants.SAFE_TEXT_PADDING;
         }
      }
      
      public function set ItemAmmo(param1:String) : void
      {
         this.tfAmmo.htmlText = param1;
      }
      
      public function set ItemCategory(param1:String) : void
      {
         if(this._ItemCategory != param1)
         {
            this._ItemCategory = param1;
            this.mcIconLoader.fallbackIconPath = this.GetDefaultFallbackIconFromType(this._ItemCategory);
         }
      }
      
      public function setItemButtons(param1:int, param2:*) : void
      {
         var _loc3_:InputDelegate = null;
         var _loc4_:String = null;
         _loc3_ = InputDelegate.getInstance();
         switch(param1)
         {
            case -10:
               _loc4_ = "double_dpad_up";
               break;
            case 0:
               this.mcButton.visible = false;
               return;
            default:
               _loc4_ = _loc3_.inputToNav("key",param1);
         }
         this.mcButton.visible = this.showButtonHint;
         this.mcButton.clickable = false;
         this.mcButton.setDataFromStage(_loc4_,param2);
         this.mcButton.validateNow();
         this.mcButton.x = this.mcIconLoader.x - this.mcButton.getViewWidth();
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
