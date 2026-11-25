reading
contextPCOfMachineCodePC: anEncodedPC method: aMethodAddress inABlock: aBoolean

	"A context's pc Cog left as machine code (a negative one): this VM keeps no machine code."

	^ self refuse: #itsPcIsMachineCodeThisVMHasNone
