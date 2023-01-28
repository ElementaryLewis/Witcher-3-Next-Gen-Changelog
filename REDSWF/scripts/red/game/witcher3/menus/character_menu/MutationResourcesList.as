package red.game.witcher3.menus.character_menu
{
   import com.gskinner.motion.GTween;
   import com.gskinner.motion.GTweener;
   import com.gskinner.motion.easing.Exponential;
   import flash.events.Event;
   import flash.utils.getDefinitionByName;
   import red.core.constants.KeyCode;
   import red.game.witcher3.controls.W3ScrollingList;
   import red.game.witcher3.utils.CommonUtils;
   import scaleform.clik.core.UIComponent;
   import scaleform.clik.data.DataProvider;
   import scaleform.clik.events.InputEvent;
   import scaleform.clik.events.ListEvent;
   import scaleform.clik.interfaces.IListItemRenderer;
   
   public class MutationResourcesList extends UIComponent
   {
       
      
      internal const TWEEN_DURATION = 0.2;
      
      internal const RENDERER_CLASS_REF = "MutationProgressItemRendererRef";
      
      private var _scrollingList:W3ScrollingList;
      
      private var _renderersList:Vector.<IListItemRenderer>;
      
      private var _positionsCache:Object;
      
      private var _data:Array;
      
      private var _activated:Boolean;
      
      private var _selectedItem:MutationProgressItemRenderer;
      
      public function MutationResourcesList()
      {
         super();
         this._renderersList = new Vector.<IListItemRenderer>();
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         this._scrollingList = new W3ScrollingList();
         this._scrollingList.addEventListener(ListEvent.ITEM_DOUBLE_CLICK,this.handleItemDoubleClick,false,0,true);
         this._scrollingList.addEventListener(ListEvent.INDEX_CHANGE,this.handleItemIndexChanged,false,0,true);
         this._scrollingList.UpAction = KeyCode.LEFT;
         this._scrollingList.DownAction = KeyCode.RIGHT;
         this._scrollingList.selectOnOver = true;
         addChild(this._scrollingList);
      }
      
      public function get data() : Array
      {
         return this._data;
      }
      
      public function set data(param1:Array) : void
      {
         var _loc2_:Object = null;
         this._data = [];
         for each(_loc2_ in param1)
         {
            if(_loc2_.required > 0)
            {
               this._data.push(CommonUtils.replicateDataObject(_loc2_));
            }
         }
      }
      
      public function updateMutationResearch(param1:Object) : void
      {
         var _loc4_:MutationProgressItemRenderer = null;
         var _loc5_:Object = null;
         var _loc2_:int = int(this._renderersList.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            if((_loc5_ = (_loc4_ = this._renderersList[_loc3_] as MutationProgressItemRenderer).data).type == param1.type)
            {
               _loc4_.setData(param1);
               _loc4_.validateNow();
            }
            _loc3_++;
         }
      }
      
      public function activate() : void
      {
         this._scrollingList.selectedIndex = -1;
         this.createRenderers();
         if(this._data)
         {
            this._scrollingList.itemRendererList = this._renderersList;
            this._scrollingList.dataProvider = new DataProvider(this._data);
            this._scrollingList.validateNow();
            this.tweenRenderers(true,this.handleRenderersShown);
         }
      }
      
      public function deactiavate() : void
      {
         this.tweenRenderers(false,this.handleRenderersHidden);
      }
      
      private function createRenderers() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         if(this._data)
         {
            _loc1_ = int(this._data.length);
            this.cleanup();
            _loc2_ = 0;
            while(_loc2_ < _loc1_)
            {
               this._renderersList.push(this.spawnRenderer(this.data[_loc2_]) as MutationProgressItemRenderer);
               _loc2_++;
            }
         }
      }
      
      private function tweenRenderers(param1:Boolean = true, param2:Function = null) : void
      {
         var _loc6_:MutationProgressItemRenderer = null;
         var _loc7_:Object = null;
         var _loc8_:Object = null;
         var _loc9_:Object = null;
         var _loc3_:int = int(this._renderersList.length);
         var _loc4_:Boolean = false;
         if(param1)
         {
            this._positionsCache = this.getPositionsList(_loc3_);
         }
         var _loc5_:int = 0;
         while(_loc5_ < _loc3_)
         {
            _loc6_ = this._renderersList[_loc5_] as MutationProgressItemRenderer;
            _loc7_ = {"ease":Exponential.easeOut};
            if(!param1)
            {
               _loc8_ = {
                  "x":0,
                  "y":0
               };
            }
            else if(_loc9_ = this._positionsCache[_loc5_])
            {
               _loc8_ = {
                  "x":_loc9_.x,
                  "y":_loc9_.y
               };
            }
            if(!_loc4_ && param2 != null)
            {
               _loc7_.onComplete = param2;
               _loc4_ = true;
            }
            GTweener.removeTweens(_loc6_);
            GTweener.to(_loc6_,this.TWEEN_DURATION,_loc8_,_loc7_);
            _loc5_++;
         }
      }
      
      private function handleRenderersShown(param1:GTween = null) : void
      {
         this._scrollingList.selectedIndex = 0;
         this._scrollingList.focusable = false;
         this._scrollingList.bSkipFocusCheck = true;
         dispatchEvent(new Event(Event.ACTIVATE));
      }
      
      private function handleRenderersHidden(param1:GTween = null) : void
      {
         this.cleanup();
         dispatchEvent(new Event(Event.DEACTIVATE));
      }
      
      private function cleanup() : void
      {
         while(this._renderersList.length)
         {
            removeChild(this._renderersList.pop());
         }
      }
      
      private function spawnRenderer(param1:Object) : MutationProgressItemRenderer
      {
         var _loc2_:Class = getDefinitionByName(this.RENDERER_CLASS_REF) as Class;
         var _loc3_:MutationProgressItemRenderer = new _loc2_() as MutationProgressItemRenderer;
         var _loc4_:Number = _loc3_.mcHitArea.width / 2;
         addChild(_loc3_);
         _loc3_.preventAutosizing = true;
         _loc3_.constraintsDisabled = true;
         _loc3_.setData(param1);
         _loc3_.validateNow();
         _loc3_.x = -_loc4_;
         _loc3_.y = -_loc4_;
         return _loc3_;
      }
      
      private function handleItemDoubleClick(param1:ListEvent) : void
      {
      }
      
      private function handleItemIndexChanged(param1:ListEvent) : void
      {
         this._selectedItem = param1.itemRenderer as MutationProgressItemRenderer;
         dispatchEvent(param1);
      }
      
      override public function handleInput(param1:InputEvent) : void
      {
         super.handleInput(param1);
         this._scrollingList.handleInput(param1);
      }
      
      private function getPositionsList(param1:int) : Array
      {
         var _loc2_:Array = [];
         switch(param1)
         {
            case 1:
               _loc2_.push({
                  "x":-38,
                  "y":70
               });
               break;
            case 2:
               _loc2_.push({
                  "x":-82,
                  "y":70
               });
               _loc2_.push({
                  "x":6,
                  "y":70
               });
               break;
            case 3:
               _loc2_.push({
                  "x":-140,
                  "y":40
               });
               _loc2_.push({
                  "x":-34,
                  "y":75
               });
               _loc2_.push({
                  "x":70,
                  "y":54
               });
               break;
            case 4:
               _loc2_.push({
                  "x":-160,
                  "y":40
               });
               _loc2_.push({
                  "x":-80,
                  "y":70
               });
               _loc2_.push({
                  "x":5,
                  "y":70
               });
               _loc2_.push({
                  "x":85,
                  "y":40
               });
         }
         return _loc2_;
      }
   }
}
