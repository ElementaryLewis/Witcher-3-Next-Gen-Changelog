package red.game.witcher3.menus.inventory_menu
{
   import red.game.witcher3.controls.W3ScrollingList;
   import scaleform.clik.core.UIComponent;
   import scaleform.clik.data.DataProvider;
   import scaleform.clik.events.ListEvent;
   
   public class PlayerGeneralStatsPanel extends UIComponent
   {
       
      
      public var mcStatsList:W3ScrollingList;
      
      public var dataSetterDelegate:Function;
      
      private var _data:Array;
      
      public function PlayerGeneralStatsPanel()
      {
         super();
         this.mcStatsList.visible = false;
         this.mcStatsList.addEventListener(ListEvent.INDEX_CHANGE,this.handleIndexChanged,false,0,true);
      }
      
      public function get data() : Array
      {
         return this._data;
      }
      
      public function set data(param1:Array) : void
      {
         this._data = param1;
         this.mcStatsList.dataProvider = new DataProvider(this._data as Array);
         this.mcStatsList.focused = 1;
         if(this.mcStatsList.selectedIndex == -1)
         {
            this.mcStatsList.selectedIndex = 0;
         }
      }
      
      private function handleIndexChanged(param1:ListEvent) : void
      {
         if(this.dataSetterDelegate != null)
         {
            if(Boolean(param1.itemData) && Boolean(param1.itemData.subStats))
            {
               this.dataSetterDelegate(param1.itemData.subStats);
            }
            else
            {
               this.dataSetterDelegate([]);
            }
         }
      }
   }
}
