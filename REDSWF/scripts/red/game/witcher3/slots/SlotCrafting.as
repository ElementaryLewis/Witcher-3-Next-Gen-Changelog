package red.game.witcher3.slots
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import flash.text.TextField;
   import red.core.constants.KeyCode;
   import red.core.events.GameEvent;
   import red.game.witcher3.events.ControllerChangeEvent;
   import red.game.witcher3.events.GridEvent;
   import red.game.witcher3.managers.InputManager;
   import scaleform.clik.events.InputEvent;
   import scaleform.gfx.MouseEventEx;
   
   public class SlotCrafting extends SlotInventoryGrid
   {
       
      
      public var mcMissingIngredient:MovieClip;
      
      public var mcCraftableBackground:MovieClip;
      
      public var mcFrameBkg:MovieClip;
      
      public var mcVendorIcon:MovieClip;
      
      public var tfVendorQuantity:TextField;
      
      public var mcCollapsedTooltipIcon:MovieClip;
      
      protected var _mouseOverTrigger:Boolean = false;
      
      public function SlotCrafting()
      {
         super();
         this.mcVendorIcon.mouseEnabled = false;
         this.mcVendorIcon.mouseChildren = false;
         this.tfVendorQuantity.mouseEnabled = false;
      }
      
      override protected function configUI() : void
      {
         super.configUI();
      }
      
      override protected function initCollapsedIconBehavior() : void
      {
         AUTO_SHOW_COLLAPSED_ICON = true;
         _mcCollapsedTooltipIcon = this.mcCollapsedTooltipIcon;
         if(_mcCollapsedTooltipIcon)
         {
            _mcCollapsedTooltipIcon.visible = false;
         }
         super.initCollapsedIconBehavior();
      }
      
      override protected function handleIconLoaded(param1:Event) : void
      {
         super.handleIconLoaded(param1);
         if(this.mcCollapsedTooltipIcon)
         {
            addChild(this.mcCollapsedTooltipIcon);
         }
      }
      
      override protected function handleControllerChanged(param1:ControllerChangeEvent) : void
      {
         super.handleControllerChanged(param1);
      }
      
      override protected function handleMouseClick(param1:MouseEvent) : void
      {
         var _loc2_:MouseEventEx = param1 as MouseEventEx;
         if(!data || data.vendorQuantity < 1)
         {
            return;
         }
         if(Boolean(_loc2_) && _loc2_.buttonIdx == MouseEventEx.RIGHT_BUTTON)
         {
            trace("");
            dispatchEvent(new GameEvent(GameEvent.CALL,"OnBuyIngredient",[int(data.id),Boolean(data.reqQuantity - data.quantity == 1)]));
         }
      }
      
      override public function executeAction(param1:Number, param2:InputEvent) : Boolean
      {
         if(!data)
         {
            return false;
         }
         if(param1 == KeyCode.PAD_Y_TRIANGLE)
         {
            dispatchEvent(new GameEvent(GameEvent.CALL,"OnBuyIngredient",[int(data.id),Boolean(data.reqQuantity - data.quantity == 1)]));
         }
         return false;
      }
      
      override protected function loadIcon(param1:String) : void
      {
         super.loadIcon(param1);
         if(this.tfVendorQuantity)
         {
            addChild(this.tfVendorQuantity);
         }
         if(this.mcVendorIcon)
         {
            addChild(this.mcVendorIcon);
         }
      }
      
      override public function get selectable() : Boolean
      {
         return _selectable && !isEmpty();
      }
      
      override public function set data(param1:*) : void
      {
         super.data = param1;
         if(!data)
         {
            visible = false;
         }
      }
      
      override protected function updateData() : *
      {
         super.updateData();
         if(!data)
         {
            visible = false;
            return;
         }
         visible = true;
         if(Boolean(this.mcVendorIcon) && Boolean(this.tfVendorQuantity))
         {
            if(_data.vendorQuantity > 0)
            {
               this.mcVendorIcon.visible = true;
               this.tfVendorQuantity.visible = true;
               this.tfVendorQuantity.text = _data.vendorQuantity + "";
            }
            else
            {
               this.mcVendorIcon.visible = false;
               this.tfVendorQuantity.visible = false;
            }
         }
         if(_data.reqQuantity)
         {
            mcSlotOverlays.SetQuantity(_data.quantity + "/" + _data.reqQuantity);
            mcSlotOverlays.SetQuantityCraftingColor(_data.reqQuantity <= _data.quantity);
         }
         if(this.mcMissingIngredient)
         {
            this.mcMissingIngredient.visible = _data.quantity < _data.reqQuantity;
         }
      }
      
      override public function getSlotRect() : Rectangle
      {
         if(mcHitArea)
         {
            return new Rectangle(mcHitArea.x - mcHitArea.width / 2,mcHitArea.y - mcHitArea.height / 2,mcHitArea.width,mcHitArea.height);
         }
         return super.getSlotRect();
      }
      
      override protected function selectingTooltipShowCheck() : Boolean
      {
         return true;
      }
      
      override protected function handleMouseOver(param1:MouseEvent) : void
      {
         this._mouseOverTrigger = true;
         super.handleMouseOver(param1);
      }
      
      override protected function handleMouseOut(param1:MouseEvent) : void
      {
         this._mouseOverTrigger = false;
         super.handleMouseOut(param1);
      }
      
      override protected function fireTooltipShowEvent(param1:Boolean = false) : void
      {
         var _loc2_:GridEvent = null;
         if((activeSelectionEnabled || !InputManager.getInstance().isGamepad() && this._mouseOverTrigger) && _data && isParentEnabled())
         {
            this._mouseOverTrigger = false;
            removeEventListener(Event.ENTER_FRAME,pendedTooltipHide);
            _loc2_ = new GridEvent(GridEvent.DISPLAY_TOOLTIP,true,false,index,-1,-1,null,_data as Object);
            _loc2_.anchorRect = getGlobalSlotRect();
            _loc2_.tooltipContentRef = "IngredientTooltipRef";
            dispatchEvent(_loc2_);
            _tooltipRequested = true;
         }
      }
      
      override protected function updateItemSize(param1:MovieClip, param2:Rectangle) : void
      {
      }
      
      override protected function defaultSlotEquipAction(param1:Object) : void
      {
      }
   }
}
