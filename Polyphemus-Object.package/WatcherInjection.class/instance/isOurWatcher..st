private
isOurWatcher: anOop

	"A process, named as ours are: not another's waiting on a slot the index file names (#163)."

	| name |
	(installer memory classIndexOf: anOop) = (reading oopClassNamed: 'Process') oopHash ifFalse: [ ^ false ].
	name := self slot: 'name' of: anOop in: 'Process'.
	name = installer nilOop ifTrue: [ ^ false ].
	^ (reading reifyOop: name) asString = self class watcherName
