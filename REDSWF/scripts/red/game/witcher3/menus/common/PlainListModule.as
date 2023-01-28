package red.game.witcher3.menus.common
{
   import flash.display.MovieClip;
   import red.core.CoreMenuModule;
   import red.game.witcher3.controls.W3ScrollingList;
   import red.game.witcher3.utils.CommonUtils;
   import scaleform.clik.controls.ScrollBar;
   import scaleform.clik.core.UIComponent;
   import scaleform.clik.data.DataProvider;
   import scaleform.clik.events.InputEvent;
   import scaleform.clik.interfaces.IListItemRenderer;
   
   public class PlainListModule extends CoreMenuModule
   {
       
      
      public var mcEmptyList:MovieClip;
      
      public var mcScrollbar:ScrollBar;
      
      public var mcScrollingList:W3ScrollingList;
      
      protected var _data:Array;
      
      public function PlainListModule()
      {
         super();
         this.mcScrollingList.focusable = false;
         this.mcEmptyList.visible = false;
      }
      
      override public function set focused(param1:Number) : void
      {
         var _loc4_:IconItemRenderer = null;
         super.focused = param1;
         var _loc2_:* = param1 == 1;
         var _loc3_:Vector.<IListItemRenderer> = this.mcScrollingList.getRenderers();
         var _loc5_:int = int(_loc3_.length);
         var _loc6_:int = 0;
         while(_loc6_ < _loc5_)
         {
            if(_loc4_ = _loc3_[_loc6_] as IconItemRenderer)
            {
               _loc4_.activeSelectionEnabled = _loc2_;
            }
            _loc6_++;
         }
         this.mcScrollingList.focusable = false;
         this.mcScrollbar.alpha = _loc2_ ? 1 : 0.4;
         _inputHandlers.push(this.mcScrollingList);
      }
      
      public function get data() : Array
      {
         return this._data;
      }
      
      public function set data(param1:Array) : void
      {
         this._data = param1;
         if(!this._data || this._data.length < 1)
         {
            this.mcScrollingList.dataProvider = new DataProvider([]);
            this.mcEmptyList.visible = true;
            return;
         }
         this.mcEmptyList.visible = false;
         var _loc2_:DataProvider = new DataProvider(this._data);
         _loc2_.sort(this.sortList);
         this.mcScrollingList.dataProvider = _loc2_;
         this.mcScrollingList.selectedIndex = 0;
      }
      
      private function sortList(param1:Object, param2:Object) : int
      {
         if(Boolean(param1.isNew) && !param2.isNew)
         {
            return -1;
         }
         if(!param1.isNew && Boolean(param2.isNew))
         {
            return 1;
         }
         if(CommonUtils.toUpperCaseSafe(param1.label) > CommonUtils.toUpperCaseSafe(param2.label))
         {
            return 1;
         }
         return -1;
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
