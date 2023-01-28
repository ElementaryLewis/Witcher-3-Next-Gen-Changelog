package red.game.witcher3.hud.modules.lootpopup
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import red.core.constants.KeyCode;
   import red.core.events.GameEvent;
   import red.game.witcher3.controls.W3ScrollingList;
   import red.game.witcher3.events.ControllerChangeEvent;
   import red.game.witcher3.events.InputFeedbackEvent;
   import red.game.witcher3.managers.InputManager;
   import red.game.witcher3.menus.common_menu.ModuleInputFeedback;
   import red.game.witcher3.utils.CommonUtils;
   import scaleform.clik.constants.InputValue;
   import scaleform.clik.constants.NavigationCode;
   import scaleform.clik.controls.CoreList;
   import scaleform.clik.controls.ListItemRenderer;
   import scaleform.clik.controls.ScrollBar;
   import scaleform.clik.core.UIComponent;
   import scaleform.clik.data.DataProvider;
   import scaleform.clik.events.ButtonEvent;
   import scaleform.clik.events.InputEvent;
   import scaleform.clik.events.ListEvent;
   import scaleform.clik.ui.InputDetails;
   import scaleform.gfx.MouseEventEx;
   
   public class HudLootItemModule extends UIComponent
   {
       
      
      public var mcLootItemsList:W3ScrollingList;
      
      public var mcLootItemsListItem1:HudLootItemsListItem;
      
      public var mcLootItemsListItem2:HudLootItemsListItem;
      
      public var mcLootItemsListItem3:HudLootItemsListItem;
      
      public var mcLootItemsListItem4:HudLootItemsListItem;
      
      public var mcScrollBar:ScrollBar;
      
      public var mcInputFeedback:ModuleInputFeedback;
      
      public var tfTitle:TextField;
      
      public var mcBackground:MovieClip;
      
      protected var _inputHandlers:Vector.<UIComponent>;
      
      public var _bWaitForKey:Boolean = false;
      
      public var m_isPCVersion:Boolean;
      
      private var m_data:Array;
      
      private var m_mouseOverIndex:int;
      
      public var m_indexToSelect:int;
      
      private const ACTION_TAKE = 0;
      
      private const ACTION_TAKE_ALL = 1;
      
      private const ACTION_CLOSE = 2;
      
      private const SCROLL_PADDING = 24;
      
      private var _backgroundActualWidth:Number;
      
      protected var _lastMoveWasMouse:Boolean = false;
      
      protected var _lastMouseOveredItem:int = -1;
      
      public function HudLootItemModule()
      {
         super();
         this._inputHandlers = new Vector.<UIComponent>();
         this.tfTitle.text = "";
         this.tfTitle.visible = false;
         this._backgroundActualWidth = 513.55;
         this.mcInputFeedback.buttonAlign = "center";
      }
      
      public function set lastMoveWasMouse(param1:Boolean) : void
      {
         var _loc2_:HudLootItemsListItem = null;
         if(this._lastMoveWasMouse == param1)
         {
            return;
         }
         this._lastMoveWasMouse = param1;
         if(!this._lastMoveWasMouse)
         {
            if(this.mcLootItemsList.selectedIndex == -1)
            {
               this.mcLootItemsList.selectedIndex = 0;
            }
         }
         else
         {
            if(this._lastMouseOveredItem == -1)
            {
               this.mcLootItemsList.selectedIndex = -1;
            }
            else
            {
               _loc2_ = this.mcLootItemsList.getRendererAt(this._lastMouseOveredItem) as HudLootItemsListItem;
               if(_loc2_)
               {
                  this.mcLootItemsList.selectedIndex = _loc2_.index;
               }
            }
            this.mcLootItemsList.validateNow();
         }
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         visible = false;
         this.mcInputFeedback.directWsCall = false;
         this.mcInputFeedback.appendButton(this.ACTION_TAKE_ALL,NavigationCode.GAMEPAD_Y,KeyCode.SPACE,"[[panel_button_common_take_all]]",false);
         this.mcInputFeedback.appendButton(this.ACTION_TAKE,NavigationCode.GAMEPAD_A,KeyCode.E,"[[panel_button_common_take]]",false);
         this.mcInputFeedback.appendButton(this.ACTION_CLOSE,NavigationCode.GAMEPAD_B,KeyCode.ESCAPE,"[[panel_button_common_close]]",true);
         this.mcInputFeedback.addEventListener(InputFeedbackEvent.USER_ACTION,this.handleUserAction,false,0,true);
         this.mcLootItemsList.bSkipFocusCheck = true;
         this.registerMouseEvents();
         stage.addEventListener(MouseEvent.MOUSE_MOVE,this.handleMouseMove,true,100,true);
         this._inputHandlers.push(this.mcLootItemsList);
         this.mcLootItemsList.addEventListener(ListEvent.INDEX_CHANGE,this.handleSelectChange,false,0,true);
         InputManager.getInstance().addEventListener(ControllerChangeEvent.CONTROLLER_CHANGE,this.handleControllerChange,false,0,true);
         if(this.mcLootItemsList.scrollBar)
         {
            this.mcLootItemsList.scrollBar.addEventListener(Event.SCROLL,this.handleScroll,false,1,true);
         }
      }
      
      protected function handleMouseMove(param1:MouseEvent) : void
      {
         this.lastMoveWasMouse = true;
      }
      
      public function registerMouseEvents() : *
      {
         stage.addEventListener(MouseEvent.CLICK,this.onStageClick,false,1,true);
         this.mcLootItemsListItem1.addEventListener(MouseEvent.CLICK,this.onLootItemClicked,false,0,true);
         this.mcLootItemsListItem1.addEventListener(MouseEvent.MOUSE_OVER,this.onLootItemMouseOver,false,0,true);
         this.mcLootItemsListItem1.addEventListener(MouseEvent.MOUSE_OUT,this.onLootItemMouseOver,false,0,true);
         this.mcLootItemsListItem2.addEventListener(MouseEvent.CLICK,this.onLootItemClicked,false,0,true);
         this.mcLootItemsListItem2.addEventListener(MouseEvent.MOUSE_OVER,this.onLootItemMouseOver,false,0,true);
         this.mcLootItemsListItem2.addEventListener(MouseEvent.MOUSE_OUT,this.onLootItemMouseOver,false,0,true);
         this.mcLootItemsListItem3.addEventListener(MouseEvent.CLICK,this.onLootItemClicked,false,0,true);
         this.mcLootItemsListItem3.addEventListener(MouseEvent.MOUSE_OVER,this.onLootItemMouseOver,false,0,true);
         this.mcLootItemsListItem3.addEventListener(MouseEvent.MOUSE_OUT,this.onLootItemMouseOver,false,0,true);
         this.mcLootItemsListItem4.addEventListener(MouseEvent.CLICK,this.onLootItemClicked,false,0,true);
         this.mcLootItemsListItem4.addEventListener(MouseEvent.MOUSE_OVER,this.onLootItemMouseOver,false,0,true);
         this.mcLootItemsListItem4.addEventListener(MouseEvent.MOUSE_OUT,this.onLootItemMouseOver,false,0,true);
      }
      
      protected function onLootItemClicked(param1:MouseEvent) : void
      {
         var _loc2_:MouseEventEx = param1 as MouseEventEx;
         if(_loc2_.buttonIdx == MouseEventEx.LEFT_BUTTON)
         {
            this.handleTakeButtonClick(null);
            param1.stopImmediatePropagation();
         }
         else if(_loc2_.buttonIdx == MouseEventEx.RIGHT_BUTTON)
         {
            this.handleCloseButtonClick();
            param1.stopImmediatePropagation();
         }
      }
      
      protected function onStageClick(param1:MouseEvent) : void
      {
         var _loc2_:MouseEventEx = param1 as MouseEventEx;
         if(_loc2_.buttonIdx == MouseEventEx.RIGHT_BUTTON)
         {
            this.handleCloseButtonClick();
            param1.stopImmediatePropagation();
         }
      }
      
      protected function onLootItemMouseOver(param1:MouseEvent) : void
      {
         var _loc2_:HudLootItemsListItem = param1.currentTarget as HudLootItemsListItem;
         this._lastMouseOveredItem = this.mcLootItemsList.getRenderers().indexOf(_loc2_);
         if(this._lastMoveWasMouse)
         {
            this.mcLootItemsList.selectedIndex = _loc2_.index;
         }
      }
      
      protected function onLootItemMouseOut(param1:MouseEvent) : void
      {
         this._lastMouseOveredItem = -1;
         if(this._lastMoveWasMouse)
         {
            this.mcLootItemsList.selectedIndex = -1;
         }
      }
      
      protected function handleControllerChange(param1:ControllerChangeEvent) : void
      {
         if(param1.isGamepad)
         {
            this.lastMoveWasMouse = false;
         }
      }
      
      private function handleUserAction(param1:InputFeedbackEvent) : void
      {
         var _loc2_:InputEvent = param1.inputEventRef;
         if(_loc2_)
         {
            if(_loc2_.details.value == InputValue.KEY_UP)
            {
               return;
            }
         }
         switch(param1.actionId)
         {
            case this.ACTION_TAKE_ALL:
               this.handleTakeAllButtonClick(null);
               break;
            case this.ACTION_TAKE:
               this.handleTakeButtonClick(null);
               break;
            case this.ACTION_CLOSE:
               this.handleCloseButtonClick();
         }
      }
      
      public function resizeBackground(param1:Boolean) : void
      {
         if(param1)
         {
            this.mcBackground.width = this._backgroundActualWidth;
         }
         else
         {
            this.mcBackground.width = this._backgroundActualWidth - this.SCROLL_PADDING;
         }
      }
      
      public function handleItemListData(param1:Object, param2:int) : void
      {
         var _loc3_:Array = param1 as Array;
         this.mcLootItemsList.dataProvider = new DataProvider(_loc3_);
         this.mcLootItemsList.validateNow();
         this.m_data = param1 as Array;
         if(!this.m_isPCVersion && this.mcLootItemsList.dataProvider.length > 0)
         {
            this.mcLootItemsList.selectedIndex = 0;
            CoreList(this.mcLootItemsList).getRendererAt(0).selected = true;
            stage.focus = CoreList(this.mcLootItemsList).getRendererAt(0) as ListItemRenderer;
         }
         this.mcLootItemsList.validateNow();
         this.mcLootItemsList.selectedIndex = Math.min(this.m_indexToSelect,_loc3_.length - 1);
         var _loc4_:* = this.m_data.length < 1;
         this.mcInputFeedback.disableButton(this.ACTION_TAKE,_loc4_);
         this.mcInputFeedback.disableButton(this.ACTION_TAKE_ALL,_loc4_);
         visible = true;
      }
      
      private function handleTakeButtonClick(param1:ListEvent) : void
      {
         if(this._bWaitForKey)
         {
            dispatchEvent(new GameEvent(GameEvent.CALL,"OnPopupTakeItem",[this.mcLootItemsList.selectedIndex]));
            if(this.mcLootItemsList.dataProvider.length - 1 <= this.mcLootItemsList.selectedIndex)
            {
               this.mcLootItemsList.selectedIndex = this.mcLootItemsList.dataProvider.length - 2;
               this.mcLootItemsList.validateNow();
            }
         }
      }
      
      private function handleTakeAllButtonClick(param1:ButtonEvent = null) : void
      {
         dispatchEvent(new GameEvent(GameEvent.CALL,"OnPopupTakeAllItems"));
      }
      
      private function handleCloseButtonClick(param1:ButtonEvent = null) : void
      {
         dispatchEvent(new GameEvent(GameEvent.CALL,"OnCloseLootWindow"));
      }
      
      private function handleRollOver(param1:ListEvent) : void
      {
      }
      
      private function handleRollOut(param1:ListEvent) : void
      {
      }
      
      private function handleScroll(param1:Event) : void
      {
         var _loc2_:HudLootItemsListItem = null;
         this.mcLootItemsList.validateNow();
         if(this._lastMouseOveredItem != -1 && this._lastMoveWasMouse)
         {
            _loc2_ = this.mcLootItemsList.getRendererAt(this._lastMouseOveredItem) as HudLootItemsListItem;
            if(_loc2_)
            {
               this.mcLootItemsList.selectedIndex = _loc2_.index;
               this.mcLootItemsList.validateNow();
            }
         }
      }
      
      private function handleSelectChange(param1:ListEvent) : void
      {
      }
      
      override public function handleInput(param1:InputEvent) : void
      {
         var _loc2_:InputDetails = param1.details;
         var _loc3_:* = _loc2_.value == InputValue.KEY_DOWN;
         CommonUtils.convertWASDCodeToNavEquivalent(_loc2_);
         if(_loc2_.navEquivalent == NavigationCode.UP || _loc2_.navEquivalent == NavigationCode.DOWN || _loc2_.navEquivalent == NavigationCode.LEFT || _loc2_.navEquivalent == NavigationCode.RIGHT)
         {
            this.lastMoveWasMouse = false;
         }
         if(_loc3_)
         {
            if(_loc2_.code == KeyCode.E)
            {
            }
         }
      }
   }
}
