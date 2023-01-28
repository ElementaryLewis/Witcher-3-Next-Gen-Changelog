package witcher3.views.hud
{
   import flash.text.TextField;
   import scaleform.clik.core.UIComponent;
   import witcher3.game.GameInterface;
   
   public class SubtitlesView extends UIComponent
   {
       
      
      public var tfSubtitles:TextField;
      
      private var _currentId:int = 0;
      
      public function SubtitlesView()
      {
         super();
         GameInterface.initialize();
         this.tfSubtitles.htmlText = "";
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         GameInterface.sendDisplayObject(this,"SubtitlesView");
      }
      
      public function addSubtitle(param1:int, param2:String, param3:String) : *
      {
         this.tfSubtitles.htmlText = "<b><font color=\'#ffff00\'>" + param2 + "</font></b>: " + param3;
         this._currentId = param1;
      }
      
      public function removeSubtitle(param1:int) : void
      {
         if(param1 == this._currentId)
         {
            this.tfSubtitles.htmlText = "";
            this._currentId = 0;
         }
      }
   }
}
