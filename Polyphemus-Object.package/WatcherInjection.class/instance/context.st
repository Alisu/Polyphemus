making
context

	"A context of the image's own at the start of the watcher's method, as Context
	class>>newForMethod: would make it: sized for the method's frame, every slot nil."

	| compilation method class context |
	class := reading oopClassNamed: 'UndefinedObject'.
	compilation := (reading
		                compileHostSource: (PolyphemusAgent watcherMethodSourceWatching: directory)
		                for: class) first.
	method := installer
		          methodFrom: compilation
		          under: (installer intern: 'polyphemusWatch')
		          in: class.
	context := self new: 'Context' extra: compilation frameSize format: 3.
	self slot: 'pc' of: context in: 'Context' put: (installer memory smallIntegerOop: compilation initialPC).
	self slot: 'stackp' of: context in: 'Context' put: (installer memory smallIntegerOop: compilation numTemps).
	self slot: 'method' of: context in: 'Context' put: method.
	^ context
