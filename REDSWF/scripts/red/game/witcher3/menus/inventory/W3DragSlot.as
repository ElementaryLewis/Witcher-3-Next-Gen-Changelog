package red.game.witcher3.menus.inventory
{
   import red.game.witcher3.interfaces.IGridItemRenderer;
   
   public class W3DragSlot extends InventorySlot implements IGridItemRenderer
   {
       
      
      public function W3DragSlot()
      {
         super();
      }
      
      override protected function configUI() : void
      {
         super.configUI();
      }
      
      override public function toString() : String
      {
         return "[W3 DragSlot: gridSize " + _gridSize + ", iconPath " + _iconPath + "]";
      }
   }
}
