private
referencesOfOursTo: aClass

	references ifNil: [ self indexOurMethods ].
	^ references at: aClass name ifAbsent: [ #(  ) ]
