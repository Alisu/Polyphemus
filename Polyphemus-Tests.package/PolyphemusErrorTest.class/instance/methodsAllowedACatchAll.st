running
methodsAllowedACatchAll

	"Each method outside the tests that catches any Error, when ForeignCode was written (#118): the
	two of ForeignCode, the boundaries where a report is made, and what is not narrowed yet. A
	method leaves this list when its handler is narrowed; none joins it."

	^ #(
		'DirectoryChannel>>whyExpired'
		'DirectoryChannel>>whyNotServing'
		'FileAddressSpace>>close'
		'ForeignCode class>>askingPharo:ifItFails:'
		'ForeignCode class>>askingVMMaker:ifItFails:'
		'HeldImage>>serveAndHold:startingAt:'
		'HeldImage>>whyTheInterruptWasNotTaken'
		'HeldProcess>>fix:to:restartingAt:'
		'HeldReading>>heldIn:'
		'HoldLock>>take'
		'LinuxProcessMemory class>>virtualMachineChildOf:'
		'LinuxProcessMemory>>bytesAt:count:'
		'LinuxProcessMemory>>commandLine'
		'LinuxProcessMemory>>isQuiet'
		'LinuxProcessMemory>>readInto:at:address:count:'
		'LinuxProcessMemory>>state'
		'LinuxProcessMemory>>threadRegisters'
		'MemoryMapPainter>>paintFrom:upTo:'
		'MethodSave>>tell:at:'
		'MethodSave>>writeWith:'
		'OOPAbnormalEntity>>recoverCouldBeObj'
		'OOPAbnormalEntity>>reverseDecoding'
		'OOPAbstractEntity>>storeTyped:inItemKeyed:telling:'
		'PolyphemusMCPServer>>answer:'
		'PolyphemusMCPServer>>call:'
		'PolyphemusMCPServer>>hold:'
		'PolyphemusMCPServer>>inspect:'
		'PolyphemusMCPServer>>openProcess:'
		'PolyphemusMCPServer>>rowOfFrame:numbered:'
		'PolyphemusMCPServer>>rowOfProcess:numbered:in:'
		'PolyphemusMCPServer>>slot:of:named:'
		'PolyphemusMCPServer>>whereStuck:'
		'ReifiedDebugSession>>evaluate:in:'
		'SpurHeapWatch class>>problemsOf:'
		'SpurHeapWatch>>wasWritten:at:'
		'StatForPresenterPresenter>>updateForMemory:'
		'StopHelper class>>directoryShared:else:'
		'StopHelper class>>sourceFile'
		'StuckThread>>setTask:files:codeZone:'
		'VMVariables>>startsWithAHeader:'
	)
