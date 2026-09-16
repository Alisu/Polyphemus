accessing
refusals

	"Level -> why it could not be read, for every level that failed. Worked out once."

	^ refusals ifNil: [ refusals := self check ]
