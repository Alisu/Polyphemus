reading
hasAddress: anAddress

	"As a reader answers it: whether some region holds that byte."

	^ regions notNil and: [ regions anySatisfy: [ :each | each hasAddress: anAddress ] ]