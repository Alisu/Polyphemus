helpers
youngRememberedIn: aWritableProcess

	"The entries of the VM's remembered set that are in new space: there should be none."

	| variables set |
	variables := aWritableProcess variables.
	set := variables at: 'rememberedSet'.
	^ ((0 to: (variables at: 'rememberedSetSize') - 1) collect: [ :each | aWritableProcess wordAt: set + (each * 8) ])
		  select: [ :oop | self isYoung: oop in: aWritableProcess ]
