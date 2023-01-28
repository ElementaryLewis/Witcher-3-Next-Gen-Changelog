package red.game.witcher3.menus.gwint
{
   import scaleform.clik.core.UIComponent;
   
   public class CardFX extends UIComponent
   {
       
      
      public var instanceID:int;
      
      public var associatedCardInstance:CardInstance;
      
      public var finalFinishCallback:Function;
      
      public var cardFXManagerFinishCallback:Function;
      
      public var midFXPointCallback:Function;
      
      protected var _onCard:Boolean = true;
      
      public function CardFX()
      {
         super();
      }
      
      public function get onCard() : Boolean
      {
         return this._onCard;
      }
      
      public function set onCard(value:Boolean) : void
      {
         this._onCard = value;
      }
      
      public function playFX() : void
      {
         gotoAndPlay("play");
      }
      
      public function fxEnded() : void
      {
         if(this.cardFXManagerFinishCallback != null)
         {
            this.cardFXManagerFinishCallback(this);
         }
      }
      
      public function midFXPoint() : void
      {
         if(this.midFXPointCallback != null)
         {
            this.midFXPointCallback(this.associatedCardInstance);
         }
      }
   }
}
