tests
testNoReaderRedefinesWhatTheyShare

	self readers do: [ :reader |
		#( #whileStopped: #whileStoppedWhenQuiet: #hasAddress: #loadableSegments #pid #storeWord:at:
		   #unsignedAt:size: ) do: [ :selector |
			self deny: (reader includesSelector: selector) description: reader name , '>>' , selector ] ]
