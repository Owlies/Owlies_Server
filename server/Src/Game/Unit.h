#pragma once
#include "Object.h"
#include "UnitProperty.h"

#define MAX_PASSIVE_NUM 5

class Unit : Object
{
public:

    int passiveSkills[MAX_PASSIVE_NUM];
    int activeSkill = 0;

    int target = 0;
    bool targetable = true;
    bool deadable = true;
    bool attackable = true;
    bool moveable = true;

    UnitProperty originProperty;
    UnitProperty finalProperty;
    UnitFactor factors;

    OBJECT_TYPE GetType(){return UNIT};
};