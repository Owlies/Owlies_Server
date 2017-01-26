#pragma once
#include "Object.h"

class Projectile : Object
{
public:

    int target = 0;
    float speed = 0.f;

    OBJECT_TYPE GetType(){return PROJECTILE};
};