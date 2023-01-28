package red.game.witcher3.menus.common
{
   import flash.display.MovieClip;
   import flash.display.Stage;
   import flash.events.Event;
   import flash.text.TextField;
   import red.core.CoreComponent;
   import red.game.witcher3.events.GridEvent;
   import scaleform.clik.events.InputEvent;
   
   public class RecipeIconItemRenderer extends IconItemRenderer
   {
      
      public static const NoException:int = 0;
      
      public static const PINNED_EVENT:String = "PinChangedEvent";
      
      public static const MissingIngredient:int = 1;
      
      public static const NotEnoughIngredients:int = 2;
      
      public static const NoRecipe:int = 3;
      
      public static const CannotCookMore:int = 4;
      
      public static const CookNotAllowed:int = 5;
      
      public static const ECE_TooLowCraftsmanLevel:int = 1;
      
      public static const ECE_MissingIngredient:int = 2;
      
      public static const ECE_TooFewIngredients:int = 3;
      
      public static const ECE_WrongCraftsmanType:int = 4;
      
      public static const ECE_NotEnoughMoney:int = 5;
      
      public static const ECE_UnknownSchematic:int = 6;
      
      public static const ECE_CookNotAllowed:int = 7;
      
      protected static var _currentPinnedTag:uint;
       
      
      public var mcCraftingAnimation:MovieClip;
      
      public var mcPinnedOverlay:MovieClip;
      
      public var mcItemQuality:MovieClip;
      
      public var txtGuide:MovieClip;
      
      public var tfItemLevel:TextField;
      
      public function RecipeIconItemRenderer()
      {
         super();
         skipTextCentering = false;
         canBePressed = false;
         if(this.mcPinnedOverlay)
         {
            this.mcPinnedOverlay.visible = false;
         }
      }
      
      public static function setCurrentPinnedTag(param1:Stage, param2:uint) : void
      {
         _currentPinnedTag = param2;
         param1.dispatchEvent(new Event(PINNED_EVENT));
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         stage.addEventListener(PINNED_EVENT,this.onPinnedRecipeChanged,false,0,true);
      }
      
      override public function setData(param1:Object) : void
      {
         var _loc2_:String = null;
         super.setData(param1);
         if(selected)
         {
            this.fireShowTooltipEvent();
         }
         if(tfSecondLine)
         {
            if(param1.cantCookReason)
            {
               tfSecondLine.htmlText = param1.cantCookReason;
               if(CoreComponent.isArabicAligmentMode)
               {
                  tfSecondLine.htmlText = "<p align=\"right\">" + param1.cantCookReason + "</p>";
               }
            }
            else if(param1.canCookStatus == NoException)
            {
               if(CoreComponent.isArabicAligmentMode)
               {
                  tfSecondLine.text = "[[gui_panel_filter_has_ingredients]]";
                  _loc2_ = tfSecondLine.text;
                  tfSecondLine.htmlText = "<p align=\"right\">" + _loc2_ + "</p>";
               }
               else
               {
                  tfSecondLine.htmlText = "[[gui_panel_filter_has_ingredients]]";
               }
            }
         }
         if(this.mcItemQuality)
         {
            this.mcItemQuality.gotoAndStop(param1.rarity);
         }
         if(this.tfItemLevel)
         {
            if(Boolean(param1) && Boolean(param1.itemLevel))
            {
               this.tfItemLevel.visible = true;
               this.tfItemLevel.htmlText = param1.itemLevel;
            }
            else
            {
               this.tfItemLevel.visible = false;
            }
         }
         this.updatePinnedIcon();
      }
      
      protected function onPinnedRecipeChanged(param1:Event) : void
      {
         this.updatePinnedIcon();
      }
      
      public function updatePinnedIcon() : void
      {
         if(this.mcPinnedOverlay)
         {
            if(Boolean(data) && data.tag == RecipeIconItemRenderer._currentPinnedTag)
            {
               this.mcPinnedOverlay.visible = true;
            }
            else
            {
               this.mcPinnedOverlay.visible = false;
            }
         }
      }
      
      override protected function updateText() : void
      {
         super.updateText();
         if(_label != null && textField != null)
         {
            if(data.isSchematic)
            {
               this.updateTextColorSchematic();
            }
            else
            {
               this.updateTextColorRecipe();
            }
         }
         if(tfSecondLine)
         {
            if(tfSecondLine.text == "" && Boolean(this.txtGuide))
            {
               textField.y = this.txtGuide.y + this.txtGuide.height / 2 - textField.textHeight / 2;
            }
            else
            {
               textField.y = 9;
            }
         }
      }
      
      protected function updateTextColorSchematic() : void
      {
         if(tfSecondLine)
         {
            if(data.canCookStatus == NoException)
            {
               tfSecondLine.textColor = 4171044;
               if(selected)
               {
               }
            }
            else if(data.canCookStatus == ECE_TooLowCraftsmanLevel || data.canCookStatus == ECE_WrongCraftsmanType || data.canCookStatus == ECE_UnknownSchematic)
            {
               tfSecondLine.textColor = 6710886;
            }
            else
            {
               tfSecondLine.textColor = 14483456;
            }
         }
      }
      
      protected function updateTextColorRecipe() : void
      {
         if(tfSecondLine)
         {
            if(data.canCookStatus == NoException)
            {
               tfSecondLine.textColor = 4171044;
            }
            else if(data.canCookStatus == CannotCookMore)
            {
               tfSecondLine.textColor = 6710886;
            }
            else
            {
               tfSecondLine.textColor = 14483456;
            }
         }
      }
      
      override public function handleEntryPress() : void
      {
      }
      
      override public function handleInput(param1:InputEvent) : void
      {
      }
      
      public function fireShowTooltipEvent() : void
      {
         var _loc1_:GridEvent = null;
         _loc1_ = new GridEvent(GridEvent.DISPLAY_TOOLTIP,true,false,index,-1,-1,null,null);
         _loc1_.tooltipContentRef = "ItemTooltipRef";
         _loc1_.tooltipDataSource = "OnShowCraftedItemTooltip";
         _loc1_.tooltipCustomArgs = [data.tag];
         dispatchEvent(_loc1_);
      }
   }
}
