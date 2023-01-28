package red.game.witcher3.events
{
   import flash.events.Event;
   import red.game.witcher3.menus.gwint.GwintCardHolder;
   
   public class GwintHolderEvent extends Event
   {
      
      public static const HOLDER_SELECTED:String = "holder_selected";
      
      public static const HOLDER_CHOSEN:String = "holder_chosen";
       
      
      public var cardHolder:GwintCardHolder;
      
      public function GwintHolderEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, cardHolder:GwintCardHolder = null)
      {
         super(type,bubbles,cancelable);
         this.cardHolder = cardHolder;
      }
      
      override public function clone() : Event
      {
         return new GwintHolderEvent(type,bubbles,cancelable);
      }
      
      override public function toString() : String
      {
         return formatToString("GwintHolderEvent","type","bubbles","cancelable","eventPhase");
      }
   }
}
