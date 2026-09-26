finding
after: anAddress

	"The first object kept at an address above anAddress; nil if none."

	| best |
	(self holds: anAddress) ifFalse: [ ^ nil ].
	objects keysDo: [ :each |
		(each > anAddress and: [ best isNil or: [ each < best ] ]) ifTrue: [ best := each ] ].
	^ best ifNotNil: [ objects at: best ]
