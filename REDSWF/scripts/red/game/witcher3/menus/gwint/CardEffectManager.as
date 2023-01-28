package red.game.witcher3.menus.gwint
{
   public class CardEffectManager
   {
       
      
      private var seigeP2List:Vector.<CardInstance>;
      
      private var rangedP2List:Vector.<CardInstance>;
      
      private var meleeP2List:Vector.<CardInstance>;
      
      private var meleeP1List:Vector.<CardInstance>;
      
      private var rangedP1List:Vector.<CardInstance>;
      
      private var seigeP1List:Vector.<CardInstance>;
      
      public var randomResEnabled:Boolean = false;
      
      public var doubleSpyEnabled:Boolean = false;
      
      public function CardEffectManager()
      {
         this.seigeP2List = new Vector.<CardInstance>();
         this.rangedP2List = new Vector.<CardInstance>();
         this.meleeP2List = new Vector.<CardInstance>();
         this.meleeP1List = new Vector.<CardInstance>();
         this.rangedP1List = new Vector.<CardInstance>();
         this.seigeP1List = new Vector.<CardInstance>();
         super();
      }
      
      public function flushAllEffects() : void
      {
         this.meleeP1List.length = 0;
         this.meleeP2List.length = 0;
         this.rangedP1List.length = 0;
         this.rangedP2List.length = 0;
         this.seigeP1List.length = 0;
         this.seigeP2List.length = 0;
      }
      
      private function getEffectList(listID:int, playerID:int) : Vector.<CardInstance>
      {
         if(playerID == CardManager.PLAYER_1)
         {
            if(listID == CardManager.CARD_LIST_LOC_MELEE)
            {
               return this.meleeP1List;
            }
            if(listID == CardManager.CARD_LIST_LOC_RANGED)
            {
               return this.rangedP1List;
            }
            if(listID == CardManager.CARD_LIST_LOC_SEIGE)
            {
               return this.seigeP1List;
            }
         }
         else if(playerID == CardManager.PLAYER_2)
         {
            if(listID == CardManager.CARD_LIST_LOC_MELEE)
            {
               return this.meleeP2List;
            }
            if(listID == CardManager.CARD_LIST_LOC_RANGED)
            {
               return this.rangedP2List;
            }
            if(listID == CardManager.CARD_LIST_LOC_SEIGE)
            {
               return this.seigeP2List;
            }
         }
         return null;
      }
      
      public function registerActiveEffectCardInstance(cardInstance:CardInstance, listID:int, playerID:int) : void
      {
         var correctList:Vector.<CardInstance> = this.getEffectList(listID,playerID);
         trace("GFX - effect was registed in list:",listID,", for player:",playerID," and CardInstance:",cardInstance);
         if(correctList)
         {
            correctList.push(cardInstance);
            CardManager.getInstance().recalculateScores();
            return;
         }
         throw new Error("GFX - Failed to set effect into proper list in GFX manager. listID: " + listID.toString() + ", playerID: " + playerID);
      }
      
      public function unregisterActiveEffectCardInstance(cardInstance:CardInstance) : void
      {
         var indexOf:int = 0;
         trace("GFX - unregistering Effect: ",cardInstance);
         indexOf = this.seigeP2List.indexOf(cardInstance);
         if(indexOf != -1)
         {
            this.seigeP2List.splice(indexOf,1);
         }
         indexOf = this.rangedP2List.indexOf(cardInstance);
         if(indexOf != -1)
         {
            this.rangedP2List.splice(indexOf,1);
         }
         indexOf = this.meleeP2List.indexOf(cardInstance);
         if(indexOf != -1)
         {
            this.meleeP2List.splice(indexOf,1);
         }
         indexOf = this.meleeP1List.indexOf(cardInstance);
         if(indexOf != -1)
         {
            this.meleeP1List.splice(indexOf,1);
         }
         indexOf = this.rangedP1List.indexOf(cardInstance);
         if(indexOf != -1)
         {
            this.rangedP1List.splice(indexOf,1);
         }
         indexOf = this.seigeP1List.indexOf(cardInstance);
         if(indexOf != -1)
         {
            this.seigeP1List.splice(indexOf,1);
         }
         CardManager.getInstance().recalculateScores();
      }
      
      public function getEffectsForList(listID:int, playerID:int) : Vector.<CardInstance>
      {
         var i:int = 0;
         var effectList:Vector.<CardInstance> = new Vector.<CardInstance>();
         var correctList:Vector.<CardInstance> = this.getEffectList(listID,playerID);
         if(correctList)
         {
            for(i = 0; i < correctList.length; i++)
            {
               effectList.push(correctList[i]);
            }
         }
         return effectList;
      }
   }
}
