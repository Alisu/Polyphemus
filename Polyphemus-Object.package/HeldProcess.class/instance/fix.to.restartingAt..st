editing
fix: aReifiedMethod to: aSource restartingAt: aDepth

	"Compile that source for the method's class and put it where the class now holds that selector,
	the image dropping its machine code and keeping the source (#105); then the frame aDepth below the
	debugger's restarts in it, as Pharo's debugger does after a save (#109)."

	| current saving restarting how |
	current := aReifiedMethod oopMethodClass methodNamed: aReifiedMethod oopSelector asString.
	"Named while this reading is the image's: once it has run, what it is read from may have moved."
	saving := self sourceSavingOf: aSource for: aReifiedMethod.
	restarting := self restartSourceAt: aDepth in: (self methodNameOf: aReifiedMethod).
	how := self whileStillWhereRead: current do: [ :memory |
		       (SpurMethodFix on: reading into: memory) apply: aSource to: current ].
	channel ask: 'Smalltalk vm voidCogVMState. nil'.
	channel ask: saving.
	channel ask: restarting.
	^ how
