reading
backEndFor: aProcessor

	"Cog's back end for #x86_64 or #aarch64, uninitialized: the map is read in its instructions
	(codeGranularity), the only thing asked of it."

	^ (aProcessor = #aarch64
		   ifTrue: [ CogARMv8Compiler ]
		   ifFalse: [ CogInLineLiteralsX64Compiler ]) basicNew
