package red.game.witcher3.menus.character_menu
{
   import scaleform.clik.core.UIComponent;
   
   public class MutationConnector extends UIComponent
   {
       
      
      private var _mutationRendererName:String;
      
      private var _color:String;
      
      public function MutationConnector()
      {
         super();
      }
      
      public function get mutationRendererName() : String
      {
         return this._mutationRendererName;
      }
      
      public function set mutationRendererName(param1:String) : void
      {
         var _loc2_:MutationItemRenderer = null;
         this._mutationRendererName = param1;
         if(parent)
         {
            _loc2_ = parent.getChildByName(this._mutationRendererName) as MutationItemRenderer;
            if(_loc2_)
            {
               _loc2_.addConnector(this);
            }
         }
      }
      
      public function get color() : String
      {
         return this._color;
      }
      
      public function set color(param1:String) : void
      {
         this._color = param1;
         gotoAndStop(this._color);
      }
   }
}
