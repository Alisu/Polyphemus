running
whatIsAsked

	"What a class and its instance are asked of the class's own slots."

	| instance |
	instance := context receiver.
	^ (#( #instVarNames #allInstVarNames #allOopSlotNames #oopSlotNames #oopSuperclass #oopAllClassVariablesNames #oopAllClassVariables
	      #reifiedMethods #oopSubclasses #instancesOop #oopClassSide #classNameObject #oopNumberOfClassVariables )
		   collect: [ :each | each -> [ subject perform: each ] ])
	  , {
			  ('bindingOf:' -> [ subject bindingOf: #Object ]).
			  ('classVariableNamed:' -> [ subject classVariableNamed: 'NoSuchVariable' ]).
			  ('methodNamed:ifAbsent:' -> [ subject methodNamed: 'activate' ifAbsent: [ nil ] ]).
			  ('oopClassNamed:' -> [ reifiedMemory oopClassNamed: 'Point' ]).
			  ('globalNamed:' -> [ reifiedMemory globalNamed: #Smalltalk ]).
			  ('its instance''s class' -> [ instance oopClass ]).
			  ('its instance''s slots' -> [ instance allReifiedSlots ]).
			  ('its instance''s slot by name' -> [ instance oopSlotNamed: 'commandLine' ]) }
