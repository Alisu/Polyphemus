running
namedProcess

	^ (self processesOf: self resource target) detect: [ :each | (each at: 'name') notNil ]
