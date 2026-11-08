helpers
inUIProcess: aBlock

	"aBlock's value, run by the UI process between the messages Spec deferred to it, which it would
	race from here (#31); an error it raises is raised here."

	| done result error |
	done := Semaphore new.
	self currentWorld defer: [
		[ [ result := aBlock value ] on: Error do: [ :e | error := e ] ] ensure: [ done signal ] ].
	(done waitTimeoutSeconds: 60) ifTrue: [ ^ self error: 'the UI process did not run it within 60 s' ].
	error ifNotNil: [ ^ error class new signal: error messageText ].
	^ result
