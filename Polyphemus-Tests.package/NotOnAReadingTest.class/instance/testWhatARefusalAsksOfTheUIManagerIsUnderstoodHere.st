tests
testWhatARefusalAsksOfTheUIManagerIsUnderstoodHere

	"#142: a refusal, or a held image gone, asks UIManager default (or the one it is given) for
	things each Pharo names its own way; Pharo 13 has no spawnNewProcessIfThisIsUI:."

	| asked |
	asked := Set new.
	{ NotOnAReading >> #defaultAction. NotOnAReading >> #tellWith:. HeldImageGone >> #defaultAction. HeldImageGone >> #tellAbout:with: }
		do: [ :method |
			method ast allChildren do: [ :node |
				(node isMessage and: [
					 (node receiver isVariable and: [ node receiver name = #aUIManager ]) or: [
						 node receiver isMessage and: [
							 node receiver selector = #default and: [
								 node receiver receiver isVariable and: [ node receiver receiver name = #UIManager ] ] ] ] ])
					ifTrue: [ asked add: node selector ] ] ].
	self assert: (asked includes: #confirm:trueChoice:falseChoice:).
	asked do: [ :each | self assert: (MorphicUIManager canUnderstand: each) description: each ]
