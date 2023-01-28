package red.game.witcher3.slots
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import red.core.constants.KeyCode;
   import red.core.events.GameEvent;
   import red.game.witcher3.constants.CommonConstants;
   import red.game.witcher3.constants.InventorySlotType;
   import red.game.witcher3.constants.ItemQuality;
   import red.game.witcher3.events.GridEvent;
   import red.game.witcher3.interfaces.IDragTarget;
   import red.game.witcher3.interfaces.IDropTarget;
   import red.game.witcher3.interfaces.IPaperdollSlot;
   import red.game.witcher3.managers.InputManager;
   import red.game.witcher3.menus.character_menu.CharacterModeBackground;
   import red.game.witcher3.menus.common.ItemDataStub;
   import scaleform.clik.events.InputEvent;
   import scaleform.gfx.MouseEventEx;
   
   public class SlotPaperdoll extends SlotInventoryGrid implements IPaperdollSlot, IDropTarget
   {
       
      
      public var tfSlotName:TextField;
      
      public var defaultIcon:MovieClip;
      
      public var iconLock:MovieClip;
      
      public var mcPreviewIcon:MovieClip;
      
      public var sectionId:int = -1;
      
      protected var _slotTag:String;
      
      protected var _slotTypeID:int;
      
      protected var _equipID:int;
      
      protected var _selectionMode:Boolean;
      
      protected var _darkUnselectable:Boolean = true;
      
      private var _dropEnabled:Boolean = true;
      
      private var _currentDropAction:int = 1;
      
      protected var _lockedDataProvider:String = "INVALID_STRING_PARAM!";
      
      protected var _isLocked:Boolean = false;
      
      public function SlotPaperdoll()
      {
         super();
         _defaultTooltipAnchor = "tooltipPaperdollAnchor";
         AUTO_SHOW_COLLAPSED_ICON = true;
      }
      
      public function get selectionMode() : Boolean
      {
         return this._selectionMode;
      }
      
      public function set selectionMode(param1:Boolean) : void
      {
         this._selectionMode = param1;
      }
      
      public function get darkUnselectable() : Boolean
      {
         return this._darkUnselectable;
      }
      
      public function set darkUnselectable(param1:Boolean) : void
      {
         this._darkUnselectable = param1;
      }
      
      public function get dropEnabled() : Boolean
      {
         return this._dropEnabled;
      }
      
      public function set dropEnabled(param1:Boolean) : void
      {
         this._dropEnabled = param1;
      }
      
      override public function set dragSelection(param1:Boolean) : void
      {
         super.dragSelection = param1;
         if(param1 && !isEmpty() && data)
         {
            dispatchEvent(new GameEvent(GameEvent.CALL,"OnDragItemStarted",[data.id]));
         }
      }
      
      public function applyDrop(param1:IDragTarget) : void
      {
         var _loc2_:ItemDataStub = param1.getDragData() as ItemDataStub;
         switch(this._currentDropAction)
         {
            case SlotDragAvatar.ACTION_ENHANCE:
               dispatchEvent(new GameEvent(GameEvent.CALL,"OnApplyUpgrade",[_loc2_.id,this.slotTagToType(this.slotTag)]));
               break;
            case SlotDragAvatar.ACTION_OIL:
               dispatchEvent(new GameEvent(GameEvent.CALL,"OnApplyOil",[_loc2_.id,this.slotTagToType(this.slotTag)]));
               break;
            case SlotDragAvatar.ACTION_REPAIR:
               dispatchEvent(new GameEvent(GameEvent.CALL,"OnApplyRepairKit",[_loc2_.id,this.slotTagToType(this.slotTag)]));
               break;
            case SlotDragAvatar.ACTION_DIY:
               dispatchEvent(new GameEvent(GameEvent.CALL,"OnApplyDye",[_loc2_.id,this.slotTagToType(this.slotTag)]));
               break;
            default:
               dispatchEvent(new GameEvent(GameEvent.CALL,"OnDropOnPaperdoll",[_loc2_.id,this.slotTagToType(this.slotTag),_loc2_.quantity]));
         }
         var _loc3_:SlotsListPaperdoll = owner as SlotsListPaperdoll;
         if(_loc3_)
         {
            _loc3_.dispatchItemClickEvent(this);
         }
      }
      
      override public function canDrag() : Boolean
      {
         if(data && Boolean(data.cantUnequip))
         {
            return false;
         }
         return super.canDrag();
      }
      
      public function canDrop(param1:IDragTarget) : Boolean
      {
         var _loc4_:* = false;
         var _loc5_:* = false;
         var _loc6_:Boolean = false;
         var _loc7_:Boolean = false;
         var _loc2_:ItemDataStub = param1.getDragData() as ItemDataStub;
         var _loc3_:ItemDataStub = _data as ItemDataStub;
         if(Boolean(_loc2_) && !this.isLocked)
         {
            if(Boolean(_loc3_) && _loc3_.id == _loc2_.id)
            {
               this._currentDropAction = SlotDragAvatar.ACTION_NONE;
               return false;
            }
            if(!this.CheckSlotsType(_loc2_.slotType))
            {
               if(!isEmpty() && Boolean(_loc3_))
               {
                  _loc4_ = _loc3_.slotType == InventorySlotType.SteelSword;
                  _loc5_ = _loc3_.slotType == InventorySlotType.SilverSword;
                  _loc6_ = _loc3_.slotType == InventorySlotType.Armor || _loc3_.slotType == InventorySlotType.Boots || _loc3_.slotType == InventorySlotType.Gloves || _loc3_.slotType == InventorySlotType.Pants;
                  _loc7_ = _loc3_.socketsCount > _loc3_.socketsUsedCount && !_loc3_.enchanted;
                  if(_loc3_.quality == ItemQuality.SET && _loc2_.isDye && _loc6_)
                  {
                     this._currentDropAction = SlotDragAvatar.ACTION_DIY;
                     return true;
                  }
                  if(_loc2_.isSteelOil && _loc4_)
                  {
                     this._currentDropAction = SlotDragAvatar.ACTION_OIL;
                     return true;
                  }
                  if(_loc2_.isSilverOil && _loc5_)
                  {
                     this._currentDropAction = SlotDragAvatar.ACTION_OIL;
                     return true;
                  }
                  if(_loc2_.isArmorUpgrade && _loc6_ && _loc7_)
                  {
                     this._currentDropAction = SlotDragAvatar.ACTION_ENHANCE;
                     return true;
                  }
                  if(_loc2_.isWeaponUpgrade && (_loc4_ || _loc5_) && _loc7_)
                  {
                     this._currentDropAction = SlotDragAvatar.ACTION_ENHANCE;
                     return true;
                  }
                  if(_loc2_.isWeaponRepairKit && (_loc4_ || _loc5_) && _loc3_.durability < 100)
                  {
                     this._currentDropAction = SlotDragAvatar.ACTION_REPAIR;
                     return true;
                  }
                  if(_loc2_.isArmorRepairKit && _loc6_ && _loc3_.durability < 100)
                  {
                     this._currentDropAction = SlotDragAvatar.ACTION_REPAIR;
                     return true;
                  }
               }
               this._currentDropAction = SlotDragAvatar.ACTION_ERROR;
               return false;
            }
            if(isEmpty())
            {
               this._currentDropAction = SlotDragAvatar.ACTION_DROP;
            }
            else
            {
               this._currentDropAction = SlotDragAvatar.ACTION_SWAP;
            }
            return true;
         }
         this._currentDropAction = SlotDragAvatar.ACTION_ERROR;
         return false;
      }
      
      public function processOver(param1:SlotDragAvatar) : int
      {
         if(param1)
         {
            highlight = true;
         }
         else
         {
            highlight = false;
         }
         return this._currentDropAction;
      }
      
      public function get dropSelection() : Boolean
      {
         return _dropSelection;
      }
      
      public function set dropSelection(param1:Boolean) : void
      {
         _dropSelection = param1;
         invalidateState();
      }
      
      override public function set selectable(param1:Boolean) : void
      {
         if(param1)
         {
            alpha = 1;
         }
         else if(this._darkUnselectable)
         {
            alpha = 0.1;
         }
         super.selectable = param1;
      }
      
      override public function get selectable() : Boolean
      {
         return _selectable;
      }
      
      override public function executeAction(param1:Number, param2:InputEvent) : Boolean
      {
         if(useContextMgr && isEmpty() && (param1 == KeyCode.PAD_A_CROSS || param1 == KeyCode.ENTER || param1 == KeyCode.NUMPAD_ENTER || param1 == KeyCode.SPACE))
         {
            dispatchEvent(new GameEvent(GameEvent.CALL,"OnEmptySlotActivate",[this.equipID]));
            if(param2)
            {
               param2.handled = true;
            }
            return true;
         }
         return super.executeAction(param1,param2);
      }
      
      override protected function defaultSlotEquipAction(param1:Object) : void
      {
         if(useContextMgr)
         {
            if(!isEmpty())
            {
               dispatchEvent(new GameEvent(GameEvent.CALL,"OnUnequipItem",[param1.id,-1]));
            }
         }
      }
      
      override protected function handleMouseDoubleClick(param1:MouseEvent) : void
      {
         var _loc2_:MouseEventEx = param1 as MouseEventEx;
         if(Boolean(_loc2_) && _loc2_.buttonIdx != MouseEventEx.LEFT_BUTTON)
         {
            return;
         }
         if(useContextMgr)
         {
            if(this.selectionMode)
            {
               dispatchEvent(new Event(CharacterModeBackground.ACCEPT,true));
            }
            else if(!isEmpty())
            {
               callContextFunction();
            }
            else
            {
               this.executeAction(KeyCode.PAD_A_CROSS,null);
            }
         }
         else
         {
            executeDefaultAction(KeyCode.PAD_A_CROSS,null);
         }
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         this.initDropTarget();
         if(this.iconLock)
         {
            this.iconLock.visible = false;
         }
         if(this._lockedDataProvider != CommonConstants.INVALID_STRING_PARAM)
         {
            dispatchEvent(new GameEvent(GameEvent.REGISTER,this._lockedDataProvider,[this.setIsLocked]));
         }
         if(this.tfSlotName)
         {
            this.tfSlotName.mouseEnabled = false;
         }
         if(this.mcPreviewIcon)
         {
            this.mcPreviewIcon.visible = false;
         }
      }
      
      protected function initDropTarget() : void
      {
         SlotsTransferManager.getInstance().addDropTarget(this);
      }
      
      public function get lockedDataProvider() : String
      {
         return this._lockedDataProvider;
      }
      
      public function set lockedDataProvider(param1:String) : void
      {
         this._lockedDataProvider = param1;
      }
      
      public function get isLocked() : Boolean
      {
         return this._isLocked;
      }
      
      protected function setIsLocked(param1:Boolean) : void
      {
         this._isLocked = param1;
         if(param1)
         {
            this.iconLock.visible = true;
         }
         else
         {
            this.iconLock.visible = false;
         }
      }
      
      override protected function updateSize() : *
      {
      }
      
      public function get tooltipAlignment() : String
      {
         return _tooltipAlignment;
      }
      
      public function set tooltipAlignment(param1:String) : void
      {
         _tooltipAlignment = param1;
      }
      
      public function get slotTypeID() : int
      {
         return this._slotTypeID;
      }
      
      public function set slotTypeID(param1:int) : void
      {
         this._slotTypeID = param1;
      }
      
      public function get equipID() : int
      {
         return this._equipID;
      }
      
      public function set equipID(param1:int) : void
      {
         this._equipID = param1;
      }
      
      public function get slotTag() : String
      {
         return this._slotTag;
      }
      
      public function set slotTag(param1:String) : void
      {
         this._slotTag = param1;
         if(this.tfSlotName)
         {
            if(!this._slotTag)
            {
               this.tfSlotName.htmlText = "";
            }
            if(this._slotTag.indexOf("quick") != -1)
            {
               this.tfSlotName.htmlText = "";
            }
            else if(this._slotTag.indexOf("potion") != -1)
            {
               this.tfSlotName.htmlText = "";
            }
            else if(this._slotTag.indexOf("petard") != -1)
            {
               this.tfSlotName.htmlText = "";
            }
            else
            {
               this.tfSlotName.htmlText = "[[panel_inventory_paperdoll_slotname_" + this._slotTag + "]]";
            }
         }
         if(this._slotTag)
         {
            this.defaultIcon.gotoAndStop(this._slotTag);
            this.defaultIcon.visible = true;
         }
         else
         {
            this.defaultIcon.visible = false;
         }
      }
      
      public function get slotType() : int
      {
         return this.slotTagToType(this._slotTag);
      }
      
      override protected function updateData() : *
      {
         super.updateData();
         if(Boolean(_data) && Boolean(this.defaultIcon))
         {
            this.defaultIcon.visible = false;
         }
      }
      
      override public function cleanup() : void
      {
         super.cleanup();
         if(this._slotTag)
         {
            this.defaultIcon.visible = true;
         }
         if(_selected && InputManager.getInstance().isGamepad())
         {
            this.fireTooltipShowEvent();
         }
      }
      
      override protected function loadIcon(param1:String) : void
      {
         super.loadIcon(param1);
         if(this.mcPreviewIcon)
         {
            addChild(this.mcPreviewIcon);
         }
      }
      
      override protected function wipeIndicators() : void
      {
      }
      
      private function slotTagToType(param1:String) : int
      {
         var _loc2_:int = InventorySlotType.InvalidSlot;
         switch(param1)
         {
            case "steel":
               _loc2_ = InventorySlotType.SteelSword;
               break;
            case "silver":
               _loc2_ = InventorySlotType.SilverSword;
               break;
            case "armor":
               _loc2_ = InventorySlotType.Armor;
               break;
            case "gloves":
               _loc2_ = InventorySlotType.Gloves;
               break;
            case "trousers":
               _loc2_ = InventorySlotType.Pants;
               break;
            case "boots":
               _loc2_ = InventorySlotType.Boots;
               break;
            case "trophy":
               _loc2_ = InventorySlotType.Trophy;
               break;
            case "quick1":
               _loc2_ = InventorySlotType.Quickslot1;
               break;
            case "quick2":
               _loc2_ = InventorySlotType.Quickslot2;
               break;
            case "rangeweapon":
               _loc2_ = InventorySlotType.RangedWeapon;
               break;
            case "petard1":
               _loc2_ = InventorySlotType.Petard1;
               break;
            case "petard2":
               _loc2_ = InventorySlotType.Petard2;
               break;
            case "potion1":
               _loc2_ = InventorySlotType.Potion1;
               break;
            case "potion2":
               _loc2_ = InventorySlotType.Potion2;
               break;
            case "potion3":
               _loc2_ = InventorySlotType.Potion3;
               break;
            case "potion4":
               _loc2_ = InventorySlotType.Potion4;
               break;
            case "mutagen1":
               _loc2_ = InventorySlotType.Mutagen1;
               break;
            case "mutagen2":
               _loc2_ = InventorySlotType.Mutagen2;
               break;
            case "mutagen3":
               _loc2_ = InventorySlotType.Mutagen3;
               break;
            case "mutagen4":
               _loc2_ = InventorySlotType.Mutagen4;
               break;
            case "bolt":
               _loc2_ = InventorySlotType.Bolt;
               break;
            case "horseBag":
               _loc2_ = InventorySlotType.HorseBag;
               break;
            case "horseBlinders":
               _loc2_ = InventorySlotType.HorseBlinders;
               break;
            case "horseSaddle":
               _loc2_ = InventorySlotType.HorseSaddle;
               break;
            case "horseTrophy":
               _loc2_ = InventorySlotType.HorseTrophy;
         }
         return _loc2_;
      }
      
      override protected function fireTooltipShowEvent(param1:Boolean = false) : void
      {
         var _loc2_:GridEvent = null;
         if(!(activeSelectionEnabled || !InputManager.getInstance().isGamepad()) && isParentEnabled())
         {
            return;
         }
         if(_data)
         {
            if(_data.prepItemType == 3)
            {
               _loc2_ = new GridEvent(GridEvent.DISPLAY_TOOLTIP,true,false,index,-1,-1,null,null);
               if(!_data.showExtendedTooltip)
               {
                  _loc2_.tooltipContentRef = "ItemDescriptionTooltipRef";
               }
               else
               {
                  _loc2_.tooltipContentRef = "ItemTooltipRef";
               }
               _loc2_.tooltipDataSource = "OnGetAppliedOilTooltip";
               _loc2_.tooltipForceSetDataSource = true;
               _loc2_.tooltipCustomArgs = [this.equipID];
               _loc2_.isMouseTooltip = param1;
               _loc2_.anchorRect = getGlobalSlotRect();
               _loc2_.tooltipAlignment = _tooltipAlignment;
               dispatchEvent(_loc2_);
            }
            else
            {
               super.fireTooltipShowEvent(param1);
            }
         }
         else
         {
            _loc2_ = new GridEvent(GridEvent.DISPLAY_TOOLTIP,true,false,index,-1,-1,null,null);
            _loc2_.tooltipMouseContentRef = "TooltipEmptySlotRef";
            _loc2_.tooltipContentRef = "TooltipEmptySlotRef";
            _loc2_.tooltipDataSource = "OnGetEmptyPaperdollTooltip";
            _loc2_.tooltipForceSetDataSource = true;
            _loc2_.tooltipCustomArgs = [this.equipID,this.isLocked];
            _loc2_.isMouseTooltip = param1;
            _loc2_.anchorRect = getGlobalSlotRect();
            _loc2_.tooltipAlignment = _tooltipAlignment;
            dispatchEvent(_loc2_);
            _tooltipRequested = true;
         }
      }
      
      public function CheckSlotsType(param1:int) : Boolean
      {
         var _loc2_:int = this.slotTagToType(this.slotTag);
         if(param1 == InventorySlotType.Petard1)
         {
            if(_loc2_ == InventorySlotType.Petard2)
            {
               return true;
            }
         }
         else if(param1 == InventorySlotType.Petard2)
         {
            if(_loc2_ == InventorySlotType.Petard1)
            {
               return true;
            }
         }
         else if(param1 == InventorySlotType.Quickslot1)
         {
            if(_loc2_ == InventorySlotType.Quickslot2)
            {
               return true;
            }
         }
         else if(param1 == InventorySlotType.Quickslot2)
         {
            if(_loc2_ == InventorySlotType.Quickslot1)
            {
               return true;
            }
         }
         else
         {
            if((param1 == InventorySlotType.Potion1 || param1 == InventorySlotType.Potion2 || param1 == InventorySlotType.Potion3 || param1 == InventorySlotType.Potion4) && (_loc2_ == InventorySlotType.Potion1 || _loc2_ == InventorySlotType.Potion2 || _loc2_ == InventorySlotType.Potion3 || _loc2_ == InventorySlotType.Potion4))
            {
               return true;
            }
            if(param1 == InventorySlotType.Potion1)
            {
               if(_loc2_ == InventorySlotType.Potion2)
               {
                  return true;
               }
            }
            else if(param1 == InventorySlotType.Potion2)
            {
               if(_loc2_ == InventorySlotType.Potion1)
               {
                  return true;
               }
            }
         }
         return param1 == _loc2_;
      }
      
      override public function toString() : String
      {
         return "SlotPaperdoll [" + this.name + "] ";
      }
   }
}
