tests
testEveryFrameNamesItsSelector

	"#3: a method Cog compiled has its CogMethod's address where its header was. Read as a
	header, that gave a wrong literal count, and the selector read as unreadable."

	self allFrames do: [ :each | self deny: each selector equals: #unknownSelector ]
