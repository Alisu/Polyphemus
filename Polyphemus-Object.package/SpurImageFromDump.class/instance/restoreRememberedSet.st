writing
restoreRememberedSet

	"The old objects the dumped VM knew to point into new space. Without them a collection
	would take those young objects for unreachable."

	| variables scavenger size source target |
	variables := dumped raw vmVariables.
	scavenger := dumped memory scavenger.
	size := variables at: 'rememberedSetSize'.
	source := variables at: 'rememberedSet'.
	target := scavenger instVarNamed: #rememberedSet.
	0 to: size - 1 do: [ :each |
		target at: each put: (dumped raw space unsignedAt: source + (each * 8) size: 8) ].
	scavenger instVarNamed: #rememberedSetSize put: size.
	^ size
