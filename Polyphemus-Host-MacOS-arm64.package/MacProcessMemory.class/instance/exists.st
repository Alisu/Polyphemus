testing
exists

	^ (LibC system: 'ps -p ' , pid printString , ' >/dev/null 2>&1') = 0
