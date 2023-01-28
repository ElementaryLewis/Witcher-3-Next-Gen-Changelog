package red.game.witcher3.controls
{
   import flash.events.Event;
   import flash.utils.getDefinitionByName;
   import scaleform.clik.controls.ScrollIndicator;
   
   public class W3ScrollingCategorizedList extends W3ScrollingList
   {
       
      
      internal var categoriesNr:int = 0;
      
      internal var m_currentListHeight:Number;
      
      protected var CategoriesItems:Vector.<W3Label>;
      
      private var _LabelClass:String;
      
      private var _CategoryOffsetY:Number;
      
      public function W3ScrollingCategorizedList()
      {
         super();
         this.CategoriesItems = new Vector.<W3Label>();
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         stage.addEventListener(W3ScrollingList.REPOSITION,this.updatePosition,false,0,false);
      }
      
      public function get LabelClass() : String
      {
         return this._LabelClass;
      }
      
      public function set LabelClass(param1:String) : void
      {
         this._LabelClass = param1;
      }
      
      public function get CategoryOffsetY() : Number
      {
         return this._CategoryOffsetY;
      }
      
      public function set CategoryOffsetY(param1:Number) : void
      {
         this._CategoryOffsetY = param1;
      }
      
      override protected function updateScrollBar() : void
      {
         var _loc2_:ScrollIndicator = null;
         if(_scrollBar == null)
         {
            return;
         }
         if(_dataProvider.length <= _totalRenderers)
         {
            scrollBar.visible = false;
         }
         else
         {
            scrollBar.visible = true;
         }
         var _loc1_:Number = Math.max(0,_dataProvider.length - _totalRenderers);
         if(_scrollBar is ScrollIndicator)
         {
            _loc2_ = _scrollBar as ScrollIndicator;
            _loc2_.setScrollProperties(_totalRenderers,0,_dataProvider.length - _totalRenderers);
         }
         _scrollBar.position = _scrollPosition;
         _scrollBar.validateNow();
      }
      
      public function updatePosition(param1:Event) : *
      {
         var _loc2_:BaseListItem = null;
         var _loc5_:int = 0;
         if(!this.CategoriesItems || !dataProvider)
         {
            return;
         }
         var _loc3_:Number = this.y;
         var _loc4_:String = "";
         _loc5_ = 0;
         while(_loc5_ < this.CategoriesItems.length)
         {
            this.CategoriesItems[_loc5_].visible = false;
            _loc5_++;
         }
         _loc5_ = 0;
         while(_loc5_ < dataProvider.length)
         {
            _loc2_ = getRendererAt(_loc5_) as BaseListItem;
            if(_loc2_)
            {
               if(_loc2_.data.category != _loc4_)
               {
                  _loc4_ = String(_loc2_.data.category);
                  _loc3_ = this.updateCategoryPosition(_loc4_,_loc3_);
               }
               _loc2_.y = _loc3_;
               _loc3_ += _loc2_.height;
            }
            _loc5_++;
         }
         if(_loc2_)
         {
            _loc3_ += _loc2_.height;
         }
      }
      
      private function updateCategoryPosition(param1:String, param2:Number) : Number
      {
         var _loc3_:Number = NaN;
         var _loc4_:int = 0;
         var _loc5_:W3Label = null;
         _loc3_ = param2;
         if(param1 == " " || param1 == "" || param1 == "# " || param1 == "#")
         {
            return _loc3_;
         }
         _loc4_ = 0;
         while(_loc4_ < this.CategoriesItems.length)
         {
            if(this.CategoriesItems[_loc4_].htmlText == param1)
            {
               this.CategoriesItems[_loc4_].y = param2 + this._CategoryOffsetY;
               this.CategoriesItems[_loc4_].visible = true;
               _loc3_ += this.CategoriesItems[_loc4_].height;
               return _loc3_ + this._CategoryOffsetY + this._CategoryOffsetY;
            }
            _loc4_++;
         }
         var _loc6_:Class;
         if((_loc6_ = getDefinitionByName(this.LabelClass) as Class) != null)
         {
            (_loc5_ = new _loc6_() as W3Label).x = this.x;
            _loc5_.y = param2 + this._CategoryOffsetY;
            _loc5_.htmlText = param1.toUpperCase();
            parent.addChild(_loc5_);
            this.CategoriesItems.push(_loc5_);
            _loc3_ += _loc5_.height + this._CategoryOffsetY + this._CategoryOffsetY;
         }
         return _loc3_;
      }
      
      override public function toString() : String
      {
         return "[W3 W3ScrollingCategorizedList " + this.name + " ]";
      }
      
      override protected function populateData(param1:Array) : void
      {
         super.populateData(param1);
         stage.dispatchEvent(new Event(W3ScrollingList.REPOSITION));
      }
   }
}
