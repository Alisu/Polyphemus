tests
testTheMemoryMapIsATabBuiltOnlyWhenOpened

	"Drawn when its tab is opened, not when the inspector is (#68)."

	| page |
	page := inspector pages detect: [ :each | each title = 'Memory map' ].

	self assert: page activePresenter isNil.
	self assert: (page retrievePresenter isKindOf: MemoryMapPresenter)
