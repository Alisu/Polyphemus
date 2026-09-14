tests
testTheStackOfTheDamagedProcessIsEmptyNotWrong

	"Asked for the stack of the process whose pointer was blanked, the honest answer is
	that there is none. What it must not do is invent one out of whatever the zeroed word
	happens to address."

	| damaged |
	damaged := reifiedMemory reifiedActiveProcess.

	self assert: (reifiedMemory contextsOfProcess: damaged) isEmpty
