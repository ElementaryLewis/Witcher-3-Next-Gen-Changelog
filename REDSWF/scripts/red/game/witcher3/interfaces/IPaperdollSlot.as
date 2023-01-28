package red.game.witcher3.interfaces
{
   import flash.display.DisplayObject;
   
   public interface IPaperdollSlot extends IInventorySlot
   {
       
      
      function get slotType() : int;
      
      function get slotTag() : String;
      
      function set slotTag(param1:String) : void;
      
      function get navigationUp() : int;
      
      function set navigationUp(param1:int) : void;
      
      function get navigationDown() : int;
      
      function set navigationDown(param1:int) : void;
      
      function get navigationRight() : int;
      
      function set navigationRight(param1:int) : void;
      
      function get navigationLeft() : int;
      
      function set navigationLeft(param1:int) : void;
      
      function get equipID() : int;
      
      function set equipID(param1:int) : void;
      
      function getHitArea() : DisplayObject;
   }
}
