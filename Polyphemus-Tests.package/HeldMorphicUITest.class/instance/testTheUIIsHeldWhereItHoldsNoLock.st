tests
testTheUIIsHeldWhereItHoldsNoLock

	"#59: held inside a critical section, the UI process kept a mutex the test then waited on
	until its time limit."

	| mutex entered got |
	HeldMorphicUI uiProcess ifNil: [ ^ self skip: 'no Morphic UI process in this image' ].
	mutex := Mutex new.
	entered := Semaphore new.
	self currentWorld defer: [
		mutex critical: [
			entered signal.
			(Delay forMilliseconds: 500) wait ] ].
	self deny: (entered waitTimeoutSeconds: 5).

	HeldMorphicUI during: [
		got := [ mutex critical: [ true ] ] valueWithin: 3 seconds onTimeout: [ false ] ].

	self assert: got
