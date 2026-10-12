running
server

	^ server ifNil: [ server := PolyphemusMCPServer new ]
