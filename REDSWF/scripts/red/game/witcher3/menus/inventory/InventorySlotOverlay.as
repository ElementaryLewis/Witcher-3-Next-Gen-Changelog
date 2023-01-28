package red.game.witcher3.menus.inventory
{
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.geom.Rectangle;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.utils.getDefinitionByName;
   import scaleform.clik.core.UIComponent;
   
   public class InventorySlotOverlay extends UIComponent
   {
      
      private static const SOCKET_PADDING:Number = 3;
      
      private static const SOCKET_TOP_OFFSET:Number = 8;
      
      private static const SOCKET_REF:String = "SlotSocketRef";
       
      
      public var mcDyePreviewColor:MovieClip;
      
      public var mcDyeColor:MovieClip;
      
      public var mcPreviewIcon:MovieClip;
      
      public var mcEnchantmentIcon:MovieClip;
      
      public var mcQuestIndicator:MovieClip;
      
      public var mcIconRepair:MovieClip;
      
      public var mcIconEquipped:MovieClip;
      
      public var mcIconNewItem:MovieClip;
      
      public var mcOilIndicator:Sprite;
      
      public var mcCollapsedTooltipIcon:MovieClip;
      
      public var tfQuantity:TextField;
      
      protected var _oilApplied:Boolean = false;
      
      protected var _equipped:Boolean = false;
      
      protected var _newItem:Boolean = false;
      
      protected var _needRepair:Boolean = false;
      
      protected var _dyePreview:Boolean = false;
      
      protected var _dyeColor:String = "";
      
      protected var _gridSize:int = 1;
      
      protected var _defaultQuantityTxtColor:uint;
      
      protected var _socketsContainer:Sprite;
      
      protected var _targetRect:Rectangle;
      
      private var _slotsItems:Vector.<MovieClip>;
      
      public function InventorySlotOverlay()
      {
         this._slotsItems = new Vector.<MovieClip>();
         super();
         if(this.tfQuantity)
         {
            this.tfQuantity.autoSize = TextFieldAutoSize.RIGHT;
         }
         if(this.mcOilIndicator)
         {
            this.mcOilIndicator.visible = false;
         }
         if(this.mcIconNewItem)
         {
            this.mcIconNewItem.visible = false;
            this.mcIconNewItem.mouseEnabled = false;
         }
         if(this.mcIconEquipped)
         {
            this.mcIconEquipped.mouseChildren = false;
         }
         if(this.mcQuestIndicator)
         {
            this.mcQuestIndicator.visible = false;
         }
         if(this.mcEnchantmentIcon)
         {
            this.mcEnchantmentIcon.visible = false;
         }
         if(this.mcIconRepair)
         {
            this.mcIconRepair.visible = false;
         }
         if(this.mcPreviewIcon)
         {
            this.mcPreviewIcon.visible = false;
         }
         if(this.mcDyeColor)
         {
            this.mcDyeColor.visible = false;
         }
         if(this.mcDyePreviewColor)
         {
            this.mcDyePreviewColor.visible = false;
         }
         if(this.mcCollapsedTooltipIcon)
         {
            this.mcCollapsedTooltipIcon.visible = false;
         }
         this._socketsContainer = new Sprite();
         addChild(this._socketsContainer);
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         if(this.tfQuantity)
         {
            this._defaultQuantityTxtColor = this.tfQuantity.textColor;
         }
      }
      
      public function SetDyePreview(param1:Boolean) : void
      {
         this._dyePreview = param1;
      }
      
      public function SetAppliedDyeColor(param1:String) : void
      {
         this._dyeColor = param1;
      }
      
      public function SetEquipped(param1:Boolean) : void
      {
         this._equipped = param1;
      }
      
      public function GetEquipped() : Boolean
      {
         return this._equipped;
      }
      
      public function SetIsNew(param1:Boolean) : void
      {
         this._newItem = param1;
      }
      
      public function SetNeedRepair(param1:Boolean) : void
      {
         this._needRepair = param1;
      }
      
      public function SetQuantity(param1:String) : void
      {
         if(this.tfQuantity)
         {
            if(param1 == "0" || param1 == "1" || param1 == "")
            {
               this.tfQuantity.text = "";
            }
            else
            {
               this.tfQuantity.htmlText = param1;
            }
         }
      }
      
      public function SetIsQuestItem(param1:Boolean, param2:String) : void
      {
         if(this.mcQuestIndicator)
         {
            if(param1 == true)
            {
               this.mcQuestIndicator.visible = true;
               this.mcQuestIndicator.gotoAndStop(param2);
            }
            else
            {
               this.mcQuestIndicator.visible = false;
            }
         }
      }
      
      public function SetQuantityCraftingColor(param1:Boolean) : void
      {
         if(this.tfQuantity)
         {
            if(!param1)
            {
               this.tfQuantity.textColor = 15471122;
            }
            else
            {
               this.tfQuantity.textColor = 5755704;
            }
         }
      }
      
      public function SetEnchantment(param1:Boolean, param2:int) : void
      {
         if(this._socketsContainer)
         {
            if(!param1 && param2 > 0)
            {
               this._socketsContainer.visible = true;
            }
            else
            {
               this._socketsContainer.visible = false;
            }
         }
         if(this.mcEnchantmentIcon)
         {
            this.mcEnchantmentIcon.visible = param1;
         }
      }
      
      public function SetGridSize(param1:int) : void
      {
         this._gridSize = param1;
         gotoAndStop(this._gridSize);
      }
      
      public function updateIcons() : void
      {
         if(this.mcIconEquipped)
         {
            if(this.mcIconRepair.totalFrames > 1)
            {
               if(this._equipped)
               {
                  this.mcIconEquipped.gotoAndStop("equipped");
               }
               else
               {
                  this.mcIconEquipped.gotoAndStop("none");
               }
            }
            else
            {
               this.mcIconRepair.visible = this._equipped;
            }
         }
         if(this.mcIconRepair)
         {
            this.mcIconRepair.visible = this._needRepair;
         }
         if(this.mcIconNewItem)
         {
            if(this._newItem)
            {
               this.mcIconNewItem.visible = true;
            }
            else
            {
               this.mcIconNewItem.visible = false;
            }
         }
         if(this.mcDyeColor)
         {
            if(this._dyeColor)
            {
               this.mcDyeColor.gotoAndStop(this._dyeColor);
               this.mcDyeColor.visible = true;
            }
            else
            {
               this.mcDyeColor.visible = false;
            }
         }
         if(this.mcDyePreviewColor)
         {
            if(this._dyePreview)
            {
               this.mcDyePreviewColor.visible = true;
            }
            else
            {
               this.mcDyePreviewColor.visible = false;
            }
         }
         this.realignIcons();
      }
      
      public function ResetIcons() : void
      {
         this._equipped = false;
         this._newItem = false;
         this._needRepair = false;
      }
      
      public function setOilApplied(param1:Boolean) : void
      {
         this._oilApplied = param1;
         if(this.mcOilIndicator)
         {
            this.mcOilIndicator.visible = this._oilApplied;
         }
      }
      
      public function setPreviewIcon(param1:Boolean) : void
      {
         if(this.mcPreviewIcon)
         {
            this.mcPreviewIcon.visible = param1;
         }
      }
      
      public function updateSize(param1:Rectangle) : void
      {
         this._targetRect = param1;
         this.realignIcons();
      }
      
      private function realignIcons() : void
      {
         var _loc4_:Number = NaN;
         var _loc1_:* = 10;
         var _loc2_:* = 6;
         var _loc3_:* = 20;
         if(this._targetRect)
         {
            _loc4_ = 0;
            if(this.mcQuestIndicator)
            {
               this.mcQuestIndicator.x = this._targetRect.x + 8;
               this.mcQuestIndicator.y = this._targetRect.y + this._targetRect.height - this.mcQuestIndicator.height - 2;
            }
            if(this.mcCollapsedTooltipIcon)
            {
               this.mcCollapsedTooltipIcon.x = this._targetRect.x + (this._targetRect.width - this.mcCollapsedTooltipIcon.width) / 2 - 2;
               this.mcCollapsedTooltipIcon.y = this._targetRect.y + this._targetRect.height - this.mcCollapsedTooltipIcon.height - 2;
            }
            if(this.mcDyeColor)
            {
               this.mcDyeColor.y = this._targetRect.y + this._targetRect.height - this.mcCollapsedTooltipIcon.height + 5;
            }
            if(this.mcOilIndicator)
            {
               this.mcOilIndicator.x = this._targetRect.x + _loc2_;
               this.mcOilIndicator.y = this._targetRect.y + this._targetRect.height - this.mcOilIndicator.height - _loc1_;
            }
            if(Boolean(this.mcIconNewItem) && this.mcIconNewItem.visible)
            {
               this.mcIconNewItem.width = this._targetRect.width;
               this.mcIconNewItem.height = this._targetRect.height;
               this.mcIconNewItem.x = this._targetRect.width / 2;
               this.mcIconNewItem.y = this._targetRect.height / 2;
               _loc4_ = _loc3_;
            }
            if(this.mcIconRepair)
            {
               this.mcIconRepair.x = this._targetRect.x + this._targetRect.width - this.mcIconRepair.width - _loc2_;
               this.mcIconRepair.y = this._targetRect.y + _loc4_ + _loc1_;
            }
            if(this.mcEnchantmentIcon)
            {
               this.mcEnchantmentIcon.x = this._targetRect.x + _loc2_;
               this.mcEnchantmentIcon.y = this._targetRect.y + _loc2_;
            }
            if(this.mcPreviewIcon)
            {
               this.mcPreviewIcon.x = this._targetRect.x + this._targetRect.width / 2;
               this.mcPreviewIcon.y = this._targetRect.y + this._targetRect.height / 2;
            }
            if(this.tfQuantity)
            {
               this.tfQuantity.y = this._targetRect.y + this._targetRect.height - this.tfQuantity.textHeight - _loc2_;
            }
         }
      }
      
      public function updateSlots(param1:int, param2:int) : void
      {
         var _loc3_:int = 0;
         var _loc6_:MovieClip = null;
         if(isNaN(param1) || isNaN(param2))
         {
            return;
         }
         _loc3_ = 0;
         while(_loc3_ < this._slotsItems.length)
         {
            this._slotsItems[_loc3_].gotoAndStop("empty");
            _loc3_++;
         }
         var _loc4_:Class = getDefinitionByName(SOCKET_REF) as Class;
         while(this._slotsItems.length > param1)
         {
            this._socketsContainer.removeChild(this._slotsItems.pop());
         }
         while(this._slotsItems.length < param1)
         {
            _loc6_ = new _loc4_() as MovieClip;
            this._socketsContainer.addChild(_loc6_);
            this._slotsItems.push(_loc6_);
         }
         var _loc5_:Number = parent.height;
         _loc3_ = 0;
         while(_loc3_ < param1)
         {
            this._slotsItems[_loc3_].x = SOCKET_PADDING;
            this._slotsItems[_loc3_].y = (SOCKET_PADDING + this._slotsItems[_loc3_].height) * _loc3_ + SOCKET_TOP_OFFSET;
            if(param2 > 0)
            {
               this._slotsItems[_loc3_].gotoAndStop("used");
               param2--;
            }
            _loc3_++;
         }
      }
   }
}
