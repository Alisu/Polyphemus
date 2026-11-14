running
whatIsAskedOfFrame: anIndex

	"What the frame at that place is asked of its own words, each named: these answer, or
	refuse by an error of Polyphemus's own."

	| frame |
	frame := [ self frames at: anIndex ifAbsent: [ nil ] ].
	^ (#( #compiledCode #receiver #sender #pc #stackp #closureOrNil #homeMethod #outerContext #home
	      #method #methodClass #oopContext #instructionPointer #operandStack #stackWords #savedIP
	      #oopCaller #oopPageCaller #savedFramePointer #callerSavedIP ) collect: [ :each |
		   each -> [ frame value ifNotNil: [ :it | it perform: each ] ] ])
	  , { ('tempAt: 1' -> [ frame value ifNotNil: [ :it | it tempAt: 1 ] ]) }
