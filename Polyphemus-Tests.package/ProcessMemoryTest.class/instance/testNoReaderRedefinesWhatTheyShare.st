tests
testNoReaderRedefinesWhatTheyShare

	self readers do: [ :reader |
		#( #whileStopped: #whileStoppedWhenQuiet: #whileStoppedAtASafeMoment: #hasAddress: #loadableSegments #pid #storeWord:at:
		   #unsignedAt:size: ) do: [ :selector |
			self deny: (reader includesSelector: selector) description: reader name , '>>' , selector ] ]
