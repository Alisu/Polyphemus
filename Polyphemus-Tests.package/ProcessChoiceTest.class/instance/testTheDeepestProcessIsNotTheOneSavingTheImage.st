tests
testTheDeepestProcessIsNotTheOneSavingTheImage

	"The image was saved by a process caught in the middle of it, often the deepest: a debugger
	opened on it showed the save, not the code wanted (#92)."

	| deepest |
	deepest := Polyphemus deepestProcessIn: memory.
	self deny: ((memory contextsOfProcess: deepest) anySatisfy: [ :each |
			  #( #snapshot:andQuit: #doSnapshot ) includes: each selector ])
