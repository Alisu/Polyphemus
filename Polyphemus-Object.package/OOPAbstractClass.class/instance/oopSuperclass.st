accessing
oopSuperclass

	"Its superclass, or the nil object for a class that has none. A slot holding what is
	neither is refused by name (#205)."

	| superclass |
	superclass := self reifiedSlotAt: 1.
	(superclass isNilOop or: [ superclass isClassOop ]) ifFalse: [
		^ NotInTheReading signal: 'the superclass of the class at ' , (address printStringRadix: 16)
			  , ' is no class: ' , superclass whatItReadsAs ].
	^ superclass
