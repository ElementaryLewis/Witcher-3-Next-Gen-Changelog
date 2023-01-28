package red.game.witcher3.menus.gwint
{
   import com.gskinner.motion.GTweener;
   import flash.text.TextField;
   import red.core.constants.KeyCode;
   import red.game.witcher3.constants.GwintInputFeedback;
   import red.game.witcher3.controls.InputFeedbackButton;
   import red.game.witcher3.controls.W3UILoader;
   import red.game.witcher3.managers.InputFeedbackManager;
   import scaleform.clik.constants.InputValue;
   import scaleform.clik.constants.NavigationCode;
   import scaleform.clik.core.UIComponent;
   import scaleform.clik.events.ButtonEvent;
   import scaleform.clik.events.InputEvent;
   import scaleform.clik.managers.InputDelegate;
   import scaleform.clik.ui.InputDetails;
   
   public class GwintEndGameDialog extends UIComponent
   {
      
      public static const EndGameDialogResult_EndVictory:int = 0;
      
      public static const EndGameDialogResult_EndDefeat:int = 1;
      
      public static const EndGameDialogResult_Restart:int = 2;
       
      
      public var txtPlayer1Name:TextField;
      
      public var txtPlayer2Name:TextField;
      
      public var txtRound1Title:TextField;
      
      public var txtRound2Title:TextField;
      
      public var txtRound3Title:TextField;
      
      public var txtP1Round1Score:TextField;
      
      public var txtP2Round1Score:TextField;
      
      public var txtP1Round2Score:TextField;
      
      public var txtP2Round2Score:TextField;
      
      public var txtP1Round3Score:TextField;
      
      public var txtP2Round3Score:TextField;
      
      public var mcIconLoader:W3UILoader;
      
      public var mcReplayButton:InputFeedbackButton;
      
      public var mcCloseButton:InputFeedbackButton;
      
      protected var _winningPlayer:int;
      
      protected var _resultFunctor:Function;
      
      private var _btnAccept:int = -1;
      
      private var _btnRestart:int = -1;
      
      public function GwintEndGameDialog()
      {
         super();
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         this.txtRound1Title.text = "[[gwint_round]]";
         this.txtRound2Title.text = this.txtRound1Title.text + " 2";
         this.txtRound3Title.text = this.txtRound1Title.text + " 3";
         this.txtRound1Title.appendText(" 1");
         if(this.mcReplayButton != null)
         {
            this.mcReplayButton.clickable = true;
            this.mcReplayButton.label = "[[gwint_play_again]]";
            this.mcReplayButton.setDataFromStage(NavigationCode.GAMEPAD_Y,KeyCode.SPACE);
            this.mcReplayButton.addEventListener(ButtonEvent.PRESS,this.onReplayPressed,false,0,true);
            this.mcReplayButton.validateNow();
         }
         if(this.mcCloseButton != null)
         {
            this.mcCloseButton.clickable = true;
            this.mcCloseButton.label = "[[panel_button_common_close]]";
            this.mcCloseButton.setDataFromStage(NavigationCode.GAMEPAD_B,KeyCode.ESCAPE);
            this.mcCloseButton.addEventListener(ButtonEvent.PRESS,this.closeButtonPressed,false,0,true);
            this.mcCloseButton.validateNow();
         }
         visible = false;
      }
      
      public function show(winningPlayer:int, callback:Function) : void
      {
         this._winningPlayer = winningPlayer;
         this._resultFunctor = callback;
         alpha = 0;
         visible = true;
         GwintGameMenu.mSingleton.mcCloseBtn.visible = false;
         GTweener.removeTweens(this);
         GTweener.to(this,0.2,{"alpha":1},{});
         if(winningPlayer == CardManager.PLAYER_1)
         {
            if(this.mcIconLoader)
            {
               this.mcIconLoader.x = 703.8;
               this.mcIconLoader.y = 79.35;
               this.mcIconLoader.source = "img://icons\\gwint\\results\\battle_victory.png";
            }
            gotoAndPlay("Victory");
         }
         else if(winningPlayer == CardManager.PLAYER_2)
         {
            if(this.mcIconLoader)
            {
               this.mcIconLoader.x = 702.05;
               this.mcIconLoader.y = 47.8;
               this.mcIconLoader.source = "img://icons\\gwint\\results\\battle_defeat.png";
            }
            gotoAndPlay("Defeat");
         }
         else
         {
            if(this.mcIconLoader)
            {
               this.mcIconLoader.x = 705.95;
               this.mcIconLoader.y = 29;
               this.mcIconLoader.source = "img://icons\\gwint\\results\\battle_draw.png";
            }
            gotoAndPlay("Draw");
         }
         this.setPlayerScores();
         this.updatePlayerNames();
         this.showInputFeedback();
         InputDelegate.getInstance().addEventListener(InputEvent.INPUT,this.handleInputDialog,false,0,true);
      }
      
      public function hide() : void
      {
         if(visible)
         {
            GTweener.removeTweens(this);
            GwintGameMenu.mSingleton.mcCloseBtn.visible = true;
            GTweener.to(this,0.2,{"alpha":0},{});
            InputDelegate.getInstance().removeEventListener(InputEvent.INPUT,this.handleInputDialog);
            this.hideInputFeedback();
         }
      }
      
      protected function setPlayerScores() : void
      {
         var i:int = 0;
         var p1RoundTextField:TextField = null;
         var p2RoundTextField:TextField = null;
         var cardManagerRef:CardManager = CardManager.getInstance();
         if(cardManagerRef)
         {
            if(cardManagerRef.roundResults.length < 3)
            {
               throw new Error("GFX - Tried to set Player scores in end game dialog but not enough round data available! " + cardManagerRef.roundResults.length);
            }
            this.updateTextFieldsWithRoundResult(cardManagerRef.roundResults[0],this.txtP1Round1Score,this.txtP2Round1Score);
            this.updateTextFieldsWithRoundResult(cardManagerRef.roundResults[1],this.txtP1Round2Score,this.txtP2Round2Score);
            this.updateTextFieldsWithRoundResult(cardManagerRef.roundResults[2],this.txtP1Round3Score,this.txtP2Round3Score);
         }
      }
      
      protected function updateTextFieldsWithRoundResult(curResult:GwintRoundResult, p1RoundTextField:TextField, p2RoundTextField:TextField) : *
      {
         if(curResult.played)
         {
            p1RoundTextField.text = curResult.getPlayerScore(CardManager.PLAYER_1).toString();
            p2RoundTextField.text = curResult.getPlayerScore(CardManager.PLAYER_2).toString();
            if(curResult.winningPlayer == CardManager.PLAYER_1)
            {
               p1RoundTextField.textColor = 14722621;
            }
            else
            {
               p1RoundTextField.textColor = 12763584;
            }
            if(curResult.winningPlayer == CardManager.PLAYER_2)
            {
               p2RoundTextField.textColor = 14722621;
            }
            else
            {
               p2RoundTextField.textColor = 12763584;
            }
         }
         else
         {
            p1RoundTextField.text = "-";
            p2RoundTextField.text = "-";
         }
      }
      
      protected function updatePlayerNames() : void
      {
         var cardManagerRef:CardManager = CardManager.getInstance();
         if(cardManagerRef)
         {
            this.txtPlayer1Name.text = cardManagerRef.playerRenderers[CardManager.PLAYER_1].playerName;
            this.txtPlayer2Name.text = cardManagerRef.playerRenderers[CardManager.PLAYER_2].playerName;
         }
      }
      
      protected function showInputFeedback() : void
      {
         InputFeedbackManager.cleanupButtons();
         if(!GwintGameMenu.mSingleton.mcTutorials.visible)
         {
            if(this.mcReplayButton != null)
            {
               if(this._winningPlayer == CardManager.PLAYER_INVALID)
               {
                  this.mcReplayButton.visible = true;
               }
               else
               {
                  this.mcReplayButton.visible = false;
               }
            }
            if(this.mcCloseButton != null)
            {
               this.mcCloseButton.enabled = true;
               this.mcCloseButton.visible = true;
            }
         }
         else
         {
            if(this.mcCloseButton != null)
            {
               this.mcCloseButton.visible = false;
            }
            GwintGameMenu.mSingleton.mcTutorials.onHideCallback = this.showInputFeedback;
         }
      }
      
      protected function hideInputFeedback() : void
      {
         InputFeedbackManager.removeButtonById(GwintInputFeedback.restart);
         InputFeedbackManager.removeButtonById(GwintInputFeedback.close);
      }
      
      public function closeButtonPressed(event:ButtonEvent) : void
      {
         if(this._winningPlayer == CardManager.PLAYER_2 || this._winningPlayer == CardManager.PLAYER_INVALID)
         {
            this._resultFunctor(EndGameDialogResult_EndDefeat);
         }
         else
         {
            this._resultFunctor(EndGameDialogResult_EndVictory);
         }
         this.hide();
      }
      
      private function handleInputDialog(event:InputEvent) : void
      {
         var details:InputDetails = null;
         var keyUp:* = false;
         if(visible && !GwintGameMenu.mSingleton.mcTutorials.visible)
         {
            details = event.details;
            keyUp = details.value == InputValue.KEY_UP;
            if(keyUp && !event.handled && this._resultFunctor != null)
            {
               switch(details.navEquivalent)
               {
                  case NavigationCode.GAMEPAD_B:
                     this.closeButtonPressed(null);
                     break;
                  case NavigationCode.GAMEPAD_Y:
                     this.onReplayPressed(null);
               }
               if(details.code == KeyCode.SPACE)
               {
                  if(this._winningPlayer == CardManager.PLAYER_INVALID)
                  {
                     this._resultFunctor(EndGameDialogResult_Restart);
                     this.hide();
                  }
               }
            }
         }
      }
      
      protected function onReplayPressed(event:ButtonEvent) : void
      {
         if(this._winningPlayer == CardManager.PLAYER_INVALID)
         {
            this._resultFunctor(EndGameDialogResult_Restart);
            this.hide();
         }
      }
   }
}
