package red.game.witcher3.menus.gwint
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.geom.Rectangle;
   import flash.text.TextField;
   import red.core.constants.KeyCode;
   import red.core.events.GameEvent;
   import red.game.witcher3.constants.GwintInputFeedback;
   import red.game.witcher3.constants.InventoryActionType;
   import red.game.witcher3.controls.ConditionalButton;
   import red.game.witcher3.controls.ConditionalCloseButton;
   import red.game.witcher3.controls.InputFeedbackButton;
   import red.game.witcher3.controls.W3ChoiceDialog;
   import red.game.witcher3.controls.W3ListSelectionTracker;
   import red.game.witcher3.events.ControllerChangeEvent;
   import red.game.witcher3.events.SlotActionEvent;
   import red.game.witcher3.managers.InputFeedbackManager;
   import red.game.witcher3.managers.InputManager;
   import red.game.witcher3.utils.CommonUtils;
   import scaleform.clik.constants.InputValue;
   import scaleform.clik.constants.NavigationCode;
   import scaleform.clik.events.ButtonEvent;
   import scaleform.clik.events.InputEvent;
   import scaleform.clik.events.ListEvent;
   import scaleform.clik.ui.InputDetails;
   
   public class DeckBuilderMenu extends GwintBaseMenu
   {
       
      
      public var txtCurrentDeck:TextField;
      
      public var txtCurrentDeckPassive:TextField;
      
      public var txtPrevDeck:TextField;
      
      public var txtNextDeck:TextField;
      
      public var mcLeftPCButton:ConditionalButton;
      
      public var mcRightPCButton:ConditionalButton;
      
      public var mcLeftFeedbackButton:InputFeedbackButton;
      
      public var mcRightFeedbackButton:InputFeedbackButton;
      
      public var mcDeckSelectionTracker:W3ListSelectionTracker;
      
      public var mcFactionIcon:MovieClip;
      
      public var mcStartGameButton:InputFeedbackButton;
      
      public var mcStartGameButtonPC:ConditionalButton;
      
      public var txtStartGameText:TextField;
      
      public var mcChangeHeroButton:InputFeedbackButton;
      
      public var mcChoiceDialog:W3ChoiceDialog;
      
      public var mcLeaderCard:CardSlot;
      
      public var mcCloseBtn:ConditionalCloseButton;
      
      public var mcTutorial:GwintTutorial;
      
      public var mcDeckStats:GwintDeckStatsPanel;
      
      public var mcDeckHolder:GwintDeckCTabModule;
      
      public var mcCollectionHolder:GwintDeckCTabModule;
      
      protected var deckFactionList:Array;
      
      protected var deckToFactionIndexes:Array;
      
      protected var factionDecks:Vector.<GwintDeck>;
      
      protected var collectionDeck:GwintDeck;
      
      protected var hasDeckInfo:Boolean = false;
      
      protected var hasCollectionInfo:Boolean = false;
      
      protected var hasLeaderInfo:Boolean = false;
      
      protected var _selectedDeckIndex:int = -1;
      
      protected var collectionInfo:Array = null;
      
      protected var leaderCollectionInfo:Array = null;
      
      protected var gwintGamePending:Boolean = false;
      
      protected var isInZoomMode:Boolean = false;
      
      public var passiveAbilityString:String;
      
      protected var hasUpdatedOnce:Boolean = false;
      
      protected var choosingLeader:Boolean = false;
      
      protected var _leaderCardHovered:Boolean = false;
      
      public function DeckBuilderMenu()
      {
         this.deckToFactionIndexes = new Array();
         this.factionDecks = new Vector.<GwintDeck>();
         super();
         _enableMouse = false;
         this.__setProp_mcLeaderCard_Scene1_mcLeaderCard_0();
         this.__setProp_mcRightPCButton_Scene1_mcRightPCButton_0();
         this.__setProp_mcLeftPCButton_Scene1_mcLeftPCButton_0();
         this.__setProp_mcCloseBtn_Scene1_Layer2_0();
      }
      
      public function get selectedDeckIndex() : int
      {
         return this._selectedDeckIndex;
      }
      
      public function set selectedDeckIndex(param1:int) : void
      {
         var _loc2_:GwintDeck = null;
         if(this._selectedDeckIndex != param1)
         {
            this._selectedDeckIndex = param1;
            if(this.hasDeckInfo)
            {
               _loc2_ = this.factionDecks[this._selectedDeckIndex];
               this.mcDeckHolder.setTargetDeck(_loc2_);
               this.mcDeckStats.targetDeck = _loc2_;
               this.resetToDefaultButtons();
               this.updateTopSelectedDeck();
               if(this.hasCollectionInfo)
               {
                  this.updateCollectionDeck();
               }
            }
            CardSlot.updateDefaultFaction(param1);
            this.updateStartGameButton();
         }
      }
      
      override protected function configUI() : void
      {
         this.mcTutorial.currentTutorialFrame = 3;
         super.configUI();
         if(this.mcTutorial)
         {
            this.mcTutorial.showCarouselCB = this.showTutCarousel;
            this.mcTutorial.hideCarouselCB = this.hideTutCarousel;
         }
         this.clearMouseEnabledOnTextFieldsInDeckStats();
         InputFeedbackManager.useOverlayPopup = true;
         InputFeedbackManager.eventDispatcher = this;
         this.setupFactions();
         dispatchEvent(new GameEvent(GameEvent.REGISTER,"gwint.deckbuilder.decks",[this.updateGwintDecks]));
         dispatchEvent(new GameEvent(GameEvent.REGISTER,"gwint.deckbuilder.collection",[this.updateGwintCollection]));
         dispatchEvent(new GameEvent(GameEvent.REGISTER,"gwint.deckbuilder.leaderList",[this.updateLeaderList]));
         dispatchEvent(new GameEvent(GameEvent.CALL,"OnConfigUI"));
         this.setupLeaderCard();
         InputManager.getInstance().addEventListener(ControllerChangeEvent.CONTROLLER_CHANGE,this.handleControllerChange,false,0,true);
         this.mcCollectionHolder.addEventListener(SlotActionEvent.EVENT_ACTIVATE,this.handleCollectionSlotActivated,false,0,true);
         this.mcCollectionHolder.addEventListener(CardSlot.CardMouseRightClick,this.onCollectionRightClickCard,false,0,true);
         this.mcCollectionHolder.mcCardSlotList.addEventListener(ListEvent.INDEX_CHANGE,this.onSelectedCardChanged,false,0,true);
         this.mcCollectionHolder.closedCallback = this.resetToDefaultButtons;
         this.mcCollectionHolder.openedCallback = this.resetToDefaultButtons;
         this.mcDeckHolder.addEventListener(SlotActionEvent.EVENT_ACTIVATE,this.handleDeckSlotActivated,false,0,true);
         this.mcDeckHolder.addEventListener(CardSlot.CardMouseRightClick,this.onDeckRightClickCard,false,0,true);
         this.mcDeckHolder.mcCardSlotList.addEventListener(ListEvent.INDEX_CHANGE,this.onSelectedCardChanged,false,0,true);
         this.mcDeckHolder.closedCallback = this.resetToDefaultButtons;
         this.mcDeckHolder.openedCallback = this.resetToDefaultButtons;
         if(this.mcCloseBtn)
         {
            this.mcCloseBtn.addEventListener(ButtonEvent.PRESS,this.handleClosePressed,false,0,true);
         }
         this.mcChoiceDialog.cardsCarousel.addEventListener(ListEvent.INDEX_CHANGE,this.onCarouselSelectionChanged,false,0,true);
         upToCloseEnabled = false;
         if(this.mcLeftPCButton)
         {
            this.mcLeftPCButton.addEventListener(ButtonEvent.PRESS,this.handlePrevButtonPress,false,0,true);
         }
         if(this.mcRightPCButton)
         {
            this.mcRightPCButton.addEventListener(ButtonEvent.PRESS,this.handleNextButtonPress,false,0,true);
         }
         if(this.mcLeftFeedbackButton)
         {
            this.mcLeftFeedbackButton.setDataFromStage(NavigationCode.GAMEPAD_L1,-1);
         }
         if(this.mcRightFeedbackButton)
         {
            this.mcRightFeedbackButton.setDataFromStage(NavigationCode.GAMEPAD_R1,-1);
         }
         if(this.mcStartGameButton)
         {
            this.mcStartGameButton.setDataFromStage(NavigationCode.GAMEPAD_Y,-1);
         }
         if(this.txtStartGameText)
         {
            this.txtStartGameText.mouseEnabled = false;
         }
         if(this.mcStartGameButtonPC)
         {
            if(this.txtStartGameText)
            {
               this.mcStartGameButtonPC.visibleWidth = this.txtStartGameText.textWidth + 12;
            }
            this.mcStartGameButtonPC.filters = [];
            this.mcStartGameButtonPC.alpha = 1;
            this.mcStartGameButtonPC.addEventListener(ButtonEvent.PRESS,this.handleStartPressed,false,0,true);
         }
         if(this.mcChangeHeroButton)
         {
            this.mcChangeHeroButton.setDataFromStage(NavigationCode.GAMEPAD_X,-1);
         }
         if(this.mcChoiceDialog)
         {
            this.mcChoiceDialog.visible = false;
         }
         currentModuleIdx = 0;
      }
      
      override protected function get menuName() : String
      {
         return "DeckBuilder";
      }
      
      public function sorryJason_temp() : void
      {
         this.mcDeckHolder._inputEnabled = false;
         this.mcCollectionHolder._inputEnabled = false;
         this.mcDeckHolder.enabled = false;
         this.mcCollectionHolder.enabled = false;
      }
      
      public function showTutorial() : void
      {
         this.mcTutorial.show();
         this.mcCollectionHolder.sortTutorialCards();
         this.resetInputFeedbackButtons();
         this.mcTutorial.onHideCallback = this.onTutorialHide;
         this.mcDeckHolder._inputEnabled = false;
         this.mcCollectionHolder._inputEnabled = false;
         this.mcDeckHolder.enabled = false;
         this.mcCollectionHolder.enabled = false;
      }
      
      public function onTutorialHide() : void
      {
         this.mcDeckHolder._inputEnabled = true;
         this.mcCollectionHolder._inputEnabled = true;
         this.resetToDefaultButtons();
         this.mcCollectionHolder.enabled = true;
         this.mcDeckHolder.enabled = true;
         currentModuleIdx = 0;
      }
      
      public function setPassiveAbilityString(param1:String) : void
      {
         this.passiveAbilityString = param1;
      }
      
      protected function setupFactions() : void
      {
         this.deckToFactionIndexes.push(CardTemplate.FactionId_Neutral);
         this.deckToFactionIndexes.push(CardTemplate.FactionId_Northern_Kingdom);
         this.deckToFactionIndexes.push(CardTemplate.FactionId_Nilfgaard);
         this.deckToFactionIndexes.push(CardTemplate.FactionId_Scoiatael);
         this.deckToFactionIndexes.push(CardTemplate.FactionId_No_Mans_Land);
         this.deckToFactionIndexes.push(CardTemplate.FactionId_Skellige);
         this.factionDecks.push(null);
         this.factionDecks.push(null);
         this.factionDecks.push(null);
         this.factionDecks.push(null);
         this.factionDecks.push(null);
      }
      
      protected function updateGwintDecks(param1:Array) : void
      {
         var _loc2_:int = 0;
         var _loc4_:GwintDeck = null;
         var _loc3_:int = 0;
         _loc2_ = 0;
         while(_loc2_ < param1.length)
         {
            if(_loc4_ = param1[_loc2_] as GwintDeck)
            {
               this.factionDecks[_loc4_.getDeckFaction()] = _loc4_;
               _loc3_++;
            }
            _loc2_++;
         }
         this.setupDecksTopBar(_loc3_);
         this.hasDeckInfo = true;
         if(this.selectedDeckIndex != -1)
         {
            this.mcDeckHolder.setTargetDeck(this.factionDecks[this.selectedDeckIndex]);
            this.mcDeckStats.targetDeck = this.factionDecks[this.selectedDeckIndex];
            this.updateTopSelectedDeck();
            if(this.hasCollectionInfo)
            {
               this.updateCollectionDeck();
            }
            this.resetToDefaultButtons();
         }
      }
      
      protected function setupDecksTopBar(param1:int) : void
      {
         var _loc2_:int = 0;
         if(param1 <= 1)
         {
            if(this.txtPrevDeck)
            {
               this.txtPrevDeck.visible = false;
            }
            if(this.txtNextDeck)
            {
               this.txtNextDeck.visible = false;
            }
            if(this.mcLeftFeedbackButton)
            {
               this.mcLeftFeedbackButton.visible = false;
            }
            if(this.mcRightFeedbackButton)
            {
               this.mcRightFeedbackButton.visible = false;
            }
            if(this.mcDeckSelectionTracker)
            {
               this.mcDeckSelectionTracker.visible = false;
            }
         }
         else
         {
            if(this.mcDeckSelectionTracker)
            {
               this.mcDeckSelectionTracker.numElements = param1;
            }
            this.deckFactionList = new Array();
            _loc2_ = 0;
            while(_loc2_ < this.factionDecks.length)
            {
               if(this.factionDecks[_loc2_] != null)
               {
                  this.deckFactionList.push(this.factionDecks[_loc2_]);
               }
               _loc2_++;
            }
         }
      }
      
      protected function updateTopSelectedDeck() : void
      {
         var _loc2_:Rectangle = null;
         var _loc3_:Number = NaN;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc1_:GwintDeck = this.getSelectedDeck();
         dispatchEvent(new GameEvent(GameEvent.CALL,"OnSelectedDeckChanged",[this.selectedDeckIndex]));
         if(this.txtCurrentDeck)
         {
            this.txtCurrentDeck.text = CommonUtils.toUpperCaseSafe(_loc1_.getFactionNameString());
            this.txtCurrentDeckPassive.htmlText = _loc1_.getFactionPerkString();
            this.txtCurrentDeckPassive.htmlText = this.txtCurrentDeckPassive.htmlText;
         }
         if(this.mcFactionIcon)
         {
            this.mcFactionIcon.gotoAndStop(_loc1_.getDeckKingTemplate().getFactionString());
         }
         if(Boolean(this.txtCurrentDeck) && Boolean(this.mcFactionIcon))
         {
            _loc2_ = CommonUtils.getScreenRect();
            _loc3_ = Math.round((_loc2_.x + _loc2_.width - (this.txtCurrentDeck.width + this.mcFactionIcon.width)) / 2);
            this.mcFactionIcon.x = this.txtCurrentDeck.x + this.txtCurrentDeck.width / 2 - this.txtCurrentDeck.textWidth / 2 - this.mcFactionIcon.width;
         }
         if(this.mcLeaderCard)
         {
            this.mcLeaderCard.cardIndex = _loc1_.selectedKingIndex;
         }
         if(this.deckFactionList != null)
         {
            if((_loc4_ = this.deckFactionList.indexOf(_loc1_)) == this.deckFactionList.length - 1)
            {
               _loc5_ = 0;
            }
            else
            {
               _loc5_ = _loc4_ + 1;
            }
            if(_loc4_ == 0)
            {
               _loc6_ = int(this.deckFactionList.length - 1);
            }
            else
            {
               _loc6_ = _loc4_ - 1;
            }
            if(this.txtNextDeck)
            {
               this.txtNextDeck.text = this.deckFactionList[_loc5_].getFactionNameString();
            }
            if(this.txtPrevDeck)
            {
               this.txtPrevDeck.text = this.deckFactionList[_loc6_].getFactionNameString();
            }
            if(this.mcDeckSelectionTracker)
            {
               this.mcDeckSelectionTracker.selectedIndex = _loc4_;
            }
         }
      }
      
      protected function changeDeckIndex(param1:Boolean) : void
      {
         var _loc3_:int = 0;
         var _loc2_:int = this.deckFactionList.indexOf(this.getSelectedDeck());
         if(param1)
         {
            if(_loc2_ == this.deckFactionList.length - 1)
            {
               _loc3_ = 0;
            }
            else
            {
               _loc3_ = _loc2_ + 1;
            }
         }
         else if(_loc2_ == 0)
         {
            _loc3_ = int(this.deckFactionList.length - 1);
         }
         else
         {
            _loc3_ = _loc2_ - 1;
         }
         this.selectedDeckIndex = this.deckFactionList[_loc3_].getDeckFaction();
      }
      
      public function setSelectedDeck(param1:int) : void
      {
         this.selectedDeckIndex = param1;
      }
      
      public function setGwintGamePending(param1:Boolean) : void
      {
         this.gwintGamePending = param1;
         if(this.mcStartGameButton)
         {
            this.mcStartGameButton.visible = param1;
         }
         if(this.txtStartGameText)
         {
            this.txtStartGameText.visible = param1;
         }
         if(this.mcStartGameButtonPC)
         {
            this.mcStartGameButtonPC.visible = param1;
         }
         if(this.mcCloseBtn)
         {
            this.mcCloseBtn.label = param1 ? "[[gwint_pass_game]]" : "[[panel_button_common_close]]";
         }
         this.resetToDefaultButtons();
      }
      
      public function getSelectedDeck() : GwintDeck
      {
         return this.factionDecks[this.selectedDeckIndex];
      }
      
      protected function updateStartGameButton() : void
      {
         var _loc2_:GwintDeck = null;
         if(!this.mcStartGameButton)
         {
            return;
         }
         var _loc1_:Boolean = false;
         if(this.selectedDeckIndex != -1)
         {
            _loc2_ = this.getSelectedDeck();
            if(Boolean(_loc2_) && _loc2_.dbIsValidDeck())
            {
               _loc1_ = true;
            }
         }
         if(_loc1_)
         {
            this.mcStartGameButton.filters = [];
            this.mcStartGameButton.alpha = 1;
            this.mcStartGameButtonPC.filters = [];
            this.mcStartGameButtonPC.alpha = 1;
         }
         else
         {
            this.mcStartGameButton.filters = [CommonUtils.generateDarkenFilter(0.5)];
            this.mcStartGameButton.alpha = 0.5;
            this.mcStartGameButtonPC.filters = [CommonUtils.generateDarkenFilter(0.5)];
            this.mcStartGameButtonPC.alpha = 0.5;
         }
      }
      
      protected function updateGwintCollection(param1:Array) : void
      {
         this.collectionInfo = param1;
         if(this.collectionInfo != null)
         {
            this.hasCollectionInfo = true;
            if(this.hasDeckInfo && this.selectedDeckIndex != -1)
            {
               this.updateCollectionDeck();
            }
         }
      }
      
      protected function updateLeaderList(param1:Array) : void
      {
         this.leaderCollectionInfo = param1;
         if(this.leaderCollectionInfo != null)
         {
            this.hasLeaderInfo = true;
         }
      }
      
      protected function updateCollectionDeck() : void
      {
         var _loc3_:Object = null;
         var _loc4_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc1_:GwintDeck = this.getSelectedDeck();
         var _loc2_:CardManager = CardManager.getInstance();
         var _loc5_:int = _loc1_.getDeckFaction();
         if(this.collectionDeck == null)
         {
            this.collectionDeck = new GwintDeck();
            this.collectionDeck.cardIndices = new Array();
         }
         this.collectionDeck.cardIndices.length = 0;
         _loc6_ = 0;
         while(_loc6_ < this.collectionInfo.length)
         {
            _loc3_ = this.collectionInfo[_loc6_];
            if(!_loc2_.getCardTemplate(_loc3_.cardID))
            {
               throw new Error("GFX [ERROR] - Trying to parse with an invalid card ID: " + _loc3_.cardID);
            }
            if((_loc4_ = _loc2_.getCardTemplate(_loc3_.cardID).factionIdx) == CardTemplate.FactionId_Neutral || _loc4_ == _loc5_)
            {
               _loc7_ = _loc3_.numCopies - _loc1_.dbGetNumCopiesOfCard(_loc3_.cardID);
               _loc8_ = 0;
               while(_loc8_ < _loc7_)
               {
                  this.collectionDeck.cardIndices.push(_loc3_.cardID);
                  _loc8_++;
               }
            }
            _loc6_++;
         }
         if(this.mcCollectionHolder)
         {
            this.mcCollectionHolder.setTargetDeck(this.collectionDeck);
         }
         if(!this.hasUpdatedOnce)
         {
            this.hasUpdatedOnce = true;
            dispatchEvent(new GameEvent(GameEvent.CALL,"OnPlaySoundEvent",["gui_gwint_gwint_start"]));
         }
      }
      
      override protected function closeMenu() : void
      {
         dispatchEvent(new GameEvent(GameEvent.CALL,"OnPlaySoundEvent",["gui_gwint_lock_in"]));
         super.closeMenu();
      }
      
      protected function handleStartPressed(param1:ButtonEvent) : void
      {
         var _loc2_:GwintDeck = this.getSelectedDeck();
         if(!this.mcChoiceDialog.visible && !this.isInZoomMode)
         {
            if(_loc2_ == null || !_loc2_.dbIsValidDeck())
            {
               this.mcDeckStats.highlightUnitCount();
               dispatchEvent(new GameEvent(GameEvent.CALL,"OnLackOfUnitsError",[_loc2_.dbCountCards(CardTemplate.CardType_Creature,CardTemplate.CardEffect_None)]));
            }
            else if(this.gwintGamePending)
            {
               this.closeMenu();
            }
         }
      }
      
      override protected function handleInputNavigate(param1:InputEvent) : void
      {
         if(this.mcTutorial && this.mcTutorial.visible && !this.mcTutorial.isPaused)
         {
            this.mcTutorial.handleInput(param1);
            return;
         }
         var _loc2_:GwintDeck = this.getSelectedDeck();
         var _loc3_:InputDetails = param1.details;
         var _loc4_:Boolean = _loc3_.value == InputValue.KEY_DOWN || _loc3_.value == InputValue.KEY_HOLD;
         var _loc5_:* = _loc3_.value == InputValue.KEY_UP;
         if(!param1.handled)
         {
            if(Boolean(this.mcChoiceDialog) && this.mcChoiceDialog.visible)
            {
               switch(_loc3_.navEquivalent)
               {
                  case NavigationCode.GAMEPAD_R2:
                     if(_loc5_)
                     {
                        if(this.isInZoomMode && !this.choosingLeader)
                        {
                           this.closeZoomCB();
                        }
                     }
               }
            }
            else
            {
               if(_loc3_.code == KeyCode.X && _loc5_ && !this.isInZoomMode)
               {
                  this.startChooseModeLeader();
               }
               else if(_loc3_.code == KeyCode.H && _loc5_ && !this.gwintGamePending && !this.isInZoomMode)
               {
                  this.tryClose();
               }
               else if(_loc3_.code == KeyCode.ENTER || _loc3_.navEquivalent == NavigationCode.GAMEPAD_Y)
               {
                  if(_loc5_ && !this.mcChoiceDialog.visible && !this.isInZoomMode)
                  {
                     if(_loc2_ == null || !_loc2_.dbIsValidDeck())
                     {
                        this.mcDeckStats.highlightUnitCount();
                        dispatchEvent(new GameEvent(GameEvent.CALL,"OnLackOfUnitsError",[_loc2_.dbCountCards(CardTemplate.CardType_Creature,CardTemplate.CardEffect_None)]));
                     }
                     else if(this.gwintGamePending)
                     {
                        this.closeMenu();
                     }
                  }
               }
               else if((_loc3_.code == KeyCode.NUMBER_1 || _loc3_.code == KeyCode.NUMPAD_1 || _loc3_.code == KeyCode.PAGE_DOWN) && _loc5_ && !this.isInZoomMode)
               {
                  this.changeDeckIndex(false);
               }
               else if((_loc3_.code == KeyCode.NUMBER_3 || _loc3_.code == KeyCode.NUMPAD_3 || _loc3_.code == KeyCode.PAGE_UP) && _loc5_ && !this.isInZoomMode)
               {
                  this.changeDeckIndex(true);
               }
               else
               {
                  switch(_loc3_.navEquivalent)
                  {
                     case NavigationCode.GAMEPAD_B:
                        if(_loc5_ && !this.mcChoiceDialog.visible && !this.isInZoomMode)
                        {
                           this.tryClose();
                        }
                        break;
                     case NavigationCode.GAMEPAD_X:
                        if(_loc5_ && !this.isInZoomMode)
                        {
                           this.startChooseModeLeader();
                        }
                        break;
                     case NavigationCode.LEFT:
                        if(_loc4_ && !this.isInZoomMode)
                        {
                           --currentModuleIdx;
                           this.resetToDefaultButtons();
                        }
                        break;
                     case NavigationCode.RIGHT:
                        if(_loc4_ && !this.isInZoomMode)
                        {
                           ++currentModuleIdx;
                           this.resetToDefaultButtons();
                        }
                        break;
                     case NavigationCode.GAMEPAD_L1:
                        if(_loc5_ && !this.isInZoomMode)
                        {
                           this.changeDeckIndex(false);
                        }
                        break;
                     case NavigationCode.GAMEPAD_R1:
                        if(_loc5_ && !this.isInZoomMode)
                        {
                           this.changeDeckIndex(true);
                        }
                        break;
                     case NavigationCode.GAMEPAD_R2:
                        if(_loc5_)
                        {
                           if(!this.isInZoomMode)
                           {
                              this.tryZoomCard();
                           }
                        }
                  }
               }
               if(_loc3_.value == InputValue.KEY_DOWN && !this.isInZoomMode)
               {
                  switch(_loc3_.navEquivalent)
                  {
                     case NavigationCode.RIGHT_STICK_LEFT:
                        --currentModuleIdx;
                        this.resetToDefaultButtons();
                        break;
                     case NavigationCode.RIGHT_STICK_RIGHT:
                        ++currentModuleIdx;
                        this.resetToDefaultButtons();
                  }
               }
            }
         }
      }
      
      protected function tryClose() : void
      {
         if(!this.gwintGamePending)
         {
            this.closeMenu();
         }
         else
         {
            dispatchEvent(new GameEvent(GameEvent.CALL,"OnConfirmSurrender"));
         }
      }
      
      protected function handleClosePressed(param1:ButtonEvent) : void
      {
         this.tryClose();
      }
      
      protected function handlePrevButtonPress(param1:ButtonEvent) : void
      {
         if(!this.isInZoomMode)
         {
            this.changeDeckIndex(false);
         }
      }
      
      protected function handleNextButtonPress(param1:ButtonEvent) : void
      {
         if(!this.isInZoomMode)
         {
            this.changeDeckIndex(true);
         }
      }
      
      protected function handleDeckSlotActivated(param1:SlotActionEvent) : void
      {
         if(param1.actionType == InventoryActionType.DROP || this.isInZoomMode)
         {
            return;
         }
         var _loc2_:CardSlot = param1.targetSlot as CardSlot;
         dispatchEvent(new GameEvent(GameEvent.CALL,"OnCardRemovedFromDeck",[this.selectedDeckIndex,_loc2_.cardIndex]));
         this.collectionDeck.dbAddCard(_loc2_.cardIndex);
         this.getSelectedDeck().dbRemoveCard(_loc2_.cardIndex);
         dispatchEvent(new GameEvent(GameEvent.CALL,"OnPlaySoundEvent",["gui_gwint_discard_card"]));
         this.mcDeckStats.updateStats();
         this.updateStartGameButton();
      }
      
      protected function handleCollectionSlotActivated(param1:SlotActionEvent) : void
      {
         if(param1.actionType == InventoryActionType.DROP || this.isInZoomMode)
         {
            return;
         }
         var _loc2_:CardSlot = param1.targetSlot as CardSlot;
         var _loc3_:GwintDeck = this.getSelectedDeck();
         if(!_loc3_ || !_loc3_.dbCanAddCard(_loc2_.cardIndex))
         {
            this.mcDeckStats.highlightSpecialCards();
            dispatchEvent(new GameEvent(GameEvent.CALL,"OnTooManySpecialCards"));
            return;
         }
         dispatchEvent(new GameEvent(GameEvent.CALL,"OnCardAddedToDeck",[this.selectedDeckIndex,_loc2_.cardIndex]));
         this.collectionDeck.dbRemoveCard(_loc2_.cardIndex);
         this.getSelectedDeck().dbAddCard(_loc2_.cardIndex);
         dispatchEvent(new GameEvent(GameEvent.CALL,"OnPlaySoundEvent",["gui_gwint_draw_2"]));
         this.mcDeckStats.updateStats();
         this.updateStartGameButton();
         if(this.mcTutorial.visible && this.getSelectedDeck().dbIsValidDeck())
         {
            this.mcTutorial.continueTutorial();
         }
      }
      
      protected function startChooseModeLeader() : void
      {
         var _loc1_:GwintDeck = null;
         var _loc2_:Vector.<int> = null;
         var _loc3_:Vector.<int> = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:CardManager = null;
         var _loc8_:CardTemplate = null;
         var _loc9_:Boolean = false;
         var _loc10_:int = 0;
         var _loc11_:CardSlot = null;
         if(this.choosingLeader)
         {
            return;
         }
         this.choosingLeader = true;
         if(this.mcChoiceDialog)
         {
            _loc1_ = this.getSelectedDeck();
            _loc2_ = new Vector.<int>();
            _loc3_ = new Vector.<int>();
            _loc7_ = CardManager.getInstance();
            _loc10_ = -1;
            _loc4_ = 0;
            while(_loc4_ < this.leaderCollectionInfo.length)
            {
               _loc3_.push(this.leaderCollectionInfo[_loc4_].cardID);
               _loc4_++;
            }
            switch(_loc1_.getDeckFaction())
            {
               case CardTemplate.FactionId_Nilfgaard:
                  _loc2_.push(2001);
                  _loc2_.push(2002);
                  _loc2_.push(2003);
                  _loc2_.push(2004);
                  _loc2_.push(2005);
                  break;
               case CardTemplate.FactionId_No_Mans_Land:
                  _loc2_.push(4001);
                  _loc2_.push(4002);
                  _loc2_.push(4003);
                  _loc2_.push(4004);
                  _loc2_.push(4005);
                  break;
               case CardTemplate.FactionId_Northern_Kingdom:
                  _loc2_.push(1001);
                  _loc2_.push(1002);
                  _loc2_.push(1003);
                  _loc2_.push(1004);
                  _loc2_.push(1005);
                  break;
               case CardTemplate.FactionId_Scoiatael:
                  _loc2_.push(3001);
                  _loc2_.push(3002);
                  _loc2_.push(3003);
                  _loc2_.push(3004);
                  _loc2_.push(3005);
                  break;
               case CardTemplate.FactionId_Skellige:
                  _loc2_.push(5001);
                  _loc2_.push(5002);
            }
            if(_loc2_.length <= 0)
            {
               throw new Error("GFX [ERROR] - tried to show leader card choice but couldn\'t find any which is WIERD");
            }
            this.resetInputFeedbackButtons();
            this.mcChoiceDialog.showDialogCardTemplates(_loc2_,this.leaderChosenCb,this.cancelChoiceCb,"[[gwint_deckbuilder_choose_leader]]");
            this.mcDeckHolder._inputEnabled = false;
            this.mcCollectionHolder._inputEnabled = false;
            this.isInZoomMode = true;
            _loc4_ = 0;
            while(_loc4_ < this.mcChoiceDialog.cardsCarousel.getRenderersLength())
            {
               if(_loc11_ = this.mcChoiceDialog.cardsCarousel.getRendererAt(_loc4_) as CardSlot)
               {
                  if(_loc11_.cardIndex == this.getSelectedDeck().selectedKingIndex)
                  {
                     _loc10_ = _loc4_;
                  }
                  if(_loc3_.indexOf(_loc11_.cardIndex) == -1)
                  {
                     _loc11_.activateEnabled = false;
                  }
               }
               _loc4_++;
            }
            if(_loc10_ != -1)
            {
               this.mcChoiceDialog.cardsCarousel.selectedIndex = _loc10_;
            }
         }
      }
      
      protected function leaderChosenCb(param1:int = -1) : void
      {
         this.choosingLeader = false;
         this.mcChoiceDialog.hideDialog();
         this.mcDeckHolder._inputEnabled = true;
         this.mcCollectionHolder._inputEnabled = true;
         this.isInZoomMode = false;
         this.getSelectedDeck().selectedKingIndex = param1;
         if(this.mcLeaderCard)
         {
            this.mcLeaderCard.cardIndex = param1;
         }
         dispatchEvent(new GameEvent(GameEvent.CALL,"OnLeaderChanged",[this.selectedDeckIndex,param1]));
         this.resetToDefaultButtons();
      }
      
      protected function cancelChoiceCb() : void
      {
         this.choosingLeader = false;
         this.mcChoiceDialog.hideDialog();
         this.mcDeckHolder._inputEnabled = true;
         this.mcCollectionHolder._inputEnabled = true;
         this.isInZoomMode = false;
         this.resetToDefaultButtons();
      }
      
      protected function resetToDefaultButtons() : void
      {
         if(this.isInZoomMode || this.mcTutorial && this.mcTutorial.visible && !this.mcTutorial.isPaused)
         {
            return;
         }
         this.resetInputFeedbackButtons();
         if(this.gwintGamePending)
         {
            InputFeedbackManager.appendButtonById(GwintInputFeedback.startGame,NavigationCode.GAMEPAD_Y,KeyCode.ENTER,"gwint_deckbuilder_start_game");
            InputFeedbackManager.appendButtonById(GwintInputFeedback.quitGame,NavigationCode.GAMEPAD_B,-1,"gwint_pass_game");
         }
         else
         {
            InputFeedbackManager.appendButtonById(GwintInputFeedback.closeDeckbuilder,NavigationCode.GAMEPAD_B,-1,"panel_button_common_close");
         }
         InputFeedbackManager.appendButtonById(GwintInputFeedback.choseLeader,NavigationCode.GAMEPAD_X,KeyCode.X,"gwint_deckbuilder_inputfeedback_changeleader");
         if(this.deckFactionList != null && this.deckFactionList.length > 1)
         {
            InputFeedbackManager.appendButtonById(GwintInputFeedback.changeDeck,NavigationCode.GAMEPAD_RBLB,-1,"gwint_deckbuilder_inputfeedback_changedeck");
         }
         if(this.mcDeckHolder.focused)
         {
            if(this.mcDeckHolder.isOpen && this.mcDeckHolder.mcCardSlotList.getSelectedRenderer() != null)
            {
               InputFeedbackManager.appendButtonById(GwintInputFeedback.openTab,NavigationCode.GAMEPAD_A,KeyCode.E,"gwint_deckbuilder_inputfeedback_removecard");
               InputFeedbackManager.appendButtonById(GwintInputFeedback.zoomCard,NavigationCode.GAMEPAD_R2,KeyCode.RIGHT_MOUSE,"panel_button_common_zoom");
            }
            else if(this.mcDeckHolder.canOpen())
            {
               InputFeedbackManager.appendButtonById(GwintInputFeedback.openTab,NavigationCode.GAMEPAD_A,-1,"inputfeedback_common_open_grid");
            }
         }
         else if(this.mcCollectionHolder.focused)
         {
            if(this.mcCollectionHolder.isOpen && this.mcCollectionHolder.mcCardSlotList.getSelectedRenderer() != null)
            {
               InputFeedbackManager.appendButtonById(GwintInputFeedback.openTab,NavigationCode.GAMEPAD_A,KeyCode.E,"gwint_deckbuilder_inputfeedback_addcard");
               InputFeedbackManager.appendButtonById(GwintInputFeedback.zoomCard,NavigationCode.GAMEPAD_R2,KeyCode.RIGHT_MOUSE,"panel_button_common_zoom");
            }
            else if(this.mcCollectionHolder.canOpen())
            {
               InputFeedbackManager.appendButtonById(GwintInputFeedback.openTab,NavigationCode.GAMEPAD_A,-1,"inputfeedback_common_open_grid");
            }
         }
      }
      
      protected function onSelectedCardChanged(param1:ListEvent) : void
      {
         this.resetToDefaultButtons();
      }
      
      protected function tryZoomCard(param1:CardSlot = null, param2:GwintDeckCTabModule = null) : void
      {
         var _loc5_:int = 0;
         var _loc6_:CardSlot = null;
         var _loc7_:int = 0;
         var _loc3_:GwintDeckCTabModule = null;
         var _loc4_:Vector.<int> = new Vector.<int>();
         if(this.isInZoomMode)
         {
            return;
         }
         if(param1 != null)
         {
            _loc4_.push(param1.cardIndex);
         }
         else
         {
            if(param2 != null)
            {
               _loc3_ = param2;
            }
            else if(this.mcDeckHolder.focused && this.mcDeckHolder.isOpen && this.mcDeckHolder.mcCardSlotList.getSelectedRenderer() != null)
            {
               _loc3_ = this.mcDeckHolder;
            }
            else if(this.mcCollectionHolder.focused && this.mcCollectionHolder.isOpen && this.mcCollectionHolder.mcCardSlotList.getSelectedRenderer() != null)
            {
               _loc3_ = this.mcCollectionHolder;
            }
            if(_loc3_ != null)
            {
               _loc5_ = 0;
               while(_loc5_ < _loc3_.mcCardSlotList.getRenderersLength())
               {
                  if(_loc6_ = _loc3_.mcCardSlotList.getRendererAt(_loc5_) as CardSlot)
                  {
                     _loc4_.push(_loc6_.cardIndex);
                  }
                  _loc5_++;
               }
               _loc7_ = _loc3_.mcCardSlotList.selectedIndex;
            }
         }
         if(_loc4_.length != 0)
         {
            this.resetInputFeedbackButtons();
            dispatchEvent(new GameEvent(GameEvent.CALL,"OnPlaySoundEvent",["gui_gwint_preview_card"]));
            InputFeedbackManager.appendButtonById(GwintInputFeedback.zoomCard,NavigationCode.GAMEPAD_R2,KeyCode.RIGHT_MOUSE,"panel_button_common_close");
            this.isInZoomMode = true;
            this.mcChoiceDialog.showDialogCardTemplates(_loc4_,null,this.closeZoomCB,"");
            this.mcChoiceDialog.cardsCarousel.validateNow();
            this.mcDeckHolder._inputEnabled = false;
            this.mcCollectionHolder._inputEnabled = false;
            if(_loc7_ != -1)
            {
               this.mcChoiceDialog.cardsCarousel.selectedIndex = _loc7_;
            }
         }
      }
      
      protected function closeZoomCB(param1:int = -1) : void
      {
         var _loc2_:GwintDeckCTabModule = null;
         if(this.mcDeckHolder.focused && this.mcDeckHolder.isOpen && this.mcDeckHolder.mcCardSlotList.getSelectedRenderer() != null)
         {
            _loc2_ = this.mcDeckHolder;
         }
         else if(this.mcCollectionHolder.focused && this.mcCollectionHolder.isOpen && this.mcCollectionHolder.mcCardSlotList.getSelectedRenderer() != null)
         {
            _loc2_ = this.mcCollectionHolder;
         }
         if(_loc2_ != null)
         {
            _loc2_.mcCardSlotList.selectedIndex = this.mcChoiceDialog.cardsCarousel.selectedIndex;
         }
         dispatchEvent(new GameEvent(GameEvent.CALL,"OnPlaySoundEvent",["gui_gwint_preview_card"]));
         this.isInZoomMode = false;
         this.mcChoiceDialog.hideDialog();
         this.mcDeckHolder._inputEnabled = true;
         this.mcCollectionHolder._inputEnabled = true;
         this.resetToDefaultButtons();
      }
      
      protected function onCarouselSelectionChanged(param1:ListEvent) : void
      {
         var _loc2_:GwintDeckCTabModule = null;
         if(this.isInZoomMode && !this.choosingLeader)
         {
            _loc2_ = null;
            if(this.mcDeckHolder.focused && this.mcDeckHolder.isOpen && this.mcDeckHolder.mcCardSlotList.getSelectedRenderer() != null)
            {
               _loc2_ = this.mcDeckHolder;
            }
            else if(this.mcCollectionHolder.focused && this.mcCollectionHolder.isOpen && this.mcCollectionHolder.mcCardSlotList.getSelectedRenderer() != null)
            {
               _loc2_ = this.mcCollectionHolder;
            }
            if(_loc2_ != null)
            {
               _loc2_.mcCardSlotList.selectedIndex = param1.index;
            }
         }
      }
      
      protected function showTutCarousel() : void
      {
         this.startChooseModeLeader();
         this.mcChoiceDialog.inputEnabled = false;
         this.resetInputFeedbackButtons();
      }
      
      protected function hideTutCarousel() : void
      {
         this.choosingLeader = false;
         this.mcChoiceDialog.hideDialog();
         this.isInZoomMode = false;
      }
      
      protected function clearMouseEnabledOnTextFieldsInDeckStats() : void
      {
         var _loc1_:TextField = null;
         var _loc2_:int = 0;
         if(this.mcDeckStats)
         {
            _loc2_ = _loc2_;
            while(_loc2_ < this.mcDeckStats.numChildren)
            {
               _loc1_ = this.mcDeckStats.getChildAt(_loc2_) as TextField;
               if(_loc1_)
               {
                  _loc1_.mouseEnabled = false;
               }
               _loc2_++;
            }
         }
      }
      
      protected function resetInputFeedbackButtons() : void
      {
         InputFeedbackManager.cleanupButtons();
         InputFeedbackManager.appendButtonById(GwintInputFeedback.navigate,NavigationCode.GAMEPAD_L3,-1,"panel_button_common_navigation");
      }
      
      protected function setupLeaderCard() : void
      {
         if(this.mcLeaderCard)
         {
            this.mcLeaderCard.addEventListener(CardSlot.CardMouseOver,this.onLeaderMouseOver,false,0,true);
            this.mcLeaderCard.addEventListener(CardSlot.CardMouseOut,this.onLeaderMouseOut,false,0,true);
            this.mcLeaderCard.addEventListener(CardSlot.CardMouseRightClick,this.onLeaderMouseRightClick,false,0,true);
            this.mcLeaderCard.addEventListener(CardSlot.CardMouseDoubleClick,this.onLeaderMouseDoubleClick,false,0,true);
         }
      }
      
      protected function onLeaderMouseOver(param1:Event) : void
      {
         this._leaderCardHovered = true;
         if(!InputManager.getInstance().isGamepad())
         {
            this.mcLeaderCard.selected = true;
         }
      }
      
      protected function onLeaderMouseOut(param1:Event) : void
      {
         this._leaderCardHovered = false;
         if(!InputManager.getInstance().isGamepad())
         {
            this.mcLeaderCard.selected = false;
         }
      }
      
      protected function onLeaderMouseRightClick(param1:Event) : void
      {
         if(!this.isInZoomMode)
         {
            this.tryZoomCard(this.mcLeaderCard);
            this.mcChoiceDialog.ignoreNextRightClick = true;
         }
      }
      
      protected function onLeaderMouseDoubleClick(param1:Event) : void
      {
         if(!this.isInZoomMode && !this.choosingLeader)
         {
            this.startChooseModeLeader();
         }
      }
      
      protected function handleControllerChange(param1:ControllerChangeEvent) : void
      {
         if(param1.isGamepad)
         {
            if(Boolean(this.mcLeaderCard) && this.mcLeaderCard.selected)
            {
               this.mcLeaderCard.selected = false;
            }
         }
         else if(Boolean(this.mcLeaderCard) && this._leaderCardHovered)
         {
            this.mcLeaderCard.selected = true;
         }
      }
      
      protected function onCollectionRightClickCard(param1:Event) : void
      {
         if(!this.isInZoomMode)
         {
            if(this.mcCollectionHolder.mcCardSlotList.selectedIndex != -1)
            {
               this.tryZoomCard(null,this.mcCollectionHolder);
               this.mcChoiceDialog.ignoreNextRightClick = true;
            }
         }
      }
      
      protected function onDeckRightClickCard(param1:Event) : void
      {
         if(!this.isInZoomMode)
         {
            if(this.mcDeckHolder.mcCardSlotList.selectedIndex != -1)
            {
               this.tryZoomCard(null,this.mcDeckHolder);
               this.mcChoiceDialog.ignoreNextRightClick = true;
            }
         }
      }
      
      internal function __setProp_mcLeaderCard_Scene1_mcLeaderCard_0() : *
      {
         try
         {
            this.mcLeaderCard["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         this.mcLeaderCard.cardIndex = 9;
         this.mcLeaderCard.cardState = "deckBuilder";
         this.mcLeaderCard.draggingEnabled = true;
         this.mcLeaderCard.enabled = true;
         this.mcLeaderCard.enableInitCallback = false;
         this.mcLeaderCard.gridSize = 1;
         this.mcLeaderCard.instanceId = -1;
         this.mcLeaderCard.navigationDown = 0;
         this.mcLeaderCard.navigationLeft = 0;
         this.mcLeaderCard.navigationRight = 0;
         this.mcLeaderCard.navigationUp = 0;
         this.mcLeaderCard.selectable = true;
         this.mcLeaderCard.visible = true;
         try
         {
            this.mcLeaderCard["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
      
      internal function __setProp_mcRightPCButton_Scene1_mcRightPCButton_0() : *
      {
         try
         {
            this.mcRightPCButton["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         this.mcRightPCButton.autoRepeat = false;
         this.mcRightPCButton.autoSize = "none";
         this.mcRightPCButton.data = "";
         this.mcRightPCButton.enabled = true;
         this.mcRightPCButton.enableInitCallback = false;
         this.mcRightPCButton.focusable = false;
         this.mcRightPCButton.label = "";
         this.mcRightPCButton.selected = false;
         this.mcRightPCButton.showOnGamepad = false;
         this.mcRightPCButton.showOnMouseKeyboard = true;
         this.mcRightPCButton.toggle = false;
         this.mcRightPCButton.visible = true;
         try
         {
            this.mcRightPCButton["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
      
      internal function __setProp_mcLeftPCButton_Scene1_mcLeftPCButton_0() : *
      {
         try
         {
            this.mcLeftPCButton["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         this.mcLeftPCButton.autoRepeat = false;
         this.mcLeftPCButton.autoSize = "none";
         this.mcLeftPCButton.data = "";
         this.mcLeftPCButton.enabled = true;
         this.mcLeftPCButton.enableInitCallback = false;
         this.mcLeftPCButton.focusable = false;
         this.mcLeftPCButton.label = "";
         this.mcLeftPCButton.selected = false;
         this.mcLeftPCButton.showOnGamepad = false;
         this.mcLeftPCButton.showOnMouseKeyboard = true;
         this.mcLeftPCButton.toggle = false;
         this.mcLeftPCButton.visible = true;
         try
         {
            this.mcLeftPCButton["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
      
      internal function __setProp_mcCloseBtn_Scene1_Layer2_0() : *
      {
         try
         {
            this.mcCloseBtn["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         this.mcCloseBtn.autoRepeat = false;
         this.mcCloseBtn.autoSize = "none";
         this.mcCloseBtn.data = "";
         this.mcCloseBtn.enabled = true;
         this.mcCloseBtn.enableInitCallback = false;
         this.mcCloseBtn.focusable = false;
         this.mcCloseBtn.label = "";
         this.mcCloseBtn.selected = false;
         this.mcCloseBtn.showOnGamepad = false;
         this.mcCloseBtn.showOnMouseKeyboard = true;
         this.mcCloseBtn.toggle = false;
         this.mcCloseBtn.visible = true;
         try
         {
            this.mcCloseBtn["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
   }
}
