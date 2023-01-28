package red.game.witcher3.menus.gwint
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   import scaleform.clik.core.UIComponent;
   
   public class GwintDeckStatsPanel extends UIComponent
   {
       
      
      protected var _deck:GwintDeck;
      
      public var txtCardCount:TextField;
      
      public var mcUnitCountHightlight:MovieClip;
      
      public var txtUnitCount:TextField;
      
      public var txtTotalCardValue:TextField;
      
      public var mcSpecialHighlight:MovieClip;
      
      public var txtSpecialCount:TextField;
      
      public var txtHeroCount:TextField;
      
      public function GwintDeckStatsPanel()
      {
         super();
      }
      
      override protected function configUI() : void
      {
         super.configUI();
      }
      
      public function set targetDeck(param1:GwintDeck) : void
      {
         this._deck = param1;
         this.updateStats();
      }
      
      public function highlightUnitCount() : void
      {
         if(this.mcUnitCountHightlight)
         {
            this.mcUnitCountHightlight.gotoAndPlay("start");
         }
      }
      
      public function highlightSpecialCards() : void
      {
         if(this.mcSpecialHighlight)
         {
            this.mcSpecialHighlight.gotoAndPlay("start");
         }
      }
      
      public function updateStats() : void
      {
         var _loc6_:int = 0;
         var _loc7_:CardTemplate = null;
         if(!this._deck)
         {
            throw new Error("GFX [ERROR] - trying to call updateStats in GwintDeckStatsPanel with no valid deck set");
         }
         if(this.txtCardCount)
         {
            this.txtCardCount.text = this._deck.cardIndices.length.toString();
         }
         var _loc1_:CardManager = CardManager.getInstance();
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         _loc6_ = 0;
         while(_loc6_ < this._deck.cardIndices.length)
         {
            _loc7_ = _loc1_.getCardTemplate(this._deck.cardIndices[_loc6_]);
            _loc2_ += _loc7_.power;
            if(_loc7_.isType(CardTemplate.CardType_Creature))
            {
               _loc5_++;
            }
            else
            {
               _loc3_++;
            }
            if(_loc7_.isType(CardTemplate.CardType_Hero))
            {
               _loc4_++;
            }
            _loc6_++;
         }
         if(this.txtUnitCount)
         {
            if(_loc5_ < 22)
            {
               this.txtUnitCount.text = _loc5_.toString() + "/22";
               this.txtUnitCount.textColor = 16718876;
            }
            else
            {
               this.txtUnitCount.text = _loc5_.toString();
               this.txtUnitCount.textColor = 11963974;
            }
         }
         if(this.txtTotalCardValue)
         {
            this.txtTotalCardValue.text = _loc2_.toString();
         }
         if(this.txtSpecialCount)
         {
            this.txtSpecialCount.text = _loc3_.toString() + "/10";
         }
         if(this.txtHeroCount)
         {
            this.txtHeroCount.text = _loc4_.toString();
         }
      }
   }
}
