tests
testTheLibraryStartsWhereItsHeaderIs

	"macOS may name several regions as the VM library at offset 0, a small one before its code
	that reads as zeros: its start is the one with a header, not the lowest (#104)."

	| memory path |
	path := '/Applications/Pharo.app/Contents/MacOS/Plugins/libPharoVMCore.dylib'.
	memory := RegionsDouble new.
	memory mapFile: path from: 16r10504C000 to: 16r105050000.
	memory region: 16r10504C000 bytes: (ByteArray new: 16r4000) writable: false.
	memory mapFile: path from: 16r105050000 to: 16r105060000.
	memory region: 16r105050000 bytes: #[ 16rCF 16rFA 16rED 16rFE ] , (ByteArray new: 16r10000 - 4) writable: false.
	self assert: (VMVariables on: memory) base equals: 16r105050000
