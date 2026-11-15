debugger protocol
propertyAt: aKey ifAbsent: aBlock

	"Pharo's tools ask this of any method: properties that do not read are answered as absent.
	#oopPropertyAt:ifAbsent: refuses them."

	| absent property |
	absent := Object new.
	property := [ self oopPropertyAt: aKey ifAbsent: [ absent ] ] on: PolyphemusError do: [ :refusal | absent ].
	^ property == absent
		  ifTrue: [ aBlock value ]
		  ifFalse: [ property ]
