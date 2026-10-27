tests
testARefusalIsTold

	self deny: ((MethodSave of: 'tick: n ^ n + 1' notifying: notifier) refuse: 'only read').
	self assert: notifier notices asArray equals: { { 'only read'. 1 } }
