contexts
whyTheStackEndsAfter: anActivation

	"Why reading stops at this activation though something called it, in a sentence: its caller
	does not read, is no activation, or is a frame this reading does not hold. nil when its
	caller reads, and when nothing called it."

	| caller |
	caller := [ anActivation sender ] on: PolyphemusError do: [ :refusal | ^ refusal messageText ].
	(caller isNil or: [ caller isNilOop ]) ifFalse: [ ^ nil ].
	^ (anActivation isStackFrame not and: [ self isMarriedContext: anActivation ]) ifTrue: [
		  'the context at ' , (anActivation address printStringRadix: 16)
		  , ' is married to a frame this reading does not hold' ]
