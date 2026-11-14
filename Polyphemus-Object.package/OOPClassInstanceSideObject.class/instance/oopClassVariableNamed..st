accessing
oopClassVariableNamed: aString

	"The value of that class variable, read from its own entry: another entry that does not
	read costs nothing here."

	| slotIndex |
	self oopInstanceSide oopAllClassVariablesNames doWithIndex: [ :o :i | o asString = aString ifTrue: [ slotIndex := i ] ].
	^ slotIndex ifNotNil: [ (self oopClassPoolEntries at: slotIndex) oopSlotNamed: #value ]
