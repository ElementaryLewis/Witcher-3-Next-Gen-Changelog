package red.game.witcher3.menus.gwint
{
   import flash.events.MouseEvent;
   import red.core.constants.KeyCode;
   import red.game.witcher3.constants.GwintInputFeedback;
   import red.game.witcher3.controls.InputFeedbackButton;
   import red.game.witcher3.controls.W3ChoiceDialog;
   import red.game.witcher3.events.GwintCardEvent;
   import red.game.witcher3.events.GwintHolderEvent;
   import red.game.witcher3.managers.InputFeedbackManager;
   import scaleform.clik.constants.InputValue;
   import scaleform.clik.constants.NavigationCode;
   import scaleform.clik.events.InputEvent;
   import scaleform.clik.events.ListEvent;
   import scaleform.clik.ui.InputDetails;
   import scaleform.gfx.MouseEventEx;
   
   public class HumanPlayerController extends BasePlayerController
   {
       
      
      protected var _handHolder:GwintCardHolder;
      
      protected var mcChoiceDialog:W3ChoiceDialog;
      
      protected var _currentZoomedHolder:GwintCardHolder = null;
      
      protected var _skipButton:InputFeedbackButton;
      
      protected var _cardConfirmation:Boolean;
      
      public function HumanPlayerController()
      {
         super();
         _stateMachine.AddState("Idle",this.state_begin_Idle,this.on_state_about_to_update,this.state_end_Idle);
         _stateMachine.AddState("ChoosingCard",this.state_begin_ChoosingCard,this.state_update_ChoosingCard,this.state_end_ChoosingCard);
         _stateMachine.AddState("ChoosingHandler",this.state_begin_ChoosingHandler,this.state_update_ChoosingHandler,null);
         _stateMachine.AddState("ChoosingTargetCard",this.state_begin_ChoosingTargetCard,this.state_update_ChoosingTargetCard,null);
         _stateMachine.AddState("WaitConfirmation",this.state_begin_WaitConfirmation,this.state_update_WaitConfirmation,null);
         _stateMachine.AddState("ApplyingCard",this.state_begin_ApplyingCard,this.state_update_ApplyingCard,null);
      }
      
      override public function set boardRenderer(value:GwintBoardRenderer) : void
      {
         if(_boardRenderer != value && Boolean(value))
         {
            value.addEventListener(GwintCardEvent.CARD_CHOSEN,this.handleCardChosen,false,0,true);
            value.addEventListener(GwintCardEvent.CARD_SELECTED,this.handleCardSelected,false,0,true);
            value.addEventListener(GwintHolderEvent.HOLDER_CHOSEN,this.handleHolderChosen,false,0,true);
            value.addEventListener(GwintHolderEvent.HOLDER_SELECTED,this.handleHolderSelected,false,0,true);
            this._handHolder = value.getCardHolder(CardManager.CARD_LIST_LOC_HAND,playerID);
         }
         super.boardRenderer = value;
      }
      
      public function setChoiceDialog(choiceDialog:W3ChoiceDialog) : void
      {
         this.mcChoiceDialog = choiceDialog;
      }
      
      public function get skipButton() : InputFeedbackButton
      {
         return this._skipButton;
      }
      
      public function set skipButton(value:InputFeedbackButton) : void
      {
         this._skipButton = value;
         if(this._skipButton)
         {
            this._skipButton.holdCallback = this.handleSkipTurn;
            if(_stateMachine.currentState == "ChoosingCard")
            {
               this._skipButton.visible = true;
            }
            else
            {
               this._skipButton.visible = false;
            }
            this._skipButton.addEventListener(MouseEvent.CLICK,this.handleSkipTurn,false,0,true);
         }
      }
      
      private function handleSkipTurn(event:MouseEvent = null) : void
      {
         this.skipTurn();
      }
      
      override public function startTurn() : void
      {
         if(CardManager.getInstance().getCardInstanceList(CardManager.CARD_LIST_LOC_HAND,playerID).length == 0 && !CardManager.getInstance().getCardLeader(playerID).canBeUsed)
         {
            currentRoundStatus = BasePlayerController.ROUND_PLAYER_STATUS_DONE;
         }
         else
         {
            super.startTurn();
            _stateMachine.ChangeState("ChoosingCard");
         }
      }
      
      override public function skipTurn() : void
      {
         if(_stateMachine.currentState == "ChoosingCard" && this._currentZoomedHolder == null)
         {
            currentRoundStatus = BasePlayerController.ROUND_PLAYER_STATUS_DONE;
            _turnOver = true;
            if(_transactionCard != null)
            {
               _boardRenderer.activateAllHolders(true);
               _boardRenderer.selectCard(_transactionCard);
               declineCardTransaction();
            }
            _stateMachine.ChangeState("Idle");
         }
      }
      
      override public function set cardZoomEnabled(value:Boolean) : *
      {
         super.cardZoomEnabled = value;
         if(!value && this._currentZoomedHolder != null)
         {
            this.closeZoomCB();
         }
      }
      
      protected function on_state_about_to_update() : void
      {
         if(Boolean(this._currentZoomedHolder) && !this.mcChoiceDialog.visible)
         {
            this.closeZoomCB();
         }
      }
      
      protected function state_begin_Idle() : void
      {
         _decidedCardTransaction = null;
         if(_boardRenderer)
         {
            _boardRenderer.activateAllHolders(true);
            if(Boolean(this._handHolder) && _boardRenderer.getSelectedCardHolder() != this._handHolder)
            {
               _boardRenderer.selectCardHolderAdv(this._handHolder);
            }
            _boardRenderer.getCardHolder(CardManager.CARD_LIST_LOC_LEADER,CardManager.PLAYER_1).updateLeaderStatus(false);
         }
         declineCardTransaction();
         if(!GwintGameMenu.mSingleton.mcTutorials.visible && this._currentZoomedHolder == null)
         {
            this.resetToDefaultButtons();
            InputFeedbackManager.appendButtonById(GwintInputFeedback.navigate,NavigationCode.GAMEPAD_L3,-1,"panel_button_common_navigation");
            if(_boardRenderer && _boardRenderer.getSelectedCard() != null && cardZoomEnabled)
            {
               InputFeedbackManager.appendButtonById(GwintInputFeedback.zoomCard,NavigationCode.GAMEPAD_R2,KeyCode.RIGHT_MOUSE,"panel_button_common_zoom");
            }
         }
      }
      
      protected function state_end_Idle() : void
      {
         if(_boardRenderer)
         {
            if(_boardRenderer.getSelectedCardHolder() != this._handHolder)
            {
               _boardRenderer.selectCardHolderAdv(this._handHolder);
            }
            _boardRenderer.getCardHolder(CardManager.CARD_LIST_LOC_LEADER,CardManager.PLAYER_1).updateLeaderStatus(true);
         }
      }
      
      protected function state_begin_ChoosingCard() : void
      {
         var leaderCard:CardLeaderInstance = null;
         if(this._skipButton)
         {
            this._skipButton.visible = true;
         }
         if(this._currentZoomedHolder == null)
         {
            this.resetToDefaultButtons();
            InputFeedbackManager.appendButtonById(GwintInputFeedback.navigate,NavigationCode.GAMEPAD_L3,-1,"panel_button_common_navigation");
            leaderCard = CardManager.getInstance().getCardLeader(playerID);
            if(Boolean(leaderCard) && leaderCard.canBeUsed)
            {
               InputFeedbackManager.appendButtonById(GwintInputFeedback.leaderCard,NavigationCode.GAMEPAD_X,KeyCode.X,"gwint_use_leader");
            }
            if(this._handHolder.cardSlotsList.length > 0)
            {
               InputFeedbackManager.appendButtonById(GwintInputFeedback.apply,NavigationCode.GAMEPAD_A,KeyCode.ENTER,"panel_button_common_select");
            }
            if(_boardRenderer.getSelectedCard() != null && cardZoomEnabled)
            {
               InputFeedbackManager.appendButtonById(GwintInputFeedback.zoomCard,NavigationCode.GAMEPAD_R2,KeyCode.RIGHT_MOUSE,"panel_button_common_zoom");
            }
         }
      }
      
      protected function state_update_ChoosingCard() : void
      {
         var cardInstance:CardInstance = null;
         var isLeaderCard:* = false;
         var isCardEffect:Boolean = false;
         var isGlobalEffect:Boolean = false;
         this.on_state_about_to_update();
         if(_transactionCard)
         {
            cardInstance = CardManager.getInstance().getCardInstance(_transactionCard.instanceId);
            isLeaderCard = cardInstance is CardLeaderInstance;
            isCardEffect = cardInstance.templateRef.hasEffect(CardTemplate.CardEffect_UnsummonDummy);
            isGlobalEffect = cardInstance.templateRef.isType(CardTemplate.CardType_Global_Effect);
            if(isLeaderCard || isGlobalEffect)
            {
               _stateMachine.ChangeState("WaitConfirmation");
            }
            else if(isCardEffect)
            {
               _stateMachine.ChangeState("ChoosingTargetCard");
            }
            else
            {
               _stateMachine.ChangeState("ChoosingHandler");
            }
         }
      }
      
      protected function state_end_ChoosingCard() : void
      {
         if(this._skipButton)
         {
            this._skipButton.visible = false;
         }
      }
      
      protected function state_begin_ChoosingTargetCard() : void
      {
         var cardInstance:CardInstance = null;
         var selectedHolder:GwintCardHolder = null;
         var transCardInstance:CardInstance = null;
         var targetCardInstance:CardInstance = null;
         if(Boolean(_transactionCard) && Boolean(_boardRenderer))
         {
            cardInstance = CardManager.getInstance().getCardInstance(_transactionCard.instanceId);
            _boardRenderer.activateHoldersForCard(cardInstance,true);
         }
         if(this._currentZoomedHolder == null)
         {
            this.resetToDefaultButtons();
            InputFeedbackManager.appendButtonById(GwintInputFeedback.navigate,NavigationCode.GAMEPAD_L3,-1,"panel_button_common_navigation");
            InputFeedbackManager.appendButtonById(GwintInputFeedback.cancel,NavigationCode.GAMEPAD_B,KeyCode.ESCAPE,"panel_common_cancel");
            selectedHolder = _boardRenderer.getSelectedCardHolder();
            if(selectedHolder.cardSelectionEnabled && selectedHolder.cardSlotsList.length > 0 && selectedHolder.getSelectedCardSlot() != null)
            {
               transCardInstance = CardManager.getInstance().getCardInstance(_transactionCard.instanceId);
               targetCardInstance = CardManager.getInstance().getCardInstance(selectedHolder.getSelectedCardSlot().instanceId);
               if(transCardInstance.canBeCastOn(targetCardInstance))
               {
                  InputFeedbackManager.appendButtonById(GwintInputFeedback.apply,NavigationCode.GAMEPAD_A,KeyCode.ENTER,"panel_common_apply");
               }
            }
         }
      }
      
      protected function state_update_ChoosingTargetCard() : void
      {
         this.on_state_about_to_update();
      }
      
      protected function state_begin_ChoosingHandler() : void
      {
         var cardInstance:CardInstance = null;
         if(Boolean(_transactionCard) && Boolean(_boardRenderer))
         {
            cardInstance = CardManager.getInstance().getCardInstance(_transactionCard.instanceId);
            boardRenderer.activateHoldersForCard(cardInstance,true);
         }
         if(this._currentZoomedHolder == null)
         {
            this.resetToDefaultButtons();
            InputFeedbackManager.appendButtonById(GwintInputFeedback.apply,NavigationCode.GAMEPAD_A,KeyCode.ENTER,"panel_common_apply");
            InputFeedbackManager.appendButtonById(GwintInputFeedback.cancel,NavigationCode.GAMEPAD_B,KeyCode.ESCAPE,"panel_common_cancel");
            InputFeedbackManager.appendButtonById(GwintInputFeedback.navigate,NavigationCode.GAMEPAD_L3,-1,"panel_button_common_navigation");
         }
      }
      
      protected function state_update_ChoosingHandler() : void
      {
         this.on_state_about_to_update();
      }
      
      protected function state_begin_WaitConfirmation() : void
      {
         this._cardConfirmation = false;
         if(this._currentZoomedHolder == null)
         {
            this.resetToDefaultButtons();
            InputFeedbackManager.appendButtonById(GwintInputFeedback.cancel,NavigationCode.GAMEPAD_B,KeyCode.ESCAPE,"panel_common_cancel");
            InputFeedbackManager.appendButtonById(GwintInputFeedback.apply,NavigationCode.GAMEPAD_A,KeyCode.ENTER,"panel_common_apply");
         }
      }
      
      protected function state_update_WaitConfirmation() : void
      {
         this.on_state_about_to_update();
         if(this._cardConfirmation && Boolean(_transactionCard))
         {
            this._cardConfirmation = false;
            _decidedCardTransaction = new CardTransaction();
            _decidedCardTransaction.targetPlayerID = playerID;
            _decidedCardTransaction.sourceCardInstanceRef = CardManager.getInstance().getCardInstance(_transactionCard.instanceId);
            _stateMachine.ChangeState("ApplyingCard");
         }
      }
      
      override protected function cardEffectApplying() : Boolean
      {
         return super.cardEffectApplying() || this.mcChoiceDialog.visible;
      }
      
      override protected function state_begin_ApplyingCard() : void
      {
         super.state_begin_ApplyingCard();
         _boardRenderer.activateAllHolders(true);
         if(Boolean(this._handHolder) && _boardRenderer.getSelectedCardHolder() != this._handHolder)
         {
            _boardRenderer.selectCardHolderAdv(this._handHolder);
         }
      }
      
      override protected function state_update_ApplyingCard() : void
      {
         this.on_state_about_to_update();
         if(!CardTweenManager.getInstance().isAnyCardMoving() && !gameFlowControllerRef.mcMessageQueue.ShowingMessage() && !CardFXManager.getInstance().isPlayingAnyCardFX() && !this.mcChoiceDialog.visible)
         {
            _turnOver = true;
            _stateMachine.ChangeState("Idle");
         }
      }
      
      protected function handleCardSelected(event:GwintCardEvent) : void
      {
         var transCardInstance:CardInstance = null;
         var targetCardInstance:CardInstance = null;
         if(this._currentZoomedHolder != null || this.mcChoiceDialog.visible)
         {
            return;
         }
         trace("GFX handleCardSelected <",_stateMachine.currentState,"> ",event.cardSlot);
         if(event.cardSlot)
         {
            switch(_stateMachine.currentState)
            {
               case "ChoosingTargetCard":
                  transCardInstance = CardManager.getInstance().getCardInstance(_transactionCard.instanceId);
                  targetCardInstance = CardManager.getInstance().getCardInstance(event.cardSlot.instanceId);
                  if(transCardInstance.canBeCastOn(targetCardInstance))
                  {
                     InputFeedbackManager.appendButtonById(GwintInputFeedback.apply,NavigationCode.GAMEPAD_A,KeyCode.ENTER,"panel_common_apply");
                     break;
                  }
                  InputFeedbackManager.removeButtonById(GwintInputFeedback.apply);
                  break;
            }
         }
         if(_boardRenderer.getSelectedCard() != null && cardZoomEnabled && !this.mcChoiceDialog.visible && _stateMachine.currentState != "ChoosingTargetCard" && _stateMachine.currentState != "ChoosingHandler")
         {
            InputFeedbackManager.appendButtonById(GwintInputFeedback.zoomCard,NavigationCode.GAMEPAD_R2,KeyCode.RIGHT_MOUSE,"panel_button_common_zoom");
         }
         else
         {
            InputFeedbackManager.removeButtonById(GwintInputFeedback.zoomCard);
         }
      }
      
      protected function handleHolderSelected(event:GwintHolderEvent) : void
      {
         var curHolder:GwintCardHolder = null;
         var leaderCard:CardLeaderInstance = null;
         if(this._currentZoomedHolder != null || this.mcChoiceDialog.visible)
         {
            return;
         }
         trace("GFX handleHolderSelected <",_stateMachine.currentState,"> ",_transactionCard,event.cardHolder);
         switch(_stateMachine.currentState)
         {
            case "ChoosingHandler":
               if(_transactionCard)
               {
                  InputFeedbackManager.appendButtonById(GwintInputFeedback.apply,NavigationCode.GAMEPAD_A,KeyCode.ENTER,"panel_common_apply");
               }
               break;
            case "ChoosingCard":
               curHolder = event.cardHolder;
               leaderCard = CardManager.getInstance().getCardLeader(playerID);
               if(curHolder.cardSlotsList.length > 0 && (curHolder.cardHolderID == CardManager.CARD_LIST_LOC_HAND || curHolder.cardHolderID == CardManager.CARD_LIST_LOC_LEADER && curHolder.playerID == CardManager.PLAYER_1 && leaderCard && leaderCard.canBeUsed))
               {
                  InputFeedbackManager.appendButtonById(GwintInputFeedback.apply,NavigationCode.GAMEPAD_A,KeyCode.ENTER,"panel_button_common_select");
               }
               else
               {
                  InputFeedbackManager.removeButtonById(GwintInputFeedback.apply);
               }
               if(_boardRenderer.getSelectedCard() != null && cardZoomEnabled && !this.mcChoiceDialog.visible)
               {
                  InputFeedbackManager.appendButtonById(GwintInputFeedback.zoomCard,NavigationCode.GAMEPAD_R2,KeyCode.RIGHT_MOUSE,"panel_button_common_zoom");
               }
               else
               {
                  InputFeedbackManager.removeButtonById(GwintInputFeedback.zoomCard);
               }
         }
      }
      
      protected function handleCardChosen(event:GwintCardEvent) : void
      {
         var curHolder:GwintCardHolder = null;
         var transCardInstance:CardInstance = null;
         var targetCardInstance:CardInstance = null;
         var leaderCard:CardLeaderInstance = null;
         if(this._currentZoomedHolder != null)
         {
            return;
         }
         trace("GFX handleCardChosen <",_stateMachine.currentState,"> ",event.cardSlot);
         if(event.cardSlot)
         {
            switch(_stateMachine.currentState)
            {
               case "ChoosingCard":
                  curHolder = event.cardHolder;
                  if(curHolder.cardHolderID == CardManager.CARD_LIST_LOC_HAND || curHolder.cardHolderID == CardManager.CARD_LIST_LOC_LEADER && curHolder.playerID == CardManager.PLAYER_1)
                  {
                     leaderCard = event.cardSlot.cardInstance as CardLeaderInstance;
                     if(leaderCard == null || leaderCard.canBeUsed)
                     {
                        startCardTransaction(event.cardSlot.instanceId);
                     }
                  }
                  break;
               case "ChoosingTargetCard":
                  transCardInstance = CardManager.getInstance().getCardInstance(_transactionCard.instanceId);
                  targetCardInstance = CardManager.getInstance().getCardInstance(event.cardSlot.instanceId);
                  if(transCardInstance.canBeCastOn(targetCardInstance))
                  {
                     _decidedCardTransaction = new CardTransaction();
                     _decidedCardTransaction.targetPlayerID = playerID;
                     _decidedCardTransaction.targetSlotID = CardManager.CARD_LIST_LOC_INVALID;
                     _decidedCardTransaction.targetCardInstanceRef = targetCardInstance;
                     _decidedCardTransaction.sourceCardInstanceRef = transCardInstance;
                     _stateMachine.ChangeState("ApplyingCard");
                  }
            }
         }
      }
      
      protected function handleHolderChosen(event:GwintHolderEvent) : void
      {
         var transCardInstance:CardInstance = null;
         trace("GFX handleHolderChosen <",_stateMachine.currentState,"> ",_transactionCard,event.cardHolder);
         if(Boolean(_transactionCard) && _stateMachine.currentState == "ChoosingHandler")
         {
            transCardInstance = CardManager.getInstance().getCardInstance(_transactionCard.instanceId);
            _decidedCardTransaction = new CardTransaction();
            _decidedCardTransaction.targetPlayerID = event.cardHolder.playerID;
            _decidedCardTransaction.targetSlotID = event.cardHolder.cardHolderID;
            _decidedCardTransaction.targetCardInstanceRef = null;
            _decidedCardTransaction.sourceCardInstanceRef = transCardInstance;
            _stateMachine.ChangeState("ApplyingCard");
         }
      }
      
      override public function handleUserInput(event:InputEvent) : void
      {
         if(!inputEnabled)
         {
            return;
         }
         if(_boardRenderer && this._currentZoomedHolder == null && (_transactionCard == null || CardManager.getInstance().getCardLeader(playerID) != _transactionCard.cardInstance))
         {
            _boardRenderer.handleInputPreset(event);
         }
         if(!event.handled)
         {
            this.processUserInput(event);
         }
      }
      
      override public function handleMouseMove(event:MouseEvent) : void
      {
         if(!inputEnabled)
         {
            return;
         }
         if(_boardRenderer && this._currentZoomedHolder == null && (_transactionCard == null || CardManager.getInstance().getCardLeader(playerID) != _transactionCard.cardInstance))
         {
            _boardRenderer.handleMouseMove(event);
         }
      }
      
      override public function handleMouseClick(event:MouseEvent) : void
      {
         var superMouseEvent:MouseEventEx = null;
         if(Boolean(_boardRenderer) && this._currentZoomedHolder == null)
         {
            superMouseEvent = event as MouseEventEx;
            if(superMouseEvent.buttonIdx == MouseEventEx.LEFT_BUTTON)
            {
               if(_stateMachine.currentState == "WaitConfirmation")
               {
                  this._cardConfirmation = true;
               }
               else
               {
                  _boardRenderer.handleLeftClick(event);
               }
            }
            else if(superMouseEvent.buttonIdx == MouseEventEx.RIGHT_BUTTON && !CardTweenManager.getInstance().isAnyCardMoving())
            {
               if(_transactionCard == null)
               {
                  if(_stateMachine.currentState == "Idle" || _stateMachine.currentState == "ChoosingCard")
                  {
                     if(this._currentZoomedHolder == null)
                     {
                        this.tryStartZoom();
                        if(this.mcChoiceDialog.visible)
                        {
                           this.mcChoiceDialog.ignoreNextRightClick = true;
                        }
                     }
                     else
                     {
                        this.closeZoomCB(-1);
                        event.stopImmediatePropagation();
                     }
                  }
               }
               else
               {
                  _boardRenderer.activateAllHolders(true);
                  declineCardTransaction();
                  _stateMachine.ChangeState("ChoosingCard");
               }
            }
         }
      }
      
      protected function processUserInput(event:InputEvent) : void
      {
         var details:InputDetails = event.details;
         var keyUp:* = details.value == InputValue.KEY_UP;
         var navCommand:String = details.navEquivalent;
         if(CardTweenManager.getInstance().isAnyCardMoving())
         {
            return;
         }
         if(keyUp && !event.handled)
         {
            if(this._currentZoomedHolder)
            {
               if(navCommand == NavigationCode.GAMEPAD_R2)
               {
                  this.closeZoomCB();
               }
            }
            else
            {
               switch(navCommand)
               {
                  case NavigationCode.GAMEPAD_A:
                     if(_stateMachine.currentState == "WaitConfirmation" && details.code != KeyCode.SPACE)
                     {
                        this._cardConfirmation = true;
                     }
                     break;
                  case NavigationCode.GAMEPAD_B:
                     if(_transactionCard)
                     {
                        _boardRenderer.activateAllHolders(true);
                        _boardRenderer.selectCard(_transactionCard);
                        declineCardTransaction();
                        event.handled = true;
                        _stateMachine.ChangeState("ChoosingCard");
                     }
                     break;
                  case NavigationCode.GAMEPAD_X:
                     this.tryPutLeaderInTransaction();
                     break;
                  case NavigationCode.GAMEPAD_R2:
                     if(_stateMachine.currentState == "Idle" || _stateMachine.currentState == "ChoosingCard")
                     {
                        this.tryStartZoom();
                     }
               }
               switch(details.code)
               {
                  case KeyCode.X:
                     this.tryPutLeaderInTransaction();
               }
            }
            if(!event.handled && !this.mcChoiceDialog.visible && details.code == KeyCode.ESCAPE)
            {
               GwintGameMenu.mSingleton.tryQuitGame();
            }
         }
      }
      
      protected function tryPutLeaderInTransaction() : void
      {
         var leaderCard:CardLeaderInstance = null;
         if(_stateMachine.currentState == "ChoosingCard" && _transactionCard == null)
         {
            leaderCard = CardManager.getInstance().getCardLeader(playerID);
            if(!leaderCard)
            {
               throw new Error("GFX [ERROR] - The leader card for player: " + playerID + " is not the correct type");
            }
            if(leaderCard.canBeUsed)
            {
               startCardTransaction(leaderCard.instanceId);
            }
         }
      }
      
      protected function resetToDefaultButtons() : void
      {
         InputFeedbackManager.cleanupButtons();
         InputFeedbackManager.appendButtonById(GwintInputFeedback.quitGame,NavigationCode.START,KeyCode.Q,"gwint_pass_game");
         if(_stateMachine.currentState == "ChoosingCard")
         {
            InputFeedbackManager.appendButtonById(GwintInputFeedback.endTurn,NavigationCode.GAMEPAD_Y,-1,"qwint_skip_turn");
            if(this._skipButton)
            {
               this._skipButton.visible = true;
            }
         }
      }
      
      protected function tryStartZoom() : void
      {
         var cardInstanceList:Vector.<CardInstance> = null;
         var i:int = 0;
         if(Boolean(this._currentZoomedHolder) || !cardZoomEnabled)
         {
            return;
         }
         if(Boolean(_boardRenderer.getSelectedCardHolder()) && _boardRenderer.getSelectedCardHolder().cardSlotsList.length > 0)
         {
            this._currentZoomedHolder = _boardRenderer.getSelectedCardHolder();
         }
         if(this._currentZoomedHolder.cardHolderID == CardManager.CARD_LIST_LOC_HAND && this._currentZoomedHolder.playerID == CardManager.PLAYER_2)
         {
            this._currentZoomedHolder = null;
            return;
         }
         if(this._currentZoomedHolder)
         {
            if(this._currentZoomedHolder.selectedCardIdx == -1)
            {
               return;
            }
            GwintGameMenu.mSingleton.playSound("gui_gwint_preview_card");
            InputFeedbackManager.cleanupButtons();
            InputFeedbackManager.appendButtonById(GwintInputFeedback.quitGame,NavigationCode.START,KeyCode.Q,"gwint_pass_game");
            InputFeedbackManager.appendButtonById(GwintInputFeedback.navigate,NavigationCode.GAMEPAD_L3,-1,"panel_button_common_navigation");
            InputFeedbackManager.appendButtonById(GwintInputFeedback.zoomCard,NavigationCode.GAMEPAD_R2,KeyCode.RIGHT_MOUSE,"panel_button_common_close");
            if(this._skipButton)
            {
               this._skipButton.visible = false;
            }
            cardInstanceList = new Vector.<CardInstance>();
            for(i = 0; i < this._currentZoomedHolder.cardSlotsList.length; i++)
            {
               cardInstanceList.push(this._currentZoomedHolder.cardSlotsList[i].cardInstance);
            }
            if(_stateMachine.currentState == "ChoosingCard" && (this._currentZoomedHolder.cardHolderID == CardManager.CARD_LIST_LOC_HAND && this._currentZoomedHolder.playerID == CardManager.PLAYER_1 || this._currentZoomedHolder.cardHolderID == CardManager.CARD_LIST_LOC_LEADER && this._currentZoomedHolder.playerID == CardManager.PLAYER_1 && CardManager.getInstance().getCardLeader(CardManager.PLAYER_1).canBeUsed))
            {
               this.mcChoiceDialog.showDialogCardInstances(cardInstanceList,this.zoomCardToTransaction,this.closeZoomCB,"");
            }
            else
            {
               this.mcChoiceDialog.showDialogCardInstances(cardInstanceList,null,this.closeZoomCB,"");
            }
            this.mcChoiceDialog.cardsCarousel.validateNow();
            this.mcChoiceDialog.cardsCarousel.addEventListener(ListEvent.INDEX_CHANGE,this.onCarouselSelectionChanged,false,0,true);
            if(this._currentZoomedHolder.selectedCardIdx != -1)
            {
               this.mcChoiceDialog.cardsCarousel.selectedIndex = this._currentZoomedHolder.selectedCardIdx;
            }
         }
      }
      
      protected function zoomCardToTransaction(instanceId:int = 0) : void
      {
         if(instanceId != -1)
         {
            startCardTransaction(instanceId);
         }
         this.closeZoomCB(instanceId);
      }
      
      protected function closeZoomCB(instanceId:int = 0) : void
      {
         var leaderCard:CardLeaderInstance = null;
         var currentHolder:GwintCardHolder = null;
         if(this._currentZoomedHolder)
         {
            GwintGameMenu.mSingleton.playSound("gui_gwint_preview_card");
            if(this._skipButton)
            {
               this._skipButton.visible = false;
            }
            if(this.mcChoiceDialog.visible)
            {
               this.mcChoiceDialog.hideDialog();
            }
            this.resetToDefaultButtons();
            leaderCard = CardManager.getInstance().getCardLeader(playerID);
            currentHolder = _boardRenderer.getSelectedCardHolder();
            if(_stateMachine.currentState == "ChoosingCard" && (this._currentZoomedHolder.cardHolderID == CardManager.CARD_LIST_LOC_HAND || this._currentZoomedHolder.cardHolderID == CardManager.CARD_LIST_LOC_LEADER && this._currentZoomedHolder.playerID == CardManager.PLAYER_1 && leaderCard && leaderCard.canBeUsed))
            {
               InputFeedbackManager.appendButtonById(GwintInputFeedback.apply,NavigationCode.GAMEPAD_A,KeyCode.ENTER,"panel_button_common_select");
            }
            InputFeedbackManager.appendButtonById(GwintInputFeedback.zoomCard,NavigationCode.GAMEPAD_R2,KeyCode.RIGHT_MOUSE,"panel_button_common_zoom");
            if(Boolean(leaderCard) && leaderCard.canBeUsed)
            {
               InputFeedbackManager.appendButtonById(GwintInputFeedback.leaderCard,NavigationCode.GAMEPAD_X,KeyCode.X,"gwint_use_leader");
            }
            this.mcChoiceDialog.cardsCarousel.removeEventListener(ListEvent.INDEX_CHANGE,this.onCarouselSelectionChanged,false);
            InputFeedbackManager.appendButtonById(GwintInputFeedback.navigate,NavigationCode.GAMEPAD_L3,-1,"panel_button_common_navigation");
            this._currentZoomedHolder = null;
         }
      }
      
      public function attachToTutorialCarouselMessage() : void
      {
         if(GwintTutorial.mSingleton)
         {
            GwintTutorial.mSingleton.hideCarouselCB = this.closeZoomCB;
         }
      }
      
      protected function onCarouselSelectionChanged(event:ListEvent) : void
      {
         if(this._currentZoomedHolder)
         {
            this._currentZoomedHolder.selectedCardIdx = event.index;
         }
      }
   }
}
