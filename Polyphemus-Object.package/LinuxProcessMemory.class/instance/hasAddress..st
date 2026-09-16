reading
hasAddress: anAddress

	^ self segments anySatisfy: [ :each | each holdsAddress: anAddress ]
