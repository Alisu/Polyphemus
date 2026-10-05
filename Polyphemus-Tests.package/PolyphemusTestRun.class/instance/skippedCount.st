accessing
skippedCount

	^ (outcomes select: [ :each | each value = #skipped ]) size
