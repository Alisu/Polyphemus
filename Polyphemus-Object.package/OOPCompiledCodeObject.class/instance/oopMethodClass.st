accessing
oopMethodClass

	"The class or trait it is installed in: the value of its last literal, a binding. What is
	neither there, nor nil, is refused by name (#206)."

	| class |
	class := self lastLiteral reifiedSlotAt: 2.
	(class isNilOop or: [ class isKindOf: OOPAbstractClass ]) ifFalse: [
		^ NotInTheReading signal: 'the class of the method at ' , (address printStringRadix: 16)
			  , ' is no class: ' , class whatItReadsAs ].
	^ class
