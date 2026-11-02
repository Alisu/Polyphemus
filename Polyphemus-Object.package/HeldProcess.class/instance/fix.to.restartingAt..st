editing
fix: aReifiedMethod to: aSource restartingAt: aDepth

	"The image compiles that source into the method's class itself, with its own compiler, symbols
	and changes (#112), the observer compiling it first only to say where it does not; then the
	frame aDepth below the debugger's restarts in it, as Pharo's debugger does after a save (#109)."

	| class className selector |
	class := aReifiedMethod oopMethodClass.
	className := class oopName.
	selector := aReifiedMethod oopSelector asSymbol.
	(self reading compileHostSource: aSource for: class) ifNil: [
		(self reading whyHostSourceDoesNotCompile: aSource for: class) ifNotNil: [ :why |
			^ SourceDoesNotCompile new position: why value; signal: why key ] ].
	self call: #compile with: { className. selector. aSource }.
	[ self call: #restart with: { className. selector. aDepth } ]
		on: Error
		do: [ :error | ^ PartlySaved signal: 'saved, but its frame was not restarted: ' , error messageText ].
	^ #compiledByTheImage
