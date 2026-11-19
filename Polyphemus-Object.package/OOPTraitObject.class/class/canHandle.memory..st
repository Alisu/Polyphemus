instance creation
canHandle: anAddress memory: aMemory

	^ (self isAClassAt: anAddress in: aMemory) and: [ aMemory metaclassForTraitIndex notNil and: [
		  (aMemory classIndexOf: (aMemory fetchClassOf: anAddress)) = aMemory metaclassForTraitIndex ] ]
