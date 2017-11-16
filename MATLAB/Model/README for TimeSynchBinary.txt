To convert real value of time synchronizer symbol:

- first convert the data into fixed point 
	for 8 bit signed with 7 fraction: 
		fiShapRudin64TimeSynchSym=fi(ShapRudin64TimeSynchSym,1,8,7);

- convert the fixed point into binary,
	use this command: 
		binShapRudin64TimeSynchSym=bin(fiShapRudin64TimeSynchSym);