tests
testADefectReadingAClassesNameIsNotAClassWithoutOne

	"#118: a bug of our own while a class's name was read gave 'Invalid ClassName', and a class
	said to have no readable name. The class is read through a reading that fails where a slot
	is made an object."

	| class |
	class := (self memory oopClassNamed: 'Point') copy.
	class memory: (self defective: self memory in: #reifyOop:).

	self should: [ class oopName ] raise: ZeroDivide.
	self should: [ class hasAReadableName ] raise: ZeroDivide.
	self should: [ class printString ] raise: ZeroDivide
