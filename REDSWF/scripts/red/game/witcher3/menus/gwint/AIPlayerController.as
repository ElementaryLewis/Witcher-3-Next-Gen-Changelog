package red.game.witcher3.menus.gwint
{
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class AIPlayerController extends BasePlayerController
   {
      
      protected static const TACTIC_NONE:int = 0;
      
      protected static const TACTIC_SPY_DUMMY_BEST_THEN_PASS:int = 1;
      
      protected static const TACTIC_MINIMIZE_LOSS:int = 1;
      
      protected static const TACTIC_MINIMIZE_WIN:int = 2;
      
      protected static const TACTIC_MAXIMIZE_WIN:int = 3;
      
      protected static const TACTIC_AVERAGE_WIN:int = 4;
      
      protected static const TACTIC_MINIMAL_WIN:int = 5;
      
      protected static const TACTIC_JUST_WAIT:int = 6;
      
      protected static const TACTIC_PASS:int = 7;
      
      protected static const TACTIC_WAIT_DUMMY:int = 8;
      
      protected static const TACTIC_SPY:int = 9;
      
      protected static const TACTIC_BESERKER:int = 10;
      
      protected static const TACTIC_PLAY_SUICIDE:int = 11;
      
      private static const SortType_None:int = 0;
      
      private static const SortType_StrategicValue:int = 1;
      
      private static const SortType_PowerChange:int = 2;
       
      
      protected var attitude:int;
      
      protected var chances:int;
      
      private var berserkerSelectedRowType:int;
      
      private var berserkerMushroomPlaced:Boolean;
      
      protected var waitingForTimer:Boolean;
      
      protected var waitingTimer:Timer;
      
      protected var _currentRoundCritical:Boolean = false;
      
      public function AIPlayerController()
      {
         super();
         isAI = true;
         _stateMachine.AddState("Idle",this.state_begin_Idle,null,this.state_end_Idle);
         _stateMachine.AddState("ChoosingMove",this.state_begin_ChoseMove,this.state_update_ChooseMove,null);
         _stateMachine.AddState("SendingCardToTransaction",this.state_begin_SendingCard,this.state_update_SendingCard,null);
         _stateMachine.AddState("DelayBetweenActions",this.state_begin_DelayAction,this.state_update_DelayAction,null);
         _stateMachine.AddState("ApplyingCard",state_begin_ApplyingCard,state_update_ApplyingCard,null);
      }
      
      override public function startTurn() : void
      {
         if(currentRoundStatus == BasePlayerController.ROUND_PLAYER_STATUS_DONE)
         {
            return;
         }
         super.startTurn();
         _stateMachine.ChangeState("ChoosingMove");
      }
      
      protected function state_begin_Idle() : void
      {
         if(this.attitude == TACTIC_PASS)
         {
            currentRoundStatus = BasePlayerController.ROUND_PLAYER_STATUS_DONE;
         }
         _turnOver = true;
         if(CardManager.getInstance().getCardInstanceList(CardManager.CARD_LIST_LOC_HAND,playerID).length == 0 && CardManager.getInstance().getCardLeader(playerID) != null && !CardManager.getInstance().getCardLeader(playerID).canBeUsed)
         {
            currentRoundStatus = BasePlayerController.ROUND_PLAYER_STATUS_DONE;
         }
         if(_boardRenderer)
         {
            _boardRenderer.getCardHolder(CardManager.CARD_LIST_LOC_LEADER,playerID).updateLeaderStatus(false);
         }
      }
      
      protected function state_end_Idle() : void
      {
         if(_boardRenderer)
         {
            _boardRenderer.getCardHolder(CardManager.CARD_LIST_LOC_LEADER,playerID).updateLeaderStatus(true);
         }
      }
      
      protected function attitudeToString(_attitude:int) : String
      {
         switch(_attitude)
         {
            case TACTIC_NONE:
               return "NONE - ERROR";
            case TACTIC_SPY_DUMMY_BEST_THEN_PASS:
               return "DUMMY BETS THEN PASS";
            case TACTIC_MINIMIZE_LOSS:
               return "MINIMIZE LOSS";
            case TACTIC_MINIMIZE_WIN:
               return "MINIMIZE WIN";
            case TACTIC_MAXIMIZE_WIN:
               return "MAXIMIZE WIN";
            case TACTIC_AVERAGE_WIN:
               return "AVERAGE WIN";
            case TACTIC_MINIMAL_WIN:
               return "MINIMAL WIN";
            case TACTIC_JUST_WAIT:
               return "JUST WAIT";
            case TACTIC_PASS:
               return "PASS";
            case TACTIC_WAIT_DUMMY:
               return "WAIT DUMMY";
            case TACTIC_SPY:
               return "SPIES";
            case TACTIC_BESERKER:
               return "BESERKER";
            case TACTIC_PLAY_SUICIDE:
               return "SUICIDE";
            default:
               return _attitude.toString();
         }
      }
      
      protected function state_begin_ChoseMove() : void
      {
         var hand:Vector.<CardInstance> = null;
         var numShrooms:int = 0;
         var numZerkers:int = 0;
         var rowType:int = 0;
         var i:int = 0;
         var template:CardTemplate = null;
         CardManager.getInstance().CalculateCardPowerPotentials();
         this.ChooseAttitude();
         var attitudeName:String = this.attitudeToString(this.attitude);
         trace("GFX -#AI# ai has decided to use the following attitude:" + attitudeName);
         _decidedCardTransaction = this.decideWhichCardToPlay();
         if(_decidedCardTransaction == null && this.attitude != TACTIC_PASS)
         {
            this.attitude = TACTIC_PASS;
         }
         else if(_decidedCardTransaction != null && _decidedCardTransaction.sourceCardInstanceRef != null)
         {
            if(this.attitude != TACTIC_BESERKER && _decidedCardTransaction.sourceCardInstanceRef.templateRef != null)
            {
               hand = CardManager.getInstance().getCardInstanceList(CardManager.CARD_LIST_LOC_HAND,playerID);
               numShrooms = 0;
               numZerkers = 0;
               trace("GFX +--------------------------------------------------------------");
               trace("GFX | Evaluating chosen card + hand for Berserker Tactic potential");
               switch(_decidedCardTransaction.targetSlotID)
               {
                  case CardManager.CARD_LIST_LOC_MELEE:
                     rowType = int(CardTemplate.CardType_Melee);
                     trace("GFX | Selected Card being played on row: Melee");
                     break;
                  case CardManager.CARD_LIST_LOC_RANGED:
                     rowType = int(CardTemplate.CardType_Ranged);
                     trace("GFX | Selected Card being played on row: Ranged");
                     break;
                  case CardManager.CARD_LIST_LOC_SEIGE:
                     rowType = int(CardTemplate.CardType_Siege);
                     trace("GFX | Selected Card being played on row: Siege");
                     break;
                  default:
                     trace("GFX | Selected Card being played on row: !! UNKNOWN !!");
               }
               trace("GFX |");
               for(i = 0; i < hand.length; i++)
               {
                  template = hand[i].templateRef;
                  if(template.isType(rowType))
                  {
                     if(template.hasEffect(CardTemplate.CardEffect_Morph))
                     {
                        numZerkers++;
                     }
                     if(template.hasEffect(CardTemplate.CardEffect_Mushroom))
                     {
                        numShrooms++;
                     }
                  }
               }
               trace("GFX | Zerkers [" + numZerkers + "]");
               trace("GFX | Shrooms [" + numShrooms + "]");
               if(Boolean(numZerkers) && Boolean(numShrooms) && (_decidedCardTransaction.sourceCardInstanceRef.templateRef.hasEffect(CardTemplate.CardEffect_Morph) || _decidedCardTransaction.sourceCardInstanceRef.templateRef.hasEffect(CardTemplate.CardEffect_Mushroom)))
               {
                  trace("GFX |");
                  this.attitude = TACTIC_BESERKER;
                  this.berserkerSelectedRowType = rowType;
                  this.berserkerMushroomPlaced = _decidedCardTransaction.sourceCardInstanceRef.templateRef.hasEffect(CardTemplate.CardEffect_Mushroom);
                  switch(this.berserkerSelectedRowType)
                  {
                     case CardTemplate.CardType_Melee:
                        trace("GFX | Activating Berserker Tactic on row: Melee");
                        break;
                     case CardTemplate.CardType_Ranged:
                        trace("GFX | Activating Berserker Tactic on row: Ranged");
                        break;
                     case CardTemplate.CardType_Siege:
                        trace("GFX | Activating Berserker Tactic on row: Siege");
                  }
               }
               trace("GFX +--------------------------------------------------------------");
            }
         }
         else if(this._currentRoundCritical && _decidedCardTransaction != null && !_decidedCardTransaction.sourceCardInstanceRef.templateRef.hasEffect(CardTemplate.CardEffect_UnsummonDummy) && _decidedCardTransaction.powerChangeResult < 0 && CardManager.getInstance().getAllCreaturesInHand(playerID).length == 0)
         {
            _decidedCardTransaction = null;
            this.attitude = TACTIC_PASS;
         }
         trace("GFX -#AI# the ai decided on the following transaction: " + _decidedCardTransaction);
      }
      
      protected function state_update_ChooseMove() : void
      {
         if(this.attitude == TACTIC_PASS || _decidedCardTransaction == null)
         {
            _stateMachine.ChangeState("Idle");
            if(this.attitude != TACTIC_PASS)
            {
               trace("GFX -#AI#--------------- WARNING ---------- AI is passing since chosen tactic was unable to find a transaction is liked");
            }
            this.attitude = TACTIC_PASS;
         }
         else
         {
            _stateMachine.ChangeState("SendingCardToTransaction");
         }
      }
      
      protected function state_begin_SendingCard() : void
      {
         trace("GFX -#AI# AI is sending the following card into transaction: ",_decidedCardTransaction.sourceCardInstanceRef);
         startCardTransaction(_decidedCardTransaction.sourceCardInstanceRef.instanceId);
      }
      
      protected function state_update_SendingCard() : void
      {
         if(!CardTweenManager.getInstance().isAnyCardMoving())
         {
            _stateMachine.ChangeState("DelayBetweenActions");
         }
      }
      
      protected function state_begin_DelayAction() : void
      {
         this.waitingForTimer = true;
         this.waitingTimer = new Timer(1200,1);
         this.waitingTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onWaitingTimerEnded,false,0,true);
         this.waitingTimer.start();
      }
      
      protected function state_update_DelayAction() : void
      {
         if(!this.waitingForTimer)
         {
            _stateMachine.ChangeState("ApplyingCard");
         }
      }
      
      protected function onWaitingTimerEnded(event:TimerEvent) : void
      {
         this.waitingForTimer = false;
         this.waitingTimer = null;
      }
      
      private function ChooseAttitude() : void
      {
         var i:int = 0;
         var scoreIt:int = 0;
         var roundWinner:int = 0;
         var beserkersOnBoard:Vector.<CardInstance> = null;
         var beserkersInHand:Vector.<CardInstance> = null;
         var numCardsInHandToPerf:Number = NaN;
         var dummyInstance:* = undefined;
         var cardManagerRef:CardManager = CardManager.getInstance();
         var cardsInHand:Vector.<CardInstance> = new Vector.<CardInstance>();
         cardsInHand = cardManagerRef.getCardInstanceList(CardManager.CARD_LIST_LOC_HAND,playerID);
         if(cardManagerRef.getCardInstanceList(CardManager.CARD_LIST_LOC_HAND,playerID).length == 0)
         {
            this.attitude = TACTIC_PASS;
            return;
         }
         var hasWon:Boolean = false;
         var opponentHasWon:Boolean = false;
         var numUnitsInHand:int = 0;
         var dummyCount:int = 0;
         var spyCount:int = 0;
         for(scoreIt = 0; scoreIt < cardManagerRef.roundResults.length; scoreIt++)
         {
            if(cardManagerRef.roundResults[scoreIt].played)
            {
               roundWinner = cardManagerRef.roundResults[scoreIt].winningPlayer;
               if(roundWinner == playerID || roundWinner == CardManager.PLAYER_INVALID)
               {
                  hasWon = true;
               }
               if(roundWinner == opponentID || roundWinner == CardManager.PLAYER_INVALID)
               {
                  opponentHasWon = true;
               }
            }
         }
         this._currentRoundCritical = opponentHasWon;
         for(i = 0; i < cardsInHand.length; i++)
         {
            if(cardsInHand[i].templateRef.isType(CardTemplate.CardType_Creature))
            {
               numUnitsInHand++;
            }
         }
         var playerCardsInHand:int = int(cardManagerRef.getCardInstanceList(CardManager.CARD_LIST_LOC_HAND,playerID).length);
         var opponentCardsInHand:int = int(cardManagerRef.getCardInstanceList(CardManager.CARD_LIST_LOC_HAND,opponentID).length);
         var cardAdvantage:int = playerCardsInHand - opponentCardsInHand;
         var scoreDifference:int = cardManagerRef.currentPlayerScores[playerID] - cardManagerRef.currentPlayerScores[opponentID];
         var opponentRoundStatus:int = gameFlowControllerRef.playerControllers[opponentID].currentRoundStatus;
         trace("GFX -#AI# ###############################################################################");
         trace("GFX -#AI#---------------------------- AI Deciding his next move --------------------------------");
         trace("GFX -#AI#------ previousTactic: " + this.attitudeToString(this.attitude));
         trace("GFX -#AI#------ playerCardsInHand: " + playerCardsInHand);
         trace("GFX -#AI#------ opponentCardsInHand: " + opponentCardsInHand);
         trace("GFX -#AI#------ cardAdvantage: " + cardAdvantage);
         trace("GFX -#AI#------ scoreDifference: " + scoreDifference + ", his score: " + cardManagerRef.currentPlayerScores[playerID] + ", enemy score: " + cardManagerRef.currentPlayerScores[opponentID]);
         trace("GFX -#AI#------ opponent has won: " + opponentHasWon);
         trace("GFX -#AI#------ has won: " + hasWon);
         trace("GFX -#AI#------ Num units in hand: " + numUnitsInHand);
         if(gameFlowControllerRef.playerControllers[opponentID].currentRoundStatus == ROUND_PLAYER_STATUS_DONE)
         {
            trace("GFX -#AI#------ has opponent passed: true");
         }
         else
         {
            trace("GFX -#AI#------ has opponent passed: false");
         }
         trace("GFX =#AI#=======================================================================================");
         trace("GFX -#AI#-----------------------------   AI CARDS AT HAND   ------------------------------------");
         for(i = 0; i < cardsInHand.length; i++)
         {
            trace("GFX -#AI# Card Points[ ",cardsInHand[i].templateRef.power," ], Card -",cardsInHand[i]);
         }
         trace("GFX =#AI#=======================================================================================");
         var playerFaction:int = cardManagerRef.playerDeckDefinitions[playerID].getDeckFaction();
         var opponentFaction:int = cardManagerRef.playerDeckDefinitions[opponentID].getDeckFaction();
         var spiesOnMySide:int = int(cardManagerRef.getCardsInSlotIdWithEffect(CardTemplate.CardEffect_Draw2,opponentID).length);
         if(this.attitude == TACTIC_BESERKER)
         {
            beserkersOnBoard = new Vector.<CardInstance>();
            beserkersInHand = new Vector.<CardInstance>();
            cardManagerRef.getBeserkersOnBoard(playerID,beserkersOnBoard);
            cardManagerRef.getBeserkersInHand(playerID,beserkersInHand);
            if(beserkersInHand.length > 0 || beserkersOnBoard.length > 0 && cardManagerRef.getCardsInHandWithEffect(CardTemplate.CardEffect_Mushroom,playerID).length > 0)
            {
               return;
            }
         }
         if(cardManagerRef.getFirstCardInHandWithEffect(CardTemplate.CardEffect_SuicideSummon,playerID) != null)
         {
            this.attitude = TACTIC_PLAY_SUICIDE;
         }
         else if(playerFaction == CardTemplate.FactionId_Nilfgaard && opponentFaction != CardTemplate.FactionId_Nilfgaard && opponentRoundStatus == ROUND_PLAYER_STATUS_DONE && scoreDifference == 0)
         {
            this.attitude = TACTIC_PASS;
         }
         else if(!opponentHasWon && this.attitude == TACTIC_SPY_DUMMY_BEST_THEN_PASS)
         {
            if(opponentRoundStatus != ROUND_PLAYER_STATUS_DONE)
            {
               this.attitude == TACTIC_SPY_DUMMY_BEST_THEN_PASS;
            }
         }
         else if(!opponentHasWon && cardManagerRef.getFirstCardInHandWithEffect(CardTemplate.CardEffect_Draw2,playerID) != null && (Math.random() < 0.2 || spiesOnMySide > 1) && this.attitude != TACTIC_SPY_DUMMY_BEST_THEN_PASS)
         {
            this.attitude = TACTIC_SPY;
         }
         else if(this.attitude == TACTIC_SPY && cardManagerRef.getFirstCardInHandWithEffect(CardTemplate.CardEffect_Draw2,playerID) != null)
         {
            this.attitude = TACTIC_SPY;
         }
         else if(opponentRoundStatus == ROUND_PLAYER_STATUS_DONE)
         {
            if(this.attitude == TACTIC_MINIMIZE_LOSS)
            {
               this.attitude = TACTIC_MINIMIZE_LOSS;
            }
            else if(!opponentHasWon && scoreDifference <= 0 && Math.random() < scoreDifference / 20)
            {
               this.attitude = TACTIC_MINIMIZE_LOSS;
            }
            else if(!hasWon && scoreDifference > 0)
            {
               this.attitude = TACTIC_MINIMIZE_WIN;
            }
            else if(scoreDifference > 0)
            {
               this.attitude = TACTIC_PASS;
            }
            else
            {
               this.attitude = TACTIC_MINIMAL_WIN;
            }
         }
         else if(scoreDifference > 0)
         {
            if(opponentHasWon)
            {
               this.attitude = TACTIC_JUST_WAIT;
            }
            else
            {
               numCardsInHandToPerf = numUnitsInHand * numUnitsInHand / 36;
               this.attitude = TACTIC_NONE;
               if(hasWon)
               {
                  dummyCount = int(cardManagerRef.getCardsInHandWithEffect(CardTemplate.CardEffect_UnsummonDummy,playerID).length);
                  spyCount = int(cardManagerRef.getCardsInHandWithEffect(CardTemplate.CardEffect_Draw2,playerID).length);
                  if(Math.random() < 0.2 || playerCardsInHand == dummyCount + spyCount)
                  {
                     this.attitude = TACTIC_SPY_DUMMY_BEST_THEN_PASS;
                  }
                  else
                  {
                     dummyInstance = cardManagerRef.getFirstCardInHandWithEffect(CardTemplate.CardEffect_UnsummonDummy,playerID);
                     if(dummyInstance != null && cardManagerRef.getHigherOrLowerValueTargetCardOnBoard(dummyInstance,playerID,false) != null)
                     {
                        this.attitude = TACTIC_WAIT_DUMMY;
                     }
                     else if(Math.random() < scoreDifference / 30 && Math.random() < numCardsInHandToPerf)
                     {
                        this.attitude = TACTIC_MAXIMIZE_WIN;
                     }
                  }
               }
               if(this.attitude == TACTIC_NONE)
               {
                  if(Math.random() < playerCardsInHand / 10 || playerCardsInHand > 8)
                  {
                     if(Math.random() < 0.2 || playerCardsInHand == dummyCount + spyCount)
                     {
                        this.attitude = TACTIC_SPY_DUMMY_BEST_THEN_PASS;
                     }
                     else
                     {
                        this.attitude = TACTIC_JUST_WAIT;
                     }
                  }
                  else
                  {
                     this.attitude = TACTIC_PASS;
                  }
               }
            }
         }
         else if(hasWon)
         {
            dummyCount = int(cardManagerRef.getCardsInHandWithEffect(CardTemplate.CardEffect_UnsummonDummy,playerID).length);
            spyCount = int(cardManagerRef.getCardsInHandWithEffect(CardTemplate.CardEffect_Draw2,playerID).length);
            if(!opponentHasWon && (Math.random() < 0.2 || playerCardsInHand == dummyCount + spyCount))
            {
               this.attitude = TACTIC_SPY_DUMMY_BEST_THEN_PASS;
            }
            else
            {
               this.attitude = TACTIC_MAXIMIZE_WIN;
            }
         }
         else if(opponentHasWon)
         {
            this.attitude = TACTIC_MINIMAL_WIN;
         }
         else if(!cardManagerRef.roundResults[0].played && scoreDifference < -11 && Math.random() < (Math.abs(scoreDifference) - 10) / 20)
         {
            if(Math.random() < 0.9)
            {
               this.attitude = TACTIC_SPY_DUMMY_BEST_THEN_PASS;
            }
            else
            {
               this.attitude = TACTIC_PASS;
            }
         }
         else if(Math.random() < playerCardsInHand / 10)
         {
            this.attitude = TACTIC_MINIMAL_WIN;
         }
         else if(Math.random() < playerCardsInHand / 10)
         {
            this.attitude = TACTIC_AVERAGE_WIN;
         }
         else if(Math.random() < playerCardsInHand / 10)
         {
            this.attitude = TACTIC_MAXIMIZE_WIN;
         }
         else if(playerCardsInHand <= 8 && Math.random() > playerCardsInHand / 10)
         {
            this.attitude = TACTIC_PASS;
         }
         else
         {
            this.attitude = TACTIC_JUST_WAIT;
         }
      }
      
      protected function decideWhichCardToPlay() : CardTransaction
      {
         var sortedCards:Vector.<CardInstance> = null;
         var list_it:int = 0;
         var currentTransaction:CardTransaction = null;
         var currentCard:CardInstance = null;
         var bestCard:CardInstance = null;
         var cardList:Vector.<CardInstance> = null;
         var i:int = 0;
         var firstValidIndex:int = 0;
         var targetIndex:int = 0;
         var cardManagerRef:CardManager = CardManager.getInstance();
         var playerScore:int = cardManagerRef.currentPlayerScores[playerID];
         var opponentScore:int = cardManagerRef.currentPlayerScores[opponentID];
         var scoreDifference:* = playerScore - opponentScore;
         switch(this.attitude)
         {
            case TACTIC_PLAY_SUICIDE:
               currentCard = cardManagerRef.getFirstCardInHandWithEffect(CardTemplate.CardEffect_SuicideSummon,playerID);
               if(currentCard != null)
               {
                  return currentCard.getOptimalTransaction();
               }
               this.attitude = TACTIC_PASS;
               break;
            case TACTIC_BESERKER:
               cardList = cardManagerRef.getCardsInHandWithEffect(CardTemplate.CardEffect_Morph,playerID);
               for(i = 0; i < cardList.length; i++)
               {
                  if(cardList[i].templateRef.isType(this.berserkerSelectedRowType))
                  {
                     currentCard = cardList[i];
                     break;
                  }
               }
               if(currentCard != null)
               {
                  return currentCard.getOptimalTransaction();
               }
               if(!this.berserkerMushroomPlaced)
               {
                  cardList = cardManagerRef.getCardsInHandWithEffect(CardTemplate.CardEffect_Mushroom,playerID);
                  for(i = 0; i < cardList.length; i++)
                  {
                     if(cardList[i].templateRef.isType(this.berserkerSelectedRowType))
                     {
                        currentCard = cardList[i];
                        break;
                     }
                  }
                  if(currentCard != null)
                  {
                     this.berserkerMushroomPlaced = true;
                     return currentCard.getOptimalTransaction();
                  }
               }
               this.attitude = TACTIC_PASS;
               break;
            case TACTIC_SPY_DUMMY_BEST_THEN_PASS:
               currentCard = cardManagerRef.getFirstCardInHandWithEffect(CardTemplate.CardEffect_Draw2,playerID);
               if(currentCard != null)
               {
                  return currentCard.getOptimalTransaction();
               }
               currentCard = cardManagerRef.getFirstCardInHandWithEffect(CardTemplate.CardEffect_UnsummonDummy,playerID);
               if(currentCard)
               {
                  bestCard = cardManagerRef.getHigherOrLowerValueTargetCardOnBoard(currentCard,playerID,true,true);
                  if(bestCard)
                  {
                     currentTransaction = currentCard.getOptimalTransaction();
                     currentTransaction.targetCardInstanceRef = bestCard;
                     return currentTransaction;
                  }
               }
               this.attitude = TACTIC_PASS;
               break;
            case TACTIC_MINIMIZE_LOSS:
               currentCard = cardManagerRef.getFirstCardInHandWithEffect(CardTemplate.CardEffect_UnsummonDummy,playerID);
               if(currentCard)
               {
                  bestCard = this.getHighestValueCardOnBoard();
                  if(bestCard)
                  {
                     currentTransaction = currentCard.getOptimalTransaction();
                     currentTransaction.targetCardInstanceRef = bestCard;
                     return currentTransaction;
                  }
               }
               currentCard = cardManagerRef.getFirstCardInHandWithEffect(CardTemplate.CardEffect_Draw2,playerID);
               if(currentCard != null)
               {
                  return currentCard.getOptimalTransaction();
               }
               this.attitude = TACTIC_PASS;
               break;
            case TACTIC_MINIMIZE_WIN:
               currentCard = cardManagerRef.getFirstCardInHandWithEffect(CardTemplate.CardEffect_UnsummonDummy,playerID);
               if(currentCard)
               {
                  bestCard = this.getHighestValueCardOnBoardWithEffectLessThan(scoreDifference);
                  if(bestCard)
                  {
                     currentTransaction = currentCard.getOptimalTransaction();
                     if(currentTransaction)
                     {
                        currentTransaction.targetCardInstanceRef = bestCard;
                        return currentTransaction;
                     }
                  }
               }
               sortedCards = cardManagerRef.getCardsInHandWithEffect(CardTemplate.CardEffect_Draw2,playerID);
               for(list_it = 0; list_it < sortedCards.length; list_it++)
               {
                  currentCard = sortedCards[list_it];
                  if(Boolean(currentCard) && Math.abs(currentCard.getOptimalTransaction().powerChangeResult) < Math.abs(scoreDifference))
                  {
                     return currentCard.getOptimalTransaction();
                  }
               }
               this.attitude = TACTIC_PASS;
               break;
            case TACTIC_MAXIMIZE_WIN:
               sortedCards = this.getCardsBasedOnCriteria(SortType_PowerChange);
               if(sortedCards.length > 0)
               {
                  bestCard = sortedCards[sortedCards.length - 1];
                  if(bestCard)
                  {
                     return bestCard.getOptimalTransaction();
                  }
               }
               break;
            case TACTIC_AVERAGE_WIN:
               sortedCards = this.getCardsBasedOnCriteria(SortType_PowerChange);
               firstValidIndex = -1;
               while(list_it < sortedCards.length && firstValidIndex == -1)
               {
                  currentCard = sortedCards[list_it];
                  if(currentCard.getOptimalTransaction().powerChangeResult > Math.abs(scoreDifference))
                  {
                     firstValidIndex = list_it;
                  }
                  list_it++;
               }
               if(firstValidIndex != -1)
               {
                  targetIndex = Math.min(firstValidIndex,Math.max(sortedCards.length - 1,firstValidIndex + Math.floor(Math.random() * (sortedCards.length - 1 - firstValidIndex))));
                  bestCard = sortedCards[targetIndex];
                  if(bestCard)
                  {
                     return bestCard.getOptimalTransaction();
                  }
               }
               else if(sortedCards.length > 0)
               {
                  bestCard = sortedCards[sortedCards.length - 1];
                  if(bestCard)
                  {
                     return bestCard.getOptimalTransaction();
                  }
               }
               break;
            case TACTIC_MINIMAL_WIN:
               sortedCards = this.getCardsBasedOnCriteria(SortType_PowerChange);
               for(list_it = 0; list_it < sortedCards.length; list_it++)
               {
                  currentCard = sortedCards[list_it];
                  if(currentCard.getOptimalTransaction().powerChangeResult > Math.abs(scoreDifference))
                  {
                     bestCard = currentCard;
                     break;
                  }
               }
               if(!bestCard && sortedCards.length > 0)
               {
                  bestCard = sortedCards[sortedCards.length - 1];
               }
               if(bestCard)
               {
                  return bestCard.getOptimalTransaction();
               }
               break;
            case TACTIC_JUST_WAIT:
               sortedCards = this.getCardsBasedOnCriteria(SortType_StrategicValue);
               if(sortedCards.length == 0)
               {
                  return null;
               }
               for(list_it = 0; list_it < sortedCards.length; list_it++)
               {
                  currentTransaction = sortedCards[list_it].getOptimalTransaction();
                  if(currentTransaction)
                  {
                     if(!this._currentRoundCritical)
                     {
                        break;
                     }
                     if(!(currentTransaction && currentTransaction.sourceCardInstanceRef.templateRef.isType(CardTemplate.CardType_Weather) && (currentTransaction.powerChangeResult < 0 || currentTransaction.powerChangeResult < currentTransaction.sourceCardInstanceRef.potentialWeatherHarm())))
                     {
                        break;
                     }
                     currentTransaction = null;
                  }
               }
               return currentTransaction;
               break;
            case TACTIC_WAIT_DUMMY:
               currentCard = cardManagerRef.getFirstCardInHandWithEffect(CardTemplate.CardEffect_UnsummonDummy,playerID);
               if(currentCard != null)
               {
                  currentTransaction = currentCard.getOptimalTransaction();
                  if(currentTransaction.targetCardInstanceRef == null)
                  {
                     currentTransaction.targetCardInstanceRef = cardManagerRef.getHigherOrLowerValueTargetCardOnBoard(currentCard,playerID,false);
                  }
                  if(currentTransaction.targetCardInstanceRef != null)
                  {
                     return currentTransaction;
                  }
               }
               trace("GFX [ WARNING ] -#AI#---- Uh oh, was in TACTIC_WAIT_DUMMY but was unable to get a valid dummy transaction :S");
               break;
            case TACTIC_SPY:
               currentCard = cardManagerRef.getFirstCardInHandWithEffect(CardTemplate.CardEffect_Draw2,playerID);
               if(currentCard != null)
               {
                  return currentCard.getOptimalTransaction();
               }
               break;
         }
         if(this.attitude != TACTIC_PASS && this.attitude != TACTIC_MINIMIZE_WIN)
         {
            currentCard = cardManagerRef.getFirstCardInHandWithEffect(CardTemplate.CardEffect_Draw2,playerID);
            if(currentCard != null)
            {
               return currentCard.getOptimalTransaction();
            }
         }
         return null;
      }
      
      protected function getCardsBasedOnCriteria(criteriaType:int) : Vector.<CardInstance>
      {
         var i:int = 0;
         var currentInstance:CardInstance = null;
         var sortedInstanceList:Vector.<CardInstance> = new Vector.<CardInstance>();
         var handInstanceList:Vector.<CardInstance> = CardManager.getInstance().getCardInstanceList(CardManager.CARD_LIST_LOC_HAND,playerID);
         var cardManagerRef:CardManager = CardManager.getInstance();
         var leaderCard:CardLeaderInstance = cardManagerRef.getCardLeader(playerID);
         if(Boolean(leaderCard) && leaderCard.canBeUsed)
         {
            leaderCard.recalculatePowerPotential(cardManagerRef);
            if(leaderCard.getOptimalTransaction().strategicValue != -1)
            {
               sortedInstanceList.push(leaderCard);
            }
         }
         for(i = 0; i < handInstanceList.length; i++)
         {
            currentInstance = handInstanceList[i];
            switch(criteriaType)
            {
               case SortType_None:
                  sortedInstanceList.push(currentInstance);
                  break;
               case SortType_PowerChange:
                  if(currentInstance.getOptimalTransaction().powerChangeResult >= 0)
                  {
                     sortedInstanceList.push(currentInstance);
                  }
                  break;
               case SortType_StrategicValue:
                  if(currentInstance.getOptimalTransaction().strategicValue >= 0)
                  {
                     sortedInstanceList.push(currentInstance);
                  }
                  break;
            }
         }
         switch(criteriaType)
         {
            case SortType_StrategicValue:
               sortedInstanceList.sort(this.strategicValueSorter);
               break;
            case SortType_PowerChange:
               sortedInstanceList.sort(this.powerChangeSorter);
         }
         return sortedInstanceList;
      }
      
      protected function strategicValueSorter(element1:CardInstance, element2:CardInstance) : Number
      {
         return element1.getOptimalTransaction().strategicValue - element2.getOptimalTransaction().strategicValue;
      }
      
      protected function powerChangeSorter(element1:CardInstance, element2:CardInstance) : Number
      {
         if(element1.getOptimalTransaction().powerChangeResult == element2.getOptimalTransaction().powerChangeResult)
         {
            return element1.getOptimalTransaction().strategicValue - element2.getOptimalTransaction().strategicValue;
         }
         return element1.getOptimalTransaction().powerChangeResult - element2.getOptimalTransaction().powerChangeResult;
      }
      
      protected function getHighestValueCardOnBoard() : CardInstance
      {
         var i:int = 0;
         var currentInstance:CardInstance = null;
         var elligibleCardList:Vector.<CardInstance> = new Vector.<CardInstance>();
         var cardManagerRef:CardManager = CardManager.getInstance();
         cardManagerRef.getAllCreaturesNonHero(CardManager.CARD_LIST_LOC_MELEE,playerID,elligibleCardList);
         cardManagerRef.getAllCreaturesNonHero(CardManager.CARD_LIST_LOC_RANGED,playerID,elligibleCardList);
         cardManagerRef.getAllCreaturesNonHero(CardManager.CARD_LIST_LOC_SEIGE,playerID,elligibleCardList);
         var currentlyFoundCard:CardInstance = null;
         for(i = 0; i < elligibleCardList.length; i++)
         {
            currentInstance = elligibleCardList[i];
            if(currentlyFoundCard == null || currentInstance.templateRef.power + currentInstance.templateRef.GetBonusValue() > currentlyFoundCard.templateRef.power + currentlyFoundCard.templateRef.GetBonusValue())
            {
               currentlyFoundCard = currentInstance;
            }
         }
         return currentlyFoundCard;
      }
      
      protected function getHighestValueCardOnBoardWithEffectLessThan(lessThan:int) : CardInstance
      {
         var i:int = 0;
         var currentInstance:CardInstance = null;
         var elligibleCardList:Vector.<CardInstance> = new Vector.<CardInstance>();
         var cardManagerRef:CardManager = CardManager.getInstance();
         cardManagerRef.getAllCreaturesNonHero(CardManager.CARD_LIST_LOC_MELEE,playerID,elligibleCardList);
         cardManagerRef.getAllCreaturesNonHero(CardManager.CARD_LIST_LOC_RANGED,playerID,elligibleCardList);
         cardManagerRef.getAllCreaturesNonHero(CardManager.CARD_LIST_LOC_SEIGE,playerID,elligibleCardList);
         var currentlyFoundCard:CardInstance = null;
         for(i = 0; i < elligibleCardList.length; i++)
         {
            currentInstance = elligibleCardList[i];
            if(!currentInstance.templateRef.hasEffect(CardTemplate.CardEffect_SameTypeMorale) && !currentInstance.templateRef.hasEffect(CardTemplate.CardEffect_ImproveNeighbours) && currentInstance.getTotalPower() < lessThan && (currentlyFoundCard == null || currentlyFoundCard.templateRef.power + currentlyFoundCard.templateRef.GetBonusValue() < currentInstance.templateRef.power + currentInstance.templateRef.GetBonusValue()))
            {
               currentlyFoundCard = currentInstance;
            }
         }
         return currentlyFoundCard;
      }
   }
}
