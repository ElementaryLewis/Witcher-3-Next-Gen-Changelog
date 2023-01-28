package red.game.witcher3.slots
{
   import flash.display.DisplayObjectContainer;
   import flash.utils.getDefinitionByName;
   import flash.utils.getQualifiedClassName;
   import red.game.witcher3.interfaces.IBaseSlot;
   import scaleform.clik.core.UIComponent;
   
   public class SlotsListPreset extends SlotsListBase
   {
       
      
      protected var _rendererClassName:String;
      
      protected var _rendererClass:Class;
      
      protected var _internalRenderers:Boolean;
      
      public var sortData:Boolean = false;
      
      public function SlotsListPreset()
      {
         super();
      }
      
      public function get internalRenderers() : Boolean
      {
         return this._internalRenderers;
      }
      
      public function set internalRenderers(param1:Boolean) : void
      {
         this._internalRenderers = param1;
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         this.initRenderers();
         selectedIndex = 0;
      }
      
      override protected function populateData() : void
      {
         var _loc1_:int = 0;
         this.cleanupRenderers();
         _loc1_ = 0;
         while(_loc1_ < data.length && _loc1_ < _renderers.length)
         {
            _renderers[_loc1_].data = data[_loc1_];
            _renderers[_loc1_].validateNow();
            _loc1_++;
         }
         while(_loc1_ < _renderers.length)
         {
            _renderers[_loc1_].data = null;
            _loc1_++;
         }
         super.populateData();
         findSelection();
      }
      
      protected function cleanupRenderers() : void
      {
         var _loc1_:int = int(_renderers.length);
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_)
         {
            _renderers[_loc2_].cleanup();
            _loc2_++;
         }
      }
      
      protected function getSlotsContainer() : DisplayObjectContainer
      {
         return this._internalRenderers ? this : this.parent;
      }
      
      protected function initRenderers() : void
      {
         var i:int;
         var childrenCount:int = 0;
         var rendererClasRef:Class = null;
         var curRenderer:IBaseSlot = null;
         var isClassCorrected:Boolean = false;
         var targetContainer:DisplayObjectContainer = this.getSlotsContainer();
         if(!targetContainer)
         {
            return;
         }
         childrenCount = targetContainer.numChildren;
         if(_slotRenderer)
         {
            rendererClasRef = getDefinitionByName(_slotRenderer) as Class;
         }
         _renderersCount = 0;
         while(_renderers.length)
         {
            cleanUpRenderer(_renderers.pop());
         }
         i = 0;
         while(i < childrenCount)
         {
            curRenderer = targetContainer.getChildAt(i) as IBaseSlot;
            isClassCorrected = !_slotRenderer || (curRenderer is rendererClasRef || getQualifiedClassName(curRenderer) == _slotRenderer);
            if(Boolean(curRenderer) && isClassCorrected)
            {
               _renderers.push(curRenderer);
               curRenderer.index = _renderersCount;
               setupRenderer(curRenderer);
               ++_renderersCount;
            }
            i++;
         }
         if(this.sortData)
         {
            _renderers.sort(this.rendererNameSorter);
         }
         _renderers.forEach(function(param1:SlotBase, param2:int, param3:Vector.<IBaseSlot>):*
         {
            param1.index = _renderers.indexOf(param1);
         },null);
      }
      
      protected function rendererNameSorter(param1:IBaseSlot, param2:IBaseSlot) : Number
      {
         var _loc3_:UIComponent = param1 as UIComponent;
         var _loc4_:UIComponent = param2 as UIComponent;
         return _loc3_.name < _loc4_.name ? -1 : 1;
      }
   }
}
