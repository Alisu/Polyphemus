telling
sayCodeRunsInTheObserver

	"Said in the debugger's title until it closes: no image runs its code, the observer does."

	self owner ifNotNil: [ :code |
		code owner ifNotNil: [ :debugger |
			self session mark: 'Code runs in the observer'.
			self session markTitleOf: debugger ] ]
