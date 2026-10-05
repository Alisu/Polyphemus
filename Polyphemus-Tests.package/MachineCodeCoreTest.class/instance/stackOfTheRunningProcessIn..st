helpers
stackOfTheRunningProcessIn: aCore

	| memory |
	memory := (SpurDumpedMemory on: (ElfCoreDump on: aCore)) reifiedMemory.
	^ memory activationsOfProcess: memory reifiedActiveProcess
