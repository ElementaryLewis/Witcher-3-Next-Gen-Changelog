package red.game.witcher3.menus.inventory_menu
{
   import com.gskinner.motion.GTweener;
   import com.gskinner.motion.easing.Exponential;
   import flash.display.MovieClip;
   import red.core.CoreMenu;
   import red.core.constants.KeyCode;
   import red.core.events.GameEvent;
   import red.game.witcher3.controls.InputFeedbackButton;
   import red.game.witcher3.events.SlotActionEvent;
   import red.game.witcher3.interfaces.IBaseSlot;
   import red.game.witcher3.slots.SlotInventoryGrid;
   import red.game.witcher3.slots.SlotsListGrid;
   import scaleform.clik.constants.NavigationCode;
   import scaleform.clik.controls.ScrollBar;
   import scaleform.clik.events.InputEvent;
   
   public class MenuSocketsManagment extends CoreMenu
   {
       
      
      public var mcScrollBar:ScrollBar;
      
      public var mcPlayerGrid:SlotsListGrid;
      
      public var btnAccept:InputFeedbackButton;
      
      public var btnClose:InputFeedbackButton;
      
      public var mcGridMask:MovieClip;
      
      public function MenuSocketsManagment()
      {
         super();
         this.__setProp_mcPlayerGrid_Scene1_mcPlayerGrid_0();
      }
      
      override protected function get menuName() : String
      {
         return "InventorySocketsMenu";
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         dispatchEvent(new GameEvent(GameEvent.CALL,"OnConfigUI"));
         dispatchEvent(new GameEvent(GameEvent.REGISTER,"menu.inventory.sockets.items",[this.handleDataSet]));
         this.btnAccept.label = "[[panel_common_accept]]";
         this.btnAccept.setDataFromStage(NavigationCode.GAMEPAD_A,KeyCode.ENTER);
         this.btnClose.label = "[[panel_common_cancel]]";
         this.btnClose.setDataFromStage(NavigationCode.GAMEPAD_B,KeyCode.ESCAPE);
         focused = 1;
         this.mcPlayerGrid.ignoreGridPosition = true;
         this.mcPlayerGrid.focused = 1;
         this.mcPlayerGrid.focusable = false;
         addEventListener(InputEvent.INPUT,this.handleInput,false,0,true);
         this.mcPlayerGrid.addEventListener(SlotActionEvent.EVENT_ACTIVATE,this.handleItemSelect,false,0,true);
      }
      
      protected function handleItemSelect(event:SlotActionEvent) : void
      {
         var targetSlot:IBaseSlot = event.targetSlot as IBaseSlot;
         if(!targetSlot.isEmpty())
         {
            dispatchEvent(new GameEvent(GameEvent.CALL,"OnEquipItem",[targetSlot.data.id]));
         }
      }
      
      override public function handleInput(event:InputEvent) : void
      {
         super.handleInput(event);
         if(!event.handled)
         {
            this.mcPlayerGrid.handleInputNavSimple(event);
         }
      }
      
      override protected function showAnimation() : void
      {
         visible = true;
         alpha = 0.1;
         GTweener.to(this,1,{
            "x":0,
            "alpha":1
         },{"ease":Exponential.easeOut});
      }
      
      protected function handleDataSet(value:Array) : void
      {
         var currentSlot:SlotInventoryGrid = null;
         this.mcPlayerGrid.data = value;
         this.mcPlayerGrid.selectedIndex = 0;
         this.mcPlayerGrid.validateNow();
         for(var i:int = 0; i < this.mcPlayerGrid.getRenderersCount(); i++)
         {
            currentSlot = this.mcPlayerGrid.getRendererAt(i) as SlotInventoryGrid;
            if(currentSlot)
            {
               currentSlot.useContextMgr = false;
            }
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
         this.mcPlayerGrid.scrollBar = "mcScrollBar";
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
