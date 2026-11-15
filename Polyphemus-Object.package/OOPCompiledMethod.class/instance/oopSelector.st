accessing
oopSelector

	"Its selector as the image holds it: the literal before the last, or the one its properties
	keep there. What is no symbol, or takes other arguments than its header counts, is another
	literal taken for it and refused by name (#206)."

	| selector |
	selector := self penultimateLiteral.
	selector oopClassName = 'AdditionalMethodState' ifTrue: [ selector := selector reifiedSlotAt: 2 ].
	selector isStringOop ifFalse: [
		^ NotInTheReading signal: 'the selector of the method at ' , (address printStringRadix: 16)
			  , ' is no symbol: ' , selector whatItReadsAs ].
	selector asString asSymbol numArgs = self numArgs ifFalse: [
		^ NotInTheReading signal: 'the selector of the method at ' , (address printStringRadix: 16)
			  , ' does not take the ' , self numArgs printString , ' arguments its header counts: '
			  , selector asString ].
	^ selector
