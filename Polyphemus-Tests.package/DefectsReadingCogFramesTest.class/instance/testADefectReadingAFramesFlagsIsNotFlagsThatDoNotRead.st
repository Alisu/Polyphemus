tests
testADefectReadingAFramesFlagsIsNotFlagsThatDoNotRead

	"#118: a context keeps its frames when the flags of its frame do not read; a bug of our own
	reading them is not that. The flags are the only bytes the layout reads one at a time."

	| raw space layout |
	raw := memory vmLayout raw.
	space := (DefectiveReadDouble of: raw space) when: #unsignedAt:size: answer: [ :address :size |
		         size = 1
			         ifTrue: [ 1 / 0 ]
			         ifFalse: [ raw space unsignedAt: address size: size ] ].
	layout := OOPCogLayout on: memory raw: ((DefectiveReadDouble of: raw) when: #space answer: [ space ]).

	self should: [ layout framePointerOf: context ] raise: ZeroDivide
