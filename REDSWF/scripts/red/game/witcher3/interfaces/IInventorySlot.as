package red.game.witcher3.interfaces
{
   public interface IInventorySlot extends IBaseSlot
   {
       
      
      function get uplink() : IInventorySlot;
      
      function set uplink(param1:IInventorySlot) : void;
      
      function get highlight() : Boolean;
      
      function set highlight(param1:Boolean) : void;
   }
}
