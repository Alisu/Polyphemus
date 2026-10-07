reading
packageNames

	"Pharo 10 and 11: the names held by RPackages."

	^ packageNames ifNil: [
		  packageNames := Set new.
		  objectMemory allObjectsDo: [ :each |
			  (self is: each named: 'RPackage') ifTrue: [ packageNames addAll: (self stringsOf: each) ] ].
		  packageNames ]
