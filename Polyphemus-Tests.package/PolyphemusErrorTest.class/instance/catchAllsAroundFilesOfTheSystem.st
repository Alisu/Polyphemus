accessing
catchAllsAroundFilesOfTheSystem

	"A file of /proc, of a hold's directory or of the stop helper, read while its process may end
	or another writes it; a stream being closed. The block holds the file's reading and no more."

	^ #( 'DirectoryChannel>>whyExpired' 'DirectoryChannel>>whyNotServing' 'FileAddressSpace>>close'
	     'LinuxProcessMemory class>>syscallFieldsIn:' 'LinuxProcessMemory class>>virtualMachineChildOf:'
	     'LinuxProcessMemory>>bytesAt:count:' 'LinuxProcessMemory>>commandLine' 'LinuxProcessMemory>>readInto:at:address:count:'
	     'LinuxProcessMemory>>state' 'LinuxStuckThread>>setTask:files:codeZone:' 'StopHelper class>>directoryShared:else:'
	     'StopHelper class>>sourceFile' )
