package red.game.witcher3.menus.character_menu
{
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.utils.Dictionary;
   import red.game.witcher3.interfaces.IBaseSlot;
   import red.game.witcher3.slots.SlotBase;
   import red.game.witcher3.slots.SlotsListPreset;
   import scaleform.clik.events.ListEvent;
   
   public class MutationItemsList extends SlotsListPreset
   {
       
      
      protected const TWEEN_DISTANCE = 20;
      
      protected var _connectionsCanvas:Sprite;
      
      protected var _dependenciesGraph:Dictionary;
      
      public function MutationItemsList()
      {
         super();
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         this._connectionsCanvas = new Sprite();
         parent.addChildAt(this._connectionsCanvas,0);
      }
      
      public function updateSingleMutation(param1:Object) : void
      {
         var _loc2_:MutationItemRenderer = this.getRendererById(param1.mutationId);
         if(_loc2_)
         {
            _loc2_.data = param1;
            _loc2_.validateNow();
         }
      }
      
      override public function set selectedIndex(param1:int) : void
      {
         super.selectedIndex = param1;
      }
      
      override protected function populateData() : void
      {
         var _loc3_:Object = null;
         var _loc4_:MutationItemRenderer = null;
         if(!_data)
         {
            return;
         }
         var _loc1_:int = int(_data.length);
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = _data[_loc2_];
            if(_loc4_ = this.getRendererById(_loc3_.mutationId))
            {
               _loc3_.gridSize = 1;
               _loc4_.data = _loc3_;
               _loc4_.draggingEnabled = false;
            }
            _loc2_++;
         }
      }
      
      public function setResearchMode(param1:Boolean, param2:MutationItemRenderer = null) : void
      {
         var _loc4_:MutationItemRenderer = null;
         var _loc3_:int = int(_renderers.length);
         var _loc5_:int = 0;
         while(_loc5_ < _loc3_)
         {
            if(_loc4_ = _renderers[_loc5_] as MutationItemRenderer)
            {
               if(param1 && _loc4_ != param2)
               {
                  _loc4_.alpha = 0.1;
                  _loc4_.blocked = true;
               }
               else
               {
                  _loc4_.alpha = 1;
                  _loc4_.blocked = false;
               }
            }
            _loc5_++;
         }
         this._connectionsCanvas.alpha = param1 ? 0.1 : 1;
      }
      
      protected function buildDependenciesGraph() : void
      {
         var _loc3_:Object = null;
         var _loc4_:Array = null;
         var _loc5_:int = 0;
         var _loc6_:MutationItemRenderer = null;
         var _loc7_:Array = null;
         var _loc8_:int = 0;
         var _loc9_:Object = null;
         var _loc10_:MutationItemRenderer = null;
         if(!_data)
         {
            return;
         }
         this._dependenciesGraph = new Dictionary(true);
         var _loc1_:int = int(_data.length);
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = _data[_loc2_];
            if((Boolean(_loc4_ = _loc3_.requiredMutations as Array)) && Boolean(_loc4_.length))
            {
               _loc5_ = int(_loc4_.length);
               if(_loc6_ = this.getRendererById(_loc3_.mutationId))
               {
                  _loc7_ = [];
                  this._dependenciesGraph[_loc6_] = _loc7_;
                  _loc8_ = 0;
                  while(_loc8_ < _loc5_)
                  {
                     _loc9_ = _loc4_[_loc8_];
                     if(_loc10_ = this.getRendererById(_loc9_.type))
                     {
                        _loc7_.push(_loc10_);
                     }
                     _loc8_++;
                  }
               }
            }
            _loc2_++;
         }
      }
      
      protected function updateConnectors(param1:Dictionary) : void
      {
         var _loc3_:Object = null;
         var _loc4_:MutationItemRenderer = null;
         var _loc5_:Array = null;
         var _loc6_:int = 0;
         var _loc7_:MutationItemRenderer = null;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         if(!param1)
         {
            return;
         }
         var _loc2_:Number = 66.5;
         this._connectionsCanvas.graphics.clear();
         this._connectionsCanvas.graphics.lineStyle(2,16777215,0.5);
         for(_loc3_ in param1)
         {
            if(_loc4_ = _loc3_ as MutationItemRenderer)
            {
               if(_loc5_ = param1[_loc4_] as Array)
               {
                  _loc6_ = 0;
                  while(_loc6_ < _loc5_.length)
                  {
                     if(_loc7_ = _loc5_[_loc6_] as MutationItemRenderer)
                     {
                        _loc8_ = _loc4_.x - _loc7_.x;
                        _loc9_ = _loc4_.y - _loc7_.y;
                        _loc10_ = Math.atan2(_loc9_,_loc8_);
                        this._connectionsCanvas.graphics.moveTo(_loc4_.x - _loc2_ * Math.cos(_loc10_),_loc4_.y - _loc2_ * Math.sin(_loc10_));
                        this._connectionsCanvas.graphics.lineTo(_loc7_.x + _loc2_ * Math.cos(_loc10_),_loc7_.y + _loc2_ * Math.sin(_loc10_));
                     }
                     _loc6_++;
                  }
               }
            }
         }
      }
      
      protected function getRendererById(param1:int) : MutationItemRenderer
      {
         var _loc3_:MutationItemRenderer = null;
         var _loc2_:int = int(_renderers.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc2_)
         {
            _loc3_ = _renderers[_loc4_] as MutationItemRenderer;
            if(Boolean(_loc3_) && _loc3_.mutationId == param1)
            {
               return _loc3_;
            }
            _loc4_++;
         }
         return null;
      }
      
      override protected function setupRenderer(param1:IBaseSlot) : void
      {
         super.setupRenderer(param1);
         param1.addEventListener(MouseEvent.DOUBLE_CLICK,this.handleItemDoubleClick,false,0,true);
      }
      
      protected function handleItemDoubleClick(param1:MouseEvent) : void
      {
         var _loc3_:ListEvent = null;
         var _loc2_:MutationItemRenderer = param1.currentTarget as MutationItemRenderer;
         if(!_loc2_ && param1.currentTarget && Boolean(param1.currentTarget.parent))
         {
            _loc2_ = param1.currentTarget.parent as MutationItemRenderer;
         }
         if(_loc2_)
         {
            _loc3_ = new ListEvent(ListEvent.ITEM_DOUBLE_CLICK,true);
            _loc3_.itemData = _loc2_.data as Object;
            _loc3_.index = _loc2_.index;
            _loc3_.itemRenderer = _loc2_;
            dispatchEvent(_loc3_);
         }
      }
      
      override protected function rendererNameSorter(param1:IBaseSlot, param2:IBaseSlot) : Number
      {
         var _loc3_:MutationItemRenderer = param1 as MutationItemRenderer;
         var _loc4_:MutationItemRenderer = param2 as MutationItemRenderer;
         return _loc3_.slotNavigationId < _loc4_.slotNavigationId ? -1 : 1;
      }
      
      override protected function initRenderers() : void
      {
         var i:int;
         var curRenderer:SlotBase = null;
         var targetContainer:DisplayObjectContainer = _internalRenderers ? this : this.parent;
         var childrenCount:int = targetContainer.numChildren;
         _renderersCount = 0;
         while(_renderers.length)
         {
            cleanUpRenderer(_renderers.pop());
         }
         i = 0;
         while(i < childrenCount)
         {
            curRenderer = targetContainer.getChildAt(i) as SlotBase;
            if(Boolean(curRenderer) && Boolean(curRenderer) && curRenderer.name.indexOf(_slotRenderer) > -1)
            {
               _renderers.push(curRenderer);
               curRenderer.index = _renderersCount;
               this.setupRenderer(curRenderer);
               ++_renderersCount;
            }
            i++;
         }
         if(sortData)
         {
            _renderers.sort(this.rendererNameSorter);
         }
         _renderers.forEach(function(param1:SlotBase, param2:int, param3:Vector.<IBaseSlot>):*
         {
            param1.index = _renderers.indexOf(param1);
         });
      }
   }
}
