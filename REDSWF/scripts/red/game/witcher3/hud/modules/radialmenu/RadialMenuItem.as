package red.game.witcher3.hud.modules.radialmenu
{
   import com.gskinner.motion.GTween;
   import com.gskinner.motion.GTweener;
   import com.gskinner.motion.easing.Exponential;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.filters.BitmapFilterQuality;
   import flash.filters.ColorMatrixFilter;
   import flash.filters.GlowFilter;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   import flash.utils.Timer;
   import red.core.CoreComponent;
   import red.game.witcher3.controls.W3UILoader;
   import red.game.witcher3.utils.CommonUtils;
   import scaleform.clik.core.UIComponent;
   
   public class RadialMenuItem extends UIComponent
   {
      
      protected static const OVER_GLOW_COLOR:Number = 11508592;
      
      protected static const OVER_GLOW_BLUR:Number = 20;
      
      protected static const OVER_GLOW_STRENGHT:Number = 0.75;
      
      protected static const OVER_GLOW_ALPHA:Number = 0.6;
       
      
      public var mcIcon:MovieClip;
      
      protected var _iconPath:String = "";
      
      protected var _itemName:String = "";
      
      protected var _itemCategory:String = "";
      
      protected var _itemDescription:String = "";
      
      protected var _radialName:String = "";
      
      protected var _isDesaturated:Boolean = false;
      
      protected var bItemField:Boolean = false;
      
      public var tfSignLabel:TextField;
      
      public var tfItemName:TextField;
      
      public var mcSelection:MovieClip;
      
      public var mcItemQuality:MovieClip;
      
      protected var _isSelected:Boolean;
      
      protected var _glowFilter:GlowFilter;
      
      internal var otherTextFormat:TextFormat;
      
      internal var lTextFormat:TextFormat;
      
      protected const DESATURATION_DELAY:Number = 1;
      
      private var _desaturationDelayTimer:Timer;
      
      public function RadialMenuItem()
      {
         super();
         if(this.mcSelection)
         {
            this.mcSelection.visible = false;
         }
         this._isSelected = false;
      }
      
      override protected function configUI() : void
      {
         super.configUI();
      }
      
      private function updateIcon() : void
      {
         if(this.mcIcon)
         {
            this.mcIcon.gotoAndStop(this._radialName);
         }
      }
      
      public function setRadialItemName(param1:String) : void
      {
         this._radialName = param1;
         this.updateIcon();
         this.setSignLabel();
      }
      
      private function setSignLabel() : void
      {
         var _loc1_:* = 0;
         var _loc2_:* = -14.5;
         var _loc3_:* = -26;
         var _loc4_:* = -6.85;
         var _loc5_:* = 11.35;
         this.lTextFormat = new TextFormat("$NormalFont",21);
         this.otherTextFormat = new TextFormat("$NormalFont",17);
         this.lTextFormat.align = TextFormatAlign.CENTER;
         this.lTextFormat.font = "$NormalFont";
         this.otherTextFormat.align = TextFormatAlign.CENTER;
         this.otherTextFormat.font = "$NormalFont";
         this.otherTextFormat.color = 16777215;
         if(this.tfSignLabel)
         {
            this.tfSignLabel.htmlText = "[[" + this._radialName + "]]";
            this.tfSignLabel.htmlText = CommonUtils.toUpperCaseSafe(this.tfSignLabel.htmlText);
            if(CoreComponent._gameLanguage == "JP" || CoreComponent._gameLanguage == "KR" || CoreComponent._gameLanguage == "ZH" || CoreComponent._gameLanguage == "AR")
            {
               this.mcIcon.y = _loc3_;
               this.mcIcon.scaleX = this.mcIcon.scaleY = 0.7;
               this.tfSignLabel.y = _loc4_;
               this.tfSignLabel.embedFonts = true;
               this.tfSignLabel.defaultTextFormat = this.otherTextFormat;
               this.tfSignLabel.setTextFormat(this.otherTextFormat);
            }
            else
            {
               this.mcIcon.y = _loc2_;
               this.mcIcon.scaleX = this.mcIcon.scaleY = 1;
               this.tfSignLabel.y = _loc5_;
               this.tfSignLabel.embedFonts = true;
               this.tfSignLabel.defaultTextFormat = this.lTextFormat;
               this.tfSignLabel.setTextFormat(this.lTextFormat);
            }
         }
      }
      
      public function getIsSelected() : Boolean
      {
         return this._isSelected;
      }
      
      public function setItemName() : void
      {
         if(this.tfItemName)
         {
            this.tfItemName.htmlText = this._itemName;
         }
      }
      
      public function getRadialItemName() : String
      {
         return this._radialName;
      }
      
      public function SetSelected() : void
      {
         if(this.mcSelection)
         {
            GTweener.removeTweens(this.mcSelection);
            GTweener.to(this.mcSelection,0.5,{
               "scaleX":1,
               "scaleY":1,
               "alpha":1
            },{"ease":Exponential.easeOut});
            this.mcSelection.visible = true;
         }
         this._isSelected = true;
      }
      
      public function SetDeselected() : void
      {
         if(this.mcSelection)
         {
            GTweener.removeTweens(this.mcSelection);
            GTweener.to(this.mcSelection,0.5,{
               "scaleX":1.1,
               "scaleY":1.1,
               "alpha":0
            },{"ease":Exponential.easeOut});
         }
         this._isSelected = false;
      }
      
      private function handleHidden(param1:GTween) : void
      {
         this.mcSelection.visible = false;
         this.mcSelection.alpha = 1;
         if(this.mcSelection)
         {
            this.mcSelection.scaleX = this.mcSelection.scaleY = 1.1;
         }
      }
      
      public function SetDesatureted(param1:Boolean) : void
      {
         this._isDesaturated = param1;
         this.removeDesaturationTimer();
         if(param1)
         {
            this._desaturationDelayTimer = new Timer(this.DESATURATION_DELAY);
            this._desaturationDelayTimer.addEventListener(TimerEvent.TIMER,this.applyDesaturationFilter,false,0,true);
            this._desaturationDelayTimer.start();
         }
         else
         {
            filters = [];
         }
      }
      
      protected function removeDesaturationTimer() : void
      {
         if(this._desaturationDelayTimer)
         {
            this._desaturationDelayTimer.removeEventListener(TimerEvent.TIMER,this.applyDesaturationFilter,false);
            this._desaturationDelayTimer.stop();
            this._desaturationDelayTimer = null;
         }
      }
      
      protected function applyDesaturationFilter(param1:Event = null) : void
      {
         var _loc2_:ColorMatrixFilter = CommonUtils.getDesaturateFilter();
         filters = [_loc2_];
         this.removeDesaturationTimer();
      }
      
      public function IsDesatureted() : Boolean
      {
         return this._isDesaturated;
      }
      
      public function SetIcon(param1:String, param2:String, param3:String, param4:String, param5:int) : void
      {
         var _loc6_:W3UILoader = null;
         var _loc7_:Array = null;
         if(this.mcIcon)
         {
            _loc7_ = [];
            this._glowFilter = new GlowFilter(OVER_GLOW_COLOR,OVER_GLOW_ALPHA,OVER_GLOW_BLUR,OVER_GLOW_BLUR,OVER_GLOW_STRENGHT,BitmapFilterQuality.HIGH);
            _loc7_.push(this._glowFilter);
            if(param3 != "crossbow")
            {
               this.mcIcon.gotoAndStop("iconLoader");
               _loc6_ = this.mcIcon.mcLoader;
            }
            else
            {
               this.mcIcon.gotoAndStop("iconLoaderLarge");
               _loc6_ = this.mcIcon.mcLoaderLarge;
            }
            if(this.mcItemQuality)
            {
               this.mcItemQuality.gotoAndStop(param5);
            }
            _loc6_.fallbackIconPath = "img://" + this.GetDefaultFallbackIconFromType(param3);
            if(param1 != "")
            {
               _loc6_.source = "img://" + param1;
            }
            else
            {
               _loc6_.source = "";
            }
            _loc6_.filters = _loc7_;
         }
         this._iconPath = param1;
         this._itemName = param2;
         this._itemCategory = param3;
         this._itemDescription = param4;
         this.bItemField = true;
         this.setItemName();
      }
      
      public function GetIconPath() : String
      {
         return this._iconPath;
      }
      
      public function GetItemName() : String
      {
         if(!this.IsItemField())
         {
            return this._radialName;
         }
         return this._itemName;
      }
      
      public function GetItemCategory() : String
      {
         return this._itemCategory;
      }
      
      public function GetItemDescription() : String
      {
         if(this.IsItemField())
         {
            return this._itemDescription;
         }
         return "[[" + this._radialName + "_description]]";
      }
      
      public function IsItemField() : Boolean
      {
         return this.bItemField;
      }
      
      public function SetAsItemField(param1:Boolean) : void
      {
         this.bItemField = param1;
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
               return "";
         }
      }
   }
}
