helpers
spinningTargetScript

	"The target as the tests that do not care about machine code want it: cold."

	^ self spinningTargetScriptWarming: false
