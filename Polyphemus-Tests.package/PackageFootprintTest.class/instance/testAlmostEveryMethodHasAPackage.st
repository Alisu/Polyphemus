tests
testAlmostEveryMethodHasAPackage

	"Methods outside every method dictionary (a DoIt kept by a tool, say) have none."

	| footprint all |
	footprint := self footprint.
	all := footprint census countOf: 'CompiledMethod'.
	self assert: footprint ownedMethodCount <= all.
	self assert: footprint ownedMethodCount > (all * 99 / 100)
