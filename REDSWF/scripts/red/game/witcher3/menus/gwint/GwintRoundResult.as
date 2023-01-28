package red.game.witcher3.menus.gwint
{
   internal class GwintRoundResult
   {
       
      
      private var roundScores:Vector.<int>;
      
      private var roundWinner:int;
      
      public function GwintRoundResult()
      {
         super();
      }
      
      public function get played() : Boolean
      {
         return this.roundScores != null;
      }
      
      public function getPlayerScore(playerID:int) : int
      {
         if(this.played && playerID != CardManager.PLAYER_INVALID)
         {
            return this.roundScores[playerID];
         }
         return -1;
      }
      
      public function reset() : void
      {
         this.roundScores = null;
      }
      
      public function get winningPlayer() : int
      {
         if(this.roundWinner != -1)
         {
            return this.roundWinner;
         }
         if(this.played)
         {
            if(this.roundScores[CardManager.PLAYER_1] == this.roundScores[CardManager.PLAYER_2])
            {
               return CardManager.PLAYER_INVALID;
            }
            if(this.roundScores[CardManager.PLAYER_1] > this.roundScores[CardManager.PLAYER_2])
            {
               return CardManager.PLAYER_1;
            }
            return CardManager.PLAYER_2;
         }
         return CardManager.PLAYER_INVALID;
      }
      
      public function setResults(player1Score:int, player2Score:int, winner:int) : void
      {
         if(this.played)
         {
            throw new Error("GFX - Tried to set round results on a round that already had results!");
         }
         this.roundScores = new Vector.<int>();
         this.roundScores.push(player1Score);
         this.roundScores.push(player2Score);
         this.roundWinner = winner;
      }
      
      public function toString() : String
      {
         if(this.roundScores != null)
         {
            return "[ROUND RESULT] p1Score: " + this.roundScores[0] + ", p2Score: " + this.roundScores[1] + ", roundWinner: " + this.roundWinner;
         }
         return "[ROUND RESULT] empty!";
      }
   }
}
