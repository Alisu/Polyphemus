tests
testAStackThatDoesNotReadIsRefusedNotTakenForAnEmptyOne

	"#182: an unreadable stack was taken as an empty one: the process kept a married context, then
	bereaved, and the image was written with nothing said. The image is refused instead."

	| writer |
	writer := SpurImageFromDump new.
	writer instVarNamed: #reified put: Object new.
	self should: [ writer divorceStackOf: Object new ] raise: NotInTheReading