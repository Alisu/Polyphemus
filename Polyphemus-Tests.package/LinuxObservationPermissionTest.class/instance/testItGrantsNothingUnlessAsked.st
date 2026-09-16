tests
testItGrantsNothingUnlessAsked

	"An image is not observable by accident. With the variable unset there is nothing to do
	and nothing is granted, which is what makes it safe to put in a startup action."

	self assert: LinuxObservationPermission applyFromEnvironment isNil
