reading
uuidIn: aHeader

	"LC_UUID's sixteen bytes, or nil."

	self commandsIn: aHeader do: [ :type :at |
		(type = 16r1B and: [ at + 24 <= aHeader size ]) ifTrue: [ ^ aHeader copyFrom: at + 9 to: at + 24 ] ].
	^ nil
