reading the map
hasAddress: anAddress

	^ self segments anySatisfy: [ :each | each holdsAddress: anAddress ]
