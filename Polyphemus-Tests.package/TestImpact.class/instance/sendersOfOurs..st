private
sendersOfOurs: aSelector

	senders ifNil: [ self indexOurMethods ].
	^ senders at: aSelector ifAbsent: [ #(  ) ]
