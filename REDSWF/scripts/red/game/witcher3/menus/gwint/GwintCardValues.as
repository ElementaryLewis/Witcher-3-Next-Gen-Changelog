package red.game.witcher3.menus.gwint
{
   import flash.utils.Dictionary;
   
   public class GwintCardValues
   {
       
      
      public var weatherCardValue:Number;
      
      public var hornCardValue:Number;
      
      public var drawCardValue:Number;
      
      public var scorchCardValue:Number;
      
      public var summonClonesCardValue:Number;
      
      public var unsummonCardValue:Number;
      
      public var improveNeighboursCardValue:Number;
      
      public var nurseCardValue:Number;
      
      private var _bufferedDictionary:Dictionary;
      
      public function GwintCardValues()
      {
         super();
      }
      
      public function getEffectValueDictionary() : Dictionary
      {
         if(this._bufferedDictionary == null)
         {
            this._bufferedDictionary = new Dictionary();
            this._bufferedDictionary[CardTemplate.CardEffect_Horn] = this.hornCardValue;
            this._bufferedDictionary[CardTemplate.CardEffect_Draw] = this.drawCardValue;
            this._bufferedDictionary[CardTemplate.CardEffect_Draw2] = this.drawCardValue * 2;
            this._bufferedDictionary[CardTemplate.CardEffect_Scorch] = this.scorchCardValue;
            this._bufferedDictionary[CardTemplate.CardEffect_SummonClones] = this.summonClonesCardValue;
            this._bufferedDictionary[CardTemplate.CardEffect_UnsummonDummy] = this.unsummonCardValue;
            this._bufferedDictionary[CardTemplate.CardEffect_ImproveNeighbours] = this.improveNeighboursCardValue;
            this._bufferedDictionary[CardTemplate.CardEffect_Nurse] = this.nurseCardValue;
         }
         return this._bufferedDictionary;
      }
   }
}
