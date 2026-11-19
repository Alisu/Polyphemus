instance creation
canHandle: anAddress memory: aMemory

	^ (self isAClassAt: anAddress in: aMemory) and: [ (aMemory classIndexOf: (aMemory fetchClassOf: anAddress)) = aMemory traitedMetaclassIndex ]
