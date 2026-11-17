tests
testItRefusesItsOwnProcessByItsPid

	"A reader stops its target to read it: the observer stopping itself would never wake (#117)."

	self
		should: [ WindowsProcessMemory on: WindowsProcessMemory currentProcessId ]
		raise: CannotReadProcess
		withExceptionDo: [ :error | self assert: error reason equals: #itIsThisVeryImage ]
