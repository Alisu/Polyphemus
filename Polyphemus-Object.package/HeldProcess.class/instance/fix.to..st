editing
fix: aReifiedMethod to: aSource

	"Compile that source for the method's class and put it where the class now holds that
	selector -- a context may run an older method, as after a trap took itself out. The image then
	drops its machine code: a jitted method would go on running the old bytecodes."

	| current how |
	current := aReifiedMethod oopMethodClass methodNamed: aReifiedMethod oopSelector asString.
	how := self whileStillWhereRead: current do: [ :memory |
		       (SpurMethodFix on: reading into: memory) apply: aSource to: current ].
	channel ask: 'Smalltalk vm voidCogVMState. nil'.
	^ how
