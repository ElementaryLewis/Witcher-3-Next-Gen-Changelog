package red.game.witcher3.menus.gwint
{
   import flash.display.MovieClip;
   import flash.events.TimerEvent;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   import flash.utils.getDefinitionByName;
   import scaleform.clik.core.UIComponent;
   
   public class CardFXManager extends UIComponent
   {
      
      protected static var _instance:CardFXManager;
      
      private static var _instanceIDGenerator:int = 0;
       
      
      private var effectDictionary:Dictionary;
      
      private var numEffectsPlaying:int = 0;
      
      private var weatherParent:MovieClip;
      
      public var activeFXDictionary:Dictionary;
      
      private var weatherMeleeOngoing_Active:Boolean = false;
      
      private var weatherRangedOngoing_Active:Boolean = false;
      
      private var weatherSeigeOngoing_Active:Boolean = false;
      
      public var weatherMeleeP1Ongoing:MovieClip;
      
      public var weatherMeleeP2Ongoing:MovieClip;
      
      public var weatherRangedP1Ongoing:MovieClip;
      
      public var weatherRangedP2Ongoing:MovieClip;
      
      public var weatherSeigeP1Ongoing:MovieClip;
      
      public var weatherSeigeP2Ongoing:MovieClip;
      
      protected var hidingWeatherMeleeTimer:Timer;
      
      protected var hidingWeatherRangedTimer:Timer;
      
      protected var hidingWeatherSiegeTimer:Timer;
      
      protected var _frostFXName:String;
      
      public var _frostFXClassRef:Class;
      
      protected var _fogFXName:String;
      
      public var _fogFXClassRef:Class;
      
      protected var _rainFXName:String;
      
      public var _rainFXClassRef:Class;
      
      protected var _clearWeatherFXName:String;
      
      public var _clearWeatherFXClassRef:Class;
      
      protected var _hornFXName:String;
      
      public var _hornFXClassRef:Class;
      
      protected var _scorchFXName:String;
      
      public var _scorchFXClassRef:Class;
      
      protected var _dummyFXName:String;
      
      public var _dummyFXClassRef:Class;
      
      protected var _placeMeleeFXName:String;
      
      public var _placeMeleeFXClassRef:Class;
      
      protected var _placeRangedFXName:String;
      
      public var _placeRangedFXClassRef:Class;
      
      protected var _placeSeigeFXName:String;
      
      public var _placeSeigeFXClassRef:Class;
      
      protected var _placeSpyFXName:String;
      
      public var _placeSpyFXClassRef:Class;
      
      protected var _placeFiendFXName:String;
      
      public var _placeFiendFXClassRef:Class;
      
      protected var _placeHeroFXName:String;
      
      public var _placeHeroFXClassRef:Class;
      
      protected var _resurrectFXName:String;
      
      public var _resurrectFXClassRef:Class;
      
      protected var _summonClonesFXName:String;
      
      public var _summonClonesFXClassRef:Class;
      
      protected var _moraleBoostFXName:String;
      
      public var _moraleBoostFXClassRef:Class;
      
      protected var _tightBondsFXName:String;
      
      public var _tightBondsFXClassRef:Class;
      
      protected var _summonClonesArriveFX:String;
      
      public var _summonClonesArriveFXClassRef:Class;
      
      protected var _hornRowFXName:String;
      
      public var _hornRowFXClassRef:Class;
      
      protected var _mushroomRowFXName:String;
      
      public var _mushroomFXClassRef:Class;
      
      protected var _morphRowFXName:String;
      
      public var _morphFXClassRef:Class;
      
      protected var _rowEffectX:Number;
      
      protected var _seigeEnemyRowEffectY:Number;
      
      protected var _rangedEnemyRowEffectY:Number;
      
      protected var _meleeEnemyRowEffectY:Number;
      
      protected var _meleePlayerRowEffectY:Number;
      
      protected var _rangedPlayerRowEffectY:Number;
      
      protected var _seigePlayerRowEffectY:Number;
      
      public function CardFXManager()
      {
         this.effectDictionary = new Dictionary();
         this.activeFXDictionary = new Dictionary();
         super();
      }
      
      public static function getInstance() : CardFXManager
      {
         return _instance;
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         _instance = this;
         mouseEnabled = false;
         mouseChildren = false;
         this.setupWeatherEffects();
      }
      
      public function playCardDeployFX(cardInstance:CardInstance, finishedCallback:Function) : void
      {
         var fxClass:Class = null;
         if(cardInstance.playSummonedFX)
         {
            fxClass = this._summonClonesArriveFXClassRef;
            cardInstance.playSummonedFX = false;
            if(cardInstance.templateRef.isType(CardTemplate.CardType_Siege))
            {
               GwintGameMenu.mSingleton.playSound("gui_gwint_siege_weapon");
            }
            else if(cardInstance.templateRef.isType(CardTemplate.CardType_Ranged))
            {
               GwintGameMenu.mSingleton.playSound("gui_gwint_long_range");
            }
            else if(cardInstance.templateRef.isType(CardTemplate.CardType_Melee))
            {
               GwintGameMenu.mSingleton.playSound("gui_gwint_close_combat");
            }
         }
         else
         {
            fxClass = this.getDeployFX(cardInstance);
         }
         if(fxClass)
         {
            this.spawnFX(cardInstance,finishedCallback,fxClass);
         }
         else
         {
            finishedCallback(cardInstance);
            trace("GFX ---- [WARNING] ---- CardFXManager tried to play Card Deploy FX with no matching fxClass: " + cardInstance.toString());
         }
      }
      
      public function playerCardEffectFX(cardInstance:CardInstance, finishedCallback:Function) : CardFX
      {
         var spawnedFX:CardFX = null;
         var fxClass:Class = this.getEffectFX(cardInstance.templateRef);
         if(fxClass)
         {
            return this.spawnFX(cardInstance,finishedCallback,fxClass);
         }
         finishedCallback(cardInstance);
         trace("GFX ---- [WARNING] ---- CardFXManager tried to play Card Effect FX with no matching fxClass: " + cardInstance.toString());
         return null;
      }
      
      public function playRessurectEffectFX(cardInstance:CardInstance, finishedCallback:Function) : void
      {
         if(this._resurrectFXClassRef)
         {
            this.spawnFX(cardInstance,finishedCallback,this._resurrectFXClassRef);
         }
         else
         {
            finishedCallback(cardInstance);
            trace("GFX ---- [WARNING] ---- CardFXManager tried to play Card Resurrect FX with no matching fxClass: " + cardInstance.toString());
         }
      }
      
      public function playScorchEffectFX(cardInstance:CardInstance, finishedCallback:Function) : void
      {
         if(this._scorchFXClassRef)
         {
            this.spawnFX(cardInstance,finishedCallback,this._scorchFXClassRef);
         }
         else
         {
            trace("GFX ---- [WARNING] ---- CardFXManager tried to play Card Scorch FX with no matching fxClass: " + cardInstance.toString());
            finishedCallback(cardInstance);
         }
      }
      
      public function playTightBondsFX(cardInstance:CardInstance, finishedCallback:Function) : void
      {
         if(this._tightBondsFXClassRef)
         {
            this.spawnFX(cardInstance,finishedCallback,this._tightBondsFXClassRef);
         }
         else
         {
            trace("GFX ---- [WARNING] ---- CardFXManager tried to play Tight Bonds FX with no matching fxClass: " + cardInstance.toString());
            finishedCallback(cardInstance);
         }
      }
      
      public function spawnFX_Location(xLocation:int, yLocation:int, targetClass:Class) : void
      {
         var newInstanceID:int = int(++_instanceIDGenerator);
         var newCardFX:CardFX = new targetClass();
         newCardFX.associatedCardInstance = null;
         newCardFX.instanceID = newInstanceID;
         newCardFX.cardFXManagerFinishCallback = this.finishedFXCallback;
         this.addChild(newCardFX);
         this.addChild(this.weatherParent);
         newCardFX.x = xLocation;
         newCardFX.y = yLocation;
         newCardFX.play();
         ++this.numEffectsPlaying;
      }
      
      public function spawnFX(cardInstance:CardInstance, finishedCallback:Function, targetClass:Class) : CardFX
      {
         var cardSlot:CardSlot = null;
         var newInstanceID:int = int(++_instanceIDGenerator);
         var newCardFX:CardFX = new targetClass();
         newCardFX.associatedCardInstance = cardInstance;
         newCardFX.instanceID = newInstanceID;
         newCardFX.finalFinishCallback = finishedCallback;
         newCardFX.cardFXManagerFinishCallback = this.finishedFXCallback;
         this.addChild(newCardFX);
         this.addChild(this.weatherParent);
         if(cardInstance != null && !cardInstance.templateRef.isType(CardTemplate.CardType_Weather))
         {
            cardSlot = CardManager.getInstance().boardRenderer.getCardSlotById(cardInstance.instanceId);
            if(cardSlot)
            {
               newCardFX.x = cardSlot.x;
               newCardFX.y = cardSlot.y;
            }
         }
         else
         {
            newCardFX.x = 0;
            newCardFX.y = 0;
         }
         newCardFX.play();
         ++this.numEffectsPlaying;
         return newCardFX;
      }
      
      protected function finishedFXCallback(cardFX:CardFX) : void
      {
         if(cardFX.finalFinishCallback != null)
         {
            cardFX.finalFinishCallback(cardFX.associatedCardInstance);
         }
         removeChild(cardFX);
         --this.numEffectsPlaying;
         this.effectDictionary[cardFX.instanceID] = null;
      }
      
      public function isPlayingAnyCardFX() : Boolean
      {
         return this.numEffectsPlaying > 0;
      }
      
      public function playRowEffect(slotID:int, playerID:int, targetClass:Class) : CardFX
      {
         var yPos:Number = NaN;
         var newCardFX:CardFX = new targetClass();
         if(newCardFX)
         {
            newCardFX.cardFXManagerFinishCallback = this.finishedFXCallback;
            this.addChild(newCardFX);
            this.addChild(this.weatherParent);
            if(playerID == CardManager.PLAYER_1)
            {
               switch(slotID)
               {
                  case CardManager.CARD_LIST_LOC_SEIGE:
                  case CardManager.CARD_LIST_LOC_SEIGEMODIFIERS:
                     yPos = this._seigePlayerRowEffectY;
                     break;
                  case CardManager.CARD_LIST_LOC_RANGED:
                  case CardManager.CARD_LIST_LOC_RANGEDMODIFIERS:
                     yPos = this._rangedPlayerRowEffectY;
                     break;
                  case CardManager.CARD_LIST_LOC_MELEE:
                  case CardManager.CARD_LIST_LOC_MELEEMODIFIERS:
                     yPos = this._meleePlayerRowEffectY;
               }
            }
            else if(playerID == CardManager.PLAYER_2)
            {
               switch(slotID)
               {
                  case CardManager.CARD_LIST_LOC_SEIGE:
                  case CardManager.CARD_LIST_LOC_SEIGEMODIFIERS:
                     yPos = this._seigeEnemyRowEffectY;
                     break;
                  case CardManager.CARD_LIST_LOC_RANGED:
                  case CardManager.CARD_LIST_LOC_RANGEDMODIFIERS:
                     yPos = this._rangedEnemyRowEffectY;
                     break;
                  case CardManager.CARD_LIST_LOC_MELEE:
                  case CardManager.CARD_LIST_LOC_MELEEMODIFIERS:
                     yPos = this._meleeEnemyRowEffectY;
               }
            }
            newCardFX.x = this._rowEffectX;
            newCardFX.y = yPos;
            newCardFX.play();
            ++this.numEffectsPlaying;
         }
         return newCardFX;
      }
      
      protected function setupWeatherEffects() : void
      {
         this.weatherParent = new MovieClip();
         this.addChild(this.weatherParent);
         this.weatherParent.addChild(this.weatherMeleeP1Ongoing);
         this.weatherParent.addChild(this.weatherMeleeP2Ongoing);
         this.weatherParent.addChild(this.weatherRangedP1Ongoing);
         this.weatherParent.addChild(this.weatherRangedP2Ongoing);
         this.weatherParent.addChild(this.weatherSeigeP1Ongoing);
         this.weatherParent.addChild(this.weatherSeigeP2Ongoing);
      }
      
      public function ShowWeatherOngoing(slotID:int, value:Boolean) : void
      {
         trace("GFX -------------------------------------------------------===================================");
         trace("GFX - ShowWeatherOngoing called for slot: " + slotID + ", with value: " + value);
         if(slotID == CardManager.CARD_LIST_LOC_MELEE)
         {
            if(value)
            {
               if(this.hidingWeatherMeleeTimer)
               {
                  this.hidingWeatherMeleeTimer.stop();
                  this.hidingWeatherMeleeTimer = null;
               }
               if(!this.weatherMeleeOngoing_Active)
               {
                  trace("GFX - calling gotoAndPlay(start)");
                  this.weatherMeleeOngoing_Active = true;
                  this.weatherMeleeP1Ongoing.gotoAndPlay("start");
                  this.weatherMeleeP2Ongoing.gotoAndPlay("start");
               }
            }
            else if(!this.hidingWeatherMeleeTimer && this.weatherMeleeOngoing_Active)
            {
               trace("GFX - starting stop timer");
               this.hidingWeatherMeleeTimer = new Timer(300,1);
               this.hidingWeatherMeleeTimer.addEventListener(TimerEvent.TIMER,this.hiddingMeleeWeatherTimerEnded,false,0,true);
               this.hidingWeatherMeleeTimer.start();
            }
         }
         else if(slotID == CardManager.CARD_LIST_LOC_RANGED)
         {
            if(value)
            {
               if(this.hidingWeatherRangedTimer)
               {
                  this.hidingWeatherRangedTimer.stop();
                  this.hidingWeatherRangedTimer = null;
               }
               if(!this.weatherRangedOngoing_Active)
               {
                  this.weatherRangedOngoing_Active = true;
                  trace("GFX - calling gotoAndPlay(start)");
                  this.weatherRangedP1Ongoing.gotoAndPlay("start");
                  this.weatherRangedP2Ongoing.gotoAndPlay("start");
               }
            }
            else if(!this.hidingWeatherRangedTimer && this.weatherRangedOngoing_Active)
            {
               trace("GFX - starting stop timer");
               this.hidingWeatherRangedTimer = new Timer(300,1);
               this.hidingWeatherRangedTimer.addEventListener(TimerEvent.TIMER,this.hiddingRangeWeatherTimerEnded,false,0,true);
               this.hidingWeatherRangedTimer.start();
            }
         }
         else if(slotID == CardManager.CARD_LIST_LOC_SEIGE)
         {
            if(value)
            {
               if(this.hidingWeatherSiegeTimer)
               {
                  this.hidingWeatherSiegeTimer.stop();
                  this.hidingWeatherSiegeTimer = null;
               }
               if(!this.weatherSeigeOngoing_Active)
               {
                  this.weatherSeigeOngoing_Active = true;
                  trace("GFX - calling gotoAndPlay(start)");
                  this.weatherSeigeP1Ongoing.gotoAndPlay("start");
                  this.weatherSeigeP2Ongoing.gotoAndPlay("start");
               }
            }
            else if(!this.hidingWeatherSiegeTimer && this.weatherSeigeOngoing_Active)
            {
               trace("GFX - starting stop timer");
               this.hidingWeatherSiegeTimer = new Timer(300,1);
               this.hidingWeatherSiegeTimer.addEventListener(TimerEvent.TIMER,this.hiddingSiegeWeatherTimerEnded,false,0,true);
               this.hidingWeatherSiegeTimer.start();
            }
         }
         trace("GFX ===================================-------------------------------------------------------");
      }
      
      public function hiddingMeleeWeatherTimerEnded(event:TimerEvent) : *
      {
         if(this.weatherMeleeOngoing_Active)
         {
            this.weatherMeleeOngoing_Active = false;
            this.weatherMeleeP1Ongoing.gotoAndPlay("ending");
            this.weatherMeleeP2Ongoing.gotoAndPlay("ending");
            trace("GFX - calling gotoAndPlay(ending) - Melee");
            this.hidingWeatherMeleeTimer.stop();
            this.hidingWeatherMeleeTimer = null;
         }
      }
      
      public function hiddingRangeWeatherTimerEnded(event:TimerEvent) : *
      {
         if(this.weatherRangedOngoing_Active)
         {
            this.weatherRangedOngoing_Active = false;
            this.weatherRangedP1Ongoing.gotoAndPlay("ending");
            this.weatherRangedP2Ongoing.gotoAndPlay("ending");
            trace("GFX - calling gotoAndPlay(ending) - Ranged");
            this.hidingWeatherRangedTimer.stop();
            this.hidingWeatherRangedTimer = null;
         }
      }
      
      public function hiddingSiegeWeatherTimerEnded(event:TimerEvent) : *
      {
         if(this.weatherSeigeOngoing_Active)
         {
            this.weatherSeigeOngoing_Active = false;
            this.weatherSeigeP1Ongoing.gotoAndPlay("ending");
            this.weatherSeigeP2Ongoing.gotoAndPlay("ending");
            trace("GFX - calling gotoAndPlay(ending) - Siege");
            this.hidingWeatherSiegeTimer.stop();
            this.hidingWeatherSiegeTimer = null;
         }
      }
      
      public function get frostFXName() : String
      {
         return this._frostFXName;
      }
      
      public function set frostFXName(value:String) : void
      {
         if(this._frostFXName != value)
         {
            this._frostFXName = value;
            try
            {
               this._frostFXClassRef = getDefinitionByName(value) as Class;
            }
            catch(er:Error)
            {
               trace("GFX Can\'t find class definition in your library for " + value);
            }
         }
      }
      
      public function get fogFXName() : String
      {
         return this._fogFXName;
      }
      
      public function set fogFXName(value:String) : void
      {
         if(this._fogFXName != value)
         {
            this._fogFXName = value;
            try
            {
               this._fogFXClassRef = getDefinitionByName(value) as Class;
            }
            catch(er:Error)
            {
               trace("GFX Can\'t find class definition in your library for " + value);
            }
         }
      }
      
      public function get rainFXName() : String
      {
         return this._rainFXName;
      }
      
      public function set rainFXName(value:String) : void
      {
         if(this._rainFXName != value)
         {
            this._rainFXName = value;
            try
            {
               this._rainFXClassRef = getDefinitionByName(value) as Class;
            }
            catch(er:Error)
            {
               trace("GFX Can\'t find class definition in your library for " + value);
            }
         }
      }
      
      public function get clearWeatherFXName() : String
      {
         return this._clearWeatherFXName;
      }
      
      public function set clearWeatherFXName(value:String) : void
      {
         if(this._clearWeatherFXName != value)
         {
            this._clearWeatherFXName = value;
            try
            {
               this._clearWeatherFXClassRef = getDefinitionByName(value) as Class;
            }
            catch(er:Error)
            {
               trace("GFX Can\'t find class definition in your library for " + value);
            }
         }
      }
      
      public function get hornFXName() : String
      {
         return this._hornFXName;
      }
      
      public function set hornFXName(value:String) : void
      {
         if(this._hornFXName != value)
         {
            this._hornFXName = value;
            try
            {
               this._hornFXClassRef = getDefinitionByName(value) as Class;
            }
            catch(er:Error)
            {
               trace("GFX Can\'t find class definition in your library for " + value);
            }
         }
      }
      
      public function get scorchFXName() : String
      {
         return this._scorchFXName;
      }
      
      public function set scorchFXName(value:String) : void
      {
         if(this._scorchFXName != value)
         {
            this._scorchFXName = value;
            try
            {
               this._scorchFXClassRef = getDefinitionByName(value) as Class;
            }
            catch(er:Error)
            {
               trace("GFX Can\'t find class definition in your library for " + value);
            }
         }
      }
      
      public function get dummyFXName() : String
      {
         return this._dummyFXName;
      }
      
      public function set dummyFXName(value:String) : void
      {
         if(this._dummyFXName != value)
         {
            this._dummyFXName = value;
            try
            {
               this._dummyFXClassRef = getDefinitionByName(value) as Class;
            }
            catch(er:Error)
            {
               trace("GFX Can\'t find class definition in your library for " + value);
            }
         }
      }
      
      public function get placeMeleeFXName() : String
      {
         return this._placeMeleeFXName;
      }
      
      public function set placeMeleeFXName(value:String) : void
      {
         if(this._placeMeleeFXName != value)
         {
            this._placeMeleeFXName = value;
            try
            {
               this._placeMeleeFXClassRef = getDefinitionByName(value) as Class;
            }
            catch(er:Error)
            {
               trace("GFX Can\'t find class definition in your library for " + value);
            }
         }
      }
      
      public function get placeRangedFXName() : String
      {
         return this._placeRangedFXName;
      }
      
      public function set placeRangedFXName(value:String) : void
      {
         if(this._placeRangedFXName != value)
         {
            this._placeRangedFXName = value;
            try
            {
               this._placeRangedFXClassRef = getDefinitionByName(value) as Class;
            }
            catch(er:Error)
            {
               trace("GFX Can\'t find class definition in your library for " + value);
            }
         }
      }
      
      public function get placeSeigeFXName() : String
      {
         return this._placeSeigeFXName;
      }
      
      public function set placeSeigeFXName(value:String) : void
      {
         if(this._placeSeigeFXName != value)
         {
            this._placeSeigeFXName = value;
            try
            {
               this._placeSeigeFXClassRef = getDefinitionByName(value) as Class;
            }
            catch(er:Error)
            {
               trace("GFX Can\'t find class definition in your library for " + value);
            }
         }
      }
      
      public function get placeSpyFXName() : String
      {
         return this._placeSpyFXName;
      }
      
      public function set placeSpyFXName(value:String) : void
      {
         if(this._placeSpyFXName != value)
         {
            this._placeSpyFXName = value;
            try
            {
               this._placeSpyFXClassRef = getDefinitionByName(value) as Class;
            }
            catch(er:Error)
            {
               trace("GFX Can\'t find class definition in your library for " + value);
            }
         }
      }
      
      public function get placeFiendFXName() : String
      {
         return this._placeFiendFXName;
      }
      
      public function set placeFiendFXName(value:String) : void
      {
         if(this._placeFiendFXName != value)
         {
            this._placeFiendFXName = value;
            try
            {
               this._placeFiendFXClassRef = getDefinitionByName(value) as Class;
            }
            catch(er:Error)
            {
               trace("GFX Can\'t find class definition in your library for " + value);
            }
         }
      }
      
      public function get placeHeroFXName() : String
      {
         return this._placeHeroFXName;
      }
      
      public function set placeHeroFXName(value:String) : void
      {
         if(this._placeHeroFXName != value)
         {
            this._placeHeroFXName = value;
            try
            {
               this._placeHeroFXClassRef = getDefinitionByName(value) as Class;
            }
            catch(er:Error)
            {
               trace("GFX Can\'t find class definition in your library for " + value);
            }
         }
      }
      
      public function get resurrectFXName() : String
      {
         return this._resurrectFXName;
      }
      
      public function set resurrectFXName(value:String) : void
      {
         if(this._resurrectFXName != value)
         {
            this._resurrectFXName = value;
            try
            {
               this._resurrectFXClassRef = getDefinitionByName(value) as Class;
            }
            catch(er:Error)
            {
               trace("GFX Can\'t find class definition in your library for " + value);
            }
         }
      }
      
      public function get summonClonesFXName() : String
      {
         return this._summonClonesFXName;
      }
      
      public function set summonClonesFXName(value:String) : void
      {
         if(this._summonClonesFXName != value)
         {
            this._summonClonesFXName = value;
            try
            {
               this._summonClonesFXClassRef = getDefinitionByName(value) as Class;
            }
            catch(er:Error)
            {
               trace("GFX Can\'t find class definition in your library for " + value);
            }
         }
      }
      
      public function get moraleBoostFXName() : String
      {
         return this._moraleBoostFXName;
      }
      
      public function set moraleBoostFXName(value:String) : void
      {
         if(this._moraleBoostFXName != value)
         {
            this._moraleBoostFXName = value;
            try
            {
               this._moraleBoostFXClassRef = getDefinitionByName(value) as Class;
            }
            catch(er:Error)
            {
               trace("GFX Can\'t find class definition in your library for " + value);
            }
         }
      }
      
      public function get tightBondsFXName() : String
      {
         return this._tightBondsFXName;
      }
      
      public function set tightBondsFXName(value:String) : void
      {
         if(this._tightBondsFXName != value)
         {
            this._tightBondsFXName = value;
            try
            {
               this._tightBondsFXClassRef = getDefinitionByName(value) as Class;
            }
            catch(er:Error)
            {
               trace("GFX Can\'t find class definition in your library for " + value);
            }
         }
      }
      
      public function get summonClonesArriveFXName() : String
      {
         return this._summonClonesArriveFX;
      }
      
      public function set summonClonesArriveFXName(value:String) : void
      {
         if(this._summonClonesArriveFX != value)
         {
            this._summonClonesArriveFX = value;
            try
            {
               this._summonClonesArriveFXClassRef = getDefinitionByName(value) as Class;
            }
            catch(er:Error)
            {
               trace("GFX Can\'t find class definition in your library for " + value);
            }
         }
      }
      
      public function get hornRowFXName() : String
      {
         return this._hornRowFXName;
      }
      
      public function set hornRowFXName(value:String) : void
      {
         if(this._hornRowFXName != value)
         {
            this._hornRowFXName = value;
            try
            {
               this._hornRowFXClassRef = getDefinitionByName(value) as Class;
            }
            catch(er:Error)
            {
               trace("GFX Can\'t find class definition in your library for " + value);
            }
         }
      }
      
      public function get mushroomFXName() : String
      {
         return this._mushroomRowFXName;
      }
      
      public function set mushroomFXName(value:String) : void
      {
         if(this._mushroomRowFXName != value)
         {
            this._mushroomRowFXName = value;
            try
            {
               this._mushroomFXClassRef = getDefinitionByName(value) as Class;
            }
            catch(er:Error)
            {
               trace("GFX Can\'t find class definition in your library for " + value);
            }
         }
      }
      
      public function get morphFXName() : String
      {
         return this._morphRowFXName;
      }
      
      public function set morphFXName(value:String) : void
      {
         if(this._morphRowFXName != value)
         {
            this._morphRowFXName = value;
            try
            {
               this._morphFXClassRef = getDefinitionByName(value) as Class;
            }
            catch(er:Error)
            {
               trace("GFX Can\'t find class definition in your library for " + value);
            }
         }
      }
      
      public function get rowEffectX() : Number
      {
         return this._rowEffectX;
      }
      
      public function set rowEffectX(value:Number) : void
      {
         this._rowEffectX = value;
      }
      
      public function get seigeEnemyRowEffectY() : Number
      {
         return this._seigeEnemyRowEffectY;
      }
      
      public function set seigeEnemyRowEffectY(value:Number) : void
      {
         this._seigeEnemyRowEffectY = value;
      }
      
      public function get rangedEnemyRowEffectY() : Number
      {
         return this._rangedEnemyRowEffectY;
      }
      
      public function set rangedEnemyRowEffectY(value:Number) : void
      {
         this._rangedEnemyRowEffectY = value;
      }
      
      public function get meleeEnemyRowEffectY() : Number
      {
         return this._meleeEnemyRowEffectY;
      }
      
      public function set meleeEnemyRowEffectY(value:Number) : void
      {
         this._meleeEnemyRowEffectY = value;
      }
      
      public function get meleePlayerRowEffectY() : Number
      {
         return this._meleePlayerRowEffectY;
      }
      
      public function set meleePlayerRowEffectY(value:Number) : void
      {
         this._meleePlayerRowEffectY = value;
      }
      
      public function get rangedPlayerRowEffectY() : Number
      {
         return this._rangedPlayerRowEffectY;
      }
      
      public function set rangedPlayerRowEffectY(value:Number) : void
      {
         this._rangedPlayerRowEffectY = value;
      }
      
      public function get seigePlayerRowEffectY() : Number
      {
         return this._seigePlayerRowEffectY;
      }
      
      public function set seigePlayerRowEffectY(value:Number) : void
      {
         this._seigePlayerRowEffectY = value;
      }
      
      protected function getDeployFX(cardInstance:CardInstance) : Class
      {
         var templateRef:CardTemplate = cardInstance.templateRef;
         if(templateRef.isType(CardTemplate.CardType_Hero))
         {
            GwintGameMenu.mSingleton.playSound("gui_gwint_hero");
            return this._placeHeroFXClassRef;
         }
         if(templateRef.isType(CardTemplate.CardType_Spy))
         {
            GwintGameMenu.mSingleton.playSound("gui_gwint_spy");
            return this._placeSpyFXClassRef;
         }
         if(templateRef.isType(CardTemplate.CardType_RangedMelee))
         {
            switch(cardInstance.inList)
            {
               case CardManager.CARD_LIST_LOC_MELEE:
                  GwintGameMenu.mSingleton.playSound("gui_gwint_close_combat");
                  break;
               case CardManager.CARD_LIST_LOC_RANGED:
                  GwintGameMenu.mSingleton.playSound("gui_gwint_long_range");
            }
            return this._placeRangedFXClassRef;
         }
         if(templateRef.isType(CardTemplate.CardType_Siege))
         {
            GwintGameMenu.mSingleton.playSound("gui_gwint_siege_weapon");
            return this._placeSeigeFXClassRef;
         }
         if(templateRef.isType(CardTemplate.CardType_Ranged))
         {
            GwintGameMenu.mSingleton.playSound("gui_gwint_long_range");
            return this._placeRangedFXClassRef;
         }
         if(templateRef.isType(CardTemplate.CardType_Melee))
         {
            GwintGameMenu.mSingleton.playSound("gui_gwint_close_combat");
            return this._placeMeleeFXClassRef;
         }
         if(templateRef.isType(CardTemplate.CardType_Weather))
         {
            if(templateRef.hasEffect(CardTemplate.CardEffect_Ranged) && templateRef.hasEffect(CardTemplate.CardEffect_Siege))
            {
               GwintGameMenu.mSingleton.playSound("gui_gwint_ske_tidal_wave");
               return this._fogFXClassRef;
            }
            if(templateRef.hasEffect(CardTemplate.CardEffect_Melee))
            {
               GwintGameMenu.mSingleton.playSound("gui_gwint_frost");
               return this._frostFXClassRef;
            }
            if(templateRef.hasEffect(CardTemplate.CardEffect_Ranged))
            {
               GwintGameMenu.mSingleton.playSound("gui_gwint_fog");
               return this._fogFXClassRef;
            }
            if(templateRef.hasEffect(CardTemplate.CardEffect_Siege))
            {
               GwintGameMenu.mSingleton.playSound("gui_gwint_rain");
               return this._rainFXClassRef;
            }
            if(templateRef.hasEffect(CardTemplate.CardEffect_ClearSky))
            {
               GwintGameMenu.mSingleton.playSound("gui_gwint_clear_weather");
               return this._clearWeatherFXClassRef;
            }
         }
         else if(templateRef.isType(CardTemplate.CardType_Friendly_Effect))
         {
            if(templateRef.hasEffect(CardTemplate.CardEffect_UnsummonDummy))
            {
               GwintGameMenu.mSingleton.playSound("gui_gwint_draw_card");
               return this._dummyFXClassRef;
            }
         }
         return null;
      }
      
      protected function getEffectFX(cardTemplate:CardTemplate) : Class
      {
         if(cardTemplate.hasEffect(CardTemplate.CardEffect_Horn))
         {
            GwintGameMenu.mSingleton.playSound("gui_gwint_horn");
            return this._hornFXClassRef;
         }
         if(cardTemplate.hasEffect(CardTemplate.CardEffect_Nurse))
         {
            GwintGameMenu.mSingleton.playSound("gui_gwint_resurrect");
            return this._resurrectFXClassRef;
         }
         if(cardTemplate.hasEffect(CardTemplate.CardEffect_SummonClones))
         {
            GwintGameMenu.mSingleton.playSound("gui_gwint_summon_clones");
            return this._summonClonesFXClassRef;
         }
         if(cardTemplate.hasEffect(CardTemplate.CardEffect_SameTypeMorale))
         {
            GwintGameMenu.mSingleton.playSound("gui_gwint_morale_boost");
            return this._tightBondsFXClassRef;
         }
         if(cardTemplate.hasEffect(CardTemplate.CardEffect_ImproveNeighbours))
         {
            GwintGameMenu.mSingleton.playSound("gui_gwint_morale_boost");
            return this._moraleBoostFXClassRef;
         }
         if(cardTemplate.hasEffect(CardTemplate.CardEffect_Morph))
         {
            if(cardTemplate.factionIdx == CardTemplate.FactionId_Skellige)
            {
               GwintGameMenu.mSingleton.playSound("gui_gwint_ske_berserker");
            }
            else
            {
               GwintGameMenu.mSingleton.playSound("gui_gwint_beserker");
            }
            return this._morphFXClassRef;
         }
         return null;
      }
   }
}
