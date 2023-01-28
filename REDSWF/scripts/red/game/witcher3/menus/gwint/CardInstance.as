package red.game.witcher3.menus.gwint
{
   public class CardInstance
   {
      
      public static const INVALID_INSTANCE_ID:int = -1;
       
      
      public var templateId:int;
      
      public var templateRef:CardTemplate;
      
      public var instanceId:int = -1;
      
      public var owningPlayer:int;
      
      public var inList:int;
      
      public var listsPlayer:int;
      
      public var effectingCardsRefList:Vector.<CardInstance>;
      
      public var effectedByCardsRefList:Vector.<CardInstance>;
      
      public var lastListApplied:int;
      
      public var lastListPlayerApplied:int;
      
      public var powerChangeCallback:Function;
      
      public var playSummonedFX:Boolean = false;
      
      public var BanishInsteadOfGraveyard:Boolean = false;
      
      public var InstancePositioning:Boolean = false;
      
      protected var _lastCalculatedPowerPotential:CardTransaction;
      
      public function CardInstance()
      {
         this.owningPlayer = CardManager.PLAYER_INVALID;
         this.inList = CardManager.CARD_LIST_LOC_INVALID;
         this.listsPlayer = CardManager.PLAYER_INVALID;
         this.effectingCardsRefList = new Vector.<CardInstance>();
         this.effectedByCardsRefList = new Vector.<CardInstance>();
         this.lastListApplied = CardManager.CARD_LIST_LOC_INVALID;
         this.lastListPlayerApplied = CardManager.PLAYER_INVALID;
         this._lastCalculatedPowerPotential = new CardTransaction();
         super();
      }
      
      public function getTotalPower(ignoreWeather:Boolean = false) : int
      {
         var iter:int = 0;
         var currentBuffer:CardInstance = null;
         var affectedByWeather:Boolean = false;
         var hornCounter:int = 0;
         var moraleCounter:int = 0;
         var tightBondsCounter:int = 0;
         var cardManager:CardManager = CardManager.getInstance();
         if(!this.templateRef.isType(CardTemplate.CardType_Hero))
         {
            for(iter = 0; iter < this.effectedByCardsRefList.length; iter++)
            {
               currentBuffer = this.effectedByCardsRefList[iter];
               if(currentBuffer.templateRef.isType(CardTemplate.CardType_Weather))
               {
                  affectedByWeather = true;
               }
               if(currentBuffer.templateRef.hasEffect(CardTemplate.CardEffect_Horn) || currentBuffer.templateRef.hasEffect(CardTemplate.CardEffect_Siege_Horn) || currentBuffer.templateRef.hasEffect(CardTemplate.CardEffect_Range_Horn) || currentBuffer.templateRef.hasEffect(CardTemplate.CardEffect_Melee_Horn))
               {
                  hornCounter++;
               }
               if(currentBuffer.templateRef.hasEffect(CardTemplate.CardEffect_ImproveNeighbours))
               {
                  moraleCounter++;
               }
               if(currentBuffer.templateRef.hasEffect(CardTemplate.CardEffect_SameTypeMorale))
               {
                  tightBondsCounter++;
               }
            }
         }
         var totalPower:int = cardManager.getCardTemplate(this.templateId).power;
         if(!ignoreWeather && affectedByWeather)
         {
            if(cardManager.halfWeatherEnabled(this.listsPlayer))
            {
               totalPower = Math.max(0,Math.floor(cardManager.getCardTemplate(this.templateId).power / 2));
            }
            else
            {
               totalPower = Math.min(1,cardManager.getCardTemplate(this.templateId).power);
            }
         }
         if(this.templateRef.isType(CardTemplate.CardType_Spy) && cardManager.cardEffectManager.doubleSpyEnabled && !this.templateRef.isType(CardTemplate.CardType_Hero))
         {
            totalPower *= 2;
         }
         var additionalPower:int = 0;
         additionalPower += totalPower * tightBondsCounter;
         additionalPower += moraleCounter;
         if(hornCounter > 0)
         {
            additionalPower += totalPower + additionalPower;
         }
         return totalPower + additionalPower;
      }
      
      public function updateTemplateID(newTemplateId:int) : void
      {
         this.templateId = newTemplateId;
         this.templateRef = CardManager.getInstance().getCardTemplate(this.templateId);
      }
      
      public function get notOwningPlayer() : int
      {
         return this.owningPlayer == CardManager.PLAYER_1 ? CardManager.PLAYER_2 : CardManager.PLAYER_1;
      }
      
      public function get notListPlayer() : int
      {
         return this.listsPlayer == CardManager.PLAYER_1 ? CardManager.PLAYER_2 : CardManager.PLAYER_1;
      }
      
      public function finializeSetup() : void
      {
      }
      
      public function toString() : String
      {
         return " powerChange[ " + this.getOptimalTransaction().powerChangeResult + " ] , strategicValue[ " + this.getOptimalTransaction().strategicValue + " ] , CardName[ " + this.templateRef.title + " ] [Gwint CardInstance] instanceID:" + this.instanceId + ", owningPlayer[ " + this.owningPlayer + " ], templateId[ " + this.templateId + " ], inList[ " + this.inList + " ]";
      }
      
      public function canBeCastOn(cardInstance:CardInstance) : Boolean
      {
         if(this.templateRef.isType(CardTemplate.CardType_Hero) || cardInstance.templateRef.isType(CardTemplate.CardType_Hero))
         {
            return false;
         }
         if(this.templateRef.hasEffect(CardTemplate.CardEffect_UnsummonDummy) && cardInstance.templateRef.isType(CardTemplate.CardType_Creature) && cardInstance.listsPlayer == this.listsPlayer && cardInstance.inList != CardManager.CARD_LIST_LOC_HAND && cardInstance.inList != CardManager.CARD_LIST_LOC_GRAVEYARD && cardInstance.inList != CardManager.CARD_LIST_LOC_LEADER)
         {
            return true;
         }
         return false;
      }
      
      public function canBePlacedInSlot(slotID:int, playerID:int) : Boolean
      {
         var cardManagerRef:CardManager = CardManager.getInstance();
         if(slotID == CardManager.CARD_LIST_LOC_DECK || slotID == CardManager.CARD_LIST_LOC_GRAVEYARD)
         {
            return false;
         }
         if(playerID == CardManager.PLAYER_INVALID && slotID == CardManager.CARD_LIST_LOC_WEATHERSLOT && this.templateRef.isType(CardTemplate.CardType_Weather))
         {
            return true;
         }
         if(playerID == this.listsPlayer && this.templateRef.isType(CardTemplate.CardType_Spy))
         {
            return false;
         }
         if(!this.templateRef.isType(CardTemplate.CardType_Spy) && playerID != this.listsPlayer && (this.templateRef.isType(CardTemplate.CardType_Creature) || this.templateRef.isType(CardTemplate.CardType_Row_Modifier)))
         {
            return false;
         }
         if(this.templateRef.isType(CardTemplate.CardType_Creature))
         {
            if(slotID == CardManager.CARD_LIST_LOC_MELEE && this.templateRef.isType(CardTemplate.CardType_Melee))
            {
               return true;
            }
            if(slotID == CardManager.CARD_LIST_LOC_RANGED && this.templateRef.isType(CardTemplate.CardType_Ranged))
            {
               return true;
            }
            if(slotID == CardManager.CARD_LIST_LOC_SEIGE && this.templateRef.isType(CardTemplate.CardType_Siege))
            {
               return true;
            }
         }
         else if(this.templateRef.isType(CardTemplate.CardType_Row_Modifier))
         {
            if(slotID == CardManager.CARD_LIST_LOC_MELEEMODIFIERS && this.templateRef.isType(CardTemplate.CardType_Melee) && cardManagerRef.getCardInstanceList(CardManager.CARD_LIST_LOC_MELEEMODIFIERS,this.listsPlayer).length == 0)
            {
               return true;
            }
            if(slotID == CardManager.CARD_LIST_LOC_RANGEDMODIFIERS && this.templateRef.isType(CardTemplate.CardType_Ranged) && cardManagerRef.getCardInstanceList(CardManager.CARD_LIST_LOC_RANGEDMODIFIERS,this.listsPlayer).length == 0)
            {
               return true;
            }
            if(slotID == CardManager.CARD_LIST_LOC_SEIGEMODIFIERS && this.templateRef.isType(CardTemplate.CardType_Siege) && cardManagerRef.getCardInstanceList(CardManager.CARD_LIST_LOC_SEIGEMODIFIERS,this.listsPlayer).length == 0)
            {
               return true;
            }
         }
         return false;
      }
      
      public function recalculatePowerPotential(cardManager:CardManager) : void
      {
         var currentCard:CardInstance = null;
         var cardList:Vector.<CardInstance> = null;
         var currentRowList:Vector.<CardInstance> = null;
         var currentInstance:CardInstance = null;
         var ressurectedCardValue:int = 0;
         var creaturePower:int = 0;
         var rangedPower:int = 0;
         var buffedCreaturePower:int = 0;
         var buffedRangedPower:int = 0;
         var oldPower:int = 0;
         var numClonesToSummon:int = 0;
         var totalChange:int = 0;
         var prevPower:int = 0;
         var beserkersOnBoard:Vector.<CardInstance> = null;
         var beserkersInHand:Vector.<CardInstance> = null;
         var hasErmionInHand:Boolean = false;
         var cardInHand:CardInstance = null;
         var targetRow:int = 0;
         var meleeCount:int = 0;
         var rangedCount:int = 0;
         var meleeAvailable:* = false;
         var rangedAvailable:* = false;
         var beserkerCard:CardInstance = null;
         var meleeRowIncrease:int = 0;
         var rangeRowIncrease:int = 0;
         var seigeRowIncrease:int = 0;
         var oldValue:int = 0;
         var forNurseList:* = undefined;
         var onlyNursesAtHand:Boolean = false;
         var nursePlusRessurectedValue:int = 0;
         var i:* = 0;
         this._lastCalculatedPowerPotential.powerChangeResult = 0;
         this._lastCalculatedPowerPotential.strategicValue = 0;
         this._lastCalculatedPowerPotential.sourceCardInstanceRef = this;
         var weatherCardList:Vector.<CardInstance> = cardManager.getCardInstanceList(CardManager.CARD_LIST_LOC_WEATHERSLOT,CardManager.PLAYER_INVALID);
         var currentWeatherCard:CardInstance = weatherCardList.length > 0 ? weatherCardList[0] : null;
         var opponentPlayer:* = this.listsPlayer == CardManager.PLAYER_1 ? CardManager.PLAYER_2 : CardManager.PLAYER_1;
         var hasScorchInHand:* = cardManager.getCardsInHandWithEffect(CardTemplate.CardEffect_Scorch,this.listsPlayer).length > 0;
         var playerCardsInHand:Vector.<CardInstance> = cardManager.getCardInstanceList(CardManager.CARD_LIST_LOC_HAND,this.listsPlayer);
         var scorchRowList:Vector.<CardInstance> = null;
         var onlyScorchedCardsPower:int = 0;
         var totalScorchPower:int = 0;
         if(this.templateRef.isType(CardTemplate.CardType_Creature))
         {
            this._lastCalculatedPowerPotential.targetPlayerID = this.templateRef.isType(CardTemplate.CardType_Spy) ? opponentPlayer : this.listsPlayer;
            if(this.templateRef.isType(CardTemplate.CardType_Melee))
            {
               this._lastCalculatedPowerPotential.targetSlotID = CardManager.CARD_LIST_LOC_MELEE;
            }
            else if(this.templateRef.isType(CardTemplate.CardType_Ranged))
            {
               this._lastCalculatedPowerPotential.targetSlotID = CardManager.CARD_LIST_LOC_RANGED;
            }
            else
            {
               this._lastCalculatedPowerPotential.targetSlotID = CardManager.CARD_LIST_LOC_SEIGE;
            }
            cardList = cardManager.cardEffectManager.getEffectsForList(this._lastCalculatedPowerPotential.targetSlotID,this.listsPlayer);
            for(i = 0; i < cardList.length; i++)
            {
               currentCard = cardList[i];
               if(currentCard != this)
               {
                  this.effectedByCardsRefList.push(currentCard);
               }
            }
            creaturePower = this.getTotalPower();
            this.effectedByCardsRefList.length = 0;
            if(this.templateRef.isType(CardTemplate.CardType_RangedMelee))
            {
               cardList = cardManager.cardEffectManager.getEffectsForList(CardManager.CARD_LIST_LOC_RANGED,this.listsPlayer);
               for(i = 0; i < cardList.length; i++)
               {
                  currentCard = cardList[i];
                  if(currentCard != this)
                  {
                     this.effectedByCardsRefList.push(currentCard);
                  }
               }
               rangedPower = this.getTotalPower();
               this.effectedByCardsRefList.length = 0;
               if(this.templateRef.hasEffect(CardTemplate.CardEffect_ImproveNeighbours))
               {
                  currentRowList = new Vector.<CardInstance>();
                  cardManager.getAllCreaturesNonHero(CardManager.CARD_LIST_LOC_MELEE,CardManager.PLAYER_1,currentRowList);
                  buffedCreaturePower = creaturePower + currentRowList.length;
                  cardManager.getAllCreaturesNonHero(CardManager.CARD_LIST_LOC_RANGED,CardManager.PLAYER_1,currentRowList);
                  buffedRangedPower = rangedPower + currentRowList.length;
                  if(buffedRangedPower > buffedCreaturePower || buffedRangedPower == buffedCreaturePower && Math.random() < 0.5)
                  {
                     creaturePower = rangedPower;
                     this._lastCalculatedPowerPotential.targetSlotID = CardManager.CARD_LIST_LOC_RANGED;
                  }
               }
               else if(rangedPower > creaturePower || rangedPower == creaturePower && Math.random() < 0.5)
               {
                  creaturePower = rangedPower;
                  this._lastCalculatedPowerPotential.targetSlotID = CardManager.CARD_LIST_LOC_RANGED;
               }
            }
            if(this.templateRef.hasEffect(CardTemplate.CardEffect_SameTypeMorale) || this.templateRef.hasEffect(CardTemplate.CardEffect_ImproveNeighbours))
            {
               cardList = new Vector.<CardInstance>();
               if(this._lastCalculatedPowerPotential.targetSlotID == CardTemplate.CardType_Melee)
               {
                  cardManager.getAllCreaturesNonHero(CardManager.CARD_LIST_LOC_MELEE,this.listsPlayer,cardList);
               }
               if(this._lastCalculatedPowerPotential.targetSlotID == CardTemplate.CardType_Ranged)
               {
                  cardManager.getAllCreaturesNonHero(CardManager.CARD_LIST_LOC_RANGED,this.listsPlayer,cardList);
               }
               if(this._lastCalculatedPowerPotential.targetSlotID == CardTemplate.CardType_Siege)
               {
                  cardManager.getAllCreaturesNonHero(CardManager.CARD_LIST_LOC_SEIGE,this.listsPlayer,cardList);
               }
               if(this.templateRef.hasEffect(CardTemplate.CardEffect_ImproveNeighbours))
               {
                  this._lastCalculatedPowerPotential.powerChangeResult += cardList.length;
               }
               else
               {
                  for(i = 0; i < cardList.length; i++)
                  {
                     currentCard = cardList[i];
                     if(currentCard.templateId == this.templateId)
                     {
                        oldPower = currentCard.getTotalPower();
                        currentCard.effectedByCardsRefList.push(this);
                        this._lastCalculatedPowerPotential.powerChangeResult += currentCard.getTotalPower() - oldPower;
                        currentCard.effectedByCardsRefList.pop();
                     }
                  }
               }
            }
            if(this.templateRef.hasEffect(CardTemplate.CardEffect_SummonClones))
            {
               numClonesToSummon = 0;
               cardList = cardManager.getCardInstanceList(CardManager.CARD_LIST_LOC_HAND,this.listsPlayer);
               for(i = 0; i < cardList.length; i++)
               {
                  if(this.templateRef.summonFlags.indexOf(cardList[i].templateId) != -1)
                  {
                     numClonesToSummon++;
                  }
               }
               for(i = 0; i < this.templateRef.summonFlags.length; i++)
               {
                  numClonesToSummon += cardManager.playerDeckDefinitions[this.listsPlayer].numCopiesLeft(this.templateRef.summonFlags[i]);
               }
               this._lastCalculatedPowerPotential.powerChangeResult += numClonesToSummon * creaturePower;
            }
            if(this.templateRef.isType(CardTemplate.CardType_Spy))
            {
               this._lastCalculatedPowerPotential.powerChangeResult -= creaturePower;
            }
            else
            {
               this._lastCalculatedPowerPotential.powerChangeResult += creaturePower;
            }
         }
         if(this.templateRef.isType(CardTemplate.CardType_Weather))
         {
            totalChange = 0;
            prevPower = 0;
            currentRowList = new Vector.<CardInstance>();
            if(this.templateRef.hasEffect(CardTemplate.CardEffect_ClearSky))
            {
               currentRowList.length = 0;
               cardManager.getAllCreaturesNonHero(CardManager.CARD_LIST_LOC_MELEE,this.listsPlayer,currentRowList);
               cardManager.getAllCreaturesNonHero(CardManager.CARD_LIST_LOC_RANGED,this.listsPlayer,currentRowList);
               cardManager.getAllCreaturesNonHero(CardManager.CARD_LIST_LOC_SEIGE,this.listsPlayer,currentRowList);
               for(i = 0; i < currentRowList.length; i++)
               {
                  totalChange += currentRowList[i].getTotalPower(true) - currentRowList[i].getTotalPower();
               }
               currentRowList.length = 0;
               cardManager.getAllCreaturesNonHero(CardManager.CARD_LIST_LOC_MELEE,opponentPlayer,currentRowList);
               cardManager.getAllCreaturesNonHero(CardManager.CARD_LIST_LOC_RANGED,opponentPlayer,currentRowList);
               cardManager.getAllCreaturesNonHero(CardManager.CARD_LIST_LOC_SEIGE,opponentPlayer,currentRowList);
               for(i = 0; i < currentRowList.length; i++)
               {
                  totalChange -= currentRowList[i].getTotalPower(true) - currentRowList[i].getTotalPower();
               }
            }
            else
            {
               if(this.templateRef.hasEffect(CardTemplate.CardEffect_Melee))
               {
                  currentRowList.length = 0;
                  cardManager.getAllCreaturesNonHero(CardManager.CARD_LIST_LOC_MELEE,this.listsPlayer,currentRowList);
                  for(i = 0; i < currentRowList.length; i++)
                  {
                     currentCard = currentRowList[i];
                     prevPower = currentCard.getTotalPower();
                     currentCard.effectedByCardsRefList.push(this);
                     totalChange += currentCard.getTotalPower() - prevPower;
                     currentCard.effectedByCardsRefList.pop();
                  }
                  currentRowList.length = 0;
                  cardManager.getAllCreaturesNonHero(CardManager.CARD_LIST_LOC_MELEE,opponentPlayer,currentRowList);
                  for(i = 0; i < currentRowList.length; i++)
                  {
                     currentCard = currentRowList[i];
                     prevPower = currentCard.getTotalPower();
                     currentCard.effectedByCardsRefList.push(this);
                     totalChange -= currentCard.getTotalPower() - prevPower;
                     currentCard.effectedByCardsRefList.pop();
                  }
               }
               if(this.templateRef.hasEffect(CardTemplate.CardEffect_Ranged))
               {
                  currentRowList.length = 0;
                  cardManager.getAllCreaturesNonHero(CardManager.CARD_LIST_LOC_RANGED,this.listsPlayer,currentRowList);
                  for(i = 0; i < currentRowList.length; i++)
                  {
                     currentCard = currentRowList[i];
                     prevPower = currentCard.getTotalPower();
                     currentCard.effectedByCardsRefList.push(this);
                     totalChange += currentCard.getTotalPower() - prevPower;
                     currentCard.effectedByCardsRefList.pop();
                  }
                  currentRowList.length = 0;
                  cardManager.getAllCreaturesNonHero(CardManager.CARD_LIST_LOC_RANGED,opponentPlayer,currentRowList);
                  for(i = 0; i < currentRowList.length; i++)
                  {
                     currentCard = currentRowList[i];
                     prevPower = currentCard.getTotalPower();
                     currentCard.effectedByCardsRefList.push(this);
                     totalChange -= currentCard.getTotalPower() - prevPower;
                     currentCard.effectedByCardsRefList.pop();
                  }
               }
               if(this.templateRef.hasEffect(CardTemplate.CardEffect_Siege))
               {
                  currentRowList.length = 0;
                  cardManager.getAllCreaturesNonHero(CardManager.CARD_LIST_LOC_SEIGE,this.listsPlayer,currentRowList);
                  for(i = 0; i < currentRowList.length; i++)
                  {
                     currentCard = currentRowList[i];
                     prevPower = currentCard.getTotalPower();
                     currentCard.effectedByCardsRefList.push(this);
                     totalChange += currentCard.getTotalPower() - prevPower;
                     currentCard.effectedByCardsRefList.pop();
                  }
                  currentRowList.length = 0;
                  cardManager.getAllCreaturesNonHero(CardManager.CARD_LIST_LOC_SEIGE,opponentPlayer,currentRowList);
                  for(i = 0; i < currentRowList.length; i++)
                  {
                     currentCard = currentRowList[i];
                     prevPower = currentCard.getTotalPower();
                     currentCard.effectedByCardsRefList.push(this);
                     totalChange -= currentCard.getTotalPower() - prevPower;
                     currentCard.effectedByCardsRefList.pop();
                  }
               }
            }
            this._lastCalculatedPowerPotential.powerChangeResult = totalChange;
            this._lastCalculatedPowerPotential.strategicValue = Math.max(0,cardManager.cardValues.weatherCardValue - totalChange);
            if(this.templateRef.hasEffect(CardTemplate.CardEffect_ClearSky))
            {
               this._lastCalculatedPowerPotential.strategicValue = Math.max(this._lastCalculatedPowerPotential.strategicValue,8);
            }
            this._lastCalculatedPowerPotential.targetSlotID = CardManager.CARD_LIST_LOC_WEATHERSLOT;
            this._lastCalculatedPowerPotential.targetPlayerID = CardManager.PLAYER_INVALID;
         }
         var cardsBeingRemoved:Vector.<CardInstance> = null;
         if(this.templateRef.hasEffect(CardTemplate.CardEffect_Scorch))
         {
            cardsBeingRemoved = cardManager.getScorchTargets();
         }
         if(cardsBeingRemoved != null)
         {
            if(this.templateRef.isType(CardTemplate.CardType_Creature))
            {
               if(cardsBeingRemoved.length == 0 || cardsBeingRemoved[0].getTotalPower() < this._lastCalculatedPowerPotential.powerChangeResult)
               {
                  this._lastCalculatedPowerPotential.strategicValue = -1;
                  this._lastCalculatedPowerPotential.powerChangeResult = 0;
                  return;
               }
            }
            for(i = 0; i < cardsBeingRemoved.length; i++)
            {
               currentCard = cardsBeingRemoved[i];
               if(currentCard.listsPlayer == this.listsPlayer)
               {
                  this._lastCalculatedPowerPotential.powerChangeResult -= currentCard.getTotalPower();
               }
               else
               {
                  this._lastCalculatedPowerPotential.powerChangeResult += currentCard.getTotalPower();
               }
            }
            if(this._lastCalculatedPowerPotential.powerChangeResult < 0)
            {
               this._lastCalculatedPowerPotential.strategicValue = -1;
            }
            else
            {
               this._lastCalculatedPowerPotential.strategicValue = Math.max(this.templateRef.GetBonusValue(),this._lastCalculatedPowerPotential.powerChangeResult);
            }
            return;
         }
         if(this.templateRef.hasEffect(CardTemplate.CardEffect_UnsummonDummy))
         {
            this._lastCalculatedPowerPotential.targetCardInstanceRef = cardManager.getHigherOrLowerValueTargetCardOnBoard(this,this.listsPlayer,false,false,true);
            if(this._lastCalculatedPowerPotential.targetCardInstanceRef)
            {
               if(this._lastCalculatedPowerPotential.targetCardInstanceRef.templateRef.isType(CardTemplate.CardType_Spy))
               {
                  this._lastCalculatedPowerPotential.powerChangeResult = 0;
               }
               else
               {
                  this._lastCalculatedPowerPotential.powerChangeResult = -this._lastCalculatedPowerPotential.targetCardInstanceRef.getTotalPower();
               }
               if(cardManager.cardValues.unsummonCardValue + this._lastCalculatedPowerPotential.powerChangeResult >= 0)
               {
                  this._lastCalculatedPowerPotential.strategicValue = Math.abs(this._lastCalculatedPowerPotential.powerChangeResult);
               }
               else
               {
                  this._lastCalculatedPowerPotential.strategicValue = cardManager.cardValues.unsummonCardValue + Math.abs(this._lastCalculatedPowerPotential.powerChangeResult);
               }
            }
            else
            {
               this._lastCalculatedPowerPotential.powerChangeResult = -1000;
               this._lastCalculatedPowerPotential.strategicValue = -1;
            }
         }
         if(this.templateRef.isType(CardTemplate.CardType_Row_Modifier) && this.templateRef.hasEffect(CardTemplate.CardEffect_Mushroom))
         {
            beserkersOnBoard = new Vector.<CardInstance>();
            beserkersInHand = new Vector.<CardInstance>();
            cardManager.getBeserkersOnBoard(this.listsPlayer,beserkersOnBoard);
            cardManager.getBeserkersInHand(this.listsPlayer,beserkersInHand);
            if(beserkersOnBoard.length == 0)
            {
               if(beserkersInHand.length == 0)
               {
                  this._lastCalculatedPowerPotential.powerChangeResult = 0;
                  this._lastCalculatedPowerPotential.strategicValue = 0;
                  this._lastCalculatedPowerPotential.targetPlayerID = this.listsPlayer;
                  switch(Math.floor(Math.random() * 2))
                  {
                     case 0:
                        if(cardManager.getCardInstanceList(CardManager.CARD_LIST_LOC_MELEEMODIFIERS,this.listsPlayer).length == 0)
                        {
                           this._lastCalculatedPowerPotential.targetSlotID = CardManager.CARD_LIST_LOC_MELEEMODIFIERS;
                        }
                        else if(cardManager.getCardInstanceList(CardManager.CARD_LIST_LOC_RANGEDMODIFIERS,this.listsPlayer).length == 0)
                        {
                           this._lastCalculatedPowerPotential.targetSlotID = CardManager.CARD_LIST_LOC_RANGEDMODIFIERS;
                        }
                        else
                        {
                           this._lastCalculatedPowerPotential.strategicValue = -1;
                           this._lastCalculatedPowerPotential.powerChangeResult = -1000;
                        }
                        break;
                     case 1:
                        if(cardManager.getCardInstanceList(CardManager.CARD_LIST_LOC_RANGEDMODIFIERS,this.listsPlayer).length == 0)
                        {
                           this._lastCalculatedPowerPotential.targetSlotID = CardManager.CARD_LIST_LOC_RANGEDMODIFIERS;
                        }
                        else if(cardManager.getCardInstanceList(CardManager.CARD_LIST_LOC_MELEEMODIFIERS,this.listsPlayer).length == 0)
                        {
                           this._lastCalculatedPowerPotential.targetSlotID = CardManager.CARD_LIST_LOC_MELEEMODIFIERS;
                        }
                        else
                        {
                           this._lastCalculatedPowerPotential.strategicValue = -1;
                           this._lastCalculatedPowerPotential.powerChangeResult = -1000;
                        }
                  }
               }
               else
               {
                  this._lastCalculatedPowerPotential.strategicValue = -1;
                  this._lastCalculatedPowerPotential.powerChangeResult = -1000;
                  this._lastCalculatedPowerPotential.targetSlotID = CardManager.CARD_LIST_LOC_SEIGEMODIFIERS;
                  this._lastCalculatedPowerPotential.targetPlayerID = this.listsPlayer;
               }
            }
            else
            {
               hasErmionInHand = false;
               for each(cardInHand in cardManager.getCardInstanceList(CardManager.CARD_LIST_LOC_HAND,this.listsPlayer))
               {
                  if(cardInHand.templateId == 503)
                  {
                     hasErmionInHand = true;
                     break;
                  }
               }
               targetRow = CardManager.CARD_LIST_LOC_SEIGEMODIFIERS;
               meleeCount = 0;
               rangedCount = 0;
               meleeAvailable = cardManager.getCardInstanceList(CardManager.CARD_LIST_LOC_MELEEMODIFIERS,this.listsPlayer).length == 0;
               rangedAvailable = cardManager.getCardInstanceList(CardManager.CARD_LIST_LOC_RANGEDMODIFIERS,this.listsPlayer).length == 0;
               for each(beserkerCard in beserkersOnBoard)
               {
                  if(beserkerCard.inList == CardManager.CARD_LIST_LOC_MELEE && meleeAvailable)
                  {
                     meleeCount += 1;
                  }
                  else if(beserkerCard.inList == CardManager.CARD_LIST_LOC_RANGED && rangedAvailable)
                  {
                     rangedCount += 1;
                  }
               }
               if(beserkersInHand.length != 0)
               {
                  for each(beserkerCard in beserkersInHand)
                  {
                     if(beserkerCard.inList == CardManager.CARD_LIST_LOC_MELEE && meleeAvailable)
                     {
                        meleeCount += 1;
                     }
                     else if(beserkerCard.inList == CardManager.CARD_LIST_LOC_RANGED && rangedAvailable)
                     {
                        rangedCount += 1;
                     }
                  }
               }
               if(meleeCount > 0 && hasErmionInHand || meleeCount > 0 && meleeCount > rangedCount)
               {
                  targetRow = CardManager.CARD_LIST_LOC_MELEEMODIFIERS;
                  this._lastCalculatedPowerPotential.strategicValue = 0;
                  this._lastCalculatedPowerPotential.powerChangeResult = meleeCount * 8;
               }
               else if(rangedCount > 0)
               {
                  targetRow = CardManager.CARD_LIST_LOC_RANGEDMODIFIERS;
                  this._lastCalculatedPowerPotential.strategicValue = 0;
                  this._lastCalculatedPowerPotential.powerChangeResult = rangedCount * 8;
               }
               if(targetRow == CardManager.CARD_LIST_LOC_SEIGEMODIFIERS)
               {
                  this._lastCalculatedPowerPotential.strategicValue = -1;
                  this._lastCalculatedPowerPotential.powerChangeResult = -1000;
               }
               this._lastCalculatedPowerPotential.targetPlayerID = this.listsPlayer;
               this._lastCalculatedPowerPotential.targetSlotID = targetRow;
            }
         }
         if(this.templateRef.isType(CardTemplate.CardType_Row_Modifier) && this.templateRef.hasEffect(CardTemplate.CardEffect_Horn))
         {
            meleeRowIncrease = -1;
            rangeRowIncrease = -1;
            seigeRowIncrease = -1;
            oldValue = 0;
            currentRowList = new Vector.<CardInstance>();
            if(cardManager.getCardInstanceList(CardManager.CARD_LIST_LOC_MELEEMODIFIERS,this.listsPlayer).length == 0)
            {
               cardManager.getAllCreaturesNonHero(CardManager.CARD_LIST_LOC_MELEE,this.listsPlayer,currentRowList);
               meleeRowIncrease = 0;
               for(i = 0; i < currentRowList.length; i++)
               {
                  currentCard = currentRowList[i];
                  oldValue = currentCard.getTotalPower();
                  currentCard.effectedByCardsRefList.push(this);
                  meleeRowIncrease = currentCard.getTotalPower() - oldValue;
                  currentCard.effectedByCardsRefList.pop();
               }
            }
            currentRowList.length = 0;
            if(cardManager.getCardInstanceList(CardManager.CARD_LIST_LOC_RANGEDMODIFIERS,this.listsPlayer).length == 0)
            {
               cardManager.getAllCreaturesNonHero(CardManager.CARD_LIST_LOC_RANGED,this.listsPlayer,currentRowList);
               rangeRowIncrease = 0;
               for(i = 0; i < currentRowList.length; i++)
               {
                  currentCard = currentRowList[i];
                  oldValue = currentCard.getTotalPower();
                  currentCard.effectedByCardsRefList.push(this);
                  rangeRowIncrease = currentCard.getTotalPower() - oldValue;
                  currentCard.effectedByCardsRefList.pop();
               }
            }
            currentRowList.length = 0;
            if(cardManager.getCardInstanceList(CardManager.CARD_LIST_LOC_SEIGEMODIFIERS,this.listsPlayer).length == 0)
            {
               cardManager.getAllCreaturesNonHero(CardManager.CARD_LIST_LOC_SEIGE,this.listsPlayer,currentRowList);
               seigeRowIncrease = 0;
               for(i = 0; i < currentRowList.length; i++)
               {
                  currentCard = currentRowList[i];
                  currentCard.effectedByCardsRefList.push(this);
                  seigeRowIncrease = currentCard.getTotalPower() - oldValue;
                  currentCard.effectedByCardsRefList.pop();
               }
            }
            if(seigeRowIncrease == -1 && meleeRowIncrease == -1 && rangeRowIncrease == -1)
            {
               this._lastCalculatedPowerPotential.powerChangeResult = -1;
               this._lastCalculatedPowerPotential.strategicValue = -1;
               return;
            }
            if(meleeRowIncrease > seigeRowIncrease && meleeRowIncrease > rangeRowIncrease)
            {
               this._lastCalculatedPowerPotential.powerChangeResult = meleeRowIncrease;
               this._lastCalculatedPowerPotential.targetSlotID = CardManager.CARD_LIST_LOC_MELEEMODIFIERS;
               this._lastCalculatedPowerPotential.targetPlayerID = this.listsPlayer;
            }
            else if(rangeRowIncrease > seigeRowIncrease)
            {
               this._lastCalculatedPowerPotential.powerChangeResult = rangeRowIncrease;
               this._lastCalculatedPowerPotential.targetSlotID = CardManager.CARD_LIST_LOC_RANGEDMODIFIERS;
               this._lastCalculatedPowerPotential.targetPlayerID = this.listsPlayer;
            }
            else
            {
               this._lastCalculatedPowerPotential.powerChangeResult = seigeRowIncrease;
               this._lastCalculatedPowerPotential.targetSlotID = CardManager.CARD_LIST_LOC_SEIGEMODIFIERS;
               this._lastCalculatedPowerPotential.targetPlayerID = this.listsPlayer;
            }
            if(this._lastCalculatedPowerPotential.powerChangeResult > cardManager.cardValues.hornCardValue)
            {
               this._lastCalculatedPowerPotential.strategicValue = Math.max(0,cardManager.cardValues.hornCardValue * 2 - this._lastCalculatedPowerPotential.powerChangeResult);
            }
            else
            {
               this._lastCalculatedPowerPotential.strategicValue = cardManager.cardValues.hornCardValue;
            }
         }
         if(this.templateRef.hasEffect(CardTemplate.CardEffect_MeleeScorch))
         {
            scorchRowList = null;
            scorchRowList = cardManager.getScorchTargets(CardTemplate.CardType_Melee,this.notListPlayer);
            if(scorchRowList.length != 0 && cardManager.calculatePlayerScore(CardManager.CARD_LIST_LOC_MELEE,this.notListPlayer) >= 10)
            {
               i = 0;
               onlyScorchedCardsPower = 0;
               totalScorchPower = 0;
               for(i = 0; i < scorchRowList.length; i++)
               {
                  totalScorchPower = scorchRowList[i].getTotalPower();
                  this._lastCalculatedPowerPotential.powerChangeResult += totalScorchPower;
                  onlyScorchedCardsPower += totalScorchPower;
               }
               if(Math.random() >= 2 / scorchRowList.length || Math.random() >= 4 / onlyScorchedCardsPower)
               {
                  this._lastCalculatedPowerPotential.strategicValue = 1;
               }
               else
               {
                  this._lastCalculatedPowerPotential.strategicValue = this._lastCalculatedPowerPotential.powerChangeResult;
               }
            }
            else
            {
               this._lastCalculatedPowerPotential.strategicValue = this._lastCalculatedPowerPotential.powerChangeResult + cardManager.cardValues.scorchCardValue;
            }
         }
         if(this.templateRef.hasEffect(CardTemplate.CardEffect_RangedScorch))
         {
            scorchRowList = null;
            scorchRowList = cardManager.getScorchTargets(CardTemplate.CardType_Ranged,this.notListPlayer);
            if(scorchRowList.length != 0 && cardManager.calculatePlayerScore(CardManager.CARD_LIST_LOC_RANGED,this.notListPlayer) >= 10)
            {
               i = 0;
               onlyScorchedCardsPower = 0;
               totalScorchPower = 0;
               for(i = 0; i < scorchRowList.length; i++)
               {
                  totalScorchPower = scorchRowList[i].getTotalPower();
                  this._lastCalculatedPowerPotential.powerChangeResult += totalScorchPower;
                  onlyScorchedCardsPower += totalScorchPower;
               }
               if(Math.random() >= 2 / scorchRowList.length || Math.random() >= 4 / onlyScorchedCardsPower)
               {
                  this._lastCalculatedPowerPotential.strategicValue = 1;
               }
               else
               {
                  this._lastCalculatedPowerPotential.strategicValue = this._lastCalculatedPowerPotential.powerChangeResult;
               }
            }
            else
            {
               this._lastCalculatedPowerPotential.strategicValue = this._lastCalculatedPowerPotential.powerChangeResult + cardManager.cardValues.scorchCardValue;
            }
         }
         if(this.templateRef.isType(CardTemplate.CardType_Creature))
         {
            if(this.templateRef.hasEffect(CardTemplate.CardEffect_Nurse))
            {
               forNurseList = new Vector.<CardInstance>();
               onlyNursesAtHand = true;
               for(i = 0; i < playerCardsInHand.length; i++)
               {
                  if(!playerCardsInHand[i].templateRef.hasEffect(CardTemplate.CardEffect_Nurse))
                  {
                     onlyNursesAtHand = false;
                     break;
                  }
               }
               cardManager.GetRessurectionTargets(this.listsPlayer,forNurseList,false);
               if(forNurseList.length == 0)
               {
                  if(!onlyNursesAtHand)
                  {
                     this._lastCalculatedPowerPotential.powerChangeResult = -1000;
                     this._lastCalculatedPowerPotential.strategicValue = -1;
                  }
               }
               else
               {
                  for(i = 0; i < forNurseList.length; i++)
                  {
                     if(!forNurseList[i].templateRef.hasEffect(CardTemplate.CardEffect_Nurse))
                     {
                        forNurseList[i].recalculatePowerPotential(cardManager);
                     }
                  }
                  forNurseList.sort(this.powerChangeSorter);
                  currentInstance = forNurseList[forNurseList.length - 1];
                  ressurectedCardValue = currentInstance.getOptimalTransaction().powerChangeResult;
                  this._lastCalculatedPowerPotential.powerChangeResult += ressurectedCardValue;
                  if(Math.random() <= 1 / playerCardsInHand.length || Math.random() >= 8 / ressurectedCardValue)
                  {
                     this._lastCalculatedPowerPotential.strategicValue = 0;
                  }
                  else
                  {
                     nursePlusRessurectedValue = cardManager.cardValues.nurseCardValue + ressurectedCardValue;
                     this._lastCalculatedPowerPotential.strategicValue = Math.max(nursePlusRessurectedValue,this.templateRef.power);
                  }
               }
            }
            else if(this._lastCalculatedPowerPotential.strategicValue == 0)
            {
               this._lastCalculatedPowerPotential.strategicValue += this.templateRef.power;
            }
         }
      }
      
      public function scoreGainOnReposition() : int
      {
         var moveScore:int = 0;
         var newEffectList:Vector.<CardInstance> = null;
         var i:int = 0;
         var oldEffectList:Vector.<CardInstance> = new Vector.<CardInstance>();
         if(this.templateRef.isType(CardTemplate.CardType_RangedMelee))
         {
            for(i = 0; i < this.effectedByCardsRefList.length; i++)
            {
               oldEffectList.push(this.effectedByCardsRefList[i]);
            }
            newEffectList = CardManager.getInstance().cardEffectManager.getEffectsForList(this.inList == CardManager.CARD_LIST_LOC_MELEE ? CardManager.CARD_LIST_LOC_RANGED : CardManager.CARD_LIST_LOC_MELEE,this.listsPlayer);
            this.effectedByCardsRefList.length = 0;
            for(i = 0; i < newEffectList.length; i++)
            {
               this.effectedByCardsRefList.push(newEffectList[i]);
            }
            moveScore = this.getTotalPower();
            this.effectedByCardsRefList.length = 0;
            for(i = 0; i < oldEffectList.length; i++)
            {
               this.effectedByCardsRefList.push(oldEffectList[i]);
            }
            if(moveScore > this.getTotalPower())
            {
               return moveScore - this.getTotalPower();
            }
         }
         return 0;
      }
      
      public function getOptimalTransaction() : CardTransaction
      {
         return this._lastCalculatedPowerPotential;
      }
      
      public function onFinishedMovingIntoHolder(listID:int, playerID:int) : void
      {
         var cardManagerRef:CardManager = null;
         var it:int = 0;
         var currentList:Vector.<CardInstance> = null;
         var currentCard:CardInstance = null;
         var cardFXManager:CardFXManager = null;
         var cardList:Vector.<CardInstance> = null;
         var weatherList:Vector.<CardInstance> = null;
         var curWeather:CardInstance = null;
         if(this.lastListApplied != listID || this.lastListPlayerApplied != playerID)
         {
            trace("GFX - finished Moving into holder:",listID,", playerID:",playerID,", for cardInstance:",this);
            cardManagerRef = CardManager.getInstance();
            this.lastListApplied = listID;
            this.lastListPlayerApplied = playerID;
            cardFXManager = CardFXManager.getInstance();
            if(listID == CardManager.CARD_LIST_LOC_DECK || listID == CardManager.CARD_LIST_LOC_LEADER)
            {
               return;
            }
            while(this.effectingCardsRefList.length > 0)
            {
               this.removeFromEffectingList(this.effectingCardsRefList[0]);
            }
            while(this.effectedByCardsRefList.length > 0)
            {
               this.effectedByCardsRefList[0].removeFromEffectingList(this);
            }
            this.effectingCardsRefList.length = 0;
            cardManagerRef.cardEffectManager.unregisterActiveEffectCardInstance(this);
            this.powerChangeCallback();
            if(listID == CardManager.CARD_LIST_LOC_GRAVEYARD || listID == CardManager.CARD_LIST_LOC_HAND)
            {
               return;
            }
            if(this.templateRef.isType(CardTemplate.CardType_Creature) || this.templateRef.hasEffect(CardTemplate.CardEffect_UnsummonDummy) && this.templateId != 500)
            {
               cardFXManager.playCardDeployFX(this,this.updateEffectsApplied);
            }
            else if(this.templateRef.isType(CardTemplate.CardType_Weather))
            {
               if(this.templateRef.hasEffect(CardTemplate.CardEffect_ClearSky))
               {
                  cardList = cardManagerRef.getCardInstanceList(CardManager.CARD_LIST_LOC_WEATHERSLOT,CardManager.PLAYER_INVALID);
                  trace("GFX - Applying Clear weather effect, numTargets: " + cardList.length);
                  while(cardList.length > 0)
                  {
                     cardManagerRef.sendToGraveyard(cardList[0]);
                  }
               }
               else
               {
                  currentList = new Vector.<CardInstance>();
                  weatherList = cardManagerRef.getCardInstanceList(CardManager.CARD_LIST_LOC_WEATHERSLOT,CardManager.PLAYER_INVALID);
                  for each(curWeather in weatherList)
                  {
                     currentList.push(curWeather);
                  }
                  if(this.templateRef.effectFlags.length == 2)
                  {
                     for(it = 0; it < currentList.length; it++)
                     {
                        currentCard = currentList[it];
                        if(currentCard != this)
                        {
                           if(currentCard.templateId == this.templateId)
                           {
                              cardManagerRef.sendToGraveyard(currentCard);
                           }
                           else if(this.templateRef.effectFlags.indexOf(currentCard.templateRef.getFirstEffect()) != -1)
                           {
                              cardManagerRef.sendToGraveyard(currentCard);
                           }
                        }
                     }
                  }
                  else
                  {
                     for(it = 0; it < currentList.length; it++)
                     {
                        currentCard = currentList[it];
                        if(currentCard.templateRef.effectFlags.indexOf(this.templateRef.getFirstEffect()) != -1 && currentCard != this)
                        {
                           cardManagerRef.sendToGraveyard(this);
                           return;
                        }
                     }
                  }
               }
               cardFXManager.playCardDeployFX(this,this.updateEffectsApplied);
            }
            else
            {
               this.updateEffectsApplied();
            }
         }
      }
      
      protected function removeFromEffectingList(cardInstance:CardInstance) : void
      {
         var indexOf:int = this.effectingCardsRefList.indexOf(cardInstance);
         if(indexOf != -1)
         {
            this.effectingCardsRefList.splice(indexOf,1);
            cardInstance.removeEffect(this);
            this.powerChangeCallback();
         }
      }
      
      protected function addToEffectingList(cardInstance:CardInstance) : void
      {
         if(this.effectingCardsRefList.indexOf(cardInstance) == -1)
         {
            this.effectingCardsRefList.push(cardInstance);
            cardInstance.addEffect(this);
         }
      }
      
      protected function addEffect(sourceOfEffect:CardInstance) : void
      {
         this.effectedByCardsRefList.push(sourceOfEffect);
         this.powerChangeCallback();
      }
      
      protected function removeEffect(sourceEffect:CardInstance) : void
      {
         var indexOf:int = this.effectedByCardsRefList.indexOf(sourceEffect);
         if(indexOf != -1)
         {
            this.effectedByCardsRefList.splice(indexOf,1);
            this.powerChangeCallback();
         }
      }
      
      public function updateEffectsApplied(cardInstance:CardInstance = null) : void
      {
         var it:int = 0;
         var cardList:Vector.<CardInstance> = null;
         var copyList:Vector.<CardInstance> = null;
         var currentInstance:CardInstance = null;
         var scorchList:Vector.<CardInstance> = null;
         var i:int = 0;
         var scorchMeleeList:Vector.<CardInstance> = null;
         var scorchRangedList:Vector.<CardInstance> = null;
         var scorchSiegeList:Vector.<CardInstance> = null;
         var isSkelligeFaction:* = false;
         var sfxString:String = null;
         var mushroomFX:CardFX = null;
         var transformed:Boolean = false;
         var fellowRowInstance:CardInstance = null;
         var spawnedFX:CardFX = null;
         var cardAndComboPoints:CardAndComboPoints = null;
         var foundOtherCard:Boolean = false;
         var deck:GwintDeck = null;
         var hand_it:int = 0;
         var hasSummons:Boolean = false;
         var cardFXManager:CardFXManager = CardFXManager.getInstance();
         var cardManagerRef:CardManager = CardManager.getInstance();
         var gameFlowRef:GwintGameFlowController = GwintGameFlowController.getInstance();
         var effectedList:int = CardManager.CARD_LIST_LOC_INVALID;
         trace("GFX - updateEffectsApplied Called ----------");
         if(this.templateRef.isType(CardTemplate.CardType_Creature) && !this.templateRef.isType(CardTemplate.CardType_Hero))
         {
            cardList = cardManagerRef.cardEffectManager.getEffectsForList(this.inList,this.listsPlayer);
            trace("GFX - fetched: ",cardList.length,", effects for list:",this.inList,", and Player:",this.listsPlayer);
            for(it = 0; it < cardList.length; it++)
            {
               currentInstance = cardList[it];
               if(currentInstance != this)
               {
                  currentInstance.addToEffectingList(this);
               }
            }
         }
         if(this.templateRef.isType(CardTemplate.CardType_Weather))
         {
            if(!this.templateRef.hasEffect(CardTemplate.CardEffect_ClearSky))
            {
               cardList = new Vector.<CardInstance>();
               if(this.templateRef.hasEffect(CardTemplate.CardEffect_Melee))
               {
                  cardManagerRef.getAllCreaturesNonHero(CardManager.CARD_LIST_LOC_MELEE,CardManager.PLAYER_1,cardList);
                  cardManagerRef.getAllCreaturesNonHero(CardManager.CARD_LIST_LOC_MELEE,CardManager.PLAYER_2,cardList);
                  cardManagerRef.cardEffectManager.registerActiveEffectCardInstance(this,CardManager.CARD_LIST_LOC_MELEE,CardManager.PLAYER_1);
                  cardManagerRef.cardEffectManager.registerActiveEffectCardInstance(this,CardManager.CARD_LIST_LOC_MELEE,CardManager.PLAYER_2);
                  trace("GFX - Applying Melee Weather Effect");
               }
               if(this.templateRef.hasEffect(CardTemplate.CardEffect_Ranged))
               {
                  cardManagerRef.getAllCreaturesNonHero(CardManager.CARD_LIST_LOC_RANGED,CardManager.PLAYER_1,cardList);
                  cardManagerRef.getAllCreaturesNonHero(CardManager.CARD_LIST_LOC_RANGED,CardManager.PLAYER_2,cardList);
                  cardManagerRef.cardEffectManager.registerActiveEffectCardInstance(this,CardManager.CARD_LIST_LOC_RANGED,CardManager.PLAYER_1);
                  cardManagerRef.cardEffectManager.registerActiveEffectCardInstance(this,CardManager.CARD_LIST_LOC_RANGED,CardManager.PLAYER_2);
                  trace("GFX - Applying Ranged Weather Effect");
               }
               if(this.templateRef.hasEffect(CardTemplate.CardEffect_Siege))
               {
                  cardManagerRef.getAllCreaturesNonHero(CardManager.CARD_LIST_LOC_SEIGE,CardManager.PLAYER_1,cardList);
                  cardManagerRef.getAllCreaturesNonHero(CardManager.CARD_LIST_LOC_SEIGE,CardManager.PLAYER_2,cardList);
                  cardManagerRef.cardEffectManager.registerActiveEffectCardInstance(this,CardManager.CARD_LIST_LOC_SEIGE,CardManager.PLAYER_1);
                  cardManagerRef.cardEffectManager.registerActiveEffectCardInstance(this,CardManager.CARD_LIST_LOC_SEIGE,CardManager.PLAYER_2);
                  trace("GFX - Applying SIEGE Weather Effect");
               }
               for(it = 0; it < cardList.length; it++)
               {
                  currentInstance = cardList[it];
                  this.addToEffectingList(currentInstance);
               }
            }
         }
         if(this.templateRef.hasEffect(CardTemplate.CardEffect_Scorch))
         {
            scorchList = cardManagerRef.getScorchTargets();
            trace("GFX - Applying Scorch Effect, number of targets: " + scorchList.length);
            GwintGameMenu.mSingleton.playSound("gui_gwint_scorch");
            for(i = 0; i < scorchList.length; i++)
            {
               cardFXManager.playScorchEffectFX(scorchList[i],this.onScorchFXEnd);
            }
         }
         if(this.templateRef.hasEffect(CardTemplate.CardEffect_MeleeScorch))
         {
            if(cardManagerRef.calculatePlayerScore(CardManager.CARD_LIST_LOC_MELEE,this.notListPlayer) >= 10)
            {
               scorchMeleeList = cardManagerRef.getScorchTargets(CardTemplate.CardType_Melee,this.notListPlayer);
               trace("GFX - Applying scorchMeleeList, number of targets: " + scorchMeleeList.length);
               GwintGameMenu.mSingleton.playSound("gui_gwint_scorch");
               for(it = 0; it < scorchMeleeList.length; it++)
               {
                  cardFXManager.playScorchEffectFX(scorchMeleeList[it],this.onScorchFXEnd);
               }
            }
         }
         if(this.templateRef.hasEffect(CardTemplate.CardEffect_RangedScorch))
         {
            if(cardManagerRef.calculatePlayerScore(CardManager.CARD_LIST_LOC_RANGED,this.notListPlayer) >= 10)
            {
               scorchRangedList = cardManagerRef.getScorchTargets(CardTemplate.CardType_Ranged,this.notListPlayer);
               trace("GFX - Applying scorchRangedList, number of targets: " + scorchRangedList.length);
               GwintGameMenu.mSingleton.playSound("gui_gwint_scorch");
               for(it = 0; it < scorchRangedList.length; it++)
               {
                  cardFXManager.playScorchEffectFX(scorchRangedList[it],this.onScorchFXEnd);
               }
            }
         }
         if(this.templateRef.hasEffect(CardTemplate.CardEffect_Siege_Scorch))
         {
            if(cardManagerRef.calculatePlayerScore(CardManager.CARD_LIST_LOC_SEIGE,this.notListPlayer) >= 10)
            {
               scorchSiegeList = cardManagerRef.getScorchTargets(CardTemplate.CardType_Siege,this.notListPlayer);
               trace("GFX - Applying scorchSiegeList, number of targets: " + scorchSiegeList.length);
               GwintGameMenu.mSingleton.playSound("gui_gwint_scorch");
               for(it = 0; it < scorchSiegeList.length; it++)
               {
                  cardFXManager.playScorchEffectFX(scorchSiegeList[it],this.onScorchFXEnd);
               }
            }
         }
         if(this.templateRef.hasEffect(CardTemplate.CardEffect_Horn))
         {
            trace("GFX - Applying Horn Effect ----------");
            effectedList = CardManager.CARD_LIST_LOC_INVALID;
            if(this.inList == CardManager.CARD_LIST_LOC_MELEEMODIFIERS || this.inList == CardManager.CARD_LIST_LOC_MELEE)
            {
               effectedList = CardManager.CARD_LIST_LOC_MELEE;
            }
            else if(this.inList == CardManager.CARD_LIST_LOC_RANGEDMODIFIERS || this.inList == CardManager.CARD_LIST_LOC_RANGED)
            {
               effectedList = CardManager.CARD_LIST_LOC_RANGED;
            }
            else if(this.inList == CardManager.CARD_LIST_LOC_SEIGEMODIFIERS || this.inList == CardManager.CARD_LIST_LOC_SEIGE)
            {
               effectedList = CardManager.CARD_LIST_LOC_SEIGE;
            }
            if(effectedList != CardManager.PLAYER_INVALID)
            {
               cardList = cardManagerRef.getCardInstanceList(effectedList,this.listsPlayer);
               if(cardList)
               {
                  for(it = 0; it < cardList.length; it++)
                  {
                     currentInstance = cardList[it];
                     if(!currentInstance.templateRef.isType(CardTemplate.CardType_Hero) && currentInstance != this)
                     {
                        this.addToEffectingList(currentInstance);
                     }
                  }
               }
               cardFXManager.playerCardEffectFX(this,null);
               cardFXManager.playRowEffect(effectedList,this.listsPlayer,cardFXManager._hornRowFXClassRef);
               cardManagerRef.cardEffectManager.registerActiveEffectCardInstance(this,effectedList,this.listsPlayer);
            }
         }
         if(this.templateRef.hasEffect(CardTemplate.CardEffect_Mushroom))
         {
            effectedList = CardManager.CARD_LIST_LOC_INVALID;
            if(this.inList == CardManager.CARD_LIST_LOC_MELEEMODIFIERS || this.inList == CardManager.CARD_LIST_LOC_MELEE)
            {
               effectedList = CardManager.CARD_LIST_LOC_MELEE;
            }
            else if(this.inList == CardManager.CARD_LIST_LOC_RANGEDMODIFIERS || this.inList == CardManager.CARD_LIST_LOC_RANGED)
            {
               effectedList = CardManager.CARD_LIST_LOC_RANGED;
            }
            else if(this.inList == CardManager.CARD_LIST_LOC_SEIGEMODIFIERS || this.inList == CardManager.CARD_LIST_LOC_SEIGE)
            {
               effectedList = CardManager.CARD_LIST_LOC_SEIGE;
            }
            isSkelligeFaction = cardManagerRef.getSpawnedFaction(this) == CardTemplate.FactionId_Skellige;
            sfxString = isSkelligeFaction ? "gui_gwint_ske_mushroom" : "gui_gwint_mushroom";
            GwintGameMenu.mSingleton.playSound(sfxString);
            mushroomFX = cardFXManager.playRowEffect(effectedList,this.listsPlayer,cardFXManager._mushroomFXClassRef);
            mushroomFX.midFXPointCallback = this.mushroomFXTrigger;
            mushroomFX.associatedCardInstance = this;
         }
         if(this.templateRef.hasEffect(CardTemplate.CardEffect_Morph) && this.templateRef.summonFlags.length > 0)
         {
            transformed = false;
            for each(fellowRowInstance in cardManagerRef.getCardInstanceList(this.inList,this.listsPlayer))
            {
               if(fellowRowInstance.templateRef.hasEffect(CardTemplate.CardEffect_Mushroom))
               {
                  transformed = true;
                  break;
               }
            }
            if(!transformed)
            {
               if(this.inList == CardManager.CARD_LIST_LOC_MELEE && cardManagerRef.hasRowModifier(CardManager.CARD_LIST_LOC_MELEEMODIFIERS,this.listsPlayer,CardTemplate.CardEffect_Mushroom))
               {
                  transformed = true;
               }
               else if(this.inList == CardManager.CARD_LIST_LOC_RANGED && cardManagerRef.hasRowModifier(CardManager.CARD_LIST_LOC_RANGEDMODIFIERS,this.listsPlayer,CardTemplate.CardEffect_Mushroom))
               {
                  transformed = true;
               }
               else if(this.inList == CardManager.CARD_LIST_LOC_SEIGE && cardManagerRef.hasRowModifier(CardManager.CARD_LIST_LOC_SEIGEMODIFIERS,this.listsPlayer,CardTemplate.CardEffect_Mushroom))
               {
                  transformed = true;
               }
            }
            if(transformed)
            {
               spawnedFX = cardFXManager.playerCardEffectFX(this,this.morphFXEnded);
               if(spawnedFX != null)
               {
                  spawnedFX.associatedCardInstance = this;
                  spawnedFX.midFXPointCallback = this.morphFXMidPointTrigger;
               }
            }
         }
         if(this.templateRef.hasEffect(CardTemplate.CardEffect_Nurse))
         {
            copyList = new Vector.<CardInstance>();
            cardManagerRef.GetRessurectionTargets(this.listsPlayer,copyList,true);
            trace("GFX - Applying Nurse Effect");
            if(copyList.length > 0)
            {
               if(cardManagerRef.cardEffectManager.randomResEnabled && !this.templateRef.isType(CardTemplate.CardType_Hero))
               {
                  this.handleNurseChoice(copyList[Math.min(Math.floor(Math.random() * copyList.length),copyList.length - 1)].instanceId);
               }
               else if(gameFlowRef.playerControllers[this.listsPlayer] is AIPlayerController)
               {
                  cardAndComboPoints = cardManagerRef.getHigherOrLowerValueCardFromTargetGraveyard(this.listsPlayer,true,true,false);
                  currentInstance = cardAndComboPoints.cardInstance;
                  this.handleNurseChoice(currentInstance.instanceId);
               }
               else
               {
                  gameFlowRef.mcChoiceDialog.showDialogCardInstances(copyList,this.handleNurseChoice,null,"[[gwint_choose_card_to_ressurect]]");
               }
            }
         }
         if(this.templateRef.hasEffect(CardTemplate.CardEffect_ImproveNeighbours))
         {
            cardList = cardManagerRef.getCardInstanceList(this.inList,this.listsPlayer);
            trace("GFX - Applying Improve Neightbours effect");
            for(it = 0; it < cardList.length; it++)
            {
               currentInstance = cardList[it];
               if(!currentInstance.templateRef.isType(CardTemplate.CardType_Hero) && !currentInstance.templateRef.hasEffect(CardTemplate.CardEffect_UnsummonDummy) && currentInstance != this)
               {
                  this.addToEffectingList(currentInstance);
               }
            }
            cardFXManager.playerCardEffectFX(this,null);
            cardManagerRef.cardEffectManager.registerActiveEffectCardInstance(this,this.inList,this.listsPlayer);
         }
         if(this.templateRef.hasEffect(CardTemplate.CardEffect_SameTypeMorale))
         {
            cardList = new Vector.<CardInstance>();
            cardManagerRef.getAllCreaturesNonHero(this.inList,this.listsPlayer,cardList);
            trace("GFX - Applying Right Bonds effect");
            foundOtherCard = false;
            for(it = 0; it < cardList.length; it++)
            {
               currentInstance = cardList[it];
               if(currentInstance != this && this.templateRef.summonFlags.indexOf(currentInstance.templateId) != -1)
               {
                  currentInstance.addToEffectingList(this);
                  this.addToEffectingList(currentInstance);
                  GwintGameMenu.mSingleton.playSound("gui_gwint_morale_boost");
                  cardFXManager.playTightBondsFX(currentInstance,null);
                  foundOtherCard = true;
               }
            }
            if(foundOtherCard)
            {
               cardFXManager.playTightBondsFX(this,null);
            }
         }
         if(this.templateRef.hasEffect(CardTemplate.CardEffect_SummonClones))
         {
            deck = cardManagerRef.playerDeckDefinitions[this.listsPlayer];
            cardList = cardManagerRef.getCardInstanceList(CardManager.CARD_LIST_LOC_HAND,this.listsPlayer);
            hasSummons = false;
            it = 0;
            while(it < this.templateRef.summonFlags.length && !hasSummons)
            {
               if(deck.numCopiesLeft(this.templateRef.summonFlags[it]) > 0)
               {
                  hasSummons = true;
               }
               for(hand_it = 0; hand_it < cardList.length; hand_it++)
               {
                  if(cardList[hand_it].templateId == this.templateRef.summonFlags[it])
                  {
                     hasSummons = true;
                     break;
                  }
               }
               it++;
            }
            trace("GFX - Applying Summon Clones Effect, found summons: " + hasSummons);
            if(hasSummons)
            {
               cardFXManager.playerCardEffectFX(this,this.summonFXEnded);
            }
         }
         if(this.templateRef.hasEffect(CardTemplate.CardEffect_Draw2))
         {
            trace("GFX - applying draw 2 effect");
            cardManagerRef.drawCards(this.listsPlayer == CardManager.PLAYER_1 ? CardManager.PLAYER_2 : CardManager.PLAYER_1,2);
         }
         cardManagerRef.recalculateScores();
      }
      
      protected function summonFXEnded(cardInstance:CardInstance) : void
      {
         var it:int = 0;
         var cardManagerRef:CardManager = CardManager.getInstance();
         for(it = 0; it < this.templateRef.summonFlags.length; it++)
         {
            cardManagerRef.summonFromDeck(this.listsPlayer,this.templateRef.summonFlags[it]);
            cardManagerRef.summonFromHand(this.listsPlayer,this.templateRef.summonFlags[it]);
         }
      }
      
      protected function mushroomFXTrigger(cardInstance:CardInstance) : void
      {
         var potentialTarget:CardInstance = null;
         var spawnedFX:CardFX = null;
         var effectedList:int = CardManager.CARD_LIST_LOC_INVALID;
         if(cardInstance.inList == CardManager.CARD_LIST_LOC_MELEEMODIFIERS || cardInstance.inList == CardManager.CARD_LIST_LOC_MELEE)
         {
            effectedList = CardManager.CARD_LIST_LOC_MELEE;
         }
         else if(cardInstance.inList == CardManager.CARD_LIST_LOC_RANGEDMODIFIERS || cardInstance.inList == CardManager.CARD_LIST_LOC_RANGED)
         {
            effectedList = CardManager.CARD_LIST_LOC_RANGED;
         }
         else if(cardInstance.inList == CardManager.CARD_LIST_LOC_SEIGEMODIFIERS || cardInstance.inList == CardManager.CARD_LIST_LOC_SEIGE)
         {
            effectedList = CardManager.CARD_LIST_LOC_SEIGE;
         }
         var targetList:Vector.<CardInstance> = CardManager.getInstance().getCardInstanceList(effectedList,cardInstance.listsPlayer);
         var cardFXManager:CardFXManager = CardFXManager.getInstance();
         for each(potentialTarget in targetList)
         {
            if(potentialTarget.templateRef.hasEffect(CardTemplate.CardEffect_Morph) && potentialTarget.templateRef.summonFlags.length == 1)
            {
               spawnedFX = cardFXManager.playerCardEffectFX(potentialTarget,this.morphFXEnded);
               if(spawnedFX != null)
               {
                  spawnedFX.associatedCardInstance = potentialTarget;
                  spawnedFX.midFXPointCallback = this.morphFXMidPointTrigger;
               }
            }
         }
      }
      
      protected function morphFXMidPointTrigger(cardInstance:CardInstance) : void
      {
         var targetSlot:CardSlot = CardManager.getInstance().boardRenderer.getCardSlotById(cardInstance.instanceId);
         if(targetSlot != null)
         {
            cardInstance.updateTemplateID(cardInstance.templateRef.summonFlags[0]);
            targetSlot.updateTemplate(cardInstance.templateRef);
         }
      }
      
      protected function morphFXEnded(cardInstance:CardInstance) : void
      {
         cardInstance.updateEffectsApplied(cardInstance);
      }
      
      protected function handleNurseChoice(instanceId:int) : void
      {
         var targetSlot:CardSlot = null;
         var cardManagerRef:CardManager = CardManager.getInstance();
         var cardInstance:CardInstance = cardManagerRef.getCardInstance(instanceId);
         var cardFXManager:CardFXManager = CardFXManager.getInstance();
         var boardRenderer:GwintBoardRenderer = cardManagerRef.boardRenderer;
         if(boardRenderer)
         {
            targetSlot = boardRenderer.getCardSlotById(instanceId);
            if(targetSlot)
            {
               targetSlot.parent.addChild(targetSlot);
            }
         }
         GwintGameMenu.mSingleton.playSound("gui_gwint_resurrect");
         cardFXManager.playRessurectEffectFX(cardInstance,this.onNurseEffectEnded);
         if(GwintGameFlowController.getInstance().mcChoiceDialog.visible)
         {
            GwintGameFlowController.getInstance().mcChoiceDialog.hideDialog();
         }
      }
      
      protected function noNurseChoice() : void
      {
         if(GwintGameFlowController.getInstance().mcChoiceDialog.visible)
         {
            GwintGameFlowController.getInstance().mcChoiceDialog.hideDialog();
         }
      }
      
      protected function onNurseEffectEnded(cardInstance:CardInstance = null) : void
      {
         var cardManagerRef:CardManager = CardManager.getInstance();
         if(cardInstance)
         {
            cardInstance.recalculatePowerPotential(cardManagerRef);
            cardManagerRef.addCardInstanceToList(cardInstance,cardInstance.getOptimalTransaction().targetSlotID,cardInstance.getOptimalTransaction().targetPlayerID);
         }
      }
      
      protected function onScorchFXEnd(cardInstance:CardInstance) : void
      {
         CardManager.getInstance().sendToGraveyard(cardInstance);
      }
      
      protected function powerChangeSorter(element1:CardInstance, element2:CardInstance) : Number
      {
         if(element1.getOptimalTransaction().powerChangeResult == element2.getOptimalTransaction().powerChangeResult)
         {
            return element1.getOptimalTransaction().strategicValue - element2.getOptimalTransaction().strategicValue;
         }
         return element1.getOptimalTransaction().powerChangeResult - element2.getOptimalTransaction().powerChangeResult;
      }
      
      public function potentialWeatherHarm() : int
      {
         var cardManager:CardManager = null;
         var cardsInHand:Vector.<CardInstance> = null;
         var lossPointsPotential:int = 0;
         var currentCardInHand:CardInstance = null;
         var preWeatherDeBuff:int = 0;
         var effectList:Vector.<CardInstance> = null;
         var typeToCheck:int = 0;
         var effectCard_it:int = 0;
         var list_it:int = 0;
         if(this.templateRef.isType(CardTemplate.CardType_Weather))
         {
            cardManager = CardManager.getInstance();
            cardsInHand = cardManager.getAllCreaturesInHand(this.listsPlayer);
            lossPointsPotential = 0;
            preWeatherDeBuff = 0;
            if(this.templateRef.hasEffect(CardTemplate.CardEffect_Melee))
            {
               typeToCheck = CardManager.CARD_LIST_LOC_MELEE;
            }
            else if(this.templateRef.hasEffect(CardTemplate.CardEffect_Ranged))
            {
               typeToCheck = CardManager.CARD_LIST_LOC_RANGED;
            }
            else if(this.templateRef.hasEffect(CardTemplate.CardEffect_Siege))
            {
               typeToCheck = CardManager.CARD_LIST_LOC_SEIGE;
            }
            effectList = cardManager.cardEffectManager.getEffectsForList(typeToCheck,this.listsPlayer);
            for(list_it = 0; list_it < cardsInHand.length; list_it++)
            {
               currentCardInHand = cardsInHand[list_it];
               if(currentCardInHand.templateRef.isType(CardTemplate.CardType_Creature) && !currentCardInHand.templateRef.isType(CardTemplate.CardType_RangedMelee) && currentCardInHand.templateRef.isType(typeToCheck))
               {
                  for(effectCard_it = 0; effectCard_it < effectList.length; effectCard_it++)
                  {
                     currentCardInHand.effectedByCardsRefList.push(effectList[effectCard_it]);
                  }
                  preWeatherDeBuff = currentCardInHand.getTotalPower();
                  currentCardInHand.effectedByCardsRefList.push(this);
                  lossPointsPotential += Math.max(0,preWeatherDeBuff - currentCardInHand.getTotalPower());
                  currentCardInHand.effectedByCardsRefList.length = 0;
               }
            }
            return lossPointsPotential;
         }
         return 0;
      }
   }
}
