package red.game.witcher3.menus.character_menu
{
   import flash.text.TextField;
   import scaleform.clik.core.UIComponent;
   
   public class SkillsGroupTitle extends UIComponent
   {
       
      
      public var textField:TextField;
      
      protected var _skillGroup:String;
      
      protected var _title:String;
      
      protected var _colorMap:Object;
      
      public function SkillsGroupTitle()
      {
         this._colorMap = {
            "ESP_Sword":14548991,
            "ESP_Signs":16765889,
            "ESP_Alchemy":12451839
         };
         super();
      }
      
      public function get skillGroup() : String
      {
         return this._skillGroup;
      }
      
      public function set skillGroup(param1:String) : void
      {
         if(param1)
         {
            this._skillGroup = param1;
            gotoAndStop(this._skillGroup);
            this.textField.textColor = this._colorMap[this._skillGroup];
         }
      }
      
      public function get title() : String
      {
         return this._title;
      }
      
      public function set title(param1:String) : void
      {
         this._title = param1;
         this.textField.htmlText = this._title;
      }
   }
}
