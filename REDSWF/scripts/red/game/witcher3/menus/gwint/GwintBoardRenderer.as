package red.game.witcher3.menus.gwint
{
   import com.gskinner.motion.GTween;
   import com.gskinner.motion.GTweener;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.utils.Dictionary;
   import red.game.witcher3.controls.W3TextArea;
   import red.game.witcher3.slots.SlotsListBase;
   import scaleform.clik.events.InputEvent;
   
   public class GwintBoardRenderer extends SlotsListBase
   {
       
      
      public var mcGodCardHolder:MovieClip;
      
      public var mcTransitionAnchor:MovieClip;
      
      public var rowScoreP2Seige:MovieClip;
      
      public var rowScoreP2Ranged:MovieClip;
      
      public var rowScoreP2Melee:MovieClip;
      
      public var rowScoreP1Melee:MovieClip;
      
      public var rowScoreP1Ranged:MovieClip;
      
      public var rowScoreP1Seige:MovieClip;
      
      public var mcP1LeaderHolder:GwintCardHolder;
      
      public var mcP2LeaderHolder:GwintCardHolder;
      
      public var mcP1Deck:GwintCardHolder;
      
      public var mcP2Deck:GwintCardHolder;
      
      public var mcP1Hand:GwintCardHolder;
      
      public var mcP2Hand:GwintCardHolder;
      
      public var mcP1Graveyard:GwintCardHolder;
      
      public var mcP2Graveyard:GwintCardHolder;
      
      public var mcP1Siege:GwintCardHolder;
      
      public var mcP2Siege:GwintCardHolder;
      
      public var mcP1Range:GwintCardHolder;
      
      public var mcP2Range:GwintCardHolder;
      
      public var mcP1Melee:GwintCardHolder;
      
      public var mcP2Melee:GwintCardHolder;
      
      public var mcP1SiegeModif:GwintCardHolder;
      
      public var mcP2SiegeModif:GwintCardHolder;
      
      public var mcP1RangeModif:GwintCardHolder;
      
      public var mcP2RangeModif:GwintCardHolder;
      
      public var mcP1MeleeModif:GwintCardHolder;
      
      public var mcP2MeleeModif:GwintCardHolder;
      
      public var mcWeather:GwintCardHolder;
      
      public var mcTransactionTooltip:MovieClip;
      
      private var cardManager:CardManager;
      
      private var allRenderers:Vector.<GwintCardHolder>;
      
      private var allCardSlotInstances:Dictionary;
      
      public function GwintBoardRenderer()
      {
         this.allCardSlotInstances = new Dictionary();
         super();
      }
      
      public function getSelectedCardHolder() : GwintCardHolder
      {
         if(selectedIndex == -1)
         {
            return null;
         }
         return getSelectedRenderer() as GwintCardHolder;
      }
      
      public function getSelectedCard() : CardSlot
      {
         var curHolder:GwintCardHolder = this.getSelectedCardHolder();
         if(curHolder == null)
         {
            return null;
         }
         return curHolder.getSelectedCardSlot();
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         this.cardManager = CardManager.getInstance();
         CardManager.getInstance().boardRenderer = this;
         this.updateRowScores(0,0,0,0,0,0);
         this.fillRenderersList();
         if(this.mcTransactionTooltip)
         {
            this.mcTransactionTooltip.visible = false;
            this.mcTransactionTooltip.alpha = 0;
         }
         this.setupCardHolders();
      }
      
      protected function setupCardHolders() : void
      {
         this.setupCardHolder(this.mcP1Deck);
         this.setupCardHolder(this.mcP2Deck);
         this.setupCardHolder(this.mcP1Hand);
         this.setupCardHolder(this.mcP2Hand);
         this.setupCardHolder(this.mcP1Graveyard);
         this.setupCardHolder(this.mcP2Graveyard);
         this.setupCardHolder(this.mcP1Siege);
         this.setupCardHolder(this.mcP2Siege);
         this.setupCardHolder(this.mcP1Range);
         this.setupCardHolder(this.mcP2Range);
         this.setupCardHolder(this.mcP1Melee);
         this.setupCardHolder(this.mcP2Melee);
         this.setupCardHolder(this.mcP1SiegeModif);
         this.setupCardHolder(this.mcP2SiegeModif);
         this.setupCardHolder(this.mcP1RangeModif);
         this.setupCardHolder(this.mcP2RangeModif);
         this.setupCardHolder(this.mcP1MeleeModif);
         this.setupCardHolder(this.mcP2MeleeModif);
         this.setupCardHolder(this.mcP1LeaderHolder);
         this.setupCardHolder(this.mcP2LeaderHolder);
         this.setupCardHolder(this.mcWeather);
      }
      
      override public function handleInputPreset(event:InputEvent) : void
      {
         var i:int = 0;
         if(selectedIndex < 0)
         {
            this.selectCardHolder(CardManager.CARD_LIST_LOC_HAND,CardManager.PLAYER_1);
         }
         var curHolder:GwintCardHolder = getSelectedRenderer() as GwintCardHolder;
         if(!curHolder)
         {
            for(i = 0; i < _renderers.length; i++)
            {
               curHolder = _renderers[i] as GwintCardHolder;
               if(Boolean(curHolder) && curHolder.selectable)
               {
                  selectedIndex = i;
               }
               else
               {
                  curHolder = null;
               }
            }
         }
         if(curHolder)
         {
            curHolder.handleInput(event);
         }
         if(!event.handled)
         {
            super.handleInputPreset(event);
         }
      }
      
      protected function fillRenderersList() : void
      {
         var i:int = 0;
         this.allRenderers = new Vector.<GwintCardHolder>();
         for(i = 0; i < numChildren; i++)
         {
            if(getChildAt(i) is GwintCardHolder)
            {
               this.allRenderers.push(getChildAt(i));
            }
         }
         this.allRenderers.sort(this.cardHolderSorter);
         for(i = 0; i < this.allRenderers.length; i++)
         {
            this.allRenderers[i].boardRendererRef = this;
            _renderers.push(this.allRenderers[i]);
         }
         _renderersCount = this.allRenderers.length;
      }
      
      protected function cardHolderSorter(element1:GwintCardHolder, element2:GwintCardHolder) : Number
      {
         return element1.uniqueID - element2.uniqueID;
      }
      
      public function selectCardHolder(typeID:int, playerID:int) : void
      {
         this.selectCardHolderAdv(this.getCardHolder(typeID,playerID));
      }
      
      public function selectCardHolderAdv(targetHolder:GwintCardHolder) : void
      {
         if(targetHolder == null)
         {
            return;
         }
         var targetIdx:int = this.allRenderers.indexOf(targetHolder);
         if(targetIdx > -1)
         {
            selectedIndex = targetIdx;
            if(targetHolder.selectedCardIdx == -1)
            {
               targetHolder.selectedCardIdx = 0;
            }
         }
      }
      
      public function selectCardInstance(targetCard:CardInstance) : void
      {
         var selectedCardsHolder:GwintCardHolder = null;
         if(targetCard)
         {
            selectedCardsHolder = this.getCardHolder(targetCard.inList,targetCard.listsPlayer);
            if(selectedCardsHolder)
            {
               this.selectCardHolderAdv(selectedCardsHolder);
               selectedCardsHolder.selectCardInstance(targetCard);
               return;
            }
            throw new Error("GFX [ERROR] - tried to select card with no matching card holder on board! list: " + targetCard.inList + ", listsPlayer: " + targetCard.listsPlayer);
         }
         throw new Error("GFX [ERROR] - tried to select card slot with unknown card instance. Should not happen in this context: " + targetCard);
      }
      
      public function flushNewlyAddedCards() : void
      {
         for(var i:int = 0; i < this.allRenderers.length; i++)
         {
            this.allRenderers[i].newlySpawnedCards.length = 0;
         }
      }
      
      public function selectCard(targetCard:CardSlot) : void
      {
         var cardInstance:CardInstance = targetCard.cardInstance;
         this.selectCardInstance(cardInstance);
      }
      
      public function getCardHolder(typeID:int, playerID:int) : GwintCardHolder
      {
         var i:int = 0;
         var currentRenderer:GwintCardHolder = null;
         for(i = 0; i < this.allRenderers.length; i++)
         {
            currentRenderer = this.allRenderers[i];
            if(currentRenderer.cardHolderID == typeID && currentRenderer.playerID == playerID)
            {
               return currentRenderer;
            }
         }
         return null;
      }
      
      public function activateAllHolders(value:Boolean) : void
      {
         this.allRenderers.forEach(function(curHandler:GwintCardHolder):*
         {
            curHandler.selectable = value;
            curHandler.disableNavigation = false;
            curHandler.cardSelectionEnabled = true;
            curHandler.alwaysHighlight = false;
         });
      }
      
      public function activateHoldersForCard(cardInstance:CardInstance, selectFirstActive:Boolean = false) : void
      {
         var currentRenderer:GwintCardHolder = null;
         var validSlot:* = false;
         var len:int = int(this.allRenderers.length);
         var slotTargets:Vector.<CardInstance> = new Vector.<CardInstance>();
         for(var i:int = 0; i < len; i++)
         {
            currentRenderer = this.allRenderers[i];
            validSlot = false;
            if(cardInstance.templateRef.hasEffect(CardTemplate.CardEffect_UnsummonDummy) && currentRenderer.playerID == cardInstance.owningPlayer && (currentRenderer.cardHolderID == CardManager.CARD_LIST_LOC_MELEE || currentRenderer.cardHolderID == CardManager.CARD_LIST_LOC_RANGED || currentRenderer.cardHolderID == CardManager.CARD_LIST_LOC_SEIGE) && currentRenderer.playerID == cardInstance.owningPlayer)
            {
               slotTargets.length = 0;
               CardManager.getInstance().getAllCreaturesNonHero(currentRenderer.cardHolderID,currentRenderer.playerID,slotTargets);
               validSlot = slotTargets.length > 0;
               currentRenderer.selectFirstValid(cardInstance);
            }
            else
            {
               currentRenderer.cardSelectionEnabled = false;
               if(cardInstance.canBePlacedInSlot(currentRenderer.cardHolderID,currentRenderer.playerID))
               {
                  validSlot = true;
               }
            }
            trace("GFX ----- Analyzing slot for placement, valid: " + validSlot + ", for slot: " + currentRenderer);
            currentRenderer.selectable = validSlot;
            currentRenderer.alwaysHighlight = validSlot;
            if(validSlot && selectFirstActive)
            {
               selectedIndex = i;
               selectFirstActive = false;
            }
         }
      }
      
      public function getCardSlotById(cardInstanceId:int) : CardSlot
      {
         return this.allCardSlotInstances[cardInstanceId];
      }
      
      public function wasRemovedFromList(cardInstance:CardInstance, sourceTypeID:int, sourcePlayerID:int) : void
      {
         var correspondingHolder:GwintCardHolder = this.getCardHolder(sourceTypeID,sourcePlayerID);
         var targetCardSlot:CardSlot = this.allCardSlotInstances[cardInstance.instanceId];
         if(!correspondingHolder || !targetCardSlot)
         {
            throw new Error("GFX ---- spawnCardInstance failed because it was called with unknown params, sourceTypeID: " + sourceTypeID.toString() + ", sourcePlayerID: " + sourcePlayerID.toString());
         }
         correspondingHolder.cardRemoved(targetCardSlot);
      }
      
      public function wasAddedToList(cardInstance:CardInstance, sourceTypeID:int, sourcePlayerID:int) : void
      {
         var correspondingHolder:GwintCardHolder = this.getCardHolder(sourceTypeID,sourcePlayerID);
         var targetCardSlot:CardSlot = this.allCardSlotInstances[cardInstance.instanceId];
         if(!correspondingHolder || !targetCardSlot)
         {
            throw new Error("GFX ---- spawnCardInstance failed because it was called with unknown params, sourceTypeID: " + sourceTypeID.toString() + ", sourcePlayerID: " + sourcePlayerID.toString());
         }
         correspondingHolder.cardAdded(targetCardSlot);
      }
      
      public function spawnCardInstance(cardInstance:CardInstance, sourceTypeID:int, sourcePlayerID:int) : *
      {
         var correspondingHolder:GwintCardHolder = this.getCardHolder(sourceTypeID,sourcePlayerID);
         if(!correspondingHolder)
         {
            throw new Error("GFX ---- spawnCardInstance failed because it was called with unknown params, sourceTypeID: " + sourceTypeID.toString() + ", sourcePlayerID: " + sourcePlayerID.toString());
         }
         var newCardSlot:CardSlot = new _slotRendererRef() as CardSlot;
         newCardSlot.useContextMgr = false;
         newCardSlot.instanceId = cardInstance.instanceId;
         newCardSlot.cardState = "Board";
         this.mcGodCardHolder.addChild(newCardSlot);
         this.allCardSlotInstances[cardInstance.instanceId] = newCardSlot;
         newCardSlot.setCallbacksToCardInstance(cardInstance);
         correspondingHolder.spawnCard(newCardSlot);
      }
      
      public function returnToDeck(cardInstance:CardInstance) : void
      {
         var targetDeckHolder:GwintCardHolder = null;
         var targetCardSlot:CardSlot = this.allCardSlotInstances[cardInstance.instanceId];
         if(targetCardSlot)
         {
            targetDeckHolder = this.getCardHolder(CardManager.CARD_LIST_LOC_DECK,cardInstance.owningPlayer);
            CardTweenManager.getInstance().tweenTo(targetCardSlot,targetDeckHolder.x + CardSlot.CARD_BOARD_WIDTH / 2,targetDeckHolder.y + CardSlot.CARD_BOARD_HEIGHT / 2,this.onReturnToDeckEnded);
         }
      }
      
      public function onReturnToDeckEnded(finishedTween:GTween) : void
      {
         var resultedCard:CardSlot = finishedTween.target as CardSlot;
         if(resultedCard)
         {
            this.mcGodCardHolder.removeChild(resultedCard);
         }
      }
      
      public function removeCardInstance(cardInstance:CardInstance) : void
      {
         var targetCardSlot:CardSlot = this.allCardSlotInstances[cardInstance.instanceId];
         if(targetCardSlot)
         {
            this.mcGodCardHolder.removeChild(targetCardSlot);
         }
      }
      
      public function updateRowScores(p1Seige:int, p1Ranged:int, p1Melee:int, p2Melee:int, p2Ranged:int, p2Seige:int) : void
      {
         var currentTextArea:W3TextArea = null;
         currentTextArea = this.rowScoreP1Seige.getChildByName("txtScore") as W3TextArea;
         if(currentTextArea)
         {
            currentTextArea.text = p1Seige.toString();
         }
         currentTextArea = this.rowScoreP1Ranged.getChildByName("txtScore") as W3TextArea;
         if(currentTextArea)
         {
            currentTextArea.text = p1Ranged.toString();
         }
         currentTextArea = this.rowScoreP1Melee.getChildByName("txtScore") as W3TextArea;
         if(currentTextArea)
         {
            currentTextArea.text = p1Melee.toString();
         }
         currentTextArea = this.rowScoreP2Melee.getChildByName("txtScore") as W3TextArea;
         if(currentTextArea)
         {
            currentTextArea.text = p2Melee.toString();
         }
         currentTextArea = this.rowScoreP2Ranged.getChildByName("txtScore") as W3TextArea;
         if(currentTextArea)
         {
            currentTextArea.text = p2Ranged.toString();
         }
         currentTextArea = this.rowScoreP2Seige.getChildByName("txtScore") as W3TextArea;
         if(currentTextArea)
         {
            currentTextArea.text = p2Seige.toString();
         }
      }
      
      public function clearAllCards() : void
      {
         var currentItem:CardSlot = null;
         this.mcP1Deck.clearAllCards();
         this.mcP2Deck.clearAllCards();
         this.mcP1Hand.clearAllCards();
         this.mcP2Hand.clearAllCards();
         this.mcP1Graveyard.clearAllCards();
         this.mcP2Graveyard.clearAllCards();
         this.mcP1Siege.clearAllCards();
         this.mcP2Siege.clearAllCards();
         this.mcP1Range.clearAllCards();
         this.mcP2Range.clearAllCards();
         this.mcP1Melee.clearAllCards();
         this.mcP2Melee.clearAllCards();
         this.mcP1SiegeModif.clearAllCards();
         this.mcP2SiegeModif.clearAllCards();
         this.mcP1RangeModif.clearAllCards();
         this.mcP2RangeModif.clearAllCards();
         this.mcP1MeleeModif.clearAllCards();
         this.mcP2MeleeModif.clearAllCards();
         this.mcP1LeaderHolder.clearAllCards();
         this.mcP2LeaderHolder.clearAllCards();
         while(this.mcGodCardHolder.numChildren > 0)
         {
            this.mcGodCardHolder.removeChildAt(0);
         }
      }
      
      public function updateTransactionCardTooltip(targetCard:CardSlot) : void
      {
         var cardTemplate:CardTemplate = null;
         var tooltipString:String = null;
         var titleText:TextField = null;
         var descText:TextField = null;
         var tooltipIcon:MovieClip = null;
         if(this.mcTransactionTooltip)
         {
            if(targetCard != null)
            {
               visible = true;
               GTweener.removeTweens(this.mcTransactionTooltip);
               GTweener.to(this.mcTransactionTooltip,0.2,{"alpha":1},{});
               if(this.cardManager)
               {
                  cardTemplate = this.cardManager.getCardTemplate(targetCard.cardIndex);
                  tooltipString = cardTemplate.tooltipString;
                  titleText = this.mcTransactionTooltip.getChildByName("txtTooltipTitle") as TextField;
                  descText = this.mcTransactionTooltip.getChildByName("txtTooltip") as TextField;
                  if(tooltipString == "" || !titleText || !descText)
                  {
                     this.mcTransactionTooltip.visible = false;
                  }
                  else
                  {
                     this.mcTransactionTooltip.visible = true;
                     if(cardTemplate.index >= 1000)
                     {
                        titleText.text = "[[gwint_leader_ability]]";
                     }
                     else
                     {
                        titleText.text = "[[" + tooltipString + "_title]]";
                     }
                     if(cardTemplate.index == 524)
                     {
                        descText.text = "[[gwint_card_tooltip_scorch_creature]]";
                     }
                     else
                     {
                        descText.text = "[[" + tooltipString + "]]";
                     }
                     tooltipIcon = this.mcTransactionTooltip.getChildByName("mcTooltipIcon") as MovieClip;
                     if(tooltipIcon)
                     {
                        tooltipIcon.gotoAndStop(cardTemplate.tooltipIcon);
                     }
                  }
               }
            }
            else if(this.mcTransactionTooltip.visible)
            {
               GTweener.removeTweens(this.mcTransactionTooltip);
               GTweener.to(this.mcTransactionTooltip,0.2,{"alpha":0},{"onComplete":this.onTooltipHideEnded});
            }
         }
      }
      
      protected function setupCardHolder(curHolder:GwintCardHolder) : void
      {
      }
      
      public function handleMouseMove(event:MouseEvent) : void
      {
         var i:int = 0;
         var currentRenderer:GwintCardHolder = null;
         if(GwintGameMenu.mSingleton.mcChoiceDialog.visible)
         {
            return;
         }
         var collisionIndex:int = -1;
         for(i = 0; i < _renderers.length; i++)
         {
            currentRenderer = _renderers[i] as GwintCardHolder;
            if(currentRenderer && (currentRenderer.selectable || currentRenderer.cardSelectionEnabled) && currentRenderer.handleMouseMove(event.stageX,event.stageY))
            {
               collisionIndex = i;
               break;
            }
         }
         selectedIndex = collisionIndex;
      }
      
      public function handleLeftClick(event:MouseEvent) : void
      {
         if(GwintGameMenu.mSingleton.mcChoiceDialog.visible)
         {
            return;
         }
         this.handleMouseMove(event);
         var curSelectedHolder:GwintCardHolder = this.getSelectedCardHolder();
         if(curSelectedHolder)
         {
            curSelectedHolder.handleLeftClick(event);
         }
      }
      
      protected function onTooltipHideEnded(curTween:GTween) : void
      {
         if(this.mcTransactionTooltip)
         {
            this.mcTransactionTooltip.visible = false;
         }
      }
   }
}
