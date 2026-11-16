accessing
doesNotUnderstand: aMessage

	"What a class is asked and this stand-in has no answer to is refused by name, where its
	callers look for a refusal (#193); what no class understands either stays not understood."

	^ (OOPClassInstanceSideObject canUnderstand: aMessage selector)
		  ifTrue: [ NotInTheReading signal: self name , ' does not read: it has no answer to ' , aMessage selector ]
		  ifFalse: [ super doesNotUnderstand: aMessage ]
