package red.game.witcher3.menus.gwint
{
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import red.game.witcher3.managers.InputManager;
   import red.game.witcher3.slots.SlotBase;
   import red.game.witcher3.slots.SlotsListBase;
   import scaleform.clik.constants.InvalidationType;
   import scaleform.clik.controls.ScrollIndicator;
   import scaleform.clik.events.ListEvent;
   import scaleform.clik.interfaces.IScrollBar;
   
   public class GwintCardGridList extends SlotsListBase
   {
       
      
      private var _widthPadding:int = 0;
      
      private var _heightPadding:int = 0;
      
      private var _baseXOffset:int = 0;
      
      private var _baseYOffset:int = 0;
      
      protected var _maxOffset:Number = 0;
      
      protected var _scrollBarValue:Object;
      
      protected var _scrollBar:IScrollBar;
      
      protected var _gridRenderHeight:int = 520;
      
      protected var _gridMask:MovieClip = null;
      
      private var _numColums:uint;
      
      private var _numRowsVisible:uint;
      
      protected var _rows:uint;
      
      protected var _offset:uint;
      
      public function GwintCardGridList()
      {
         super();
      }
      
      public function get widthPadding() : int
      {
         return this._widthPadding;
      }
      
      public function set widthPadding(param1:int) : void
      {
         this._widthPadding = param1;
      }
      
      public function get heightPadding() : int
      {
         return this._heightPadding;
      }
      
      public function set heightPadding(param1:int) : void
      {
         this._heightPadding = param1;
      }
      
      public function get baseXOffset() : int
      {
         return this._baseXOffset;
      }
      
      public function set baseXOffset(param1:int) : void
      {
         this._baseXOffset = param1;
      }
      
      public function get baseYOffset() : int
      {
         return this._baseYOffset;
      }
      
      public function set baseYOffset(param1:int) : void
      {
         this._baseYOffset = param1;
      }
      
      protected function get gridMask() : MovieClip
      {
         if(this._gridMask == null)
         {
            this._gridMask = parent.getChildByName("mcGridMask") as MovieClip;
         }
         return this._gridMask;
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         stage.addEventListener(MouseEvent.MOUSE_WHEEL,this.onScroll,false,0,true);
         if(this.gridMask)
         {
            this._gridRenderHeight = this.gridMask.height;
         }
         addEventListener(ListEvent.INDEX_CHANGE,this.handleSlotChanged,false,0,true);
      }
      
      override public function get numColumns() : uint
      {
         return this._numColums;
      }
      
      public function set numColumns(param1:uint) : void
      {
         this._numColums = param1;
      }
      
      public function get numRowsVisible() : uint
      {
         return this._numRowsVisible;
      }
      
      public function set numRowsVisible(param1:uint) : void
      {
         this._numRowsVisible = param1;
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
      
      public function get rows() : uint
      {
         return this._rows;
      }
      
      public function set rows(param1:uint) : void
      {
         this._rows = param1;
      }
      
      override public function getColumn(param1:int) : int
      {
         if(param1 < 0)
         {
            return -1;
         }
         return param1 % (this.numColumns - 1);
      }
      
      override public function getRow(param1:int) : int
      {
         if(param1 < 0)
         {
            return -1;
         }
         return Math.abs(param1 / this.numColumns);
      }
      
      override protected function populateData() : void
      {
         this.setupRenderers();
      }
      
      public function addRenderer(param1:Object) : void
      {
         this.spawnRenderer(param1);
         _renderersCount = _renderers.length;
         this.rows = Math.floor(_renderers.length / this.numColumns);
         data.push(param1);
         this.positionRenderers();
         this.updateScrollBar();
      }
      
      public function removeRenderer(param1:SlotBase) : void
      {
         var _loc2_:int = _renderers.indexOf(param1);
         var _loc3_:int = selectedIndex;
         this.selectedIndex = -1;
         if(_loc2_ != -1)
         {
            param1.cleanup();
            _canvas.removeChild(param1 as DisplayObject);
            _renderers.splice(_loc2_,1);
            _renderersCount = _renderers.length;
         }
         this.rows = Math.floor(_renderers.length / this.numColumns);
         _loc2_ = -1;
         var _loc4_:int = 0;
         while(_loc4_ < data.length)
         {
            if(data[_loc4_] == param1.data)
            {
               _loc2_ = _loc4_;
               break;
            }
            _loc4_++;
         }
         if(_loc2_ != -1)
         {
            data.splice(_loc2_,1);
         }
         this.positionRenderers();
         if(_loc3_ >= _renderers.length)
         {
            this.selectedIndex = _renderers.length - 1;
         }
         else
         {
            this.selectedIndex = _loc3_;
         }
         if(getSelectedRenderer() != null)
         {
            getSelectedRenderer().selected = true;
         }
         this.updateScrollBar();
      }
      
      override public function set selectedIndex(param1:int) : void
      {
         super.selectedIndex = param1;
      }
      
      private function setupRenderers() : void
      {
         this.adjustRendererCount();
         this.positionRenderers();
         this.updateRendererData();
         if(InputManager.getInstance().isGamepad())
         {
            this.selectedIndex = 0;
         }
      }
      
      protected function spawnRenderer(param1:Object = null) : SlotBase
      {
         var _loc2_:SlotBase = new _slotRendererRef() as SlotBase;
         if(_loc2_)
         {
            setupRenderer(_loc2_);
            _loc2_.useContextMgr = false;
            _canvas.addChild(_loc2_);
            _loc2_.index = _renderers.length;
            _renderers.push(_loc2_);
            if(param1 != null)
            {
               _loc2_.setData(param1);
            }
            _loc2_.activeSelectionEnabled = _activeSelectionVisible;
            return _loc2_;
         }
         throw new Error("GFX - unsupported _slotRendererRef() used: " + _slotRendererRef);
      }
      
      private function adjustRendererCount() : void
      {
         var _loc2_:SlotBase = null;
         var _loc1_:int = _data == null ? 0 : int(_data.length);
         if(_loc1_ < 0)
         {
            throw new Error("GFX - adjusting renderer count to an invalid value: " + _loc1_);
         }
         while(_renderers.length != _loc1_)
         {
            if(_renderers.length > _loc1_)
            {
               _loc2_ = _renderers.pop() as SlotBase;
               if(!_loc2_)
               {
                  throw new Error("GFX - trying to remove a slotRenderer of invalid type. Will NOT be properly removed!");
               }
               _loc2_.cleanup();
               _canvas.removeChild(_loc2_ as DisplayObject);
            }
            else
            {
               if(_renderers.length >= _loc1_)
               {
                  throw new Error("GFX - something has gone horribly wrong!");
               }
               this.spawnRenderer();
            }
         }
         _renderersCount = _renderers.length;
         this.rows = Math.floor(_renderersCount / this.numColumns);
      }
      
      public function positionRenderers() : void
      {
         var _loc1_:int = 0;
         var _loc4_:SlotBase = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         _loc1_ = 0;
         while(_loc1_ < _renderers.length)
         {
            (_loc4_ = _renderers[_loc1_] as SlotBase).index = _loc1_;
            _loc2_ = _loc1_ % this.numColumns;
            _loc3_ = Math.floor(_loc1_ / this.numColumns);
            _loc4_.x = this.baseXOffset + _loc2_ * this._widthPadding;
            _loc4_.y = this.baseYOffset + _loc3_ * this._heightPadding;
            _loc1_++;
         }
      }
      
      private function updateRendererData() : void
      {
         var _loc1_:int = 0;
         var _loc4_:SlotBase = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         _loc1_ = 0;
         while(_loc1_ < _renderers.length)
         {
            (_loc4_ = _renderers[_loc1_] as SlotBase).setData(_data[_loc1_]);
            _loc1_++;
         }
      }
      
      override public function applySelectionContext() : void
      {
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
         this.updateScrollBar();
      }
      
      public function get scrollPosition() : uint
      {
         return this.offset;
      }
      
      public function set scrollPosition(param1:uint) : void
      {
         this.offset = param1;
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
      
      protected function onScroll(param1:MouseEvent) : void
      {
         if(Boolean(this.gridMask) && this.gridMask.hitTestPoint(param1.stageX,param1.stageY))
         {
            if(this._maxOffset > 0)
            {
               if(param1.delta > 0)
               {
                  this._scrollBar.position -= this.heightPadding;
               }
               else
               {
                  this._scrollBar.position += this.heightPadding;
               }
            }
         }
      }
      
      protected function handleSlotChanged(param1:ListEvent) : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc2_:SlotBase = param1.itemRenderer as SlotBase;
         if(_loc2_)
         {
            _loc3_ = Number(this.scrollBar.position);
            if((_loc4_ = Math.floor(param1.itemRenderer.index / this.numColumns) * this.heightPadding) >= _loc3_ + this.numRowsVisible * this.heightPadding)
            {
               this.scrollBar.position = _loc4_ - (this.numRowsVisible - 1) * this.heightPadding;
            }
            else if(_loc4_ < _loc3_)
            {
               this.scrollBar.position = _loc4_;
            }
         }
         this.updateScrollBar();
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
      
      protected function handleScroll(param1:Event) : void
      {
         this.scrollPosition = this._scrollBar.position;
      }
      
      protected function updateScrollBar() : void
      {
         var _loc1_:ScrollIndicator = null;
         if(this._scrollBar != null)
         {
            _loc1_ = this._scrollBar as ScrollIndicator;
            this._maxOffset = Math.round(Math.ceil(_renderersCount / this.numColumns) - this.numRowsVisible) * this.heightPadding;
            this._maxOffset = Math.max(0,this._maxOffset);
            if(this._maxOffset <= 0 || !visible)
            {
               _loc1_.visible = false;
            }
            else
            {
               _loc1_.visible = true;
               _loc1_.setScrollProperties(this.numRowsVisible * this.heightPadding,0,this._maxOffset);
            }
            this._scrollBar.position = this.scrollPosition;
            this._scrollBar.validateNow();
         }
      }
   }
}
