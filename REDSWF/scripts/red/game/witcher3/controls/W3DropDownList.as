package red.game.witcher3.controls
{
   import com.gskinner.motion.GTween;
   import com.gskinner.motion.GTweener;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.utils.Dictionary;
   import red.core.events.GameEvent;
   import red.game.witcher3.interfaces.IBaseSlot;
   import red.game.witcher3.slots.SlotBase;
   import red.game.witcher3.slots.SlotsListBase;
   import red.game.witcher3.slots.SlotsListGrid;
   import red.game.witcher3.utils.CommonUtils;
   import scaleform.clik.controls.CoreList;
   import scaleform.clik.controls.ListItemRenderer;
   import scaleform.clik.controls.ScrollIndicator;
   import scaleform.clik.core.UIComponent;
   import scaleform.clik.data.DataProvider;
   import scaleform.clik.events.InputEvent;
   import scaleform.clik.events.ListEvent;
   import scaleform.clik.interfaces.IListItemRenderer;
   import scaleform.clik.ui.InputDetails;
   
   public class W3DropDownList extends W3ScrollingList
   {
       
      
      public var smoothScrolling:Boolean = false;
      
      public var itemRendererClass:String = "";
      
      protected var _inputHandlers:Vector.<UIComponent>;
      
      public var previousSelectedIndex:int = -1;
      
      private var _dropdownMenuScrollingList:String;
      
      private var _dropdownMenuItemRenderer:String;
      
      public var _scrollSpeed:Number = 40;
      
      public var _listWidth:Number = 1200;
      
      public var _listHeight:Number = 810;
      
      protected var _handleKeyUpInput:Boolean;
      
      protected var m_currentListHeight:Number = 0;
      
      protected var m_defaultPosition:Number;
      
      protected var m_lastScrollPosition:uint = 0;
      
      public var mcMask:MovieClip;
      
      public var mcEmptyListFeedback:MovieClip;
      
      private var lastSelectedColumn:uint = 0;
      
      public var menuName:String = "";
      
      public var restoreSelectionByTag:Boolean = false;
      
      public var updateSurgicallyOnDataSet:Boolean = false;
      
      protected var dataSetOnce:Boolean = false;
      
      private var _activeSelectionEnabled:Boolean = true;
      
      protected var _openRenderersList:Dictionary;
      
      protected var _bufScrollPos:Number;
      
      protected var _selectionIdx:int;
      
      protected var _subSelectionIdx:int;
      
      protected var _subSelectionTag:uint;
      
      protected var _bufSmoothScrolling:Boolean;
      
      protected var _selectTargetDownView:UIComponent;
      
      internal var hackCounter:int = 0;
      
      protected var scrollTweener:GTween;
      
      public function W3DropDownList()
      {
         super();
         this._inputHandlers = new Vector.<UIComponent>();
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         mouseChildren = true;
         stage.addEventListener(W3ScrollingList.REPOSITION,this.updatePosition,false,0,true);
         this.CreateMask();
         stage.addEventListener(MouseEvent.MOUSE_WHEEL,this.onScroll,false,0,true);
         this.m_defaultPosition = y;
         addEventListener(ListEvent.INDEX_CHANGE,this.handleSelectChange,false,0,true);
      }
      
      public function setMask(param1:MovieClip) : void
      {
         this.mcMask = param1;
      }
      
      override public function UpdateEmptyStateFeedback(param1:Boolean) : *
      {
         if(textField)
         {
            textField.visible = param1;
            if(param1)
            {
               textField.htmlText = this.GetPanelEmptyStateFeedbackDescription();
               textField.htmlText = CommonUtils.toUpperCaseSafe(textField.htmlText);
            }
         }
         if(this.mcEmptyListFeedback)
         {
            this.mcEmptyListFeedback.visible = param1;
            if(param1 && this.mcEmptyListFeedback.mcIcon && Boolean(this.menuName))
            {
               this.mcEmptyListFeedback.mcIcon.gotoAndStop(this.menuName);
            }
         }
      }
      
      protected function GetPanelEmptyStateFeedbackDescription() : String
      {
         return "[[panel_menu_empty_list_" + (!!this.menuName ? this.menuName.toLowerCase() : "") + "]]";
      }
      
      override public function toString() : String
      {
         return "[W3 W3DropDownList " + this.name + " ]";
      }
      
      public function get dropdownMenuScrollingList() : String
      {
         return this._dropdownMenuScrollingList;
      }
      
      public function set dropdownMenuScrollingList(param1:String) : void
      {
         this._dropdownMenuScrollingList = param1;
      }
      
      public function get dropdownMenuItemRenderer() : String
      {
         return this._dropdownMenuItemRenderer;
      }
      
      public function set dropdownMenuItemRenderer(param1:String) : void
      {
         this._dropdownMenuItemRenderer = param1;
      }
      
      public function get scrollSpeed() : Number
      {
         return this._scrollSpeed;
      }
      
      public function set scrollSpeed(param1:Number) : void
      {
         this._scrollSpeed = param1;
      }
      
      public function get listWidth() : Number
      {
         return this._listWidth;
      }
      
      public function set listWidth(param1:Number) : void
      {
         this._listWidth = param1;
      }
      
      public function get listHeight() : Number
      {
         return this._listHeight;
      }
      
      public function set listHeight(param1:Number) : void
      {
         this._listHeight = param1;
      }
      
      public function get handleKeyUpInput() : Boolean
      {
         return this._handleKeyUpInput;
      }
      
      public function set handleKeyUpInput(param1:Boolean) : void
      {
         this._handleKeyUpInput = param1;
      }
      
      public function set activeSelectionEnabled(param1:Boolean) : void
      {
         this._activeSelectionEnabled = param1;
         this.updateActiveSelectionEnabled();
      }
      
      protected function updateActiveSelectionEnabled() : void
      {
         var _loc1_:int = 0;
         var _loc2_:W3DropdownMenuListItem = null;
         _loc1_ = 0;
         while(_loc1_ < numRenderers)
         {
            _loc2_ = getRendererAt(_loc1_) as W3DropdownMenuListItem;
            if(_loc2_)
            {
               _loc2_.activeSelectionEnabled = this._activeSelectionEnabled;
            }
            _loc1_++;
         }
      }
      
      public function stableUpdateData(param1:Array) : void
      {
         var _loc4_:W3DropdownMenuListItem = null;
         var _loc5_:UIComponent = null;
         var _loc6_:Array = null;
         var _loc2_:int = int(_renderers.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            if(_loc4_ = _renderers[_loc3_] as W3DropdownMenuListItem)
            {
               _loc5_ = _loc4_.GetDropdownGridRef();
               if((_loc6_ = this.selectCategoryData(param1,_loc4_.label)).length > 0)
               {
                  if(!_loc5_)
                  {
                     _loc4_.setData(_loc6_);
                     _loc4_.updateDropdownData(_loc6_);
                  }
                  else
                  {
                     _loc4_.updateDropdownData(_loc6_);
                  }
               }
            }
            _loc3_++;
         }
      }
      
      public function saveSelectionState() : void
      {
         var _loc4_:W3DropdownMenuListItem = null;
         var _loc5_:UIComponent = null;
         var _loc6_:* = false;
         var _loc7_:W3ScrollingList = null;
         var _loc1_:int = int(_renderers.length);
         var _loc2_:int = int(_renderers.length);
         this._openRenderersList = new Dictionary(true);
         this._bufScrollPos = _scrollBar.position;
         this._bufSmoothScrolling = this.smoothScrolling;
         this.smoothScrolling = false;
         var _loc3_:int = 0;
         while(_loc3_ < _loc1_)
         {
            if(_loc4_ = _renderers[_loc3_] as W3DropdownMenuListItem)
            {
               _loc6_ = (_loc5_ = _loc4_.GetDropdownGridRef()) != null;
               if(_loc4_.label)
               {
                  this._openRenderersList[CommonUtils.toUpperCaseSafe(_loc4_.label)] = _loc6_;
               }
               if(_loc6_ && _loc4_.selected)
               {
                  this._selectionIdx = _loc3_;
                  if(_loc5_ is CoreList)
                  {
                     this._subSelectionTag = 0;
                     if((Boolean(_loc7_ = _loc5_ as W3ScrollingList)) && _loc7_.selectedIndex != -1)
                     {
                        this._subSelectionTag = (_loc7_.getSelectedRenderer() as ListItemRenderer).data.tag;
                     }
                     this._subSelectionIdx = (_loc5_ as CoreList).selectedIndex;
                  }
                  else if(_loc5_ is SlotsListBase)
                  {
                     this._subSelectionIdx = (_loc5_ as SlotsListBase).selectedIndex;
                  }
               }
            }
            _loc3_++;
         }
      }
      
      public function restoreSelectionState() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:W3DropdownMenuListItem = null;
         var _loc4_:int = 0;
         var _loc5_:SlotsListBase = null;
         var _loc6_:W3ScrollingList = null;
         var _loc7_:int = 0;
         if(this._openRenderersList)
         {
            _loc1_ = int(_renderers.length);
            _loc2_ = 0;
            while(_loc2_ < _renderers.length)
            {
               _loc3_ = _renderers[_loc2_] as W3DropdownMenuListItem;
               if(Boolean(_loc3_) && Boolean(this._openRenderersList[CommonUtils.toUpperCaseSafe(_loc3_.label)]))
               {
                  _loc3_.open(false);
                  _loc3_.GetDropdownGridRef().validateNow();
                  if(this._selectionIdx == _loc2_)
                  {
                     this._selectTargetDownView = _loc3_.GetDropdownGridRef();
                     if(this._selectTargetDownView)
                     {
                        this._selectTargetDownView.validateNow();
                     }
                     if(this.restoreSelectionByTag)
                     {
                        _loc4_ = 0;
                        _loc5_ = _loc3_.GetDropdownGridRef() as SlotsListBase;
                        _loc6_ = _loc3_.GetDropdownGridRef() as W3ScrollingList;
                        if(_loc5_)
                        {
                           _loc4_ = _loc5_.getRenderersLength();
                        }
                        else if(_loc6_)
                        {
                           _loc4_ = int(_loc6_.getRenderers().length);
                        }
                        _loc7_ = 0;
                        while(_loc7_ < _loc4_)
                        {
                           if(_loc5_)
                           {
                              if((_loc5_.getRendererAt(_loc7_) as SlotBase).data.tag == this._subSelectionTag)
                              {
                                 this._subSelectionIdx = _loc7_;
                                 break;
                              }
                           }
                           else if(_loc6_)
                           {
                              if((_loc6_.getRendererAt(_loc7_) as ListItemRenderer).data.tag == this._subSelectionTag)
                              {
                                 this._subSelectionIdx = _loc7_;
                                 break;
                              }
                           }
                           _loc7_++;
                        }
                     }
                  }
               }
               else
               {
                  _loc3_.close();
               }
               if(_loc2_ == this._selectionIdx)
               {
                  _loc3_.selectedIndex = this._subSelectionIdx;
                  _loc3_.validateNow();
               }
               _loc2_++;
            }
         }
         stage.dispatchEvent(new Event(W3ScrollingList.REPOSITION));
         updateSelectedIndex();
         _scrollBar.position = this._bufScrollPos;
         selectedIndex = this._selectionIdx;
         addEventListener(Event.ENTER_FRAME,this.handleListValidated,false,0,true);
         this.hackCounter = 0;
      }
      
      protected function handleListValidated(param1:Event) : void
      {
         if(this.hackCounter < 1)
         {
            ++this.hackCounter;
            return;
         }
         removeEventListener(Event.ENTER_FRAME,this.handleListValidated);
         if(this._selectTargetDownView as CoreList)
         {
            (this._selectTargetDownView as CoreList).selectedIndex = this._subSelectionIdx;
         }
         else if(this._selectTargetDownView as SlotsListBase)
         {
            (this._selectTargetDownView as SlotsListBase).validateNow();
            (this._selectTargetDownView as SlotsListBase).selectedIndex = this._subSelectionIdx;
         }
         this._openRenderersList = null;
         this._selectionIdx = -1;
         this._subSelectionIdx = -1;
         this.smoothScrolling = this._bufSmoothScrolling;
      }
      
      protected function selectCategoryData(param1:Array, param2:String) : Array
      {
         var _loc6_:String = null;
         var _loc3_:Array = [];
         var _loc4_:int = int(param1.length);
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            _loc6_ = String(param1[_loc5_].dropDownLabel);
            if(CommonUtils.toUpperCaseSafe(_loc6_) == CommonUtils.toUpperCaseSafe(param2))
            {
               _loc3_.push(param1[_loc5_]);
            }
            _loc5_++;
         }
         return _loc3_;
      }
      
      public function clearDataProvider() : void
      {
         this.resetRenderers();
         dataProvider = new DataProvider();
         validateNow();
         this.UpdateEmptyStateFeedback(true);
      }
      
      override public function updateData(param1:Array) : void
      {
         var _loc2_:Boolean = false;
         var _loc3_:String = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc10_:W3DropdownMenuListItem = null;
         var _loc11_:int = 0;
         if(!param1)
         {
            return;
         }
         var _loc4_:Array = new Array();
         var _loc5_:Array = new Array();
         _loc7_ = 0;
         while(_loc7_ < param1.length)
         {
            _loc3_ = param1[_loc7_].dropDownLabel as String;
            _loc6_ = -1;
            _loc8_ = 0;
            while(_loc8_ < _loc4_.length)
            {
               if(_loc4_[_loc8_] == _loc3_)
               {
                  _loc6_ = _loc8_;
                  break;
               }
               _loc8_++;
            }
            if(_loc6_ == -1)
            {
               _loc6_ = int(_loc4_.length);
               _loc4_.push(_loc3_);
               _loc5_.push(new Array());
            }
            _loc5_[_loc6_].push(param1[_loc7_]);
            _loc7_++;
         }
         if(this.updateSurgicallyOnDataSet && this.dataSetOnce)
         {
            this.updateDataSurgically(_loc4_,_loc5_);
            return;
         }
         _loc2_ = _renderers && _renderers.length > 0 && _renderers[0] is W3DropdownMenuListItem && Boolean((_renderers[0] as W3DropdownMenuListItem).label);
         if(_loc2_)
         {
            this.saveSelectionState();
         }
         clearRenderers();
         this._inputHandlers.length = 0;
         if(this.itemRendererClass)
         {
            itemRendererName = this.itemRendererClass;
         }
         var _loc9_:Vector.<IListItemRenderer> = new Vector.<IListItemRenderer>();
         _usingExternalRenderers = true;
         dataProvider = new DataProvider(_loc4_);
         _loc9_ = new Vector.<IListItemRenderer>();
         if(_loc5_.length == _loc4_.length)
         {
            _loc11_ = 0;
            while(_loc11_ < _loc5_.length)
            {
               _loc10_ = createRenderer(_loc11_) as W3DropdownMenuListItem;
               addChild(_loc10_);
               this.setupRenderer(_loc10_);
               _loc10_.y = _loc10_.height * _loc11_;
               _loc10_.enabled = true;
               _loc10_.label = _loc4_[_loc11_];
               _loc10_.setData(_loc5_[_loc11_]);
               _loc10_.setDropdownData(_loc5_[_loc11_]);
               _loc10_.handleKeyUpInput = this._handleKeyUpInput;
               _loc10_.validateNow();
               _loc9_.push(_loc10_);
               _loc11_++;
            }
         }
         itemRendererList = _loc9_;
         if(_loc2_)
         {
            this.restoreSelectionState();
         }
         else
         {
            this.SetInitialSelection();
         }
         validateNow();
         this.dataSetOnce = true;
      }
      
      public function updateDataSurgically(param1:Array, param2:Array) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:W3DropdownMenuListItem = null;
         var _loc6_:Boolean = false;
         _loc3_ = 0;
         while(_loc3_ < param1.length)
         {
            _loc6_ = false;
            _loc4_ = 0;
            while(_loc4_ < _renderers.length)
            {
               if((_loc5_ = _renderers[_loc4_] as W3DropdownMenuListItem).data == param2[_loc3_][0].dropDownLabel)
               {
                  _loc6_ = true;
                  break;
               }
               _loc4_++;
            }
            if(_loc6_)
            {
               _loc5_.setData(param2[_loc3_].dropDownLabel);
               _loc5_.updateDropdownDataSurgically(param2[_loc3_]);
            }
            _loc3_++;
         }
      }
      
      public function updateCategoryData(param1:Object) : void
      {
         var _loc4_:W3DropdownMenuListItem = null;
         var _loc5_:Array = null;
         var _loc6_:SlotsListGrid = null;
         var _loc2_:int = int(_renderers.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            if((_loc5_ = (_loc4_ = _renderers[_loc3_] as W3DropdownMenuListItem).getDropDownData())[0].dropDownLabel == param1[0].dropDownLabel)
            {
               _loc4_.setDropdownData(param1);
               if(_loc6_ = _loc4_.GetDropdownGridRef() as SlotsListGrid)
               {
                  _loc6_.data = param1 as Array;
               }
            }
            _loc3_++;
         }
      }
      
      public function updateItemData(param1:Object) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:W3DropdownMenuListItem = null;
         var _loc5_:BaseListItem = null;
         if(param1)
         {
            _loc2_ = 0;
            while(_loc2_ < dataProvider.length)
            {
               if((_loc4_ = getRendererAt(_loc2_) as W3DropdownMenuListItem).label == param1.dropDownLabel)
               {
                  _loc3_ = 0;
                  while(_loc3_ < _loc4_.dataProvider.length)
                  {
                     if((_loc5_ = _loc4_.GetDropdownListRef().getRendererAt(_loc3_) as BaseListItem).label == param1.label)
                     {
                        _loc5_.setData(param1);
                        return;
                     }
                     _loc3_++;
                  }
               }
               _loc2_++;
            }
         }
      }
      
      public function resetRenderers() : void
      {
         var _loc1_:int = 0;
         var _loc2_:W3DropdownMenuListItem = null;
         if(_renderers)
         {
            _loc1_ = int(_renderers.length);
            while(_renderers.length)
            {
               _loc2_ = _renderers.pop() as W3DropdownMenuListItem;
               if(_loc2_)
               {
                  _loc2_.parent.removeChild(_loc2_);
                  this.cleanUpRenderer(_loc2_);
                  _loc2_.close();
               }
            }
            itemRendererList = _renderers;
            this._inputHandlers.length = 0;
         }
      }
      
      public function SetInitialSelection() : *
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Boolean = false;
         var _loc4_:W3DropdownMenuListItem = null;
         var _loc5_:BaseListItem = null;
         _loc3_ = false;
         _loc1_ = 0;
         while(_loc1_ < dataProvider.length)
         {
            if(_loc4_ = getRendererAt(_loc1_) as W3DropdownMenuListItem)
            {
               if(_loc4_.HasInitialSelection() && !_loc3_)
               {
                  _loc4_.open(false);
                  selectedIndex = _loc1_;
                  _loc3_ = true;
               }
               else if(_loc4_.IsOpenedByDefault())
               {
                  _loc4_.open(false);
               }
            }
            _loc1_++;
         }
         if(_loc3_)
         {
            return;
         }
         removeEventListener(Event.ENTER_FRAME,this.pendedInitSelection,false);
         addEventListener(Event.ENTER_FRAME,this.pendedInitSelection,false,0,true);
      }
      
      protected function pendedInitSelection(param1:Event) : void
      {
         var _loc2_:W3DropdownMenuListItem = null;
         var _loc3_:Array = null;
         removeEventListener(Event.ENTER_FRAME,this.pendedInitSelection,false);
         _loc2_ = getRendererAt(0) as W3DropdownMenuListItem;
         if(_loc2_)
         {
            selectedIndex = 0;
            _loc2_.open(false);
            _loc2_.SelectSubListItem(0);
            _loc3_ = _loc2_.getDropDownData();
            if(_loc3_.length > 0)
            {
               if(_loc3_[0].id)
               {
                  dispatchEvent(new GameEvent(GameEvent.CALL,_loc2_.selectionEventName,[_loc3_[0].id]));
               }
               else if(_loc3_[0].tag)
               {
                  dispatchEvent(new GameEvent(GameEvent.CALL,_loc2_.selectionEventName,[_loc3_[0].tag]));
               }
            }
            else
            {
               dispatchEvent(new GameEvent(GameEvent.CALL,_loc2_.selectionEventName,[0]));
            }
         }
      }
      
      override protected function setupRenderer(param1:IListItemRenderer) : void
      {
         var _loc2_:W3DropdownMenuListItem = null;
         _loc2_ = param1 as W3DropdownMenuListItem;
         _loc2_.dropdown = this.dropdownMenuScrollingList;
         _loc2_.itemRenderer = this.dropdownMenuItemRenderer;
         this._inputHandlers.push(param1);
         super.setupRenderer(param1);
      }
      
      override protected function cleanUpRenderer(param1:IListItemRenderer) : void
      {
         if(this._inputHandlers.indexOf(param1) != -1)
         {
            this._inputHandlers.splice(this._inputHandlers.indexOf(param1),1);
         }
         super.cleanUpRenderer(param1);
      }
      
      public function handleSelectChange(param1:ListEvent) : *
      {
         var _loc6_:W3DropdownMenuListItem = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:Number = NaN;
         var _loc2_:Boolean = true;
         updateSelectedIndex();
         var _loc3_:UIComponent = param1.itemRenderer as UIComponent;
         var _loc4_:SlotsListBase;
         if(_loc4_ = param1.itemData as SlotsListBase)
         {
            if(param1.index == -1)
            {
               _loc3_ = _renderers[selectedIndex] as UIComponent;
            }
            else
            {
               this.UpdateLastSelectedColumn(_loc4_);
            }
         }
         var _loc5_:*;
         if(_loc5_ = _renderers[selectedIndex] as W3DropdownMenuListItem)
         {
            _loc5_.changeFocus();
         }
         if(!_loc3_)
         {
            return;
         }
         if(param1.itemRenderer is W3DropdownMenuListItem)
         {
            _loc6_ = _renderers[selectedIndex] as W3DropdownMenuListItem;
            if(this.previousSelectedIndex > -1 && this.previousSelectedIndex != selectedIndex)
            {
               this.ResetPreviousDropdownSelection(this.previousSelectedIndex);
               if(selectedIndex < this.previousSelectedIndex && Math.abs(this.previousSelectedIndex - selectedIndex) < 2 && _loc6_ && _loc6_.isOpen())
               {
                  _loc2_ = false;
               }
            }
            this.previousSelectedIndex = selectedIndex;
            if(_loc6_.GetDropdownListRef() != null)
            {
               _loc6_.selectedIndex = _loc6_.GetDropdownListRef().selectedIndex;
               _loc6_.validateNow();
            }
            if(_loc6_.selectedIndex != -1)
            {
               _loc2_ = false;
            }
            else if(selectedIndex != param1.index && param1.index != -1)
            {
               _loc2_ = false;
            }
         }
         if(Boolean(_loc3_) && _loc2_)
         {
            _loc7_ = 0;
            _loc8_ = 0;
            _loc7_ = _loc3_.y;
            if(!(_loc3_ is W3DropdownMenuListItem) && selectedIndex < _renderers.length && selectedIndex > -1)
            {
               _loc7_ += _renderers[selectedIndex].y + _renderers[selectedIndex].height;
            }
            if(_loc3_ is IBaseSlot)
            {
               _loc8_ = (_loc3_ as IBaseSlot).getSlotRect().height;
            }
            else
            {
               _loc8_ = _loc3_.height;
            }
            _loc9_ = this.m_defaultPosition - y;
            if(_loc7_ + _loc8_ > this._listHeight + _loc9_)
            {
               _scrollBar.position = _loc7_ + _loc8_ - this._listHeight;
            }
            else if(_loc7_ < _loc9_)
            {
               _scrollBar.position = _loc7_;
            }
         }
      }
      
      public function UpdateLastSelectedColumn(param1:SlotsListBase) : *
      {
         var _loc2_:int = 0;
         var _loc3_:W3DropdownMenuListItem = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         if(Boolean(param1) && param1.selectedColumn != -1)
         {
            _loc2_ = param1.selectedColumn;
            _loc3_ = null;
            _loc4_ = int(_renderers.length);
            _loc5_ = 0;
            while(_loc5_ < _loc4_)
            {
               _loc3_ = _renderers[_loc5_] as W3DropdownMenuListItem;
               if(_loc3_)
               {
                  _loc3_.lastSelectedColumn = _loc2_;
               }
               _loc5_++;
            }
         }
      }
      
      public function ResetPreviousDropdownSelection(param1:int) : void
      {
         var _loc2_:W3DropdownMenuListItem = null;
         _loc2_ = getRendererAt(param1) as W3DropdownMenuListItem;
         if(_loc2_)
         {
            if(_loc2_.isOpen())
            {
               _loc2_.SelectSubListItem(-1);
            }
         }
      }
      
      public function closeAll(param1:Boolean = false) : *
      {
         var _loc2_:W3DropdownMenuListItem = null;
         var _loc3_:int = -1;
         var _loc4_:int = 0;
         while(_loc4_ < dataProvider.length)
         {
            _loc2_ = getRendererAt(_loc4_) as W3DropdownMenuListItem;
            if(Boolean(_loc2_) && _loc2_.isOpen())
            {
               _loc3_ = int(_loc2_.index);
               _loc2_.close();
            }
            _loc4_++;
         }
         if(param1)
         {
            selectedIndex = _loc3_;
            validateNow();
         }
      }
      
      public function forceUpdateSelection(param1:int) : *
      {
         selectedIndex = param1;
         validateNow();
      }
      
      public function updatePosition(param1:Event) : *
      {
         var _loc2_:W3DropdownMenuListItem = null;
         var _loc3_:Number = 0;
         var _loc4_:int = 0;
         while(_loc4_ < dataProvider.length)
         {
            if(_loc2_)
            {
               _loc3_ += _loc2_.height;
               if(_loc2_.isOpen())
               {
                  _loc2_.SetDropdownListVerticalPosition(_loc3_);
                  _loc3_ += _loc2_.GetDropdownListHeight();
               }
            }
            _loc2_ = getRendererAt(_loc4_) as W3DropdownMenuListItem;
            if(_loc2_)
            {
               _loc2_.y = _loc3_;
            }
            _loc4_++;
         }
         if(_loc2_)
         {
            _loc3_ += _loc2_.height;
            if(_loc2_.isOpen())
            {
               if(_loc2_.isOpen())
               {
                  _loc2_.SetDropdownListVerticalPosition(_loc3_);
                  _loc3_ += _loc2_.GetDropdownListHeight();
               }
            }
         }
         this.m_currentListHeight = _loc3_;
         this.updateScrollBar();
      }
      
      protected function CreateMask() : *
      {
         if(this.mcMask)
         {
            this.mcMask.width = this.listWidth;
            this.mcMask.height = this.listHeight;
         }
      }
      
      public function ScrollToSelected(param1:IListItemRenderer, param2:Number = 0) : *
      {
         if(scrollBar == null)
         {
            return;
         }
         if(param1 == null)
         {
            return;
         }
         scrollBar.position = param1.y + param2;
         this.m_lastScrollPosition = scrollBar.position;
      }
      
      protected function onScroll(param1:MouseEvent) : void
      {
         if(hitTestPoint(param1.stageX,param1.stageY,false))
         {
            if(this.m_currentListHeight > this.listHeight)
            {
               if(param1.delta > 0)
               {
                  _scrollBar.position -= this.scrollSpeed;
               }
               else
               {
                  _scrollBar.position += this.scrollSpeed;
               }
            }
         }
      }
      
      override protected function handleScroll(param1:Event) : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc2_:int = _scrollBar.position - this.m_lastScrollPosition;
         if(this.smoothScrolling)
         {
            if(this.scrollTweener)
            {
               this.scrollTweener.paused = true;
               _loc4_ = this.scrollTweener.getValue("y") as Number;
               this.y = _loc4_;
               GTweener.removeTweens(this);
            }
            _loc3_ = this.y - _loc2_;
            this.scrollTweener = GTweener.to(this,0.3,{"y":_loc3_},{"onComplete":this.handleTweenComplete});
         }
         else
         {
            this.y -= _loc2_;
         }
         this.m_lastScrollPosition = _scrollBar.position;
      }
      
      protected function handleTweenComplete(param1:GTween) : void
      {
         this.scrollTweener = null;
      }
      
      override public function handleInput(param1:InputEvent) : void
      {
         var _loc3_:UIComponent = null;
         if(param1.handled || !_focused && focusable || !visible || this.mcEmptyListFeedback && this.mcEmptyListFeedback.visible)
         {
            return;
         }
         var _loc2_:InputDetails = param1.details;
         for each(_loc3_ in this._inputHandlers)
         {
            if(_loc3_)
            {
               _loc3_.handleInput(param1);
               if(param1.handled)
               {
                  param1.stopImmediatePropagation();
                  return;
               }
            }
         }
         super.handleInput(param1);
      }
      
      override protected function updateScrollBar() : void
      {
         var _loc2_:ScrollIndicator = null;
         if(_scrollBar == null)
         {
            return;
         }
         var _loc1_:Number = this.m_currentListHeight - this.listHeight;
         if(_loc1_ <= 0)
         {
            _scrollBar.position = 0;
            scrollBar.visible = false;
            return;
         }
         scrollBar.visible = true;
         if(_scrollBar is ScrollIndicator)
         {
            _loc2_ = _scrollBar as ScrollIndicator;
            _loc2_.setScrollProperties(this.listHeight,0,_loc1_,this.scrollSpeed);
         }
         _scrollBar.validateNow();
      }
      
      override public function CheckSubListSelection() : void
      {
         var _loc1_:W3DropdownMenuListItem = null;
         _loc1_ = getRendererAt(_newSelectedIndex) as W3DropdownMenuListItem;
         if(_loc1_ && _loc1_.GetDropdownGridRef() && !_loc1_.IsSubListItemSelected())
         {
            _loc1_.SelectLastSubListItem();
         }
      }
   }
}
