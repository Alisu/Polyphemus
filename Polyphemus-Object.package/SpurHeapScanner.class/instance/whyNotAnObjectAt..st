walking
whyNotAnObjectAt: anAddress

	"Why no object can begin here, or nil."

	| header |
	header := self headerAt: anAddress.
	header ifNil: [ ^ #outsideTheRegion ].
	^ self
		  whyNotAnObjectAt: anAddress
		  header: header
		  slots: (self slotsAt: anAddress header: header)
