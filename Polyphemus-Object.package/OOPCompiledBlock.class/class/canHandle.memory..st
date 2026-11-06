instance creation
canHandle: anAddress memory: aMemory

	^ (aMemory isOopCompiledMethod: anAddress) and: [
		  aMemory compiledBlockClassIndex = (aMemory classIndexOf: anAddress) ]
