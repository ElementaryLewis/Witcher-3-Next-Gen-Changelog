package red.game.witcher3.menus.gwint
{
   public class CardTransaction
   {
       
      
      public var sourceCardInstanceRef:CardInstance = null;
      
      public var targetCardInstanceRef:CardInstance = null;
      
      public var targetSlotID:int;
      
      public var targetPlayerID:int;
      
      public var powerChangeResult:Number = 0;
      
      public var strategicValue:Number = 0;
      
      public function CardTransaction()
      {
         this.targetSlotID = CardManager.CARD_LIST_LOC_INVALID;
         this.targetPlayerID = CardManager.PLAYER_INVALID;
         super();
      }
      
      public function toString() : String
      {
         return "[Gwint CardTransaction] sourceCard:[[[" + this.sourceCardInstanceRef + "]]], targetSlotID:" + this.targetSlotID + ", targetPlayerID:" + this.targetPlayerID + ", StrategicValue:" + this.strategicValue.toString() + ", PowerChangeResult:" + this.powerChangeResult.toString() + ", targetCardRef:[[[" + this.targetCardInstanceRef + "]]]";
      }
   }
}
