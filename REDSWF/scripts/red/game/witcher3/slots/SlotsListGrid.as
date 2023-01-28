package red.game.witcher3.slots
{
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import flash.utils.getDefinitionByName;
   import red.core.events.GameEvent;
   import red.game.witcher3.constants.CommonConstants;
   import red.game.witcher3.constants.InventorySlotType;
   import red.game.witcher3.interfaces.IBaseSlot;
   import red.game.witcher3.interfaces.IDragTarget;
   import red.game.witcher3.interfaces.IDropTarget;
   import red.game.witcher3.interfaces.IInventorySlot;
   import red.game.witcher3.managers.InputManager;
   import red.game.witcher3.menus.common.ItemDataStub;
   import red.game.witcher3.menus.inventory_menu.ItemSectionData;
   import red.game.witcher3.menus.inventory_menu.MenuInventory;
   import red.game.witcher3.utils.CommonUtils;
   import scaleform.clik.constants.InputValue;
   import scaleform.clik.constants.InvalidationType;
   import scaleform.clik.constants.NavigationCode;
   import scaleform.clik.controls.ScrollIndicator;
   import scaleform.clik.events.InputEvent;
   import scaleform.clik.events.ListEvent;
   import scaleform.clik.interfaces.IListItemRenderer;
   import scaleform.clik.interfaces.IScrollBar;
   import scaleform.clik.ui.InputDetails;
   
   public class SlotsListGrid extends SlotsListBase implements IDropTarget
   {
      
      public static const SECTION_PADDING:Number = 15;
      
      protected static const HIGHLIGHT_REF:String = "SlotHighlightRef";
      
      protected static const HIGHLIGHT_LABEL_ACCEPT:String = "accept";
      
      protected static const HIGHLIGHT_LABEL_DENIDED:String = "denided";
      
      protected static const HIGHLIGHT_LABEL_NONE:String = "none";
      
      protected static const ITEM_PADDING:Number = 4;
       
      
      public var handleScrollBar:Boolean = false;
      
      protected var _gridRenderHeight:int = 520;
      
      protected var _discardedRendererPool:Vector.<IInventorySlot>;
      
      protected var _specialCachedSelection:int = -1;
      
      protected var _lastSetSort:int = -1;
      
      protected var _maxOffset:Number = 0;
      
      protected var _scrollBarValue:Object;
      
      protected var _offset:uint;
      
      protected var _scrollBar:IScrollBar;
      
      protected var _gridSquareSize:Number;
      
      protected var _elementGridSquareOffset:Number;
      
      protected var _rows:uint;
      
      protected var _columns:uint;
      
      protected var _totalRenderers:int;
      
      public var handlesRightJoystick:Boolean = false;
      
      public var ignoreValidationOpt:Boolean = false;
      
      protected var _numRowsVisible:uint = 1;
      
      protected var _dropSelection:Boolean;
      
      protected var _highlightCanvas:Sprite;
      
      protected var _highlightIndicator:MovieClip;
      
      protected var _cachedItemPositions:Object;
      
      protected var _initFindSelection:Boolean = true;
      
      protected var _ignoreGridPosition:Boolean = false;
      
      public var ignoreNextGridPosition:Boolean = false;
      
      protected var _itemSectionsList:Array;
      
      protected var _paddingsMap:Object;
      
      protected var highestRowNeeded:uint = 0;
      
      public var gridMaskOffset:Number = 0;
      
      public var mcStateDropTarget:MovieClip;
      
      protected var _gridMask:MovieClip = null;
      
      protected var _dropMode:int;
      
      protected var _useContextMgr:Boolean = true;
      
      private var _dropEnabled:Boolean = true;
      
      protected var _currentDropRenderer:IInventorySlot;
      
      public var lastSelectedSection:int = -1;
      
      internal const DEBUG_REC_LIMIT = 100;
      
      protected var _renderBounds:Rectangle = null;
      
      public function SlotsListGrid()
      {
         this._discardedRendererPool = new Vector.<IInventorySlot>();
         super();
         if(this.mcStateDropTarget)
         {
            this.mcStateDropTarget.visible = false;
         }
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         this._totalRenderers = this._rows * this._columns;
         this.createInitRenderers();
         _canvas.addEventListener(MouseEvent.MOUSE_WHEEL,this.onScroll,false,0,true);
         this._highlightCanvas = new Sprite();
         this._highlightCanvas.mouseChildren = false;
         this._highlightCanvas.mouseEnabled = false;
         addChild(this._highlightCanvas);
         if(this.gridMask)
         {
            this._gridRenderHeight = this.gridMask.height - this.gridMaskOffset;
            this._numRowsVisible = Math.floor((this.gridMask.height - this.gridMaskOffset) / CommonConstants.INVENTORY_GRID_SIZE);
         }
         addEventListener(ListEvent.INDEX_CHANGE,this.handleSlotChanged,false,0,true);
      }
      
      protected function get gridMask() : MovieClip
      {
         if(this._gridMask == null)
         {
            this._gridMask = parent.getChildByName("mcGridMask") as MovieClip;
         }
         return this._gridMask;
      }
      
      public function setItemSections(param1:Array) : void
      {
         this._itemSectionsList = param1;
         this.updateColumnsPaddingMap();
         clearRenderers();
      }
      
      private function updateColumnsPaddingMap() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(this._itemSectionsList)
         {
            this._paddingsMap = {};
            _loc1_ = int(this._itemSectionsList.length);
            _loc2_ = 0;
            while(_loc2_ < this.numColumns)
            {
               this._paddingsMap[_loc2_] = 0;
               _loc3_ = 0;
               while(_loc3_ < _loc1_)
               {
                  if(_loc2_ >= this._itemSectionsList[_loc3_].start && _loc2_ <= this._itemSectionsList[_loc3_].end)
                  {
                     this._paddingsMap[_loc2_] = this._itemSectionsList[_loc3_].id;
                     break;
                  }
                  _loc3_++;
               }
               _loc2_++;
            }
         }
      }
      
      public function get dropMode() : int
      {
         return this._dropMode;
      }
      
      public function set dropMode(param1:int) : void
      {
         this._dropMode = param1;
      }
      
      public function get useContextMgr() : Boolean
      {
         return this._useContextMgr;
      }
      
      public function set useContextMgr(param1:Boolean) : void
      {
         this._useContextMgr = param1;
      }
      
      public function get initFindSelection() : *
      {
         return this._initFindSelection;
      }
      
      public function set initFindSelection(param1:Boolean) : void
      {
         this._initFindSelection = param1;
      }
      
      public function get ignoreGridPosition() : *
      {
         return this._ignoreGridPosition;
      }
      
      public function set ignoreGridPosition(param1:Boolean) : void
      {
         this._ignoreGridPosition = param1;
      }
      
      override public function set visible(param1:Boolean) : void
      {
         super.visible = param1;
         this.updateScrollBar();
      }
      
      override public function set focused(param1:Number) : void
      {
         if(param1 > 0 && param1 != focused)
         {
            if(selectedIndex < 0 && this.initFindSelection)
            {
               findSelection();
            }
         }
         super.focused = param1;
      }
      
      override public function get numColumns() : uint
      {
         return this._columns;
      }
      
      public function get dropEnabled() : Boolean
      {
         return this._dropEnabled;
      }
      
      public function set dropEnabled(param1:Boolean) : void
      {
         this._dropEnabled = param1;
      }
      
      public function applyDrop(param1:IDragTarget) : void
      {
         var _loc5_:int = 0;
         var _loc2_:ItemDataStub = param1.getDragData() as ItemDataStub;
         var _loc3_:IInventorySlot = param1 as IInventorySlot;
         var _loc4_:* = _loc3_.owner == this;
         if(!this._currentDropRenderer)
         {
            if(!_loc4_)
            {
               if(this._dropMode == MenuInventory.IMS_Shop)
               {
                  dispatchEvent(new GameEvent(GameEvent.CALL,"OnBuyItem",[_loc2_.id,_loc2_.quantity,-1]));
               }
               else if(this._dropMode == MenuInventory.IMS_Container)
               {
                  dispatchEvent(new GameEvent(GameEvent.CALL,"OnTransferItem",[_loc2_.id,_loc2_.quantity,-1]));
               }
               else if(this._dropMode == MenuInventory.IMS_Stash)
               {
                  dispatchEvent(new GameEvent(GameEvent.CALL,"OnTakeFromStash",[_loc2_.id]));
               }
               else
               {
                  dispatchEvent(new GameEvent(GameEvent.CALL,"OnUnequipItem",[_loc2_.id,-1]));
               }
            }
            return;
         }
         if(this._currentDropRenderer.isEmpty())
         {
            _loc5_ = this.getDropIndex(_loc2_.gridSize);
         }
         else
         {
            _loc5_ = int(this._currentDropRenderer.data.gridPosition);
         }
         if(_loc4_)
         {
            if(this._currentDropRenderer.isEmpty())
            {
               dispatchEvent(new GameEvent(GameEvent.CALL,"OnMoveItem",[_loc2_.id,_loc5_]));
            }
            else if(this._currentDropRenderer.data.id != _loc2_.id)
            {
               dispatchEvent(new GameEvent(GameEvent.CALL,"OnMoveItems",[_loc2_.id,_loc5_,this._currentDropRenderer.data.id,_loc3_.data.gridPosition]));
            }
         }
         else if(this._dropMode == MenuInventory.IMS_Shop)
         {
            dispatchEvent(new GameEvent(GameEvent.CALL,"OnBuyItem",[_loc2_.id,_loc2_.quantity,_loc5_]));
         }
         else if(this._dropMode == MenuInventory.IMS_Container)
         {
            dispatchEvent(new GameEvent(GameEvent.CALL,"OnTransferItem",[_loc2_.id,_loc2_.quantity,_loc5_]));
         }
         else if(this._dropMode == MenuInventory.IMS_Stash)
         {
            dispatchEvent(new GameEvent(GameEvent.CALL,"OnTakeFromStash",[_loc2_.id]));
         }
         else if(this._currentDropRenderer.isEmpty())
         {
            dispatchEvent(new GameEvent(GameEvent.CALL,"OnUnequipItem",[uint(_loc2_.id),int(_loc5_)]));
         }
         else if(CommonUtils.checkSlotsCompatibility(this._currentDropRenderer.data.slotType,_loc3_.data.slotType))
         {
            dispatchEvent(new GameEvent(GameEvent.CALL,"OnSwapItems",[this._currentDropRenderer.data.id,_loc2_.id,_loc3_.data.slotType]));
         }
         _cachedSelection = this._currentDropRenderer.index;
         this.removeUselessRows();
         if(this._currentDropRenderer)
         {
            dispatchItemClickEvent(this._currentDropRenderer);
         }
      }
      
      public function canDrop(param1:IDragTarget) : Boolean
      {
         return true;
      }
      
      public function get dropSelection() : Boolean
      {
         return this._dropSelection;
      }
      
      public function set dropSelection(param1:Boolean) : void
      {
         this._dropSelection = param1;
      }
      
      public function processOver(param1:SlotDragAvatar) : int
      {
         var _loc4_:IInventorySlot = null;
         var _loc5_:* = false;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:IInventorySlot = null;
         var _loc9_:Class = null;
         var _loc10_:IInventorySlot = null;
         var _loc11_:Boolean = false;
         var _loc12_:String = null;
         var _loc13_:Boolean = false;
         var _loc14_:int = 0;
         var _loc15_:IInventorySlot = null;
         var _loc16_:int = 0;
         var _loc2_:int = int(SlotDragAvatar.ACTION_NONE);
         var _loc3_:Boolean = false;
         if(param1)
         {
            _loc5_ = (_loc4_ = param1.getSourceContainer() as IInventorySlot).owner == this;
            if(!this._highlightIndicator)
            {
               _loc9_ = getDefinitionByName(HIGHLIGHT_REF) as Class;
               this._highlightIndicator = new _loc9_() as MovieClip;
               this._highlightCanvas.addChild(this._highlightIndicator);
            }
            _loc6_ = int(param1.data.gridSize);
            if((_loc7_ = this.getDropIndex(_loc6_)) < 0 || _loc7_ > _renderers.length)
            {
               this._currentDropRenderer = null;
               return SlotDragAvatar.ACTION_NONE;
            }
            _loc8_ = _renderers[_loc7_] as IInventorySlot;
            this._currentDropRenderer = _loc8_;
            if(_loc8_)
            {
               if(!this.isSectionCorrect(_loc8_.index,_loc4_.data))
               {
                  this._currentDropRenderer = null;
                  _loc11_ = false;
                  _loc12_ = HIGHLIGHT_LABEL_DENIDED;
                  _loc2_ = int(SlotDragAvatar.ACTION_ERROR);
               }
               else
               {
                  _loc11_ = false;
                  _loc12_ = HIGHLIGHT_LABEL_ACCEPT;
                  _loc13_ = Boolean(_loc8_.isEmpty());
                  _loc2_ = int(SlotDragAvatar.ACTION_GRID_DROP);
                  if(Boolean(_loc8_.uplink) && _loc8_.uplink.data.id != _loc4_.data.id)
                  {
                     this._currentDropRenderer = null;
                     if(_loc5_)
                     {
                        _loc12_ = HIGHLIGHT_LABEL_DENIDED;
                        _loc2_ = int(SlotDragAvatar.ACTION_ERROR);
                     }
                     else
                     {
                        _loc12_ = HIGHLIGHT_LABEL_ACCEPT;
                        _loc11_ = true;
                        _loc2_ = int(SlotDragAvatar.ACTION_GRID_DROP);
                     }
                  }
                  else if(!_loc13_)
                  {
                     _loc2_ = int(SlotDragAvatar.ACTION_GRID_SWAP);
                     if(this.dropMode == MenuInventory.IMS_Shop && !_loc5_)
                     {
                        _loc11_ = false;
                        _loc2_ = int(SlotDragAvatar.ACTION_GRID_DROP);
                     }
                     else if(Boolean(_loc4_) && (_loc4_.owner != this || _loc8_.data.gridSize != _loc4_.data.gridSize))
                     {
                        if(!CommonUtils.checkSlotsCompatibility(_loc8_.data.slotType,_loc4_.data.slotType))
                        {
                           this._currentDropRenderer = null;
                           if(_loc5_)
                           {
                              _loc12_ = HIGHLIGHT_LABEL_DENIDED;
                              _loc2_ = int(SlotDragAvatar.ACTION_ERROR);
                           }
                           else
                           {
                              _loc12_ = HIGHLIGHT_LABEL_ACCEPT;
                              _loc11_ = true;
                              _loc2_ = int(SlotDragAvatar.ACTION_GRID_DROP);
                           }
                        }
                     }
                  }
               }
               if(this._currentDropRenderer != null && _loc6_ > 1)
               {
                  _loc14_ = _loc7_ + this._columns;
                  while(_loc14_ > _renderers.length)
                  {
                     this.addRow();
                  }
                  if(!(_loc15_ = _renderers[_loc14_] as IInventorySlot).isEmpty() && _loc15_.data.id != _loc4_.data.id)
                  {
                     this._currentDropRenderer = null;
                     if(_loc5_)
                     {
                        _loc12_ = HIGHLIGHT_LABEL_DENIDED;
                        _loc2_ = int(SlotDragAvatar.ACTION_ERROR);
                     }
                     else
                     {
                        _loc12_ = HIGHLIGHT_LABEL_NONE;
                        _loc2_ = int(SlotDragAvatar.ACTION_GRID_DROP);
                     }
                  }
               }
               _loc10_ = _loc8_;
               if(_loc11_)
               {
                  _loc16_ = this.findItemPlace(_loc4_.data);
                  _loc10_ = _renderers[_loc16_] as IInventorySlot;
               }
               if(this.mcStateDropTarget)
               {
                  this.mcStateDropTarget.visible = true;
               }
               this._highlightIndicator.x = _loc10_.x;
               this._highlightIndicator.y = _loc10_.y;
               this._highlightIndicator.width = this.gridSquareSize;
               this._highlightIndicator.height = this.gridSquareSize * _loc6_;
               this._highlightIndicator.gotoAndStop(_loc12_);
               this._highlightIndicator.visible = true;
            }
         }
         else if(this._highlightIndicator)
         {
            this._highlightCanvas.removeChild(this._highlightIndicator);
            this._highlightIndicator = null;
            if(this.mcStateDropTarget)
            {
               this.mcStateDropTarget.visible = false;
            }
         }
         return _loc2_;
      }
      
      protected function isSectionCorrect(param1:int, param2:ItemDataStub) : Boolean
      {
         var _loc3_:ItemSectionData = null;
         var _loc4_:int = 0;
         if(param2.sectionId < 0)
         {
            return true;
         }
         _loc3_ = this.getItemSection(param2.sectionId);
         if(_loc3_)
         {
            if((_loc4_ = this.getColumn(param1)) < _loc3_.start || _loc4_ > _loc3_.end)
            {
               return false;
            }
            return true;
         }
         return false;
      }
      
      protected function handleSlotChanged(param1:ListEvent) : void
      {
         var _loc4_:Number = NaN;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         if(!this.handleScrollBar)
         {
            return;
         }
         var _loc2_:SlotBase = param1.itemRenderer as SlotBase;
         if(_loc2_)
         {
            _loc4_ = Number(this.scrollBar.position);
            _loc5_ = _loc2_.y;
            _loc6_ = _loc2_.gridSize * this._gridSquareSize;
            if(_loc5_ + _loc6_ > this._gridRenderHeight + _loc4_)
            {
               this.scrollBar.position = _loc5_ + _loc6_ - this._gridRenderHeight;
            }
            else if(_loc5_ < _loc4_)
            {
               this.scrollBar.position = _loc5_;
            }
         }
         var _loc3_:SlotInventoryGrid = param1.itemRenderer as SlotInventoryGrid;
         if(_loc3_)
         {
            dispatchEvent(new GameEvent(GameEvent.CALL,"OnInventoryItemSelected",[_loc3_.data.id]));
         }
         this.updateScrollBar();
      }
      
      protected function currentDropIsPossible(param1:ItemDataStub) : Boolean
      {
         return true;
      }
      
      protected function getDropRenderer() : IInventorySlot
      {
         return this._currentDropRenderer;
      }
      
      protected function getDropIndex(param1:int = 1) : int
      {
         var _loc6_:IBaseSlot = null;
         var _loc2_:int = Math.min(this._columns - 1,Math.ceil(mouseX / this.gridSquareSize) - 1);
         var _loc3_:int = param1 == 2 ? int(this.gridSquareSize / 2) : 0;
         var _loc4_:int = Math.ceil((mouseY - _loc3_ + this._offset) / this.gridSquareSize) - 1;
         var _loc5_:int;
         if((_loc5_ = _loc2_ + _loc4_ * this._columns) > -1 && _loc5_ < _renderers.length)
         {
            if(_loc6_ = _renderers[_loc5_] as IBaseSlot)
            {
               return _loc6_.index;
            }
         }
         return -1;
      }
      
      public function get scrollBar() : Object
      {
         return this._scrollBar;
      }
      
      public function set scrollBar(param1:Object) : void
      {
         this._scrollBarValue = param1;
         invalidate(InvalidationType.SCROLL_BAR);
      }
      
      public function get scrollPosition() : uint
      {
         return this.offset;
      }
      
      public function set scrollPosition(param1:uint) : void
      {
         this.offset = param1;
      }
      
      public function get gridSquareSize() : Number
      {
         return this._gridSquareSize;
      }
      
      public function set gridSquareSize(param1:Number) : void
      {
         this._gridSquareSize = param1;
      }
      
      public function get elementGridSquareOffset() : Number
      {
         return this._elementGridSquareOffset;
      }
      
      public function set elementGridSquareOffset(param1:Number) : void
      {
         this._elementGridSquareOffset = param1;
      }
      
      public function get rows() : uint
      {
         return this._rows;
      }
      
      public function set rows(param1:uint) : void
      {
         this._rows = param1;
      }
      
      public function get columns() : uint
      {
         return this._columns;
      }
      
      public function set columns(param1:uint) : void
      {
         this._columns = param1;
      }
      
      public function get offset() : uint
      {
         return this._offset;
      }
      
      public function set offset(param1:uint) : void
      {
         if(param1 > -1)
         {
            this._offset = param1;
         }
         _canvas.y = -this._offset;
         this.validateRenderersSpecial();
         this._highlightCanvas.y = _canvas.y;
         this.updateScrollBar();
      }
      
      public function getRendererNoUplink(param1:uint) : IListItemRenderer
      {
         if(param1 < 0 || param1 >= _renderers.length)
         {
            return null;
         }
         return _renderers[param1] as IListItemRenderer;
      }
      
      override public function getRendererAt(param1:uint, param2:int = 0) : IListItemRenderer
      {
         if(param1 < 0 || param1 >= _renderers.length)
         {
            return null;
         }
         var _loc3_:IInventorySlot = _renderers[param1] as IInventorySlot;
         while(Boolean(_loc3_) && Boolean(_loc3_.uplink))
         {
            _loc3_ = _loc3_.uplink;
         }
         return _loc3_ as IBaseSlot;
      }
      
      protected function saveItemPosition(param1:ItemDataStub) : void
      {
         if(!this._ignoreGridPosition)
         {
            dispatchEvent(new GameEvent(GameEvent.CALL,"OnSaveItemGridPosition",[param1.id,param1.gridPosition]));
         }
      }
      
      override protected function draw() : void
      {
         super.draw();
         if(isInvalid(InvalidationType.SCROLL_BAR))
         {
            this.createScrollBar();
            this.updateScrollBar();
         }
         if(isInvalid(InvalidationType.DATA))
         {
            this.updateScrollBar();
         }
      }
      
      public function calculateColumnsAndRows(param1:uint) : void
      {
         if(this.gridSquareSize > 0)
         {
            this.columns = Math.floor(this.actualWidth / this.gridSquareSize);
            if(this.columns < 1)
            {
               this.columns = 1;
            }
         }
         this.rows = Math.ceil(param1 / this.columns);
      }
      
      public function getSlotByID(param1:int) : SlotBase
      {
         var _loc2_:int = 0;
         _loc2_ = 0;
         while(_loc2_ < _renderers.length)
         {
            if(_renderers[_loc2_].data && _renderers[_loc2_].data.id == param1)
            {
               return _renderers[_loc2_] as SlotBase;
            }
            _loc2_++;
         }
         return null;
      }
      
      override public function updateItems(param1:Array) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:IBaseSlot = null;
         this._specialCachedSelection = !!_cachedSelection ? _cachedSelection : selectedIndex;
         selectedIndex = -1;
         this.lastSelectedSection = -1;
         for each(_loc2_ in param1)
         {
            for each(_loc4_ in _renderers)
            {
               if(!_loc4_.isEmpty() && _loc4_.data.id == _loc2_.id && _loc4_.data.gridPosition != _loc2_.gridPosition)
               {
                  _loc4_.cleanup();
                  break;
               }
            }
         }
         for each(_loc3_ in param1)
         {
            this.appendItemData(_loc3_,InputManager.getInstance().isGamepad());
         }
         if(this._specialCachedSelection != -1)
         {
            ReselectIndexIfInvalid(this._specialCachedSelection);
            this._specialCachedSelection = -1;
         }
         validateNow();
         this.updateScrollBar();
      }
      
      override public function updateItemData(param1:Object) : void
      {
         this._specialCachedSelection = !!_cachedSelection ? _cachedSelection : selectedIndex;
         selectedIndex = -1;
         this.appendItemData(param1);
         if(this._specialCachedSelection != -1)
         {
            ReselectIndexIfInvalid(this._specialCachedSelection);
            this._specialCachedSelection = -1;
         }
         validateNow();
         this.updateScrollBar();
      }
      
      override public function removeItem(param1:uint, param2:Boolean = false) : void
      {
         var _loc3_:int = this.removeItemData(param1);
         if(!param2)
         {
            this._specialCachedSelection = selectedIndex;
            if(selectedIndex == _loc3_)
            {
               ReselectIndexIfInvalid(_loc3_);
            }
         }
         validateNow();
         this.updateScrollBar();
      }
      
      protected function appendItemData(param1:Object, param2:Boolean = false) : void
      {
         var _loc3_:ItemDataStub = param1 as ItemDataStub;
         if(_loc3_)
         {
            this.removeItemData(_loc3_.id);
            this.populateItemData(_loc3_,!InputManager.getInstance().isGamepad(),param2);
            this.removeUselessRows();
         }
      }
      
      protected function removeItemData(param1:uint) : int
      {
         var _loc3_:IInventorySlot = null;
         var _loc2_:* = getIdIndex(param1);
         if(_loc2_ > -1)
         {
            _loc3_ = _renderers[_loc2_] as IInventorySlot;
            this.removeUplinks(_loc3_);
            _loc3_.cleanup();
            _loc3_.data = null;
            --_renderersCount;
         }
         this.removeUselessRows();
         return _loc2_;
      }
      
      protected function removeUplinks(param1:IInventorySlot) : void
      {
         var _loc4_:IInventorySlot = null;
         var _loc2_:int = int(_renderers.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            if((_loc4_ = _renderers[_loc3_] as IInventorySlot).uplink == param1)
            {
               _loc4_.uplink = null;
            }
            _loc3_++;
         }
      }
      
      override protected function populateData() : void
      {
         var _loc1_:Boolean = false;
         var _loc2_:Boolean = false;
         var _loc3_:* = undefined;
         var _loc4_:int = 0;
         var _loc5_:ItemDataStub = null;
         var _loc6_:int = 0;
         var _loc7_:* = undefined;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:Object = null;
         var _loc11_:Array = null;
         var _loc12_:int = 0;
         var _loc13_:ItemDataStub = null;
         var _loc14_:ItemSectionData = null;
         var _loc15_:int = 0;
         var _loc16_:Array = null;
         var _loc17_:ItemSectionData = null;
         var _loc18_:Array = null;
         var _loc19_:int = 0;
         var _loc20_:int = 0;
         var _loc21_:int = 0;
         var _loc22_:int = 0;
         var _loc23_:int = 0;
         var _loc24_:IInventorySlot = null;
         var _loc25_:int = 0;
         var _loc26_:int = 0;
         var _loc27_:IInventorySlot = null;
         var _loc28_:Array = null;
         super.populateData();
         if(_data)
         {
            this.updateColumnsPaddingMap();
            _loc1_ = InputManager.getInstance().isGamepad();
            _loc2_ = !_loc1_ && !this.ignoreNextGridPosition;
            _loc3_ = selectedIndex;
            if(_loc2_)
            {
               data.sortOn("gridPosition",Array.NUMERIC | Array.DESCENDING);
            }
            else
            {
               this.ignoreNextGridPosition = false;
               this.sortList(data);
            }
            this.cleanUpRenderers();
            _loc4_ = 0;
            for each(_loc5_ in _data)
            {
               _loc4_ += _loc5_.gridSize;
            }
            _loc6_ = Math.ceil(_loc4_ / this._columns) * this._columns;
            while(_loc6_ > _renderers.length)
            {
               _renderers.push(this.spawnRenderer(_renderers.length));
            }
            if(_loc1_)
            {
               _loc9_ = 0;
               _loc10_ = {};
               if((_loc12_ = !!this._itemSectionsList ? int(this._itemSectionsList.length) : -1) > 0)
               {
                  _loc7_ = 0;
                  while(_loc7_ < _loc12_)
                  {
                     _loc15_ = (_loc14_ = this._itemSectionsList[_loc7_]).end - _loc14_.start + 1;
                     _loc16_ = [];
                     _loc8_ = 0;
                     while(_loc8_ < _loc15_)
                     {
                        _loc16_[_loc8_] = 0;
                        _loc8_++;
                     }
                     _loc10_[_loc7_] = _loc16_;
                     _loc7_++;
                  }
               }
               else
               {
                  _loc11_ = [];
                  _loc8_ = 0;
                  while(_loc8_ < this.columns)
                  {
                     _loc11_.push(0);
                     _loc8_++;
                  }
               }
               for each(_loc13_ in _data)
               {
                  _loc17_ = this.getItemSection(_loc13_.sectionId);
                  if(_loc12_ > 0)
                  {
                     _loc18_ = _loc10_[_loc13_.sectionId];
                  }
                  else
                  {
                     _loc18_ = _loc11_;
                  }
                  if(_loc18_)
                  {
                     _loc19_ = int(_loc18_.length);
                     _loc20_ = 0;
                     _loc21_ = int(_loc18_[0]);
                     _loc7_ = 1;
                     while(_loc7_ < _loc19_)
                     {
                        _loc25_ = int(_loc18_[_loc7_]);
                        if(_loc21_ > _loc25_)
                        {
                           _loc21_ = _loc25_;
                           _loc20_ = _loc7_;
                        }
                        _loc7_++;
                     }
                     _loc18_[_loc20_] += 1;
                     _loc23_ = (_loc22_ = !!_loc17_ ? int(_loc17_.start) : 0) + _loc20_ + _loc21_ * this.numColumns;
                     _loc24_ = this.getRendererNoUplink(_loc23_) as IInventorySlot;
                     while(!_loc24_)
                     {
                        this.addRow();
                        _loc24_ = this.getRendererNoUplink(_loc23_) as IInventorySlot;
                     }
                     _loc13_.gridPosition = _loc23_;
                     _loc24_.data = _loc13_;
                     ++_renderersCount;
                     if(_loc13_.gridSize > 1)
                     {
                        _loc18_[_loc20_] += 1;
                        _loc26_ = _loc23_ + this._columns;
                        while(_loc26_ >= _renderers.length)
                        {
                           this.addRow();
                        }
                        (_loc27_ = _renderers[_loc26_] as IInventorySlot).uplink = _loc24_;
                     }
                  }
               }
            }
            else
            {
               _loc28_ = new Array();
               for each(_loc5_ in _data)
               {
                  if(_loc2_ && _loc5_.gridPosition < 0)
                  {
                     _loc28_.push(_loc5_);
                  }
                  else
                  {
                     this.populateItemData(_loc5_,_loc2_);
                  }
               }
               if(_loc28_.length > 0)
               {
                  this.sortList(_loc28_);
                  for each(_loc5_ in _loc28_)
                  {
                     this.populateItemData(_loc5_,false);
                  }
               }
            }
         }
         if(this._initFindSelection || _loc3_ == -1)
         {
            findSelection();
         }
         else
         {
            ReselectIndexIfInvalid(_loc3_);
         }
         invalidate(InvalidationType.SCROLL_BAR);
         this.removeUselessRows();
         this.validateRenderersSpecial();
      }
      
      public function setCurrentSort(param1:int) : void
      {
         if(this._lastSetSort != param1)
         {
            this._lastSetSort = param1;
         }
      }
      
      protected function sortList(param1:Array) : void
      {
         if(!param1)
         {
            return;
         }
         switch(this._lastSetSort)
         {
            case MenuInventory.INV_SORT_MODE_INVALID:
            case MenuInventory.INV_SORT_MODE_TYPE:
               param1.sort(this.inventorySorter_Type);
               break;
            case MenuInventory.INV_SORT_MODE_PRICE:
               param1.sort(this.inventorySorter_Price);
               break;
            case MenuInventory.INV_SORT_MODE_WEIGHT:
               param1.sort(this.inventorySorter_Weight);
               break;
            case MenuInventory.INV_SORT_MODE_DURABILTIY:
               param1.sort(this.inventorySorter_Durability);
               break;
            case MenuInventory.INV_SORT_MODE_RARITY:
               param1.sort(this.inventorySorter_Rarity);
         }
      }
      
      protected function inventorySorter_Type(param1:ItemDataStub, param2:ItemDataStub) : Number
      {
         if(param1.isNew && !param2.isNew)
         {
            return -1;
         }
         if(!param1.isNew && param2.isNew)
         {
            return 1;
         }
         if(param1.sortGroup != param2.sortGroup)
         {
            return param1.sortGroup > param2.sortGroup ? 1 : -1;
         }
         if(param1.disableAction && !param2.disableAction)
         {
            return 1;
         }
         if(!param1.disableAction && param2.disableAction)
         {
            return -1;
         }
         if(param1.category == "edibles" && param2.category != "edibles")
         {
            return 1;
         }
         if(param1.category != "edibles" && param2.category == "edibles")
         {
            return -1;
         }
         if(param1.isEquipped && !param2.isEquipped)
         {
            return -1;
         }
         if(!param1.isEquipped && param2.isEquipped)
         {
            return 1;
         }
         if(param1.slotType != param2.slotType)
         {
            if(param1.slotType == InventorySlotType.InvalidSlot)
            {
               return 1;
            }
            if(param2.slotType == InventorySlotType.InvalidSlot)
            {
               return -1;
            }
            return InventorySlotType.getSortingWeight(param1.slotType) - InventorySlotType.getSortingWeight(param2.slotType);
         }
         if(param1.category != param2.category)
         {
            return param1.category > param2.category ? -1 : 1;
         }
         if(param1.quality != param2.quality)
         {
            return param2.quality - param1.quality;
         }
         return param1.id - param2.id;
      }
      
      protected function inventorySorter_Price(param1:ItemDataStub, param2:ItemDataStub) : Number
      {
         if(param1.isNew && !param2.isNew)
         {
            return -1;
         }
         if(!param1.isNew && param2.isNew)
         {
            return 1;
         }
         if(param1.price != param2.price)
         {
            return param2.price - param1.price;
         }
         return this.inventorySorter_Type(param1,param2);
      }
      
      protected function inventorySorter_Weight(param1:ItemDataStub, param2:ItemDataStub) : Number
      {
         if(param1.isNew && !param2.isNew)
         {
            return -1;
         }
         if(!param1.isNew && param2.isNew)
         {
            return 1;
         }
         if(param1.weight != param2.weight)
         {
            return param2.weight - param1.weight;
         }
         return this.inventorySorter_Type(param1,param2);
      }
      
      protected function inventorySorter_Durability(param1:ItemDataStub, param2:ItemDataStub) : Number
      {
         if(param1.isNew && !param2.isNew)
         {
            return -1;
         }
         if(!param1.isNew && param2.isNew)
         {
            return 1;
         }
         if(param1.durability != param2.durability)
         {
            return param1.durability - param2.durability;
         }
         return this.inventorySorter_Type(param1,param2);
      }
      
      protected function inventorySorter_Rarity(param1:ItemDataStub, param2:ItemDataStub) : Number
      {
         if(param1.isNew && !param2.isNew)
         {
            return -1;
         }
         if(!param1.isNew && param2.isNew)
         {
            return 1;
         }
         if(param1.quality != param2.quality)
         {
            return param2.quality - param1.quality;
         }
         return this.inventorySorter_Type(param1,param2);
      }
      
      protected function tryRestoreItemPosition(param1:ItemDataStub) : int
      {
         var _loc2_:int = 0;
         var _loc3_:IBaseSlot = null;
         if(this._cachedItemPositions)
         {
            _loc2_ = int(this._cachedItemPositions[param1.id]);
            if(_loc2_)
            {
               _loc3_ = this.getRendererAt(_loc2_) as IBaseSlot;
               if(Boolean(_loc3_) && _loc3_.isEmpty())
               {
                  return _loc2_;
               }
            }
         }
         return -1;
      }
      
      protected function populateItemData(param1:ItemDataStub, param2:Boolean, param3:Boolean = false) : IInventorySlot
      {
         var _loc7_:int = 0;
         var _loc8_:IInventorySlot = null;
         if(param1.invisible)
         {
            return null;
         }
         var _loc4_:int = param1.gridPosition;
         if(param1.gridPosition < 0 || !param2 || !this.isItemPlaceValid(param1.gridPosition,param1.gridSize,param1.sectionId))
         {
            param1.gridPosition = this.findItemPlace(param1);
         }
         var _loc5_:int = param1.gridPosition;
         var _loc6_:IInventorySlot = this.getRendererAt(_loc5_) as IInventorySlot;
         while(!_loc6_)
         {
            this.addRow();
            _loc6_ = this.getRendererAt(_loc5_) as IInventorySlot;
         }
         if(!_loc6_.isEmpty() && _loc6_.data.id != param1.id && !param3)
         {
            param1.gridPosition = this.findItemPlace(param1);
            _loc6_ = this.getRendererAt(_loc5_) as IInventorySlot;
         }
         if(param1.gridPosition != _loc4_)
         {
            this.saveItemPosition(param1);
         }
         _loc6_.data = param1;
         ++_renderersCount;
         if(param1.gridSize > 1)
         {
            _loc7_ = _loc5_ + this._columns;
            while(_loc7_ >= _renderers.length)
            {
               this.addRow();
            }
            (_loc8_ = _renderers[_loc7_] as IInventorySlot).uplink = _loc6_;
         }
         return _loc6_;
      }
      
      protected function isItemPlaceValid(param1:int, param2:int, param3:int = -1) : Boolean
      {
         var _loc5_:ItemSectionData = null;
         var _loc6_:int = 0;
         var _loc7_:* = undefined;
         if(param3 != -1)
         {
            if(_loc5_ = this.getItemSection(param3))
            {
               if((_loc6_ = this.getColumn(param1)) < _loc5_.start || _loc6_ > _loc5_.end)
               {
                  return false;
               }
            }
         }
         if(param1 >= _renderers.length)
         {
            return true;
         }
         var _loc4_:SlotBase;
         if((_loc4_ = _renderers[param1] as SlotBase).isEmpty() && (_loc4_ as IInventorySlot).uplink == null)
         {
            if(param2 <= 1)
            {
               return true;
            }
            if((_loc7_ = param1 + this._columns) >= _renderers.length || _renderers[_loc7_].isEmpty())
            {
               return true;
            }
         }
         return false;
      }
      
      protected function getSectionRenderers(param1:int) : Vector.<IBaseSlot>
      {
         var _loc5_:IBaseSlot = null;
         var _loc2_:int = int(_renderers.length);
         var _loc3_:Vector.<IBaseSlot> = new Vector.<IBaseSlot>();
         var _loc4_:int = 0;
         while(_loc4_ < _loc2_)
         {
            if(!(_loc5_ = _renderers[_loc4_]).isEmpty() && _loc5_.data.sectionId == param1)
            {
               _loc3_.push(_loc5_);
            }
            _loc4_++;
         }
         return _loc3_;
      }
      
      protected function getSectionByRendererIdx(param1:int) : ItemSectionData
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:* = undefined;
         var _loc5_:ItemSectionData = null;
         if(this._itemSectionsList)
         {
            _loc2_ = int(this._itemSectionsList.length);
            _loc3_ = this.getColumn(param1);
            _loc4_ = 0;
            while(_loc4_ < _loc2_)
            {
               if((_loc5_ = this._itemSectionsList[_loc4_] as ItemSectionData) && _loc3_ >= _loc5_.start && _loc3_ <= _loc5_.end)
               {
                  return _loc5_;
               }
               _loc4_++;
            }
         }
         return null;
      }
      
      protected function getItemSection(param1:int) : ItemSectionData
      {
         var _loc2_:int = 0;
         var _loc3_:* = undefined;
         var _loc4_:ItemSectionData = null;
         if(this._itemSectionsList)
         {
            _loc2_ = int(this._itemSectionsList.length);
            _loc3_ = 0;
            while(_loc3_ < _loc2_)
            {
               if((Boolean(_loc4_ = this._itemSectionsList[_loc3_] as ItemSectionData)) && _loc4_.id == param1)
               {
                  return _loc4_;
               }
               _loc3_++;
            }
         }
         return null;
      }
      
      override public function applySelectionContext() : void
      {
         var _loc5_:ItemSectionData = null;
         var _loc6_:Number = NaN;
         super.applySelectionContext();
         if(!this._itemSectionsList)
         {
            return;
         }
         var _loc1_:ItemSectionData = this.getSectionByRendererIdx(_selectedIndex);
         var _loc2_:int = -1;
         if(_loc1_)
         {
            _loc2_ = int(_loc1_.id);
         }
         this.lastSelectedSection = _loc2_;
         var _loc3_:int = int(this._itemSectionsList.length);
         var _loc4_:* = 0;
         while(_loc4_ < _loc3_)
         {
            if((Boolean(_loc5_ = this._itemSectionsList[_loc4_] as ItemSectionData)) && Boolean(_loc5_.border))
            {
               _loc6_ = 1;
               if(_activeSelectionVisible)
               {
                  _loc6_ = _loc5_.id == this.lastSelectedSection ? 2 : 1;
               }
               else
               {
                  _loc6_ = 1;
               }
               _loc5_.border.gotoAndStop(_loc6_);
            }
            _loc4_++;
         }
      }
      
      protected function findItemPlace(param1:ItemDataStub, param2:uint = 0) : int
      {
         var _loc3_:int = this.getFreeRendererIdx(param1);
         if(_loc3_ > -1)
         {
            return _loc3_;
         }
         if(param2 > this.DEBUG_REC_LIMIT)
         {
            throw new Error("Can\'t find place for item in the grid. Something is realy wrong!");
         }
         this.addRow();
         return this.findItemPlace(param1,param2 + 1);
      }
      
      protected function getFreeRendererIdx(param1:ItemDataStub) : int
      {
         var _loc2_:uint = _renderers.length;
         var _loc3_:uint = uint(param1.gridSize);
         var _loc4_:int = 0;
         while(_loc4_ < _loc2_)
         {
            if(this.isItemPlaceValid(_loc4_,param1.gridSize,param1.sectionId))
            {
               return _loc4_;
            }
            _loc4_++;
         }
         return -1;
      }
      
      protected function isUplink(param1:int) : Boolean
      {
         var _loc2_:IInventorySlot = _renderers[param1] as IInventorySlot;
         if(_loc2_)
         {
            return _loc2_.uplink != null;
         }
         return false;
      }
      
      protected function addRow() : void
      {
         var _loc1_:int = int(_renderers.length);
         var _loc2_:int = _loc1_ + this._columns;
         while(_loc1_ < _loc2_)
         {
            _renderers.push(this.spawnRenderer(_renderers.length));
            _loc1_++;
         }
         invalidate(InvalidationType.SCROLL_BAR);
      }
      
      protected function removeUselessRows() : void
      {
         var _loc5_:IBaseSlot = null;
         var _loc6_:ItemDataStub = null;
         var _loc7_:IInventorySlot = null;
         var _loc1_:uint = this._numRowsVisible;
         this.highestRowNeeded = 0;
         var _loc2_:int = int(_renderers.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            if((Boolean(_loc5_ = _renderers[_loc3_])) && !_loc5_.isEmpty())
            {
               _loc6_ = _loc5_.data as ItemDataStub;
               this.highestRowNeeded = _loc6_.gridPosition / this._columns + _loc6_.gridSize;
               if(this.highestRowNeeded > _loc1_)
               {
                  _loc1_ = this.highestRowNeeded;
               }
            }
            _loc3_++;
         }
         this.highestRowNeeded = _loc1_;
         var _loc4_:* = _loc1_ * this._columns;
         while(_loc4_ > _renderers.length)
         {
            this.addRow();
         }
         while(_loc4_ < _renderers.length)
         {
            _loc7_ = _renderers.pop() as IInventorySlot;
            this._discardedRendererPool.push(_loc7_);
            if(_loc7_)
            {
               _loc7_.cleanup();
               _canvas.removeChild(_loc7_ as DisplayObject);
            }
         }
         invalidate(InvalidationType.SCROLL_BAR);
      }
      
      private function createInitRenderers() : void
      {
         var _loc2_:IInventorySlot = null;
         this._totalRenderers = this.rows * this.columns;
         _renderers = new Vector.<IBaseSlot>(this._totalRenderers);
         var _loc1_:int = this._totalRenderers - 1;
         while(_loc1_ >= 0)
         {
            _loc2_ = this.spawnRenderer(_loc1_);
            _renderers[_loc1_] = _loc2_;
            _loc1_--;
         }
      }
      
      public function updateRendererBounds() : void
      {
         if(this.gridMask)
         {
            this._renderBounds = this.gridMask.getBounds(stage);
            invalidateData();
         }
      }
      
      protected function get renderBounds() : Rectangle
      {
         if(!this.ignoreValidationOpt && this._renderBounds == null && Boolean(this.gridMask))
         {
            this._renderBounds = this.gridMask.getBounds(stage);
         }
         return this._renderBounds;
      }
      
      private function spawnRenderer(param1:uint) : IInventorySlot
      {
         var _loc2_:IInventorySlot = null;
         if(this._discardedRendererPool.length > 0)
         {
            _loc2_ = this._discardedRendererPool.pop();
         }
         else
         {
            _loc2_ = new _slotRendererRef() as IInventorySlot;
         }
         _loc2_.index = param1;
         if(_loc2_ is SlotBase)
         {
            (_loc2_ as SlotBase).name = "Instance: " + String(param1);
            (_loc2_ as SlotBase).validationBounds = this.renderBounds;
         }
         _loc2_.useContextMgr = this._useContextMgr;
         _canvas.addChild(_loc2_ as DisplayObject);
         this.repositionRenderer(param1,_loc2_);
         setupRenderer(_loc2_);
         return _loc2_;
      }
      
      private function repositionRenderer(param1:int, param2:IInventorySlot) : *
      {
         var _loc3_:int = this.getColumn(param1);
         var _loc4_:int = this.getRow(param1);
         var _loc5_:uint = 0;
         if(this._paddingsMap)
         {
            _loc5_ = this._paddingsMap[_loc3_] * SECTION_PADDING;
         }
         param2.x = _loc3_ * this._gridSquareSize + this._elementGridSquareOffset * _loc3_ + _loc5_;
         param2.y = _loc4_ * this._gridSquareSize + this._elementGridSquareOffset * _loc4_;
      }
      
      private function cleanUpRenderers() : void
      {
         var _loc1_:IInventorySlot = null;
         for each(_loc1_ in _renderers)
         {
            if(_loc1_)
            {
               _loc1_.cleanup();
            }
         }
         _renderersCount = 0;
      }
      
      protected function scrollList(param1:int) : void
      {
         this.scrollPosition -= param1;
      }
      
      protected function handleScroll(param1:Event) : void
      {
         this.scrollPosition = this._scrollBar.position;
      }
      
      protected function validateRenderersSpecial() : void
      {
         var _loc1_:SlotBase = null;
         var _loc2_:int = int(this._numRowsVisible * this._columns);
         var _loc3_:* = 0;
         while(_loc3_ < _renderers.length)
         {
            _loc1_ = _renderers[_loc3_] as SlotBase;
            if(Boolean(_loc1_) && _loc1_.awaitingCompleteValidation)
            {
               _loc1_.validateNow();
               if(_loc3_ <= _loc2_ && _loc1_ && _loc1_.awaitingCompleteValidation)
               {
                  _loc1_.forceValidateNow();
               }
            }
            _loc3_++;
         }
      }
      
      protected function onScroll(param1:MouseEvent) : void
      {
         if(this._maxOffset > 0)
         {
            if(param1.delta > 0)
            {
               this._scrollBar.position -= CommonConstants.INVENTORY_GRID_SIZE;
            }
            else
            {
               this._scrollBar.position += CommonConstants.INVENTORY_GRID_SIZE;
            }
         }
      }
      
      override protected function handleRightJoystick(param1:Number) : *
      {
         if(this.handlesRightJoystick)
         {
            if(this._maxOffset > 0)
            {
               this._scrollBar.position -= param1 * 40;
            }
         }
      }
      
      protected function createScrollBar() : void
      {
         if(!this._scrollBar && Boolean(this._scrollBarValue))
         {
            this._scrollBar = parent.getChildByName(this._scrollBarValue.toString()) as IScrollBar;
            this._scrollBar.addEventListener(Event.SCROLL,this.handleScroll,false,0,true);
            this._scrollBar.addEventListener(Event.CHANGE,this.handleScroll,false,0,true);
            this._scrollBar.focusTarget = this;
            this._scrollBar.tabEnabled = false;
         }
      }
      
      protected function updateScrollBar() : void
      {
         var _loc1_:ScrollIndicator = null;
         var _loc2_:Number = NaN;
         if(this._scrollBar != null)
         {
            _loc1_ = this._scrollBar as ScrollIndicator;
            _loc2_ = this._rows * this._gridSquareSize;
            this._maxOffset = (this.highestRowNeeded - this._rows) * this._gridSquareSize;
            this._maxOffset = Math.max(0,this._maxOffset);
            if(!this._maxOffset || !visible)
            {
               _loc1_.visible = false;
               _loc1_.setScrollProperties(0,0,0);
            }
            else
            {
               _loc1_.visible = true;
               _loc1_.setScrollProperties(_loc2_,0,this._maxOffset);
            }
            this._scrollBar.position = this.scrollPosition;
            this._scrollBar.validateNow();
         }
      }
      
      override public function handleInputNavSimple(param1:InputEvent) : void
      {
         var _loc5_:IBaseSlot = null;
         var _loc6_:Sprite = null;
         var _loc7_:ItemSectionData = null;
         var _loc8_:int = 0;
         var _loc9_:Vector.<IBaseSlot> = null;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:* = new Namespace("");
         var _loc13_:SlotBase = null;
         var _loc14_:Rectangle = null;
         if(param1.handled)
         {
            return;
         }
         var _loc2_:InputDetails = param1.details as InputDetails;
         var _loc3_:Boolean = false;
         var _loc4_:Boolean = _loc2_.navEquivalent == NavigationCode.RIGHT_STICK_LEFT || _loc2_.navEquivalent == NavigationCode.RIGHT_STICK_RIGHT;
         if(this._itemSectionsList && this._itemSectionsList.length > 0 && _loc4_ && param1.details.value != InputValue.KEY_UP)
         {
            if(_loc5_ = getSelectedRenderer() as IBaseSlot)
            {
               if(_loc6_ = (_loc5_ as Sprite).parent as Sprite)
               {
                  _loc8_ = int((_loc7_ = this.getSectionByRendererIdx(selectedIndex)).id);
                  while(!_loc3_ && _loc8_ < this._itemSectionsList.length && _loc8_ >= 0)
                  {
                     switch(_loc2_.navEquivalent)
                     {
                        case NavigationCode.RIGHT_STICK_LEFT:
                           _loc8_--;
                           break;
                        case NavigationCode.RIGHT_STICK_RIGHT:
                           _loc8_++;
                     }
                     if(_loc8_ < this._itemSectionsList.length && _loc8_ >= 0)
                     {
                        _loc10_ = int((_loc9_ = this.getSectionRenderers(_loc8_)).length);
                        _loc11_ = 0;
                        while(_loc11_ < _loc10_)
                        {
                           _loc12_ = -10;
                           (_loc14_ = (_loc13_ = _loc9_[_loc11_] as SlotBase).getGlobalSlotRect()).inflate(_loc12_,_loc12_);
                           if(Boolean(_loc13_) && this.renderBounds.intersects(_loc14_))
                           {
                              selectedIndex = _loc13_.index;
                              _loc3_ = true;
                              break;
                           }
                           _loc11_++;
                        }
                     }
                  }
               }
            }
         }
         if(_loc3_)
         {
            param1.handled = true;
         }
         super.handleInputNavSimple(param1);
      }
      
      override public function getColumn(param1:int) : int
      {
         if(param1 < 0)
         {
            return -1;
         }
         return param1 % this._columns;
      }
      
      override public function getRow(param1:int) : int
      {
         if(param1 < 0)
         {
            return -1;
         }
         return param1 / this.columns;
      }
      
      override public function toString() : String
      {
         return "[SlotsListGrid " + name + "]";
      }
      
      override public function GetDropdownListHeight() : Number
      {
         return this._rows * this.gridSquareSize + ITEM_PADDING;
      }
   }
}
