reading processes
processExists: aPid

	^ (LibC system: 'ps -p ' , aPid printString , ' >/dev/null 2>&1') = 0
