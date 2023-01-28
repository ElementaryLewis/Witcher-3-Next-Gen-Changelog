package red.game.witcher3.menus.overlay
{
   import com.gskinner.motion.GTweener;
   import com.gskinner.motion.easing.Exponential;
   import red.core.CoreMenu;
   import red.core.events.GameEvent;
   import red.game.witcher3.controls.W3GamepadButton;
   import red.game.witcher3.events.SlotActionEvent;
   import red.game.witcher3.interfaces.IBaseSlot;
   import red.game.witcher3.slots.SlotInventoryGrid;
   import red.game.witcher3.slots.SlotsListGrid;
   import scaleform.clik.constants.NavigationCode;
   
   public class ItemSelectMenu extends CoreMenu
   {
       
      
      public var mcPlayerGrid:SlotsListGrid;
      
      public var btnAccept:W3GamepadButton;
      
      public var btnClose:W3GamepadButton;
      
      public function ItemSelectMenu()
      {
         _enableMouse = true;
         super();
         this.__setProp_mcPlayerGrid_Scene1_mcPlayerGrid_0();
      }
      
      override protected function get menuName() : String
      {
         return "SelectItemMenu";
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         dispatchEvent(new GameEvent(GameEvent.CALL,"OnConfigUI"));
         dispatchEvent(new GameEvent(GameEvent.REGISTER,"items.list.data",[this.handleDataSet]));
         this.btnAccept.label = "Accept";
         this.btnAccept.navigationCode = NavigationCode.GAMEPAD_A;
         this.btnClose.label = "Close";
         this.btnClose.navigationCode = NavigationCode.GAMEPAD_B;
         focused = 1;
         this.mcPlayerGrid.ignoreGridPosition = true;
         this.mcPlayerGrid.focused = 1;
         this.mcPlayerGrid.focusable = false;
         this.mcPlayerGrid.addEventListener(SlotActionEvent.EVENT_ACTIVATE,this.handleItemSelect,false,0,true);
      }
      
      override protected function showAnimation() : void
      {
         visible = true;
         alpha = 0.5;
         GTweener.to(this,1,{
            "x":0,
            "alpha":1
         },{"ease":Exponential.easeOut});
      }
      
      protected function handleItemSelect(param1:SlotActionEvent) : void
      {
         var _loc2_:IBaseSlot = param1.targetSlot as IBaseSlot;
         if(!_loc2_.isEmpty())
         {
            trace("GFX [ItemSelectMenu] handleItemSelect, item id: ",_loc2_.data.id);
            dispatchEvent(new GameEvent(GameEvent.CALL,"OnSelectItem",[_loc2_.data.id]));
         }
      }
      
      protected function handleDataSet(param1:Array) : void
      {
         var _loc2_:SlotInventoryGrid = null;
         this.mcPlayerGrid.data = param1;
         this.mcPlayerGrid.selectedIndex = 0;
         this.mcPlayerGrid.validateNow();
         var _loc3_:int = 0;
         while(_loc3_ < this.mcPlayerGrid.getRenderersCount())
         {
            _loc2_ = this.mcPlayerGrid.getRendererAt(_loc3_) as SlotInventoryGrid;
            if(_loc2_)
            {
               _loc2_.useContextMgr = false;
            }
            _loc3_++;
         }
      }
      
      internal function __setProp_mcPlayerGrid_Scene1_mcPlayerGrid_0() : *
      {
         try
         {
            this.mcPlayerGrid["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         this.mcPlayerGrid.columns = 8;
         this.mcPlayerGrid.elementGridSquareOffset = 0;
         this.mcPlayerGrid.enabled = true;
         this.mcPlayerGrid.enableInitCallback = false;
         this.mcPlayerGrid.gridSquareSize = 64;
         this.mcPlayerGrid.rows = 8;
         this.mcPlayerGrid.scrollBar = "";
         this.mcPlayerGrid.slotRendererName = "InventorySlotRef";
         this.mcPlayerGrid.visible = true;
         try
         {
            this.mcPlayerGrid["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
   }
}
