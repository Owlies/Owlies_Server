#pragma once
#include <string>

using namespace std;

class UnitProperty
{
public: 
	int hitPoint = 0;
	int defense = 0;
	int defenseType = 0;

	int attackDamage = 0;
	float attackSpeed = 1;
	float attackInterval = 1;
	int attackRange = 0;
	int attackType = 0;

	int viewRange = 0;
	int moveSpeed = 0;
	int elementCrystalValue = 0;

	string rarity = "";
};

class UnitFactor
{
public:
	float defenseFactor = 1;∫
	int defenseDelta = 1;
	float attackDamageFactor = 1;
	int attackDamageDelta = 0;
	float attackSpeedFactor = 1;
	int attackSpeedDelta = 0;
	float attackRageFactor = 1;
	int attackRangeDelta = 0;
};