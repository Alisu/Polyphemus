printing
nativeDebuggerCommand

	^ 'lldb -p ' , pid printString , ' --batch -o ''thread backtrace'''
