finding
methodNamed: aString ifAbsent: aBlock

	"Its method of that name. An entry of its dictionary that is no method, or whose selector
	does not read, cannot be it for sure: with one passed over, a name not found is refused
	rather than said absent (#205)."

	| passedOver |
	passedOver := 0.
	self reifiedMethods do: [ :each |
		| selector |
		selector := each isCompiledMethodOop ifTrue: [
			            [ each oopSelector asString ] on: PolyphemusError do: [ :refusal | nil ] ].
		selector
			ifNil: [ passedOver := passedOver + 1 ]
			ifNotNil: [ selector = aString ifTrue: [ ^ each ] ] ].
	passedOver > 0 ifTrue: [
		^ NotInTheReading signal: 'the class at ' , (address printStringRadix: 16) , ' has '
			  , passedOver printString , ' entries of its method dictionary that do not read as methods: whether it has '
			  , aString , ' cannot be told' ].
	^ aBlock value
