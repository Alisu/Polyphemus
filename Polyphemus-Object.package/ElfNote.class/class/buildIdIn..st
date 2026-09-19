reading
buildIdIn: aByteArray

	"The description of the GNU build-id note (type 3), or nil."

	self in: aByteArray do: [ :type :name :description |
		(type = 3 and: [ name = 'GNU' ]) ifTrue: [ ^ description ] ].
	^ nil
