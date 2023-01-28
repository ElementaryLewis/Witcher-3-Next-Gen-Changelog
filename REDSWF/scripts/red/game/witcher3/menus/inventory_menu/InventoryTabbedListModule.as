package red.game.witcher3.menus.inventory_menu
{
   import com.gskinner.motion.GTween;
   import com.gskinner.motion.GTweener;
   import com.gskinner.motion.easing.Sine;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.text.TextField;
   import flash.utils.getDefinitionByName;
   import red.core.constants.KeyCode;
   import red.core.events.GameEvent;
   import red.game.witcher3.constants.CommonConstants;
   import red.game.witcher3.controls.AdvancedTabListItem;
   import red.game.witcher3.interfaces.IAbstractItemContainerModule;
   import red.game.witcher3.managers.InputManager;
   import red.game.witcher3.menus.common.ItemDataStub;
   import red.game.witcher3.modules.CollapsableTabbedListModule;
   import red.game.witcher3.slots.SlotBase;
   import red.game.witcher3.slots.SlotInventoryGrid;
   import red.game.witcher3.slots.SlotsListGrid;
   import red.game.witcher3.utils.CommonUtils;
   import scaleform.clik.core.UIComponent;
   import scaleform.clik.events.InputEvent;
   import scaleform.clik.events.ListEvent;
   
   public class InventoryTabbedListModule extends CollapsableTabbedListModule implements IAbstractItemContainerModule
   {
       
      
      private const SECTION_BORDER_REF:String = "GridSegmentationRef";
      
      private const SECTION_BORDER_SIDE_PADDING:Number = 3;
      
      private const SECTION_BORDER_TOP_PADDING:Number = 9;
      
      internal var maskClip:MovieClip;
      
      protected var _gridRenderHeight:int = 520;
      
      public var mcSectionTitlesAnchor:MovieClip;
      
      public var mcPlayerGrid:SlotsListGrid;
      
      protected var _sectionTitlesContainer:MovieClip;
      
      protected var _sectionTitlesList:Vector.<TextField>;
      
      protected var _sectionBordersList:Vector.<MovieClip>;
      
      protected var _itemSectionsList:GridTabSections;
      
      private var isHorse:Boolean = false;
      
      public var gridMaskOffset:Number = 0;
      
      protected var maskTweener:GTween;
      
      public function InventoryTabbedListModule()
      {
         this._sectionTitlesList = new Vector.<TextField>();
         this._sectionBordersList = new Vector.<MovieClip>();
         super();
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         _initialSelectedIndex = 4;
         this.maskClip = getChildByName("mcGridMask") as MovieClip;
         if(this.maskClip)
         {
            this._gridRenderHeight = this.maskClip.height - this.gridMaskOffset;
         }
         dataBindingKey = "inventory.grid.player";
         addToListContainer(this.mcPlayerGrid);
         stage.addEventListener(SlotBase.NEW_FLAG_CLEARED,this.onNewFlagCleared,true,0,true);
         dispatchEvent(new GameEvent(GameEvent.REGISTER,dataBindingKey + ".itemUpdate",[this.handleItemUpdate]));
         dispatchEvent(new GameEvent(GameEvent.REGISTER,dataBindingKey + ".itemsUpdate",[this.handleItemsUpdate]));
         if(this.mcPlayerGrid)
         {
            this.mcPlayerGrid.gridMaskOffset = this.gridMaskOffset;
            this.mcPlayerGrid.focusable = false;
            this.mcPlayerGrid.handleScrollBar = true;
            this.mcPlayerGrid.ignoreGridPosition = false;
            _inputHandlers.push(this.mcPlayerGrid);
            this.mcPlayerGrid.addEventListener(ListEvent.INDEX_CHANGE,this.handleSlotChanged,false,0,true);
         }
         bToCloseEnabled = true;
      }
      
      public function setItemSections(param1:GridTabSections) : void
      {
         this._itemSectionsList = param1;
      }
      
      override protected function onTabListItemSelected(param1:ListEvent) : void
      {
         var _loc4_:Array = null;
         var _loc6_:MovieClip = null;
         var _loc7_:Class = null;
         var _loc8_:int = 0;
         var _loc9_:Number = NaN;
         var _loc10_:Point = null;
         var _loc11_:int = 0;
         var _loc12_:ItemSectionData = null;
         var _loc13_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc15_:TextField = null;
         var _loc16_:MovieClip = null;
         var _loc2_:Number = this.mcPlayerGrid.gridSquareSize;
         var _loc3_:Number = SlotsListGrid.SECTION_PADDING;
         if(param1.index != currentlySelectedTabIndex)
         {
            if(_loc4_ = this._itemSectionsList.getTabSections(param1.index))
            {
               this.mcPlayerGrid.setItemSections(_loc4_);
            }
         }
         super.onTabListItemSelected(param1);
         var _loc5_:Number = 0;
         if(Boolean(_loc4_) && Boolean(_loc4_.length))
         {
            _loc5_ = this.mcPlayerGrid.columns * _loc2_ + (_loc4_.length - 1) * SlotsListGrid.SECTION_PADDING;
            this.mcPlayerGrid.x = -_loc5_ / 2;
         }
         else
         {
            _loc5_ = this.mcPlayerGrid.actualWidth;
         }
         if(Boolean(_loc4_) && Boolean(this.mcSectionTitlesAnchor))
         {
            if(this._sectionTitlesContainer)
            {
               while(this._sectionTitlesList.length)
               {
                  this._sectionTitlesContainer.removeChild(this._sectionTitlesList.pop());
               }
               while(this._sectionBordersList.length)
               {
                  _loc6_ = this._sectionBordersList.pop();
                  GTweener.removeTweens(_loc6_);
                  this._sectionTitlesContainer.removeChild(_loc6_);
               }
               removeChild(this._sectionTitlesContainer);
               this._sectionTitlesContainer = null;
            }
            if(_loc4_.length)
            {
               _loc7_ = getDefinitionByName(this.SECTION_BORDER_REF) as Class;
               _loc8_ = int(_loc4_.length);
               _loc9_ = 0;
               _loc10_ = mcListContainer.localToGlobal(new Point(this.mcPlayerGrid.x,this.mcPlayerGrid.y));
               this._sectionTitlesContainer = new MovieClip();
               this._sectionTitlesContainer.y = this.mcSectionTitlesAnchor.y;
               this._sectionTitlesContainer.x = this.mcSectionTitlesAnchor.x - _loc5_ / 2;
               addChild(this._sectionTitlesContainer);
               this._sectionTitlesContainer.mouseChildren = this._sectionTitlesContainer.mouseEnabled = false;
               _loc11_ = 0;
               while(_loc11_ < _loc8_)
               {
                  if(_loc12_ = _loc4_[_loc11_] as ItemSectionData)
                  {
                     if((_loc13_ = (_loc12_.end - _loc12_.start + 1) * _loc2_) < 0)
                     {
                        throw new Error("Invalid grid sections structure. Check MenuInventory.as or InventoryTabbedListModule.as ;-)");
                     }
                     _loc14_ = _loc13_ / 2;
                     (_loc15_ = CommonUtils.spawnTextField(21)).text = _loc12_.label;
                     CommonUtils.toSmallCaps(_loc15_);
                     _loc15_.width = _loc15_.textWidth + CommonConstants.SAFE_TEXT_PADDING;
                     _loc15_.x = _loc9_ + _loc14_ - _loc15_.width / 2;
                     this._sectionTitlesContainer.addChild(_loc15_);
                     (_loc16_ = new _loc7_() as MovieClip).x = _loc9_ - this.SECTION_BORDER_SIDE_PADDING;
                     _loc16_.y = -this.SECTION_BORDER_TOP_PADDING;
                     _loc16_.width = _loc13_ + this.SECTION_BORDER_SIDE_PADDING * 2;
                     this._sectionTitlesContainer.addChild(_loc16_);
                     _loc12_.border = _loc16_;
                     _loc16_.alpha = CommonConstants.BORDER_ALPHA_UNSELECTED;
                     this.mcPlayerGrid.lastSelectedSection = -1;
                     _loc9_ += _loc3_ + _loc13_;
                  }
                  _loc11_++;
               }
            }
         }
      }
      
      override protected function handleMouseMove(param1:MouseEvent) : void
      {
         if(!_lastMoveWasMouse)
         {
            _lastMoveWasMouse = true;
         }
         open();
      }
      
      override protected function requestTabdata(param1:int) : void
      {
         dispatchEvent(new GameEvent(GameEvent.CALL,tabDataEventName,[param1,this.isHorse]));
      }
      
      override protected function setAllowSelectionHighlight(param1:Boolean) : void
      {
         var _loc2_:SlotBase = null;
         var _loc3_:int = 0;
         super.setAllowSelectionHighlight(param1);
         if(this.mcPlayerGrid)
         {
            this.mcPlayerGrid.activeSelectionVisible = param1;
         }
      }
      
      override protected function state_Open_begin() : void
      {
         super.state_Open_begin();
         invalidate(INVALIDATE_CONTEXT);
         if(this.mcPlayerGrid.selectedIndex == -1)
         {
            this.mcPlayerGrid.findSelection();
         }
         this.mcPlayerGrid.applySelectionContext();
         this.checkTabNewFlag(this.mcPlayerGrid.getSelectedRenderer() as SlotBase);
      }
      
      protected function handleSlotChanged(param1:ListEvent) : void
      {
         invalidate(INVALIDATE_CONTEXT);
         this.checkTabNewFlag(this.mcPlayerGrid.getSelectedRenderer() as SlotBase);
      }
      
      protected function onNewFlagCleared(param1:Event) : void
      {
         if(param1.target is SlotBase)
         {
            this.checkTabNewFlag(param1.target as SlotBase);
         }
      }
      
      protected function checkTabNewFlag(param1:SlotBase) : void
      {
         if(Boolean(param1) && param1._unprocessedNewFlagRemoval)
         {
            param1._unprocessedNewFlagRemoval = false;
            this.validateTabNewFlag(mcTabList.selectedIndex);
         }
      }
      
      protected function validateTabNewFlag(param1:int) : void
      {
         var _loc3_:Array = null;
         var _loc4_:int = 0;
         var _loc5_:Boolean = false;
         var _loc2_:AdvancedTabListItem = mcTabList.getRendererAt(param1) as AdvancedTabListItem;
         if(Boolean(_loc2_) && _loc2_.hasNewFlag())
         {
            _loc3_ = subDataDictionary[param1];
            if(_loc3_)
            {
               _loc4_ = 0;
               _loc5_ = false;
               _loc4_ = 0;
               while(_loc4_ < _loc3_.length)
               {
                  if(_loc3_[_loc4_].isNew)
                  {
                     _loc5_ = true;
                     break;
                  }
                  _loc4_++;
               }
               if(!_loc5_)
               {
                  _loc2_.setNewFlag(false);
               }
            }
         }
      }
      
      protected function handleItemUpdate(param1:Object) : void
      {
         var _loc5_:AdvancedTabListItem = null;
         var _loc2_:ItemDataStub = param1 as ItemDataStub;
         var _loc3_:int = mcTabList.selectedIndex;
         if(_loc2_.tabIndex != -1)
         {
            _loc3_ = _loc2_.tabIndex;
         }
         mcTabList.validateNow();
         var _loc4_:Array;
         (_loc4_ = new Array()).push(_loc2_);
         updateDataSurgicallyInCurrentTab(_loc3_,_loc4_);
         this.mcPlayerGrid.updateItemData(param1);
         invalidate(INVALIDATE_CONTEXT);
         open();
         if(_loc2_.isNew)
         {
            if(_loc5_ = mcTabList.getRendererAt(_loc2_.tabIndex) as AdvancedTabListItem)
            {
               _loc5_.setNewFlag(true);
            }
         }
      }
      
      protected function handleItemsUpdate(param1:Array) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:int = 0;
         var _loc7_:Object = null;
         var _loc8_:ItemDataStub = null;
         var _loc9_:AdvancedTabListItem = null;
         var _loc4_:Array = new Array();
         var _loc5_:int = mcTabList.selectedIndex;
         var _loc6_:Boolean = false;
         if(param1)
         {
            _loc3_ = int(param1.length);
            _loc2_ = 0;
            while(_loc2_ < _loc3_)
            {
               if((_loc8_ = (_loc7_ = param1[_loc2_]) as ItemDataStub).tabIndex != -1)
               {
                  _loc5_ = _loc8_.tabIndex;
               }
               if(_loc8_.isNew)
               {
                  _loc6_ = true;
               }
               _loc4_.push(_loc8_);
               _loc2_++;
            }
            this.mcPlayerGrid.updateItems(_loc4_);
            updateDataSurgicallyInCurrentTab(_loc5_,_loc4_);
            mcTabList.validateNow();
            invalidate(INVALIDATE_CONTEXT);
            open();
            if(_loc6_)
            {
               if(_loc9_ = mcTabList.getRendererAt(_loc5_) as AdvancedTabListItem)
               {
                  _loc9_.setNewFlag(true);
               }
            }
         }
      }
      
      override protected function draw() : void
      {
         super.draw();
         if(isInvalid(INVALIDATE_CONTEXT))
         {
            this.updateActiveContext();
         }
      }
      
      protected function updateActiveContext() : void
      {
         var _loc5_:ItemDataStub = null;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:Point = new Point();
         var _loc4_:SlotBase = this.mcPlayerGrid.getSelectedRenderer() as SlotBase;
         if(focused == 0)
         {
            return;
         }
         if(Boolean(_loc4_) && this.mcPlayerGrid.enabled)
         {
            if(_loc5_ = _loc4_.data as ItemDataStub)
            {
               _loc2_ = _loc5_.id;
               _loc1_ = uint(_loc5_.slotType);
            }
            _loc6_ = _loc4_.x + _loc4_.getSlotRect().width;
            _loc7_ = _loc4_.y + _loc4_.getSlotRect().height;
            _loc3_ = _loc4_.parent.localToGlobal(new Point(_loc6_,_loc7_));
         }
         dispatchEvent(new GameEvent(GameEvent.CALL,"OnSelectInventoryItem",[_loc2_,_loc1_,_loc3_.x,_loc3_.y]));
      }
      
      public function forceSelectItem(param1:int) : void
      {
         if(this.mcPlayerGrid)
         {
            this.mcPlayerGrid.selectedIndex = param1;
         }
      }
      
      override public function set focused(param1:Number) : void
      {
         if(param1 > 0 && param1 != _focused)
         {
            dispatchEvent(new GameEvent(GameEvent.CALL,"OnSetCurrentPlayerGrid",[dataBindingKey]));
         }
         super.focused = param1;
         invalidate(INVALIDATE_CONTEXT);
         if(isOpen)
         {
            this.mcPlayerGrid.applySelectionContext();
            this.checkTabNewFlag(this.mcPlayerGrid.getSelectedRenderer() as SlotBase);
         }
      }
      
      public function SetOverburdened(param1:Boolean) : void
      {
         var _loc2_:int = 0;
         var _loc3_:SlotInventoryGrid = null;
         _loc2_ = 0;
         while(_loc2_ < this.mcPlayerGrid.getRenderersLength())
         {
            _loc3_ = this.mcPlayerGrid.getRendererAt(_loc2_) as SlotInventoryGrid;
            if(_loc3_)
            {
               _loc3_.setOverburdened(param1);
            }
            _loc2_ += 1;
         }
      }
      
      override public function getDataShowerForTab(param1:int) : UIComponent
      {
         return this.mcPlayerGrid;
      }
      
      public function get CurrentItemDataStub() : ItemDataStub
      {
         return null;
      }
      
      override protected function setSubData(param1:int, param2:Array) : void
      {
         super.setSubData(param1,param2);
      }
      
      public function inventoryRemoveItem(param1:int, param2:Boolean = false) : void
      {
         mcTabList.validateNow();
         this.mcPlayerGrid.removeItem(param1,param2);
         var _loc3_:Array = new Array();
         _loc3_.push(param1);
         removeDataSurgicallyInCurrentTab(mcTabList.selectedIndex,_loc3_);
      }
      
      public function getSlotByID(param1:int) : SlotInventoryGrid
      {
         return this.mcPlayerGrid.getSlotByID(param1) as SlotInventoryGrid;
      }
      
      protected function handleMaskTweenComplete(param1:GTween) : void
      {
         this.maskTweener = null;
      }
      
      override protected function ApplyCloseAnimationToMask() : *
      {
         this.maskClip = getChildByName("mcGridMask") as MovieClip;
         if(this.maskClip)
         {
            if(this.maskTweener)
            {
               this.maskTweener.paused = true;
               GTweener.removeTweens(this.maskClip);
            }
            this.maskTweener = GTweener.to(this.maskClip,0.2,{"height":ClosedListScale * this._gridRenderHeight},{
               "onComplete":this.handleMaskTweenComplete,
               "ease":Sine.easeOut
            });
         }
      }
      
      override protected function ApplyOpenAnimationToMask() : *
      {
         this.maskClip = getChildByName("mcGridMask") as MovieClip;
         if(this.maskClip)
         {
            if(this.maskTweener)
            {
               this.maskTweener.paused = true;
               GTweener.removeTweens(this.maskClip);
            }
            this.maskTweener = GTweener.to(this.maskClip,0.2,{"height":this._gridRenderHeight},{
               "onComplete":this.handleMaskTweenComplete,
               "ease":Sine.easeOut
            });
         }
      }
      
      override public function handleInput(param1:InputEvent) : void
      {
         if(!InputManager.getInstance().isGamepad() && param1.details.code == KeyCode.ESCAPE)
         {
            return;
         }
         super.handleInput(param1);
      }
   }
}
