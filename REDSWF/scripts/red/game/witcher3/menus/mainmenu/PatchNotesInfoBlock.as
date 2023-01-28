package red.game.witcher3.menus.mainmenu
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   import scaleform.clik.core.UIComponent;
   
   public class PatchNotesInfoBlock extends UIComponent
   {
       
      
      public var mcTitle:TextField;
      
      public var mcDescription:TextField;
      
      public var mcIcon:MovieClip;
      
      public var mcBackground:MovieClip;
      
      public function PatchNotesInfoBlock()
      {
         super();
      }
      
      override protected function configUI() : void
      {
         super.configUI();
      }
      
      public function setData(param1:String) : *
      {
         this.mcIcon.gotoAndStop(param1);
         switch(param1)
         {
            case "graphical_modes_xss":
               this.mcTitle.text = "[[nge_info_title_graphical_modes]]";
               this.mcDescription.text = "[[nge_info_description_graphical_modes_xss]]";
            case "graphical_modes":
               this.mcTitle.text = "[[nge_info_title_graphical_modes]]";
               this.mcDescription.text = "[[nge_info_description_graphical_modes_xss]]";
               break;
            case "new_content":
               this.mcTitle.text = "[[nge_info_title_new_content]]";
               this.mcDescription.text = "[[nge_info_description_new_content]]";
               break;
            case "photo_mode":
               this.mcTitle.text = "[[nge_info_title_photo_mode]]";
               this.mcDescription.text = "[[nge_info_description_photo_mode]]";
               break;
            case "cross_progression":
               this.mcTitle.text = "[[nge_info_title_cross_progression]]";
               this.mcDescription.text = "[[nge_info_description_cross_progression]]";
               break;
            case "mods":
               this.mcTitle.text = "[[nge_info_title_mods]]";
               this.mcDescription.text = "[[nge_info_description_mods]]";
               break;
            case "controls":
               this.mcTitle.text = "[[nge_info_title_controls]]";
               this.mcDescription.text = "[[nge_info_description_controls]]";
         }
         this.realignControls();
      }
      
      private function realignControls() : *
      {
         var _loc1_:Number = 10;
         var _loc2_:Number = (this.mcBackground.width - (this.mcIcon.width + this.mcTitle.textWidth + _loc1_)) / 2;
         this.mcIcon.x = _loc2_;
         this.mcTitle.x = this.mcIcon.x + this.mcIcon.width + _loc1_;
      }
   }
}
