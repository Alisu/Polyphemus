running
outcomeOfRunning: aTest

	^ [
	  aTest runCaseManaged.
	  #passed ]
		  on: TestResult failure , TestResult skip , TestResult warning , TestResult error
		  do: [ :e |
			  (e isKindOf: TestResult skip)
				  ifTrue: [ #skipped ]
				  ifFalse: [
					  places at: e put: (self placeOf: e) , (self memoryOf: e).
					  e ] ]
