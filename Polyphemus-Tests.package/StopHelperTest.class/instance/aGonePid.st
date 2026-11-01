helpers
aGonePid

	| pid |
	pid := (LibC resultOfCommand: 'true > /dev/null 2>&1 & echo $!') trimBoth asNumber.
	self assert: (self waitFor: [ (self stateOf: pid) isEmpty ]).
	^ pid
