package red.game.witcher3.controls
{
   import flash.display.MovieClip;
   import scaleform.clik.core.UIComponent;
   
   public class W3MessageQueue extends UIComponent
   {
       
      
      public var mcBackground:MovieClip;
      
      public var mcImages:MovieClip;
      
      public var txtMessage:W3TextArea;
      
      public var _showingMessage:Boolean = false;
      
      private var messageQueue:Array;
      
      private var currentOnShowEndFunc:Function = null;
      
      private var _msgsEnabled:Boolean = true;
      
      public function W3MessageQueue()
      {
         super();
         this.messageQueue = new Array();
         mouseEnabled = false;
         mouseChildren = false;
      }
      
      public function get msgsEnabled() : Boolean
      {
         return this._msgsEnabled;
      }
      
      public function set msgsEnabled(value:Boolean) : void
      {
         if(this._msgsEnabled != value)
         {
            this._msgsEnabled = value;
            if(this._msgsEnabled)
            {
               this.tryShowMessage();
            }
         }
      }
      
      public function PushMessage(message:String, imageName:String = "", onShowFunc:Function = null, onShowEndFunc:Function = null) : void
      {
         var showingMessage:Boolean = this.ShowingMessage();
         var messageObject:Object = new Object();
         messageObject.message = message;
         if(imageName == "")
         {
            messageObject.imageName = "none";
         }
         else
         {
            messageObject.imageName = imageName;
         }
         messageObject.onShowFunc = onShowFunc;
         messageObject.onShowEndFunc = onShowEndFunc;
         this.messageQueue.push(messageObject);
         if(!showingMessage)
         {
            this.tryShowMessage();
         }
      }
      
      public function ShowingMessage() : Boolean
      {
         return this._showingMessage || this.messageQueue.length > 0;
      }
      
      public function OnShowMessageEnded() : void
      {
         this._showingMessage = false;
         if(this.currentOnShowEndFunc != null)
         {
            this.currentOnShowEndFunc();
            this.currentOnShowEndFunc = null;
         }
         this.tryShowMessage();
      }
      
      protected function tryShowMessage() : void
      {
         var currentMessage:Object = null;
         if(!this.msgsEnabled)
         {
            return;
         }
         if(this.messageQueue.length > 0 && !this._showingMessage)
         {
            currentMessage = this.messageQueue[0];
            this.txtMessage.text = currentMessage.message;
            if(this.mcImages)
            {
               this.mcImages.gotoAndStop(currentMessage.imageName);
            }
            this.txtMessage.validateNow();
            if(currentMessage.onShowFunc)
            {
               currentMessage.onShowFunc();
            }
            this.currentOnShowEndFunc = currentMessage.onShowEndFunc;
            gotoAndPlay("Show");
            this.messageQueue.splice(0,1);
            this._showingMessage = true;
         }
      }
      
      public function trySkipMessage() : Boolean
      {
         if(this._showingMessage && currentLabel == "Showing")
         {
            gotoAndPlay("Hiding");
            return true;
         }
         return false;
      }
   }
}
