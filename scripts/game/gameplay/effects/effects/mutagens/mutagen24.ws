/***********************************************************************/
/** 	© 2015 CD PROJEKT S.A. All rights reserved.
/** 	THE WITCHER® is a trademark of CD PROJEKT S. A.
/** 	The Witcher game is based on the prose of Andrzej Sapkowski.
/***********************************************************************/



class W3Mutagen24_Effect extends W3Mutagen_Effect
{
	default effectType = EET_Mutagen24;

	
	default dontAddAbilityOnTarget = true;
	
	private var hasAbility : bool;
	
	event OnUpdate(dt : float)
	{
		var currentHour : int;
	
		super.OnUpdate(dt);		
		
		currentHour = GameTimeHours(theGame.GetGameTime());
		
		if( (GetCurWeather() != EWE_Clear && GetWeatherConditionName() != 'WT_Clear') || (currentHour > GetHourForDayPart(EDP_Dawn) && currentHour < GetHourForDayPart(EDP_Dusk)) )
		{
			if(hasAbility)
			{
				target.RemoveAbility(abilityName);
				hasAbility = false;
			}
		}
		else
		{
			if(!hasAbility)
			{
				target.AddAbility(abilityName, false);
				hasAbility = true;
			}
		}
	}
	
	public function OnLoad(t : CActor, eff : W3EffectManager)
	{
		super.OnLoad(t, eff);
		hasAbility = target.HasAbility(abilityName);
	}
	
}