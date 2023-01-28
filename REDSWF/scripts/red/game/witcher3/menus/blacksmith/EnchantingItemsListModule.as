package red.game.witcher3.menus.blacksmith
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import red.core.CoreMenuModule;
   import red.game.witcher3.controls.W3ScrollingList;
   import red.game.witcher3.menus.common.IconItemRenderer;
   import scaleform.clik.controls.ScrollBar;
   import scaleform.clik.core.UIComponent;
   import scaleform.clik.data.DataProvider;
   import scaleform.clik.events.InputEvent;
   import scaleform.clik.events.ListEvent;
   import scaleform.clik.interfaces.IListItemRenderer;
   
   public class EnchantingItemsListModule extends CoreMenuModule
   {
       
      
      public var mcEmptyList:MovieClip;
      
      public var mcScrollbar:ScrollBar;
      
      public var mcScrollingList:W3ScrollingList;
      
      protected var _data:Array;
      
      protected var _itemRendererClassName:String;
      
      public var filterFunction:Function;
      
      public function EnchantingItemsListModule()
      {
         super();
         dataBindingKey = "EnchantingItemsListModule";
         this.mcEmptyList.visible = false;
         this.mcScrollingList.addEventListener(ListEvent.ITEM_CLICK,this.handleItemClick,false,0,true);
      }
      
      public function get itemRendererClassName() : String
      {
         return this._itemRendererClassName;
      }
      
      public function set itemRendererClassName(param1:String) : void
      {
         this._itemRendererClassName = param1;
         this.mcScrollingList.itemRendererName = this._itemRendererClassName;
      }
      
      private function handleItemClick(param1:ListEvent) : void
      {
         dispatchEvent(new Event(EVENT_MOUSE_FOCUSE));
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         stage.addEventListener(InputEvent.INPUT,this.handleInput,false,0,true);
         this.updateActiveSelectionEnabled();
      }
      
      override public function set focused(param1:Number) : void
      {
         super.focused = param1;
         var _loc2_:* = param1 == 1;
         this.updateActiveSelectionEnabled();
         this.mcScrollingList.focusable = false;
         this.mcScrollingList.focused = param1;
         this.mcScrollbar.alpha = _loc2_ ? 1 : 0.4;
         _inputHandlers.push(this.mcScrollingList);
      }
      
      protected function updateActiveSelectionEnabled() : void
      {
         var _loc3_:IconItemRenderer = null;
         var _loc1_:Vector.<IListItemRenderer> = this.mcScrollingList.getRenderers();
         var _loc2_:int = int(_loc1_.length);
         var _loc4_:* = _focused == 1;
         var _loc5_:int = 0;
         while(_loc5_ < _loc2_)
         {
            _loc3_ = _loc1_[_loc5_] as IconItemRenderer;
            if(_loc3_)
            {
               _loc3_.activeSelectionEnabled = _loc4_;
            }
            _loc5_++;
         }
      }
      
      public function get data() : Array
      {
         return this._data;
      }
      
      public function set data(param1:Array) : void
      {
         if(this.filterFunction != null)
         {
            this._data = this.filterFunction(param1);
         }
         else
         {
            this._data = param1;
         }
         if(!this._data || this._data.length < 1)
         {
            this.mcScrollingList.dataProvider = new DataProvider([]);
            this.mcEmptyList.visible = true;
            return;
         }
         this.mcEmptyList.visible = false;
         var _loc2_:DataProvider = new DataProvider(this._data);
         this.mcScrollingList.dataProvider = _loc2_;
         this.mcScrollingList.selectedIndex = 0;
         this.mcScrollingList.validateNow();
         this.updateActiveSelectionEnabled();
      }
      
      override public function handleInput(param1:InputEvent) : void
      {
         var _loc2_:UIComponent = null;
         if(param1.handled || !focused || !enabled || !visible)
         {
            return;
         }
         for each(_loc2_ in _inputHandlers)
         {
            _loc2_.handleInput(param1);
            if(param1.handled)
            {
               param1.stopImmediatePropagation();
               return;
            }
         }
      }
   }
}
