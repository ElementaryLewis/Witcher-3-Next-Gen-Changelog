package red.game.witcher3.menus.glossary
{
   import com.gskinner.motion.GTweener;
   import com.gskinner.motion.easing.Exponential;
   import red.core.events.GameEvent;
   import red.game.witcher3.controls.W3UILoader;
   import scaleform.clik.core.UIComponent;
   
   public class GlossaryTextureSubListModule extends UIComponent
   {
       
      
      public var mcLoader:W3UILoader;
      
      public var dataBindingKey:String = "glossary.characters.sublist";
      
      public var imagePathPrefix:String = "img://textures/journal/characters/";
      
      protected var DATA_UPDATE_ALPHA_ANIMATION_TIME:Number = 3;
      
      public function GlossaryTextureSubListModule()
      {
         super();
      }
      
      override protected function configUI() : void
      {
         dispatchEvent(new GameEvent(GameEvent.REGISTER,this.dataBindingKey + ".image",[this.handleSetImage]));
         super.configUI();
      }
      
      override public function toString() : String
      {
         return "[W3 GlossaryTextureSubListModule]";
      }
      
      public function handleSetImage(param1:String) : void
      {
         this.mcLoader.source = this.imagePathPrefix + param1;
         this.alpha = 0;
         GTweener.to(this,this.DATA_UPDATE_ALPHA_ANIMATION_TIME,{"alpha":1},{"ease":Exponential.easeOut});
      }
      
      public function setImage(param1:String) : void
      {
         this.mcLoader.source = param1;
         this.alpha = 0;
         GTweener.to(this,this.DATA_UPDATE_ALPHA_ANIMATION_TIME,{"alpha":1},{"ease":Exponential.easeOut});
      }
   }
}
