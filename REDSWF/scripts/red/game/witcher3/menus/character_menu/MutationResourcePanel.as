package red.game.witcher3.menus.character_menu
{
   import flash.text.TextField;
   import red.core.CoreComponent;
   import red.game.witcher3.utils.CommonUtils;
   import scaleform.clik.core.UIComponent;
   
   public class MutationResourcePanel extends UIComponent
   {
       
      
      public var tfTitle:TextField;
      
      public var mcRenderer1:MutationResourceInfo;
      
      public var mcRenderer2:MutationResourceInfo;
      
      public var mcRenderer3:MutationResourceInfo;
      
      public var mcRenderer4:MutationResourceInfo;
      
      private var _renderers:Vector.<MutationResourceInfo>;
      
      private var _data:Array;
      
      private var _textValue:String;
      
      public function MutationResourcePanel()
      {
         super();
         this._renderers = new Vector.<MutationResourceInfo>();
         this._renderers.push(this.mcRenderer1);
         this._renderers.push(this.mcRenderer2);
         this._renderers.push(this.mcRenderer3);
         this._renderers.push(this.mcRenderer4);
      }
      
      public function get data() : Array
      {
         return this._data;
      }
      
      public function set data(param1:Array) : void
      {
         this._data = param1;
         this.populate();
      }
      
      public function getListHeight() : Number
      {
         if(this.mcRenderer3.visible)
         {
            return this.mcRenderer3.y + this.mcRenderer3.actualHeight;
         }
         if(this.mcRenderer1.visible)
         {
            return this.mcRenderer1.y + this.mcRenderer1.actualHeight;
         }
         return 0;
      }
      
      public function playFeedbackAnim() : void
      {
         var _loc1_:MutationResourceInfo = null;
         for each(_loc1_ in this._renderers)
         {
            _loc1_.playFeedbackAnim();
         }
      }
      
      protected function populate() : void
      {
         var _loc5_:Object = null;
         var _loc6_:MutationResourceInfo = null;
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = !!this._data ? int(this._data.length) : 0;
         var _loc4_:int = int(this._renderers.length);
         this.tfTitle.text = "[[panel_crafting_ingredients_start]]";
         this._textValue = this.tfTitle.text;
         if(CoreComponent.isArabicAligmentMode)
         {
            this.tfTitle.htmlText = "<p align=\"right\">" + this._textValue + "</p>";
         }
         else
         {
            this.tfTitle.htmlText = CommonUtils.toUpperCaseSafe(this._textValue);
         }
         while(_loc1_ < _loc3_ && _loc2_ < _loc4_)
         {
            if((Boolean(_loc5_ = this._data[_loc1_])) && _loc5_.required > 0)
            {
               (_loc6_ = this._renderers[_loc2_]).visible = true;
               _loc6_.data = _loc5_;
               _loc2_++;
            }
            _loc1_++;
         }
         while(_loc2_ < _loc4_)
         {
            this._renderers[_loc2_].visible = false;
            _loc2_++;
         }
      }
   }
}
