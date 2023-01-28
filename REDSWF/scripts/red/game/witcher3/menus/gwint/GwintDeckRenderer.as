package red.game.witcher3.menus.gwint
{
   import flash.display.MovieClip;
   import red.game.witcher3.controls.W3TextArea;
   import scaleform.clik.core.UIComponent;
   
   public class GwintDeckRenderer extends UIComponent
   {
       
      
      public var mcCardCount:MovieClip;
      
      public var mcDeckTop:MovieClip;
      
      private var _cardCount:int = 0;
      
      public function GwintDeckRenderer()
      {
         super();
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         this._cardCount = 0;
      }
      
      public function set cardCount(value:int) : void
      {
         this._cardCount = value;
         if(this._cardCount == 0)
         {
            this.gotoAndStop(1);
            this.mcDeckTop.visible = false;
         }
         else
         {
            this.gotoAndStop(Math.min(50,this._cardCount));
            this.mcDeckTop.visible = true;
         }
         var countW3Text:W3TextArea = !!this.mcCardCount ? this.mcCardCount.getChildByName("txtCount") as W3TextArea : null;
         if(countW3Text)
         {
            countW3Text.text = this._cardCount.toString();
         }
      }
      
      public function set factionString(value:String) : void
      {
         this.mcDeckTop.gotoAndStop(value);
      }
   }
}
