tests
testCloseForgetsAReadingAndLetsGoOfWhatItReads

	"#180: no tool closed a handle, and each kept its heap and its file for the server's life. A
	reading is closed; a held image is not, which let_go and stop are for."

	| closed handle result held |
	closed := false.
	handle := self server
		          open: (PolyphemusMCPReading new
				           setKind: 'a core'
				           path: 'nowhere'
				           reified: ((DefectiveReadDouble of: Object new)
						            when: #closeWhatItReads answer: [ closed := true ];
						            yourself))
		          as: 'core'.
	result := self resultOf: 'close' with: (Dictionary new at: 'handle' put: handle; yourself).
	self deny: (result at: 'isError' ifAbsent: [ false ]).
	self assert: closed.
	self deny: (self server images includesKey: handle).
	held := self heldBy: UnaskedDouble new.
	result := self resultOf: 'close' with: (Dictionary new at: 'handle' put: held; yourself).
	self assert: (result at: 'isError').
	self assert: (((result at: 'content') first at: 'text') includesSubstring: 'let_go').
	self assert: (self server images includesKey: held)
