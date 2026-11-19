running
methodsAllowedACatchAll

	"Each method outside the tests that catches any Error, when ForeignCode was written (#118): the
	two of ForeignCode, the boundaries where a report is made, what is not narrowed yet, and the one
	that lets go and signals again. A method leaves this list when it is narrowed; none joins it."

	^ #(
		'BlockClosure>>valueThenLetGo:'
		'DirectoryChannel>>whyExpired'
		'DirectoryChannel>>whyNotServing'
		'FileAddressSpace>>close'
		'ForeignCode class>>askingPharo:ifItFails:'
		'ForeignCode class>>askingVMMaker:ifItFails:'
		'HeldImage>>serveAndHold:startingAt:'
		'HeldImage>>whyTheInterruptWasNotTaken'
		'HeldProcess>>fix:to:restartingAt:'
		'HeldReading>>heldIn:'
		'LinuxProcessMemory class>>virtualMachineChildOf:'
		'LinuxProcessMemory class>>syscallFieldsIn:'
		'LinuxProcessMemory>>bytesAt:count:'
		'LinuxProcessMemory>>commandLine'
		'LinuxProcessMemory>>readInto:at:address:count:'
		'LinuxProcessMemory>>state'
		'MemoryMapPainter>>paintFrom:upTo:'
		'MethodSave>>tell:at:'
		'MethodSave>>writeWith:'
		'OOPAbnormalEntity>>recoverCouldBeObj'
		'OOPAbnormalEntity>>reverseDecoding'
		'OOPAbstractEntity>>storeTyped:inItemKeyed:telling:'
		'PolyphemusMCPServer>>answer:'
		'PolyphemusMCPServer>>hold:'
		'PolyphemusMCPServer>>openProcess:'
		'PolyphemusMCPServer>>whereStuck:'
		'ReifiedDebugSession>>evaluate:in:'
		'SpurHeapWatch class>>problemsOf:'
		'SpurHeapWatch>>wasWritten:at:'
		'StatForPresenterPresenter>>updateForMemory:'
		'StopHelper class>>directoryShared:else:'
		'StopHelper class>>sourceFile'
		'LinuxStuckThread>>setTask:files:codeZone:'
		'VMVariables>>startsWithAHeader:'
	)
