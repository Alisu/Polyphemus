computing
computeSubclasses
	"Record subclasses between real classes only. Entries that are not classes, and classes
	missing from the table, are skipped."
	memory allClassesOop do: [ :aClass | | superclass |
		aClass isClassOop ifTrue: [
			superclass := aClass oopSuperclass.
			(superclass isNotNilOop and: [ superclass isClassOop ]) ifTrue: [
				superclass addSubclass: aClass
			]]]
