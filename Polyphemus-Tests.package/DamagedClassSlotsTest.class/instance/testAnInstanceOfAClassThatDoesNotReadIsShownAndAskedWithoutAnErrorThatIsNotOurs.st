tests
testAnInstanceOfAClassThatDoesNotReadIsShownAndAskedWithoutAnErrorThatIsNotOurs

	"#193: the class index of a context's receiver names no class, so its class is the stand-in.
	What the tools show of it and of its context answers; what is asked of it and of that
	stand-in answers or is refused by name."

	| instance classIndex unnamed |
	instance := context receiver.
	classIndex := memory classIndexOf: instance address.
	memory setClassIndexOf: instance address to: 16r3FFF00.
	reifiedMemory forgetWhatWasRead.
	unnamed := OrderedCollection new.
	[
	self assert: instance oopClass isUnreadableClass.
	self whatIsShown , {
		('its class printed' -> [ instance oopClass printString ]).
		('its class''s name' -> [ instance oopClass oopName ]).
		('its name if any' -> [ instance objectNameIfAny ]) } do: [ :question |
		[ question value value ]
			on: Error
			do: [ :error | unnamed add: (self saying: error of: question under: 'no class at its index') ] ].
	self whatIsAsked , {
		('its class''s slot names' -> [ instance oopClass allOopSlotNames ]).
		('a method of its class' -> [ instance oopClass methodNamed: 'activate' ifAbsent: [ nil ] ]).
		('its class''s methods' -> [ instance oopClass reifiedMethods ]).
		('its class''s superclass' -> [ instance oopClass oopSuperclass ]).
		('its contained items' -> [ instance containedInspectionItems ]) } do: [ :question |
		[ question value value ]
			on: Error
			do: [ :error |
				(error isKindOf: PolyphemusError) ifFalse: [
					unnamed add: (self saying: error of: question under: 'no class at its index') ] ] ] ] ensure: [
		memory setClassIndexOf: instance address to: classIndex.
		reifiedMemory forgetWhatWasRead ].
	self assert: unnamed isEmpty description: (String cr join: unnamed)
