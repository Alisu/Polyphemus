testing
hasAddress: anAddress

	^ pieces anySatisfy: [ :each | each hasAddress: anAddress ]
