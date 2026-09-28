reading
cogMethodSurrogateClass

	"VMMaker v12 moved a flag out of CogMethod's header bits, and its own surrogates still read
	the old layout: ours reads the one the VM has, chosen where VMMaker declares the move."

	^ CogMethod instVarNames last = #picHasMNUCaseOrCMIsFullBlock
		  ifTrue: [ OOPCogMethodSurrogate64 ]
		  ifFalse: [ CogMethodSurrogate64 ]
