running
runOnce: aTest

	"#passed, #skipped, or the exception it signalled, caught where TestResult catches it and
	noted with where it was signalled, while that is still on the stack."

	^ [
	  aTest runCaseManaged.
	  #passed ]
		  on: TestResult failure , TestResult skip , TestResult warning , TestResult error
		  do: [ :e |
			  (e isKindOf: TestResult skip)
				  ifTrue: [ #skipped ]
				  ifFalse: [
					  places at: e put: (self placeOf: e).
					  e ] ]
