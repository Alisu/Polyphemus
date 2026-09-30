categories
categoryOfHeader: aHeader

	"Class indexes 3 and 16 to 31 are the VM's own (VMMaker's puns); pinned is bit 30."

	| classIndex format |
	classIndex := scanner classIndexIn: aHeader.
	classIndex = 0 ifTrue: [ ^ #free ].
	classIndex = 8 ifTrue: [ ^ #forwarder ].
	((aHeader bitShift: -30) bitAnd: 1) = 1 ifTrue: [ ^ #pinned ].
	(classIndex = 3 or: [ classIndex between: 16 and: 31 ]) ifTrue: [ ^ #virtualMachine ].
	format := scanner formatIn: aHeader.
	format >= 24 ifTrue: [ ^ #compiledCode ].
	format >= 16 ifTrue: [ ^ #bytes ].
	format >= 9 ifTrue: [ ^ #words ].
	^ #pointers
