finding
atOrBefore: anAddress

	"The object kept at anAddress, or the last one below it."

	| best |
	(self holds: anAddress) ifFalse: [ ^ NotFound signal ].
	objects keysDo: [ :each |
		(each <= anAddress and: [ best isNil or: [ each > best ] ]) ifTrue: [ best := each ] ].
	^ best ifNil: [ NotFound signal ] ifNotNil: [ objects at: best ]
