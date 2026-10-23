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
"Those that launch images of their own, which the runner keeps from running side by side."
names do: [ :n |
	| c |
	c := Smalltalk at: n.
	((c class canUnderstand: #launchesImages) and: [ c launchesImages ])
		ifTrue: [ ('LANE ', n) traceCr ] ].

"What each class may take before the runner calls it stuck: each test its own limit."
names do: [ :n |
	[ ('LIMIT ', n, ' ', (PolyphemusTestRun secondsAllowedFor: (Smalltalk at: n) atLeast: 0) printString) traceCr ]
		on: Error
		do: [ :e | ] ].

Smalltalk exitSuccess
