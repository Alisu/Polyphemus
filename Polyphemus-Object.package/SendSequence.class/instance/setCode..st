initialization
setCode: aCompiledCode

	"Decode, keeping every pc as an offset from the first bytecode: the file's code and ours
	count their pcs from different places, and only offsets compare."

	| scanner |
	code := aCompiledCode.
	starts := OrderedCollection new.
	sends := OrderedCollection new.
	scanner := InstructionStream on: code.
	origin := scanner pc.
	[ scanner atEnd ] whileFalse: [
		current := scanner pc - origin.
		starts add: current.
		scanner interpretNextInstructionFor: self ]
