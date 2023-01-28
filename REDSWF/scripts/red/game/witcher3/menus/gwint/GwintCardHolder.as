package red.game.witcher3.menus.gwint
{
   import com.gskinner.motion.GTween;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import red.core.constants.KeyCode;
   import red.game.witcher3.events.GwintCardEvent;
   import red.game.witcher3.events.GwintHolderEvent;
   import red.game.witcher3.slots.SlotBase;
   import scaleform.clik.constants.InputValue;
   import scaleform.clik.constants.NavigationCode;
   import scaleform.clik.events.InputEvent;
   import scaleform.clik.ui.InputDetails;
   
   public class GwintCardHolder extends SlotBase
   {
       
      
      protected var _cardHolderID:int = -1;
      
      protected var _playerID:int = -1;
      
      protected var _uniqueID:int = 0;
      
      protected var _paddingX:int = 3;
      
      protected var _paddingY:int = 5;
      
      public var boardRendererRef:GwintBoardRenderer;
      
      public var mcHighlight:MovieClip;
      
      public var mcSelected:MovieClip;
      
      public var mcStatus:MovieClip;
      
      public var cardSlotsList:Vector.<CardSlot>;
      
      protected var _selectedCardIdx:int = -1;
      
      public var newlySpawnedCards:Vector.<CardSlot>;
      
      protected var centerX:int;
      
      protected var _disableNavigation:Boolean;
      
      protected var _cardSelectionEnabled:Boolean = true;
      
      protected var _alwaysHighlight:Boolean = false;
      
      private var _lastSelectedCard:CardSlot;
      
      public function GwintCardHolder()
      {
         this.cardSlotsList = new Vector.<CardSlot>();
         this.newlySpawnedCards = new Vector.<CardSlot>();
         super();
      }
      
      public function get cardHolderID() : int
      {
         return this._cardHolderID;
      }
      
      public function set cardHolderID(value:int) : void
      {
         this._cardHolderID = value;
      }
      
      public function get playerID() : int
      {
         return this._playerID;
      }
      
      public function set playerID(value:int) : void
      {
         this._playerID = value;
      }
      
      public function get uniqueID() : int
      {
         return this._uniqueID;
      }
      
      public function set uniqueID(value:int) : void
      {
         this._uniqueID = value;
      }
      
      public function get paddingX() : int
      {
         return this._paddingX;
      }
      
      public function set paddingX(value:int) : void
      {
         this._paddingX = value;
      }
      
      public function get paddingY() : int
      {
         return this._paddingY;
      }
      
      public function set paddingY(value:int) : void
      {
         this._paddingY = value;
      }
      
      public function get disableNavigation() : Boolean
      {
         return this._disableNavigation;
      }
      
      public function set disableNavigation(value:Boolean) : void
      {
         this._disableNavigation = value;
      }
      
      public function get cardSelectionEnabled() : Boolean
      {
         return this._cardSelectionEnabled;
      }
      
      public function set cardSelectionEnabled(value:Boolean) : *
      {
         this._cardSelectionEnabled = value;
         this.updateCardSelectionAvailable();
      }
      
      public function set alwaysHighlight(value:Boolean) : void
      {
         if(this._alwaysHighlight == value)
         {
            return;
         }
         this._alwaysHighlight = value;
         if(this.mcHighlight)
         {
            if(this.mcSelected)
            {
               if(this.mcSelected.visible)
               {
                  this.mcHighlight.visible = false;
               }
               else
               {
                  this.mcHighlight.visible = this._alwaysHighlight;
               }
            }
            else
            {
               this.mcHighlight.visible = this._alwaysHighlight;
            }
         }
      }
      
      public function handleMouseMove(stageX:Number, stageY:Number) : Boolean
      {
         var i:int = 0;
         var currentCardSlot:CardSlot = null;
         if(this.cardHolderID == CardManager.CARD_LIST_LOC_HAND && this.playerID == CardManager.PLAYER_2)
         {
            return false;
         }
         for(i = 0; i < this.cardSlotsList.length; i++)
         {
            currentCardSlot = this.cardSlotsList[i] as CardSlot;
            if(Boolean(currentCardSlot) && currentCardSlot.mcHitBox.hitTestPoint(stageX,stageY))
            {
               this.selectedCardIdx = i;
               return true;
            }
         }
         this.selectedCardIdx = -1;
         return hitTestPoint(stageX,stageY);
      }
      
      protected function updateCardSelectionAvailable() : *
      {
         var i:int = 0;
         var currentCard:CardSlot = null;
         for(i = 0; i < this.cardSlotsList.length; i++)
         {
            currentCard = this.cardSlotsList[i];
            if(currentCard)
            {
               currentCard.activeSelectionEnabled = this._cardSelectionEnabled && selected;
            }
         }
         this.updateDrawOrder();
      }
      
      public function get selectedCardIdx() : int
      {
         return this._selectedCardIdx;
      }
      
      public function set selectedCardIdx(value:int) : void
      {
         if(value == -1 && this._lastSelectedCard == null)
         {
            return;
         }
         if(this._lastSelectedCard != null && this.cardSlotsList.indexOf(this._lastSelectedCard) != -1)
         {
            if(this.cardSlotsList[value] == this._lastSelectedCard)
            {
               if(!this._lastSelectedCard.selected)
               {
                  this._lastSelectedCard.selected = true;
               }
               this._selectedCardIdx = value;
               return;
            }
            this._lastSelectedCard.selected = false;
         }
         if(value < 0 || value >= this.cardSlotsList.length)
         {
            value = -1;
         }
         else
         {
            value = value;
         }
         if(value != -1)
         {
            this._selectedCardIdx = value;
            this._lastSelectedCard = this.cardSlotsList[this._selectedCardIdx];
            this._lastSelectedCard.selected = true;
            dispatchEvent(new GwintCardEvent(GwintCardEvent.CARD_SELECTED,true,false,this._lastSelectedCard,this));
         }
         else if(selected)
         {
         }
         this.updateDrawOrder();
      }
      
      public function selectCardInstance(cardInstance:CardInstance) : void
      {
         var i:int = 0;
         for(i = 0; i < this.cardSlotsList.length; i++)
         {
            if(this.cardSlotsList[i].cardInstance == cardInstance)
            {
               this.selectedCardIdx = i;
               return;
            }
         }
         throw new Error("GFX [ERROR] - tried to select card in slot: (" + this.cardHolderID + ", " + this.playerID + "), but could could not find reference to: " + cardInstance);
      }
      
      public function selectCard(cardSlot:CardSlot) : void
      {
         var indexOf:int = this.cardSlotsList.indexOf(cardSlot);
         if(indexOf != -1)
         {
            this.selectedCardIdx = indexOf;
            return;
         }
         throw new Error("GFX [ERROR] - tried to select card in slot: (" + this.cardHolderID + ", " + this.playerID + "), but could could not find reference to: " + cardSlot);
      }
      
      public function findSelection() : void
      {
         if(this.selectedCardIdx < 0)
         {
            this.selectedCardIdx = 0;
         }
      }
      
      public function getSelectedCardSlot() : CardSlot
      {
         if(this._selectedCardIdx >= 0 && this._selectedCardIdx < this.cardSlotsList.length)
         {
            return this.cardSlotsList[this._selectedCardIdx];
         }
         return null;
      }
      
      override public function set selected(value:Boolean) : void
      {
         if(!this.boardRendererRef || value == selected)
         {
            return;
         }
         super.selected = value;
         if(value)
         {
            if(this.mcSelected != null)
            {
               this.mcSelected.visible = true;
            }
            this.mcHighlight.visible = false;
            dispatchEvent(new GwintHolderEvent(GwintHolderEvent.HOLDER_SELECTED,true,false,this));
            if(this.selectedCardIdx == -1 && this.cardSlotsList.length > 0)
            {
               this.selectedCardIdx = 0;
            }
         }
         else
         {
            if(this.mcSelected != null)
            {
               this.mcSelected.visible = false;
            }
            this.mcHighlight.visible = this._alwaysHighlight;
         }
         this.updateCardSelectionAvailable();
         this.updateDrawOrder();
      }
      
      override public function set selectable(value:Boolean) : void
      {
         super.selectable = value;
         if(selectable && enabled && Boolean(this.mcSelected))
         {
            this.mcSelected.visible = selected;
         }
         else if(!selectable && Boolean(this.mcSelected))
         {
            this.mcSelected.visible = false;
         }
      }
      
      public function selectFirstValid(castingCard:CardInstance) : void
      {
         this._selectedCardIdx = -1;
         for(var i:int = 0; i < this.cardSlotsList.length; i++)
         {
            if(castingCard.canBeCastOn(this.cardSlotsList[i].cardInstance))
            {
               this.selectedCardIdx = i;
               break;
            }
         }
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         if(this.mcHighlight)
         {
            this.mcHighlight.visible = false;
            this.mcHighlight.stop();
         }
         if(this.mcSelected)
         {
            this.mcSelected.visible = false;
         }
         if(this.mcStatus)
         {
            this.mcStatus.visible = false;
         }
      }
      
      public function updateLeaderStatus(playerTurn:Boolean) : void
      {
         var currentCardSlot:CardSlot = null;
         if(this.cardSlotsList.length > 0)
         {
            currentCardSlot = this.cardSlotsList[0] as CardSlot;
         }
         if(!currentCardSlot)
         {
            return;
         }
         var currentLeaderCard:CardLeaderInstance = currentCardSlot.cardInstance as CardLeaderInstance;
         if(!currentLeaderCard)
         {
            return;
         }
         if(currentLeaderCard.hasBeenUsed)
         {
            this.mcStatus.visible = false;
            if(currentCardSlot)
            {
               currentCardSlot.darkenIcon(0.3);
            }
         }
         else
         {
            if(currentCardSlot)
            {
               currentCardSlot.filters = [];
            }
            if(this.mcStatus)
            {
               if(playerTurn)
               {
                  this.mcStatus.visible = true;
                  if(currentLeaderCard.canBeUsed)
                  {
                     this.mcStatus.gotoAndStop(1);
                  }
                  else
                  {
                     this.mcStatus.gotoAndStop(2);
                  }
               }
               else
               {
                  this.mcStatus.visible = false;
               }
            }
         }
      }
      
      override public function handleInput(event:InputEvent) : void
      {
         super.handleInput(event);
         var details:InputDetails = event.details;
         var keyPress:Boolean = details.value == InputValue.KEY_DOWN || details.value == InputValue.KEY_HOLD;
         var navCommand:String = details.navEquivalent;
         if(keyPress)
         {
            switch(navCommand)
            {
               case NavigationCode.LEFT:
                  if(this.cardHolderID != CardManager.CARD_LIST_LOC_GRAVEYARD)
                  {
                     if(this.selectedCardIdx > 0 && !this._disableNavigation && this.cardSlotsList.length > 0)
                     {
                        --this.selectedCardIdx;
                        event.handled = true;
                     }
                  }
                  break;
               case NavigationCode.RIGHT:
                  if(this.cardHolderID != CardManager.CARD_LIST_LOC_GRAVEYARD)
                  {
                     if(this.selectedCardIdx < this.cardSlotsList.length - 1 && !this._disableNavigation && this.cardSlotsList.length > 0)
                     {
                        ++this.selectedCardIdx;
                        event.handled = true;
                     }
                  }
            }
         }
         if(details.value == InputValue.KEY_UP && navCommand == NavigationCode.GAMEPAD_A && details.code != KeyCode.SPACE)
         {
            this.handleActivatePressed();
         }
      }
      
      public function handleLeftClick(event:MouseEvent) : void
      {
         this.handleActivatePressed();
      }
      
      protected function handleActivatePressed() : void
      {
         var selectedCard:CardSlot = null;
         if(this.selectedCardIdx > -1 && this.selectedCardIdx < this.cardSlotsList.length)
         {
            selectedCard = this.cardSlotsList[this.selectedCardIdx];
         }
         if(selectedCard)
         {
            dispatchEvent(new GwintCardEvent(GwintCardEvent.CARD_CHOSEN,true,false,selectedCard,this));
         }
         dispatchEvent(new GwintHolderEvent(GwintHolderEvent.HOLDER_CHOSEN,true,false,this));
      }
      
      public function spawnCard(newCard:CardSlot) : void
      {
         if(this.cardHolderID == CardManager.CARD_LIST_LOC_MELEE || this.cardHolderID == CardManager.CARD_LIST_LOC_SEIGE || this.cardHolderID == CardManager.CARD_LIST_LOC_RANGED || this.cardHolderID == CardManager.CARD_LIST_LOC_HAND)
         {
            this.newlySpawnedCards.push(newCard);
         }
         else
         {
            newCard.x = this.x;
            newCard.y = this.y;
         }
      }
      
      protected function cardSorter(e1:CardSlot, e2:CardSlot) : Number
      {
         var cardInstance1:CardInstance = e1.cardInstance;
         var cardInstance2:CardInstance = e2.cardInstance;
         if(cardInstance1.templateId == cardInstance2.templateId)
         {
            return 0;
         }
         var battlefield1:int = cardInstance1.templateRef.getCreatureType();
         var battlefield2:int = cardInstance2.templateRef.getCreatureType();
         if(battlefield1 == CardTemplate.CardType_None && battlefield2 == CardTemplate.CardType_None)
         {
            return cardInstance1.templateId - cardInstance2.templateId;
         }
         if(battlefield1 == CardTemplate.CardType_None)
         {
            return -1;
         }
         if(battlefield2 == CardTemplate.CardType_None)
         {
            return 1;
         }
         if(cardInstance1.templateRef.power != cardInstance2.templateRef.power)
         {
            return cardInstance1.templateRef.power - cardInstance2.templateRef.power;
         }
         return cardInstance1.templateId - cardInstance2.templateId;
      }
      
      public function cardAdded(newCard:CardSlot) : void
      {
         var currentCard:CardSlot = null;
         var targetIndex:int = 0;
         if(this.selectedCardIdx != -1 && this.selectedCardIdx < this.cardSlotsList.length)
         {
            currentCard = this.cardSlotsList[this.selectedCardIdx];
         }
         this.cardSlotsList.push(newCard);
         this.cardSlotsList.sort(this.cardSorter);
         if(currentCard != null)
         {
            targetIndex = this.cardSlotsList.indexOf(currentCard);
            if(targetIndex != this.selectedCardIdx)
            {
               this.selectedCardIdx = targetIndex;
            }
         }
         this.repositionAllCards();
         newCard.activeSelectionEnabled = selected && this._cardSelectionEnabled;
         if(newCard.selected)
         {
            newCard.selected = false;
         }
         this.updateWeatherEffects();
         this.registerCard(newCard);
      }
      
      public function cardRemoved(newCard:CardSlot) : void
      {
         this.unregisterCard(newCard);
         var indexOf:int = this.cardSlotsList.indexOf(newCard);
         if(indexOf != -1)
         {
            this.cardSlotsList.splice(indexOf,1);
            this.findCardSelection(indexOf >= this._selectedCardIdx);
         }
         this.repositionAllCards();
         this.updateWeatherEffects();
      }
      
      protected function registerCard(targetCard:CardSlot) : void
      {
         if(!targetCard)
         {
         }
      }
      
      protected function unregisterCard(targetCard:CardSlot) : void
      {
         if(!targetCard)
         {
         }
      }
      
      protected function onCardMouseOver(event:Event) : void
      {
         var targetIndex:int = 0;
         var currentTarget:CardSlot = event.target as CardSlot;
         if(currentTarget)
         {
            targetIndex = this.cardSlotsList.indexOf(currentTarget);
            if(targetIndex != -1)
            {
               this.selectedCardIdx = targetIndex;
            }
         }
      }
      
      protected function onCardMouseOut(event:Event) : void
      {
         var targetIndex:int = 0;
         var currentTarget:CardSlot = event.target as CardSlot;
         if(currentTarget)
         {
            targetIndex = this.cardSlotsList.indexOf(currentTarget);
            if(targetIndex != -1)
            {
               this.selectedCardIdx = -1;
            }
         }
      }
      
      protected function updateWeatherEffects() : void
      {
         var hasMeleeEffect:Boolean = false;
         var hasRangedEffect:Boolean = false;
         var hasSiegeEffect:Boolean = false;
         var i:int = 0;
         var currentSlot:CardSlot = null;
         var cardFXManagerRef:CardFXManager = null;
         var effectID:int = 0;
         if(Boolean(this.boardRendererRef) && this.cardHolderID == CardManager.CARD_LIST_LOC_WEATHERSLOT)
         {
            hasMeleeEffect = false;
            hasRangedEffect = false;
            hasSiegeEffect = false;
            for(i = 0; i < this.cardSlotsList.length; i++)
            {
               currentSlot = this.cardSlotsList[i];
               for each(effectID in currentSlot.cardInstance.templateRef.effectFlags)
               {
                  switch(effectID)
                  {
                     case CardTemplate.CardEffect_Melee:
                        hasMeleeEffect = true;
                        break;
                     case CardTemplate.CardEffect_Ranged:
                        hasRangedEffect = true;
                        break;
                     case CardTemplate.CardEffect_Siege:
                        hasSiegeEffect = true;
                        break;
                  }
               }
            }
            cardFXManagerRef = CardFXManager.getInstance();
            cardFXManagerRef.ShowWeatherOngoing(CardManager.CARD_LIST_LOC_MELEE,hasMeleeEffect);
            cardFXManagerRef.ShowWeatherOngoing(CardManager.CARD_LIST_LOC_RANGED,hasRangedEffect);
            cardFXManagerRef.ShowWeatherOngoing(CardManager.CARD_LIST_LOC_SEIGE,hasSiegeEffect);
         }
      }
      
      protected function findCardSelection(backward:Boolean) : void
      {
         this.selectedCardIdx = Math.max(0,Math.min(this.cardSlotsList.length - 1,this._selectedCardIdx));
      }
      
      public function repositionAllCards() : void
      {
         if(this.cardHolderID == CardManager.CARD_LIST_LOC_GRAVEYARD)
         {
            this.repositionAllCards_Graveyard();
         }
         else if(this.cardHolderID == CardManager.CARD_LIST_LOC_MELEE || this.cardHolderID == CardManager.CARD_LIST_LOC_SEIGE || this.cardHolderID == CardManager.CARD_LIST_LOC_RANGED || this.cardHolderID == CardManager.CARD_LIST_LOC_HAND)
         {
            this.repositionAllCards_Standard(true);
         }
         else
         {
            this.repositionAllCards_Standard(false);
         }
      }
      
      private function repositionAllCards_Graveyard() : void
      {
         var i:int = 0;
         var curCardSlot:CardSlot = null;
         var cardTweener:CardTweenManager = CardTweenManager.getInstance();
         if(this.cardSlotsList.length == 0 || !cardTweener)
         {
            return;
         }
         var godCardHolder:MovieClip = this.cardSlotsList[0].parent as MovieClip;
         var curX:Number = this.x + this.width / 2;
         curX -= (this.cardSlotsList.length - 1) * 1;
         var curY:Number = this.y + this.height / 2;
         curY -= (this.cardSlotsList.length - 1) * 2;
         for(i = 0; i < this.cardSlotsList.length; i++)
         {
            curCardSlot = this.cardSlotsList[i];
            godCardHolder.addChildAt(curCardSlot,0);
            cardTweener.tweenTo(curCardSlot,curX,curY,this.onPositionCardEnded);
            curX += 1;
            curY += 2;
         }
      }
      
      private function repositionAllCards_Standard(allowOverlap:Boolean) : void
      {
         var totalWidth:int = 0;
         var curX:int = 0;
         var stepX:int = 0;
         var i:int = 0;
         var currentCard:CardSlot = null;
         var targetY:Number = NaN;
         var foundInNewlySpawned:Boolean = false;
         var p:int = 0;
         var cardTweener:CardTweenManager = CardTweenManager.getInstance();
         if(!cardTweener)
         {
            throw new Error("GFX -- Trying to reposition all cards but the CardTweenManager instance does not exist !!!");
         }
         if(this.cardSlotsList.length > 0)
         {
            totalWidth = (this.cardSlotsList.length - 1) * this._paddingX + this.cardSlotsList.length * CardSlot.CARD_BOARD_WIDTH;
            curX = this.x + this.width / 2 - totalWidth / 2;
            stepX = CardSlot.CARD_BOARD_WIDTH + this._paddingX;
            if(this.cardHolderID == CardManager.CARD_LIST_LOC_LEADER)
            {
               curX = this.x + this.mcSelected.width / 2 - totalWidth / 2;
            }
            if(allowOverlap && totalWidth > this.width)
            {
               stepX -= (totalWidth - this.width) / (this.cardSlotsList.length - 1);
               curX = this.x;
            }
            curX += CardSlot.CARD_BOARD_WIDTH / 2;
            targetY = this.y + this.height / 2;
            for(i = 0; i < this.cardSlotsList.length; i++)
            {
               currentCard = this.cardSlotsList[i];
               foundInNewlySpawned = false;
               if(currentCard.cardInstance.InstancePositioning)
               {
                  foundInNewlySpawned = true;
                  currentCard.x = curX;
                  currentCard.y = targetY;
               }
               else
               {
                  for(p = 0; p < this.newlySpawnedCards.length; p++)
                  {
                     if(this.newlySpawnedCards[p] == currentCard)
                     {
                        foundInNewlySpawned = true;
                        currentCard.x = curX;
                        currentCard.y = targetY;
                        this.newlySpawnedCards.splice(p,1);
                        break;
                     }
                  }
               }
               if(!foundInNewlySpawned)
               {
                  cardTweener.tweenTo(currentCard,curX,targetY,this.onPositionCardEnded);
               }
               curX += stepX;
            }
            this.updateDrawOrder();
         }
      }
      
      private function updateDrawOrder() : void
      {
         var i:int = 0;
         var curCardSlot:CardSlot = null;
         if(this.cardHolderID == CardManager.CARD_LIST_LOC_GRAVEYARD)
         {
            for(i = int(this.cardSlotsList.length - 1); i >= 0; i--)
            {
               curCardSlot = this.cardSlotsList[i];
               curCardSlot.parent.addChild(curCardSlot);
            }
         }
         else
         {
            for(i = 0; i < this.cardSlotsList.length; i++)
            {
               curCardSlot = this.cardSlotsList[i];
               curCardSlot.parent.addChild(curCardSlot);
            }
         }
         curCardSlot = this.getSelectedCardSlot();
         if(selected && curCardSlot != null && this.cardSelectionEnabled)
         {
            curCardSlot.parent.addChild(curCardSlot);
         }
      }
      
      public function onPositionCardEnded(finishedTween:GTween) : void
      {
         var cardManagerRef:CardManager = CardManager.getInstance();
         var cardInstanceRef:CardInstance = cardManagerRef.getCardInstance((finishedTween.target as CardSlot).instanceId);
         if(cardInstanceRef)
         {
            cardInstanceRef.onFinishedMovingIntoHolder(this._cardHolderID,this._playerID);
         }
      }
      
      public function clearAllCards() : void
      {
         this.cardSlotsList.length = 0;
      }
   }
}
