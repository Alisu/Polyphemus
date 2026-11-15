tests
testADefectReadingTheNamesOfAnInstancesSlotsIsNotAnInstanceShownByNumbers

	"#118, #205: an instance of a class that does not tell its names shows its slots by number; a
	bug of our own asking the names is not that. The defect is planted where the class is kept,
	and taken out."

	| memory class instance |
	memory := self memory.
	class := memory oopClassNamed: 'Point'.
	instance := class instancesOop first.
	memory objectAt: class address put: (self defective: class in: #allOopSlotNames).
	[ self should: [ instance containedInspectionItems ] raise: ZeroDivide ] ensure: [
		memory objectAt: class address put: class ]
