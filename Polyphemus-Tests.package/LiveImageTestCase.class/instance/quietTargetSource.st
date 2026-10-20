helpers
quietTargetSource

	"Run before a target's own script: no Epicea log of what it compiles, which went next to the
	pinned images, into resources/pharo-local, one file a launch."

	^ '(Smalltalk globals at: #EpMonitor ifAbsent: [ nil ]) ifNotNil: [ :monitor | monitor current disable ].'
