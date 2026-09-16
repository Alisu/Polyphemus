computing
computeSubclasses
	"Only between things that really are classes.

	A damaged class table costs on both sides: an entry that is not a class has no
	superclass to ask for, and a real class that has fallen out of the table is never
	recognised as one, so it cannot be told it has subclasses either. Asking anyway used to
	fail here and take the whole memory down with it. Both are skipped instead -- every
	sound class still gets its subclasses, and the objects whose class went missing come out
	with an OOPUnreadableClass."
	memory allClassesOop do: [ :aClass | | superclass |
		aClass isClassOop ifTrue: [
			superclass := aClass oopSuperclass.
			(superclass isNotNilOop and: [ superclass isClassOop ]) ifTrue: [
				superclass addSubclass: aClass
			]]]
