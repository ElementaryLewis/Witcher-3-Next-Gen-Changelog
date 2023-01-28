package red.game.witcher3.menus.inventory
{
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import red.core.events.GameEvent;
   import red.game.witcher3.constants.InventoryActionType;
   import red.game.witcher3.controls.W3BaseSlot;
   import red.game.witcher3.data.GridData;
   import red.game.witcher3.events.GridEvent;
   import red.game.witcher3.interfaces.IGridItemRenderer;
   import red.game.witcher3.managers.W3DragManager;
   import red.game.witcher3.menus.common.ItemDataStub;
   import scaleform.clik.data.ListData;
   import scaleform.clik.events.ButtonEvent;
   import scaleform.clik.events.DragEvent;
   import scaleform.clik.events.InputEvent;
   import scaleform.clik.interfaces.IDragSlot;
   import scaleform.gfx.MouseEventEx;
   
   public class InventorySlot extends W3BaseSlot implements IGridItemRenderer, IDragSlot
   {
      
      private static const DOUBLE_SIZE_PADDING:Number = 2;
       
      
      public var mcHitArea:MovieClip;
      
      public var mcRadialGradient:MovieClip;
      
      public var mcHighlightFrame:MovieClip;
      
      public var mcFrame:MovieClip;
      
      public var mcSlotOverlays:InventorySlotOverlay;
      
      protected var _mouseDownX:Number;
      
      protected var _mouseDownY:Number;
      
      protected var _gridSize:int = 1;
      
      protected var gridSizeOverride:Boolean = true;
      
      protected var m_sQuantity:String = "";
      
      protected var _itemQuality:int = 1;
      
      public function InventorySlot()
      {
         super();
         if(this.mcHitArea)
         {
            _originalHeight = this.mcHitArea.height;
            mouseChildren = tabChildren = false;
            hitArea = this.mcHitArea;
            this.mcHitArea.visible = false;
         }
      }
      
      override protected function configUI() : void
      {
         addEventListener(MouseEvent.MOUSE_OVER,this.handleMouseOver,true,0,true);
         addEventListener(MouseEvent.MOUSE_DOWN,this.handleMouseDown,false,0,true);
         addEventListener(MouseEvent.ROLL_OVER,this.handleMouseRollOver,false,0,true);
         addEventListener(MouseEvent.ROLL_OUT,this.handleMouseRollOut,false,0,true);
         addEventListener(MouseEvent.DOUBLE_CLICK,this.handleDoubleClik,false,0,true);
         this.addEventListener(MouseEvent.CLICK,this.handleRightClik,false,100,true);
         removeEventListener(InputEvent.INPUT,handleInput);
         addEventListener(ButtonEvent.PRESS,this.handleButtonPress,false,0,true);
      }
      
      public function get content() : Sprite
      {
         return null;
      }
      
      public function set content(param1:Sprite) : void
      {
      }
      
      public function set gridSize(param1:int) : void
      {
         if(this.gridSizeOverride)
         {
            this._gridSize = param1;
         }
         if(this.mcSlotOverlays)
         {
            this.mcSlotOverlays.SetGridSize(param1);
         }
      }
      
      public function get gridSize() : int
      {
         return this._gridSize;
      }
      
      protected function setClipHeightForGridSize(param1:Sprite) : void
      {
         if(this._gridSize == 4)
         {
            param1.height = (this._gridSize * _originalHeight + (this._gridSize - 1) * DOUBLE_SIZE_PADDING) / 2;
            param1.width = param1.height;
         }
         else
         {
            param1.height = this._gridSize * _originalHeight + (this._gridSize - 1) * DOUBLE_SIZE_PADDING;
            param1.width = _originalHeight;
         }
      }
      
      public function get uplink() : IGridItemRenderer
      {
         return null;
      }
      
      public function set uplink(param1:IGridItemRenderer) : void
      {
      }
      
      public function GetSlotHeight() : int
      {
         if(this._gridSize == 4)
         {
            return (this._gridSize * _originalHeight + (this._gridSize - 1) * DOUBLE_SIZE_PADDING) / 2;
         }
         return this._gridSize * _originalHeight + (this._gridSize - 1) * DOUBLE_SIZE_PADDING;
      }
      
      public function GetSlotWidth() : int
      {
         if(this._gridSize == 4)
         {
            return (this._gridSize * _originalWidth + (this._gridSize - 1) * DOUBLE_SIZE_PADDING) / 2;
         }
         return _originalWidth + DOUBLE_SIZE_PADDING;
      }
      
      protected function handleMouseOver(param1:MouseEvent) : void
      {
         trace("INVENTORY handleMouseOver " + this);
      }
      
      protected function handleMouseDown(param1:MouseEvent) : void
      {
         if(W3DragManager.inDrag() || !enabled)
         {
            return;
         }
         selected = true;
         if(!this.IsEmpty())
         {
            this.SetupHandleMouseDown();
         }
      }
      
      protected function SetupHandleMouseDown() : *
      {
         stage.addEventListener(MouseEvent.MOUSE_UP,this.handleMouseUp,false,0,true);
         addEventListener(MouseEvent.MOUSE_MOVE,this.handleMouseMove,false,0,true);
         this._mouseDownX = mouseX;
         this._mouseDownY = mouseY;
      }
      
      override protected function handleMouseRollOver(param1:MouseEvent) : void
      {
         var _loc2_:GridEvent = null;
         if(!enabled)
         {
            return;
         }
         if(!this.IsEmpty())
         {
            setState("over");
            _loc2_ = new GridEvent(GridEvent.DISPLAY_TOOLTIP,true,false,index,-1,-1,this,_data);
            trace("GFX INVENTORY handleMouseRollOver  DISPLAY_TOOLTIP inventory slotr");
            dispatchEvent(_loc2_);
         }
      }
      
      override protected function handleMouseRollOut(param1:MouseEvent) : void
      {
         var _loc2_:GridEvent = null;
         if(!enabled)
         {
            return;
         }
         setState("out");
         if(!this.IsEmpty())
         {
            _loc2_ = new GridEvent(GridEvent.HIDE_TOOLTIP,true,false,index,-1,-1,this,_data);
            dispatchEvent(_loc2_);
         }
      }
      
      protected function handleDoubleClik(param1:MouseEvent) : void
      {
         if(!enabled)
         {
            return;
         }
         this.ExecuteDefaultAction(_data);
      }
      
      protected function handleRightClik(param1:MouseEvent) : void
      {
         var _loc2_:MouseEventEx = null;
         var _loc3_:GridEvent = null;
         if(enabled)
         {
            _loc2_ = param1 as MouseEventEx;
            if(_loc2_)
            {
               if(_loc2_.buttonIdx == MouseEventEx.RIGHT_BUTTON && !this.IsEmpty())
               {
                  dispatchEvent(new GridEvent(GridEvent.DISPLAY_OPTIONSMENU,true,false,index,-1,-1,this,_data));
                  param1.stopImmediatePropagation();
                  _loc3_ = new GridEvent(GridEvent.HIDE_TOOLTIP,true,false,index,-1,-1,this,_data);
                  dispatchEvent(_loc3_);
               }
            }
         }
      }
      
      protected function cleanupDragListeners() : void
      {
         removeEventListener(MouseEvent.MOUSE_MOVE,this.handleMouseMove,false);
         this._mouseDownX = undefined;
         this._mouseDownY = undefined;
      }
      
      protected function handleMouseMove(param1:MouseEvent) : void
      {
         var _loc2_:DragEvent = null;
         if(mouseX > this._mouseDownX + 3 || mouseX < this._mouseDownX - 3 || mouseY > this._mouseDownY + 3 || mouseY < this._mouseDownY - 3)
         {
            this.cleanupDragListeners();
            if(_data == null)
            {
               _data = new Object();
               _data.iconPath = "";
               return;
            }
            if(!this.IsEmpty() && this.IsDragAllowed())
            {
               _data.iconPath = IconPath;
               _data.dragTarget = this;
               _loc2_ = new DragEvent(DragEvent.DRAG_START,_data,this,null,null);
               dispatchEvent(_loc2_);
               this.handleDragStartEvent(_loc2_);
            }
         }
      }
      
      protected function handleMouseUp(param1:MouseEvent) : void
      {
         this.cleanupDragListeners();
         stage.removeEventListener(MouseEvent.MOUSE_UP,this.handleMouseUp,false);
         var _loc2_:DragEvent = new DragEvent(DragEvent.DRAG_END,_data,this,null,null);
         dispatchEvent(_loc2_);
         this.handleDragEndEvent(_loc2_,false);
         dispatchEvent(new ButtonEvent(ButtonEvent.CLICK));
      }
      
      public function handleDragStartEvent(param1:DragEvent) : void
      {
         if(mcLoader)
         {
            mcLoader.alpha = 0.5;
         }
      }
      
      public function handleDropEvent(param1:DragEvent) : Boolean
      {
         var _loc5_:int = 0;
         var _loc6_:GridData = null;
         var _loc2_:InventorySlot = InventorySlot(param1.dragTarget);
         if(_loc2_ == this)
         {
            return false;
         }
         var _loc3_:Object = _loc2_.data;
         if(_loc3_ == null)
         {
            trace("Bidon: ASSERT InventrySlot handleDropEvent " + this + " (data == null)");
         }
         var _loc4_:Boolean;
         if(_loc4_ = this.CheckAcceptDrop(_loc3_))
         {
            _loc6_ = getGridData();
            if((_loc5_ = this.GetDropIndex()) > -1)
            {
               dispatchEvent(new GameEvent(GameEvent.CALL,"OnMoveItem",[_loc3_.id,_loc5_]));
            }
            else
            {
               dispatchEvent(new GameEvent(GameEvent.CALL,"OnEquipItem",[_loc3_.id,_loc3_.slotType,_loc3_.quantity]));
            }
            this.setListData(_loc2_.getGridData());
            _loc2_.setListData(_loc6_);
            _loc2_.setData(this.data);
            this.data = _loc3_;
         }
         return _loc4_;
      }
      
      protected function ExecuteDefaultAction(param1:Object) : *
      {
         var _loc3_:GridEvent = null;
         var _loc2_:ItemDataStub = param1 as ItemDataStub;
         if(_loc2_)
         {
            switch(_loc2_.actionType)
            {
               case InventoryActionType.EQUIP:
                  this.ExecuteEquipDefaultAction(_loc2_);
                  _loc3_ = new GridEvent(GridEvent.DISPLAY_TOOLTIP,true,false,0,-1,-1,null,_loc2_);
                  trace("INVENTORY ExecuteDefaultAction  DISPLAY_TOOLTIP inventory slot");
                  dispatchEvent(_loc3_);
                  break;
               case InventoryActionType.UPGRADE_WEAPON:
               case InventoryActionType.UPGRADE_WEAPON_STEEL:
               case InventoryActionType.UPGRADE_WEAPON_SILVER:
               case InventoryActionType.UPGRADE_ARMOR:
                  break;
               case InventoryActionType.CONSUME:
                  dispatchEvent(new GameEvent(GameEvent.CALL,"OnConsumeItem",[_loc2_.id]));
                  break;
               case InventoryActionType.READ:
                  dispatchEvent(new GameEvent(GameEvent.CALL,"OnReadBook",[_loc2_.id]));
               case InventoryActionType.DROP:
                  dispatchEvent(new GameEvent(GameEvent.CALL,"OnDropItem",[_loc2_.id,_loc2_.quantity]));
                  break;
               case InventoryActionType.TRANSFER:
                  dispatchEvent(new GameEvent(GameEvent.CALL,"OnTransferItem",[_loc2_.id,_loc2_.quantity]));
                  break;
               case InventoryActionType.SELL:
                  dispatchEvent(new GameEvent(GameEvent.CALL,"OnSellItem",[_loc2_.id,_loc2_.quantity]));
                  break;
               case InventoryActionType.BUY:
                  dispatchEvent(new GameEvent(GameEvent.CALL,"OnBuyItem",[_loc2_.id,_loc2_.quantity]));
            }
         }
      }
      
      protected function ExecuteEquipDefaultAction(param1:ItemDataStub) : *
      {
         dispatchEvent(new GameEvent(GameEvent.CALL,"OnEquipItem",[param1.id,param1.slotType,param1.quantity]));
      }
      
      public function GetCurrentItemId() : int
      {
         if(data)
         {
            return data.id;
         }
         return -1;
      }
      
      protected function CheckAcceptDrop(param1:Object) : Boolean
      {
         return true;
      }
      
      public function GetDropIndex() : int
      {
         return index;
      }
      
      public function handleDragEndEvent(param1:DragEvent, param2:Boolean) : void
      {
         mcLoader.alpha = 1;
         if(param2)
         {
         }
      }
      
      protected function IsDragAllowed() : Boolean
      {
         return true;
      }
      
      override public function setListData(param1:ListData) : void
      {
         gridData = param1 as GridData;
         if(gridData)
         {
            selected = gridData.selected;
            this.gridSize = gridData.gridSize;
         }
         else
         {
            this.gridSize = 1;
         }
         super.setListData(param1);
      }
      
      override public function setData(param1:Object) : void
      {
         this._itemQuality = 1;
         if(param1)
         {
            mcLoader.fallbackIconPath = this.GetDefaultFallbackIconFromType(param1.category);
         }
         if(param1)
         {
            if(this.mcSlotOverlays)
            {
               this.mcSlotOverlays.SetEquipped(this.GetEquippedState(param1));
               this.mcSlotOverlays.SetIsNew(param1.isNew);
               this.mcSlotOverlays.SetNeedRepair(param1.needRepair);
            }
            this._itemQuality = param1.quality;
         }
         super.setData(param1);
      }
      
      protected function GetEquippedState(param1:Object) : Boolean
      {
         return param1.equipped > 0;
      }
      
      override public function toString() : String
      {
         return "[W3 InventorySlot: gridSize " + this._gridSize + ", index " + _index + "]";
      }
      
      protected function updateQuantity() : void
      {
         var _loc1_:ItemDataStub = data as ItemDataStub;
         if(_loc1_)
         {
            this.m_sQuantity = Boolean(_loc1_) && (_loc1_.isStackable || _loc1_.quantity > 1) ? String(_loc1_.quantity) : "";
         }
         else
         {
            this.m_sQuantity = "";
         }
         if(this.mcSlotOverlays)
         {
            this.mcSlotOverlays.SetQuantity(this.m_sQuantity);
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
               return "icons/inventory/crabspidershell_64x64.dds";
            case "mutagen":
               return "icons/inventory/freezingtrap_64x64.dds";
            default:
               return "icons/inventory/raspberryjuice_64x64.dds";
         }
      }
      
      override protected function update() : void
      {
         this.updateQuantity();
         this.updateScale();
         this.UpdateBackground();
         this.UpdateSelectionFrame(this._gridSize);
         this.updateIcons();
      }
      
      protected function updateScale() : void
      {
         if(this.mcHitArea)
         {
            this.setClipHeightForGridSize(this.mcHitArea);
         }
         if(this.mcRadialGradient)
         {
            this.setClipHeightForGridSize(this.mcRadialGradient);
         }
      }
      
      protected function updateIcons() : void
      {
         if(this.mcSlotOverlays)
         {
            this.mcSlotOverlays.updateIcons();
         }
      }
      
      protected function UpdateBackground() : void
      {
         if(this.mcFrame)
         {
            this.mcFrame.gotoAndStop(this._itemQuality);
         }
      }
      
      protected function UpdateSelectionFrame(param1:int) : void
      {
         if(getChildByName("mcHighlightFrame"))
         {
            if(param1 > 3)
            {
               this.mcHighlightFrame.height = 75.5 + _originalHeight;
               this.mcHighlightFrame.width = 75.5 + _originalHeight;
               this.mcFrame.height = 64 + _originalHeight;
               this.mcFrame.width = 64 + _originalHeight;
            }
            else
            {
               this.mcHighlightFrame.height = 75.5 + (param1 - 1) * _originalHeight;
               this.mcHighlightFrame.width = 75.5;
               this.mcFrame.height = 64 + (param1 - 1) * _originalHeight;
               this.mcFrame.width = 64;
            }
         }
      }
      
      public function IsEmpty() : Boolean
      {
         if(IconPath)
         {
            if(IconPath != "")
            {
               return false;
            }
         }
         return true;
      }
      
      public function IsEquipped() : Boolean
      {
         return this.mcSlotOverlays.GetEquipped();
      }
      
      override protected function ResetIcons() : void
      {
         if(this.mcSlotOverlays)
         {
            this.mcSlotOverlays.ResetIcons();
         }
      }
      
      protected function handleButtonPress(param1:ButtonEvent) : void
      {
         var _loc2_:GridEvent = null;
         if(!this.IsEmpty())
         {
            this.ExecuteDefaultAction(data);
            _loc2_ = new GridEvent(GridEvent.DISPLAY_TOOLTIP,true,false,index,-1,-1,this,data);
            trace("GFX INVENTORY handleButtonPress  DISPLAY_TOOLTIP inventory slot");
            dispatchEvent(_loc2_);
         }
      }
   }
}
