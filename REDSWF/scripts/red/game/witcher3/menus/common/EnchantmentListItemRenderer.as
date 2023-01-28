package red.game.witcher3.menus.common
{
   import flash.display.MovieClip;
   import flash.display.Stage;
   import flash.events.Event;
   import red.core.CoreComponent;
   import red.game.witcher3.constants.CommonConstants;
   
   public class EnchantmentListItemRenderer extends IconItemRenderer
   {
      
      public static const PINNED_EVENT:String = "PinChangedEvent";
      
      public static var DISABLE_ACTION:Boolean = false;
      
      public static var APPLIED_ENCHANTMENT:uint = 0;
      
      protected static var _currentPinnedTag:uint;
       
      
      private const STATIC_HEIGHT:Number = 87;
      
      private const CENTER_LINE:Number = 44;
      
      public var mcEnchantmenTypeIcon:MovieClip;
      
      public var mcPinnedOverlay:MovieClip;
      
      public function EnchantmentListItemRenderer()
      {
         super();
         visible = false;
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
      
      protected function onPinnedRecipeChanged(param1:Event) : void
      {
         this.updatePinnedIcon();
      }
      
      public function updatePinnedIcon() : void
      {
         if(this.mcPinnedOverlay)
         {
            if(Boolean(data) && data.name == EnchantmentListItemRenderer._currentPinnedTag)
            {
               this.mcPinnedOverlay.visible = true;
            }
            else
            {
               this.mcPinnedOverlay.visible = false;
            }
         }
      }
      
      override public function setData(param1:Object) : void
      {
         var timelineOffset:int = 0;
         var data:Object = param1;
         super.setData(data);
         if(!data)
         {
            return;
         }
         this.updatePinnedIcon();
         visible = true;
         try
         {
            timelineOffset = data.name == APPLIED_ENCHANTMENT ? 3 : 0;
            this.mcEnchantmenTypeIcon.gotoAndStop(data.level + timelineOffset);
            this.mcEnchantmenTypeIcon.visible = true;
         }
         catch(er:Error)
         {
            trace("GFX Enchantment level is undefined! <",data.level,"> ",er.getStackTrace());
            mcEnchantmenTypeIcon.visible = false;
         }
      }
      
      override protected function updateText() : void
      {
         var _loc1_:* = null;
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         super.updateText();
         if(data)
         {
            _loc1_ = String(data.localizedName);
            _loc2_ = 0;
            if(data.name == APPLIED_ENCHANTMENT)
            {
               _loc3_ = 15105547;
            }
            else if(!(data.canApply && !data.notEnoughMoney && !data.notEnoughSlots && !DISABLE_ACTION))
            {
               _loc3_ = 13173250;
            }
            else
            {
               _loc3_ = 3066368;
            }
            if(CoreComponent.isArabicAligmentMode)
            {
               _loc1_ = "<p align=\"right\">" + _loc1_ + "</p>";
            }
            textField.htmlText = _loc1_;
            textField.textColor = _loc3_;
            _loc2_ = textField.textHeight;
            textField.height = _loc2_ + CommonConstants.SAFE_TEXT_PADDING;
            textField.y = this.CENTER_LINE - _loc2_ / 2;
         }
      }
      
      override public function toString() : String
      {
         return "[W3 EnchantmentListItemRenderer]";
      }
      
      override public function get height() : Number
      {
         return this.STATIC_HEIGHT;
      }
   }
}
