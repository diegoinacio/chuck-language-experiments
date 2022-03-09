// ChucK file for recording support

// init arguments
me.arg(0) => string filename;
Std.atof(me.arg(1)) => float gain;

// dac samples
// stereo output
dac => Gain g => WvOut2 w => blackhole;

// output file name
filename => w.wavFilename;

// output gain
gain => g.gain;

// temporary solution to close file
null @=> w;

// infinity loop..
// use ctrl + c to stop recording
while(true) 1::second => now;