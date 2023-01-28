package red.game.witcher3.controls
{
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.text.TextField;
   import flash.text.TextFormatAlign;
   import flash.utils.getDefinitionByName;
   import red.game.witcher3.tooltips.TooltipStatRenderer;
   import scaleform.clik.constants.InvalidationType;
   import scaleform.clik.core.UIComponent;
   import scaleform.clik.interfaces.IListItemRenderer;
   
   public class RenderersList extends UIComponent
   {
       
      
      protected var _itemRendererName:String;
      
      protected var _dataList:Array;
      
      protected var _itemPadding:Number;
      
      protected var _isHorizontal:Boolean;
      
      protected var _alignment:String;
      
      protected var _straightenColumn:Boolean;
      
      protected var _itemRendererRef:Class;
      
      protected var _renderers:Vector.<IListItemRenderer>;
      
      protected var _canvas:Sprite;
      
      public var _thisWidth:Number;
      
      public function RenderersList()
      {
         this._renderers = new Vector.<IListItemRenderer>();
         super();
         this._dataList = [];
         this._canvas = new Sprite();
         addChild(this._canvas);
      }
      
      public function get straightenColumn() : Boolean
      {
         return this._straightenColumn;
      }
      
      public function set straightenColumn(param1:Boolean) : void
      {
         this._straightenColumn = param1;
         invalidateData();
      }
      
      public function get alignment() : String
      {
         return this._alignment;
      }
      
      public function set alignment(param1:String) : void
      {
         this._alignment = param1;
         invalidateData();
      }
      
      public function get isHorizontal() : Boolean
      {
         return this._isHorizontal;
      }
      
      public function set isHorizontal(param1:Boolean) : void
      {
         this._isHorizontal = param1;
         invalidateData();
      }
      
      public function get itemRendererName() : String
      {
         return this._itemRendererName;
      }
      
      public function set itemRendererName(param1:String) : void
      {
         var _loc2_:Class = getDefinitionByName(param1) as Class;
         if(_loc2_ != null)
         {
            this._itemRendererName = param1;
            this._itemRendererRef = _loc2_;
            invalidateData();
         }
      }
      
      public function get itemPadding() : Number
      {
         return this._itemPadding;
      }
      
      public function set itemPadding(param1:Number) : void
      {
         this._itemPadding = param1;
         invalidateData();
      }
      
      public function get dataList() : Array
      {
         return this._dataList;
      }
      
      public function set dataList(param1:Array) : void
      {
         while(this._renderers.length)
         {
            this._canvas.removeChild(this._renderers.pop());
         }
         if(param1)
         {
            this._dataList = param1;
            invalidateData();
         }
      }
      
      public function getRenderersCount() : int
      {
         return this._renderers.length;
      }
      
      override protected function draw() : void
      {
         super.draw();
         if(isInvalid(InvalidationType.DATA))
         {
            this.populateData();
         }
      }
      
      protected function populateData() : void
      {
         var _loc6_:IListItemRenderer = null;
         var _loc7_:Object = null;
         var _loc8_:TooltipStatRenderer = null;
         var _loc9_:BaseListItem = null;
         var _loc10_:BaseListItem = null;
         var _loc11_:TextField = null;
         var _loc12_:int = 0;
         var _loc13_:int = 0;
         var _loc14_:int = 0;
         var _loc1_:Number = 0;
         var _loc2_:Number = 0;
         var _loc3_:Number = 0;
         var _loc4_:Number = 0;
         var _loc5_:Number = 0;
         while(this._renderers.length)
         {
            this._canvas.removeChild(this._renderers.pop());
         }
         for each(_loc7_ in this._dataList)
         {
            (_loc6_ = new this._itemRendererRef() as IListItemRenderer).setData(_loc7_);
            this._canvas.addChild(_loc6_ as DisplayObject);
            _loc6_.validateNow();
            if(_loc9_ = _loc6_ as BaseListItem)
            {
               _loc1_ = _loc9_.getRendererWidth();
               _loc2_ = _loc9_.getRendererHeight();
            }
            else
            {
               _loc1_ = Number(_loc6_.width);
               _loc2_ = Number(_loc6_.height);
            }
            if(this._isHorizontal)
            {
               _loc6_.x = _loc3_;
               _loc3_ += _loc1_ + this._itemPadding;
            }
            else
            {
               _loc10_ = _loc6_ as BaseListItem;
               if(this._alignment == TextFormatAlign.CENTER)
               {
                  _loc6_.x = -_loc6_.width / 2;
               }
               else if(this._alignment == TextFormatAlign.RIGHT)
               {
                  _loc6_.x = !!_loc10_ ? -_loc10_.getRendererWidth() : -_loc6_.width;
               }
               else
               {
                  _loc6_.x = 0;
               }
               if(_loc8_ = _loc6_ as TooltipStatRenderer)
               {
                  if((Boolean(_loc11_ = _loc8_.tfStatValue)) && _loc11_.textWidth > _loc5_)
                  {
                     _loc5_ = _loc11_.x + _loc11_.textWidth;
                  }
               }
               _loc6_.y = _loc4_;
               _loc4_ += _loc2_ + this._itemPadding;
            }
            this._renderers.push(_loc6_);
         }
         this._thisWidth = this._canvas.width;
         if(!this._isHorizontal && this._straightenColumn)
         {
            _loc12_ = int(this._renderers.length);
            _loc13_ = 0;
            while(_loc13_ < _loc12_)
            {
               if(_loc8_ = this._renderers[_loc13_] as TooltipStatRenderer)
               {
                  _loc8_.columnPadding = _loc5_;
               }
               _loc13_++;
            }
            _loc4_ = 0;
            _loc14_ = 0;
            while(_loc14_ < _loc12_)
            {
               if(_loc6_ = this._renderers[_loc14_])
               {
                  _loc6_.y = _loc4_;
                  _loc4_ += _loc6_.height + this._itemPadding;
               }
               _loc14_++;
            }
         }
      }
   }
}
