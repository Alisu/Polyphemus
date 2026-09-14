tests
testAFrameReadsAgainstTheReceiverClassOfThatImage

	"The class a frame's source is read against is the receiver's class in the image
	being analysed, so its instance variables resolve."

	| context behavior |
	context := (reifiedMemory contextsOfProcess: (reifiedMemory allReifiedProcesses
			             detectMax: [ :each | (reifiedMemory contextsOfProcess: each) size ])) first.
	behavior := context receiver oopClass.

	self assert: behavior name equals: 'Process'.
	self assert: (behavior allInstVarNames includes: 'suspendedContext').
	self deny: (behavior lookupVar: 'suspendedContext' declare: false) isNil
