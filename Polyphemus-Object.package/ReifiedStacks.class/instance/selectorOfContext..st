contexts
selectorOfContext: anActivation

	"The selector of the method a frame or a context runs, a block's being its method's;
	#unknownSelector where the method or its selector does not read."

	^ [ anActivation homeMethod oopSelector asString asSymbol ]
		  on: PolyphemusError
		  do: [ :refusal | #unknownSelector ]
