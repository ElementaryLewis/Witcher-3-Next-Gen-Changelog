package red.game.witcher3.menus.inventory_menu
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   import red.core.events.GameEvent;
   import red.game.witcher3.events.ControllerChangeEvent;
   import red.game.witcher3.interfaces.IDragTarget;
   import red.game.witcher3.interfaces.IDropTarget;
   import red.game.witcher3.managers.InputManager;
   import red.game.witcher3.menus.common.ItemDataStub;
   import red.game.witcher3.slots.SlotDragAvatar;
   import red.game.witcher3.slots.SlotsTransferManager;
   import scaleform.clik.core.UIComponent;
   
   public class InventoryDropArea extends UIComponent implements IDropTarget
   {
       
      
      public var mcBorder:MovieClip;
      
      public var mcIconGlow:MovieClip;
      
      public var txtLabel:TextField;
      
      private var _isGamepad:Boolean;
      
      private var _dropSelection:Boolean;
      
      private var _inputManager:InputManager;
      
      protected var _disabled:Boolean = false;
      
      private var _dropEnabled:Boolean = true;
      
      public function InventoryDropArea()
      {
         super();
         this.txtLabel.text = "[[panel_button_common_drop]]";
         this.mcIconGlow.visible = false;
         SlotsTransferManager.getInstance().addDropTarget(this);
         visible = false;
      }
      
      public function get disabled() : Boolean
      {
         return this._disabled;
      }
      
      public function set disabled(param1:Boolean) : void
      {
         this._disabled = param1;
         this.updateVisibility();
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         this._inputManager = InputManager.getInstance();
         this._inputManager.addEventListener(ControllerChangeEvent.CONTROLLER_CHANGE,this.handleControllerChange,false,0,true);
         this._isGamepad = this._inputManager.isGamepad();
         this.updateVisibility();
      }
      
      private function handleControllerChange(param1:ControllerChangeEvent) : void
      {
         this._isGamepad = param1.isGamepad;
         this.updateVisibility();
      }
      
      private function updateVisibility() : void
      {
         visible = !this._isGamepad && !this._disabled;
      }
      
      public function get dropEnabled() : Boolean
      {
         return this._dropEnabled;
      }
      
      public function set dropEnabled(param1:Boolean) : void
      {
         this._dropEnabled = param1;
      }
      
      public function get dropSelection() : Boolean
      {
         return this._dropSelection;
      }
      
      public function set dropSelection(param1:Boolean) : void
      {
         this._dropSelection = param1;
      }
      
      public function processOver(param1:SlotDragAvatar) : int
      {
         this.mcIconGlow.visible = param1 != null;
         return SlotDragAvatar.ACTION_DROP;
      }
      
      public function canDrop(param1:IDragTarget) : Boolean
      {
         var _loc2_:ItemDataStub = param1.getDragData() as ItemDataStub;
         return _loc2_ && _loc2_.canDrop && !this._inputManager.isGamepad() && visible;
      }
      
      public function applyDrop(param1:IDragTarget) : void
      {
         var _loc2_:ItemDataStub = param1.getDragData() as ItemDataStub;
         if(Boolean(_loc2_) && _loc2_.canDrop)
         {
            dispatchEvent(new GameEvent(GameEvent.CALL,"OnDropItem",[_loc2_.id,_loc2_.quantity]));
            this.mcBorder.gotoAndPlay(2);
         }
      }
   }
}
