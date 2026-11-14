private
integerInSlot: anIndex called: aName ifNil: aBlock

	"The small integer a context keeps there; aBlock's value when it keeps nil."

	| slot |
	slot := self reifiedSlotAt: anIndex.
	slot isNilOop ifTrue: [ ^ aBlock value ].
	slot isImmediateOop ifFalse: [
		^ NotInTheReading signal: 'the ' , aName , ' of the context at ' , (address printStringRadix: 16)
			  , ' is no integer: ' , slot whatItReadsAs ].
	^ slot asInteger
