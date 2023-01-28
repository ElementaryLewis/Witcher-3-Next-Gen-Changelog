package red.game.witcher3.menus.gwint
{
   import flash.events.MouseEvent;
   import red.game.witcher3.utils.FiniteStateMachine;
   import scaleform.clik.core.UIComponent;
   import scaleform.clik.events.InputEvent;
   
   public class BasePlayerController extends UIComponent
   {
      
      public static const ROUND_PLAYER_STATUS_ACTIVE:int = 1;
      
      public static const ROUND_PLAYER_STATUS_DONE:int = 2;
       
      
      public var gameFlowControllerRef:GwintGameFlowController;
      
      public var playerID:int;
      
      public var opponentID:int;
      
      protected var isAI:Boolean = false;
      
      protected var _stateMachine:FiniteStateMachine;
      
      protected var _decidedCardTransaction:CardTransaction;
      
      public var inputEnabled:Boolean = true;
      
      protected var _boardRenderer:GwintBoardRenderer;
      
      protected var _playerRenderer:GwintPlayerRenderer;
      
      protected var _cardZoomEnabled:Boolean = true;
      
      private var _currentRoundStatus:int = 1;
      
      protected var _turnOver:Boolean;
      
      protected var _transactionCard:CardSlot;
      
      public function BasePlayerController()
      {
         super();
         this._stateMachine = new FiniteStateMachine();
      }
      
      public function get boardRenderer() : GwintBoardRenderer
      {
         return this._boardRenderer;
      }
      
      public function set boardRenderer(value:GwintBoardRenderer) : void
      {
         this._boardRenderer = value;
      }
      
      public function get playerRenderer() : GwintPlayerRenderer
      {
         return this._playerRenderer;
      }
      
      public function set playerRenderer(value:GwintPlayerRenderer) : void
      {
         this._playerRenderer = value;
         var deckDefinition:GwintDeck = CardManager.getInstance().playerDeckDefinitions[this._playerRenderer.playerID];
         this._playerRenderer.txtFactionName.text = deckDefinition.getFactionNameString();
         this._playerRenderer.mcFactionIcon.gotoAndStop(deckDefinition.getDeckKingTemplate().getFactionString());
         this._playerRenderer.numCardsInHand = 0;
      }
      
      public function set cardZoomEnabled(value:Boolean) : *
      {
         this._cardZoomEnabled = value;
      }
      
      public function get cardZoomEnabled() : Boolean
      {
         return this._cardZoomEnabled;
      }
      
      public function get currentRoundStatus() : int
      {
         if(CardManager.getInstance().getCardInstanceList(CardManager.CARD_LIST_LOC_HAND,this.playerID).length == 0 && !CardManager.getInstance().getCardLeader(this.playerID).canBeUsed)
         {
            return ROUND_PLAYER_STATUS_DONE;
         }
         return this._currentRoundStatus;
      }
      
      public function set currentRoundStatus(value:int) : void
      {
         this._currentRoundStatus = value;
         if(this._playerRenderer)
         {
            this._playerRenderer.showPassed(this._currentRoundStatus == ROUND_PLAYER_STATUS_DONE);
         }
      }
      
      public function set transactionCard(slot:CardSlot) : void
      {
         if(this._transactionCard)
         {
            this._transactionCard.cardState = CardSlot.STATE_BOARD;
         }
         this._transactionCard = slot;
         if(this._boardRenderer)
         {
            this._boardRenderer.updateTransactionCardTooltip(slot);
         }
         if(this._transactionCard)
         {
            this._transactionCard.cardState = CardSlot.STATE_CAROUSEL;
         }
      }
      
      public function get turnOver() : Boolean
      {
         return this._turnOver && !this._transactionCard;
      }
      
      public function startTurn() : void
      {
         if(this.currentRoundStatus == ROUND_PLAYER_STATUS_DONE)
         {
            return;
         }
         this._turnOver = false;
      }
      
      public function skipTurn() : void
      {
      }
      
      public function resetCurrentRoundStatus() : void
      {
         if(CardManager.getInstance().getCardInstanceList(CardManager.CARD_LIST_LOC_HAND,this.playerID).length > 0)
         {
            this.currentRoundStatus = ROUND_PLAYER_STATUS_ACTIVE;
         }
      }
      
      protected function startCardTransaction(cardInstanceId:int) : void
      {
         var targetCard:CardSlot = null;
         var targetX:Number = NaN;
         var targetY:Number = NaN;
         if(this.boardRenderer)
         {
            targetCard = this.boardRenderer.getCardSlotById(cardInstanceId);
            targetX = this.boardRenderer.mcTransitionAnchor.x;
            targetY = this.boardRenderer.mcTransitionAnchor.y;
            CardTweenManager.getInstance().storePosition(targetCard);
            CardTweenManager.getInstance().tweenTo(targetCard,targetX,targetY);
            this.transactionCard = targetCard;
         }
      }
      
      protected function declineCardTransaction() : void
      {
         if(this._transactionCard)
         {
            CardTweenManager.getInstance().restorePosition(this._transactionCard,true);
            this.transactionCard = null;
         }
      }
      
      protected function transferTransactionCardToDestination(slotID:int, playerID:int) : void
      {
         if(this._transactionCard)
         {
            CardManager.getInstance().addCardInstanceIDToList(this._transactionCard.instanceId,slotID,playerID);
            this.transactionCard = null;
         }
      }
      
      protected function applyTransactionCardToCardInstance(cardInstance:CardInstance) : void
      {
         CardManager.getInstance().replaceCardInstanceIDs(this._transactionCard.instanceId,cardInstance.instanceId);
         this.transactionCard = null;
      }
      
      protected function applyGlobalEffectTransactionCard() : void
      {
         if(this._transactionCard)
         {
            CardManager.getInstance().applyCardEffectsID(this._transactionCard.instanceId);
            CardManager.getInstance().sendToGraveyardID(this._transactionCard.instanceId);
            this.transactionCard = null;
         }
      }
      
      protected function state_begin_ApplyingCard() : void
      {
         var leaderCard:CardLeaderInstance = this._decidedCardTransaction.sourceCardInstanceRef as CardLeaderInstance;
         if(leaderCard)
         {
            leaderCard.ApplyLeaderAbility(this.isAI);
            CardTweenManager.getInstance().restorePosition(this._transactionCard,true);
            this.transactionCard = null;
         }
         else if(this._decidedCardTransaction.targetSlotID != CardManager.CARD_LIST_LOC_INVALID)
         {
            this.transferTransactionCardToDestination(this._decidedCardTransaction.targetSlotID,this._decidedCardTransaction.targetPlayerID);
         }
         else if(this._decidedCardTransaction.targetCardInstanceRef)
         {
            this.applyTransactionCardToCardInstance(this._decidedCardTransaction.targetCardInstanceRef);
         }
         else if(this._decidedCardTransaction.sourceCardInstanceRef.templateRef.isType(CardTemplate.CardType_Global_Effect))
         {
            this.applyGlobalEffectTransactionCard();
         }
         else
         {
            this.declineCardTransaction();
         }
      }
      
      protected function cardEffectApplying() : Boolean
      {
         return CardTweenManager.getInstance().isAnyCardMoving() || this.gameFlowControllerRef.mcMessageQueue.ShowingMessage() || CardFXManager.getInstance().isPlayingAnyCardFX();
      }
      
      protected function state_update_ApplyingCard() : void
      {
         if(!this.cardEffectApplying())
         {
            if(this.gameFlowControllerRef.playerControllers[this.opponentID].currentRoundStatus == ROUND_PLAYER_STATUS_DONE)
            {
               this._stateMachine.ChangeState("ChoosingMove");
            }
            else
            {
               this._stateMachine.ChangeState("Idle");
            }
         }
      }
      
      public function handleUserInput(event:InputEvent) : void
      {
      }
      
      public function handleMouseMove(event:MouseEvent) : void
      {
      }
      
      public function handleMouseClick(event:MouseEvent) : void
      {
      }
   }
}
