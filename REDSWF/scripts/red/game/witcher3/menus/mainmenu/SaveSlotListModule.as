package red.game.witcher3.menus.mainmenu
{
   import com.gskinner.motion.GTween;
   import com.gskinner.motion.GTweener;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import red.core.CoreMenuModule;
   import red.core.constants.KeyCode;
   import red.core.events.GameEvent;
   import red.game.witcher3.controls.W3ScrollingList;
   import red.game.witcher3.controls.W3UILoader;
   import red.game.witcher3.events.ControllerChangeEvent;
   import red.game.witcher3.managers.InputManager;
   import scaleform.clik.constants.InputValue;
   import scaleform.clik.constants.NavigationCode;
   import scaleform.clik.controls.ScrollBar;
   import scaleform.clik.data.DataProvider;
   import scaleform.clik.events.InputEvent;
   import scaleform.clik.events.ListEvent;
   import scaleform.clik.ui.InputDetails;
   import scaleform.gfx.MouseEventEx;
   
   public class SaveSlotListModule extends CoreMenuModule
   {
      
      public static const SLOT_MODE_SAVES:int = 0;
      
      public static const SLOT_MODE_LOAD:int = 1;
      
      public static const SLOT_MODE_IMPORT:int = 2;
      
      public static const SLOT_MODE_NEWGAME_PLUS:int = 3;
      
      public static const CST_CLOUD = 30;
       
      
      public var mcScrollingList:W3ScrollingList;
      
      public var mcSaveSlotItem1:SaveSlotItemRenderer;
      
      public var mcSaveSlotItem2:SaveSlotItemRenderer;
      
      public var mcSaveSlotItem3:SaveSlotItemRenderer;
      
      public var mcSaveSlotItem4:SaveSlotItemRenderer;
      
      public var mcSaveSlotItem5:SaveSlotItemRenderer;
      
      public var mcSaveSlotItem6:SaveSlotItemRenderer;
      
      public var mcSaveSlotItem7:SaveSlotItemRenderer;
      
      public var mcSaveSlotItem8:SaveSlotItemRenderer;
      
      public var mcSaveSlotItem9:SaveSlotItemRenderer;
      
      public var mcSaveSlotItem10:SaveSlotItemRenderer;
      
      public var mcSaveSlotItem11:SaveSlotItemRenderer;
      
      public var mcSlotPreview:W3UILoader;
      
      public var mcScrollbar:ScrollBar;
      
      public var slotMode:int;
      
      protected var saveImageTimer:Timer;
      
      protected var loadingSaveImageTimer:Timer;
      
      protected var _lastRequestedSaveImage:String;
      
      protected var _lastRequestedSaveImageTag:int;
      
      protected var _isLoadingScreenshot:Boolean = false;
      
      public var _lastMoveWasMouse:Boolean = false;
      
      protected var _lastMouseOveredItem:int = -1;
      
      public function SaveSlotListModule()
      {
         super();
      }
      
      public function get lastMoveWasMouse() : Boolean
      {
         return this._lastMoveWasMouse;
      }
      
      public function set lastMoveWasMouse(param1:Boolean) : void
      {
         var _loc2_:SaveSlotItemRenderer = null;
         this._lastMoveWasMouse = param1;
         if(!this._lastMoveWasMouse)
         {
            if(this.mcScrollingList.selectedIndex == -1)
            {
               this.mcScrollingList.selectedIndex = 0;
            }
         }
         else if(this._lastMouseOveredItem != -1)
         {
            _loc2_ = this.mcScrollingList.getRendererAt(this._lastMouseOveredItem) as SaveSlotItemRenderer;
            if(_loc2_)
            {
               this.mcScrollingList.selectedIndex = _loc2_.index;
               this.mcScrollingList.validateNow();
            }
         }
         else
         {
            this.mcScrollingList.selectedIndex = this._lastMouseOveredItem;
         }
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         enabled = false;
         visible = false;
         alpha = 0;
         if(this.mcScrollingList)
         {
            this.mcScrollingList.focusable = false;
            this.mcScrollingList.addEventListener(ListEvent.INDEX_CHANGE,this.onSaveSlotSelected,false,0,true);
         }
         if(this.mcScrollbar)
         {
            this.mcScrollbar.addEventListener(Event.SCROLL,this.handleScroll,false,1,true);
         }
      }
      
      public function registerMouseEvents() : void
      {
         this.registerMouseEventsForItem(this.mcSaveSlotItem1);
         this.registerMouseEventsForItem(this.mcSaveSlotItem2);
         this.registerMouseEventsForItem(this.mcSaveSlotItem3);
         this.registerMouseEventsForItem(this.mcSaveSlotItem4);
         this.registerMouseEventsForItem(this.mcSaveSlotItem5);
         this.registerMouseEventsForItem(this.mcSaveSlotItem6);
         this.registerMouseEventsForItem(this.mcSaveSlotItem7);
         this.registerMouseEventsForItem(this.mcSaveSlotItem8);
         this.registerMouseEventsForItem(this.mcSaveSlotItem9);
         this.registerMouseEventsForItem(this.mcSaveSlotItem10);
         this.registerMouseEventsForItem(this.mcSaveSlotItem11);
         InputManager.getInstance().addEventListener(ControllerChangeEvent.CONTROLLER_CHANGE,this.handleControllerChange,false,0,true);
      }
      
      public function unregisteredMouseEvents() : void
      {
         this.unregisterMouseEventsForItem(this.mcSaveSlotItem1);
         this.unregisterMouseEventsForItem(this.mcSaveSlotItem2);
         this.unregisterMouseEventsForItem(this.mcSaveSlotItem3);
         this.unregisterMouseEventsForItem(this.mcSaveSlotItem4);
         this.unregisterMouseEventsForItem(this.mcSaveSlotItem5);
         this.unregisterMouseEventsForItem(this.mcSaveSlotItem6);
         this.unregisterMouseEventsForItem(this.mcSaveSlotItem7);
         this.unregisterMouseEventsForItem(this.mcSaveSlotItem8);
         this.unregisterMouseEventsForItem(this.mcSaveSlotItem9);
         this.unregisterMouseEventsForItem(this.mcSaveSlotItem10);
         this.unregisterMouseEventsForItem(this.mcSaveSlotItem11);
         InputManager.getInstance().removeEventListener(ControllerChangeEvent.CONTROLLER_CHANGE,this.handleControllerChange);
      }
      
      protected function registerMouseEventsForItem(param1:SaveSlotItemRenderer) : void
      {
         param1.addEventListener(MouseEvent.CLICK,this.onItemClicked,false,0,true);
         param1.addEventListener(MouseEvent.MOUSE_OVER,this.onItemMouseOver,false,0,true);
         param1.addEventListener(MouseEvent.MOUSE_OUT,this.onItemMouseOut,false,0,true);
      }
      
      protected function unregisterMouseEventsForItem(param1:SaveSlotItemRenderer) : void
      {
         param1.removeEventListener(MouseEvent.CLICK,this.onItemClicked);
         param1.removeEventListener(MouseEvent.MOUSE_OVER,this.onItemMouseOver);
         param1.removeEventListener(MouseEvent.MOUSE_OUT,this.onItemMouseOut);
      }
      
      protected function onItemClicked(param1:MouseEvent) : void
      {
         var _loc2_:MouseEventEx = param1 as MouseEventEx;
         if(_loc2_.buttonIdx == MouseEventEx.LEFT_BUTTON)
         {
            this.activateSelectedSlot();
         }
      }
      
      protected function onItemMouseOver(param1:MouseEvent) : void
      {
         var _loc2_:SaveSlotItemRenderer = param1.currentTarget as SaveSlotItemRenderer;
         this._lastMouseOveredItem = this.mcScrollingList.getRenderers().indexOf(_loc2_);
         if(this._lastMoveWasMouse)
         {
            this.mcScrollingList.selectedIndex = _loc2_.index;
         }
      }
      
      protected function onItemMouseOut(param1:MouseEvent) : void
      {
         this._lastMouseOveredItem = -1;
         if(this._lastMoveWasMouse)
         {
            this.mcScrollingList.selectedIndex = -1;
         }
      }
      
      private function handleScroll(param1:Event) : void
      {
         var _loc2_:SaveSlotItemRenderer = null;
         this.mcScrollingList.validateNow();
         if(this._lastMouseOveredItem != -1 && this._lastMoveWasMouse)
         {
            _loc2_ = this.mcScrollingList.getRendererAt(this._lastMouseOveredItem) as SaveSlotItemRenderer;
            if(_loc2_)
            {
               this.mcScrollingList.selectedIndex = _loc2_.index;
               this.mcScrollingList.validateNow();
            }
         }
      }
      
      protected function handleControllerChange(param1:ControllerChangeEvent) : void
      {
         if(param1.isGamepad)
         {
            if(this.mcScrollingList.selectedIndex == -1)
            {
               this.mcScrollingList.selectedIndex = 0;
            }
         }
         else if(this._lastMoveWasMouse)
         {
            this.mcScrollingList.selectedIndex = this._lastMouseOveredItem;
         }
      }
      
      public function showWithData(param1:Array, param2:int) : void
      {
         this.slotMode = param2;
         this.mcSlotPreview.visible = false;
         visible = true;
         GTweener.removeTweens(this);
         GTweener.to(this,0.2,{"alpha":1},{});
         if(this.mcScrollingList)
         {
            this.mcScrollingList.dataProvider = new DataProvider(param1);
            this.mcScrollingList.validateNow();
            if(this.mcScrollingList.selectedIndex == 0)
            {
               dispatchEvent(new GameEvent(GameEvent.CALL,"OnPlaySoundEvent",["gui_global_highlight"]));
            }
            this.mcScrollingList.selectedIndex = 0;
         }
         this.registerMouseEvents();
         this.displaySelectedSavesScreenshot();
      }
      
      public function hide() : void
      {
         if(visible)
         {
            GTweener.removeTweens(this);
            enabled = false;
            GTweener.to(this,0.2,{"alpha":0},{"onComplete":this.onHideComplete});
            this.unregisteredMouseEvents();
            if(this.saveImageTimer)
            {
               this.saveImageTimer.stop();
            }
            if(this.mcSlotPreview.visible)
            {
               this.mcSlotPreview.visible = false;
               dispatchEvent(new GameEvent(GameEvent.CALL,"OnLoadSaveImageCancelled"));
            }
         }
      }
      
      protected function onHideComplete(param1:GTween) : void
      {
         this._lastRequestedSaveImage = "";
         this.mcSlotPreview.source = "";
         visible = false;
      }
      
      public function handleInputNavigate(param1:InputEvent) : void
      {
         var _loc2_:InputDetails = null;
         var _loc3_:* = false;
         if(visible)
         {
            _loc2_ = param1.details;
            _loc3_ = _loc2_.value == InputValue.KEY_UP;
            if(_loc3_ && !param1.handled)
            {
               switch(_loc2_.navEquivalent)
               {
                  case NavigationCode.GAMEPAD_B:
                     this.handleNavigateBack();
                     param1.handled = true;
                     break;
                  case NavigationCode.GAMEPAD_A:
                     this.activateSelectedSlot();
                     param1.handled = true;
                     break;
                  case NavigationCode.GAMEPAD_X:
                     this.tryDeleteSlot();
                     param1.handled = true;
                     break;
                  case NavigationCode.GAMEPAD_L2:
                     this.activateCloudSaves();
                     param1.handled = true;
               }
               if(!param1.handled)
               {
                  if(_loc2_.code == KeyCode.DELETE)
                  {
                     this.tryDeleteSlot();
                  }
                  else if(_loc2_.code == KeyCode.E)
                  {
                     this.activateSelectedSlot();
                     param1.handled = true;
                  }
                  else if(_loc2_.code == KeyCode.C)
                  {
                     this.activateCloudSaves();
                     param1.handled = true;
                  }
               }
            }
            if(!param1.handled)
            {
               this.mcScrollingList.handleInput(param1);
            }
         }
      }
      
      protected function trySyncSlot() : void
      {
         var _loc1_:SaveSlotItemRenderer = null;
         if(this.slotMode != SLOT_MODE_IMPORT && this.slotMode != SLOT_MODE_NEWGAME_PLUS)
         {
            _loc1_ = this.mcScrollingList.getSelectedRenderer() as SaveSlotItemRenderer;
            if(Boolean(_loc1_) && _loc1_.data.tag != -1)
            {
               this.handleNavigateBack();
               dispatchEvent(new GameEvent(GameEvent.CALL,"OnSyncSaveCalled",[_loc1_.data.saveType,_loc1_.data.tag,this.slotMode == SLOT_MODE_SAVES]));
            }
         }
      }
      
      protected function activateCloudSaves() : void
      {
         var _loc1_:IngameMenu = null;
         if(this.slotMode != SLOT_MODE_IMPORT && this.slotMode != SLOT_MODE_NEWGAME_PLUS)
         {
            _loc1_ = parent as IngameMenu;
            if(_loc1_)
            {
               if(_loc1_.isCloudUserSignedIn)
               {
                  dispatchEvent(new GameEvent(GameEvent.CALL,"OnShowCloudModalCalled"));
               }
               else
               {
                  this.handleNavigateBack();
                  dispatchEvent(new GameEvent(GameEvent.CALL,"OnLoginCloudCalled"));
               }
            }
         }
      }
      
      protected function tryDeleteSlot() : void
      {
         var _loc1_:SaveSlotItemRenderer = null;
         var _loc2_:IngameMenu = null;
         if(this.slotMode != SLOT_MODE_IMPORT && this.slotMode != SLOT_MODE_NEWGAME_PLUS)
         {
            _loc1_ = this.mcScrollingList.getSelectedRenderer() as SaveSlotItemRenderer;
            if(_loc1_.data.cloudStatus == CST_CLOUD)
            {
               return;
            }
            if(Boolean(_loc1_) && _loc1_.data.tag != -1)
            {
               _loc2_ = parent as IngameMenu;
               if(_loc2_)
               {
                  _loc2_.setIgnoreInput(true);
               }
               dispatchEvent(new GameEvent(GameEvent.CALL,"OnDeleteSaveCalled",[_loc1_.data.saveType,_loc1_.data.tag,this.slotMode == SLOT_MODE_SAVES]));
            }
         }
      }
      
      protected function activateSelectedSlot() : void
      {
         var _loc1_:SaveSlotItemRenderer = this.mcScrollingList.getSelectedRenderer() as SaveSlotItemRenderer;
         var _loc2_:IngameMenu = parent as IngameMenu;
         if(_loc1_)
         {
            switch(this.slotMode)
            {
               case SLOT_MODE_SAVES:
                  if(_loc2_)
                  {
                     _loc2_.setIgnoreInput(true);
                  }
                  dispatchEvent(new GameEvent(GameEvent.CALL,"OnSaveGameCalled",[_loc1_.data.saveType,_loc1_.data.tag]));
                  break;
               case SLOT_MODE_LOAD:
                  if(_loc2_)
                  {
                     _loc2_.setIgnoreInput(true);
                  }
                  dispatchEvent(new GameEvent(GameEvent.CALL,"OnLoadGameCalled",[_loc1_.data.saveType,_loc1_.data.tag]));
                  break;
               case SLOT_MODE_IMPORT:
                  dispatchEvent(new GameEvent(GameEvent.CALL,"OnImportGameCalled",[_loc1_.data.tag]));
                  break;
               case SLOT_MODE_NEWGAME_PLUS:
                  dispatchEvent(new GameEvent(GameEvent.CALL,"OnNewGamePlusCalled",[_loc1_.data.tag]));
            }
         }
      }
      
      public function onRightClick(param1:MouseEvent) : void
      {
         if(visible)
         {
            this.handleNavigateBack();
         }
      }
      
      protected function handleNavigateBack() : void
      {
         dispatchEvent(new Event(IngameMenu.OnOptionPanelClosed,false,false));
      }
      
      protected function onSaveSlotSelected(param1:ListEvent) : void
      {
         if(this.slotMode != SLOT_MODE_IMPORT)
         {
            this.displaySelectedSavesScreenshot();
         }
      }
      
      protected function displaySelectedSavesScreenshot() : void
      {
         var _loc1_:SaveSlotItemRenderer = this.mcScrollingList.getSelectedRenderer() as SaveSlotItemRenderer;
         if(Boolean(_loc1_) && Boolean(_loc1_.data))
         {
            if(_loc1_.data.tag == -1)
            {
               this.mcSlotPreview.visible = false;
            }
            else
            {
               this.setSelectedSaveSlotImage(_loc1_.data.filename,_loc1_.data.tag);
            }
            this.mcSlotPreview.y = _loc1_.y;
         }
         else
         {
            this.mcSlotPreview.visible = false;
         }
      }
      
      protected function setSelectedSaveSlotImage(param1:String, param2:int) : void
      {
         this.mcSlotPreview.visible = false;
         if(param1 != "")
         {
            if(!this.saveImageTimer)
            {
               this.saveImageTimer = new Timer(200,1);
               this.saveImageTimer.addEventListener(TimerEvent.TIMER,this.showSaveImageTimerDone);
            }
            this.stopLoadingTimer();
            if(param1 != this._lastRequestedSaveImage || !this.saveImageTimer.running || this.loadingSaveImageTimer && !this.loadingSaveImageTimer.running)
            {
               this.saveImageTimer.reset();
               this.saveImageTimer.start();
               this._lastRequestedSaveImage = param1 + ".sav";
               this._lastRequestedSaveImageTag = param2;
            }
         }
      }
      
      protected function stopLoadingTimer() : void
      {
         if(this.loadingSaveImageTimer)
         {
            if(this.loadingSaveImageTimer.running)
            {
               dispatchEvent(new GameEvent(GameEvent.CALL,"OnLoadSaveImageCancelled"));
            }
            this.loadingSaveImageTimer.stop();
         }
      }
      
      protected function showSaveImageTimerDone(param1:TimerEvent) : void
      {
         if(!this.loadingSaveImageTimer)
         {
            this.loadingSaveImageTimer = new Timer(60);
            this.loadingSaveImageTimer.addEventListener(TimerEvent.TIMER,this.onLoadingSaveImageTimer);
         }
         this.loadingSaveImageTimer.reset();
         this.loadingSaveImageTimer.start();
         this._isLoadingScreenshot = true;
         dispatchEvent(new GameEvent(GameEvent.CALL,"OnScreenshotDataRequested",[this._lastRequestedSaveImageTag]));
      }
      
      protected function onLoadingSaveImageTimer(param1:TimerEvent) : void
      {
         dispatchEvent(new GameEvent(GameEvent.CALL,"OnCheckScreenshotDataReady"));
      }
      
      public function onLoadingScreenshotComplete() : void
      {
         if(this.slotMode != SLOT_MODE_IMPORT)
         {
            this.mcSlotPreview.visible = true;
            this.mcSlotPreview.source = this._lastRequestedSaveImage;
            if(this.loadingSaveImageTimer)
            {
               this.loadingSaveImageTimer.stop();
            }
         }
      }
   }
}
