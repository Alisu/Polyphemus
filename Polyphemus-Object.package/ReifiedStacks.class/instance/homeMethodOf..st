contexts
homeMethodOf: aCompiledCodeOop

	"A compiled block carries no selector: it keeps its enclosing code as its last literal, so
	climb until a compiled method appears; a chain that repeats, or ends on what is no method,
	as only a damaged image has, is refused by name."

	| code seen |
	code := aCompiledCodeOop.
	seen := Set new.
	[ code notNil and: [ code isCompiledBlockOop and: [ (seen includes: code) not ] ] ] whileTrue: [
		seen add: code.
		code := code lastLiteral ].
	(code notNil and: [ code isCompiledMethodOop ]) ifFalse: [
		^ NotInTheReading signal: 'what this activation runs is no method: '
			  , (code ifNil: [ 'nil' ] ifNotNil: [ code whatItReadsAs ]) ].
	^ code
