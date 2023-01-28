package red.game.witcher3.menus.noticeboard
{
   import flash.display.MovieClip;
   import red.game.witcher3.slots.SlotBase;
   
   public class NoticeboardListItem extends SlotBase
   {
       
      
      internal var mcErrand:MovieClip;
      
      internal var destinationErrandOutlook:int = 2;
      
      public function NoticeboardListItem()
      {
         super();
         INDICATE_ANIM_DURATION = 0.7;
      }
      
      override protected function configUI() : void
      {
         super.configUI();
      }
      
      override public function set data(param1:*) : void
      {
         super.data = param1;
         if(!this.mcErrand)
         {
            this.mcErrand = this.getChildByName("mcErrand") as MovieClip;
         }
         if(data)
         {
            if(data.tag == "")
            {
               selectable = false;
               enabled = false;
               this.visible = false;
               return;
            }
            selectable = true;
            enabled = true;
            this.visible = true;
            this.x += data.posX;
            this.y += data.posY;
            if(data.isFluff)
            {
               this.destinationErrandOutlook = index % 3 + 9;
               if(this.mcErrand)
               {
                  this.mcErrand.gotoAndStop(this.destinationErrandOutlook);
                  mcStateSelectedActive.gotoAndStop(this.destinationErrandOutlook);
               }
               return;
            }
            this.destinationErrandOutlook = index + 1;
            if(this.mcErrand)
            {
               this.mcErrand.gotoAndStop(this.destinationErrandOutlook);
               mcStateSelectedActive.gotoAndStop(this.destinationErrandOutlook);
            }
         }
         else
         {
            selectable = false;
            enabled = false;
            this.visible = false;
         }
      }
      
      override public function set visible(param1:Boolean) : void
      {
         super.visible = param1;
         if(!data)
         {
         }
      }
   }
}
