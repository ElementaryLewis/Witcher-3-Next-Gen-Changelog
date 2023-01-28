package red.game.witcher3.interfaces
{
   import scaleform.clik.interfaces.IListItemRenderer;
   import scaleform.clik.interfaces.IUIComponent;
   
   public interface IScrollingList extends IUIComponent
   {
       
      
      function getRendererAt(param1:uint, param2:int = 0) : IListItemRenderer;
      
      function get selectedIndex() : int;
      
      function set selectedIndex(param1:int) : void;
   }
}
