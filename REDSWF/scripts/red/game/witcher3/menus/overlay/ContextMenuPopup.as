package red.game.witcher3.menus.overlay
{
   import red.core.events.GameEvent;
   import red.game.witcher3.controls.W3ScrollingList;
   import scaleform.clik.data.DataProvider;
   import scaleform.clik.events.InputEvent;
   import scaleform.clik.events.ListEvent;
   import scaleform.clik.managers.InputDelegate;
   
   public class ContextMenuPopup extends BasePopup
   {
       
      
      public var actionList:W3ScrollingList;
      
      public function ContextMenuPopup()
      {
         super();
         visible = false;
         InputDelegate.getInstance().addEventListener(InputEvent.INPUT,this.handleInput,false,0,true);
         this.actionList.addEventListener(ListEvent.INDEX_CHANGE,this.handleSelectChange,false,0,true);
         this.actionList.addEventListener(ListEvent.ITEM_DOUBLE_CLICK,this.handleListDoubleClick,false,0,true);
      }
      
      override protected function populateData() : void
      {
         mcInpuFeedback.handleSetupButtons(_data.ButtonsList);
         this.actionList.dataProvider = new DataProvider(_data.ActionsList as Array);
         this.x = _data.positionX;
         this.y = _data.positionY;
         visible = true;
         this.actionList.focused = 1;
         this.actionList.selectedIndex = 0;
      }
      
      protected function handleSelectChange(param1:ListEvent) : void
      {
         dispatchEvent(new GameEvent(GameEvent.CALL,"OnContextActionChange",[param1.itemData.NavCode,false]));
      }
      
      protected function handleListDoubleClick(param1:ListEvent) : void
      {
         dispatchEvent(new GameEvent(GameEvent.CALL,"OnContextActionChange",[param1.itemData.NavCode,true]));
      }
      
      override public function handleInput(param1:InputEvent) : void
      {
         super.handleInput(param1);
         this.actionList.handleInput(param1);
      }
   }
}
