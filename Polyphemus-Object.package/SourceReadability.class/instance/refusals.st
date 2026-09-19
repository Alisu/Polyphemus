accessing
refusals

	"Level -> why it could not be read. Worked out once."

	^ refusals ifNil: [
		  refusals := Dictionary new.
		  self checkSource ifNotNil: [ :why | refusals at: #source put: why ].
		  refusals ]
