taking
take

	"Classes before metaclasses, so that a metaclass finds its class's package."

	| classes metaclasses |
	classes := self classOops.
	metaclasses := classes select: [ :each | (census nameOfClass: each) endsWith: ' class' ].
	(classes reject: [ :each | metaclasses includes: each ]) do: [ :each | self own: each ].
	metaclasses do: [ :each | self own: each ]
