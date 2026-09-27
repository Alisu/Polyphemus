execution
executeOn: aMemoryPresenter

	"The query evaluated as a doit -- the same on Pharo 10, 11 and 12, where noPattern: is
	deprecated for isScripting:, which the older ones do not have."

	self currentQuery
		executeCode: (Smalltalk compiler evaluate: self queryInput text)
		on: aMemoryPresenter
