inspection
inspectionItemsOperandStack

	"Each operand under its number; where its stack did not read, one item saying why."

	| operands |
	whyNoStack ifNotNil: [ ^ { ('Operands' -> (OOPUnreadableSlot named: 'the stack' because: whyNoStack on: memory)) } ].
	operands := OrderedCollection new.
	operandStack doWithIndex: [ :operand :anIndex |
		operands add: 'Operand ' , anIndex printString -> operand ].
	^ operands
