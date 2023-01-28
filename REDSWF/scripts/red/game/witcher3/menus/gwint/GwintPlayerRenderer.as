package red.game.witcher3.menus.gwint
{
   import flash.display.MovieClip;
   import red.core.events.GameEvent;
   import red.game.witcher3.constants.CommonConstants;
   import red.game.witcher3.controls.W3TextArea;
   import scaleform.clik.core.UIComponent;
   
   public class GwintPlayerRenderer extends UIComponent
   {
       
      
      public var txtPassed:W3TextArea;
      
      public var mcPassed:MovieClip;
      
      public var txtPlayerName:W3TextArea;
      
      public var txtFactionName:W3TextArea;
      
      public var txtCardCount:W3TextArea;
      
      public var mcPlayerPortrait:MovieClip;
      
      public var mcScore:MovieClip;
      
      public var mcLifeIndicator:MovieClip;
      
      public var mcFactionIcon:MovieClip;
      
      public var mcWinningRound:MovieClip;
      
      protected var _playerNameDataProvider:String = "INVALID_STRING_PARAM!";
      
      protected var _playerID:int;
      
      private var _score:int = -1;
      
      private var _turnActive:Boolean = false;
      
      protected var _lastSetPlayerLives:int = -1;
      
      protected var passedShown:Boolean = false;
      
      public function GwintPlayerRenderer()
      {
         this._playerID = CardManager.PLAYER_INVALID;
         super();
      }
      
      public function set playerName(value:String) : void
      {
         this.txtPlayerName.text = value;
      }
      
      public function get playerName() : String
      {
         return this.txtPlayerName.text;
      }
      
      public function get playerNameDataProvider() : String
      {
         return this._playerNameDataProvider;
      }
      
      public function set playerNameDataProvider(value:String) : void
      {
         this._playerNameDataProvider = value;
      }
      
      public function get playerID() : int
      {
         return this._playerID;
      }
      
      public function set playerID(value:int) : void
      {
         this._playerID = value;
         if(this.mcPlayerPortrait)
         {
            if(this._playerID == CardManager.PLAYER_1)
            {
               this.mcPlayerPortrait.gotoAndStop("geralt");
            }
            else
            {
               this.mcPlayerPortrait.gotoAndStop("npc");
            }
         }
      }
      
      public function set score(value:int) : void
      {
         var scoreTextArea:W3TextArea = null;
         if(this._score != value)
         {
            if(this.mcScore.currentFrameLabel == "Idle")
            {
               if(this._score < value)
               {
                  this.mcScore.gotoAndPlay("Grew");
               }
               else
               {
                  this.mcScore.gotoAndPlay("Shrank");
               }
            }
            this._score = value;
            scoreTextArea = this.mcScore.getChildByName("txtScore") as W3TextArea;
            if(scoreTextArea)
            {
               scoreTextArea.text = this._score.toString();
            }
         }
      }
      
      public function set numCardsInHand(value:int) : void
      {
         this.txtCardCount.text = value.toString();
      }
      
      public function set turnActive(value:Boolean) : void
      {
         if(value != this._turnActive)
         {
            this._turnActive = value;
            if(this._turnActive)
            {
               gotoAndPlay("Selected");
            }
            else
            {
               gotoAndPlay("Idle");
            }
         }
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         if(this._playerNameDataProvider != CommonConstants.INVALID_STRING_PARAM)
         {
            dispatchEvent(new GameEvent(GameEvent.REGISTER,this._playerNameDataProvider,[this.setPlayerName]));
         }
         if(this.mcPassed)
         {
            this.txtPassed = this.mcPassed.getChildByName("txtPassed") as W3TextArea;
         }
         if(this.mcWinningRound)
         {
            this.mcWinningRound.stop();
            this.mcWinningRound.visible = false;
         }
         this.reset();
      }
      
      protected function setPlayerName(value:String) : void
      {
         this.playerName = value;
      }
      
      public function setPlayerLives(value:int) : void
      {
         var gem1:MovieClip = null;
         var gem2:MovieClip = null;
         trace("GFX - Updating life for Player: " + this.playerName + ", to: " + value + " and life indicator: " + this.mcLifeIndicator);
         if(this._lastSetPlayerLives != value)
         {
            this._lastSetPlayerLives = value;
            gem1 = this.mcLifeIndicator.getChildByName("mcLifeGemAnim1") as MovieClip;
            gem2 = this.mcLifeIndicator.getChildByName("mcLifeGemAnim2") as MovieClip;
            switch(value)
            {
               case 0:
                  if(gem2.currentLabel != "play")
                  {
                     gem2.gotoAndPlay("play");
                  }
                  if(gem1.currentLabel != "play")
                  {
                     gem1.gotoAndPlay("play");
                  }
                  break;
               case 1:
                  if(gem2.currentLabel != "visible")
                  {
                     gem2.gotoAndStop("visible");
                  }
                  if(gem1.currentLabel != "play")
                  {
                     gem1.gotoAndPlay("play");
                  }
                  break;
               case 2:
                  if(gem2.currentLabel != "visible")
                  {
                     gem2.gotoAndStop("visible");
                  }
                  if(gem1.currentLabel != "visible")
                  {
                     gem1.gotoAndStop("visible");
                  }
            }
         }
      }
      
      public function showPassed(shouldShow:Boolean) : void
      {
         if(this.txtPassed)
         {
            this.txtPassed.visible = shouldShow;
         }
         if(this.mcPassed)
         {
            if(shouldShow)
            {
               if(!this.passedShown)
               {
                  GwintGameMenu.mSingleton.playSound("gui_gwint_turn_passed");
               }
               this.passedShown = true;
               this.mcPassed.gotoAndPlay("passed");
            }
            else
            {
               this.passedShown = false;
               this.mcPassed.gotoAndStop("Idle");
            }
         }
      }
      
      public function setIsWinning(isWinning:Boolean) : void
      {
         if(this.mcWinningRound)
         {
            if(isWinning)
            {
               this.mcWinningRound.visible = true;
               this.mcWinningRound.play();
            }
            else
            {
               this.mcWinningRound.visible = false;
               this.mcWinningRound.stop();
            }
         }
      }
      
      public function reset() : void
      {
         if(this.txtPassed)
         {
            this.txtPassed.text = "[[gwint_player_passed_element]]";
            this.txtPassed.visible = false;
         }
         this.score = 0;
         this.setPlayerLives(2);
         this.txtCardCount.text = "0";
      }
   }
}
