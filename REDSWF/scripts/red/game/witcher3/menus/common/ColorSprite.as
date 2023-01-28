package red.game.witcher3.menus.common
{
   import flash.display.MovieClip;
   import scaleform.clik.core.UIComponent;
   
   public class ColorSprite extends UIComponent
   {
      
      public static const COLOR_NONE:String = "none";
      
      public static const COLOR_YELLOW:String = "red";
      
      public static const COLOR_GREEN:String = "green";
      
      public static const COLOR_BLUE:String = "blue";
      
      public static const COLOR_ORANGE:String = "orange";
       
      
      public var mcColorBlind:MovieClip;
      
      public var mcColor:MovieClip;
      
      protected var _colorBlind:Boolean;
      
      protected var _color:String;
      
      public function ColorSprite()
      {
         super();
         this.mcColorBlind.visible = false;
      }
      
      public function get colorBlind() : Boolean
      {
         return this._colorBlind;
      }
      
      public function set colorBlind(param1:Boolean) : void
      {
         this._colorBlind = param1;
         this.mcColorBlind.visible = this._colorBlind;
      }
      
      public function get color() : String
      {
         return this._color;
      }
      
      public function set color(param1:String) : void
      {
         this._color = param1;
         this.updateColor();
      }
      
      protected function updateColor() : void
      {
         if(this._color)
         {
            this.mcColorBlind.gotoAndStop(this._color);
            this.mcColor.gotoAndStop(this._color);
         }
      }
      
      public function setByItemQuality(param1:int) : void
      {
         switch(param1)
         {
            case 0:
            case 1:
               this.color = COLOR_NONE;
               break;
            case 2:
               this.color = COLOR_BLUE;
               break;
            case 3:
               this.color = COLOR_YELLOW;
               break;
            case 4:
               this.color = COLOR_ORANGE;
               break;
            case 5:
               this.color = COLOR_GREEN;
         }
      }
      
      public function setBySkillType(param1:String) : void
      {
         switch(param1)
         {
            case "SC_None":
               this.color = COLOR_NONE;
               break;
            case "SC_Blue":
               this.color = COLOR_BLUE;
               break;
            case "SC_Green":
               this.color = COLOR_GREEN;
               break;
            case "SC_Yellow":
               this.color = COLOR_YELLOW;
               break;
            case "SC_Red":
               this.color = COLOR_ORANGE;
         }
      }
      
      override public function toString() : String
      {
         return "ColorSprite [" + this.name + "]";
      }
   }
}
