running
setUpUsingImageMarrying: marryInitialContext

	"Open the image in the simulator. Marrying the initial context is what a VM does
	when it starts an image: it takes the running process' context and gives it a
	frame to run in. Stage two wants that. Stage one does not: it reads the snapshot
	as written, where every stack is contexts and nothing is married."

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
