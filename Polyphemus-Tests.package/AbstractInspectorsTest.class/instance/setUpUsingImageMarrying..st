running
setUpUsingImageMarrying: marryInitialContext

	"Open the image in the simulator, marrying the initial context as a starting VM does. Stage
	two wants that; stage one reads the snapshot as written, all contexts."

	interpreter := self newInterpreter pluginList: { }.

	interpreter openOn: self imagePath.
	interpreter initStackPages.
	marryInitialContext ifTrue: [ interpreter loadInitialContext ].
	wordSize := memory wordSize.

	objectHeaderSize := 8 "bytes. Always.".
	emptyObjectSize := objectHeaderSize + 8 "minimum required single empty slot, to use for forwarders".

	newSpaceSize := memory newSpaceLimit - memory newSpaceStart.
	oldSpaceSize := memory oldSpaceSize.

	methodBuilder := VMCompiledCodeBuilder new
		interpreter: interpreter;
		memory: memory;
		yourself.

	stackBuilder := VMStackBuilder new
		interpreter: interpreter;
		memory: memory;
		methodBuilder: methodBuilder;
		yourself
