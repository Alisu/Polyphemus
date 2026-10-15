holding it still
isStopped

	"Windows keeps no stopped state for a process: stopped is every thread suspended."

	| ids |
	ids := self threadIds copyWithout: self class currentThreadId.
	^ ids notEmpty and: [ ids allSatisfy: [ :each | ((self suspendCountOf: each) ifNil: [ 0 ]) > 0 ] ]
