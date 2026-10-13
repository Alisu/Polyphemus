accessing
isMachineCodeAddress: anAddress

	"Within Cog's code zone, from codeBase up to where the method zone is free."

	^ anAddress between: (self at: 'codeBase') and: (self at: 'mzFreeStart') - 1
