tests
testTheBlankedSlotIsReportedRatherThanRaised

	"The running process points at eight zero bytes, which is no object. It must come back as a
	report: raising mid-walk hides what is wrong and every part that is still intact."

	| problems |
	problems := reifiedMemory processInconsistencies.

	self deny: problems isEmpty.
	self assert:
		(problems anySatisfy: [ :each | each value = #suspendedContextIsUnreadable ])
