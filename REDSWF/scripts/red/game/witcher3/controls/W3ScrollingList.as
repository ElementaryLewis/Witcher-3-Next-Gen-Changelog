package red.game.witcher3.controls
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import red.core.constants.KeyCode;
   import red.core.events.GameEvent;
   import red.game.witcher3.interfaces.IScrollingList;
   import scaleform.clik.constants.InputValue;
   import scaleform.clik.constants.WrappingMode;
   import scaleform.clik.controls.DropdownMenu;
   import scaleform.clik.controls.ListItemRenderer;
   import scaleform.clik.controls.ScrollIndicator;
   import scaleform.clik.controls.ScrollingList;
   import scaleform.clik.core.UIComponent;
   import scaleform.clik.events.InputEvent;
   import scaleform.clik.events.ListEvent;
   import scaleform.clik.interfaces.IListItemRenderer;
   import scaleform.clik.ui.InputDetails;
   
   public class W3ScrollingList extends ScrollingList implements IScrollingList
   {
      
      public static var REPOSITION:String = "Recalculate position of list items";
       
      
      private var _UpAction:int = 38;
      
      private var _DownAction:int = 40;
      
      private var _PCUpAction:int = 87;
      
      private var _PCDownAction:int = 83;
      
      public var textField:TextField;
      
      public var bAlwaysHandleDirectionActions:Boolean = false;
      
      public var bSkipFocusCheck:Boolean = false;
      
      private var _lastDir:int = 0;
      
      private var _selectOnOver:Boolean = false;
      
      private var _reverseMouseWheel:Boolean = false;
      
      public var ignoreHeightForRendererCreation:Boolean = false;
      
      public function W3ScrollingList()
      {
         super();
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         addEventListener(InputEvent.INPUT,this.handleInput,false,0,true);
      }
      
      public function get UpAction() : int
      {
         return this._UpAction;
      }
      
      public function set UpAction(param1:int) : void
      {
         this._UpAction = param1;
      }
      
      public function get DownAction() : int
      {
         return this._DownAction;
      }
      
      public function set DownAction(param1:int) : void
      {
         this._DownAction = param1;
      }
      
      public function get PCUpAction() : int
      {
         return this._PCUpAction;
      }
      
      public function set PCUpAction(param1:int) : void
      {
         this._PCUpAction = param1;
      }
      
      public function get PCDownAction() : int
      {
         return this._PCDownAction;
      }
      
      public function set PCDownAction(param1:int) : void
      {
         this._PCDownAction = param1;
      }
      
      public function get selectOnOver() : Boolean
      {
         return this._selectOnOver;
      }
      
      public function set selectOnOver(param1:Boolean) : void
      {
         this._selectOnOver = param1;
      }
      
      public function get reverseMouseWheel() : Boolean
      {
         return this._reverseMouseWheel;
      }
      
      public function set reverseMouseWheel(param1:Boolean) : void
      {
         this._reverseMouseWheel = param1;
      }
      
      public function clearLastDir() : *
      {
         this._lastDir = 0;
      }
      
      public function getLastDir() : int
      {
         return this._lastDir;
      }
      
      public function get TotalRenderers() : int
      {
         return _totalRenderers;
      }
      
      public function get numRenderers() : int
      {
         if(_renderers)
         {
            return _renderers.length;
         }
         return 0;
      }
      
      public function clearRenderers() : void
      {
         var _loc1_:int = 0;
         _loc1_ = 0;
         while(_loc1_ < _renderers.length)
         {
            cleanUpRenderer(_renderers[_loc1_]);
            if(_renderers[_loc1_] is W3DropdownMenuListItem)
            {
               (_renderers[_loc1_] as W3DropdownMenuListItem).clearRenderers();
            }
            (_renderers[_loc1_] as UIComponent).parent.removeChild(_renderers[_loc1_] as UIComponent);
            _loc1_++;
         }
         _renderers.length = 0;
         _totalRenderers = 0;
      }
      
      public function GenerateRenderers() : void
      {
         var _loc1_:int = 0;
         var _loc3_:ListItemRenderer = null;
         this.clearRenderers();
         var _loc2_:int = 0;
         _loc1_ = 0;
         while(_loc1_ < dataProvider.length)
         {
            _loc3_ = createRenderer(_loc1_) as ListItemRenderer;
            if(_loc3_)
            {
               addChild(_loc3_);
               _loc3_.enabled = true;
               _loc3_.y = _loc2_;
               _loc3_.index = _loc1_;
               _loc2_ += _loc3_.height;
               _loc3_.setData(dataProvider[_loc1_]);
               _renderers.push(_loc3_);
               _loc3_.validateNow();
               ++_totalRenderers;
            }
            _loc1_++;
         }
      }
      
      override protected function calculateRendererTotal(param1:Number, param2:Number) : uint
      {
         var _loc3_:uint = super.calculateRendererTotal(param1,param2);
         if(this.ignoreHeightForRendererCreation)
         {
            return !!dataProvider ? dataProvider.length : uint(NaN);
         }
         return _loc3_;
      }
      
      public function ShowRenderers(param1:Boolean) : void
      {
         var _loc2_:ListItemRenderer = null;
         var _loc3_:int = 0;
         var _loc4_:MovieClip = null;
         visible = param1;
         _loc3_ = 0;
         while(_loc3_ < Math.min(_dataProvider.length,_totalRenderers))
         {
            _loc2_ = getRendererAt(_loc3_) as ListItemRenderer;
            if(_loc2_)
            {
               _loc2_.visible = param1;
            }
            _loc3_++;
         }
         if(_dataProvider)
         {
            _loc3_ = int(_dataProvider.length);
            while(_loc3_ < _totalRenderers)
            {
               if(_loc4_ = getRendererAt(_loc3_) as MovieClip)
               {
                  _loc4_.visible = false;
               }
               _loc3_++;
            }
         }
         if(this.textField)
         {
            this.UpdateEmptyStateFeedback(_dataProvider.length < 1);
         }
      }
      
      public function UpdateEmptyStateFeedback(param1:Boolean) : *
      {
         if(param1)
         {
            this.textField.htmlText = "[[panel_journal_quest_empty_description]]";
            this.textField.visible = true;
         }
         else
         {
            this.textField.visible = false;
         }
      }
      
      public function moveUp(param1:Boolean = true) : void
      {
         var _loc2_:UIComponent = null;
         var _loc4_:int = 0;
         var _loc3_:* = -1;
         _loc4_ = selectedIndex - 1;
         while(_loc4_ >= 0)
         {
            _loc2_ = getRendererAt(_loc4_) as UIComponent;
            if(!_loc2_ || _loc2_.enabled)
            {
               _loc3_ = _loc4_;
               break;
            }
            _loc4_--;
         }
         if(selectedIndex == -1)
         {
            this.selectedIndex = scrollPosition + _totalRenderers - 1;
         }
         else if(_loc3_ != -1)
         {
            this.selectedIndex = _loc3_;
         }
         else if(wrapping != WrappingMode.STICK)
         {
            if(!(wrapping == WrappingMode.WRAP && param1))
            {
               return;
            }
            _loc4_ = int(_dataProvider.length - 1);
            while(_loc4_ >= 0)
            {
               _loc2_ = getRendererAt(_loc4_) as UIComponent;
               if(!_loc2_ || _loc2_.enabled)
               {
                  this.selectedIndex = _loc4_;
                  break;
               }
               _loc4_--;
            }
            updateSelectedIndex();
            if(_loc2_ != null)
            {
               _loc2_.invalidate();
            }
            this.CheckSubListSelection();
         }
         validateNow();
         var _loc5_:W3DropdownMenuListItem;
         if((Boolean(_loc5_ = getRendererAt(selectedIndex) as W3DropdownMenuListItem)) && _loc5_.isOpen())
         {
            _loc5_.SelectLastSubListItem();
         }
         _loc2_ = getRendererAt(selectedIndex) as BaseListItem;
         this.dispatchIndexChanged(selectedIndex,_loc2_);
      }
      
      public function moveDown(param1:Boolean = true) : void
      {
         var _loc2_:UIComponent = null;
         var _loc4_:int = 0;
         var _loc5_:W3DropdownMenuListItem = null;
         var _loc3_:* = -1;
         _loc4_ = selectedIndex + 1;
         while(_loc4_ < _dataProvider.length)
         {
            _loc2_ = getRendererAt(_loc4_) as UIComponent;
            if(!_loc2_ || _loc2_.enabled)
            {
               _loc3_ = _loc4_;
               break;
            }
            _loc4_++;
         }
         if(_selectedIndex == -1)
         {
            this.selectedIndex = 0;
         }
         else if(_loc3_ != -1)
         {
            this.selectedIndex = _loc3_;
         }
         else if(wrapping != WrappingMode.STICK)
         {
            if(wrapping == WrappingMode.WRAP && param1)
            {
               if(selectedIndex == 0)
               {
                  if((Boolean(_loc5_ = getRendererAt(0) as W3DropdownMenuListItem)) && _loc5_.selectedIndex != -1)
                  {
                     _loc5_.SelectSubListItem(-1);
                  }
               }
               else
               {
                  _loc4_ = 0;
                  while(_loc4_ < _dataProvider.length)
                  {
                     _loc2_ = getRendererAt(_loc4_) as UIComponent;
                     if(!_loc2_ || _loc2_.enabled)
                     {
                        this.selectedIndex = _loc4_;
                        break;
                     }
                     _loc4_++;
                  }
                  updateSelectedIndex();
               }
            }
         }
         validateNow();
         _loc2_ = getRendererAt(selectedIndex) as BaseListItem;
         this.dispatchIndexChanged(selectedIndex,_loc2_);
      }
      
      override public function handleInput(param1:InputEvent) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         if(param1.handled || !this.bSkipFocusCheck && (!focused && focusable))
         {
            return;
         }
         var _loc2_:InputDetails = param1.details;
         var _loc3_:Boolean = _loc2_.value == InputValue.KEY_DOWN || _loc2_.value == InputValue.KEY_HOLD;
         var _loc6_:UIComponent;
         if(!((_loc6_ = getRendererAt(_selectedIndex,_scrollPosition) as UIComponent) is IListItemRenderer))
         {
            _loc6_ = null;
         }
         if(_loc6_ != null)
         {
            _loc6_.handleInput(param1);
            if(param1.handled)
            {
               return;
            }
         }
         if((_loc2_.code == KeyCode.PAD_DIGIT_DOWN || KeyCode.PAD_DIGIT_UP || _loc2_.code == KeyCode.PAD_DIGIT_LEFT || _loc2_.code == KeyCode.PAD_DIGIT_RIGHT) && _loc2_.code != this.UpAction && _loc2_.code != this.DownAction && _loc2_.code != this.PCUpAction && _loc2_.code != this.PCDownAction)
         {
            return;
         }
         switch(_loc2_.code)
         {
            case this.UpAction:
            case this.PCUpAction:
               if(_loc3_)
               {
                  this._lastDir = -1;
                  _loc5_ = selectedIndex;
                  this.moveUp(_loc2_.value != InputValue.KEY_HOLD);
                  if(_loc5_ != selectedIndex)
                  {
                     _loc6_ = getRendererAt(selectedIndex) as BaseListItem;
                     this.dispatchIndexChanged(selectedIndex,_loc6_);
                     param1.handled = true;
                  }
               }
               break;
            case this.DownAction:
            case this.PCDownAction:
               if(_loc3_)
               {
                  this._lastDir = 1;
                  _loc5_ = selectedIndex;
                  this.moveDown(_loc2_.value != InputValue.KEY_HOLD);
                  if(_loc5_ != selectedIndex)
                  {
                     _loc6_ = getRendererAt(selectedIndex) as BaseListItem;
                     this.dispatchIndexChanged(selectedIndex,_loc6_);
                     param1.handled = true;
                  }
               }
               break;
            case KeyCode.LEFT:
            case KeyCode.RIGHT:
               break;
            default:
               return;
         }
      }
      
      private function dispatchIndexChanged(param1:int, param2:UIComponent) : *
      {
         var _loc3_:BaseListItem = null;
         var _loc4_:DropdownMenu = null;
         if(param2 is BaseListItem)
         {
            _loc3_ = param2 as BaseListItem;
            dispatchEvent(new ListEvent(ListEvent.INDEX_CHANGE,true,false,param1,-1,-1,param2 as IListItemRenderer,!!_loc3_ ? _loc3_.data : null));
         }
         else if(param2 is DropdownMenu)
         {
            _loc4_ = param2 as DropdownMenu;
            dispatchEvent(new ListEvent(ListEvent.INDEX_CHANGE,true,false,param1,-1,-1,param2 as IListItemRenderer,!!_loc4_ ? _loc4_.data : null));
         }
         else
         {
            dispatchEvent(new ListEvent(ListEvent.INDEX_CHANGE,true,false,param1,-1,-1,null,param2));
         }
      }
      
      override protected function updateScrollBar() : void
      {
         var _loc2_:ScrollIndicator = null;
         if(_scrollBar == null)
         {
            return;
         }
         if(_dataProvider.length <= _totalRenderers)
         {
            scrollBar.visible = false;
         }
         else
         {
            scrollBar.visible = true;
         }
         var _loc1_:Number = Math.max(0,_dataProvider.length - _totalRenderers);
         if(_scrollBar is ScrollIndicator)
         {
            _loc2_ = _scrollBar as ScrollIndicator;
            _loc2_.setScrollProperties(_totalRenderers,0,_dataProvider.length - _totalRenderers);
         }
         _scrollBar.position = _scrollPosition;
         _scrollBar.validateNow();
      }
      
      override protected function populateData(param1:Array) : void
      {
         super.populateData(param1);
         this.ShowRenderers(true);
         stage.dispatchEvent(new Event(W3ScrollingList.REPOSITION));
      }
      
      public function updateData(param1:Array) : void
      {
         if(!param1)
         {
            return;
         }
         this.populateData(param1);
         invalidateData();
      }
      
      override protected function drawLayout() : void
      {
         super.drawLayout();
         stage.dispatchEvent(new Event(W3ScrollingList.REPOSITION));
      }
      
      override public function toString() : String
      {
         return "[W3 W3ScrollingList " + this.name + " ]";
      }
      
      public function getRenderers() : Vector.<IListItemRenderer>
      {
         return _renderers;
      }
      
      public function GetDropdownListHeight() : Number
      {
         var _loc2_:BaseListItem = null;
         var _loc1_:Number = 0;
         var _loc3_:int = 0;
         while(_loc3_ < dataProvider.length)
         {
            _loc2_ = getRendererAt(_loc3_) as BaseListItem;
            if(_loc2_)
            {
               _loc1_ += _loc2_.actualHeight;
            }
            _loc3_++;
         }
         return _loc1_;
      }
      
      override protected function dispatchItemEvent(param1:Event) : Boolean
      {
         var _loc2_:IListItemRenderer = null;
         var _loc3_:IListItemRenderer = null;
         var _loc4_:ListEvent = null;
         if(this.selectOnOver && param1.type == MouseEvent.ROLL_OVER)
         {
            _loc2_ = param1.currentTarget as IListItemRenderer;
            if(_loc2_)
            {
               this.trySelectingIndex(_loc2_.index);
            }
         }
         if(param1.type == MouseEvent.DOUBLE_CLICK)
         {
            _loc3_ = param1.currentTarget as IListItemRenderer;
            _loc4_ = new ListEvent(ListEvent.ITEM_DOUBLE_CLICK,true,true,_loc3_.index,0,_loc3_.index,_loc3_,dataProvider.requestItemAt(_loc3_.index),0,0,false);
            return dispatchEvent(_loc4_);
         }
         return super.dispatchItemEvent(param1);
      }
      
      public function trySelectingIndex(param1:int) : *
      {
         this.selectedIndex = param1;
      }
      
      override public function set selectedIndex(param1:int) : void
      {
         var _loc2_:W3DropdownMenuListItem = null;
         if(param1 == _selectedIndex || param1 == _newSelectedIndex)
         {
            return;
         }
         if(this is W3DropDownList)
         {
            _loc2_ = getRendererAt(param1) as W3DropdownMenuListItem;
            if(Boolean(_loc2_) && !_loc2_.isOpen())
            {
               dispatchEvent(new GameEvent(GameEvent.CALL,"OnPlaySoundEvent",["gui_global_highlight"]));
            }
         }
         else
         {
            dispatchEvent(new GameEvent(GameEvent.CALL,"OnPlaySoundEvent",["gui_global_highlight"]));
         }
         super.selectedIndex = param1;
      }
      
      override protected function handleMouseWheel(param1:MouseEvent) : void
      {
         if(this.reverseMouseWheel)
         {
            scrollList(param1.delta < 0 ? 1 : -1);
         }
         else
         {
            scrollList(param1.delta > 0 ? 1 : -1);
         }
      }
      
      public function CheckSubListSelection() : void
      {
      }
      
      override public function set focused(param1:Number) : void
      {
         super.focused = param1;
      }
   }
}
