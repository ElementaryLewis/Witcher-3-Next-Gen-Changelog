package red.game.witcher3.menus.gwint
{
   import flash.events.Event;
   import flash.utils.Dictionary;
   import scaleform.clik.core.UIComponent;
   
   public class CardManager extends UIComponent
   {
      
      public static const PLAYER_INVALID:int = -1;
      
      public static const PLAYER_1:int = 0;
      
      public static const PLAYER_2:int = 1;
      
      public static const PLAYER_BOTH:int = 2;
      
      public static const CARD_LIST_LOC_INVALID:int = -1;
      
      public static const CARD_LIST_LOC_DECK:int = 0;
      
      public static const CARD_LIST_LOC_HAND:int = 1;
      
      public static const CARD_LIST_LOC_GRAVEYARD:int = 2;
      
      public static const CARD_LIST_LOC_SEIGE:int = 3;
      
      public static const CARD_LIST_LOC_RANGED:int = 4;
      
      public static const CARD_LIST_LOC_MELEE:int = 5;
      
      public static const CARD_LIST_LOC_SEIGEMODIFIERS:int = 6;
      
      public static const CARD_LIST_LOC_RANGEDMODIFIERS:int = 7;
      
      public static const CARD_LIST_LOC_MELEEMODIFIERS:int = 8;
      
      public static const CARD_LIST_LOC_WEATHERSLOT:int = 9;
      
      public static const CARD_LIST_LOC_LEADER:int = 10;
      
      public static const cardTemplatesLoaded:String = "CardManager.templates.received";
      
      protected static var _instance:CardManager;
      
      private static var lastInstanceID:int = 0;
       
      
      public var _cardTemplates:Dictionary = null;
      
      private var _cardInstances:Dictionary;
      
      public var cardTemplatesReceived:Boolean = false;
      
      public var boardRenderer:GwintBoardRenderer;
      
      public var cardValues:GwintCardValues;
      
      public var cardEffectManager:CardEffectManager;
      
      public var playerDeckDefinitions:Vector.<GwintDeck>;
      
      public var playerRenderers:Vector.<GwintPlayerRenderer>;
      
      public var currentPlayerScores:Vector.<int>;
      
      public var roundResults:Vector.<GwintRoundResult>;
      
      private var cardListHand:Array;
      
      private var cardListGraveyard:Array;
      
      private var cardListSeige:Array;
      
      private var cardListRanged:Array;
      
      private var cardListMelee:Array;
      
      private var cardListSeigeModifier:Array;
      
      private var cardListRangedModifier:Array;
      
      private var cardListMeleeModifier:Array;
      
      private var cardListWeather:Vector.<CardInstance>;
      
      private var cardListLeader:Array;
      
      private var pendingSpawnedCards:Vector.<int>;
      
      private var pendingSpawnedCardsPlayerTargets:Vector.<int>;
      
      private var _heroDrawSoundsAllowed:int = -1;
      
      private var _normalDrawSoundsAllowed:int = -1;
      
      public function CardManager()
      {
         this.playerRenderers = new Vector.<GwintPlayerRenderer>();
         this.pendingSpawnedCards = new Vector.<int>();
         this.pendingSpawnedCardsPlayerTargets = new Vector.<int>();
         super();
         this.cardEffectManager = new CardEffectManager();
         this.initializeLists();
         this._cardTemplates = new Dictionary();
         this._cardInstances = new Dictionary();
         _instance = this;
      }
      
      public static function getInstance() : CardManager
      {
         if(_instance == null)
         {
            _instance = new CardManager();
         }
         return _instance;
      }
      
      private function initializeLists() : void
      {
         this.playerDeckDefinitions = new Vector.<GwintDeck>();
         this.playerDeckDefinitions.push(new GwintDeck());
         this.playerDeckDefinitions.push(new GwintDeck());
         this.currentPlayerScores = new Vector.<int>();
         this.currentPlayerScores.push(0);
         this.currentPlayerScores.push(0);
         this.cardListHand = new Array();
         this.cardListHand.push(new Vector.<CardInstance>());
         this.cardListHand.push(new Vector.<CardInstance>());
         this.cardListGraveyard = new Array();
         this.cardListGraveyard.push(new Vector.<CardInstance>());
         this.cardListGraveyard.push(new Vector.<CardInstance>());
         this.cardListSeige = new Array();
         this.cardListSeige.push(new Vector.<CardInstance>());
         this.cardListSeige.push(new Vector.<CardInstance>());
         this.cardListRanged = new Array();
         this.cardListRanged.push(new Vector.<CardInstance>());
         this.cardListRanged.push(new Vector.<CardInstance>());
         this.cardListMelee = new Array();
         this.cardListMelee.push(new Vector.<CardInstance>());
         this.cardListMelee.push(new Vector.<CardInstance>());
         this.cardListSeigeModifier = new Array();
         this.cardListSeigeModifier.push(new Vector.<CardInstance>());
         this.cardListSeigeModifier.push(new Vector.<CardInstance>());
         this.cardListRangedModifier = new Array();
         this.cardListRangedModifier.push(new Vector.<CardInstance>());
         this.cardListRangedModifier.push(new Vector.<CardInstance>());
         this.cardListMeleeModifier = new Array();
         this.cardListMeleeModifier.push(new Vector.<CardInstance>());
         this.cardListMeleeModifier.push(new Vector.<CardInstance>());
         this.cardListWeather = new Vector.<CardInstance>();
         this.cardListLeader = new Array();
         this.cardListLeader.push(new Vector.<CardInstance>());
         this.cardListLeader.push(new Vector.<CardInstance>());
         this.roundResults = new Vector.<GwintRoundResult>();
         this.roundResults.push(new GwintRoundResult());
         this.roundResults.push(new GwintRoundResult());
         this.roundResults.push(new GwintRoundResult());
      }
      
      public function reset() : void
      {
         this.boardRenderer.clearAllCards();
         this._cardInstances = new Dictionary();
         this.cardListHand = new Array();
         this.cardListHand.push(new Vector.<CardInstance>());
         this.cardListHand.push(new Vector.<CardInstance>());
         this.cardListGraveyard = new Array();
         this.cardListGraveyard.push(new Vector.<CardInstance>());
         this.cardListGraveyard.push(new Vector.<CardInstance>());
         this.cardListSeige = new Array();
         this.cardListSeige.push(new Vector.<CardInstance>());
         this.cardListSeige.push(new Vector.<CardInstance>());
         this.cardListRanged = new Array();
         this.cardListRanged.push(new Vector.<CardInstance>());
         this.cardListRanged.push(new Vector.<CardInstance>());
         this.cardListMelee = new Array();
         this.cardListMelee.push(new Vector.<CardInstance>());
         this.cardListMelee.push(new Vector.<CardInstance>());
         this.cardListSeigeModifier = new Array();
         this.cardListSeigeModifier.push(new Vector.<CardInstance>());
         this.cardListSeigeModifier.push(new Vector.<CardInstance>());
         this.cardListRangedModifier = new Array();
         this.cardListRangedModifier.push(new Vector.<CardInstance>());
         this.cardListRangedModifier.push(new Vector.<CardInstance>());
         this.cardListMeleeModifier = new Array();
         this.cardListMeleeModifier.push(new Vector.<CardInstance>());
         this.cardListMeleeModifier.push(new Vector.<CardInstance>());
         this.cardListLeader = new Array();
         this.cardListLeader.push(new Vector.<CardInstance>());
         this.cardListLeader.push(new Vector.<CardInstance>());
         this.cardListWeather = new Vector.<CardInstance>();
         this.roundResults[0].reset();
         this.roundResults[1].reset();
         this.roundResults[2].reset();
         this.playerRenderers[0].reset();
         this.playerRenderers[1].reset();
         this.cardEffectManager.flushAllEffects();
         this.recalculateScores();
      }
      
      public function getCardTemplate(index:int) : CardTemplate
      {
         return this._cardTemplates[index];
      }
      
      public function getCardInstance(uniqueID:int) : CardInstance
      {
         return this._cardInstances[uniqueID];
      }
      
      public function onGetCardTemplates(gameData:Object, index:int) : void
      {
         var cardTemplate:CardTemplate = null;
         var dataArray:Array = gameData as Array;
         if(!dataArray)
         {
            throw new Error("GFX - Information sent from WS regarding card templates was total crapola!");
         }
         for each(cardTemplate in dataArray)
         {
            if(this._cardTemplates[cardTemplate.index] != null)
            {
               throw new Error("GFX - receieved a duplicate template, new:" + cardTemplate + ", old:" + this._cardTemplates[cardTemplate.index]);
            }
            this._cardTemplates[cardTemplate.index] = cardTemplate;
         }
         dispatchEvent(new Event(cardTemplatesLoaded,false,false));
         this.cardTemplatesReceived = true;
      }
      
      public function updatePlayerLives() : void
      {
         var i:int = 0;
         var livesCount:Array = new Array();
         livesCount.push(2);
         livesCount.push(2);
         for(i = 0; i < this.roundResults.length; i++)
         {
            if(!this.roundResults[i].played)
            {
               break;
            }
            if(this.roundResults[i].winningPlayer == PLAYER_1 || this.roundResults[i].winningPlayer == PLAYER_INVALID)
            {
               livesCount[PLAYER_2] = Math.max(0,livesCount[PLAYER_2] - 1);
            }
            if(this.roundResults[i].winningPlayer == PLAYER_2 || this.roundResults[i].winningPlayer == PLAYER_INVALID)
            {
               livesCount[PLAYER_1] = Math.max(0,livesCount[PLAYER_1] - 1);
            }
         }
         this.playerRenderers[PLAYER_1].setPlayerLives(livesCount[PLAYER_1]);
         this.playerRenderers[PLAYER_2].setPlayerLives(livesCount[PLAYER_2]);
      }
      
      public function getFirstCardInHandWithEffect(effectID:int, playerID:int) : CardInstance
      {
         var list_it:int = 0;
         var currentCard:CardInstance = null;
         var handList:Vector.<CardInstance> = this.getCardInstanceList(CARD_LIST_LOC_HAND,playerID);
         for(list_it = 0; list_it < handList.length; list_it++)
         {
            currentCard = handList[list_it];
            if(currentCard.templateRef.hasEffect(effectID))
            {
               return currentCard;
            }
         }
         return null;
      }
      
      public function getCardsInHandWithEffect(effectID:int, playerID:int) : Vector.<CardInstance>
      {
         var list_it:int = 0;
         var currentCard:CardInstance = null;
         var matchingList:Vector.<CardInstance> = new Vector.<CardInstance>();
         var handList:Vector.<CardInstance> = this.getCardInstanceList(CARD_LIST_LOC_HAND,playerID);
         for(list_it = 0; list_it < handList.length; list_it++)
         {
            currentCard = handList[list_it];
            if(currentCard.templateRef.hasEffect(effectID))
            {
               matchingList.push(currentCard);
            }
         }
         return matchingList;
      }
      
      public function getCardsInSlotIdWithEffect(effectID:int, playerID:int, slotID:int = -1) : Vector.<CardInstance>
      {
         var currentCard:CardInstance = null;
         var list_it:int = 0;
         var rowList:Vector.<CardInstance> = null;
         var handList:Vector.<CardInstance> = null;
         var matchingList:Vector.<CardInstance> = new Vector.<CardInstance>();
         if(slotID == -1)
         {
            rowList = this.getCardInstanceList(CARD_LIST_LOC_MELEE,playerID);
            for(list_it = 0; list_it < rowList.length; list_it++)
            {
               currentCard = rowList[list_it];
               if(currentCard.templateRef.hasEffect(effectID))
               {
                  matchingList.push(currentCard);
               }
            }
            rowList = this.getCardInstanceList(CARD_LIST_LOC_RANGED,playerID);
            for(list_it = 0; list_it < rowList.length; list_it++)
            {
               currentCard = rowList[list_it];
               if(currentCard.templateRef.hasEffect(effectID))
               {
                  matchingList.push(currentCard);
               }
            }
            rowList = this.getCardInstanceList(CARD_LIST_LOC_SEIGE,playerID);
            for(list_it = 0; list_it < rowList.length; list_it++)
            {
               currentCard = rowList[list_it];
               if(currentCard.templateRef.hasEffect(effectID))
               {
                  matchingList.push(currentCard);
               }
            }
         }
         else
         {
            handList = this.getCardInstanceList(slotID,playerID);
            for(list_it = 0; list_it < handList.length; list_it++)
            {
               currentCard = handList[list_it];
               if(currentCard.templateRef.hasEffect(effectID))
               {
                  matchingList.push(currentCard);
               }
            }
         }
         return matchingList;
      }
      
      public function getCardInstanceList(listID:int, playerID:int) : Vector.<CardInstance>
      {
         switch(listID)
         {
            case CARD_LIST_LOC_DECK:
               return null;
            case CARD_LIST_LOC_HAND:
               if(playerID != PLAYER_INVALID)
               {
                  return this.cardListHand[playerID];
               }
               break;
            case CARD_LIST_LOC_GRAVEYARD:
               if(playerID != PLAYER_INVALID)
               {
                  return this.cardListGraveyard[playerID];
               }
               break;
            case CARD_LIST_LOC_SEIGE:
               if(playerID != PLAYER_INVALID)
               {
                  return this.cardListSeige[playerID];
               }
               break;
            case CARD_LIST_LOC_RANGED:
               if(playerID != PLAYER_INVALID)
               {
                  return this.cardListRanged[playerID];
               }
               break;
            case CARD_LIST_LOC_MELEE:
               if(playerID != PLAYER_INVALID)
               {
                  return this.cardListMelee[playerID];
               }
               break;
            case CARD_LIST_LOC_SEIGEMODIFIERS:
               if(playerID != PLAYER_INVALID)
               {
                  return this.cardListSeigeModifier[playerID];
               }
               break;
            case CARD_LIST_LOC_RANGEDMODIFIERS:
               if(playerID != PLAYER_INVALID)
               {
                  return this.cardListRangedModifier[playerID];
               }
               break;
            case CARD_LIST_LOC_MELEEMODIFIERS:
               if(playerID != PLAYER_INVALID)
               {
                  return this.cardListMeleeModifier[playerID];
               }
               break;
            case CARD_LIST_LOC_WEATHERSLOT:
               return this.cardListWeather;
            case CARD_LIST_LOC_LEADER:
               if(playerID != PLAYER_INVALID)
               {
                  return this.cardListLeader[playerID];
               }
         }
         trace("GFX [WARNING] - CardManager: failed to get card list with player: " + playerID + ", and listID: " + listID);
         return null;
      }
      
      private function flushPendingSpawnedCards() : void
      {
         var currentInstance:CardInstance = null;
         var newInstance:CardInstance = null;
         var newInstances:Vector.<CardInstance> = new Vector.<CardInstance>();
         for(var i:int = 0; i < this.pendingSpawnedCards.length; i++)
         {
            newInstance = this.spawnCardInstance(this.pendingSpawnedCards[i],this.pendingSpawnedCardsPlayerTargets[i],CARD_LIST_LOC_MELEE);
            newInstance.InstancePositioning = true;
            newInstance.BanishInsteadOfGraveyard = true;
            this.addCardInstanceToList(newInstance,CARD_LIST_LOC_MELEE,this.pendingSpawnedCardsPlayerTargets[i]);
            newInstances.push(newInstance);
         }
         for(var x:int = 0; x < newInstances.length; x++)
         {
            currentInstance = newInstances[x];
            currentInstance.InstancePositioning = false;
            CardFXManager.getInstance().spawnFX(currentInstance,null,CardFXManager.getInstance()._placeFiendFXClassRef);
            currentInstance.onFinishedMovingIntoHolder(currentInstance.inList,currentInstance.listsPlayer);
         }
         this.pendingSpawnedCards.length = 0;
         this.pendingSpawnedCardsPlayerTargets.length = 0;
      }
      
      public function clearBoard(allowMonsterFactionAbility:Boolean) : void
      {
         var list_it:int = 0;
         var player_it:int = 0;
         var cardToIgnore:CardInstance = null;
         var currentCard:CardInstance = null;
         var currentList:Vector.<CardInstance> = null;
         while(this.cardListWeather.length > 0)
         {
            currentCard = this.cardListWeather[0];
            this.addCardInstanceToList(currentCard,CARD_LIST_LOC_GRAVEYARD,currentCard.owningPlayer);
         }
         for(player_it = PLAYER_1; player_it <= PLAYER_2; player_it++)
         {
            if(allowMonsterFactionAbility)
            {
               cardToIgnore = this.chooseCreatureToExclude(player_it);
            }
            this.sendListToGraveyard(CARD_LIST_LOC_MELEE,player_it,cardToIgnore,false);
            this.sendListToGraveyard(CARD_LIST_LOC_RANGED,player_it,cardToIgnore,false);
            this.sendListToGraveyard(CARD_LIST_LOC_SEIGE,player_it,cardToIgnore,false);
            this.sendListToGraveyard(CARD_LIST_LOC_MELEEMODIFIERS,player_it,cardToIgnore,false);
            this.sendListToGraveyard(CARD_LIST_LOC_RANGEDMODIFIERS,player_it,cardToIgnore,false);
            this.sendListToGraveyard(CARD_LIST_LOC_SEIGEMODIFIERS,player_it,cardToIgnore,false);
         }
         this.flushPendingSpawnedCards();
      }
      
      private function sendListToGraveyard(listID:int, playerID:int, cardToIgnore:CardInstance, allowFlush:Boolean = true) : void
      {
         var currentCard:CardInstance = null;
         var currentList:Vector.<CardInstance> = this.getCardInstanceList(listID,playerID);
         var indexToCheck:int = 0;
         while(currentList.length > indexToCheck)
         {
            currentCard = currentList[indexToCheck];
            if(currentCard == cardToIgnore)
            {
               indexToCheck++;
            }
            else if(currentCard.BanishInsteadOfGraveyard)
            {
               CardFXManager.getInstance().spawnFX(currentCard,null,CardFXManager.getInstance()._placeFiendFXClassRef);
               this.removeCardInstanceFromItsList(currentCard);
               this.boardRenderer.removeCardInstance(currentCard);
            }
            else if(playerID == -1)
            {
               this.addCardInstanceToList(currentCard,CARD_LIST_LOC_GRAVEYARD,currentCard.owningPlayer);
            }
            else
            {
               this.addCardInstanceToList(currentCard,CARD_LIST_LOC_GRAVEYARD,currentCard.listsPlayer);
            }
         }
      }
      
      public function chooseCreatureToExclude(playerIndex:int) : CardInstance
      {
         var elligibleCardList:Vector.<CardInstance> = null;
         var keepIndex:int = 0;
         if(this.playerDeckDefinitions[playerIndex].getDeckFaction() == CardTemplate.FactionId_No_Mans_Land)
         {
            elligibleCardList = new Vector.<CardInstance>();
            this.getAllCreaturesNonHero(CARD_LIST_LOC_MELEE,playerIndex,elligibleCardList);
            this.getAllCreaturesNonHero(CARD_LIST_LOC_RANGED,playerIndex,elligibleCardList);
            this.getAllCreaturesNonHero(CARD_LIST_LOC_SEIGE,playerIndex,elligibleCardList);
            if(elligibleCardList.length > 0)
            {
               keepIndex = Math.min(Math.floor(Math.random() * elligibleCardList.length),elligibleCardList.length - 1);
               return elligibleCardList[keepIndex];
            }
         }
         return null;
      }
      
      public function getAllCreatures(playerIndex:int) : Vector.<CardInstance>
      {
         var list_it:int = 0;
         var currentRowList:Vector.<CardInstance> = null;
         var returnVal:Vector.<CardInstance> = new Vector.<CardInstance>();
         currentRowList = this.getCardInstanceList(CARD_LIST_LOC_MELEE,playerIndex);
         for(list_it = 0; list_it < currentRowList.length; list_it++)
         {
            returnVal.push(currentRowList[list_it]);
         }
         currentRowList = this.getCardInstanceList(CARD_LIST_LOC_RANGED,playerIndex);
         for(list_it = 0; list_it < currentRowList.length; list_it++)
         {
            returnVal.push(currentRowList[list_it]);
         }
         currentRowList = this.getCardInstanceList(CARD_LIST_LOC_SEIGE,playerIndex);
         for(list_it = 0; list_it < currentRowList.length; list_it++)
         {
            returnVal.push(currentRowList[list_it]);
         }
         return returnVal;
      }
      
      public function getAllCreaturesInHand(playerIndex:int) : Vector.<CardInstance>
      {
         var list_it:int = 0;
         var currentCard:CardInstance = null;
         var returnVal:Vector.<CardInstance> = new Vector.<CardInstance>();
         var handList:Vector.<CardInstance> = this.getCardInstanceList(CARD_LIST_LOC_HAND,playerIndex);
         for(list_it = 0; list_it < handList.length; list_it++)
         {
            currentCard = handList[list_it];
            if(currentCard.templateRef.isType(CardTemplate.CardType_Creature))
            {
               returnVal.push(currentCard);
            }
         }
         return returnVal;
      }
      
      public function getAllCreaturesNonHero(listID:int, playerIndex:int, listToAdd:Vector.<CardInstance>) : void
      {
         var list_it:int = 0;
         var currentCard:CardInstance = null;
         var currentList:Vector.<CardInstance> = this.getCardInstanceList(listID,playerIndex);
         if(currentList == null)
         {
            throw new Error("GFX [ERROR] - Failed to get card instance list for listID: " + listID + ", and playerIndex: " + playerIndex);
         }
         for(list_it = 0; list_it < currentList.length; list_it++)
         {
            currentCard = currentList[list_it];
            if(currentCard.templateRef.isType(CardTemplate.CardType_Creature) && !currentCard.templateRef.isType(CardTemplate.CardType_Hero))
            {
               listToAdd.push(currentCard);
            }
         }
      }
      
      public function replaceCardInstanceIDs(replacerInstanceID:int, replaceeInstanceID:int) : void
      {
         this.replaceCardInstance(this.getCardInstance(replacerInstanceID),this.getCardInstance(replaceeInstanceID));
      }
      
      public function replaceCardInstance(replacerInstance:CardInstance, replaceeInstance:CardInstance) : void
      {
         if(replaceeInstance == null || replacerInstance == null)
         {
            return;
         }
         GwintGameMenu.mSingleton.playSound("gui_gwint_dummy");
         var targetList:int = replaceeInstance.inList;
         var targetListPlayer:int = replaceeInstance.listsPlayer;
         this.addCardInstanceToList(replaceeInstance,CARD_LIST_LOC_HAND,replaceeInstance.listsPlayer);
         this.addCardInstanceToList(replacerInstance,targetList,targetListPlayer);
      }
      
      public function addCardInstanceIDToList(instanceID:int, listID:int, playerID:int) : void
      {
         var cardInstance:CardInstance = this.getCardInstance(instanceID);
         if(cardInstance)
         {
            this.addCardInstanceToList(cardInstance,listID,playerID);
         }
      }
      
      public function addCardInstanceToList(cardInstance:CardInstance, listID:int, playerID:int) : void
      {
         var i:int = 0;
         this.removeCardInstanceFromItsList(cardInstance);
         cardInstance.inList = listID;
         cardInstance.listsPlayer = playerID;
         var newList:Vector.<CardInstance> = this.getCardInstanceList(listID,playerID);
         if(listID == CARD_LIST_LOC_GRAVEYARD && cardInstance.templateRef.hasEffect(CardTemplate.CardEffect_SuicideSummon) && !GwintGameFlowController.getInstance().isGameOver())
         {
            if(cardInstance.templateRef.summonFlags.length > 0)
            {
               GwintGameMenu.mSingleton.playSound(cardInstance.templateRef.factionIdx == CardTemplate.FactionId_Skellige ? "gui_gwint_hero" : "gui_gwint_cow_death");
            }
            for(i = 0; i < cardInstance.templateRef.summonFlags.length; i++)
            {
               this.pendingSpawnedCards.push(cardInstance.templateRef.summonFlags[i]);
               this.pendingSpawnedCardsPlayerTargets.push(cardInstance.listsPlayer);
            }
         }
         trace("GFX ====== Adding card with instance ID: " + cardInstance.instanceId + ", to List ID: " + this.listIDToString(listID) + ", for player: " + playerID);
         newList.push(cardInstance);
         if(this.boardRenderer)
         {
            this.boardRenderer.wasAddedToList(cardInstance,listID,playerID);
         }
         this.recalculateScores();
         if(listID == CARD_LIST_LOC_HAND)
         {
            this.playerRenderers[playerID].numCardsInHand = newList.length;
         }
      }
      
      public function removeCardInstanceFromItsList(cardInstance:CardInstance) : void
      {
         this.removeCardInstanceFromList(cardInstance,cardInstance.inList,cardInstance.listsPlayer);
      }
      
      public function removeCardInstanceFromList(cardInstance:CardInstance, listID:int, playerID:int) : void
      {
         var containingList:Vector.<CardInstance> = null;
         var indexOf:int = 0;
         if(cardInstance.inList != CARD_LIST_LOC_INVALID)
         {
            cardInstance.inList = CARD_LIST_LOC_INVALID;
            cardInstance.listsPlayer = PLAYER_INVALID;
            containingList = this.getCardInstanceList(listID,playerID);
            if(!containingList)
            {
               throw new Error("GFX - Tried to remove from unknown listID:" + listID + ", and player:" + playerID + ", the following card: " + cardInstance);
            }
            indexOf = containingList.indexOf(cardInstance);
            if(indexOf < 0 || indexOf >= containingList.length)
            {
               throw new Error("GFX - tried to remove card instance from a list that does not contain it: " + listID + ", " + playerID + ", " + cardInstance);
            }
            containingList.splice(indexOf,1);
            if(this.boardRenderer)
            {
               this.boardRenderer.wasRemovedFromList(cardInstance,listID,playerID);
            }
            this.recalculateScores();
            if(listID == CARD_LIST_LOC_HAND)
            {
               this.playerRenderers[playerID].numCardsInHand = containingList.length;
            }
         }
      }
      
      public function spawnLeaders() : void
      {
         var templateId:int = 0;
         var newCardInstance:CardInstance = null;
         templateId = this.playerDeckDefinitions[PLAYER_1].selectedKingIndex;
         newCardInstance = this.spawnCardInstance(templateId,PLAYER_1);
         this.addCardInstanceToList(newCardInstance,CARD_LIST_LOC_LEADER,PLAYER_1);
         templateId = this.playerDeckDefinitions[PLAYER_2].selectedKingIndex;
         newCardInstance = this.spawnCardInstance(templateId,PLAYER_2);
         this.addCardInstanceToList(newCardInstance,CARD_LIST_LOC_LEADER,PLAYER_2);
      }
      
      public function halfWeatherEnabled(playerID:int) : Boolean
      {
         var otherPlayerLeader:CardLeaderInstance = null;
         var playerToCheckInstance:CardLeaderInstance = this.getCardLeader(playerID);
         if(playerID == PLAYER_1)
         {
            otherPlayerLeader = this.getCardLeader(PLAYER_2);
         }
         else
         {
            otherPlayerLeader = this.getCardLeader(PLAYER_1);
         }
         return otherPlayerLeader.templateRef.getFirstEffect() != CardTemplate.CardEffect_Counter_King && playerToCheckInstance.templateRef.getFirstEffect() == CardTemplate.CardEffect_WeatherResistant;
      }
      
      public function getCardLeader(playerIndex:int) : CardLeaderInstance
      {
         var leaderCardList:Vector.<CardInstance> = CardManager.getInstance().getCardInstanceList(CardManager.CARD_LIST_LOC_LEADER,playerIndex);
         if(leaderCardList.length < 1)
         {
            return null;
         }
         return leaderCardList[0] as CardLeaderInstance;
      }
      
      public function shuffleAndDrawCards() : void
      {
         var numToDraw:int = 0;
         var player1Deck:GwintDeck = this.playerDeckDefinitions[PLAYER_1];
         var player2Deck:GwintDeck = this.playerDeckDefinitions[PLAYER_2];
         var player1Leader:CardLeaderInstance = this.getCardLeader(PLAYER_1);
         var player2Leader:CardLeaderInstance = this.getCardLeader(PLAYER_2);
         if(player1Deck.getDeckKingTemplate() == null || player2Deck.getDeckKingTemplate() == null)
         {
            throw new Error("GFX - Trying to shuffle and draw cards when one of the following decks is null:" + player1Deck.getDeckKingTemplate() + ", " + player2Deck.getDeckKingTemplate());
         }
         trace("GFX -#AI#------------------- DECK STRENGTH --------------------");
         trace("GFX -#AI#--- PLAYER 1:");
         player1Deck.shuffleDeck(player2Deck.originalStength());
         trace("GFX -#AI#--- PLAYER 2:");
         player2Deck.shuffleDeck(player1Deck.originalStength());
         trace("GFX -#AI#------------------------------------------------------");
         if(player1Leader.canBeUsed && player1Leader.templateRef.getFirstEffect() == CardTemplate.CardEffect_11th_card)
         {
            player1Leader.canBeUsed = false;
            numToDraw = 11;
         }
         else
         {
            numToDraw = 10;
         }
         if(GwintGameMenu.mSingleton.tutorialsOn)
         {
            if(this.tryDrawSpecificCard(PLAYER_1,3))
            {
               numToDraw--;
            }
            if(this.tryDrawSpecificCard(PLAYER_1,5))
            {
               numToDraw--;
            }
            if(this.tryDrawSpecificCard(PLAYER_1,150))
            {
               numToDraw--;
            }
            if(this.tryDrawSpecificCard(PLAYER_1,115))
            {
               numToDraw--;
            }
            if(this.tryDrawSpecificCard(PLAYER_1,135))
            {
               numToDraw--;
            }
            if(this.tryDrawSpecificCard(PLAYER_1,111))
            {
               numToDraw--;
            }
            if(this.tryDrawSpecificCard(PLAYER_1,145))
            {
               numToDraw--;
            }
            if(this.tryDrawSpecificCard(PLAYER_1,113))
            {
               numToDraw--;
            }
            if(this.tryDrawSpecificCard(PLAYER_1,114))
            {
               numToDraw--;
            }
            if(this.tryDrawSpecificCard(PLAYER_1,107))
            {
               numToDraw--;
            }
            GwintGameMenu.mSingleton.playSound("gui_gwint_draw_card");
         }
         this.drawCards(PLAYER_1,numToDraw);
         var cardList:Vector.<CardInstance> = this.getCardInstanceList(CARD_LIST_LOC_HAND,PLAYER_1);
         cardList.sort(this.cardSorter);
         if(player2Leader.canBeUsed && player2Leader.templateRef.getFirstEffect() == CardTemplate.CardEffect_11th_card)
         {
            player2Leader.canBeUsed = false;
            numToDraw = 11;
         }
         else
         {
            numToDraw = 10;
         }
         this.drawCards(PLAYER_2,numToDraw);
      }
      
      public function drawCards(playerID:int, quantity:int) : Boolean
      {
         var i:int = 0;
         this._heroDrawSoundsAllowed = 1;
         this._normalDrawSoundsAllowed = 1;
         for(i = 0; i < quantity; i++)
         {
            if(!this.drawCard(playerID))
            {
               return false;
            }
         }
         this._heroDrawSoundsAllowed = -1;
         this._normalDrawSoundsAllowed = -1;
         return true;
      }
      
      public function drawCard(playerID:int) : Boolean
      {
         var templateId:int = 0;
         var newCardInstance:CardInstance = null;
         var playerDeck:GwintDeck = this.playerDeckDefinitions[playerID];
         if(playerDeck.cardIndicesInDeck.length > 0)
         {
            templateId = this.playerDeckDefinitions[playerID].drawCard();
            newCardInstance = this.spawnCardInstance(templateId,playerID);
            this.addCardInstanceToList(newCardInstance,CARD_LIST_LOC_HAND,playerID);
            if(newCardInstance.templateRef.isType(CardTemplate.CardType_Hero))
            {
               if(this._heroDrawSoundsAllowed > 0)
               {
                  --this._heroDrawSoundsAllowed;
                  GwintGameMenu.mSingleton.playSound("gui_gwint_hero_card_drawn");
               }
               else if(this._heroDrawSoundsAllowed == -1)
               {
                  GwintGameMenu.mSingleton.playSound("gui_gwint_hero_card_drawn");
               }
            }
            else if(this._normalDrawSoundsAllowed > 0)
            {
               --this._normalDrawSoundsAllowed;
               GwintGameMenu.mSingleton.playSound("gui_gwint_draw_card");
            }
            else if(this._normalDrawSoundsAllowed == -1)
            {
               GwintGameMenu.mSingleton.playSound("gui_gwint_draw_card");
            }
            trace("GFX - Player ",playerID," drew the following Card:",newCardInstance);
            return true;
         }
         trace("GFX - Player ",playerID," has no more cards to draw!");
         return false;
      }
      
      public function tryDrawAndPlaySpecificCard_Weather(playerID:int, cardID:int) : Boolean
      {
         var newCardInstance:CardInstance = null;
         var playerDeck:GwintDeck = this.playerDeckDefinitions[playerID];
         if(playerDeck.tryDrawSpecificCard(cardID))
         {
            newCardInstance = this.spawnCardInstance(cardID,playerID);
            this.addCardInstanceToList(newCardInstance,CARD_LIST_LOC_WEATHERSLOT,CardManager.PLAYER_INVALID);
            trace("GFX - Player ",playerID," drew the following Card:",newCardInstance);
            return true;
         }
         return false;
      }
      
      public function tryDrawSpecificCard(playerID:int, cardID:int) : Boolean
      {
         var newCardInstance:CardInstance = null;
         var playerDeck:GwintDeck = this.playerDeckDefinitions[playerID];
         if(playerDeck.tryDrawSpecificCard(cardID))
         {
            newCardInstance = this.spawnCardInstance(cardID,playerID);
            this.addCardInstanceToList(newCardInstance,CARD_LIST_LOC_HAND,playerID);
            trace("GFX - Player ",playerID," drew the following Card:",newCardInstance);
            return true;
         }
         return false;
      }
      
      public function mulliganCard(cardInstance:CardInstance) : CardInstance
      {
         var newtemplateID:* = undefined;
         var newCardInstance:CardInstance = null;
         var cardList:Vector.<CardInstance> = null;
         var playerDeck:GwintDeck = null;
         if(cardInstance.owningPlayer >= 0 && cardInstance.owningPlayer < this.playerDeckDefinitions.length)
         {
            playerDeck = this.playerDeckDefinitions[cardInstance.owningPlayer];
         }
         if(playerDeck)
         {
            playerDeck.readdCard(cardInstance.templateId);
            newtemplateID = playerDeck.drawCard();
            if(newtemplateID != CardInstance.INVALID_INSTANCE_ID)
            {
               newCardInstance = this.spawnCardInstance(newtemplateID,cardInstance.owningPlayer);
               if(newCardInstance)
               {
                  this.addCardInstanceToList(newCardInstance,CARD_LIST_LOC_HAND,cardInstance.owningPlayer);
                  this.unspawnCardInstance(cardInstance);
                  if(newCardInstance.templateRef.isType(CardTemplate.CardType_Hero))
                  {
                     GwintGameMenu.mSingleton.playSound("gui_gwint_hero_card_drawn");
                  }
                  cardList = this.getCardInstanceList(CARD_LIST_LOC_HAND,PLAYER_1);
                  cardList.sort(this.cardSorter);
                  return newCardInstance;
               }
            }
         }
         return null;
      }
      
      public function spawnCardInstance(templateId:int, forPlayer:int, startingLocation:int = -1) : CardInstance
      {
         var newInstance:CardInstance = null;
         lastInstanceID += 1;
         if(templateId >= 1000)
         {
            newInstance = new CardLeaderInstance();
         }
         else
         {
            newInstance = new CardInstance();
         }
         var spawnLocation:int = startingLocation;
         if(spawnLocation == CARD_LIST_LOC_INVALID)
         {
            spawnLocation = CARD_LIST_LOC_DECK;
         }
         newInstance.templateId = templateId;
         newInstance.templateRef = this.getCardTemplate(templateId);
         newInstance.owningPlayer = forPlayer;
         newInstance.instanceId = lastInstanceID;
         this._cardInstances[newInstance.instanceId] = newInstance;
         newInstance.finializeSetup();
         if(this.boardRenderer)
         {
            this.boardRenderer.spawnCardInstance(newInstance,spawnLocation,forPlayer);
         }
         if(startingLocation == CARD_LIST_LOC_INVALID)
         {
            this.addCardInstanceToList(newInstance,CARD_LIST_LOC_HAND,forPlayer);
         }
         return newInstance;
      }
      
      public function unspawnCardInstance(cardInstance:CardInstance) : void
      {
         this.removeCardInstanceFromItsList(cardInstance);
         if(this.boardRenderer)
         {
            this.boardRenderer.returnToDeck(cardInstance);
         }
         delete this._cardInstances[cardInstance.instanceId];
      }
      
      public function applyCardEffectsID(instanceID:int) : void
      {
         this.applyCardEffects(this.getCardInstance(instanceID));
      }
      
      public function applyCardEffects(sourceInstance:CardInstance) : void
      {
         if(sourceInstance != null)
         {
            sourceInstance.updateEffectsApplied();
         }
      }
      
      public function sendToGraveyardID(instanceID:int) : void
      {
         this.sendToGraveyard(this.getCardInstance(instanceID));
      }
      
      public function sendToGraveyard(targetInstance:CardInstance) : void
      {
         if(targetInstance)
         {
            if(targetInstance.BanishInsteadOfGraveyard)
            {
               CardFXManager.getInstance().spawnFX(targetInstance,null,CardFXManager.getInstance()._placeFiendFXClassRef);
               this.removeCardInstanceFromItsList(targetInstance);
               this.boardRenderer.removeCardInstance(targetInstance);
               this.unspawnCardInstance(targetInstance);
            }
            else if(targetInstance.templateRef.isType(CardTemplate.CardType_Weather))
            {
               this.addCardInstanceToList(targetInstance,CARD_LIST_LOC_GRAVEYARD,targetInstance.owningPlayer);
            }
            else
            {
               this.addCardInstanceToList(targetInstance,CARD_LIST_LOC_GRAVEYARD,targetInstance.listsPlayer);
            }
         }
         this.flushPendingSpawnedCards();
      }
      
      public function getSpawnedFaction(instance:CardInstance) : int
      {
         return this.playerDeckDefinitions[instance.owningPlayer].getDeckFaction();
      }
      
      public function getStrongestNonHeroFromGraveyard(playerID:int) : CardInstance
      {
         var list_it:int = 0;
         var graveyard:Vector.<CardInstance> = this.getCardInstanceList(CARD_LIST_LOC_GRAVEYARD,playerID);
         var strongestCard:CardInstance = null;
         for(list_it = 0; list_it < graveyard.length; list_it++)
         {
            if(!graveyard[list_it].templateRef.isType(CardTemplate.CardType_Hero) && (strongestCard == null || strongestCard.getTotalPower() < graveyard[list_it].getTotalPower()))
            {
               strongestCard = graveyard[list_it];
            }
         }
         return strongestCard;
      }
      
      public function getScorchTargets(tags:int = 7, validPlayer:int = 2) : Vector.<CardInstance>
      {
         var listIt:int = 0;
         var playerIt:int = 0;
         var currentList:Vector.<CardInstance> = null;
         var currentCard:CardInstance = null;
         var outputList:Vector.<CardInstance> = new Vector.<CardInstance>();
         var highestPower:int = 0;
         for(playerIt = PLAYER_1; playerIt < PLAYER_2 + 1; playerIt++)
         {
            if(playerIt == validPlayer || validPlayer == PLAYER_BOTH)
            {
               if((tags & CardTemplate.CardType_Melee) != CardTemplate.CardType_None)
               {
                  currentList = this.getCardInstanceList(CARD_LIST_LOC_MELEE,playerIt);
                  for(listIt = 0; listIt < currentList.length; listIt++)
                  {
                     currentCard = currentList[listIt];
                     if(currentCard.getTotalPower() >= highestPower && (currentCard.templateRef.typeArray & tags) != CardTemplate.CardType_None && !currentCard.templateRef.isType(CardTemplate.CardType_Hero))
                     {
                        if(currentCard.getTotalPower() > highestPower)
                        {
                           highestPower = currentCard.getTotalPower();
                           outputList.length = 0;
                           outputList.push(currentCard);
                        }
                        else
                        {
                           outputList.push(currentCard);
                        }
                     }
                  }
               }
               if((tags & CardTemplate.CardType_Ranged) != CardTemplate.CardType_None)
               {
                  currentList = this.getCardInstanceList(CARD_LIST_LOC_RANGED,playerIt);
                  for(listIt = 0; listIt < currentList.length; listIt++)
                  {
                     currentCard = currentList[listIt];
                     if(currentCard.getTotalPower() >= highestPower && (currentCard.templateRef.typeArray & tags) != CardTemplate.CardType_None && !currentCard.templateRef.isType(CardTemplate.CardType_Hero))
                     {
                        if(currentCard.getTotalPower() > highestPower)
                        {
                           highestPower = currentCard.getTotalPower();
                           outputList.length = 0;
                           outputList.push(currentCard);
                        }
                        else
                        {
                           outputList.push(currentCard);
                        }
                     }
                  }
               }
               if((tags & CardTemplate.CardType_Siege) != CardTemplate.CardType_None)
               {
                  currentList = this.getCardInstanceList(CARD_LIST_LOC_SEIGE,playerIt);
                  for(listIt = 0; listIt < currentList.length; listIt++)
                  {
                     currentCard = currentList[listIt];
                     if(currentCard.getTotalPower() >= highestPower && (currentCard.templateRef.typeArray & tags) != CardTemplate.CardType_None && !currentCard.templateRef.isType(CardTemplate.CardType_Hero))
                     {
                        if(currentCard.getTotalPower() > highestPower)
                        {
                           highestPower = currentCard.getTotalPower();
                           outputList.length = 0;
                           outputList.push(currentCard);
                        }
                        else
                        {
                           outputList.push(currentCard);
                        }
                     }
                  }
               }
            }
         }
         return outputList;
      }
      
      public function summonFromDeck(playerID:int, templateID:int) : Boolean
      {
         var newCardInstance:CardInstance = null;
         var hadCard:Boolean = false;
         var playerDeck:GwintDeck = this.playerDeckDefinitions[playerID];
         while(playerDeck.tryDrawSpecificCard(templateID))
         {
            hadCard = true;
            newCardInstance = this.spawnCardInstance(templateID,playerID);
            newCardInstance.playSummonedFX = true;
            if(newCardInstance.templateRef.isType(CardTemplate.CardType_Melee))
            {
               this.addCardInstanceToList(newCardInstance,CARD_LIST_LOC_MELEE,playerID);
            }
            else if(newCardInstance.templateRef.isType(CardTemplate.CardType_Ranged))
            {
               this.addCardInstanceToList(newCardInstance,CARD_LIST_LOC_RANGED,playerID);
            }
            else if(newCardInstance.templateRef.isType(CardTemplate.CardType_Siege))
            {
               this.addCardInstanceToList(newCardInstance,CARD_LIST_LOC_SEIGE,playerID);
            }
         }
         return hadCard;
      }
      
      public function summonFromHand(playerID:int, templateID:int) : void
      {
         var cardsInHand:Vector.<CardInstance> = null;
         var currentCard:CardInstance = null;
         var it:int = 0;
         cardsInHand = this.getCardInstanceList(CARD_LIST_LOC_HAND,playerID);
         it = 0;
         while(it < cardsInHand.length)
         {
            currentCard = cardsInHand[it];
            if(currentCard.templateId == templateID)
            {
               currentCard.playSummonedFX = true;
               if(currentCard.templateRef.isType(CardTemplate.CardType_Melee))
               {
                  this.addCardInstanceToList(currentCard,CARD_LIST_LOC_MELEE,playerID);
               }
               else if(currentCard.templateRef.isType(CardTemplate.CardType_Ranged))
               {
                  this.addCardInstanceToList(currentCard,CARD_LIST_LOC_RANGED,playerID);
               }
               else if(currentCard.templateRef.isType(CardTemplate.CardType_Siege))
               {
                  this.addCardInstanceToList(currentCard,CARD_LIST_LOC_SEIGE,playerID);
               }
            }
            else
            {
               it++;
            }
         }
      }
      
      public function ressurectFromGraveyard(playerID:int, count:int) : void
      {
         var resIndex:int = 0;
         var ressurectInstance:CardInstance = null;
         var location:int = 0;
         var targetPlayerID:int = 0;
         var elligibleCardListFromOpponentsGrave:Vector.<CardInstance> = new Vector.<CardInstance>();
         this.getAllCreaturesNonHero(CARD_LIST_LOC_GRAVEYARD,playerID,elligibleCardListFromOpponentsGrave);
         var leftSummonCounter:int = count;
         while(elligibleCardListFromOpponentsGrave.length > 0 && leftSummonCounter > 0)
         {
            resIndex = Math.min(Math.floor(Math.random() * elligibleCardListFromOpponentsGrave.length),elligibleCardListFromOpponentsGrave.length - 1);
            ressurectInstance = elligibleCardListFromOpponentsGrave[resIndex];
            location = CardManager.CARD_LIST_LOC_INVALID;
            if(ressurectInstance.templateRef.isType(CardTemplate.CardType_Melee))
            {
               location = CardManager.CARD_LIST_LOC_MELEE;
            }
            else if(ressurectInstance.templateRef.isType(CardTemplate.CardType_Ranged))
            {
               location = CardManager.CARD_LIST_LOC_RANGED;
            }
            else if(ressurectInstance.templateRef.isType(CardTemplate.CardType_Siege))
            {
               location = CardManager.CARD_LIST_LOC_SEIGE;
            }
            if(location != CardManager.CARD_LIST_LOC_INVALID)
            {
               targetPlayerID = playerID;
               if(ressurectInstance.templateRef.isType(CardTemplate.CardType_Spy))
               {
                  if(playerID == PLAYER_1)
                  {
                     targetPlayerID = PLAYER_2;
                  }
                  else
                  {
                     targetPlayerID = PLAYER_1;
                  }
               }
               this.addCardInstanceToList(ressurectInstance,location,targetPlayerID);
               elligibleCardListFromOpponentsGrave.splice(resIndex,1);
            }
            leftSummonCounter--;
         }
      }
      
      public function shuffleGraveyards() : void
      {
         var listPlayer:int = 0;
         var cardInstance:CardInstance = null;
         var currentRowList:Vector.<CardInstance> = new Vector.<CardInstance>();
         this.getAllCreaturesNonHero(CardManager.CARD_LIST_LOC_GRAVEYARD,CardManager.PLAYER_1,currentRowList);
         this.getAllCreaturesNonHero(CardManager.CARD_LIST_LOC_GRAVEYARD,CardManager.PLAYER_2,currentRowList);
         var player1Affected:Boolean = false;
         var player2Affected:Boolean = false;
         for each(cardInstance in currentRowList)
         {
            listPlayer = cardInstance.listsPlayer;
            if(listPlayer == CardManager.PLAYER_1 && !player1Affected)
            {
               player1Affected = true;
            }
            else if(listPlayer == CardManager.PLAYER_2 && !player2Affected)
            {
               player2Affected = true;
            }
            this.unspawnCardInstance(cardInstance);
            this.playerDeckDefinitions[listPlayer].readdCard(cardInstance.templateId,true);
         }
         if(player1Affected)
         {
            CardFXManager.getInstance().spawnFX_Location(1601,901,CardFXManager.getInstance()._placeFiendFXClassRef);
         }
         if(player2Affected)
         {
            CardFXManager.getInstance().spawnFX_Location(1601,141,CardFXManager.getInstance()._placeFiendFXClassRef);
         }
      }
      
      public function getBeserkersOnBoard(player:int, list:Vector.<CardInstance>) : void
      {
         var currentInstance:CardInstance = null;
         for each(currentInstance in this.getCardInstanceList(CARD_LIST_LOC_MELEE,player))
         {
            if(currentInstance.templateRef.hasEffect(CardTemplate.CardEffect_Morph))
            {
               list.push(currentInstance);
            }
         }
         for each(currentInstance in this.getCardInstanceList(CARD_LIST_LOC_RANGED,player))
         {
            if(currentInstance.templateRef.hasEffect(CardTemplate.CardEffect_Morph))
            {
               list.push(currentInstance);
            }
         }
         for each(currentInstance in this.getCardInstanceList(CARD_LIST_LOC_SEIGE,player))
         {
            if(currentInstance.templateRef.hasEffect(CardTemplate.CardEffect_Morph))
            {
               list.push(currentInstance);
            }
         }
      }
      
      public function getBeserkersInHand(player:int, list:Vector.<CardInstance>) : void
      {
         var currentInstance:CardInstance = null;
         for each(currentInstance in this.getCardInstanceList(CARD_LIST_LOC_HAND,player))
         {
            if(currentInstance.templateRef.hasEffect(CardTemplate.CardEffect_Morph))
            {
               list.push(currentInstance);
            }
         }
      }
      
      public function getHigherOrLowerValueCardFromTargetGraveyard(playerID:int, higherOrLower:Boolean = true, overrideSpy:Boolean = false, overrideNurse:Boolean = false, considerOwnGraveyard:Boolean = false) : CardAndComboPoints
      {
         var list_it:int = 0;
         var choosenCard:CardInstance = null;
         var currentCard:CardInstance = null;
         var cachedBestUnit:CardInstance = null;
         var cachedBestNurseFromTargetGrave:CardInstance = null;
         var cachedBestSpy:CardInstance = null;
         var cachedBestMeleeScorch:CardInstance = null;
         var spyPointsFromTargetGrave:int = 0;
         var spyPointsFromOppositeGrave:int = 0;
         var comboPointsFromOppositeGrave:int = 0;
         var elligibleCardListOppositeGrave:Vector.<CardInstance> = null;
         var oppositePlayer:* = undefined;
         var choosenCardFromOppositeGrave:CardInstance = null;
         var currentCardFromOppositeGrave:CardInstance = null;
         var cachedBestUnitFromOppositeGrave:CardInstance = null;
         var cachedBestSpyFromOppositeGrave:CardInstance = null;
         var listOfNursesFromOppositeGrave:Vector.<CardInstance> = null;
         var cachedBestMeleeScorchFromOppositeGrave:CardInstance = null;
         var i:* = undefined;
         var elligibleCardListFromOpponentsGrave:Vector.<CardInstance> = new Vector.<CardInstance>();
         this.getAllCreaturesNonHero(CARD_LIST_LOC_GRAVEYARD,playerID,elligibleCardListFromOpponentsGrave);
         var listOfNursesFromTargetGrave:Vector.<CardInstance> = new Vector.<CardInstance>();
         var comboPoints:int = 0;
         var cardAndPoints:CardAndComboPoints = new CardAndComboPoints();
         for(list_it = 0; list_it < elligibleCardListFromOpponentsGrave.length; list_it++)
         {
            currentCard = elligibleCardListFromOpponentsGrave[list_it];
            if(choosenCard == null)
            {
               choosenCard = currentCard;
            }
            if(currentCard.templateRef.isType(CardTemplate.CardType_Spy))
            {
               if(cachedBestSpy == null)
               {
                  cachedBestSpy = currentCard;
               }
               else if(Boolean(cachedBestSpy) && this.isBetterMatchForGrave(currentCard,cachedBestSpy,playerID,higherOrLower,overrideSpy,overrideNurse))
               {
                  cachedBestSpy = currentCard;
               }
            }
            else if(currentCard.templateRef.hasEffect(CardTemplate.CardEffect_MeleeScorch))
            {
               cachedBestMeleeScorch = currentCard;
            }
            else if(currentCard.templateRef.hasEffect(CardTemplate.CardEffect_Nurse))
            {
               if(cachedBestNurseFromTargetGrave == null)
               {
                  cachedBestNurseFromTargetGrave = currentCard;
               }
               else if(Boolean(cachedBestNurseFromTargetGrave) && this.isBetterMatchForGrave(currentCard,cachedBestNurseFromTargetGrave,playerID,higherOrLower,overrideSpy,overrideNurse))
               {
                  cachedBestNurseFromTargetGrave = currentCard;
               }
               listOfNursesFromTargetGrave.push(currentCard);
            }
            else if(cachedBestUnit == null)
            {
               cachedBestUnit = currentCard;
            }
            else if(Boolean(cachedBestUnit) && this.isBetterMatchForGrave(currentCard,cachedBestUnit,playerID,higherOrLower,overrideSpy,overrideNurse))
            {
               cachedBestUnit = currentCard;
            }
         }
         if(considerOwnGraveyard && listOfNursesFromTargetGrave.length > 0)
         {
            elligibleCardListOppositeGrave = new Vector.<CardInstance>();
            oppositePlayer = playerID == CardManager.PLAYER_1 ? CardManager.PLAYER_2 : CardManager.PLAYER_1;
            this.getAllCreaturesNonHero(CARD_LIST_LOC_GRAVEYARD,oppositePlayer,elligibleCardListOppositeGrave);
            listOfNursesFromOppositeGrave = new Vector.<CardInstance>();
            for(list_it = 0; list_it < elligibleCardListOppositeGrave.length; list_it++)
            {
               currentCardFromOppositeGrave = elligibleCardListOppositeGrave[list_it];
               if(choosenCardFromOppositeGrave == null)
               {
                  choosenCardFromOppositeGrave = currentCardFromOppositeGrave;
               }
               if(currentCardFromOppositeGrave.templateRef.isType(CardTemplate.CardType_Spy))
               {
                  if(cachedBestSpyFromOppositeGrave == null)
                  {
                     cachedBestSpyFromOppositeGrave = currentCardFromOppositeGrave;
                  }
                  if(Boolean(cachedBestSpyFromOppositeGrave) && this.isBetterMatchForGrave(currentCardFromOppositeGrave,cachedBestSpyFromOppositeGrave,oppositePlayer,higherOrLower,overrideSpy,overrideNurse))
                  {
                     cachedBestSpyFromOppositeGrave = currentCardFromOppositeGrave;
                  }
               }
               else if(currentCardFromOppositeGrave.templateRef.hasEffect(CardTemplate.CardEffect_MeleeScorch))
               {
                  cachedBestMeleeScorchFromOppositeGrave = currentCardFromOppositeGrave;
               }
               else if(currentCardFromOppositeGrave.templateRef.hasEffect(CardTemplate.CardEffect_Nurse))
               {
                  listOfNursesFromOppositeGrave.push(currentCardFromOppositeGrave);
               }
               else if(cachedBestUnitFromOppositeGrave == null)
               {
                  cachedBestUnitFromOppositeGrave = currentCardFromOppositeGrave;
               }
               else if(Boolean(cachedBestUnitFromOppositeGrave) && this.isBetterMatchForGrave(currentCardFromOppositeGrave,cachedBestUnitFromOppositeGrave,oppositePlayer,higherOrLower,overrideSpy,overrideNurse))
               {
                  cachedBestUnitFromOppositeGrave = currentCardFromOppositeGrave;
               }
            }
            if(cachedBestSpyFromOppositeGrave)
            {
               comboPointsFromOppositeGrave = Math.max(0,10 - cachedBestSpyFromOppositeGrave.getTotalPower());
               spyPointsFromOppositeGrave = comboPointsFromOppositeGrave;
            }
            else if(cachedBestMeleeScorchFromOppositeGrave)
            {
               comboPointsFromOppositeGrave = cachedBestMeleeScorchFromOppositeGrave.getTotalPower();
            }
            else if(cachedBestUnitFromOppositeGrave)
            {
               comboPointsFromOppositeGrave = cachedBestUnitFromOppositeGrave.getTotalPower();
            }
            if(listOfNursesFromOppositeGrave)
            {
               for(i = 0; i < listOfNursesFromOppositeGrave.length; i++)
               {
                  comboPointsFromOppositeGrave += listOfNursesFromOppositeGrave[i].getTotalPower();
               }
            }
            if(cachedBestNurseFromTargetGrave)
            {
               comboPointsFromOppositeGrave += cachedBestNurseFromTargetGrave.getTotalPower();
            }
         }
         if(cachedBestSpy)
         {
            comboPoints = Math.max(0,10 - cachedBestSpy.getTotalPower());
            spyPointsFromTargetGrave = comboPoints;
            choosenCard = cachedBestSpy;
         }
         else if(cachedBestMeleeScorch)
         {
            comboPoints = cachedBestMeleeScorch.getTotalPower();
            choosenCard = cachedBestMeleeScorch;
         }
         else if(cachedBestUnit)
         {
            comboPoints = cachedBestUnit.getTotalPower();
            choosenCard = cachedBestUnit;
         }
         if(!considerOwnGraveyard && Boolean(listOfNursesFromTargetGrave))
         {
            for(i = 0; i < listOfNursesFromTargetGrave.length; i++)
            {
               comboPoints += listOfNursesFromTargetGrave[i].getTotalPower();
            }
         }
         else if(!cachedBestSpy && !cachedBestMeleeScorch && !cachedBestUnit && Boolean(cachedBestNurseFromTargetGrave))
         {
            comboPoints = cachedBestNurseFromTargetGrave.getTotalPower();
            choosenCard = cachedBestNurseFromTargetGrave;
         }
         if(considerOwnGraveyard && Boolean(cachedBestNurseFromTargetGrave))
         {
            if(!spyPointsFromOppositeGrave && !spyPointsFromTargetGrave && comboPointsFromOppositeGrave > comboPoints)
            {
               cardAndPoints.cardInstance = cachedBestNurseFromTargetGrave;
               cardAndPoints.comboPoints = comboPointsFromOppositeGrave;
            }
            else if(!spyPointsFromTargetGrave && spyPointsFromOppositeGrave || spyPointsFromOppositeGrave > spyPointsFromTargetGrave)
            {
               cardAndPoints.cardInstance = cachedBestNurseFromTargetGrave;
               cardAndPoints.comboPoints = comboPointsFromOppositeGrave;
            }
            else
            {
               cardAndPoints.cardInstance = choosenCard;
               cardAndPoints.comboPoints = comboPoints;
            }
         }
         else
         {
            cardAndPoints.cardInstance = choosenCard;
            cardAndPoints.comboPoints = comboPoints;
         }
         return cardAndPoints;
      }
      
      public function isBetterMatchForGrave(currentCard:CardInstance, choosenCard:CardInstance, playerID:int, higherOrLower:Boolean, overrideSpy:Boolean, overrideNurse:Boolean) : Boolean
      {
         var oppositeBehavior:* = undefined;
         var currentIsSpy:Boolean = currentCard.templateRef.isType(CardTemplate.CardType_Spy);
         var choosenIsSpy:Boolean = choosenCard.templateRef.isType(CardTemplate.CardType_Spy);
         var currentIsMeleeScorch:Boolean = currentCard.templateRef.hasEffect(CardTemplate.CardEffect_MeleeScorch);
         var choosenIsMeleeScorch:Boolean = choosenCard.templateRef.hasEffect(CardTemplate.CardEffect_MeleeScorch);
         var currentIsNurse:Boolean = currentCard.templateRef.hasEffect(CardTemplate.CardEffect_Nurse);
         var choosenIsNurse:Boolean = choosenCard.templateRef.hasEffect(CardTemplate.CardEffect_Nurse);
         var opponentPlayer:* = playerID == CardManager.PLAYER_1 ? CardManager.PLAYER_2 : CardManager.PLAYER_1;
         var opponentsMeleeScore:int = this.calculatePlayerScore(CARD_LIST_LOC_MELEE,opponentPlayer);
         if(overrideSpy || overrideNurse)
         {
            oppositeBehavior = higherOrLower == true ? false : true;
         }
         if(currentIsSpy || choosenIsSpy)
         {
            if(!choosenIsSpy)
            {
               return true;
            }
            if(overrideSpy && currentIsSpy && this.checkIfHigherOrLower(currentCard,choosenCard,oppositeBehavior))
            {
               return true;
            }
            if(currentIsSpy && this.checkIfHigherOrLower(currentCard,choosenCard,higherOrLower))
            {
               return true;
            }
            return false;
         }
         if(currentIsMeleeScorch || choosenIsMeleeScorch)
         {
            if(choosenIsMeleeScorch)
            {
               return false;
            }
            if(opponentsMeleeScore >= 10)
            {
               return true;
            }
            return false;
         }
         if(currentIsNurse || choosenIsNurse)
         {
            if(!choosenIsNurse)
            {
               return true;
            }
            if(overrideNurse && currentIsNurse && this.checkIfHigherOrLower(currentCard,choosenCard,oppositeBehavior))
            {
               return true;
            }
            if(currentIsNurse && this.checkIfHigherOrLower(currentCard,choosenCard,true))
            {
               return true;
            }
            return false;
         }
         if(this.checkIfHigherOrLower(currentCard,choosenCard,higherOrLower))
         {
            return true;
         }
         return false;
      }
      
      public function getHigherOrLowerValueTargetCardOnBoard(castingInstance:CardInstance, playerID:int, higherOrLower:Boolean = true, overrideSpy:Boolean = false, overrideNurse:Boolean = false) : CardInstance
      {
         var list_it:int = 0;
         var choosenCard:CardInstance = null;
         var currentCard:CardInstance = null;
         var elligibleCardList:Vector.<CardInstance> = new Vector.<CardInstance>();
         this.getAllCreaturesNonHero(CARD_LIST_LOC_MELEE,playerID,elligibleCardList);
         this.getAllCreaturesNonHero(CARD_LIST_LOC_RANGED,playerID,elligibleCardList);
         this.getAllCreaturesNonHero(CARD_LIST_LOC_SEIGE,playerID,elligibleCardList);
         for(list_it = 0; list_it < elligibleCardList.length; list_it++)
         {
            currentCard = elligibleCardList[list_it];
            if(castingInstance.canBeCastOn(currentCard))
            {
               if(choosenCard == null)
               {
                  choosenCard = currentCard;
               }
               else if(this.isBetterMatch(currentCard,choosenCard,playerID,higherOrLower,overrideSpy,overrideNurse))
               {
                  choosenCard = currentCard;
               }
            }
         }
         return choosenCard;
      }
      
      public function isBetterMatch(currentCard:CardInstance, choosenCard:CardInstance, playerID:int, higherOrLower:Boolean, overrideSpy:Boolean, overrideNurse:Boolean) : Boolean
      {
         var oppositeBehavior:* = undefined;
         var currentIsSpy:Boolean = currentCard.templateRef.isType(CardTemplate.CardType_Spy);
         var choosenIsSpy:Boolean = choosenCard.templateRef.isType(CardTemplate.CardType_Spy);
         var currentIsMeleeScorch:Boolean = currentCard.templateRef.hasEffect(CardTemplate.CardEffect_MeleeScorch);
         var choosenIsMeleeScorch:Boolean = choosenCard.templateRef.hasEffect(CardTemplate.CardEffect_MeleeScorch);
         var currentIsNurse:Boolean = currentCard.templateRef.hasEffect(CardTemplate.CardEffect_Nurse);
         var choosenIsNurse:Boolean = choosenCard.templateRef.hasEffect(CardTemplate.CardEffect_Nurse);
         var opponentPlayer:* = playerID == CardManager.PLAYER_1 ? CardManager.PLAYER_2 : CardManager.PLAYER_1;
         var opponentsMeleeScore:int = this.calculatePlayerScore(CARD_LIST_LOC_MELEE,opponentPlayer);
         if(overrideSpy || overrideNurse)
         {
            oppositeBehavior = higherOrLower == true ? false : true;
         }
         if(currentIsSpy || choosenIsSpy)
         {
            if(!choosenIsSpy)
            {
               return true;
            }
            if(overrideSpy && currentIsSpy && this.checkIfHigherOrLower(currentCard,choosenCard,oppositeBehavior))
            {
               return true;
            }
            if(currentIsSpy && this.checkIfHigherOrLower(currentCard,choosenCard,higherOrLower))
            {
               return true;
            }
            return false;
         }
         if(currentIsMeleeScorch || choosenIsMeleeScorch)
         {
            if(choosenIsMeleeScorch)
            {
               return false;
            }
            if(opponentsMeleeScore >= 10)
            {
               return true;
            }
            return false;
         }
         if(currentIsNurse || choosenIsNurse)
         {
            if(!choosenIsNurse)
            {
               return true;
            }
            if(overrideNurse && currentIsNurse && this.checkIfHigherOrLower(currentCard,choosenCard,oppositeBehavior))
            {
               return true;
            }
            if(currentIsNurse && this.checkIfHigherOrLower(currentCard,choosenCard,true))
            {
               return true;
            }
            return false;
         }
         if(this.checkIfHigherOrLower(currentCard,choosenCard,higherOrLower))
         {
            return true;
         }
         return false;
      }
      
      public function checkIfHigherOrLower(firstCard:CardInstance, secondCard:CardInstance, higherOrLower:*) : Boolean
      {
         if(higherOrLower)
         {
            if(firstCard.getTotalPower() > secondCard.getTotalPower())
            {
               return true;
            }
            return false;
         }
         if(firstCard.getTotalPower() < secondCard.getTotalPower())
         {
            return true;
         }
         return false;
      }
      
      public function recalculateScores() : void
      {
         var currentWinningPlayer:* = this.getWinningPlayer();
         var p2SeigeScore:int = this.calculatePlayerScore(CARD_LIST_LOC_SEIGE,PLAYER_2);
         var p2RangedScore:int = this.calculatePlayerScore(CARD_LIST_LOC_RANGED,PLAYER_2);
         var p2MeleeScore:int = this.calculatePlayerScore(CARD_LIST_LOC_MELEE,PLAYER_2);
         var p1MeleeScore:int = this.calculatePlayerScore(CARD_LIST_LOC_MELEE,PLAYER_1);
         var p1RangedScore:int = this.calculatePlayerScore(CARD_LIST_LOC_RANGED,PLAYER_1);
         var p1SeigeScore:int = this.calculatePlayerScore(CARD_LIST_LOC_SEIGE,PLAYER_1);
         this.currentPlayerScores[PLAYER_1] = p1MeleeScore + p1RangedScore + p1SeigeScore;
         this.playerRenderers[PLAYER_1].score = this.currentPlayerScores[PLAYER_1];
         this.currentPlayerScores[PLAYER_2] = p2MeleeScore + p2RangedScore + p2SeigeScore;
         this.playerRenderers[PLAYER_2].score = this.currentPlayerScores[PLAYER_2];
         this.playerRenderers[PLAYER_1].setIsWinning(this.currentPlayerScores[PLAYER_1] > this.currentPlayerScores[PLAYER_2]);
         this.playerRenderers[PLAYER_2].setIsWinning(this.currentPlayerScores[PLAYER_2] > this.currentPlayerScores[PLAYER_1]);
         this.boardRenderer.updateRowScores(p1SeigeScore,p1RangedScore,p1MeleeScore,p2MeleeScore,p2RangedScore,p2SeigeScore);
         if(currentWinningPlayer != this.getWinningPlayer())
         {
            GwintGameMenu.mSingleton.playSound("gui_gwint_whose_winning_changed");
         }
      }
      
      public function getWinningPlayer() : int
      {
         if(this.currentPlayerScores[PLAYER_1] > this.currentPlayerScores[PLAYER_2])
         {
            return PLAYER_1;
         }
         if(this.currentPlayerScores[PLAYER_1] < this.currentPlayerScores[PLAYER_2])
         {
            return PLAYER_2;
         }
         return PLAYER_INVALID;
      }
      
      public function calculatePlayerScore(listID:int, playerID:int) : int
      {
         var i:int = 0;
         var currentList:Vector.<CardInstance> = null;
         var score:int = 0;
         currentList = this.getCardInstanceList(listID,playerID);
         for(i = 0; i < currentList.length; i++)
         {
            score += currentList[i].getTotalPower();
         }
         return score;
      }
      
      public function CalculateCardPowerPotentials() : void
      {
         var i:int = 0;
         var currentList:Vector.<CardInstance> = null;
         currentList = this.getCardInstanceList(CARD_LIST_LOC_HAND,PLAYER_1);
         for(i = 0; i < currentList.length; i++)
         {
            currentList[i].recalculatePowerPotential(this);
         }
         currentList = this.getCardInstanceList(CARD_LIST_LOC_HAND,PLAYER_2);
         for(i = 0; i < currentList.length; i++)
         {
            currentList[i].recalculatePowerPotential(this);
         }
      }
      
      public function GetRessurectionTargets(playerID:int, copyList:Vector.<CardInstance>, allowRecalculations:Boolean) : void
      {
         var currentInstance:CardInstance = null;
         var cardList:Vector.<CardInstance> = this.getCardInstanceList(CardManager.CARD_LIST_LOC_GRAVEYARD,playerID);
         for(var it:int = 0; it < cardList.length; it++)
         {
            currentInstance = cardList[it];
            if(currentInstance.templateRef.isType(CardTemplate.CardType_Creature) && !currentInstance.templateRef.isType(CardTemplate.CardType_Hero))
            {
               if(allowRecalculations)
               {
                  currentInstance.recalculatePowerPotential(this);
               }
               copyList.push(currentInstance);
            }
         }
      }
      
      public function hasRowModifier(list:int, player:int, effect:int) : Boolean
      {
         var instance:CardInstance = null;
         for each(instance in this.getCardInstanceList(list,player))
         {
            if(instance.templateRef.hasEffect(effect))
            {
               return true;
            }
         }
         return false;
      }
      
      protected function cardSorter(element1:CardInstance, element2:CardInstance) : Number
      {
         if(element1.templateId == element2.templateId)
         {
            return 0;
         }
         var element1Template:CardTemplate = element1.templateRef;
         var element2Template:CardTemplate = element2.templateRef;
         var battlefield1:int = element1Template.getCreatureType();
         var battlefield2:int = element2Template.getCreatureType();
         if(battlefield1 == CardTemplate.CardType_None && battlefield2 == CardTemplate.CardType_None)
         {
            return element1.templateId - element2.templateId;
         }
         if(battlefield1 == CardTemplate.CardType_None)
         {
            return -1;
         }
         if(battlefield2 == CardTemplate.CardType_None)
         {
            return 1;
         }
         if(element1Template.power != element2Template.power)
         {
            return element1Template.power - element2Template.power;
         }
         return element1.templateId - element2.templateId;
      }
      
      public function traceRoundResults() : void
      {
         var i:int = 0;
         trace("GFX -------------------------------- START TRACE ROUND RESULTS ----------------------------------");
         trace("GFX =============================================================================================");
         if(this.roundResults == null)
         {
            trace("GFX -------------- Round Results is empty!!! -------------");
         }
         else
         {
            for(i = 0; i < this.roundResults.length; i++)
            {
               trace("GFX - " + this.roundResults[i]);
            }
         }
         trace("GFX =============================================================================================");
         trace("GFX ---------------------------------- END TRACE ROUND RESULTS ----------------------------------");
      }
      
      public function listIDToString(listID:int) : String
      {
         switch(listID)
         {
            case CARD_LIST_LOC_DECK:
               return "DECK";
            case CARD_LIST_LOC_HAND:
               return "HAND";
            case CARD_LIST_LOC_GRAVEYARD:
               return "GRAVEYARD";
            case CARD_LIST_LOC_SEIGE:
               return "SEIGE";
            case CARD_LIST_LOC_RANGED:
               return "RANGED";
            case CARD_LIST_LOC_MELEE:
               return "MELEE";
            case CARD_LIST_LOC_SEIGEMODIFIERS:
               return "SEIGEMODIFIERS";
            case CARD_LIST_LOC_RANGEDMODIFIERS:
               return "RANGEDMODIFIERS";
            case CARD_LIST_LOC_MELEEMODIFIERS:
               return "MELEEMODIFIERS";
            case CARD_LIST_LOC_WEATHERSLOT:
               return "WEATHER";
            case CARD_LIST_LOC_LEADER:
               return "LEADER";
            case CARD_LIST_LOC_INVALID:
         }
         return "INVALID";
      }
   }
}
