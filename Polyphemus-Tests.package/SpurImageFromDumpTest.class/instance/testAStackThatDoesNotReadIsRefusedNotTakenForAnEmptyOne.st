tests
testAStackThatDoesNotReadIsRefusedNotTakenForAnEmptyOne

	"#182: an unreadable stack was taken as an empty one: the process kept a married context, then
	bereaved, and the image was written with nothing said. What the reading refuses of a stack is
	refused of the image; a defect of ours on the way is not a stack that does not read (#118)."

	| writer |
	writer := SpurImageFromDump new.
	writer
		instVarNamed: #reified
		put: ((DefectiveReadDouble of: Object new) when: #activationsOfProcess: answer: [ NotInTheReading signal: 'its stack does not read' ]).
	self should: [ writer divorceStackOf: Object new ] raise: NotInTheReading.
	writer instVarNamed: #reified put: ((DefectiveReadDouble of: Object new) when: #activationsOfProcess: answer: [ 1 / 0 ]).
	self should: [ writer divorceStackOf: Object new ] raise: ZeroDivide
