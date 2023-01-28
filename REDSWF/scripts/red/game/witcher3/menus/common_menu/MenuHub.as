package red.game.witcher3.menus.common_menu
{
   import com.gskinner.motion.GTween;
   import com.gskinner.motion.GTweener;
   import com.gskinner.motion.easing.Sine;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import red.core.constants.KeyCode;
   import red.core.events.GameEvent;
   import red.game.witcher3.controls.ConditionalButton;
   import red.game.witcher3.controls.InputFeedbackButton;
   import red.game.witcher3.controls.InvisibleComponent;
   import red.game.witcher3.controls.W3ListSelectionTracker;
   import red.game.witcher3.controls.W3ScrollingList;
   import red.game.witcher3.controls.W3TextArea;
   import red.game.witcher3.controls.W3UILoader;
   import red.game.witcher3.events.ControllerChangeEvent;
   import red.game.witcher3.managers.InputManager;
   import red.game.witcher3.utils.CommonUtils;
   import red.game.witcher3.utils.FiniteStateMachine;
   import scaleform.clik.constants.InputValue;
   import scaleform.clik.constants.NavigationCode;
   import scaleform.clik.core.UIComponent;
   import scaleform.clik.data.DataProvider;
   import scaleform.clik.events.ButtonEvent;
   import scaleform.clik.events.InputEvent;
   import scaleform.clik.events.ListEvent;
   import scaleform.clik.managers.InputDelegate;
   import scaleform.clik.ui.InputDetails;
   
   public class MenuHub extends UIComponent
   {
      
      public static const OpenMenuCalled:String = "onOpenMenu";
      
      private static const IFB_ACTIVATE:int = 100;
      
      private static const IFB_NAVIGATE:int = 101;
      
      private static const IFB_NEXT_MENU:int = 102;
      
      private static const IFB_PRIOR_MENU:int = 103;
      
      private static const IFB_CLOSE:int = 1001;
      
      private static const TITLE_BTN_PADDING:int = 35;
      
      private static const TopTabAnimDuration:Number = 0.2;
      
      private static const TopTabUnfocusedAlpha:Number = 0.5;
      
      private static const TopTabUnfocusedScale:Number = 0.85;
      
      private static const TopTabYOffset:Number = -100;
      
      private static const BotTabAnimDuration:Number = 0.2;
      
      private static const BotHolderXOffset:Number = 0;
      
      private static const BotHolderYOffset:Number = -75;
      
      private static const BotUnfocusedYOffset:Number = 50;
      
      private static const BotFocusedAlpha:Number = 1;
      
      private static const BotUnfocusedAlpha:Number = 0.85;
      
      private static const BotFocusedScale:Number = 1;
      
      private static const BotUnfocusedScale:Number = 0.85;
      
      private static const TabBackgroundTopAlpha:Number = 0.85;
      
      private static const TabBackgroundBotAlpha:Number = 1;
      
      private static const TabBackgroundBotOffset:Number = -100;
      
      public static const State_Init:String = "Init";
      
      public static const State_TopTab:String = "TopTab";
      
      public static const State_BotTab:String = "BotTab";
      
      public static const State_Hidden:String = "Hidden";
      
      public static const State_Transition:String = "Trans";
       
      
      public var mcOpenMenuDataHolder:MovieClip;
      
      public var mcLeftPCButton:ConditionalButton;
      
      public var mcLeftGamepadButton:InputFeedbackButton;
      
      public var mcRightPCButton:ConditionalButton;
      
      public var mcRightGamepadButton:InputFeedbackButton;
      
      public var txtTabName:TextField;
      
      public var txtPrevTabName:W3TextArea;
      
      public var txtNextTabName:W3TextArea;
      
      public var mcSelectionTracker:W3ListSelectionTracker;
      
      protected var _selectLastChild:Boolean = false;
      
      protected var _allItemsList:Vector.<Object>;
      
      public var mcOpenHubDataContainer:MovieClip;
      
      public var refInputFeedback:ModuleInputFeedback;
      
      private var _blockMenuClosing:Boolean;
      
      private var _blockHubClosing:Boolean;
      
      private var _showOpenButton:Boolean;
      
      private var _showNavigateButton:Boolean;
      
      private var _showBackButton:Boolean;
      
      private var _showExitButton:Boolean;
      
      public var mcTopTabHolder:MovieClip;
      
      public var mcGridLine:MovieClip;
      
      public var txtTopMainDesc:W3TextArea;
      
      public var txtTabNewDesc:W3TextArea;
      
      public var txtBottomDesc:W3TextArea;
      
      public var mcItemsHistory:ItemsHistory;
      
      public var mcTrackedQuestDisplay:TrackedQuestInfo;
      
      public var mcGlossaryEntriesInfo:TextInfoContainer;
      
      public var mcAlchemyEntriesInfo:TextInfoContainer;
      
      public var mcSkillsEntriesInfo:TextInfoContainer;
      
      public var mcMapEntriesInfo:TextInfoContainerMap;
      
      private var currnetHubInfoTabName:String;
      
      public var mcTopTabList:W3ScrollingList;
      
      public var mcTopTabListItem1:MenuHubTabListItem;
      
      public var mcTopTabListItem2:MenuHubTabListItem;
      
      public var mcTopTabListItem3:MenuHubTabListItem;
      
      public var mcTopTabListItem4:MenuHubTabListItem;
      
      public var mcTopTabListItem5:MenuHubTabListItem;
      
      public var mcTopTabListItem6:MenuHubTabListItem;
      
      public var mcTopTabListItem7:MenuHubTabListItem;
      
      private var topHolderStartingY:Number;
      
      public var mcBotTabHolder:MovieClip;
      
      public var mcBotTabList:W3ScrollingList;
      
      public var mcBotTabListItem1:MenuHubTabListItem;
      
      public var mcBotTabListItem2:MenuHubTabListItem;
      
      public var mcBotTabListItem3:MenuHubTabListItem;
      
      public var mcBotTabListItem4:MenuHubTabListItem;
      
      public var mcBotTabListItem5:MenuHubTabListItem;
      
      public var mcBotTabListItem6:MenuHubTabListItem;
      
      private var botHolderStartingY:Number;
      
      private var botHolderStartingX:Number;
      
      public var mcTabBackground:MovieClip;
      
      private var tabBackgroundStartingY:Number;
      
      protected var stateMachine:FiniteStateMachine;
      
      public var navigationEnabled:Boolean = true;
      
      public var isShopInventory:Boolean = false;
      
      protected var ignoreNextTabChange:Boolean = false;
      
      public var rblbenabled:Boolean = true;
      
      private var hideRequested:Boolean = false;
      
      private var hideImmediately:Boolean = false;
      
      protected var _lastMoveWasMouse:Boolean = false;
      
      protected var _lastMouseOveredItem:MenuHubTabListItem;
      
      protected var topTabHolderTweener:GTween;
      
      protected var botTabHolderTweener:GTween;
      
      protected var backgroundImageTweener:GTween;
      
      protected var openTabImageTweener:GTween;
      
      private var _lastUpdatedTopTabIndex:int = -1;
      
      public function MenuHub()
      {
         super();
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         this.mcBotTabListItem1.isSmallTab = true;
         this.mcBotTabListItem2.isSmallTab = true;
         this.mcBotTabListItem3.isSmallTab = true;
         this.mcBotTabListItem4.isSmallTab = true;
         this.mcBotTabListItem5.isSmallTab = true;
         this.mcBotTabListItem6.isSmallTab = true;
         this.grabInitialValues();
         dispatchEvent(new GameEvent(GameEvent.REGISTER,"panel.main.panelinfo.newestitems",[this.handleItemsHistoryDataSet]));
         dispatchEvent(new GameEvent(GameEvent.REGISTER,"panel.main.panelinfo.quests",[this.handleTrackedQuestInfoDataSet]));
         dispatchEvent(new GameEvent(GameEvent.REGISTER,"panel.main.panelinfo.map",[this.populateMapInfoDataSet]));
         dispatchEvent(new GameEvent(GameEvent.REGISTER,"panel.main.panelinfo.skills",[this.populateSkillsInfoDataSet]));
         dispatchEvent(new GameEvent(GameEvent.REGISTER,"panel.main.panelinfo.glossary",[this.populateGlossaryInfoDataSet]));
         dispatchEvent(new GameEvent(GameEvent.REGISTER,"panel.main.panelinfo.alchemy",[this.populateAlchemyInfoDataSet]));
         InputDelegate.getInstance().addEventListener(InputEvent.INPUT,this.handleInput,false,10,true);
         this.mcTopTabList.addEventListener(ListEvent.INDEX_CHANGE,this.handleTopIndexChange,false,0,true);
         this.mcBotTabList.addEventListener(ListEvent.INDEX_CHANGE,this.handleBotIndexChange,false,0,true);
         tabEnabled = tabChildren = false;
         this.setupTabContainers();
         this.setupStateMachine();
         if(this.mcLeftPCButton)
         {
            this.mcLeftPCButton.addEventListener(ButtonEvent.PRESS,this.handlePrevButtonPress,false,0,true);
         }
         if(this.mcLeftGamepadButton)
         {
            this.mcLeftGamepadButton.setDataFromStage(NavigationCode.GAMEPAD_L1,-1);
         }
         if(this.mcRightPCButton)
         {
            this.mcRightPCButton.addEventListener(ButtonEvent.PRESS,this.handleNextButtonPress,false,0,true);
         }
         if(this.mcRightGamepadButton)
         {
            this.mcRightGamepadButton.setDataFromStage(NavigationCode.GAMEPAD_R1,-1);
         }
         if(this.txtTabName)
         {
            this.txtTabName.text = "";
         }
         stage.addEventListener(MouseEvent.MOUSE_MOVE,this.handleMouseMove,false,100,true);
         InputManager.getInstance().addEventListener(ControllerChangeEvent.CONTROLLER_CHANGE,this.handleControllerChange,false,0,true);
      }
      
      protected function handleItemsHistoryDataSet(param1:Object, param2:int) : void
      {
         this.mcItemsHistory.handleDataSet(param1,param2);
         this.ForceUpdateHubInfo();
      }
      
      protected function handleTrackedQuestInfoDataSet(param1:Object, param2:int) : void
      {
         this.mcTrackedQuestDisplay.handleDataSet(param1,param2);
         this.ForceUpdateHubInfo();
      }
      
      protected function populateMapInfoDataSet(param1:Object, param2:int) : void
      {
         this.mcMapEntriesInfo.handleDataSet(param1,param2);
         this.ForceUpdateHubInfo();
      }
      
      protected function populateSkillsInfoDataSet(param1:Object, param2:int) : void
      {
         this.mcSkillsEntriesInfo.handleDataSet(param1,param2);
         this.ForceUpdateHubInfo();
      }
      
      protected function populateGlossaryInfoDataSet(param1:Object, param2:int) : void
      {
         this.mcGlossaryEntriesInfo.handleDataSet(param1,param2);
         this.ForceUpdateHubInfo();
      }
      
      protected function populateAlchemyInfoDataSet(param1:Object, param2:int) : void
      {
         this.mcAlchemyEntriesInfo.handleDataSet(param1,param2);
         this.ForceUpdateHubInfo();
      }
      
      protected function ForceUpdateHubInfo() : void
      {
         var _loc1_:String = this.currnetHubInfoTabName;
         this.currnetHubInfoTabName = "";
         this.UpdateHubInfo(_loc1_);
      }
      
      public function set currentState(param1:String) : void
      {
         this.stateMachine.ChangeState(param1);
      }
      
      public function get currentState() : String
      {
         if(this.isStateAnimationPlaying())
         {
            return State_Transition;
         }
         return this.stateMachine.currentState;
      }
      
      public function get blockMenuClosing() : Boolean
      {
         return this._blockMenuClosing;
      }
      
      public function set blockMenuClosing(param1:Boolean) : void
      {
         this._blockMenuClosing = param1;
         this.updateInputFeedback();
      }
      
      public function get blockHubClosing() : Boolean
      {
         return this._blockHubClosing;
      }
      
      public function set blockHubClosing(param1:Boolean) : void
      {
         this._blockHubClosing = param1;
         this.updateInputFeedback();
      }
      
      public function hide(param1:Boolean = false) : void
      {
         this.hideRequested = true;
         this.hideImmediately = param1;
         this.stateMachine.ChangeState(State_Hidden);
      }
      
      protected function setupStateMachine() : void
      {
         this.stateMachine = new FiniteStateMachine();
         this.stateMachine.AddState(State_Init,this.state_Init_begin,this.state_Init_update,null);
         this.stateMachine.AddState(State_TopTab,this.state_TopTab_begin,null,null);
         this.stateMachine.AddState(State_BotTab,this.state_BotTab_begin,null,null);
         this.stateMachine.AddState(State_Hidden,this.state_Hidden_begin,null,this.state_Hidden_end);
      }
      
      protected function grabInitialValues() : void
      {
         if(this.mcTopTabHolder)
         {
            this.topHolderStartingY = this.mcTopTabHolder.y;
         }
         if(this.mcTabBackground)
         {
            this.tabBackgroundStartingY = this.mcTabBackground.y;
         }
         if(this.mcBotTabHolder)
         {
            this.botHolderStartingX = this.mcBotTabHolder.x;
            this.botHolderStartingY = this.mcBotTabHolder.y;
         }
      }
      
      protected function setupTabContainers() : void
      {
         this.addToOpenMenuContainer(this.mcLeftGamepadButton);
         this.addToOpenMenuContainer(this.mcRightGamepadButton);
         this.addToOpenMenuContainer(this.txtTabName);
         this.addToOpenMenuContainer(this.mcSelectionTracker);
         this.addToOpenMenuContainer(this.txtPrevTabName);
         this.addToOpenMenuContainer(this.txtNextTabName);
         this.addToOpenMenuContainer(this.mcLeftPCButton);
         this.addToOpenMenuContainer(this.mcRightPCButton);
         this.txtTopMainDesc.visible = false;
         this.txtTabNewDesc.visible = false;
         this.txtBottomDesc.visible = false;
         this.mcItemsHistory.visible = false;
         this.mcGlossaryEntriesInfo.visible = false;
         this.mcAlchemyEntriesInfo.visible = false;
         this.mcSkillsEntriesInfo.visible = false;
         this.mcTrackedQuestDisplay.visible = false;
         this.mcMapEntriesInfo.visible = false;
         this.addToOpenHubListContainer(this.txtTopMainDesc);
         this.addToOpenHubListContainer(this.txtTabNewDesc);
         this.addToTopListContainer(this.mcGridLine);
         this.addToTopListContainer(this.mcTopTabList);
         this.addToTopListContainer_Item(this.mcTopTabListItem1);
         this.addToTopListContainer_Item(this.mcTopTabListItem2);
         this.addToTopListContainer_Item(this.mcTopTabListItem3);
         this.addToTopListContainer_Item(this.mcTopTabListItem4);
         this.addToTopListContainer_Item(this.mcTopTabListItem5);
         this.addToTopListContainer_Item(this.mcTopTabListItem6);
         this.addToTopListContainer_Item(this.mcTopTabListItem7);
         this.addToBotListContainer(this.mcBotTabList);
         this.addToBotListContainer_Item(this.mcBotTabListItem1);
         this.addToBotListContainer_Item(this.mcBotTabListItem2);
         this.addToBotListContainer_Item(this.mcBotTabListItem3);
         this.addToBotListContainer_Item(this.mcBotTabListItem4);
         this.addToBotListContainer_Item(this.mcBotTabListItem5);
         this.addToBotListContainer_Item(this.mcBotTabListItem6);
         this.addToBotListContainer(this.mcItemsHistory);
         this.addToBotListContainer(this.mcGlossaryEntriesInfo);
         this.addToBotListContainer(this.mcAlchemyEntriesInfo);
         this.addToBotListContainer(this.mcSkillsEntriesInfo);
         this.addToBotListContainer(this.mcMapEntriesInfo);
         this.addToBotListContainer(this.mcTrackedQuestDisplay);
         this.addToBotListContainer(this.txtBottomDesc);
      }
      
      public function selectMenu(param1:uint, param2:String) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:Array = null;
         var _loc9_:MenuHubTabListItem = null;
         var _loc6_:int = -1;
         var _loc7_:int = -1;
         var _loc8_:Object = null;
         _loc3_ = 0;
         while(_loc3_ < this.mcTopTabList.dataProvider.length)
         {
            if((_loc9_ = this.mcTopTabList.getRendererAt(_loc3_) as MenuHubTabListItem) && _loc9_.data && _loc9_.enabled)
            {
               _loc5_ = _loc9_.data.subItems;
               _loc4_ = 0;
               while(_loc4_ < _loc5_.length)
               {
                  if(_loc5_[_loc4_].id == param1)
                  {
                     if(_loc5_[_loc4_].state == param2 || param2 == "")
                     {
                        this.ignoreNextTabChange = true;
                        this.mcTopTabList.selectedIndex = _loc3_;
                        this.mcTopTabList.validateNow();
                        this.ignoreNextTabChange = false;
                        this.mcBotTabList.selectedIndex = _loc4_;
                        this.mcBotTabList.validateNow();
                        return;
                     }
                     if(_loc6_ == -1 || _loc7_ == -1)
                     {
                        _loc6_ = _loc3_;
                        _loc7_ = _loc7_;
                        _loc8_ = _loc5_[_loc4_];
                     }
                  }
                  _loc4_++;
               }
               if(_loc9_.data.id == param1)
               {
                  if(_loc9_.data.state == param2)
                  {
                     this.mcTopTabList.selectedIndex = _loc3_;
                     this.mcTopTabList.validateNow();
                     return;
                  }
                  if(_loc6_ == -1)
                  {
                     _loc6_ = _loc3_;
                     _loc8_ = _loc9_.data;
                  }
               }
            }
            _loc3_++;
         }
         if(_loc6_ != -1)
         {
            this.mcTopTabList.selectedIndex = _loc6_;
            this.mcTopTabList.validateNow();
            if(_loc7_ != -1)
            {
               this.mcBotTabList.selectedIndex = _loc7_;
               this.mcBotTabList.validateNow();
            }
            if(Boolean(_loc8_) && param2 != "")
            {
               _loc8_.state = param2;
            }
            return;
         }
         _loc3_ = 0;
         while(_loc3_ < this.mcTopTabList.dataProvider.length)
         {
            if((_loc9_ = this.mcTopTabList.getRendererAt(_loc3_) as MenuHubTabListItem) && _loc9_.data && Boolean(_loc9_.data.enabled))
            {
               this.mcTopTabList.selectedIndex = _loc3_;
               break;
            }
            _loc3_++;
         }
      }
      
      public function updateTabDataEnabled(param1:uint, param2:String, param3:Boolean) : *
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:Array = null;
         var _loc7_:MenuHubTabListItem = null;
         var _loc8_:Object = null;
         var _loc9_:Array = new Array();
         _loc4_ = 0;
         while(_loc4_ < this.mcTopTabList.dataProvider.length)
         {
            if((_loc7_ = this.mcTopTabList.getRendererAt(_loc4_) as MenuHubTabListItem) && _loc7_.data && _loc7_.data.id == param1)
            {
               (_loc8_ = _loc7_.data).enabled = param3;
               _loc7_.setData(_loc8_);
               _loc6_ = _loc7_.data.subItems;
               if(this.mcTopTabList.selectedIndex == _loc4_ && !param3)
               {
                  this.mcTopTabList.moveUp(true);
               }
            }
            _loc9_.push(_loc7_.data);
            _loc4_++;
         }
         this.mcTopTabList.validateNow();
         this.setupAllItemsList(_loc9_);
         this.updateTabName(this.currentlySelectedMenu());
      }
      
      public function setTabdata(param1:Array) : void
      {
         if(!param1)
         {
            return;
         }
         this.mcTopTabList.dataProvider = new DataProvider(param1);
         this.mcTopTabList.validateNow();
         this.mcTopTabList.selectedIndex = param1.length / 2;
         this.setupAllItemsList(param1);
      }
      
      protected function setupAllItemsList(param1:Array) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Object = null;
         var _loc5_:Array = null;
         this._allItemsList = new Vector.<Object>();
         _loc2_ = 0;
         while(_loc2_ < param1.length)
         {
            _loc5_ = (_loc4_ = param1[_loc2_]).subItems as Array;
            if(_loc4_.enabled)
            {
               if(_loc5_ == null || _loc5_.length == 0)
               {
                  this._allItemsList.push(_loc4_);
               }
               else if(_loc4_.enabled)
               {
                  _loc3_ = 0;
                  while(_loc3_ < _loc5_.length)
                  {
                     this._allItemsList.push(_loc5_[_loc3_]);
                     _loc3_++;
                  }
               }
            }
            _loc2_++;
         }
         if(this.mcSelectionTracker)
         {
            this.mcSelectionTracker.numElements = this._allItemsList.length;
            this.mcSelectionTracker.selectedIndex = this.mcTopTabList.selectedIndex;
         }
      }
      
      protected function getIndexOfItem(param1:Object) : int
      {
         return this._allItemsList.indexOf(param1);
      }
      
      protected function handleControllerChange(param1:ControllerChangeEvent) : void
      {
         if(param1.isGamepad)
         {
            this._lastMoveWasMouse = false;
         }
      }
      
      protected function handleMouseMove(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(!this._lastMoveWasMouse)
         {
            this._lastMoveWasMouse = true;
            if(this.stateMachine.currentState == State_BotTab)
            {
               this.AnimateToTopTab_State();
            }
            if(this._lastMouseOveredItem != null)
            {
               _loc2_ = this.mcBotTabList.getRenderers().indexOf(this._lastMouseOveredItem);
               if(_loc2_ != -1)
               {
                  this.mcBotTabList.selectedIndex = _loc2_;
               }
               else
               {
                  _loc3_ = this.mcTopTabList.getRenderers().indexOf(this._lastMouseOveredItem);
                  if(_loc3_ != -1)
                  {
                     this.mcTopTabList.selectedIndex = _loc3_;
                  }
               }
            }
         }
      }
      
      public function currentlySelectedMenu() : MenuHubTabListItem
      {
         var _loc2_:MenuHubTabListItem = null;
         var _loc1_:MenuHubTabListItem = this.mcTopTabList.getSelectedRenderer() as MenuHubTabListItem;
         if(_loc1_)
         {
            if(Boolean(_loc1_.data) && _loc1_.data.subItems.length == 0)
            {
               return _loc1_;
            }
            return this.mcBotTabList.getSelectedRenderer() as MenuHubTabListItem;
         }
         return null;
      }
      
      protected function isStateAnimationPlaying() : Boolean
      {
         return this.topTabHolderTweener != null || this.botTabHolderTweener != null;
      }
      
      protected function handleTopTabHolderTweenComplete(param1:GTween = null) : void
      {
         this.topTabHolderTweener = null;
      }
      
      protected function handleTopTabHolderHideTweenComplete(param1:GTween = null) : void
      {
         this.topTabHolderTweener = null;
         this.mcTopTabHolder.y = -2000;
      }
      
      protected function handleBotTabHolderTweenComplete(param1:GTween = null) : void
      {
         this.botTabHolderTweener = null;
      }
      
      protected function handleBotTabHolderHideTweenComplete(param1:GTween = null) : void
      {
         this.botTabHolderTweener = null;
         this.mcBotTabHolder.y = -2000;
      }
      
      protected function handleBackgroundImageTweenComplete(param1:GTween = null) : void
      {
         this.backgroundImageTweener = null;
      }
      
      protected function handleOpenTabImageTweenComplete(param1:GTween = null) : void
      {
         this.openTabImageTweener = null;
         if(Boolean(this.mcOpenMenuDataHolder) && this.mcOpenMenuDataHolder.alpha == 0)
         {
            this.mcOpenMenuDataHolder.visible = false;
            this.updateNavigationInputFeedback();
         }
      }
      
      protected function state_Init_begin() : void
      {
         var _loc1_:Number = 0.5;
         if(this.mcTopTabHolder)
         {
            this.mcTopTabHolder.y = this.topHolderStartingY - 200;
            this.mcTopTabHolder.alpha = 0;
            this.topTabHolderTweener = GTweener.to(this.mcTopTabHolder,_loc1_,{
               "alpha":1,
               "y":this.topHolderStartingY
            },{
               "onComplete":this.handleTopTabHolderTweenComplete,
               "ease":Sine.easeOut
            });
         }
         if(this.mcBotTabHolder)
         {
            this.mcBotTabHolder.y = this.botHolderStartingY - 200;
            this.mcBotTabHolder.alpha = 0;
            this.botTabHolderTweener = GTweener.to(this.mcBotTabHolder,_loc1_,{
               "alpha":BotUnfocusedAlpha,
               "y":this.botHolderStartingY + BotUnfocusedYOffset,
               "scaleX":BotUnfocusedScale,
               "scaleY":BotUnfocusedScale
            },{
               "onComplete":this.handleBotTabHolderTweenComplete,
               "ease":Sine.easeOut
            });
         }
         if(this.mcOpenMenuDataHolder)
         {
            this.mcOpenMenuDataHolder.visible = false;
         }
         if(this.mcOpenHubDataContainer)
         {
            this.mcOpenHubDataContainer.visible = true;
         }
         var _loc2_:MenuHubTabListItem = this.mcTopTabList.getSelectedRenderer() as MenuHubTabListItem;
         if(_loc2_)
         {
            this.UpdateHubInfo(_loc2_.data.name);
         }
         this.updateNavigationInputFeedback();
      }
      
      protected function state_Init_update() : void
      {
         var _loc1_:MenuHubTabListItem = null;
         if(this.hideRequested)
         {
            this.stateMachine.ChangeState(State_Hidden);
         }
         else
         {
            _loc1_ = this.mcTopTabList.getSelectedRenderer() as MenuHubTabListItem;
            if(_loc1_)
            {
               this.UpdateHubInfo(_loc1_.data.name);
            }
            this.stateMachine.ChangeState(State_TopTab);
            if(_loc1_)
            {
               this.UpdateHubInfo(_loc1_.data.name);
            }
         }
      }
      
      protected function AnimateToTopTab_State() : void
      {
         if(this.mcTopTabHolder)
         {
            if(this.topTabHolderTweener)
            {
               this.topTabHolderTweener.paused = true;
               GTweener.removeTweens(this.mcTopTabHolder);
            }
            this.topTabHolderTweener = GTweener.to(this.mcTopTabHolder,TopTabAnimDuration,{
               "alpha":1,
               "scaleX":1,
               "scaleY":1,
               "y":this.topHolderStartingY
            },{
               "onComplete":this.handleTopTabHolderTweenComplete,
               "ease":Sine.easeOut
            });
         }
         if(this.mcBotTabHolder)
         {
            if(this.botTabHolderTweener)
            {
               this.botTabHolderTweener.paused = true;
               GTweener.removeTweens(this.mcBotTabHolder);
            }
            this.botTabHolderTweener = GTweener.to(this.mcBotTabHolder,TopTabAnimDuration,{
               "alpha":BotUnfocusedAlpha,
               "x":this.botHolderStartingX,
               "y":this.botHolderStartingY + BotUnfocusedYOffset,
               "scaleX":BotUnfocusedScale,
               "scaleY":BotUnfocusedScale
            },{
               "onComplete":this.handleBotTabHolderTweenComplete,
               "ease":Sine.easeOut
            });
         }
         if(this.mcTabBackground)
         {
            if(this.backgroundImageTweener)
            {
               this.backgroundImageTweener.paused = true;
               GTweener.removeTweens(this.mcTabBackground);
            }
            this.backgroundImageTweener = GTweener.to(this.mcTabBackground,TopTabAnimDuration,{
               "alpha":TabBackgroundTopAlpha,
               "y":this.tabBackgroundStartingY
            },{
               "onComplete":this.handleBackgroundImageTweenComplete,
               "ease":Sine.easeOut
            });
         }
      }
      
      protected function AnimateToBotTab_State() : void
      {
         if(this.mcTopTabHolder)
         {
            if(this.topTabHolderTweener)
            {
               this.topTabHolderTweener.paused = true;
               GTweener.removeTweens(this.mcTopTabHolder);
            }
            this.topTabHolderTweener = GTweener.to(this.mcTopTabHolder,BotTabAnimDuration,{
               "alpha":TopTabUnfocusedAlpha,
               "scaleX":TopTabUnfocusedScale,
               "scaleY":TopTabUnfocusedScale,
               "y":this.topHolderStartingY + TopTabYOffset
            },{
               "onComplete":this.handleTopTabHolderTweenComplete,
               "ease":Sine.easeOut
            });
         }
         if(this.mcBotTabHolder)
         {
            if(this.botTabHolderTweener)
            {
               this.botTabHolderTweener.paused = true;
               GTweener.removeTweens(this.mcBotTabHolder);
            }
            this.botTabHolderTweener = GTweener.to(this.mcBotTabHolder,BotTabAnimDuration,{
               "alpha":BotFocusedAlpha,
               "x":this.botHolderStartingX + BotHolderXOffset,
               "y":this.botHolderStartingY + BotHolderYOffset,
               "scaleX":BotFocusedScale,
               "scaleY":BotFocusedScale
            },{
               "onComplete":this.handleBotTabHolderTweenComplete,
               "ease":Sine.easeOut
            });
         }
         if(this.mcTabBackground)
         {
            if(this.backgroundImageTweener)
            {
               this.backgroundImageTweener.paused = true;
               GTweener.removeTweens(this.mcTabBackground);
            }
            this.backgroundImageTweener = GTweener.to(this.mcTabBackground,BotTabAnimDuration,{
               "alpha":TabBackgroundBotAlpha,
               "y":this.tabBackgroundStartingY + TabBackgroundBotOffset
            },{
               "onComplete":this.handleBackgroundImageTweenComplete,
               "ease":Sine.easeOut
            });
         }
      }
      
      protected function state_TopTab_begin() : void
      {
         if(this.refInputFeedback)
         {
            this._showOpenButton = true;
            this._showNavigateButton = true;
            this._showBackButton = false;
            this._showExitButton = true;
            this.updateInputFeedback();
         }
         this.AnimateToTopTab_State();
         var _loc1_:MenuHubTabListItem = this.mcTopTabList.getSelectedRenderer() as MenuHubTabListItem;
         if(_loc1_)
         {
            this.UpdateHubInfo(_loc1_.data.name);
         }
      }
      
      protected function state_BotTab_begin() : void
      {
         if(InputManager.getInstance().isGamepad() || !this._lastMoveWasMouse)
         {
            this.AnimateToBotTab_State();
         }
         else
         {
            this.AnimateToTopTab_State();
         }
         if(this.refInputFeedback)
         {
            this._showOpenButton = true;
            this._showNavigateButton = true;
            this._showBackButton = true;
            this._showExitButton = false;
            this.updateInputFeedback();
         }
         var _loc1_:MenuHubTabListItem = this.mcTopTabList.getSelectedRenderer() as MenuHubTabListItem;
         if(_loc1_)
         {
            this.UpdateHubInfo(_loc1_.data.name);
         }
      }
      
      protected function state_Hidden_begin() : void
      {
         var _loc1_:Number = 0.3;
         var _loc2_:MenuCommon = this.parent as MenuCommon;
         if(_loc2_)
         {
            _loc2_.hubHiddenBegin();
         }
         if(this.mcTopTabHolder)
         {
            if(this.topTabHolderTweener)
            {
               this.topTabHolderTweener.paused = true;
               GTweener.removeTweens(this.mcTopTabHolder);
            }
            this.mcTopTabHolder.alpha = 0;
            this.mcTopTabHolder.y = this.topHolderStartingY - 200;
            this.handleTopTabHolderHideTweenComplete();
         }
         if(this.mcBotTabHolder)
         {
            if(this.botTabHolderTweener)
            {
               this.botTabHolderTweener.paused = true;
               GTweener.removeTweens(this.mcBotTabHolder);
            }
            this.mcBotTabHolder.alpha = 0;
            this.mcBotTabHolder.y = this.botHolderStartingY - 200;
            this.handleBotTabHolderHideTweenComplete();
         }
         if(this.mcTabBackground)
         {
            if(this.backgroundImageTweener)
            {
               this.backgroundImageTweener.paused = true;
               GTweener.removeTweens(this.mcTabBackground);
            }
            this.mcTabBackground.alpha = 0;
            this.handleBackgroundImageTweenComplete();
         }
         if(this.mcOpenMenuDataHolder)
         {
            this.mcOpenMenuDataHolder.visible = true;
            if(this.openTabImageTweener)
            {
               this.openTabImageTweener.paused = true;
               GTweener.removeTweens(this.mcOpenMenuDataHolder);
            }
            this.mcOpenMenuDataHolder.alpha = 1;
         }
         if(this.mcOpenHubDataContainer)
         {
            this.mcOpenHubDataContainer.visible = false;
         }
         dispatchEvent(new Event(OpenMenuCalled));
         this.hideImmediately = false;
         if(this.refInputFeedback)
         {
            this._showOpenButton = false;
            this._showNavigateButton = false;
            this._showBackButton = true;
            this._showExitButton = false;
            this.updateInputFeedback();
         }
         this.UpdateHubInfo("ciastko");
         this.txtTopMainDesc.visible = false;
         this.updateNavigationInputFeedback();
      }
      
      protected function state_Hidden_end() : void
      {
         if(this.mcOpenMenuDataHolder)
         {
            if(this.openTabImageTweener)
            {
               this.openTabImageTweener.paused = true;
               GTweener.removeTweens(this.mcOpenMenuDataHolder);
            }
            this.openTabImageTweener = GTweener.to(this.mcOpenMenuDataHolder,0.4,{"alpha":0},{
               "onComplete":this.handleOpenTabImageTweenComplete,
               "ease":Sine.easeOut
            });
         }
         var _loc1_:MenuCommon = this.parent as MenuCommon;
         if(_loc1_)
         {
            _loc1_.hubHiddenEnd();
         }
         if(Boolean(this.mcTopTabHolder) && this.topTabHolderTweener == null)
         {
            this.mcTopTabHolder.y = this.topHolderStartingY - 200;
         }
         if(Boolean(this.mcBotTabHolder) && this.botTabHolderTweener == null)
         {
            this.mcBotTabHolder.y = this.botHolderStartingY - 200;
         }
         dispatchEvent(new GameEvent(GameEvent.CALL,"OnRefreshHubInfo",[true]));
         var _loc2_:MenuHubTabListItem = this.mcTopTabList.getSelectedRenderer() as MenuHubTabListItem;
         if(_loc2_)
         {
            this.UpdateHubInfo(_loc2_.data.name);
         }
         if(this.mcOpenHubDataContainer)
         {
            this.mcOpenHubDataContainer.visible = true;
         }
         this.updateNavigationInputFeedback();
      }
      
      protected function handleTopIndexChange(param1:ListEvent) : void
      {
         if(this.mcTopTabList.selectedIndex == -1)
         {
            return;
         }
         this.updateTopTabIndexSelection(this.mcTopTabList.selectedIndex);
      }
      
      protected function updateTopTabIndexSelection(param1:int) : void
      {
         var _loc2_:MenuHubTabListItem = null;
         var _loc3_:MenuHubTabListItem = null;
         if(param1 != this._lastUpdatedTopTabIndex)
         {
            this._lastUpdatedTopTabIndex = param1;
            _loc2_ = this.mcTopTabList.getSelectedRenderer() as MenuHubTabListItem;
            if(Boolean(_loc2_) && Boolean(_loc2_.data))
            {
               this.updateTabBackgroundImage();
               if(this.txtTopMainDesc)
               {
                  this.txtTopMainDesc.text = _loc2_.data.tabDesc;
               }
               if(this.txtTabNewDesc)
               {
                  this.txtTabNewDesc.text = _loc2_.data.tabNewDesc;
               }
               this.mcBotTabList.dataProvider = new DataProvider(_loc2_.data.subItems);
               this.mcBotTabList.validateNow();
               if(_loc2_.data.subItems.length == 0)
               {
                  this.updateTabName(_loc2_);
               }
               else
               {
                  if(this._selectLastChild)
                  {
                     this.mcBotTabList.selectedIndex = _loc2_.data.subItems.length - 1;
                  }
                  else
                  {
                     this.mcBotTabList.selectedIndex = 0;
                  }
                  this.mcBotTabList.validateNow();
                  _loc3_ = this.mcBotTabList.getSelectedRenderer() as MenuHubTabListItem;
                  if(_loc3_)
                  {
                     this.updateTabName(_loc3_);
                  }
               }
               this._selectLastChild = false;
            }
         }
      }
      
      protected function updateTabBackgroundImage() : void
      {
         var _loc1_:MenuHubTabListItem = null;
         var _loc2_:W3UILoader = null;
         var _loc3_:InvisibleComponent = null;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         if(this.mcTabBackground)
         {
            _loc1_ = this.mcTopTabList.getSelectedRenderer() as MenuHubTabListItem;
            if(this.backgroundImageTweener)
            {
               this.backgroundImageTweener.paused = true;
               GTweener.removeTweens(this.mcTabBackground);
            }
            this.mcTabBackground.alpha = 0;
            _loc2_ = this.mcTabBackground.getChildByName("mcImageLoader") as W3UILoader;
            if(_loc2_)
            {
               _loc2_.source = "img://icons/menuhub/img_background_" + _loc1_.data.icon + ".png";
            }
            _loc3_ = this.mcTabBackground.getChildByName("mc" + _loc1_.data.icon + "Anchor") as InvisibleComponent;
            if(_loc3_)
            {
               _loc2_.x = _loc3_.x;
               _loc2_.y = _loc3_.y;
            }
            _loc4_ = 0;
            _loc5_ = this.tabBackgroundStartingY;
            switch(this.stateMachine.currentState)
            {
               case State_TopTab:
                  _loc4_ = TabBackgroundTopAlpha;
                  break;
               case State_BotTab:
                  _loc4_ = TabBackgroundBotAlpha;
                  _loc5_ = this.tabBackgroundStartingY + TabBackgroundBotOffset;
            }
            this.backgroundImageTweener = GTweener.to(this.mcTabBackground,0.2,{
               "alpha":_loc4_,
               "y":_loc5_
            },{
               "onComplete":this.handleBackgroundImageTweenComplete,
               "ease":Sine.easeOut
            });
         }
      }
      
      protected function handleBotIndexChange(param1:ListEvent) : void
      {
         var _loc2_:MenuHubTabListItem = this.mcTopTabList.getSelectedRenderer() as MenuHubTabListItem;
         var _loc3_:MenuHubTabListItem = this.mcBotTabList.getSelectedRenderer() as MenuHubTabListItem;
         if(Boolean(_loc3_) && _loc2_.data.subItems.length > 0)
         {
            this.updateTabName(_loc3_);
         }
      }
      
      protected function updateTabName(param1:MenuHubTabListItem) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         if(this.txtTabName)
         {
            this.txtTabName.htmlText = param1.data.label;
            this.txtTabName.htmlText = CommonUtils.toUpperCaseSafe(this.txtTabName.htmlText);
            this.UpdateHubInfo(param1.data.name);
            this.mcSelectionTracker.x = this.txtTabName.x + this.txtTabName.width / 2 - this.mcSelectionTracker.getVisibleWidth() / 2;
            _loc2_ = this.getIndexOfItem(param1.data);
            this.mcSelectionTracker.selectedIndex = _loc2_;
            if(this._allItemsList.length < 2 || _loc2_ == -1)
            {
               if(this.mcRightGamepadButton)
               {
                  this.mcRightGamepadButton.visible = false;
               }
               if(this.mcLeftGamepadButton)
               {
                  this.mcLeftGamepadButton.visible = false;
               }
               if(this.mcRightPCButton)
               {
                  this.mcRightPCButton.visible = false;
               }
               if(this.mcLeftPCButton)
               {
                  this.mcLeftPCButton.visible = false;
               }
               if(this.txtNextTabName)
               {
                  this.txtNextTabName.visible = false;
               }
               if(this.txtPrevTabName)
               {
                  this.txtPrevTabName.visible = false;
               }
            }
            else
            {
               _loc3_ = 15;
               _loc4_ = 45;
               if(this.mcLeftGamepadButton)
               {
                  this.mcLeftGamepadButton.visible = true;
                  this.mcLeftGamepadButton.x = this.txtTabName.x + (this.txtTabName.width - this.txtTabName.textWidth) / 2 - this.mcLeftGamepadButton.getViewWidth() - TITLE_BTN_PADDING;
               }
               if(this.mcRightGamepadButton)
               {
                  this.mcRightGamepadButton.visible = true;
                  this.mcRightGamepadButton.x = this.txtTabName.x + this.txtTabName.width / 2 + this.txtTabName.textWidth / 2 + this.mcLeftGamepadButton.getViewWidth();
               }
               if(this.mcLeftPCButton)
               {
                  this.mcLeftPCButton.visible = true;
                  this.mcLeftPCButton.x = this.txtTabName.x + (this.txtTabName.width - this.txtTabName.textWidth) / 2 - TITLE_BTN_PADDING;
               }
               if(this.mcRightPCButton)
               {
                  this.mcRightPCButton.visible = true;
                  this.mcRightPCButton.x = this.txtTabName.x + (this.txtTabName.width + this.txtTabName.textWidth) / 2 + TITLE_BTN_PADDING;
               }
               if(this.txtNextTabName)
               {
                  this.txtNextTabName.visible = true;
                  if(_loc2_ + 1 >= this._allItemsList.length)
                  {
                     this.txtNextTabName.uppercase = true;
                     this.txtNextTabName.htmlText = this._allItemsList[0].label;
                  }
                  else
                  {
                     this.txtNextTabName.uppercase = true;
                     this.txtNextTabName.htmlText = this._allItemsList[_loc2_ + 1].label;
                  }
               }
               if(this.txtPrevTabName)
               {
                  this.txtPrevTabName.visible = true;
                  if(_loc2_ == 0)
                  {
                     this.txtPrevTabName.uppercase = true;
                     this.txtPrevTabName.htmlText = this._allItemsList[this._allItemsList.length - 1].label;
                  }
                  else
                  {
                     this.txtPrevTabName.uppercase = true;
                     this.txtPrevTabName.htmlText = this._allItemsList[_loc2_ - 1].label;
                  }
               }
            }
            this.updateNavigationInputFeedback();
         }
         if(this.stateMachine.currentState == State_Hidden)
         {
            if(!this.ignoreNextTabChange)
            {
               dispatchEvent(new Event(OpenMenuCalled));
            }
            else
            {
               this.ignoreNextTabChange = false;
            }
         }
      }
      
      protected function updateNavigationInputFeedback() : void
      {
      }
      
      protected function addToOpenHubListContainer(param1:MovieClip) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         if(Boolean(this.mcOpenHubDataContainer) && Boolean(param1))
         {
            _loc2_ = param1.x - this.mcOpenHubDataContainer.x;
            _loc3_ = param1.y - this.mcOpenHubDataContainer.y;
            this.mcOpenHubDataContainer.addChild(param1);
            param1.x = _loc2_;
            param1.y = _loc3_;
         }
      }
      
      protected function addToTopListContainer_Item(param1:MovieClip) : void
      {
         if(param1)
         {
            param1.addEventListener(MouseEvent.CLICK,this.onTopTabItemClicked,false,0,true);
            param1.addEventListener(MouseEvent.MOUSE_OVER,this.onTopTabItemMouseOver,false,0,true);
            param1.addEventListener(MouseEvent.MOUSE_OUT,this.onTopTabItemMouseOut,false,0,true);
         }
         this.addToTopListContainer(param1);
      }
      
      protected function addToTopListContainer(param1:MovieClip) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         if(Boolean(this.mcTopTabHolder) && Boolean(param1))
         {
            _loc2_ = param1.x - this.mcTopTabHolder.x;
            _loc3_ = param1.y - this.mcTopTabHolder.y;
            this.mcTopTabHolder.addChild(param1);
            param1.x = _loc2_;
            param1.y = _loc3_;
         }
      }
      
      protected function addToBotListContainer_Item(param1:MovieClip) : void
      {
         if(param1)
         {
            param1.addEventListener(MouseEvent.CLICK,this.onBotTabItemClicked,false,0,true);
            param1.addEventListener(MouseEvent.MOUSE_OVER,this.onBotTabItemMouseOver,false,0,true);
            param1.addEventListener(MouseEvent.MOUSE_OUT,this.onBotTabItemMouseOut,false,0,true);
         }
         this.addToBotListContainer(param1);
      }
      
      protected function addToBotListContainer(param1:MovieClip) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         if(Boolean(this.mcBotTabHolder) && Boolean(param1))
         {
            _loc2_ = param1.x - this.mcBotTabHolder.x;
            _loc3_ = param1.y - this.mcBotTabHolder.y;
            this.mcBotTabHolder.addChild(param1);
            param1.x = _loc2_;
            param1.y = _loc3_;
         }
      }
      
      protected function addToOpenMenuContainer(param1:DisplayObject) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         if(Boolean(this.mcOpenMenuDataHolder) && Boolean(param1))
         {
            _loc2_ = param1.x - this.mcOpenMenuDataHolder.x;
            _loc3_ = param1.y - this.mcOpenMenuDataHolder.y;
            this.mcOpenMenuDataHolder.addChild(param1);
            param1.x = _loc2_;
            param1.y = _loc3_;
         }
      }
      
      public function handleDown() : void
      {
         var _loc1_:MenuHubTabListItem = null;
         if(this.stateMachine.currentState == State_TopTab)
         {
            _loc1_ = this.mcTopTabList.getSelectedRenderer() as MenuHubTabListItem;
            if(this.mcBotTabList.dataProvider.length > 0)
            {
               if(_loc1_)
               {
                  dispatchEvent(new GameEvent(GameEvent.CALL,"OnOpenSubPanel",[_loc1_.data.id]));
               }
               this.stateMachine.ChangeState(State_BotTab);
            }
            else if(_loc1_.data.enabled)
            {
               this.stateMachine.ChangeState(State_Hidden);
            }
         }
         else if(this.stateMachine.currentState == State_BotTab)
         {
            this.stateMachine.ChangeState(State_Hidden);
         }
      }
      
      public function handleUp() : void
      {
         var _loc2_:uint = 0;
         var _loc1_:MenuHubTabListItem = this.mcTopTabList.getSelectedRenderer() as MenuHubTabListItem;
         if(this.stateMachine.currentState == State_BotTab)
         {
            _loc2_ = 0;
            if(_loc1_)
            {
               _loc2_ = uint(_loc1_.data.id);
            }
            dispatchEvent(new GameEvent(GameEvent.CALL,"OnCloseSubPanel",[_loc2_]));
            this.stateMachine.ChangeState(State_TopTab);
         }
         else if(this.stateMachine.currentState == State_Hidden)
         {
            if(this.mcTopTabHolder)
            {
               this.mcTopTabHolder.alpha = 0;
               this.mcTopTabHolder.y = this.topHolderStartingY - 200;
            }
            if(this.mcBotTabHolder)
            {
               this.mcBotTabHolder.alpha = 0;
               this.mcBotTabHolder.y = this.botHolderStartingY - 200;
            }
            if(_loc1_ && _loc1_.data.subItems.length > 0 && (InputManager.getInstance().isGamepad() || !this._lastMoveWasMouse))
            {
               dispatchEvent(new GameEvent(GameEvent.CALL,"OnOpenSubPanel",[_loc1_.data.id]));
               this.stateMachine.ChangeState(State_BotTab);
            }
            else
            {
               this.stateMachine.ChangeState(State_TopTab);
            }
         }
      }
      
      protected function selectPrevTabItem() : void
      {
         var _loc1_:MenuHubTabListItem = this.mcTopTabList.getSelectedRenderer() as MenuHubTabListItem;
         if(_loc1_)
         {
            if(this.stateMachine.currentState == State_Hidden && this.mcTopTabList.dataProvider.length > 1 && (_loc1_.data.subItems.length == 0 || this.mcBotTabList.selectedIndex == 0))
            {
               this._selectLastChild = true;
               this.mcTopTabList.moveUp(true);
            }
            else
            {
               this.mcBotTabList.moveUp(true);
            }
         }
      }
      
      protected function selectNextTabItem() : void
      {
         var _loc1_:MenuHubTabListItem = this.mcTopTabList.getSelectedRenderer() as MenuHubTabListItem;
         if(_loc1_)
         {
            if(this.mcTopTabList.dataProvider.length > 1 && (_loc1_.data.subItems.length == 0 || this.mcBotTabList.selectedIndex == _loc1_.data.subItems.length - 1))
            {
               this.mcTopTabList.moveDown(true);
            }
            else
            {
               this.mcBotTabList.moveDown(true);
            }
         }
      }
      
      protected function UpdateHubInfo(param1:String) : *
      {
         if(param1 == this.currnetHubInfoTabName)
         {
            return;
         }
         this.currnetHubInfoTabName = param1;
         this.ShowInventoryInfo(false);
         this.ShowJournalInfo(false);
         this.ShowGlossaryInfo(false);
         this.ShowAlchemyInfo(false);
         this.ShowSkillsInfo(false);
         this.ShowMapInfo(false);
         switch(param1)
         {
            case "CraftingMenu":
               if(!this.isShopInventory)
               {
                  this.ShowGlossaryInfo(true);
               }
            case "CraftingParent":
            case "BlacksmithParent":
            case "BlacksmithMenu":
               break;
            case "AlchemyMenu":
               this.ShowAlchemyInfo(true);
               break;
            case "MeditationMenu":
            case "MeditationClockMenu":
            case "MeditationParent":
               break;
            case "InventoryMenu":
            case "InventoryParent":
               this.ShowInventoryInfo(true);
               break;
            case "JournalQuestMenu":
            case "JournalParent":
            case "JournalMonsterHuntingMenu":
            case "JournalTreasureHuntingMenu":
               this.ShowJournalInfo(true);
               break;
            case "GlossaryParent":
            case "GlossaryBestiaryMenu":
            case "GlossaryTutorialsMenu":
            case "GlossaryStorybookMenu":
            case "GlossaryBooksMenu":
            case "CraftingMenu":
            case "GlossaryEncyclopediaMenu":
               this.ShowGlossaryInfo(true);
               break;
            case "CharacterMenu":
               this.ShowSkillsInfo(true);
               break;
            case "MapMenu":
               this.ShowMapInfo(true);
         }
      }
      
      public function ShowInventoryInfo(param1:Boolean) : *
      {
         if(!this.mcItemsHistory.IsAnyItemToDisplay())
         {
            param1 = false;
         }
         this.mcItemsHistory.visible = param1;
         this.txtBottomDesc.visible = param1;
         if(this.isShopInventory)
         {
         }
         if(param1)
         {
            this.txtBottomDesc.htmlText = "[[panel_hub_inventory_new_items]]";
         }
         else
         {
            this.txtBottomDesc.htmlText = "";
         }
      }
      
      public function ShowJournalInfo(param1:Boolean) : *
      {
         if(!this.mcTrackedQuestDisplay.IsAnyItemToDisplay())
         {
            param1 = false;
         }
         this.mcTrackedQuestDisplay.visible = param1;
         this.txtBottomDesc.visible = param1;
         this.txtTopMainDesc.htmlText = "[[panel_hub_journal_main]]";
         if(param1)
         {
            this.txtBottomDesc.htmlText = "[[panel_hub_journal_tracked]]";
            this.txtTabNewDesc.htmlText = "";
         }
         else
         {
            this.txtBottomDesc.htmlText = "";
         }
      }
      
      public function ShowGlossaryInfo(param1:Boolean) : *
      {
         if(!this.mcGlossaryEntriesInfo.IsAnyItemToDisplay())
         {
            param1 = false;
         }
         this.mcGlossaryEntriesInfo.visible = param1;
         this.txtBottomDesc.visible = param1;
         if(param1)
         {
            this.txtBottomDesc.htmlText = "[[panel_hub_glossary_newest_entries]]";
            this.txtTabNewDesc.htmlText = "";
         }
         else
         {
            this.txtBottomDesc.htmlText = "";
         }
      }
      
      public function ShowAlchemyInfo(param1:Boolean) : *
      {
         if(!this.mcAlchemyEntriesInfo.IsAnyItemToDisplay())
         {
            param1 = false;
         }
         this.mcAlchemyEntriesInfo.visible = param1;
         this.txtBottomDesc.visible = param1;
         if(param1)
         {
            this.txtBottomDesc.htmlText = "[[panel_hub_alchemy_newest_entries]]";
         }
         else
         {
            this.txtBottomDesc.htmlText = "";
         }
      }
      
      public function ShowSkillsInfo(param1:Boolean) : *
      {
         if(!this.mcSkillsEntriesInfo.IsAnyItemToDisplay())
         {
            param1 = false;
         }
         this.mcSkillsEntriesInfo.visible = param1;
         this.txtBottomDesc.visible = param1;
         if(param1)
         {
            this.txtBottomDesc.htmlText = "[[panel_hub_skills_last_unlocked]]";
            this.txtTabNewDesc.htmlText = "";
         }
         else
         {
            this.txtBottomDesc.htmlText = "";
         }
      }
      
      public function ShowMapInfo(param1:Boolean) : *
      {
         if(!this.mcMapEntriesInfo.IsAnyItemToDisplay())
         {
            param1 = false;
         }
         this.mcMapEntriesInfo.visible = param1;
         this.txtBottomDesc.visible = param1;
         if(param1)
         {
            this.txtBottomDesc.htmlText = "[[panel_hub_map_last_discovered]]";
            this.txtTabNewDesc.htmlText = "";
         }
         else
         {
            this.txtBottomDesc.htmlText = "";
         }
      }
      
      private function getNumEnabledTabs() : int
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:MenuHubTabListItem = null;
         var _loc4_:Object = null;
         var _loc5_:int = 0;
         _loc1_ = 0;
         while(_loc1_ < this.mcTopTabList.dataProvider.length)
         {
            _loc3_ = this.mcTopTabList.getRendererAt(_loc1_) as MenuHubTabListItem;
            if(_loc3_.data)
            {
               if(_loc3_.data.enabled)
               {
                  _loc5_++;
               }
               if(_loc3_.data.subItems)
               {
                  _loc2_ = 0;
                  while(_loc2_ < _loc3_.data.subItems.length)
                  {
                     if((Boolean(_loc4_ = _loc3_.data.subItems[_loc2_])) && Boolean(_loc4_.enabled))
                     {
                        _loc5_++;
                     }
                     _loc2_++;
                  }
               }
            }
            _loc1_++;
         }
         return _loc5_;
      }
      
      override public function handleInput(param1:InputEvent) : void
      {
         var _loc3_:* = false;
         var _loc4_:* = false;
         var _loc5_:* = false;
         var _loc6_:Boolean = false;
         var _loc7_:MenuCommon = null;
         super.handleInput(param1);
         if(param1.handled || !this.navigationEnabled)
         {
            return;
         }
         if(this.stateMachine.currentState == State_TopTab)
         {
            this.mcTopTabList.handleInput(param1);
         }
         else if(this.stateMachine.currentState == State_BotTab)
         {
            this.mcBotTabList.handleInput(param1);
         }
         var _loc2_:InputDetails = param1.details as InputDetails;
         CommonUtils.convertWASDCodeToNavEquivalent(_loc2_);
         if(_loc2_.navEquivalent == NavigationCode.UP || _loc2_.navEquivalent == NavigationCode.DOWN || _loc2_.navEquivalent == NavigationCode.LEFT || _loc2_.navEquivalent == NavigationCode.RIGHT)
         {
            this._lastMoveWasMouse = false;
         }
         if(!param1.handled)
         {
            _loc3_ = _loc2_.value == InputValue.KEY_UP;
            _loc4_ = _loc2_.value == InputValue.KEY_DOWN;
            _loc5_ = _loc2_.value == InputValue.KEY_HOLD;
            _loc6_ = true;
            if(_loc7_ = this.parent as MenuCommon)
            {
               _loc6_ = _loc4_ || !_loc7_.isInputValidationEnabled() || (_loc7_.isNavEquivalentValid(_loc2_.navEquivalent) || _loc7_.isKeyCodeValid(_loc2_.code));
            }
            switch(_loc2_.navEquivalent)
            {
               case NavigationCode.GAMEPAD_A:
                  if(_loc6_ && _loc3_ && this.stateMachine.currentState != State_Hidden)
                  {
                     this.handleDown();
                  }
                  break;
               case NavigationCode.DOWN:
                  if(_loc6_ && (_loc4_ || _loc5_) && this.stateMachine.currentState != State_Hidden)
                  {
                     this.handleDown();
                  }
                  break;
               case NavigationCode.GAMEPAD_B:
                  if(_loc6_ && (_loc4_ || _loc5_) && this.stateMachine.currentState != State_Hidden)
                  {
                     this.handleUp();
                  }
                  break;
               case NavigationCode.UP:
                  if(_loc6_ && _loc4_ && this.stateMachine.currentState != State_Hidden)
                  {
                     this.handleUp();
                  }
                  break;
               case NavigationCode.GAMEPAD_L1:
                  if(_loc6_ && _loc3_ && this.stateMachine.currentState == State_Hidden && this.rblbenabled)
                  {
                     this.selectPrevTabItem();
                  }
                  break;
               case NavigationCode.GAMEPAD_R1:
                  if(_loc6_ && _loc3_ && this.stateMachine.currentState == State_Hidden && this.rblbenabled)
                  {
                     this.selectNextTabItem();
                  }
                  break;
               default:
                  if(_loc6_ && _loc2_.code == KeyCode.E && (_loc4_ || _loc5_) && this.stateMachine.currentState != State_Hidden)
                  {
                     this.handleDown();
                  }
                  else if(_loc6_ && _loc3_ && this.stateMachine.currentState == State_Hidden && this.rblbenabled)
                  {
                     if(_loc2_.code == KeyCode.NUMBER_1 || _loc2_.code == KeyCode.NUMPAD_1 || _loc2_.code == KeyCode.PAGE_DOWN)
                     {
                        this.trySelectedPrevTabItem();
                     }
                     else if(_loc2_.code == KeyCode.NUMBER_3 || _loc2_.code == KeyCode.NUMPAD_3 || _loc2_.code == KeyCode.PAGE_UP)
                     {
                        this.trySelectNextTabItem();
                     }
                  }
            }
         }
      }
      
      protected function handlePrevButtonPress(param1:ButtonEvent) : void
      {
         this.trySelectedPrevTabItem();
      }
      
      protected function handleNextButtonPress(param1:ButtonEvent) : void
      {
         this.trySelectNextTabItem();
      }
      
      protected function trySelectedPrevTabItem() : void
      {
         if(this.stateMachine.currentState == State_Hidden && this.rblbenabled && this.navigationEnabled)
         {
            this.selectPrevTabItem();
         }
      }
      
      protected function trySelectNextTabItem() : void
      {
         if(this.stateMachine.currentState == State_Hidden && this.rblbenabled && this.navigationEnabled)
         {
            this.selectNextTabItem();
         }
      }
      
      private function updateInputFeedback() : void
      {
         this.refInputFeedback.removeButton(IFB_ACTIVATE,false);
         this.refInputFeedback.removeButton(IFB_NAVIGATE,false);
         this.refInputFeedback.removeButton(IFB_CLOSE,false);
         if(this._showOpenButton && this.getNumEnabledTabs() > 0)
         {
            this.refInputFeedback.appendButton(IFB_ACTIVATE,NavigationCode.GAMEPAD_A,KeyCode.E,"[[panel_button_common_open_menu]]",false);
         }
         if(this._showNavigateButton && this.getNumEnabledTabs() > 1)
         {
            this.refInputFeedback.appendButton(IFB_NAVIGATE,NavigationCode.GAMEPAD_L3,-1,"[[panel_button_common_navigation]]",false);
         }
         if(this._showBackButton && !this.blockMenuClosing)
         {
            this.refInputFeedback.appendButton(IFB_CLOSE,NavigationCode.GAMEPAD_B,-1,"[[panel_mainmenu_back]]",false);
         }
         else if(this._showExitButton && !this.blockHubClosing)
         {
            this.refInputFeedback.appendButton(IFB_CLOSE,NavigationCode.GAMEPAD_B,-1,"[[panel_button_common_exit]]",false);
         }
         this.refInputFeedback.refreshButtonList();
      }
      
      protected function onTopTabItemMouseOver(param1:MouseEvent) : void
      {
         this._lastMouseOveredItem = param1.currentTarget as MenuHubTabListItem;
         if(InputManager.getInstance().isGamepad() || !this._lastMoveWasMouse)
         {
            return;
         }
         param1.stopImmediatePropagation();
         var _loc2_:MenuHubTabListItem = param1.currentTarget as MenuHubTabListItem;
         this.mcTopTabList.selectedIndex = this.mcTopTabList.getRenderers().indexOf(_loc2_);
      }
      
      protected function onTopTabItemMouseOut(param1:MouseEvent) : void
      {
         this._lastMouseOveredItem = null;
         if(InputManager.getInstance().isGamepad() || !this._lastMoveWasMouse)
         {
            return;
         }
         param1.stopImmediatePropagation();
      }
      
      protected function onTopTabItemClicked(param1:MouseEvent) : void
      {
         if(InputManager.getInstance().isGamepad())
         {
            return;
         }
         param1.stopImmediatePropagation();
         var _loc2_:MenuHubTabListItem = param1.currentTarget as MenuHubTabListItem;
         if(_loc2_ && _loc2_.visible && _loc2_.data && Boolean(_loc2_.data.enabled))
         {
            this.mcTopTabList.selectedIndex = this.mcTopTabList.getRenderers().indexOf(_loc2_);
            this.mcTopTabList.validateNow();
            this.handleDown();
         }
      }
      
      protected function onBotTabItemMouseOver(param1:MouseEvent) : void
      {
         this._lastMouseOveredItem = param1.currentTarget as MenuHubTabListItem;
         if(InputManager.getInstance().isGamepad() || !this._lastMoveWasMouse)
         {
            return;
         }
         param1.stopImmediatePropagation();
         var _loc2_:MenuHubTabListItem = param1.currentTarget as MenuHubTabListItem;
         this.mcBotTabList.selectedIndex = this.mcBotTabList.getRenderers().indexOf(_loc2_);
      }
      
      protected function onBotTabItemMouseOut(param1:MouseEvent) : void
      {
         this._lastMouseOveredItem = null;
      }
      
      protected function onBotTabItemClicked(param1:MouseEvent) : void
      {
         if(InputManager.getInstance().isGamepad() || !this._lastMoveWasMouse)
         {
            return;
         }
         param1.stopImmediatePropagation();
         var _loc2_:MenuHubTabListItem = param1.currentTarget as MenuHubTabListItem;
         if(_loc2_ && _loc2_.visible && _loc2_.data && Boolean(_loc2_.data.enabled))
         {
            this.mcBotTabList.selectedIndex = this.mcBotTabList.getRenderers().indexOf(_loc2_);
            this.mcBotTabList.validateNow();
            this.handleDown();
            this.stateMachine.ForceUpdateState();
            this.handleDown();
         }
      }
   }
}
