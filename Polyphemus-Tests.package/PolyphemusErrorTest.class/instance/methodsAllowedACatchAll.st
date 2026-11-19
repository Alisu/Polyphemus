accessing
methodsAllowedACatchAll

	"Each method outside the tests that catches any Error, by why it may (#118, #212). A method
	leaves its list when it is narrowed; one joins a list only for the reason the list gives."

	^ self catchAllsAroundCodeThatIsNotOurs , self catchAllsAroundFilesOfTheSystem
	  , self catchAllsAroundWhatAUserHandsInOrSees , self catchAllsWhereAFailureIsReportedOrAProcessLetGo
	  , self catchAllsNotNarrowedYet
