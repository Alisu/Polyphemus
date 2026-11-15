running
method

	"A method of the image, its literals all there."

	^ (self memory oopClassNamed: 'Interval') methodNamed: 'collect:' ifAbsent: [ self fail: 'no Interval>>collect:' ]
