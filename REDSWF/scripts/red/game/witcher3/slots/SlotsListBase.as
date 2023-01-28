package red.game.witcher3.slots
{
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.utils.Dictionary;
   import flash.utils.getDefinitionByName;
   import red.core.constants.KeyCode;
   import red.game.witcher3.interfaces.IBaseSlot;
   import red.game.witcher3.interfaces.IDragTarget;
   import red.game.witcher3.interfaces.IInventorySlot;
   import red.game.witcher3.interfaces.IScrollingList;
   import red.game.witcher3.managers.InputManager;
   import red.game.witcher3.menus.common.ItemDataStub;
   import red.game.witcher3.utils.CommonUtils;
   import red.game.witcher3.utils.Math2;
   import scaleform.clik.constants.InputValue;
   import scaleform.clik.constants.InvalidationType;
   import scaleform.clik.constants.NavigationCode;
   import scaleform.clik.core.UIComponent;
   import scaleform.clik.events.InputEvent;
   import scaleform.clik.events.ListEvent;
   import scaleform.clik.interfaces.IListItemRenderer;
   import scaleform.clik.managers.FocusHandler;
   import scaleform.clik.ui.InputDetails;
   import scaleform.gfx.Extensions;
   import scaleform.gfx.FocusManager;
   import scaleform.gfx.MouseEventEx;
   
   public class SlotsListBase extends UIComponent implements IScrollingList
   {
       
      
      protected var _canvas:Sprite;
      
      protected var _selectedIndex:int = -1;
      
      protected var _data:Array;
      
      protected var _renderers:Vector.<IBaseSlot>;
      
      protected var _cachedSelection:int;
      
      protected var _mouseContext:IBaseSlot;
      
      protected var _selectionContext:IBaseSlot;
      
      protected var _slotRenderer:String;
      
      protected var _slotRendererRef:Class;
      
      protected var _renderersCount:int;
      
      protected var _lastLeftAxisX:Number;
      
      protected var _lastLeftAxisY:Number;
      
      public var ignoreSelectable:Boolean = false;
      
      public var filterKeyCodeFunction:Function;
      
      public var filterNavCodeFunction:Function;
      
      protected var _activeSelectionVisible:Boolean = true;
      
      public var allowSimpleNavDPad:Boolean = true;
      
      public function SlotsListBase()
      {
         super();
         this._data = [];
         this._renderers = new Vector.<IBaseSlot>();
         this._canvas = new Sprite();
         addChild(this._canvas);
         focusable = true;
         this._selectedIndex = -1;
         this._renderersCount = 0;
         tabEnabled = false;
         tabChildren = false;
      }
      
      public function getRenderersCount() : int
      {
         return this._renderersCount;
      }
      
      public function getRenderersLength() : int
      {
         return this._renderers.length;
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         addEventListener(InputEvent.INPUT,this.handleInput,false,0,true);
      }
      
      public function get slotRendererName() : String
      {
         return this._slotRenderer;
      }
      
      public function set slotRendererName(param1:String) : void
      {
         var value:String = param1;
         if(this._slotRenderer != value)
         {
            this._slotRenderer = value;
            try
            {
               this._slotRendererRef = getDefinitionByName(this._slotRenderer) as Class;
            }
            catch(er:Error)
            {
            }
         }
      }
      
      public function get data() : Array
      {
         return this._data;
      }
      
      public function set data(param1:Array) : void
      {
         this._data = param1;
         invalidateData();
      }
      
      public function stableDataUpdate(param1:Array) : void
      {
      }
      
      public function get numColumns() : uint
      {
         return 0;
      }
      
      public function get numRows() : uint
      {
         return Math.ceil(this._renderers.length / this.numColumns);
      }
      
      public function get rendererHeight() : Number
      {
         if(this._renderers.length > 0)
         {
            return this._renderers[0].height;
         }
         return 0;
      }
      
      public function get selectedColumn() : int
      {
         if(this.selectedIndex >= 0 && this.numColumns > 0)
         {
            return this.selectedIndex % this.numColumns;
         }
         return -1;
      }
      
      public function updateItemData(param1:Object) : void
      {
      }
      
      public function removeItem(param1:uint, param2:Boolean = false) : void
      {
      }
      
      public function updateItems(param1:Array) : void
      {
      }
      
      public function findSelection() : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc1_:int = !!this._cachedSelection ? this._cachedSelection : this.selectedIndex;
         var _loc2_:IBaseSlot = this.getRendererAt(_loc1_) as IBaseSlot;
         if(!_loc2_ || _loc2_ && !_loc2_.selectable)
         {
            _loc1_ = -1;
            _loc3_ = int(this._renderers.length);
            _loc4_ = 0;
            while(_loc4_ < _loc3_)
            {
               if(Boolean(this._renderers[_loc4_]) && Boolean(this._renderers[_loc4_].selectable))
               {
                  _loc1_ = _loc4_;
                  break;
               }
               _loc4_++;
            }
         }
         else
         {
            _loc1_ = int(_loc2_.index);
         }
         this.selectedIndex = _loc1_;
      }
      
      public function GetDropdownListHeight() : Number
      {
         return 0;
      }
      
      public function getSelectedRenderer() : IListItemRenderer
      {
         if(this._selectedIndex < 0 || this._selectedIndex >= this._renderers.length)
         {
            return null;
         }
         return this._renderers[this._selectedIndex] as IListItemRenderer;
      }
      
      public function getRendererIndex(param1:IListItemRenderer) : int
      {
         return this._renderers.indexOf(param1);
      }
      
      public function getRendererAt(param1:uint, param2:int = 0) : IListItemRenderer
      {
         if(param1 < 0 || param1 >= this._renderers.length)
         {
            return null;
         }
         return this._renderers[param1];
      }
      
      override protected function draw() : void
      {
         if(isInvalid(InvalidationType.DATA))
         {
            this.populateData();
         }
      }
      
      protected function populateData() : void
      {
      }
      
      public function get activeSelectionVisible() : Boolean
      {
         return this._activeSelectionVisible;
      }
      
      public function set activeSelectionVisible(param1:Boolean) : void
      {
         if(this._activeSelectionVisible != param1)
         {
            this._activeSelectionVisible = param1;
            this.updateActiveSelectionVisible();
            this.applySelectionContext();
         }
      }
      
      public function updateActiveSelectionVisible() : void
      {
         var _loc1_:int = 0;
         var _loc2_:SlotBase = null;
         _loc1_ = 0;
         while(_loc1_ < this._renderers.length)
         {
            _loc2_ = this._renderers[_loc1_] as SlotBase;
            if(_loc2_)
            {
               _loc2_.activeSelectionEnabled = this._activeSelectionVisible;
            }
            _loc1_++;
         }
      }
      
      public function handleInputPreset(param1:InputEvent) : void
      {
         var _loc5_:SlotBase = null;
         var _loc6_:* = undefined;
         var _loc7_:SlotBase = null;
         if(param1.handled)
         {
            return;
         }
         var _loc2_:InputDetails = param1.details;
         var _loc3_:Boolean = _loc2_.value == InputValue.KEY_DOWN || _loc2_.value == InputValue.KEY_HOLD;
         CommonUtils.convertWASDCodeToNavEquivalent(_loc2_);
         var _loc4_:String = _loc2_.fromJoystick || this.allowSimpleNavDPad ? _loc2_.navEquivalent : NavigationCode.INVALID;
         if(_loc3_)
         {
            switch(_loc4_)
            {
               case NavigationCode.UP:
               case NavigationCode.DOWN:
               case NavigationCode.LEFT:
               case NavigationCode.RIGHT:
                  if(_loc5_ = this.getSelectedRenderer() as SlotBase)
                  {
                     if((_loc6_ = _loc5_.GetNavigationIndex(_loc4_)) != -1)
                     {
                        if((_loc7_ = this.getRendererAt(_loc6_) as SlotBase).selectable || this.ignoreSelectable)
                        {
                           this.selectedIndex = _loc6_;
                           param1.handled = true;
                        }
                        else if((_loc6_ = this.SearchForNearestSelectableIndexInDirection(_loc4_)) != -1)
                        {
                           this.selectedIndex = _loc6_;
                           param1.handled = true;
                        }
                     }
                  }
            }
         }
      }
      
      public function SearchForNearestSelectableIndexInDirection(param1:String) : int
      {
         var _loc7_:SlotBase = null;
         var _loc8_:int = 0;
         var _loc2_:Number = -1;
         var _loc3_:Number = -1;
         var _loc4_:Number = -1;
         var _loc5_:Number = -1;
         var _loc6_:SlotBase;
         if(!(_loc6_ = this.getSelectedRenderer() as SlotBase))
         {
            return -1;
         }
         switch(param1)
         {
            case NavigationCode.UP:
               _loc5_ = _loc6_.y;
               break;
            case NavigationCode.DOWN:
               _loc4_ = _loc6_.y;
               break;
            case NavigationCode.LEFT:
               _loc3_ = _loc6_.x;
               break;
            case NavigationCode.RIGHT:
               _loc2_ = _loc6_.x;
         }
         var _loc9_:Number = 0;
         var _loc10_:Number = Number.MAX_VALUE;
         var _loc11_:SlotBase = null;
         var _loc12_:* = false;
         if(_loc6_.data && Boolean(_loc6_.data.hasOwnProperty("gridSize")))
         {
            _loc12_ = _loc6_.data.gridSize < 2;
         }
         _loc8_ = 0;
         while(_loc8_ < this._renderers.length)
         {
            if((_loc7_ = this._renderers[_loc8_] as SlotBase) != _loc6_ && (_loc7_.selectable || this.ignoreSelectable) && (_loc5_ == -1 || _loc7_.y < _loc5_) && (_loc4_ == -1 || _loc7_.y > _loc4_ || _loc7_.y == _loc4_ && _loc12_ && _loc7_.data.gridSize > 1) && (_loc3_ == -1 || _loc7_.x < _loc3_) && (_loc2_ == -1 || _loc7_.x > _loc2_))
            {
               if((_loc9_ = Math.sqrt(Math.pow(_loc6_.x - _loc7_.x,2) + Math.pow(_loc6_.y - _loc7_.y,2))) < _loc10_)
               {
                  _loc10_ = _loc9_;
                  _loc11_ = _loc7_;
               }
            }
            _loc8_++;
         }
         if(_loc11_ != null)
         {
            return this._renderers.indexOf(_loc11_);
         }
         return -1;
      }
      
      public function handleInputNavSimple(param1:InputEvent) : void
      {
         var _loc11_:SlotBase = null;
         if(param1.handled)
         {
            return;
         }
         var _loc2_:InputDetails = param1.details;
         if(_loc2_.code == KeyCode.PAD_LEFT_STICK_AXIS)
         {
            this._lastLeftAxisX = _loc2_.value.xvalue;
            this._lastLeftAxisY = _loc2_.value.yvalue;
            return;
         }
         var _loc3_:Boolean = _loc2_.value == InputValue.KEY_DOWN || _loc2_.value == InputValue.KEY_HOLD;
         CommonUtils.convertWASDCodeToNavEquivalent(_loc2_);
         var _loc4_:String = _loc2_.fromJoystick || this.allowSimpleNavDPad ? _loc2_.navEquivalent : NavigationCode.INVALID;
         if(!this.allowSimpleNavDPad)
         {
            switch(_loc2_.code)
            {
               case KeyCode.W:
               case KeyCode.UP:
                  _loc4_ = NavigationCode.UP;
                  break;
               case KeyCode.S:
               case KeyCode.DOWN:
                  _loc4_ = NavigationCode.DOWN;
                  break;
               case KeyCode.A:
               case KeyCode.LEFT:
                  _loc4_ = NavigationCode.LEFT;
                  break;
               case KeyCode.D:
               case KeyCode.RIGHT:
                  _loc4_ = NavigationCode.RIGHT;
            }
         }
         var _loc5_:int = this._selectedIndex == -1 ? -1 : int(Math.floor(this._selectedIndex / this.numColumns));
         var _loc6_:int = this._selectedIndex == -1 ? -1 : int(this._selectedIndex - _loc5_ * this.numColumns);
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = -1;
         var _loc10_:* = 1;
         if(_loc3_)
         {
            switch(_loc4_)
            {
               case NavigationCode.UP:
                  if(this._selectedIndex == -1)
                  {
                     this.findSelection();
                  }
                  else
                  {
                     _loc7_ = _loc5_ - 1;
                     while(_loc7_ >= 0)
                     {
                        if(this.searchUpDown(_loc7_,_loc6_,_loc5_,_loc10_))
                        {
                           param1.handled = true;
                           break;
                        }
                        _loc10_++;
                        _loc7_--;
                     }
                     if(!param1.handled)
                     {
                        if((_loc9_ = this.SearchForNearestSelectableIndexInDirection(_loc4_)) != -1 && this.selectRendererAtIndexIfValid(_loc9_))
                        {
                           param1.handled = true;
                        }
                     }
                  }
                  break;
               case NavigationCode.DOWN:
                  if(this._selectedIndex == -1)
                  {
                     this.findSelection();
                  }
                  else
                  {
                     if(this._renderers[this._selectedIndex] is SlotInventoryGrid && (this._renderers[this._selectedIndex] as SlotInventoryGrid).data.gridSize > 1)
                     {
                        _loc5_ += 1;
                     }
                     _loc7_ = _loc5_ + 1;
                     while(_loc7_ < this.numRows)
                     {
                        if(this.searchUpDown(_loc7_,_loc6_,_loc5_,_loc10_))
                        {
                           param1.handled = true;
                           break;
                        }
                        _loc10_++;
                        _loc7_++;
                     }
                     if(!param1.handled)
                     {
                        if((_loc9_ = this.SearchForNearestSelectableIndexInDirection(_loc4_)) != -1 && this.selectRendererAtIndexIfValid(_loc9_))
                        {
                           param1.handled = true;
                        }
                     }
                  }
                  break;
               case NavigationCode.LEFT:
                  if(this._selectedIndex == -1)
                  {
                     this.findSelection();
                  }
                  else
                  {
                     _loc8_ = _loc6_ - 1;
                     while(_loc8_ >= 0)
                     {
                        if(this.searchLeftRight(_loc8_,_loc6_,_loc5_,_loc10_))
                        {
                           param1.handled = true;
                           break;
                        }
                        _loc10_++;
                        _loc8_--;
                     }
                     if(!param1.handled)
                     {
                        if((_loc9_ = this.SearchForNearestSelectableIndexInDirection(_loc4_)) != -1 && this.selectRendererAtIndexIfValid(_loc9_))
                        {
                           param1.handled = true;
                        }
                     }
                  }
                  break;
               case NavigationCode.RIGHT:
                  if(this._selectedIndex == -1)
                  {
                     this.findSelection();
                  }
                  else
                  {
                     _loc8_ = _loc6_ + 1;
                     while(_loc8_ < this.numColumns)
                     {
                        if(this.searchLeftRight(_loc8_,_loc6_,_loc5_,_loc10_))
                        {
                           param1.handled = true;
                           break;
                        }
                        _loc10_++;
                        _loc8_++;
                     }
                     if(!param1.handled)
                     {
                        if((_loc9_ = this.SearchForNearestSelectableIndexInDirection(_loc4_)) != -1 && this.selectRendererAtIndexIfValid(_loc9_))
                        {
                           param1.handled = true;
                        }
                     }
                  }
            }
         }
         else if(_loc2_.code == KeyCode.PAD_RIGHT_STICK_AXIS)
         {
            this.handleRightJoystick(_loc2_.value.yvalue);
         }
         if(!param1.handled && _loc2_.value == InputValue.KEY_UP)
         {
            if(this.filterKeyCodeFunction != null && this.filterNavCodeFunction != null)
            {
               if(!this.filterKeyCodeFunction(param1.details.code) || !this.filterNavCodeFunction(param1.details.navEquivalent))
               {
                  return;
               }
            }
            if((Boolean(_loc11_ = this._renderers[this._selectedIndex] as SlotBase)) && !_loc11_.isEmpty())
            {
               _loc11_.executeAction(_loc2_.code,param1);
            }
         }
      }
      
      protected function searchLeftRight(param1:int, param2:int, param3:int, param4:int) : Boolean
      {
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 1;
         if(this._renderers[this._selectedIndex] != null && this._renderers[this._selectedIndex] is SlotInventoryGrid)
         {
            _loc8_ = int((this._renderers[this._selectedIndex] as SlotInventoryGrid).data.gridSize);
         }
         while(_loc5_ <= param4)
         {
            if(_loc5_ == 0)
            {
               if(this.selectRendererAtIndexIfValid(this.getIndexFromCoordinates(param3,param1)) || _loc8_ > 1 && this.selectRendererAtIndexIfValid(this.getIndexFromCoordinates(param3 + 1,param1)))
               {
                  return true;
               }
            }
            else
            {
               if(this._lastLeftAxisY < 0)
               {
                  _loc6_ = this.getIndexFromCoordinates(_loc8_ > 1 ? param3 + _loc5_ + 1 : param3 + _loc5_,param1);
                  _loc7_ = this.getIndexFromCoordinates(param3 - _loc5_,param1);
               }
               else
               {
                  _loc6_ = this.getIndexFromCoordinates(param3 - _loc5_,param1);
                  _loc7_ = this.getIndexFromCoordinates(_loc8_ > 1 ? param3 + _loc5_ + 1 : param3 + _loc5_,param1);
               }
               if(_loc6_ < 0 && _loc7_ < 0)
               {
                  break;
               }
               if(_loc6_ >= 0 && this.selectRendererAtIndexIfValid(_loc6_) || _loc7_ >= 0 && this.selectRendererAtIndexIfValid(_loc7_))
               {
                  return true;
               }
            }
            _loc5_++;
         }
         return false;
      }
      
      protected function searchUpDown(param1:int, param2:int, param3:int, param4:int) : Boolean
      {
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 1;
         if(this._renderers[this._selectedIndex] != null && this._renderers[this._selectedIndex] is SlotInventoryGrid)
         {
            _loc8_ = int((this._renderers[this._selectedIndex] as SlotInventoryGrid).data.gridSize);
         }
         while(_loc5_ <= param4)
         {
            if(_loc5_ == 0)
            {
               if(this.selectRendererAtIndexIfValid(this.getIndexFromCoordinates(param1,param2)))
               {
                  return true;
               }
            }
            else
            {
               if(this._lastLeftAxisX < 0)
               {
                  _loc6_ = this.getIndexFromCoordinates(param1,param2 - _loc5_);
                  _loc7_ = this.getIndexFromCoordinates(param1,param2 + _loc5_);
               }
               else
               {
                  _loc6_ = this.getIndexFromCoordinates(param1,param2 + _loc5_);
                  _loc7_ = this.getIndexFromCoordinates(param1,param2 - _loc5_);
               }
               if(_loc6_ < 0 && _loc7_ < 0)
               {
                  break;
               }
               if(_loc6_ >= 0 && this.selectRendererAtIndexIfValid(_loc6_) || _loc7_ >= 0 && this.selectRendererAtIndexIfValid(_loc7_))
               {
                  return true;
               }
            }
            _loc5_++;
         }
         return false;
      }
      
      public function getIndexFromCoordinates(param1:int, param2:int) : int
      {
         if(param1 >= 0 && param1 < this.numRows && param2 >= 0 && param2 < this.numColumns)
         {
            return this.numColumns * param1 + param2;
         }
         return -1;
      }
      
      public function selectRendererAtIndexIfValid(param1:int) : Boolean
      {
         var _loc4_:SlotInventoryGrid = null;
         var _loc2_:SlotBase = this.getRendererAt(param1) as SlotBase;
         var _loc3_:SlotBase = this.getRendererAt(this._selectedIndex) as SlotBase;
         if(_loc2_ && !_loc2_.isEmpty() && _loc3_ != _loc2_)
         {
            if((Boolean(_loc4_ = this._renderers[param1] as SlotInventoryGrid)) && _loc4_.uplink != null)
            {
               if(_loc4_.uplink as SlotInventoryGrid == _loc3_)
               {
                  return false;
               }
               _loc4_ = _loc4_.uplink as SlotInventoryGrid;
               this.selectedIndex = _loc4_.index;
               dispatchEvent(new ListEvent(ListEvent.INDEX_CHANGE,true,false,_loc4_.index,-1,-1,_loc4_,this.data));
            }
            else
            {
               this.selectedIndex = param1;
               dispatchEvent(new ListEvent(ListEvent.INDEX_CHANGE,true,false,param1,-1,-1,_loc2_,this));
            }
            return true;
         }
         return false;
      }
      
      public function traceGrid() : void
      {
         var _loc1_:* = null;
         var _loc6_:SlotInventoryGrid = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         _loc3_ = 0;
         while(_loc3_ < this.numRows)
         {
            _loc1_ = "GFX - |";
            _loc4_ = 0;
            while(_loc4_ < this.numColumns)
            {
               _loc2_ = this.getIndexFromCoordinates(_loc3_,_loc4_);
               _loc6_ = this.getRendererAt(_loc2_) as SlotInventoryGrid;
               if(_loc2_ == -1 || _loc2_ >= this._renderers.length)
               {
                  _loc1_ += " e |";
               }
               else if(_loc2_ == this._selectedIndex)
               {
                  _loc1_ += " s |";
               }
               else if(_loc6_)
               {
                  if((this._renderers[_loc2_] as IInventorySlot).uplink != null)
                  {
                     _loc1_ += " u |";
                  }
                  else if(_loc6_.isEmpty())
                  {
                     _loc1_ += " o |";
                  }
                  else
                  {
                     _loc1_ += " y |";
                  }
               }
               else if(!(this.getRendererAt(_loc2_) as SlotBase).isEmpty())
               {
                  _loc1_ += " x |";
               }
               else
               {
                  _loc1_ += " o |";
               }
               _loc4_++;
            }
            _loc3_++;
         }
         var _loc5_:int = 0;
         while(_loc5_ < this._renderersCount)
         {
            if(this._renderers[_loc5_] is IInventorySlot && (this._renderers[_loc5_] as IInventorySlot).uplink != null)
            {
            }
            _loc5_++;
         }
      }
      
      override public function handleInput(param1:InputEvent) : void
      {
         var _loc4_:SlotBase = null;
         super.handleInput(param1);
         var _loc2_:InputDetails = param1.details;
         var _loc3_:* = _loc2_.value == InputValue.KEY_UP;
         if(_loc3_ && !param1.handled)
         {
            if(this._selectedIndex > -1 && this._renderers.length && this._selectedIndex < this._renderers.length)
            {
               if(_loc4_ = this._renderers[this._selectedIndex] as SlotBase)
               {
                  _loc4_.executeAction(_loc2_.code,param1);
               }
            }
         }
      }
      
      protected function navigateTo(param1:IBaseSlot, param2:Number) : IBaseSlot
      {
         var _loc11_:IBaseSlot = null;
         var _loc12_:* = undefined;
         var _loc13_:IBaseSlot = null;
         var _loc14_:Number = NaN;
         var _loc15_:Number = NaN;
         var _loc16_:Number = NaN;
         var _loc17_:Number = NaN;
         var _loc18_:Number = NaN;
         var _loc19_:Number = NaN;
         var _loc20_:Number = NaN;
         var _loc21_:Number = NaN;
         var _loc22_:Number = NaN;
         var _loc23_:Number = NaN;
         var _loc3_:Number = param1.x + param1.width / 2;
         var _loc4_:Number = !!param1.data ? Number(param1.data.gridSize) : 2;
         var _loc5_:Number = param1.y + param1.height * _loc4_ / 2;
         var _loc6_:Point = new Point(_loc3_,_loc5_);
         var _loc7_:Dictionary = new Dictionary(true);
         var _loc8_:int = int(this._renderers.length);
         var _loc9_:int = 0;
         while(_loc9_ < _loc8_)
         {
            if((_loc13_ = this._renderers[_loc9_] as IBaseSlot) && _loc13_ != param1 && (Boolean(_loc13_.selectable) || this.ignoreSelectable))
            {
               _loc14_ = !!_loc13_.data ? Number(_loc13_.data.gridSize) : 2;
               _loc15_ = _loc13_.x + _loc13_.width / 2;
               _loc16_ = _loc13_.y + _loc13_.height * _loc14_ / 2;
               _loc17_ = _loc3_ - _loc15_;
               _loc18_ = _loc5_ - _loc16_;
               if((_loc19_ = Math.atan2(_loc18_,_loc17_)) > -Math.PI / 2 && _loc19_ <= Math.PI)
               {
                  _loc19_ -= Math.PI / 2;
               }
               else if(_loc19_ >= -Math.PI && _loc19_ <= -Math.PI / 2)
               {
                  _loc19_ += Math.PI * 3 / 2;
               }
               if((_loc20_ = this.getSector(param2,_loc19_)) <= Math.PI / 4)
               {
                  _loc21_ = Math2.getSegmentLength(_loc6_,new Point(_loc15_,_loc16_));
                  _loc22_ = Math.sin(_loc20_) * _loc21_;
                  _loc23_ = (_loc21_ + _loc22_) / 2;
                  _loc7_[_loc13_] = _loc23_;
               }
            }
            _loc9_++;
         }
         var _loc10_:Number = -1;
         for(_loc12_ in _loc7_)
         {
            if(_loc10_ > _loc7_[_loc12_] || _loc10_ == -1)
            {
               _loc10_ = Number(_loc7_[_loc12_]);
               _loc11_ = _loc12_ as IBaseSlot;
            }
         }
         return _loc11_;
      }
      
      protected function getSector(param1:Number, param2:Number) : Number
      {
         var _loc3_:Number = param1 >= 0 ? param1 : param1 + Math.PI * 2;
         var _loc4_:Number = param2 >= 0 ? param2 : param2 + Math.PI * 2;
         var _loc5_:Number;
         if((_loc5_ = Math.abs(_loc4_ - _loc3_)) > Math.PI)
         {
            _loc5_ = Math.abs(_loc5_ - Math.PI / 2);
         }
         return _loc5_;
      }
      
      protected function handleRightJoystick(param1:Number) : *
      {
      }
      
      public function tryExecuteAction(param1:InputEvent) : void
      {
         var _loc2_:SlotBase = null;
         if(this.filterKeyCodeFunction != null && this.filterNavCodeFunction != null)
         {
            if(!this.filterKeyCodeFunction(param1.details.code) || !this.filterNavCodeFunction(param1.details.navEquivalent))
            {
               return;
            }
         }
         if(param1.details.code == KeyCode.PAD_A_CROSS || param1.details.code == KeyCode.PAD_X_SQUARE)
         {
            if(this._selectedIndex >= 0 && this._selectedIndex < this._renderers.length)
            {
               _loc2_ = this._renderers[this._selectedIndex] as SlotBase;
               if(Boolean(_loc2_) && !_loc2_.isEmpty())
               {
                  _loc2_.executeAction(param1.details.code,param1);
                  return;
               }
            }
         }
         param1.handled = false;
      }
      
      protected function isNavigationKeyCode(param1:uint) : Boolean
      {
         switch(param1)
         {
            case KeyCode.UP:
            case KeyCode.DOWN:
            case KeyCode.RIGHT:
            case KeyCode.LEFT:
            case KeyCode.PAD_DIGIT_UP:
            case KeyCode.PAD_DIGIT_DOWN:
            case KeyCode.PAD_DIGIT_RIGHT:
            case KeyCode.PAD_DIGIT_LEFT:
               return true;
            default:
               return false;
         }
      }
      
      public function applySelectionContext() : void
      {
         var _loc2_:IBaseSlot = null;
         var _loc3_:Boolean = false;
         var _loc1_:SlotsTransferManager = SlotsTransferManager.getInstance();
         if(!InputManager.getInstance().isGamepad())
         {
            return;
         }
         if(this._selectedIndex <= -1 || focused < 1 && _focusable || !enabled)
         {
            _loc1_.hideDropTargets();
            return;
         }
         if(this._selectedIndex > -1 && this._selectedIndex < this._renderers.length)
         {
            _loc2_ = this._renderers[this._selectedIndex];
            _loc3_ = Boolean(_loc2_.selectable) || this.ignoreSelectable;
            if(!_loc3_ || !_loc2_.activeSelectionEnabled)
            {
               _loc1_.hideDropTargets();
               return;
            }
            _loc1_.showDropTargets(_loc2_ as IDragTarget);
            return;
         }
      }
      
      protected function setupRenderer(param1:IBaseSlot) : void
      {
         param1.owner = this;
         param1.enabled = enabled;
         param1.addEventListener(MouseEvent.MOUSE_DOWN,this.handleItemClick,false,0,true);
         param1.addEventListener(MouseEvent.MOUSE_UP,this.handleItemMouseUp,false,0,true);
         param1.addEventListener(MouseEvent.MOUSE_OVER,this.handleItemMouseOver,false,0,true);
         param1.addEventListener(MouseEvent.MOUSE_OUT,this.handleItemMouseOut,false,0,true);
      }
      
      protected function cleanUpRenderer(param1:IBaseSlot) : void
      {
         param1.owner = null;
         param1.removeEventListener(MouseEvent.MOUSE_DOWN,this.handleItemClick);
         param1.removeEventListener(MouseEvent.MOUSE_UP,this.handleItemMouseUp);
         param1.removeEventListener(MouseEvent.MOUSE_OVER,this.handleItemMouseOver);
         param1.removeEventListener(MouseEvent.MOUSE_OUT,this.handleItemMouseOut);
      }
      
      public function clearRenderers() : void
      {
         var _loc1_:int = 0;
         _loc1_ = 0;
         while(_loc1_ < this._renderers.length)
         {
            this.cleanUpRenderer(this._renderers[_loc1_]);
            (this._renderers[_loc1_] as UIComponent).parent.removeChild(this._renderers[_loc1_] as UIComponent);
            _loc1_++;
         }
         this._renderers.length = 0;
         this._renderersCount = 0;
      }
      
      public function get itemClickEnabled() : Boolean
      {
         return true;
      }
      
      protected function handleItemClick(param1:MouseEvent) : void
      {
         if(!this.itemClickEnabled)
         {
            return;
         }
         var _loc2_:IBaseSlot = param1.currentTarget as IBaseSlot;
         if(!_loc2_ && param1.currentTarget && Boolean(param1.currentTarget.parent))
         {
            _loc2_ = param1.currentTarget.parent as IBaseSlot;
         }
         if(_loc2_)
         {
            this.dispatchItemClickEvent(_loc2_);
         }
      }
      
      protected function handleItemMouseOver(param1:MouseEvent) : void
      {
         var _loc2_:IListItemRenderer = null;
         if(enabled)
         {
            _loc2_ = param1.currentTarget as IListItemRenderer;
            if(_loc2_)
            {
               dispatchEvent(new ListEvent(ListEvent.ITEM_ROLL_OVER,true,false,_loc2_.index,-1,-1,_loc2_,this.data));
            }
         }
      }
      
      protected function handleItemMouseOut(param1:MouseEvent) : void
      {
         var _loc2_:IListItemRenderer = null;
         if(enabled)
         {
            _loc2_ = param1.currentTarget as IListItemRenderer;
            if(_loc2_)
            {
               dispatchEvent(new ListEvent(ListEvent.ITEM_ROLL_OUT,true,false,_loc2_.index,-1,-1,_loc2_,this.data));
            }
         }
      }
      
      protected function handleItemMouseUp(param1:MouseEvent) : void
      {
         if(!this.itemClickEnabled)
         {
            return;
         }
         var _loc2_:IBaseSlot = param1.currentTarget as IBaseSlot;
         if(!_loc2_ && param1.currentTarget && Boolean(param1.currentTarget.parent))
         {
            _loc2_ = param1.currentTarget.parent as IBaseSlot;
         }
         var _loc3_:MouseEventEx = param1 as MouseEventEx;
         var _loc4_:SlotInventoryGrid;
         if((_loc4_ = _loc2_ as SlotInventoryGrid) && _loc3_ && _loc3_.buttonIdx == MouseEventEx.RIGHT_BUTTON)
         {
            _loc4_.tryExecuteAssignedAction();
         }
      }
      
      public function dispatchItemClickEvent(param1:IBaseSlot) : void
      {
         this.selectedIndex = param1.index;
         if(focused < 1)
         {
            this.focused = 1;
         }
         var _loc2_:ListEvent = new ListEvent(ListEvent.ITEM_CLICK,true);
         _loc2_.itemData = param1.data as Object;
         _loc2_.index = param1.index;
         _loc2_.itemRenderer = param1;
         dispatchEvent(_loc2_);
      }
      
      override public function set enabled(param1:Boolean) : void
      {
         var _loc2_:int = int(this._renderers.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            this._renderers[_loc3_].enabled = param1;
            _loc3_++;
         }
         super.enabled = param1;
         this.applySelectionContext();
      }
      
      override public function set focused(param1:Number) : void
      {
         if(param1 == _focused || !_focusable)
         {
            return;
         }
         _focused = param1;
         if(Extensions.isScaleform)
         {
            if(_focused > 0)
            {
               FocusManager.setFocus(this,0);
               FocusHandler.getInstance().setFocus(this);
               if(this.selectedIndex > -1 && enabled)
               {
                  (this._renderers[this.selectedIndex] as SlotBase).showTooltip();
               }
            }
         }
         else if(stage != null && _focused > 0)
         {
            stage.focus = this;
         }
      }
      
      public function trySelectClosestItem(param1:Point) : Boolean
      {
         return this.trySelectClosestItemFromList(param1,this._renderers);
      }
      
      protected function trySelectClosestItemFromList(param1:Point, param2:Vector.<IBaseSlot>) : Boolean
      {
         var _loc3_:IBaseSlot = CommonUtils.getClosestSlot(param1,param2);
         if(_loc3_)
         {
            this.selectedIndex = _loc3_.index;
            return true;
         }
         return false;
      }
      
      public function NumNonEmptyRenderers() : int
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         _loc1_ = 0;
         while(_loc1_ < this._renderers.length)
         {
            if(!this._renderers[_loc1_].isEmpty())
            {
               _loc2_++;
            }
            _loc1_++;
         }
         return _loc2_;
      }
      
      public function ReselectIndexIfInvalid(param1:int = -1) : void
      {
         var _loc2_:int = 0;
         var _loc3_:SlotBase = null;
         var _loc4_:int = 0;
         var _loc5_:SlotBase = null;
         var _loc6_:int = 0;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         if(param1 >= 0 && param1 < this._renderers.length)
         {
            _loc5_ = this._renderers[param1] as SlotBase;
            _loc4_ = param1;
         }
         else
         {
            _loc5_ = this.getSelectedRenderer() as SlotBase;
            param1 = this.selectedIndex;
            _loc4_ = this.selectedIndex;
         }
         if(_loc5_)
         {
            if(!_loc5_.selectable)
            {
               _loc6_ = -1;
               _loc7_ = Number.MAX_VALUE;
               _loc8_ = Number.MAX_VALUE;
               if(_loc4_ > 0)
               {
                  _loc3_ = this._renderers[_loc4_ - 1] as SlotBase;
                  if(Boolean(_loc3_) && _loc3_.selectable)
                  {
                     _loc7_ = Math.sqrt(Math.pow(_loc3_.x - _loc5_.x,2) + Math.pow(_loc3_.y - _loc5_.y,2));
                     if(_loc8_ > _loc7_ || _loc7_ == _loc8_ && _loc3_.y == _loc5_.y && _loc3_.x > _loc5_.x)
                     {
                        _loc8_ = _loc7_;
                        _loc6_ = _loc4_ - 1;
                     }
                  }
               }
               if(_loc4_ < this._renderers.length - 1)
               {
                  _loc3_ = this._renderers[_loc4_ + 1] as SlotBase;
                  if(Boolean(_loc3_) && _loc3_.selectable)
                  {
                     _loc7_ = Math.sqrt(Math.pow(_loc3_.x - _loc5_.x,2) + Math.pow(_loc3_.y - _loc5_.y,2));
                     if(_loc8_ > _loc7_ || _loc7_ == _loc8_ && _loc3_.y == _loc5_.y && _loc3_.x > _loc5_.x)
                     {
                        _loc8_ = _loc7_;
                        _loc6_ = _loc4_ + 1;
                     }
                  }
               }
               _loc2_ = 0;
               while(_loc2_ < this._renderers.length)
               {
                  _loc3_ = this._renderers[_loc2_] as SlotBase;
                  if(Boolean(_loc3_) && _loc3_.selectable)
                  {
                     _loc7_ = Math.sqrt(Math.pow(_loc3_.x - _loc5_.x,2) + Math.pow(_loc3_.y - _loc5_.y,2));
                     if(_loc8_ > _loc7_ || _loc7_ == _loc8_ && _loc3_.y == _loc5_.y && _loc3_.x > _loc5_.x)
                     {
                        _loc8_ = _loc7_;
                        _loc6_ = _loc2_;
                     }
                  }
                  _loc2_++;
               }
               if(_loc6_ != -1)
               {
                  this.selectedIndex = _loc6_;
                  return;
               }
            }
            else if(param1 != -1)
            {
               if((Boolean(_loc5_ = this._renderers[param1] as SlotBase)) && _loc5_.selectable)
               {
                  this.selectedIndex = param1;
                  return;
               }
            }
         }
         this.findSelection();
      }
      
      public function get selectedIndex() : int
      {
         return this._selectedIndex;
      }
      
      public function set selectedIndex(param1:int) : void
      {
         var _loc2_:IBaseSlot = null;
         var _loc3_:SlotBase = null;
         if(this._renderers.length <= 0)
         {
            if(this._selectedIndex == -1)
            {
               this.applySelectionContext();
               return;
            }
            param1 = -1;
         }
         if(this._selectedIndex > -1 && this._selectedIndex < this._renderers.length)
         {
         }
         if(this._selectedIndex != param1)
         {
            this._cachedSelection = param1;
            if(param1 > -1 && param1 < this._renderers.length && !this._renderers[param1].selectable && !this.ignoreSelectable)
            {
               this.applySelectionContext();
               return;
            }
            if(this._selectedIndex > -1 && this._selectedIndex < this._renderers.length)
            {
               this._renderers[this._selectedIndex].selected = false;
            }
            this._selectedIndex = param1;
            if(this._selectedIndex > -1 && this._selectedIndex < this._renderers.length)
            {
               _loc2_ = this._renderers[this._selectedIndex];
               _loc2_.selected = true;
               this.fireListEvent(this._renderers[this._selectedIndex]);
            }
            else
            {
               this.fireListEvent(null);
            }
         }
         else if(this._selectedIndex > -1 && this._selectedIndex < this._renderers.length && !this._renderers[this._selectedIndex].selectable && !this.ignoreSelectable)
         {
            _loc3_ = this._renderers[this._selectedIndex] as SlotBase;
            if(_loc3_)
            {
               _loc3_.showTooltip();
            }
         }
         this.applySelectionContext();
      }
      
      protected function fireListEvent(param1:IBaseSlot) : void
      {
         var _loc2_:ListEvent = new ListEvent(ListEvent.INDEX_CHANGE);
         if(param1)
         {
            _loc2_.itemRenderer = param1;
            _loc2_.itemData = param1.data as Object;
            _loc2_.index = param1.index;
         }
         else
         {
            _loc2_.index = -1;
         }
         dispatchEvent(_loc2_);
      }
      
      protected function getDataIndex(param1:ItemDataStub) : int
      {
         if(param1)
         {
            return this.getIdIndex(param1.id);
         }
         return -1;
      }
      
      protected function getIdIndex(param1:uint, param2:int = -1) : int
      {
         var _loc5_:ItemDataStub = null;
         var _loc3_:int = int(this._renderers.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            if(this._renderers[_loc4_].data is ItemDataStub)
            {
               if((Boolean(_loc5_ = this._renderers[_loc4_].data as ItemDataStub)) && (_loc5_.id == param1 && (param2 < 0 || _loc5_.groupId == param2)))
               {
                  return _loc4_;
               }
            }
            _loc4_++;
         }
         return -1;
      }
      
      public function getRow(param1:int) : int
      {
         return -1;
      }
      
      public function getColumn(param1:int) : int
      {
         return -1;
      }
      
      override public function get scaleX() : Number
      {
         return super.actualScaleX;
      }
      
      override public function get scaleY() : Number
      {
         return super.actualScaleY;
      }
      
      override public function toString() : String
      {
         return "[SlotListBase " + name + "]";
      }
   }
}
