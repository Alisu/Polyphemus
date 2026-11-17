tests
testItFindsTheRememberedSetWhereverTheVMKeepsIt

	"VM 9 names it by three variables; VM 10 keeps it in a structure it points to. Read either
	way, every entry is an object with its remembered bit set -- the offsets, not only the names."

	| pid reader |
	pid := self launchObservableTarget.
	[
	reader := LinuxProcessMemory on: pid.
	reader whileStoppedWhenQuiet: [
		| variables size array |
		variables := VMVariables on: reader.
		size := variables at: 'rememberedSetSize'.
		array := variables at: 'rememberedSet'.
		self assert: (size between: 1 and: (variables at: 'rememberedSetLimit')).
		0 to: size - 1 do: [ :index |
			| oop |
			oop := reader unsignedAt: array + (index * 8) size: 8.
			self assert: (((reader unsignedAt: oop size: 8) bitShift: -29) bitAnd: 1) equals: 1 ] ] ]
		ensure: [
			LibC system: 'kill ' , pid printString.
			reader ifNotNil: [ reader close ] ]
