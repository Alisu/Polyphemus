accessing
owner

	readOnce == true ifTrue: [ ^ super owner ].
	readOnce := true.
	^ nil
