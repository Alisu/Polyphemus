contexts
homeMethodOf: aCompiledCodeOop

	"A compiled block carries no selector: it keeps its enclosing code as its last
	literal, so climb until a compiled method appears. Stop climbing if the chain
	repeats, which only a damaged image can produce."

	| code seen |
	code := aCompiledCodeOop.
	seen := Set new.
	[ ([ code isCompiledBlockOop ] on: Error do: [ :e | false ])
		and: [ (seen includes: code) not ] ] whileTrue: [
		seen add: code.
		code := code lastLiteral ].
	^ code
