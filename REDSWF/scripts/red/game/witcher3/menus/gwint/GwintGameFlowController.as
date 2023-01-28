package red.game.witcher3.menus.gwint
{
   import flash.events.Event;
   import red.core.constants.KeyCode;
   import red.game.witcher3.constants.GwintInputFeedback;
   import red.game.witcher3.controls.InputFeedbackButton;
   import red.game.witcher3.controls.W3ChoiceDialog;
   import red.game.witcher3.controls.W3MessageQueue;
   import red.game.witcher3.managers.InputFeedbackManager;
   import red.game.witcher3.utils.FiniteStateMachine;
   import scaleform.clik.constants.NavigationCode;
   import scaleform.clik.core.UIComponent;
   
   public class GwintGameFlowController extends UIComponent
   {
      
      protected static var _instance:GwintGameFlowController;
      
      public static const COIN_TOSS_POPUP_NEEDED:String = "Gameflow.event.Cointoss.needed";
       
      
      public var currentPlayer:int = -1;
      
      public var closeMenuFunctor:Function;
      
      public var mcMessageQueue:W3MessageQueue;
      
      public var mcTutorials:GwintTutorial;
      
      public var mcChoiceDialog:W3ChoiceDialog;
      
      public var mcEndGameDialog:GwintEndGameDialog;
      
      private var cardManager:CardManager;
      
      private var currentRound:int;
      
      protected var allNeutralInRound:Boolean = true;
      
      protected var playedCreaturesInRound:Boolean = false;
      
      protected var lastRoundWinner:int = -1;
      
      protected var playedThreeHeroesOneRound:Boolean = false;
      
      public var playerControllers:Vector.<BasePlayerController>;
      
      public var gameStarted:Boolean = false;
      
      protected var sawRoundEndTutorial:Boolean = false;
      
      public var stateMachine:FiniteStateMachine;
      
      protected var _skipButton:InputFeedbackButton;
      
      protected var _mulliganCardsCount:int = 0;
      
      protected var _mulliganDecided:Boolean;
      
      protected var sawRoundStartTutorial:Boolean = false;
      
      private var sawStartMessage:Boolean;
      
      protected var sawScoreChangeTutorial:Boolean = false;
      
      protected var sawEndGameTutorial:Boolean = false;
      
      public function GwintGameFlowController()
      {
         var newController:BasePlayerController = null;
         super();
         _instance = this;
         this.stateMachine = new FiniteStateMachine();
         this.stateMachine.AddState("Initializing",null,this.state_update_Initializing,this.state_leave_Initializing);
         this.stateMachine.AddState("Tutorials",this.state_begin_Tutorials,this.state_update_Tutorials,null);
         this.stateMachine.AddState("SpawnLeaders",this.state_begin_SpawnLeaders,this.state_update_SpawnLeaders,null);
         this.stateMachine.AddState("CoinToss",this.state_begin_CoinToss,this.state_update_CoinToss,null);
         this.stateMachine.AddState("Mulligan",this.state_begin_Mulligan,this.state_update_Mulligan,null);
         this.stateMachine.AddState("RoundStart",this.state_begin_RoundStart,this.state_update_RoundStart,null);
         this.stateMachine.AddState("PlayerTurn",this.state_begin_PlayerTurn,this.state_update_PlayerTurn,this.state_leave_PlayerTurn);
         this.stateMachine.AddState("ChangingPlayer",this.state_begin_ChangingPlayer,this.state_update_ChangingPlayer,null);
         this.stateMachine.AddState("ShowingRoundResult",this.state_begin_ShowingRoundResult,this.state_update_ShowingRoundResult,null);
         this.stateMachine.AddState("ClearingBoard",this.state_begin_ClearingBoard,this.state_update_ClearingBoard,this.state_leave_ClearingBoard);
         this.stateMachine.AddState("ShowingFinalResult",this.state_begin_ShowingFinalResult,this.state_update_ShowingFinalResult,null);
         this.stateMachine.AddState("Reset",this.state_begin_reset,null,null);
         this.playerControllers = new Vector.<BasePlayerController>();
         newController = new HumanPlayerController();
         newController.gameFlowControllerRef = this;
         newController.playerID = CardManager.PLAYER_1;
         newController.opponentID = CardManager.PLAYER_2;
         (newController as HumanPlayerController).skipButton = this._skipButton;
         this.playerControllers.push(newController);
         newController = new AIPlayerController();
         newController.gameFlowControllerRef = this;
         newController.playerID = CardManager.PLAYER_2;
         newController.opponentID = CardManager.PLAYER_1;
         this.playerControllers.push(newController);
         this.currentRound = 0;
      }
      
      public static function getInstance() : GwintGameFlowController
      {
         return _instance;
      }
      
      protected function shouldDisallowStateChangeFunc() : Boolean
      {
         if(this.mcTutorials && this.mcTutorials.visible && !this.mcTutorials.isPaused)
         {
            return true;
         }
         return this.mcMessageQueue.ShowingMessage() || CardFXManager.getInstance().isPlayingAnyCardFX() || this.mcChoiceDialog.isShown() || CardTweenManager.getInstance().isAnyCardMoving();
      }
      
      public function turnOnAI(playerIndex:int) : void
      {
         var newController:BasePlayerController = null;
         newController = new AIPlayerController();
         newController.gameFlowControllerRef = this;
         newController.playerID = CardManager.PLAYER_1;
         newController.opponentID = CardManager.PLAYER_2;
         this.playerControllers[CardManager.PLAYER_1] = newController;
      }
      
      public function turnOffAI(playerIndex:int) : void
      {
         var newController:BasePlayerController = null;
         newController = new HumanPlayerController();
         newController.gameFlowControllerRef = this;
         newController.playerID = CardManager.PLAYER_1;
         newController.opponentID = CardManager.PLAYER_2;
         (newController as HumanPlayerController).setChoiceDialog(this.mcChoiceDialog);
         this.playerControllers[CardManager.PLAYER_1] = newController;
      }
      
      public function get skipButton() : InputFeedbackButton
      {
         return this._skipButton;
      }
      
      public function set skipButton(value:InputFeedbackButton) : void
      {
         this._skipButton = value;
         var curHumanController:HumanPlayerController = this.playerControllers[CardManager.PLAYER_1] as HumanPlayerController;
         if(curHumanController)
         {
            curHumanController.skipButton = this._skipButton;
         }
      }
      
      protected function state_update_Initializing() : void
      {
         if(CardManager.getInstance() && CardManager.getInstance().cardTemplatesReceived && CardFXManager.getInstance() != null)
         {
            this.stateMachine.ChangeState("Tutorials");
         }
      }
      
      protected function state_leave_Initializing() : void
      {
         var curHumanController:HumanPlayerController = null;
         this.cardManager = CardManager.getInstance();
         if(!this.cardManager)
         {
            throw new Error("GFX --- Tried to link reference to card manager after initializing, was unable to!");
         }
         if(this.playerControllers[CardManager.PLAYER_1] is HumanPlayerController)
         {
            (this.playerControllers[CardManager.PLAYER_1] as HumanPlayerController).setChoiceDialog(this.mcChoiceDialog);
         }
         this.playerControllers[CardManager.PLAYER_1].boardRenderer = this.cardManager.boardRenderer;
         this.playerControllers[CardManager.PLAYER_2].boardRenderer = this.cardManager.boardRenderer;
         this.playerControllers[CardManager.PLAYER_1].playerRenderer = this.cardManager.playerRenderers[CardManager.PLAYER_1];
         this.playerControllers[CardManager.PLAYER_2].playerRenderer = this.cardManager.playerRenderers[CardManager.PLAYER_2];
         this.stateMachine.pauseOnStateChangeIfFunc = this.shouldDisallowStateChangeFunc;
         if(this._skipButton != null)
         {
            curHumanController = this.playerControllers[CardManager.PLAYER_1] as HumanPlayerController;
            if(curHumanController)
            {
               curHumanController.skipButton = this._skipButton;
            }
         }
      }
      
      protected function state_begin_Tutorials() : void
      {
      }
      
      protected function state_update_Tutorials() : void
      {
         if(!this.mcTutorials.visible || this.mcTutorials.isPaused)
         {
            this.stateMachine.ChangeState("SpawnLeaders");
            InputFeedbackManager.cleanupButtons();
            InputFeedbackManager.appendButtonById(GwintInputFeedback.navigate,NavigationCode.GAMEPAD_L3,-1,"panel_button_common_navigation");
            InputFeedbackManager.appendButtonById(GwintInputFeedback.quitGame,NavigationCode.START,KeyCode.Q,"gwint_pass_game");
         }
      }
      
      protected function state_begin_SpawnLeaders() : void
      {
         trace("GFX ##########################################################");
         trace("GFX -#AI#-----------------------------------------------------------------------------------------------------");
         trace("GFX -#AI#----------------------------- NEW GWINT GAME ------------------------------------");
         trace("GFX -#AI#-----------------------------------------------------------------------------------------------------");
         this.cardManager.spawnLeaders();
         this.gameStarted = false;
         this.playedThreeHeroesOneRound = false;
         var player1Leader:CardLeaderInstance = this.cardManager.getCardLeader(CardManager.PLAYER_1);
         var player2Leader:CardLeaderInstance = this.cardManager.getCardLeader(CardManager.PLAYER_2);
         var disableLeaderAbilities:Boolean = false;
         if(this.playerControllers[CardManager.PLAYER_1] is HumanPlayerController)
         {
            (this.playerControllers[CardManager.PLAYER_1] as HumanPlayerController).attachToTutorialCarouselMessage();
         }
         this.playerControllers[CardManager.PLAYER_1].cardZoomEnabled = false;
         this.playerControllers[CardManager.PLAYER_2].cardZoomEnabled = false;
         this.playerControllers[CardManager.PLAYER_1].inputEnabled = true;
         this.playerControllers[CardManager.PLAYER_2].inputEnabled = true;
         if(player1Leader != null && player2Leader != null && player1Leader.templateId != player2Leader.templateId)
         {
            if(player1Leader.templateRef.getFirstEffect() == CardTemplate.CardEffect_Counter_King || player2Leader.templateRef.getFirstEffect() == CardTemplate.CardEffect_Counter_King)
            {
               disableLeaderAbilities = true;
               if(player1Leader.templateRef.getFirstEffect() != player2Leader.templateRef.getFirstEffect())
               {
                  if(player1Leader.templateRef.getFirstEffect() == CardTemplate.CardEffect_Counter_King)
                  {
                     this.mcMessageQueue.PushMessage("[[gwint_player_counter_leader]]");
                     GwintGameMenu.mSingleton.playSound("gui_gwint_using_ability");
                  }
                  else
                  {
                     this.mcMessageQueue.PushMessage("[[gwint_opponent_counter_leader]]");
                     GwintGameMenu.mSingleton.playSound("gui_gwint_using_ability");
                  }
               }
               player1Leader.canBeUsed = false;
               player2Leader.canBeUsed = false;
               if(this.cardManager.boardRenderer)
               {
                  this.cardManager.boardRenderer.getCardHolder(CardManager.CARD_LIST_LOC_LEADER,CardManager.PLAYER_1).updateLeaderStatus(false);
                  this.cardManager.boardRenderer.getCardHolder(CardManager.CARD_LIST_LOC_LEADER,CardManager.PLAYER_2).updateLeaderStatus(false);
               }
            }
         }
         if(disableLeaderAbilities)
         {
            this.cardManager.cardEffectManager.doubleSpyEnabled = false;
            this.cardManager.cardEffectManager.randomResEnabled = false;
         }
         else
         {
            this.cardManager.cardEffectManager.doubleSpyEnabled = player1Leader.templateRef.getFirstEffect() == CardTemplate.CardEffect_DoubleSpy || player2Leader.templateRef.getFirstEffect() == CardTemplate.CardEffect_DoubleSpy;
            this.cardManager.cardEffectManager.randomResEnabled = player1Leader.templateRef.getFirstEffect() == CardTemplate.CardEffect_RandomRessurect || player2Leader.templateRef.getFirstEffect() == CardTemplate.CardEffect_RandomRessurect;
         }
         this.playerControllers[CardManager.PLAYER_1].currentRoundStatus = BasePlayerController.ROUND_PLAYER_STATUS_ACTIVE;
         this.playerControllers[CardManager.PLAYER_2].currentRoundStatus = BasePlayerController.ROUND_PLAYER_STATUS_ACTIVE;
      }
      
      protected function state_update_SpawnLeaders() : void
      {
         this.stateMachine.ChangeState("CoinToss");
      }
      
      protected function state_begin_CoinToss() : void
      {
         var player1Faction:int = this.cardManager.playerDeckDefinitions[CardManager.PLAYER_1].getDeckFaction();
         var player2Faction:int = this.cardManager.playerDeckDefinitions[CardManager.PLAYER_2].getDeckFaction();
         trace("GFX - Coing flip logic, player1faction:",player1Faction,", player2Faction:",player2Faction);
         if(player1Faction != player2Faction && !this.mcTutorials.visible && (player1Faction == CardTemplate.FactionId_Scoiatael || player2Faction == CardTemplate.FactionId_Scoiatael))
         {
            GwintGameMenu.mSingleton.playSound("gui_gwint_scoia_tael_ability");
            if(player1Faction == CardTemplate.FactionId_Scoiatael)
            {
               this.currentPlayer = CardManager.PLAYER_INVALID;
               dispatchEvent(new Event(COIN_TOSS_POPUP_NEEDED,false,false));
            }
            else
            {
               this.currentPlayer = CardManager.PLAYER_2;
               this.mcMessageQueue.PushMessage("[[gwint_opponent_scoiatael_start_special]]","sco_ability");
            }
         }
         else
         {
            if(this.mcTutorials.visible)
            {
               this.currentPlayer = CardManager.PLAYER_1;
            }
            else
            {
               this.currentPlayer = Math.floor(Math.random() * 2);
            }
            if(this.currentPlayer == CardManager.PLAYER_1)
            {
               this.mcMessageQueue.PushMessage("[[gwint_player_will_go_first_message]]","coin_flip_win");
            }
            else if(this.currentPlayer == CardManager.PLAYER_2)
            {
               this.mcMessageQueue.PushMessage("[[gwint_opponent_will_go_first]]","coin_flip_loss");
            }
            GwintGameMenu.mSingleton.playSound("gui_gwint_coin_toss");
         }
      }
      
      protected function state_update_CoinToss() : void
      {
         if(this.currentPlayer != CardManager.PLAYER_INVALID)
         {
            this.stateMachine.ChangeState("Mulligan");
         }
      }
      
      protected function state_begin_Mulligan() : void
      {
         var cardsInHand:Vector.<CardInstance> = null;
         this._mulliganDecided = false;
         this._mulliganCardsCount = 0;
         this.cardManager.shuffleAndDrawCards();
         cardsInHand = this.cardManager.getCardInstanceList(CardManager.CARD_LIST_LOC_HAND,CardManager.PLAYER_1);
         this.mcChoiceDialog.showDialogCardInstances(cardsInHand,this.handleAcceptMulligan,this.handleDeclineMulligan,"[[gwint_can_choose_card_to_redraw]]");
         this.mcChoiceDialog.appendDialogText(" 0/2");
         if(this.mcTutorials.visible)
         {
            this.mcTutorials.continueTutorial();
            this.mcChoiceDialog.inputEnabled = false;
            this.mcTutorials.hideCarouselCB = this.handleDeclineMulligan;
            this.mcTutorials.changeChoiceCB = this.handleForceCardSelected;
         }
         GwintGameMenu.mSingleton.playSound("gui_gwint_draw_2");
      }
      
      protected function state_update_Mulligan() : void
      {
         if(this._mulliganDecided && (!this.mcTutorials.visible || this.mcTutorials.isPaused))
         {
            this.stateMachine.ChangeState("RoundStart");
            this.mcChoiceDialog.hideDialog();
            this.gameStarted = true;
            this.playerControllers[CardManager.PLAYER_1].cardZoomEnabled = true;
            this.playerControllers[CardManager.PLAYER_2].cardZoomEnabled = true;
            GwintGameMenu.mSingleton.playSound("gui_gwint_game_start");
         }
      }
      
      protected function handleAcceptMulligan(instanceId:int) : void
      {
         var newCard:CardInstance = null;
         var selectedCard:CardInstance = this.cardManager.getCardInstance(instanceId);
         if(selectedCard)
         {
            newCard = this.cardManager.mulliganCard(selectedCard);
            this.mcChoiceDialog.replaceCard(selectedCard,newCard);
            ++this._mulliganCardsCount;
            GwintGameMenu.mSingleton.playSound("gui_gwint_card_redrawn");
            if(this._mulliganCardsCount < 2)
            {
               this.mcChoiceDialog.updateDialogText("[[gwint_can_choose_card_to_redraw]]");
               this.mcChoiceDialog.appendDialogText(" 1/2");
            }
            this._mulliganDecided = this._mulliganCardsCount >= 2;
         }
      }
      
      protected function handleDeclineMulligan() : void
      {
         this.mcChoiceDialog.hideDialog();
         this._mulliganDecided = true;
         if(this.playerControllers[CardManager.PLAYER_1] is HumanPlayerController)
         {
            (this.playerControllers[CardManager.PLAYER_1] as HumanPlayerController).attachToTutorialCarouselMessage();
         }
      }
      
      protected function handleForceCardSelected(index:int) : void
      {
         if(Boolean(this.mcChoiceDialog) && this.mcChoiceDialog.visible)
         {
            this.mcChoiceDialog.cardsCarousel.selectedIndex = index;
         }
      }
      
      protected function state_begin_RoundStart() : void
      {
         this.mcMessageQueue.PushMessage("[[gwint_round_start]]","round_start");
         this.allNeutralInRound = true;
         this.playedCreaturesInRound = false;
         if(this.lastRoundWinner != CardManager.PLAYER_INVALID && this.cardManager.playerDeckDefinitions[this.lastRoundWinner].getDeckFaction() == CardTemplate.FactionId_Northern_Kingdom)
         {
            this.mcMessageQueue.PushMessage("[[gwint_northern_ability_triggered]]","north_ability",this.onShowNorthAbilityShown,null);
            GwintGameMenu.mSingleton.playSound("gui_gwint_northern_realms_ability");
         }
         if(this.currentRound == 2)
         {
            if(this.cardManager.playerDeckDefinitions[CardManager.PLAYER_1].getDeckFaction() == CardTemplate.FactionId_Skellige)
            {
               this.mcMessageQueue.PushMessage("[[gwint_skel_ability_player_triggered]]","skel_ability",this.OnPlayerSkelAbilityShown,null);
               GwintGameMenu.mSingleton.playSound("gui_gwint_skellige_ability");
            }
            if(this.cardManager.playerDeckDefinitions[CardManager.PLAYER_2].getDeckFaction() == CardTemplate.FactionId_Skellige)
            {
               this.mcMessageQueue.PushMessage("[[gwint_skel_ability_ai_triggered]]","skel_ability",this.OnAISkelAbilityShown,null);
               GwintGameMenu.mSingleton.playSound("gui_gwint_skellige_ability");
            }
         }
      }
      
      protected function state_update_RoundStart() : void
      {
         if(!this.mcMessageQueue.ShowingMessage())
         {
            if(this.mcTutorials.visible && !this.sawRoundStartTutorial)
            {
               this.sawRoundStartTutorial = true;
               this.mcTutorials.continueTutorial();
            }
            if(this.shouldDisallowStateChangeFunc() == false)
            {
               this.playerControllers[CardManager.PLAYER_1].resetCurrentRoundStatus();
               this.playerControllers[CardManager.PLAYER_2].resetCurrentRoundStatus();
               if(this.playerControllers[this.currentPlayer].currentRoundStatus == BasePlayerController.ROUND_PLAYER_STATUS_DONE)
               {
                  this.currentPlayer = this.currentPlayer == CardManager.PLAYER_1 ? CardManager.PLAYER_2 : CardManager.PLAYER_1;
                  if(this.playerControllers[this.currentPlayer].currentRoundStatus == BasePlayerController.ROUND_PLAYER_STATUS_DONE)
                  {
                     this.stateMachine.ChangeState("ShowingRoundResult");
                  }
                  else
                  {
                     this.stateMachine.ChangeState("PlayerTurn");
                  }
               }
               else
               {
                  this.stateMachine.ChangeState("PlayerTurn");
               }
            }
         }
      }
      
      protected function onShowNorthAbilityShown() : void
      {
         this.cardManager.drawCard(this.lastRoundWinner);
      }
      
      protected function OnPlayerSkelAbilityShown() : void
      {
         this.cardManager.ressurectFromGraveyard(CardManager.PLAYER_1,2);
      }
      
      protected function OnAISkelAbilityShown() : void
      {
         this.cardManager.ressurectFromGraveyard(CardManager.PLAYER_2,2);
      }
      
      protected function state_begin_PlayerTurn() : void
      {
         trace("GFX -#AI# starting player turn for player: " + this.currentPlayer);
         if(this.currentPlayer == CardManager.PLAYER_1)
         {
            this.mcMessageQueue.PushMessage("[[gwint_player_turn_start_message]]","your_turn");
            GwintGameMenu.mSingleton.playSound("gui_gwint_your_turn");
         }
         else if(this.currentPlayer == CardManager.PLAYER_2)
         {
            this.mcMessageQueue.PushMessage("[[gwint_opponent_turn_start_message]]","Opponents_turn");
            GwintGameMenu.mSingleton.playSound("gui_gwint_opponents_turn");
         }
         this.sawStartMessage = false;
         this.playerControllers[this.currentPlayer].playerRenderer.turnActive = true;
      }
      
      protected function state_update_PlayerTurn() : void
      {
         var currentPlayerController:BasePlayerController = this.playerControllers[this.currentPlayer];
         var otherPlayerController:BasePlayerController = this.playerControllers[this.currentPlayer == CardManager.PLAYER_1 ? CardManager.PLAYER_2 : CardManager.PLAYER_1];
         if(!currentPlayerController)
         {
            throw new Error("GFX ---- currentPlayerController not found for player: " + this.currentPlayer.toString());
         }
         if(this.mcMessageQueue.ShowingMessage())
         {
            return;
         }
         if(!this.sawStartMessage)
         {
            this.sawStartMessage = true;
            currentPlayerController.startTurn();
         }
         if(currentPlayerController.turnOver)
         {
            if(this.mcTutorials.visible && !this.sawScoreChangeTutorial)
            {
               if(this.cardManager.currentPlayerScores[CardManager.PLAYER_1] != 0 || this.cardManager.currentPlayerScores[CardManager.PLAYER_2] != 0)
               {
                  this.sawScoreChangeTutorial = true;
                  this.mcTutorials.continueTutorial();
               }
            }
            if(this.mcTutorials.visible && !this.mcTutorials.isPaused)
            {
               return;
            }
            if(currentPlayerController.currentRoundStatus == BasePlayerController.ROUND_PLAYER_STATUS_ACTIVE)
            {
               if(otherPlayerController.currentRoundStatus == BasePlayerController.ROUND_PLAYER_STATUS_DONE)
               {
                  currentPlayerController.startTurn();
               }
               else
               {
                  this.stateMachine.ChangeState("ChangingPlayer");
               }
            }
            else if(otherPlayerController.currentRoundStatus == BasePlayerController.ROUND_PLAYER_STATUS_ACTIVE)
            {
               this.stateMachine.ChangeState("ChangingPlayer");
            }
            else
            {
               this.stateMachine.ChangeState("ShowingRoundResult");
            }
         }
      }
      
      protected function state_leave_PlayerTurn() : void
      {
         var allCreatures:Vector.<CardInstance> = null;
         var currentTemplate:CardTemplate = null;
         var list_it:int = 0;
         this.playerControllers[this.currentPlayer].playerRenderer.turnActive = false;
         if(this.allNeutralInRound || !this.playedCreaturesInRound)
         {
            allCreatures = this.cardManager.getAllCreatures(CardManager.PLAYER_1);
            for(list_it = 0; list_it < allCreatures.length; list_it++)
            {
               currentTemplate = allCreatures[list_it].templateRef;
               if(!currentTemplate.isType(CardTemplate.CardType_Spy))
               {
                  this.playedCreaturesInRound = true;
                  if(currentTemplate.factionIdx != CardTemplate.FactionId_Neutral)
                  {
                     this.allNeutralInRound = false;
                  }
               }
            }
            allCreatures = this.cardManager.getAllCreatures(CardManager.PLAYER_2);
            for(list_it = 0; list_it < allCreatures.length; list_it++)
            {
               currentTemplate = allCreatures[list_it].templateRef;
               if(currentTemplate.isType(CardTemplate.CardType_Spy))
               {
                  this.playedCreaturesInRound = true;
                  if(currentTemplate.factionIdx != CardTemplate.FactionId_Neutral)
                  {
                     this.allNeutralInRound = false;
                  }
               }
            }
         }
         this.cardManager.recalculateScores();
      }
      
      protected function state_begin_ChangingPlayer() : void
      {
         if(this.playerControllers[this.currentPlayer].currentRoundStatus == BasePlayerController.ROUND_PLAYER_STATUS_DONE)
         {
            if(this.currentPlayer == CardManager.PLAYER_1)
            {
               this.mcMessageQueue.PushMessage("[[gwint_player_passed_turn]]","passed");
            }
            else
            {
               this.mcMessageQueue.PushMessage("[[gwint_opponent_passed_turn]]","passed");
            }
         }
      }
      
      protected function state_update_ChangingPlayer() : void
      {
         if(!this.mcMessageQueue.ShowingMessage())
         {
            this.currentPlayer = this.currentPlayer == CardManager.PLAYER_1 ? CardManager.PLAYER_2 : CardManager.PLAYER_1;
            this.stateMachine.ChangeState("PlayerTurn");
         }
      }
      
      protected function state_begin_ShowingRoundResult() : void
      {
         var list_it:int = 0;
         var player1Score:int = this.cardManager.currentPlayerScores[CardManager.PLAYER_1];
         var player2Score:int = this.cardManager.currentPlayerScores[CardManager.PLAYER_2];
         var player1Faction:int = this.cardManager.playerDeckDefinitions[CardManager.PLAYER_1].getDeckFaction();
         var player2Faction:int = this.cardManager.playerDeckDefinitions[CardManager.PLAYER_2].getDeckFaction();
         var roundWinner:int = CardManager.PLAYER_INVALID;
         this.playerControllers[CardManager.PLAYER_1].resetCurrentRoundStatus();
         this.playerControllers[CardManager.PLAYER_2].resetCurrentRoundStatus();
         if(this.mcTutorials.visible && !this.sawRoundEndTutorial)
         {
            this.sawRoundEndTutorial = true;
            this.mcTutorials.continueTutorial();
         }
         if(player1Score == player2Score)
         {
            if(player1Faction != player2Faction && (player1Faction == CardTemplate.FactionId_Nilfgaard || player2Faction == CardTemplate.FactionId_Nilfgaard))
            {
               this.mcMessageQueue.PushMessage("[[gwint_nilfgaard_ability_triggered]]","nilf_ability");
               GwintGameMenu.mSingleton.playSound("gui_gwint_nilfgaardian_ability");
               if(player1Faction == CardTemplate.FactionId_Nilfgaard)
               {
                  this.mcMessageQueue.PushMessage("[[gwint_player_won_round]]","battle_won");
                  roundWinner = CardManager.PLAYER_1;
                  this.lastRoundWinner = CardManager.PLAYER_1;
                  GwintGameMenu.mSingleton.playSound("gui_gwint_clash_victory");
               }
               else
               {
                  this.mcMessageQueue.PushMessage("[[gwint_opponent_won_round]]","battle_lost");
                  roundWinner = CardManager.PLAYER_2;
                  this.lastRoundWinner = CardManager.PLAYER_2;
                  GwintGameMenu.mSingleton.playSound("gui_gwint_clash_defeat");
               }
            }
            else
            {
               this.mcMessageQueue.PushMessage("[[gwint_round_draw]]","battle_draw");
               roundWinner = CardManager.PLAYER_INVALID;
               this.lastRoundWinner = CardManager.PLAYER_INVALID;
               GwintGameMenu.mSingleton.playSound("gui_gwint_round_draw");
               GwintGameMenu.mSingleton.playSound("gui_gwint_gem_destruction");
            }
         }
         else if(player1Score > player2Score)
         {
            this.mcMessageQueue.PushMessage("[[gwint_player_won_round]]","battle_won");
            roundWinner = CardManager.PLAYER_1;
            this.lastRoundWinner = CardManager.PLAYER_1;
            GwintGameMenu.mSingleton.playSound("gui_gwint_clash_victory");
         }
         else
         {
            this.mcMessageQueue.PushMessage("[[gwint_opponent_won_round]]","battle_lost");
            roundWinner = CardManager.PLAYER_2;
            this.lastRoundWinner = CardManager.PLAYER_2;
            GwintGameMenu.mSingleton.playSound("gui_gwint_clash_defeat");
         }
         if(roundWinner != CardManager.PLAYER_INVALID)
         {
            GwintGameMenu.mSingleton.playSound("gui_gwint_gem_destruction");
         }
         this.cardManager.roundResults[this.currentRound].setResults(player1Score,player2Score,roundWinner);
         this.cardManager.traceRoundResults();
         this.cardManager.updatePlayerLives();
         var numHeroes:int = 0;
         var allCreatures:Vector.<CardInstance> = this.cardManager.getAllCreatures(CardManager.PLAYER_1);
         for(list_it = 0; list_it < allCreatures.length; list_it++)
         {
            if(allCreatures[list_it].templateRef.isType(CardTemplate.CardType_Hero))
            {
               numHeroes++;
            }
         }
         if(numHeroes >= 3)
         {
            this.playedThreeHeroesOneRound = true;
         }
         if(this.allNeutralInRound && this.playedCreaturesInRound && roundWinner == CardManager.PLAYER_1)
         {
            GwintGameMenu.mSingleton.sendNeutralRoundVictoryAchievement();
         }
         if(player1Score >= 187 && roundWinner == CardManager.PLAYER_1)
         {
            GwintGameMenu.mSingleton.sendKilledItAchievement();
         }
      }
      
      public function isGameOver() : Boolean
      {
         return this.currentRound == 2 || this.currentRound == 1 && (this.cardManager.roundResults[0].winningPlayer == this.cardManager.roundResults[1].winningPlayer || this.cardManager.roundResults[0].winningPlayer == CardManager.PLAYER_INVALID || this.cardManager.roundResults[1].winningPlayer == CardManager.PLAYER_INVALID);
      }
      
      protected function state_update_ShowingRoundResult() : void
      {
         if(!this.mcMessageQueue.ShowingMessage())
         {
            if(this.isGameOver())
            {
               this.cardManager.clearBoard(false);
               this.stateMachine.ChangeState("ShowingFinalResult");
            }
            else
            {
               if(this.lastRoundWinner != CardManager.PLAYER_INVALID)
               {
                  this.currentPlayer = this.lastRoundWinner;
               }
               this.stateMachine.ChangeState("ClearingBoard");
            }
         }
      }
      
      protected function state_begin_ClearingBoard() : void
      {
         var monsterAbilityTriggered:Boolean = false;
         if(this.cardManager.playerDeckDefinitions[CardManager.PLAYER_1].getDeckFaction() == CardTemplate.FactionId_No_Mans_Land && this.cardManager.chooseCreatureToExclude(CardManager.PLAYER_1) != null)
         {
            monsterAbilityTriggered = true;
         }
         else if(!monsterAbilityTriggered && this.cardManager.playerDeckDefinitions[CardManager.PLAYER_2].getDeckFaction() == CardTemplate.FactionId_No_Mans_Land && this.cardManager.chooseCreatureToExclude(CardManager.PLAYER_2) != null)
         {
            monsterAbilityTriggered = true;
         }
         if(monsterAbilityTriggered)
         {
            this.mcMessageQueue.PushMessage("[[gwint_monster_faction_ability_triggered]]","monster_ability");
            GwintGameMenu.mSingleton.playSound("gui_gwint_monster_ability");
         }
         this.cardManager.clearBoard(true);
      }
      
      protected function state_update_ClearingBoard() : void
      {
         if(!this.mcMessageQueue.ShowingMessage())
         {
            this.cardManager.recalculateScores();
            ++this.currentRound;
            this.stateMachine.ChangeState("RoundStart");
         }
      }
      
      protected function state_leave_ClearingBoard() : void
      {
         this.cardManager.recalculateScores();
      }
      
      protected function state_begin_ShowingFinalResult() : void
      {
         var player1Faction:int = 0;
         var player2Faction:int = 0;
         var gameWinner:int = CardManager.PLAYER_INVALID;
         var round1Winner:int = this.cardManager.roundResults[0].winningPlayer;
         var round2Winner:int = this.cardManager.roundResults[1].winningPlayer;
         if(this.currentRound == 1 && round1Winner != round2Winner && !this.cardManager.roundResults[2].played)
         {
            player1Faction = this.cardManager.playerDeckDefinitions[CardManager.PLAYER_1].getDeckFaction();
            player2Faction = this.cardManager.playerDeckDefinitions[CardManager.PLAYER_2].getDeckFaction();
            if(player1Faction != player2Faction)
            {
               if(player1Faction == CardTemplate.FactionId_Nilfgaard)
               {
                  this.cardManager.roundResults[2].setResults(0,0,CardManager.PLAYER_1);
               }
               else if(player2Faction == CardTemplate.FactionId_Nilfgaard)
               {
                  this.cardManager.roundResults[2].setResults(0,0,CardManager.PLAYER_2);
               }
            }
         }
         if(this.mcTutorials.visible && !this.sawEndGameTutorial)
         {
            this.sawEndGameTutorial = true;
            this.mcTutorials.continueTutorial();
         }
         var round3Winner:int = this.cardManager.roundResults[2].winningPlayer;
         this.playerControllers[CardManager.PLAYER_1].cardZoomEnabled = false;
         this.playerControllers[CardManager.PLAYER_2].cardZoomEnabled = false;
         this.playerControllers[CardManager.PLAYER_1].inputEnabled = false;
         this.playerControllers[CardManager.PLAYER_2].inputEnabled = false;
         this.mcChoiceDialog.hideDialog();
         if(this.currentRound == 1 && (round1Winner == round2Winner || round1Winner == CardManager.PLAYER_INVALID || round2Winner == CardManager.PLAYER_INVALID))
         {
            if(round1Winner == CardManager.PLAYER_INVALID)
            {
               gameWinner = round2Winner;
            }
            else
            {
               gameWinner = round1Winner;
            }
         }
         else
         {
            if(this.currentRound != 2)
            {
               throw new Error("GFX - Danger will robinson, danger!");
            }
            if(round1Winner == round2Winner || round1Winner == round3Winner)
            {
               gameWinner = round1Winner;
            }
            else if(round2Winner == round3Winner)
            {
               gameWinner = round2Winner;
            }
         }
         this.cardManager.traceRoundResults();
         trace("GFX -#AI#--- game winner was: " + gameWinner);
         trace("GFX -#AI#--- current round was: " + this.currentRound);
         trace("GFX -#AI#--- Round 1 winner: " + round1Winner);
         trace("GFX -#AI#--- Round 2 winner: " + round1Winner);
         trace("GFX -#AI#--- Round 3 winner: " + round1Winner);
         if(gameWinner == CardManager.PLAYER_1)
         {
            if(this.playedThreeHeroesOneRound)
            {
               GwintGameMenu.mSingleton.sendHeroRoundVictoryAchievement();
            }
            GwintGameMenu.mSingleton.playSound("gui_gwint_battle_won");
         }
         else if(gameWinner == CardManager.PLAYER_2)
         {
            GwintGameMenu.mSingleton.playSound("gui_gwint_battle_lost");
         }
         else
         {
            GwintGameMenu.mSingleton.playSound("gui_gwint_battle_draw");
         }
         this.mcEndGameDialog.show(gameWinner,this.OnEndGameResult);
      }
      
      protected function state_update_ShowingFinalResult() : void
      {
      }
      
      protected function OnEndGameResult(result:int) : void
      {
         if(result == GwintEndGameDialog.EndGameDialogResult_Restart)
         {
            this.stateMachine.ChangeState("Reset");
         }
         else
         {
            this.closeMenuFunctor(result == GwintEndGameDialog.EndGameDialogResult_EndVictory);
         }
      }
      
      protected function state_begin_reset() : void
      {
         this.currentRound = 0;
         this.cardManager.reset();
         this.mcMessageQueue.PushMessage("[[gwint_resetting]]");
         this.stateMachine.ChangeState("SpawnLeaders");
      }
      
      public function EndGame(result:int) : void
      {
         this.OnEndGameResult(result);
      }
   }
}
