/***********************************************************************/
/** 	© 2015 CD PROJEKT S.A. All rights reserved.
/** 	THE WITCHER® is a trademark of CD PROJEKT S. A.
/** 	The Witcher game is based on the prose of Andrzej Sapkowski.
/***********************************************************************/
class W3Effect_Weaken extends CBaseGameplayEffect
{
	default effectType = EET_Weaken;
	default isNegative = true;
	default attributeName = 'attack_power';
}