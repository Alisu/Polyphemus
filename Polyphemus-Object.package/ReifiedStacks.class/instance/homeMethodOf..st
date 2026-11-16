contexts
homeMethodOf: aCompiledCodeOop

	"A compiled block carries no selector: it keeps its enclosing code as its last literal, so
	climb until a compiled method appears. A chain that repeats, ends on what is no method, or
	names code whose literals all read and hold no such block, is refused by name."

	| code seen |
	code := aCompiledCodeOop.
	seen := Set new.
	[ code notNil and: [ code isCompiledBlockOop and: [ (seen includes: code) not ] ] ] whileTrue: [
		| outer |
		seen add: code.
		outer := code lastLiteral.
		((outer isCompiledMethodOop or: [ outer isCompiledBlockOop ]) and: [ (self whetherCode: outer holdsBlock: code) == false ]) ifTrue: [
			^ NotInTheReading signal: 'the block at ' , (code address printStringRadix: 16) , ' names as its own the code at '
				  , (outer address printStringRadix: 16) , ', which does not hold it' ].
		code := outer ].
	(code notNil and: [ code isCompiledMethodOop ]) ifFalse: [
		^ NotInTheReading signal: 'what this activation runs is no method: '
			  , (code ifNil: [ 'nil' ] ifNotNil: [ code whatItReadsAs ]) ].
	^ code
