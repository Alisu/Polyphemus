tests
testNoReaderRedefinesWhatTheyShare

	self readers do: [ :reader |
		#( #whileStopped: #whileStoppedWhenQuiet: #whileStoppedAtASafeMoment: #hasAddress: #loadableSegments #pid #storeWord:at: #storeBytes:at: #stop #resume #writeDumpTo:
		   #unsignedAt:size: ) do: [ :selector |
			self deny: (reader includesSelector: selector) description: reader name , '>>' , selector ] ]
