package red.game.witcher3.menus.common
{
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.text.TextField;
   import red.core.CoreMenuModule;
   import red.core.events.GameEvent;
   import red.game.witcher3.controls.W3ScrollingList;
   import red.game.witcher3.events.GridEvent;
   import red.game.witcher3.managers.InputManager;
   import scaleform.clik.data.DataProvider;
   import scaleform.clik.events.ListEvent;
   
   public class PlayerStatsModule extends CoreMenuModule
   {
       
      
      public var mcStatsList:W3ScrollingList;
      
      public var mcStatsListItem1:W3StatisticsListItem;
      
      public var mcStatsListItem2:W3StatisticsListItem;
      
      public var mcStatsListItem3:W3StatisticsListItem;
      
      public var mcStatsListItem4:W3StatisticsListItem;
      
      public var mcStatsListItem5:W3StatisticsListItem;
      
      public var mcStatsListItem6:W3StatisticsListItem;
      
      public var mcStatsListItem7:W3StatisticsListItem;
      
      public var mcStatsListItem8:W3StatisticsListItem;
      
      public var mcStatsListItem9:W3StatisticsListItem;
      
      public var mcStatsListItem10:W3StatisticsListItem;
      
      public var tfCurrentState:TextField;
      
      protected var _moduleDisplayName:String = "";
      
      internal const tooltipOffset:Number = 600;
      
      public function PlayerStatsModule()
      {
         super();
         dataBindingKey = "inventory.stats";
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         dispatchEvent(new GameEvent(GameEvent.REGISTER,"playerstats.stats",[this.handleStatsUpdate]));
         dispatchEvent(new GameEvent(GameEvent.REGISTER,"playerstats.stats.name",[this.handleModuleNameSet]));
         this.mcStatsList.addEventListener(ListEvent.INDEX_CHANGE,this.handleIndexChange,false,0,true);
         this.mcStatsList.addEventListener(ListEvent.ITEM_ROLL_OVER,this.handleItemRollOver,false,0,true);
         this.mcStatsList.addEventListener(ListEvent.ITEM_ROLL_OUT,this.handleItemRollOut,false,0,true);
         _inputHandlers.push(this.mcStatsList);
      }
      
      private function handleStatsUpdate(param1:Object, param2:int) : void
      {
         var _loc3_:Array = null;
         if(param1)
         {
            _loc3_ = param1 as Array;
            this.mcStatsList.dataProvider = new DataProvider(_loc3_);
            this.mcStatsList.invalidate();
            this.mcStatsList.selectedIndex = 0;
            this.mcStatsList.invalidateSelectedIndex();
            this.mcStatsList.validateNow();
            this.mcStatsList.ShowRenderers(true);
            handleDataChanged();
         }
      }
      
      override public function hasSelectableItems() : Boolean
      {
         return false;
      }
      
      protected function handleModuleNameSet(param1:String) : void
      {
         if(this.tfCurrentState)
         {
            this._moduleDisplayName = param1;
            this.tfCurrentState.htmlText = param1;
         }
      }
      
      override public function set focused(param1:Number) : void
      {
         super.focused = param1;
         this.mcStatsList.focused = param1;
         if(this.tfCurrentState)
         {
            this.tfCurrentState.htmlText = this._moduleDisplayName;
         }
         this.setCurrentItemContext(this.mcStatsList.selectedIndex);
         if(!focused)
         {
            dispatchEvent(new GameEvent(GameEvent.CALL,"OnStatisticsLostFocus",[]));
         }
      }
      
      protected function handleItemRollOver(param1:ListEvent) : void
      {
         var _loc3_:GridEvent = null;
         var _loc4_:W3StatisticsListItem = null;
         var _loc5_:Point = null;
         var _loc2_:Boolean = InputManager.getInstance().isGamepad();
         if(!_loc2_)
         {
            _loc3_ = new GridEvent(GridEvent.DISPLAY_TOOLTIP,true,false,-1,-1,-1,null,null);
            _loc4_ = param1.itemRenderer as W3StatisticsListItem;
            _loc5_ = localToGlobal(new Point(_loc4_.x,_loc4_.y));
            _loc5_.x -= this.tooltipOffset;
            _loc3_.tooltipCustomArgs = [param1.itemData.id];
            _loc3_.isMouseTooltip = !_loc2_;
            _loc3_.anchorRect = new Rectangle(_loc5_.x,_loc5_.y,0,0);
            _loc3_.tooltipDataSource = "OnShowStatTooltip";
            dispatchEvent(_loc3_);
         }
      }
      
      protected function handleItemRollOut(param1:ListEvent) : void
      {
         var _loc3_:GridEvent = null;
         var _loc2_:Boolean = InputManager.getInstance().isGamepad();
         if(!_loc2_)
         {
            _loc3_ = new GridEvent(GridEvent.HIDE_TOOLTIP,true,false,-1,-1,-1,null,null);
            dispatchEvent(_loc3_);
         }
      }
      
      protected function handleIndexChange(param1:ListEvent) : void
      {
         var _loc2_:Boolean = InputManager.getInstance().isGamepad();
         if(_loc2_)
         {
            this.updateContext(param1.itemData.id);
         }
      }
      
      protected function setCurrentItemContext(param1:int) : void
      {
         var _loc2_:W3StatisticsListItem = this.mcStatsList.getRendererAt(param1) as W3StatisticsListItem;
         if(_loc2_)
         {
            this.updateContext(_loc2_.GetId());
         }
      }
      
      protected function updateContext(param1:uint) : void
      {
         dispatchEvent(new GameEvent(GameEvent.CALL,"OnSelectPlayerStat",[param1]));
      }
   }
}
