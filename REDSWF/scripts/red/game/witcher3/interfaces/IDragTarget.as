package red.game.witcher3.interfaces
{
   import scaleform.clik.controls.UILoader;
   import scaleform.clik.interfaces.IUIComponent;
   
   public interface IDragTarget extends IUIComponent
   {
       
      
      function getDragData() : *;
      
      function getAvatar() : UILoader;
      
      function canDrag() : Boolean;
      
      function get dragSelection() : Boolean;
      
      function set dragSelection(param1:Boolean) : void;
   }
}
