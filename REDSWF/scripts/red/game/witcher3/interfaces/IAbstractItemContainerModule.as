package red.game.witcher3.interfaces
{
   import red.game.witcher3.menus.common.ItemDataStub;
   import scaleform.clik.interfaces.IUIComponent;
   
   public interface IAbstractItemContainerModule extends IUIComponent
   {
       
      
      function get CurrentItemDataStub() : ItemDataStub;
   }
}
