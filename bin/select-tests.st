"The test classes the changes listed in $POLYPHEMUS_CHANGES call for (bin/commit-selection.sh),
 as this image knows them (TestImpact): CLASS lines, and WIDE for selectors left to CI."
| lines impact |
lines := ((OSEnvironment current at: 'POLYPHEMUS_CHANGES') asFileReference contents lines)
	reject: [ :each | each trimBoth isEmpty ].
impact := TestImpact fromLines: lines.
impact testClasses do: [ :each | ('CLASS ' , each name) traceCr ].
impact wideSelectors do: [ :each | ('WIDE ' , each) traceCr ].
Smalltalk exitSuccess
