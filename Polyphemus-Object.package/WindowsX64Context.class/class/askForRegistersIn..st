layout
askForRegistersIn: someBytes

	"Before Windows fills it: ContextFlags says x64 (16r100000), control (1) and integer (2)."

	someBytes unsignedLongAt: 16r30 + 1 put: 16r100003
