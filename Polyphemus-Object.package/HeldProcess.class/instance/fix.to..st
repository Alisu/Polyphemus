editing
fix: aReifiedMethod to: aSource

	"Compile that source for the method's class and put it where the class now holds that
	selector -- a context may run an older method, as after a trap took itself out. The image then
	drops its machine code: a jitted method would go on running the old bytecodes."

	| current saving how |
	current := aReifiedMethod oopMethodClass methodNamed: aReifiedMethod oopSelector asString.
	"Named while this reading is the image's: once it has run, what it is read from may have moved."
	saving := self sourceSavingOf: aSource for: aReifiedMethod.
	how := self whileStillWhereRead: current do: [ :memory |
		       (SpurMethodFix on: reading into: memory) apply: aSource to: current ].
	channel ask: 'Smalltalk vm voidCogVMState. nil'.
	channel ask: saving.
	^ how
