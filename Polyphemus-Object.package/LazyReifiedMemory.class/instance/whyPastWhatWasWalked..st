accessing
whyPastWhatWasWalked: anAddress

	"What the raw heap adds to the refusal of an address past where its walk stopped; nil for any
	other address, and where there is no raw heap (a simulator's layout)."

	^ self vmLayout raw ifNotNil: [ :raw | raw whyPastItsWalk: anAddress ]
