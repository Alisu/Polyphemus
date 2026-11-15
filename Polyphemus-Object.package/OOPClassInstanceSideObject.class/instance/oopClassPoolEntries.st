classVariables
oopClassPoolEntries

	"The associations of its class pool, one a class variable; none where it keeps no pool, as a
	class with no class variable does from Pharo 11. A pool that is no dictionary is refused by
	name (#205)."

	| pool array |
	pool := self oopSlotNamed: memory mode classVariablesSlotName.
	(pool isNil or: [ pool isNilOop ]) ifTrue: [ ^ #(  ) ].
	array := pool oopSlotNamed: #array.
	array ifNil: [
		^ NotInTheReading signal: 'the class pool of the class at ' , (address printStringRadix: 16)
			  , ' is no dictionary: ' , pool whatItReadsAs ].
	^ array allReifiedSlots select: [ :o | o isNotNilOop ]
