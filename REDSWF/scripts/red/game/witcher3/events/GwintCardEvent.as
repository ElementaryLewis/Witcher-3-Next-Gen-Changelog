package red.game.witcher3.events
{
   import flash.events.Event;
   import red.game.witcher3.menus.gwint.CardSlot;
   import red.game.witcher3.menus.gwint.GwintCardHolder;
   
   public class GwintCardEvent extends Event
   {
      
      public static const CARD_SELECTED:String = "card_selected";
      
      public static const CARD_CHOSEN:String = "card_chosen";
       
      
      public var cardSlot:CardSlot;
      
      public var cardHolder:GwintCardHolder;
      
      public function GwintCardEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, cardSlot:CardSlot = null, cardHolder:GwintCardHolder = null)
      {
         super(type,bubbles,cancelable);
         this.cardSlot = cardSlot;
         this.cardHolder = cardHolder;
      }
      
      override public function clone() : Event
      {
         return new GwintCardEvent(type,bubbles,cancelable);
      }
      
      override public function toString() : String
      {
         return formatToString("GwintCardEvent","type","bubbles","cancelable","eventPhase");
      }
   }
}
