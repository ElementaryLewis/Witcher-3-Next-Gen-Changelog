package red.game.witcher3.menus.gwint
{
   public class GwintDeck
   {
       
      
      public var deckName:String;
      
      public var cardIndices:Array;
      
      public var selectedKingIndex:int;
      
      public var specialCard:int;
      
      public var isUnlocked:Boolean = false;
      
      public var dynamicCardRequirements:Array;
      
      public var dynamicCards:Array;
      
      public var refreshCallback:Function;
      
      public var onCardChangedCallback:Function;
      
      private var _deckRenderer:GwintDeckRenderer;
      
      public var cardIndicesInDeck:Vector.<int>;
      
      public function GwintDeck()
      {
         this.cardIndicesInDeck = new Vector.<int>();
         super();
      }
      
      public function set DeckRenderer(value:GwintDeckRenderer) : void
      {
         this._deckRenderer = value;
         this._deckRenderer.factionString = this.getDeckKingTemplate().getFactionString();
         this._deckRenderer.cardCount = this.cardIndices.length;
      }
      
      public function getDeckFaction() : int
      {
         var kingTemplate:CardTemplate = this.getDeckKingTemplate();
         if(kingTemplate)
         {
            return kingTemplate.factionIdx;
         }
         return CardTemplate.FactionId_Error;
      }
      
      public function getFactionNameString() : String
      {
         switch(this.getDeckFaction())
         {
            case CardTemplate.FactionId_Nilfgaard:
               return "[[gwint_faction_name_nilfgaard]]";
            case CardTemplate.FactionId_No_Mans_Land:
               return "[[gwint_faction_name_no_mans_land]]";
            case CardTemplate.FactionId_Northern_Kingdom:
               return "[[gwint_faction_name_northern_kingdom]]";
            case CardTemplate.FactionId_Scoiatael:
               return "[[gwint_faction_name_scoiatael]]";
            case CardTemplate.FactionId_Skellige:
               return "[[gwint_faction_name_skellige]]";
            default:
               return "Invalid Faction for Deck";
         }
      }
      
      public function getFactionPerkString() : String
      {
         switch(this.getDeckFaction())
         {
            case CardTemplate.FactionId_Nilfgaard:
               return "[[gwint_faction_ability_nilf]]";
            case CardTemplate.FactionId_No_Mans_Land:
               return "[[gwint_faction_ability_nml]]";
            case CardTemplate.FactionId_Northern_Kingdom:
               return "[[gwint_faction_ability_nr]]";
            case CardTemplate.FactionId_Scoiatael:
               return "[[gwint_faction_ability_scoia]]";
            case CardTemplate.FactionId_Skellige:
               return "[[gwint_faction_ability_ske]]";
            default:
               return "Invalid Faction, no perk";
         }
      }
      
      public function getDeckKingTemplate() : CardTemplate
      {
         return CardManager.getInstance().getCardTemplate(this.selectedKingIndex);
      }
      
      public function toString() : String
      {
         var i:int = 0;
         var indicesString:String = "";
         for(i = 0; i < this.cardIndices.length; i++)
         {
            indicesString += this.cardIndices[i].toString() + " - ";
         }
         return "[GwintDeck] Name:" + this.deckName + ", selectedKing:" + this.selectedKingIndex.toString() + ", indices:" + indicesString;
      }
      
      public function originalStength() : int
      {
         var i:int = 0;
         var cardTemplate:CardTemplate = null;
         var strength:int = 0;
         var cardManagerRef:CardManager = CardManager.getInstance();
         for(i = 0; i < this.cardIndices.length; i++)
         {
            cardTemplate = cardManagerRef.getCardTemplate(this.cardIndices[i]);
            if(cardTemplate.isType(CardTemplate.CardType_Creature))
            {
               strength += cardTemplate.power;
            }
            switch(cardTemplate.getFirstEffect())
            {
               case CardTemplate.CardEffect_Melee:
               case CardTemplate.CardEffect_Ranged:
               case CardTemplate.CardEffect_Siege:
               case CardTemplate.CardEffect_ClearSky:
                  strength += 2;
                  break;
               case CardTemplate.CardEffect_UnsummonDummy:
                  strength += 4;
                  break;
               case CardTemplate.CardEffect_Horn:
                  strength += 5;
                  break;
               case CardTemplate.CardEffect_Scorch:
               case CardTemplate.CardEffect_MeleeScorch:
                  strength += 6;
                  break;
               case CardTemplate.CardEffect_SummonClones:
                  strength += 3;
                  break;
               case CardTemplate.CardEffect_ImproveNeighbours:
                  strength += 4;
                  break;
               case CardTemplate.CardEffect_Nurse:
                  strength += 4;
                  break;
               case CardTemplate.CardEffect_Draw2:
                  strength += 6;
                  break;
               case CardTemplate.CardEffect_SameTypeMorale:
                  strength += 4;
                  break;
            }
         }
         trace("GFX -#AI#----- > ",strength);
         return strength;
      }
      
      public function shuffleDeck(otherDeckStrength:int) : void
      {
         var i:int = 0;
         var randomIndex:int = 0;
         var originalIndices:Vector.<int> = new Vector.<int>();
         var numItems:int = int(this.cardIndices.length);
         for(i = 0; i < numItems; i++)
         {
            originalIndices.push(this.cardIndices[i]);
         }
         this.adjustDeckToDifficulty(otherDeckStrength,originalIndices);
         this.cardIndicesInDeck.length = 0;
         while(originalIndices.length > 0)
         {
            randomIndex = Math.min(Math.floor(Math.random() * originalIndices.length),originalIndices.length - 1);
            this.cardIndicesInDeck.push(originalIndices[randomIndex]);
            originalIndices.splice(randomIndex,1);
         }
         if(this.specialCard != -1)
         {
            this.cardIndicesInDeck.push(this.specialCard);
         }
         if(this._deckRenderer)
         {
            this._deckRenderer.cardCount = this.cardIndicesInDeck.length;
         }
      }
      
      private function adjustDeckToDifficulty(otherDeckStr:int, listToAddTo:Vector.<int>) : void
      {
         var i:int = 0;
         if(this.dynamicCardRequirements.length > 0 && this.dynamicCardRequirements.length == this.dynamicCards.length)
         {
            trace("GFX -#AI#------------------- Deck balance --------------------");
            for(i = 0; i < this.dynamicCardRequirements.length; i++)
            {
               if(otherDeckStr >= this.dynamicCardRequirements[i])
               {
                  trace("GFX -#AI# Requirement [ " + this.dynamicCardRequirements[i] + " ] - Adding card with id [ " + this.dynamicCards[i] + "]");
                  listToAddTo.push(this.dynamicCards[i]);
               }
            }
            trace("GFX -#AI#-----------------------------------------------------");
         }
      }
      
      public function readdCard(templateID:int, random:Boolean = false) : void
      {
         var newIndex:int = 0;
         if(random)
         {
            newIndex = Math.min(Math.floor(Math.random() * this.cardIndicesInDeck.length),this.cardIndicesInDeck.length - 1);
            this.cardIndicesInDeck.splice(newIndex,0,templateID);
         }
         else
         {
            this.cardIndicesInDeck.unshift(templateID);
         }
         this._deckRenderer.cardCount = this.cardIndicesInDeck.length;
      }
      
      public function drawCard() : int
      {
         if(this.cardIndicesInDeck.length > 0)
         {
            if(this._deckRenderer)
            {
               this._deckRenderer.cardCount = this.cardIndicesInDeck.length - 1;
            }
            return this.cardIndicesInDeck.pop();
         }
         return CardInstance.INVALID_INSTANCE_ID;
      }
      
      public function getCardsInDeck(type:int, effect:int, list:Vector.<int>) : void
      {
         var templateRef:CardTemplate = null;
         var cardManagerRef:CardManager = CardManager.getInstance();
         for(var i:int = 0; i < this.cardIndicesInDeck.length; i++)
         {
            templateRef = cardManagerRef.getCardTemplate(this.cardIndicesInDeck[i]);
            if(!templateRef)
            {
               throw new Error("GFX [ERROR] - failed to fetch template reference for card ID: " + this.cardIndicesInDeck[i]);
            }
            if((templateRef.isType(type) || type == CardTemplate.CardType_None) && (templateRef.hasEffect(effect) || effect == CardTemplate.CardEffect_None))
            {
               list.push(this.cardIndicesInDeck[i]);
            }
         }
      }
      
      public function tryDrawSpecificCard(templateID:int) : Boolean
      {
         for(var i:int = 0; i < this.cardIndicesInDeck.length; i++)
         {
            if(this.cardIndicesInDeck[i] == templateID)
            {
               this.cardIndicesInDeck.splice(i,1);
               return true;
            }
         }
         return false;
      }
      
      public function numCopiesLeft(cardID:int) : int
      {
         var i:int = 0;
         var numCopies:int = 0;
         for(i = 0; i < this.cardIndicesInDeck.length; i++)
         {
            if(cardID == this.cardIndicesInDeck[i])
            {
               numCopies++;
            }
         }
         return numCopies;
      }
      
      public function dbGetNumCopiesOfCard(cardID:int) : int
      {
         var i:int = 0;
         var numCopies:int = 0;
         for(i = 0; i < this.cardIndices.length; i++)
         {
            if(cardID == this.cardIndices[i])
            {
               numCopies++;
            }
         }
         return numCopies;
      }
      
      public function triggerRefresh() : void
      {
         if(this.refreshCallback != null)
         {
            this.refreshCallback();
         }
      }
      
      public function dbAddCard(cardID:int) : void
      {
         this.cardIndices.push(cardID);
         if(this.onCardChangedCallback != null)
         {
            this.onCardChangedCallback(cardID,this.dbGetNumCopiesOfCard(cardID));
         }
      }
      
      public function dbRemoveCard(cardID:int) : void
      {
         var i:int = 0;
         for(i = 0; i < this.cardIndices.length; i++)
         {
            if(this.cardIndices[i] == cardID)
            {
               this.cardIndices.splice(i,1);
               break;
            }
         }
         if(this.onCardChangedCallback != null)
         {
            this.onCardChangedCallback(cardID,this.dbGetNumCopiesOfCard(cardID));
         }
      }
      
      public function dbIsValidDeck() : Boolean
      {
         var i:int = 0;
         var curTemplate:CardTemplate = null;
         var unitCount:int = 0;
         var cardManagerRef:CardManager = CardManager.getInstance();
         for(i = 0; i < this.cardIndices.length; i++)
         {
            curTemplate = cardManagerRef.getCardTemplate(this.cardIndices[i]);
            if(curTemplate.isType(CardTemplate.CardType_Creature))
            {
               unitCount++;
            }
         }
         trace("GFX RRR dbIsValidDeck ",unitCount);
         if(unitCount < 22)
         {
            return false;
         }
         return true;
      }
      
      public function dbCanAddCard(cardID:int) : Boolean
      {
         var i:int = 0;
         var curTemplate:CardTemplate = null;
         var specialCardCount:int = 0;
         var cardManagerRef:CardManager = CardManager.getInstance();
         var addingCardTemplate:CardTemplate = cardManagerRef.getCardTemplate(cardID);
         if(!addingCardTemplate.isType(CardTemplate.CardType_Creature))
         {
            for(i = 0; i < this.cardIndices.length; i++)
            {
               curTemplate = cardManagerRef.getCardTemplate(this.cardIndices[i]);
               if(!curTemplate.isType(CardTemplate.CardType_Creature))
               {
                  specialCardCount++;
               }
            }
            return specialCardCount < 10;
         }
         return true;
      }
      
      public function dbCountCards(type:int, effect:int) : int
      {
         var templateRef:CardTemplate = null;
         var count:int = 0;
         var cardManagerRef:CardManager = CardManager.getInstance();
         for(var i:int = 0; i < this.cardIndices.length; i++)
         {
            templateRef = cardManagerRef.getCardTemplate(this.cardIndices[i]);
            if((templateRef.isType(type) || type == CardTemplate.CardType_None) && (templateRef.hasEffect(effect) || effect == CardTemplate.CardEffect_None))
            {
               count++;
            }
         }
         return count;
      }
   }
}
