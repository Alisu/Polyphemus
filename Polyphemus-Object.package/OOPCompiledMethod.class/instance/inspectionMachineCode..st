inspection
inspectionMachineCode: aBuilder
	<inspectorPresentationOrder: 40 title: 'Machine code'>

	"What Cog compiled of this method, read only: no disassembly, which would take FFI (#95)."

	^ aBuilder newText
		  text: (self machineCodeText ifNil: [ '' ]);
		  beNotEditable;
		  yourself
