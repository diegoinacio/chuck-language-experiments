// Diego Inácio • 2018
// github.com/diegoinacio
/*
Arpeggios and notes defined by an unidimensional cellular automation.
Execution: $ chuck arpeggios_cellularAutomaton1D.ck
Recording: $ python _record.py --cks arpeggios_cellularAutomaton1D.ck --mono
*/

fun int bin_dec(int bin[]){
    // binary to decimal conversion
    // input: inverted index array of bits
    // output: value in decimal
    0 => int dec;
    for(0 => int i; i < bin.size(); i++){
        Math.pow(2, i) $ int => int pow;
        bin[i]*(pow) +=> dec;
    }
    return dec;
}

fun int[] dec_bin(int dec, int bits){
    // decimal to binary conversion
    // entrada: value in decimal (dec) and bit depth
    // saída: inverted index array of bits
    int bin[bits];
    dec => int num;
    for(0 => int i; i < bits; i++){
        dec % 2 => bin[i];
        dec/2 => dec;
    }
    return bin;
}

fun int summation(int S[]){
    // sum operator
    // saída: sum all array elements
    S.size() => int size;
    0 => int sum;
    for(0 => int i; i < size; i++){
        S[i] +=> sum;
    }
    return sum;
}

fun int[] automata(int geno[], int rule, int diameter){
    // binary value cellular automaton 1D
    // input: - last generation array (geno)
    //        - automaton rule. Integer value different from zero
    //        - cell diameter
    // output: next generation (geni) based on last generation (geno)
    geno.size() => int size;
    int geni[size];
    int cell[diameter];
    diameter/2 => int radius;
    // defines the number of bits for the rule set
    Math.pow(2, diameter) $ int => int pow;
    dec_bin(rule, pow) @=> int ruleset[];
    for(0 => int i; i < size; i++){
        // next generation positions
        for(0 => int j; j < diameter; j++){
            // last generation positions
            j + i - radius => int k;
            k >= 0 ? k % size : (size + k) % size => int K;
            geno[K] => cell[j];
        }
        ruleset[bin_dec(cell)] => geni[i];
    }
    return geni;
}

////////////////
// parameters //
////////////////
22 => int size;          // size of each CA generation
225 => int rule;         // automaton rule
1 => int radius;         // cell radius
36 => int mo;            // reference MIDI note
100::ms => dur duration; // duration of each arpeggio's note

//////////
// init //
//////////
int ger[size];
// random initialization of the generation 0
for(0 => int i; i < size; i++){
    Math.random2(0, 1) => ger[i];
}
// defines cell diameter
2*radius + 1 => int diameter;

SinOsc s => dac;

// ! infinity time loop..
// ! use ctrl + c to stop the program
while(true){
    bin_dec(ger) % size => int key;
    summation(ger) => int sum;
    // condition which defines if the arpeggio 
    // will ascend or descend
    (key + sum) % 2 => int cnd;
    for((cnd ? 0 : size - 1) => int i;
        cnd ? (i < size) : (i >= 0);
        cnd ? i++ : i--){
        if(ger[i]){
            Std.mtof(key + sum + mo + i) => s.freq;
            duration => now;
        }
    }
    automata(ger, rule, diameter) @=> ger;
}