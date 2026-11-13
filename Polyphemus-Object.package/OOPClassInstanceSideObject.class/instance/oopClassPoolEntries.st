classVariables
oopClassPoolEntries

	"The associations of its class pool, one a class variable; none where it keeps no pool, as a
	class with no class variable does from Pharo 11."

	| pool |
	pool := self oopSlotNamed: memory mode classVariablesSlotName.
	(pool isNil or: [ pool isNilOop ]) ifTrue: [ ^ #(  ) ].
	^ pool array allReifiedSlots select: [ :o | o isNotNilOop ]
