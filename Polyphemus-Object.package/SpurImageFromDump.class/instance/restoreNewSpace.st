writing
restoreNewSpace

	"Where the dumped VM's new space was, and how much of eden it had used (#8). Its
	survivors are where the spaces say, the VM having been between collections."

	dumped takeNewSpaceFromTheDumpIn: dumped memory.
	(self rememberedSetOf: dumped memory) instVarNamed: #previousRememberedSetSize put: 0
