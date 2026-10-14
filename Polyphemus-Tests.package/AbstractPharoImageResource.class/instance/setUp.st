running
setUp
	| initializer |
	super setUp.
	initializer := AbstractInspectorsTest new.
	initializer imagePath: self imagePath.
	initializer setUpForResourceMarrying: self marriesInitialContext.

	"Interpret here rather than once at resource creation: SUnit re-runs this setUp
	between suite runs, and the interpreted state has to be reproducible."
	self numberOfSteps > 0 ifTrue: [
		initializer interpretUntilMethodChangedNumberOfTimes: self numberOfSteps ].

	self setUpFromInitializer: initializer
