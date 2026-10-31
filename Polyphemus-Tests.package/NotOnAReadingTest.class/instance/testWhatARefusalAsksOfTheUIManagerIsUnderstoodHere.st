tests
testWhatARefusalAsksOfTheUIManagerIsUnderstoodHere

	"#142: a refusal, or a held image gone, said in the UI process asks UIManager default for things
	each Pharo names its own way; Pharo 13 has no spawnNewProcessIfThisIsUI:."

	| asked |
	asked := Set new.
	{ NotOnAReading >> #defaultAction. NotOnAReading >> #tell. HeldImageGone >> #defaultAction. HeldImageGone >> #tellAbout: }
		do: [ :method |
			method ast allChildren do: [ :node |
				(node isMessage and: [
					 node receiver isMessage and: [
						 node receiver selector = #default and: [
							 node receiver receiver isVariable and: [ node receiver receiver name = #UIManager ] ] ] ])
					ifTrue: [ asked add: node selector ] ] ].
	self assert: asked notEmpty.
	asked do: [ :each | self assert: (MorphicUIManager canUnderstand: each) description: each ]
