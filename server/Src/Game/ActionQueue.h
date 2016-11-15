#pragma once
#include <Object.h>
#include <list>

using namespace std;

typedef bool(Action)(Object obj);

class ActionQueue {
private:
	list<Action> actions;

public:
	void perform(Object* obj);
}

