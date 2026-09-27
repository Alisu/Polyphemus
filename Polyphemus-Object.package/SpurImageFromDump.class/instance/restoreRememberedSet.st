writing
restoreRememberedSet

	"The old objects the dumped VM knew to point into new space. Without them a collection
	would take those young objects for unreachable. Kept where the VMMaker in use keeps them
	(rememberedSetOf:)."

	| variables set size source target |
	variables := dumped raw vmVariables.
	set := self rememberedSetOf: dumped memory.
	size := variables at: 'rememberedSetSize'.
	source := variables at: 'rememberedSet'.
	target := set instVarNamed: self rememberedSetArrayName.
	0 to: size - 1 do: [ :each |
		target at: each put: (dumped raw space unsignedAt: source + (each * 8) size: 8) ].
	set instVarNamed: #rememberedSetSize put: size.
	^ size
