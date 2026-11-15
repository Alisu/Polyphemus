computing
computeSubclasses

	"Record subclasses between real classes only. Entries that are not classes, classes missing
	from the table, and a class whose superclass does not read as one are passed over: a reading
	is set up with this, and one damaged class must not cost the image (#205)."

	memory allClassesOop do: [ :aClass |
		aClass isClassOop ifTrue: [
			| superclass |
			superclass := [ aClass oopSuperclass ] on: PolyphemusError do: [ :refusal | nil ].
			(superclass notNil and: [ superclass isNotNilOop ]) ifTrue: [ superclass addSubclass: aClass ] ] ]
