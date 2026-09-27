testing
isFailure: anOutcome

	"An assertion that did not hold, as against an error."

	^ anOutcome isKindOf: TestResult failure
