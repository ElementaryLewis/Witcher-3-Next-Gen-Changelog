/***********************************************************************/
/** 	© 2015 CD PROJEKT S.A. All rights reserved.
/** 	THE WITCHER® is a trademark of CD PROJEKT S. A.
/** 	The Witcher game is based on the prose of Andrzej Sapkowski.
/***********************************************************************/




class W3Effect_AirDrain extends CBaseGameplayEffect
{
	default effectType = EET_AirDrain;
	default attributeName = 'airDrain';
	default isPositive = false;
	default isNeutral = false;
	default isNegative = true;
	
	event OnUpdate(deltaTime : float)
	{
		var drain : float;
		
		super.OnUpdate(deltaTime);
		
		if(isOnPlayer && thePlayer.CanPlaySpecificVoiceset()  && FactsQuerySum("nge_block_geralt_coughing") <= 0 )
		{
			thePlayer.PlayVoiceset( 100, "coughing" );
			thePlayer.SetCanPlaySpecificVoiceset( false );
			thePlayer.AddTimer( 'ResetSpecificVoicesetFlag', 10.0f );
		}
	
		if(target.GetStat(BCS_Air) <= 0)
		{
			target.AddEffectDefault(EET_Choking,target,"NoAir");
		}
		else
		{
			drain = MaxF(0, deltaTime * ( effectValue.valueAdditive + effectValue.valueMultiplicative * target.GetStatMax(BCS_Air) ) );
			
			effectManager.CacheStatUpdate(BCS_Air, -drain);
		}
	}
	
	event OnEffectAdded(optional customParams : W3BuffCustomParams)
	{
		super.OnEffectAdded(customParams);
		
		if(!isOnPlayer)
		{
			isActive = false;
			return false;
		}
		
		target.PauseEffects(EET_AutoAirRegen, 'AirDrain');
	}
	
	event OnEffectRemoved()
	{
		super.OnEffectRemoved();
		
		target.RemoveBuff(EET_Choking, false, "NoAir"); 
		target.ResumeEffects(EET_AutoAirRegen, 'AirDrain');
	}
}