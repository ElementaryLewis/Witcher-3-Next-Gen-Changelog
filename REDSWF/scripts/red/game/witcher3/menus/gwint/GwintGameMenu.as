package red.game.witcher3.menus.gwint
{
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import red.core.constants.KeyCode;
   import red.core.events.GameEvent;
   import red.game.witcher3.controls.ConditionalCloseButton;
   import red.game.witcher3.controls.InputFeedbackButton;
   import red.game.witcher3.controls.W3ChoiceDialog;
   import red.game.witcher3.controls.W3MessageQueue;
   import red.game.witcher3.managers.InputFeedbackManager;
   import scaleform.clik.constants.InputValue;
   import scaleform.clik.constants.NavigationCode;
   import scaleform.clik.events.ButtonEvent;
   import scaleform.clik.events.InputEvent;
   import scaleform.clik.managers.InputDelegate;
   import scaleform.clik.ui.InputDetails;
   
   public class GwintGameMenu extends GwintBaseMenu
   {
      
      private static const SKIP_TURN_HOLD_DELAY:Number = 1000;
      
      public static var mSingleton:GwintGameMenu;
       
      
      public var gameFlowController:GwintGameFlowController;
      
      public var mcMessageQueue:W3MessageQueue;
      
      public var mcChoiceDialog:W3ChoiceDialog;
      
      public var mcCardFXManager:CardFXManager;
      
      public var mcEndGameDialog:GwintEndGameDialog;
      
      public var btnSkipTurn:InputFeedbackButton;
      
      public var mcCloseBtn:ConditionalCloseButton;
      
      public var mcTutorials:GwintTutorial;
      
      public var tutorialsOn:Boolean = false;
      
      public var mcPlayer1Renderer:GwintPlayerRenderer;
      
      public var mcPlayer2Renderer:GwintPlayerRenderer;
      
      public var mcP1DeckRenderer:GwintDeckRenderer;
      
      public var mcP2DeckRenderer:GwintDeckRenderer;
      
      public var mcBoardRenderer:GwintBoardRenderer;
      
      public function GwintGameMenu()
      {
         super();
         InputFeedbackManager.useOverlayPopup = true;
         InputFeedbackManager.eventDispatcher = this;
         this.gameFlowController = new GwintGameFlowController();
         GwintGameMenu.mSingleton = this;
         _enableMouse = false;
         addEventListener(Event.ADDED_TO_STAGE,this.__setPerspectiveProjection_);
         this.__setProp_mcBoardRenderer_Scene1_mcBoadRenderer_0();
         this.__setProp_mcPlayer2Renderer_Scene1_mcPlayer2Renderer_0();
         this.__setProp_mcPlayer1Renderer_Scene1_mcPlayer1Renderer_0();
         this.__setProp_mcCardFXManager_Scene1_mcCardFXManager_0();
         this.__setProp_mcCloseBtn_Scene1_mcCloseBtn_0();
      }
      
      public function __setPerspectiveProjection_(evt:Event) : void
      {
         root.transform.perspectiveProjection.fieldOfView = 122.353662;
         root.transform.perspectiveProjection.projectionCenter = new Point(960,540);
      }
      
      public function playSound(soundID:String) : *
      {
         dispatchEvent(new GameEvent(GameEvent.CALL,"OnPlaySoundEvent",[soundID]));
      }
      
      public function sendNeutralRoundVictoryAchievement() : void
      {
         dispatchEvent(new GameEvent(GameEvent.CALL,"OnNeutralRoundVictoryAchievement"));
      }
      
      public function sendHeroRoundVictoryAchievement() : void
      {
         dispatchEvent(new GameEvent(GameEvent.CALL,"OnHeroRoundVictoryAchievement"));
      }
      
      public function sendKilledItAchievement() : void
      {
         dispatchEvent(new GameEvent(GameEvent.CALL,"OnKilledItAchievement"));
      }
      
      public function showTutorial() : void
      {
         if(this.mcTutorials)
         {
            this.tutorialsOn = true;
            this.mcTutorials.show();
         }
      }
      
      override protected function configUI() : void
      {
         this.mcTutorials.currentTutorialFrame = 7;
         this.mcTutorials.messageQueue = this.mcMessageQueue;
         super.configUI();
         _cardManager.playerRenderers.push(this.mcPlayer1Renderer);
         _cardManager.playerRenderers.push(this.mcPlayer2Renderer);
         dispatchEvent(new GameEvent(GameEvent.REGISTER,"gwint.game.player.deck",[this.setPlayerDeck]));
         dispatchEvent(new GameEvent(GameEvent.REGISTER,"gwint.game.enemy.deck",[this.setEnemyDeck]));
         dispatchEvent(new GameEvent(GameEvent.REGISTER,"gwint.game.cardValues",[this.setCardValues]));
         dispatchEvent(new GameEvent(GameEvent.REGISTER,"gwint.game.toggleAI",[this.setAIEnabled]));
         if(this.mcCloseBtn)
         {
            this.mcCloseBtn.addEventListener(ButtonEvent.PRESS,this.handleClosePressed,false,0,true);
            this.mcCloseBtn.label = "[[gwint_pass_game]]";
         }
         this.gameFlowController.mcMessageQueue = this.mcMessageQueue;
         this.gameFlowController.mcTutorials = this.mcTutorials;
         this.gameFlowController.mcChoiceDialog = this.mcChoiceDialog;
         this.gameFlowController.mcEndGameDialog = this.mcEndGameDialog;
         this.gameFlowController.closeMenuFunctor = this.onGameFlowDone;
         this.gameFlowController.addEventListener(GwintGameFlowController.COIN_TOSS_POPUP_NEEDED,this.chooseCoingPopup,false,0,true);
         InputDelegate.getInstance().addEventListener(InputEvent.INPUT,this.handleInput,false,0,true);
         stage.addEventListener(MouseEvent.CLICK,this.handleMouseClick,false,2,true);
         this.btnSkipTurn.label = "[[qwint_skip_turn]]";
         this.btnSkipTurn.setDataFromStage(NavigationCode.GAMEPAD_Y,KeyCode.SPACE);
         this.btnSkipTurn.holdDuration = SKIP_TURN_HOLD_DELAY;
         this.btnSkipTurn.visible = false;
         this.gameFlowController.skipButton = this.btnSkipTurn;
         this.mcChoiceDialog.visible = false;
         dispatchEvent(new GameEvent(GameEvent.CALL,"OnConfigUI"));
      }
      
      protected function handleClosePressed(event:ButtonEvent) : void
      {
         if(Boolean(this.mcEndGameDialog) && this.mcEndGameDialog.visible)
         {
            this.mcEndGameDialog.closeButtonPressed(null);
         }
         else
         {
            this.tryQuitGame();
         }
      }
      
      override public function handleInput(event:InputEvent) : void
      {
         var i:* = undefined;
         var currentController:BasePlayerController = null;
         if(this.mcTutorials && this.mcTutorials.visible && !this.mcTutorials.isPaused)
         {
            this.mcTutorials.handleInput(event);
            return;
         }
         if(this.gameFlowController.gameStarted)
         {
            for(i = 0; i < this.gameFlowController.playerControllers.length; i++)
            {
               currentController = this.gameFlowController.playerControllers[i];
               if(currentController)
               {
                  currentController.handleUserInput(event);
               }
            }
         }
      }
      
      override protected function handleMouseMove(event:MouseEvent) : void
      {
         var i:* = undefined;
         var currentController:BasePlayerController = null;
         super.handleMouseMove(event);
         if(this.mcTutorials && this.mcTutorials.visible && !this.mcTutorials.isPaused)
         {
            return;
         }
         if(this.gameFlowController.gameStarted)
         {
            for(i = 0; i < this.gameFlowController.playerControllers.length; i++)
            {
               currentController = this.gameFlowController.playerControllers[i];
               if(currentController)
               {
                  currentController.handleMouseMove(event);
               }
            }
         }
      }
      
      public function handleMouseClick(event:MouseEvent) : void
      {
         var i:* = undefined;
         var currentController:BasePlayerController = null;
         if(this.mcTutorials && this.mcTutorials.visible && !this.mcTutorials.isPaused)
         {
            return;
         }
         if(Boolean(this.mcMessageQueue) && this.mcMessageQueue.trySkipMessage())
         {
            return;
         }
         if(this.gameFlowController.gameStarted)
         {
            for(i = 0; i < this.gameFlowController.playerControllers.length; i++)
            {
               currentController = this.gameFlowController.playerControllers[i];
               if(currentController)
               {
                  currentController.handleMouseClick(event);
               }
            }
         }
      }
      
      override protected function handleInputNavigate(event:InputEvent) : void
      {
         if(this.mcTutorials && this.mcTutorials.visible && !this.mcTutorials.isPaused)
         {
            return;
         }
         var details:InputDetails = event.details;
         var keyUp:* = details.value == InputValue.KEY_UP;
         if(!event.handled && keyUp)
         {
            switch(details.navEquivalent)
            {
               case NavigationCode.START:
                  this.tryQuitGame();
                  break;
               case NavigationCode.DPAD_UP:
                  this.testCardsCalculations();
                  break;
               case NavigationCode.GAMEPAD_A:
               case NavigationCode.ENTER:
                  if(Boolean(this.mcMessageQueue) && this.mcMessageQueue.trySkipMessage())
                  {
                     event.handled = true;
                  }
            }
            switch(details.code)
            {
               case KeyCode.Q:
                  this.tryQuitGame();
            }
         }
      }
      
      public function tryQuitGame() : void
      {
         if(this.gameFlowController.stateMachine.currentState != "ShowingFinalResult" && (!this.mcTutorials.visible || this.mcTutorials.isPaused))
         {
            dispatchEvent(new GameEvent(GameEvent.CALL,"OnConfirmSurrender"));
         }
      }
      
      override protected function get menuName() : String
      {
         return "GwintGame";
      }
      
      protected function onGameFlowDone(hasWon:Boolean) : void
      {
         dispatchEvent(new GameEvent(GameEvent.CALL,"OnMatchResult",[hasWon]));
         closeMenu();
      }
      
      public function setPlayerDeck(deckDefinition:Object) : void
      {
         var gwintDeck:GwintDeck = deckDefinition as GwintDeck;
         if(gwintDeck)
         {
            _cardManager.playerDeckDefinitions[CardManager.PLAYER_1] = gwintDeck;
            gwintDeck.DeckRenderer = this.mcP1DeckRenderer;
            return;
         }
         throw new Error("GFX - Invalid type for deckDefinition passed from witcher script (player 1)");
      }
      
      public function setEnemyDeck(deckDefinition:Object) : void
      {
         var gwintDeck:GwintDeck = deckDefinition as GwintDeck;
         if(gwintDeck)
         {
            _cardManager.playerDeckDefinitions[CardManager.PLAYER_2] = gwintDeck;
            gwintDeck.DeckRenderer = this.mcP2DeckRenderer;
            return;
         }
         throw new Error("GFX - Invalid type for deckDefinition passed from witcher script (player 2)");
      }
      
      public function setCardValues(cardValues:Object) : void
      {
         trace("GFX ----------------- cardValues received:",cardValues);
         _cardManager.cardValues = cardValues as GwintCardValues;
      }
      
      public function setAIEnabled(turnAIOn:Boolean) : void
      {
         if(turnAIOn)
         {
            this.gameFlowController.turnOnAI(CardManager.PLAYER_1);
         }
         else
         {
            this.gameFlowController.turnOffAI(CardManager.PLAYER_2);
         }
      }
      
      public function chooseCoingPopup(event:Event) : void
      {
         dispatchEvent(new GameEvent(GameEvent.CALL,"OnChooseCoinFlip"));
      }
      
      public function setFirstTurn(playerFirst:Boolean) : void
      {
         if(playerFirst)
         {
            this.mcMessageQueue.PushMessage("[[gwint_player_will_go_first_message]]");
            this.gameFlowController.currentPlayer = CardManager.PLAYER_1;
         }
         else
         {
            this.mcMessageQueue.PushMessage("[[gwint_opponent_will_go_first]]");
            this.gameFlowController.currentPlayer = CardManager.PLAYER_2;
         }
      }
      
      protected function testCardsCalculations() : void
      {
         var newInstance:CardInstance = null;
         var curTemplate:CardTemplate = null;
         var i:int = 0;
         var cardInstances:Vector.<CardInstance> = new Vector.<CardInstance>();
         trace("GFX --------------------------------------------------------- Commencing card test ---------------------------------------------------------");
         trace("GFX ================================================== Creating temporary card instances ===================================================");
         for each(curTemplate in _cardManager._cardTemplates)
         {
            newInstance = new CardInstance();
            newInstance.templateId = curTemplate.index;
            newInstance.templateRef = curTemplate;
            newInstance.owningPlayer = CardManager.PLAYER_1;
            newInstance.instanceId = 100;
            cardInstances.push(newInstance);
         }
         trace("GFX - Successfully created: " + cardInstances.length + " card instances");
         for(i = 0; i < cardInstances.length; i++)
         {
            trace("GFX - Checking Card with ID: " + cardInstances[i].templateId + " --------------------------");
            trace("GFX ---------------------------------------------------------");
            trace("GFX - template Ref: " + cardInstances[i].templateRef);
            trace("GFX - instance info: " + cardInstances[i]);
            trace("GFX - recalulating optimal transaction for card");
            cardInstances[i].recalculatePowerPotential(_cardManager);
            trace("GFX - successfully recalculated following power info: ");
            trace("GFX - " + cardInstances[i].getOptimalTransaction());
         }
         trace("GFX ================================ Successfully Finished Test of Card Instances ====================================");
         trace("GFX ------------------------------------------------------------------------------------------------------------------");
      }
      
      public function winGwint(result:int) : void
      {
         var gameWinner:int = CardManager.PLAYER_INVALID;
         var playerUser:int = CardManager.PLAYER_1;
         var playerNPC:int = CardManager.PLAYER_2;
         switch(result)
         {
            case 0:
               gameWinner = CardManager.PLAYER_2;
               break;
            case 1:
               gameWinner = CardManager.PLAYER_1;
               break;
            default:
               gameWinner = CardManager.PLAYER_INVALID;
         }
         if(this.gameFlowController)
         {
            this.mcEndGameDialog.show(gameWinner,this.gameFlowController.EndGame);
         }
      }
      
      internal function __setProp_mcBoardRenderer_Scene1_mcBoadRenderer_0() : *
      {
         try
         {
            this.mcBoardRenderer["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         this.mcBoardRenderer.enabled = true;
         this.mcBoardRenderer.enableInitCallback = false;
         this.mcBoardRenderer.slotRendererName = "CardSlotRef";
         this.mcBoardRenderer.visible = true;
         try
         {
            this.mcBoardRenderer["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
      
      internal function __setProp_mcPlayer2Renderer_Scene1_mcPlayer2Renderer_0() : *
      {
         try
         {
            this.mcPlayer2Renderer["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         this.mcPlayer2Renderer.enabled = true;
         this.mcPlayer2Renderer.enableInitCallback = false;
         this.mcPlayer2Renderer.playerID = 1;
         this.mcPlayer2Renderer.playerNameDataProvider = "gwint.player.name.two";
         this.mcPlayer2Renderer.visible = true;
         try
         {
            this.mcPlayer2Renderer["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
      
      internal function __setProp_mcPlayer1Renderer_Scene1_mcPlayer1Renderer_0() : *
      {
         try
         {
            this.mcPlayer1Renderer["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         this.mcPlayer1Renderer.enabled = true;
         this.mcPlayer1Renderer.enableInitCallback = false;
         this.mcPlayer1Renderer.playerID = 0;
         this.mcPlayer1Renderer.playerNameDataProvider = "gwint.player.name.one";
         this.mcPlayer1Renderer.visible = true;
         try
         {
            this.mcPlayer1Renderer["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
      
      internal function __setProp_mcCardFXManager_Scene1_mcCardFXManager_0() : *
      {
         try
         {
            this.mcCardFXManager["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         this.mcCardFXManager.clearWeatherFXName = "CardFXClearSky";
         this.mcCardFXManager.dummyFXName = "CardFXDummy";
         this.mcCardFXManager.enabled = true;
         this.mcCardFXManager.enableInitCallback = false;
         this.mcCardFXManager.fogFXName = "CardFXFog";
         this.mcCardFXManager.frostFXName = "CardFXFrost";
         this.mcCardFXManager.hornFXName = "CardFXHorn";
         this.mcCardFXManager.hornRowFXName = "CardFXHorn_Row";
         this.mcCardFXManager.meleeEnemyRowEffectY = 342;
         this.mcCardFXManager.meleePlayerRowEffectY = 491;
         this.mcCardFXManager.moraleBoostFXName = "CardFXMoraleBoost";
         this.mcCardFXManager.morphFXName = "CardFXMorph";
         this.mcCardFXManager.mushroomFXName = "CardFXMushroom";
         this.mcCardFXManager.placeFiendFXName = "CardFXFiend";
         this.mcCardFXManager.placeHeroFXName = "CardFXHero";
         this.mcCardFXManager.placeMeleeFXName = "CardFXDeploy";
         this.mcCardFXManager.placeRangedFXName = "CardFXDeploy";
         this.mcCardFXManager.placeSeigeFXName = "CardFXDeploy";
         this.mcCardFXManager.placeSpyFXName = "CardFXSpy";
         this.mcCardFXManager.rainFXName = "CardFXRain";
         this.mcCardFXManager.rangedEnemyRowEffectY = 205;
         this.mcCardFXManager.rangedPlayerRowEffectY = 624;
         this.mcCardFXManager.resurrectFXName = "CardFXRessurect";
         this.mcCardFXManager.rowEffectX = 1042;
         this.mcCardFXManager.scorchFXName = "CardFXScorch";
         this.mcCardFXManager.seigeEnemyRowEffectY = 74;
         this.mcCardFXManager.seigePlayerRowEffectY = 762;
         this.mcCardFXManager.summonClonesArriveFXName = "CardFXSummonClonesArrive";
         this.mcCardFXManager.summonClonesFXName = "CardFXSummonClones";
         this.mcCardFXManager.tightBondsFXName = "CardFXTightBonds";
         this.mcCardFXManager.visible = true;
         try
         {
            this.mcCardFXManager["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
      
      internal function __setProp_mcCloseBtn_Scene1_mcCloseBtn_0() : *
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
