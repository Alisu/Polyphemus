tests
testTheBlankedSlotIsReportedRatherThanRaised

	"The running process points at eight bytes of zero where its stack used to be. That
	is not a context, and it is not an object at all: reifying it cannot answer anything.

	It has to come back as a report. Raising out of the middle of a walk over the process
	graph tells whoever is reading the image nothing about what is wrong with it, and
	stops them seeing the parts that are still intact."

	| problems |
	problems := reifiedMemory processInconsistencies.

	self deny: problems isEmpty.
	self assert:
		(problems anySatisfy: [ :each | each value = #suspendedContextIsUnreadable ])
