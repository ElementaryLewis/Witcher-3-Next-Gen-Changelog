package red.game.witcher3.menus.worldmap
{
   import flash.display.Sprite;
   import flash.text.TextField;
   import scaleform.clik.core.UIComponent;
   
   public class CurrentQuestMapHint extends UIComponent
   {
       
      
      protected const COLLAPSED_SIZE:Number = 52;
      
      protected const EXTENDED_SIZE:Number = 74;
      
      public var tfTitle:TextField;
      
      public var tfQuest:TextField;
      
      public var mcBackground:Sprite;
      
      protected var _data:Object;
      
      public function CurrentQuestMapHint()
      {
         super();
         this.tfQuest.visible = false;
      }
      
      public function get data() : Object
      {
         return this._data;
      }
      
      public function set data(param1:Object) : void
      {
         this._data = param1;
         this.tfQuest.htmlText = param1.questName;
         this.tfQuest.visible = true;
      }
   }
}
