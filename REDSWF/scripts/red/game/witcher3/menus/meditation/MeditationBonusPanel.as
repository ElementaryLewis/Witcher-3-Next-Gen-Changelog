package red.game.witcher3.menus.meditation
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   import flash.utils.getDefinitionByName;
   import scaleform.clik.core.UIComponent;
   
   public class MeditationBonusPanel extends UIComponent
   {
      
      private static const ITEM_RDR_REF:String = "MeditationBonusItemRendererRef";
       
      
      public var tfTitle:TextField;
      
      public var mcListAnchor:MovieClip;
      
      private var _data:Array;
      
      private var _active:Boolean;
      
      private var _renderers:Vector.<MeditationBonusItemRenderer>;
      
      public function MeditationBonusPanel()
      {
         super();
         visible = false;
         this.tfTitle.text = "[[panel_title_buff_sleep]]";
         this._renderers = new Vector.<MeditationBonusItemRenderer>();
      }
      
      public function get data() : Array
      {
         return this._data;
      }
      
      public function set data(param1:Array) : void
      {
         this._data = param1;
         this.populateData();
      }
      
      public function get active() : Boolean
      {
         return this._active;
      }
      
      public function set active(param1:Boolean) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(this._active != param1)
         {
            this._active = param1;
            _loc2_ = int(this._renderers.length);
            _loc3_ = 0;
            while(_loc3_ < _loc2_)
            {
               this._renderers[_loc3_].activate = this._active;
               _loc3_++;
            }
         }
      }
      
      private function populateData() : void
      {
         var _loc1_:Class = null;
         var _loc2_:int = 0;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:int = 0;
         var _loc6_:MeditationBonusItemRenderer = null;
         while(this._renderers.length)
         {
            removeChild(this._renderers.pop());
         }
         if(this._data)
         {
            _loc1_ = getDefinitionByName(ITEM_RDR_REF) as Class;
            _loc2_ = int(this._data.length);
            _loc3_ = this.mcListAnchor.x;
            _loc4_ = this.mcListAnchor.y;
            _loc5_ = 0;
            while(_loc5_ < _loc2_)
            {
               (_loc6_ = new _loc1_() as MeditationBonusItemRenderer).data = this._data[_loc5_];
               _loc6_.activate = this._active;
               _loc6_.x = _loc3_;
               _loc6_.y = _loc4_;
               addChild(_loc6_);
               _loc4_ += _loc6_.actualHeight;
               this._renderers.push(_loc6_);
               _loc5_++;
            }
            visible = true;
         }
         else
         {
            visible = false;
         }
      }
   }
}
