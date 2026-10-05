reading
readThreadsOf: aProcess

	^ self readThreadsOf: aProcess notingRunning: #(  )
