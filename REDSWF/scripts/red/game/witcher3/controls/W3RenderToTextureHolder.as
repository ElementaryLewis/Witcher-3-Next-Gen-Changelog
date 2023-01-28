package red.game.witcher3.controls
{
   import flash.display.MovieClip;
   import red.core.events.GameEvent;
   import scaleform.clik.core.UIComponent;
   
   public class W3RenderToTextureHolder extends UIComponent
   {
       
      
      public var mcLoadingAnim:MovieClip;
      
      public var mcTextureHolder:MovieClip;
      
      public function W3RenderToTextureHolder()
      {
         super();
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         this.setRenderToTextureLoading(false);
         dispatchEvent(new GameEvent(GameEvent.REGISTER,"render.to.texture.loading",[this.setRenderToTextureLoading]));
         dispatchEvent(new GameEvent(GameEvent.REGISTER,"render.to.texture.texture.visible",[this.setRenderToTextureTextureVisible]));
      }
      
      protected function setRenderToTextureLoading(value:Boolean) : void
      {
         if(this.mcLoadingAnim)
         {
            if(value)
            {
               this.mcLoadingAnim.visible = true;
               this.mcLoadingAnim.gotoAndPlay("startAnim");
            }
            else
            {
               this.mcLoadingAnim.stop();
               this.mcLoadingAnim.visible = false;
            }
         }
      }
      
      protected function setRenderToTextureTextureVisible(value:Boolean) : void
      {
         if(this.mcTextureHolder)
         {
            this.mcTextureHolder.visible = value;
         }
      }
   }
}
