accessing
dataAddress

	"Where the VM's own data starts: its variables, not its heap."

	^ space baseAddress + (space size // 4 * 3)
