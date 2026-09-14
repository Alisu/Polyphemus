| names |
('PackageOrganizer exists: ', (Smalltalk includesKey: #PackageOrganizer) printString) traceCr.
('RPackageOrganizer exists: ', (Smalltalk includesKey: #RPackageOrganizer) printString) traceCr.
names := OrderedCollection new.
[ TestCase allSubclasses do: [ :c |
	(c isAbstract not and: [ (c category ifNil: [ '' ]) beginsWith: 'Polyphemus' ])
		ifTrue: [ names add: c name ] ] ]
	on: Error
	do: [ :e | ('ERR ', e class name, ' ', e messageText asString) traceCr ].
('CLASSCOUNT ', names size printString) traceCr.
names asSortedCollection do: [ :n | ('CLASS ', n) traceCr ].

Smalltalk exitSuccess
