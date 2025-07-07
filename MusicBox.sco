// Disable printing output
print_off()

// Set sample rate and number of output channels
rtsetparams(44100, 2)

// Load instrument definitions
load("WAVETABLE")
load("MMODALBAR")
load("FLANGE")
load("JDELAY")
load("REVERBIT")

// Set total duration of the piece in seconds (5 minutes)
totdur = 60 * 5

// Master amplitude scaling factor
masteramp = 1

// Envelope attack and decay times (not directly used here)
atk = 2
dcy = 4

// Define pitch table using octave.pitch notation
pitchtab = {
    3.05,3.07,3.09,3.11,4.00, 4.02,4.04,4.05,4.07,4.09,4.11,5.00,
    5.02,5.04,5.05,5.07,5.09,5.11,6.00,6.02,6.04,6.05,6.07,6.09,
    6.11,7.00,7.02,7.04,7.05,7.07
}

// Number of notes in pitch table
numnotes = len(pitchtab)

// Random seed (use a large int)
srand(irand(0, 999999999999))

// Global transposition (in octave.pitch)
trns = 3.04

// Amplitude range in decibels
maxampdb = 85
minampdb = 65

// Set control rate for control signals (higher = more resolution)
control_rate(20000)    

// Create an amplitude envelope (simple rise and fall)
env = maketable("line", 10000, 0,0, 1,1, 20,0)

// Create a harmonic wavetable
wavet = maketable("wave", 100000, 0, .25, .75, 1, .8, .5, .4, .3, .2, .1, .05, .02,0)

// Calculate amplitude difference
ampdiff = maxampdb - minampdb

// Initialise start time and pitch index
st = 0
ind = 11
index = ind

// Main time loop
while (st < totdur) 
{
    ind = 11

    // Randomised note duration
    notedur = 1.25 // 1.5 * irand(.995,1.005)

    // Constants for pitch shifting
    cnst = 2
    cnst2 = 1
    cnnfq = 3/2
    cnnptch = 0.07
    transposition = trns

    // Placeholder for conditional logic
    bar = 0

    // Move pitch index up/down randomly
    index += pickrand(-3, -1, 0, 2, 4)

    // Keep index in bounds
    if (index >= numnotes) {
        index += pickrand(-3, -1)
    } 
    if (index < 0) {
        index += pickrand(2, 4)
    }

    // Weighted random used for various modulations
    ttt = pickwrand(0.1, 40, irand(0.2,1.2), 40, 1, 20)

    // Used for rhythmic variation
    incr = notedur / pickwrand(2, 20, 1.125, 20, 2, 60) / 2

    // Interval distances (relative pitch jumps)
    alto = pickrand(2, 9)
    tenor = 5

    // Force stop condition if near end and at specific index
    if (st > totdur - 60 && st < totdur - 10 && index = ind) {
        st = totdur
    }

    // Wait offset before next note
    wait = 0

    // Dummy weighted value (unused here)
    ttttt = pickwrand(1, 80, 0, 20)

    // Transposed pitches (main + interval voices)
    pitch = pchoct(octpch(pitchtab[index]) + octpch(transposition))
    pitch2 = pchoct(octpch(pitchtab[index - alto]) + octpch(transposition))    
    pitch3 = pchoct(octpch(pitchtab[index - tenor]) + octpch(transposition))    
    pitch4 = pchoct(octpch(pitchtab[index + 3]) + octpch(transposition))

    // Final amplitude scaling with randomness
    amp = ampdb(minampdb + (ampdiff * random())) * 0.8

    // Sound type (used in MMODALBAR)
    type = 4

    // --- Instrument calls (some commented out) ---

    // Final conditional block for generating one or more layers of sound
    if (st <= totdur) {
        MMODALBAR(st + wait, notedur, amp * irand(.9, 1.3) / 12, cpspch(pitch), irand(0.05, .3) * 1.5, 1, type, 0)
        WAVETABLE(st + wait, notedur, amp * env / 6, cpspch(pitch), 1)
    }

    // Add harmonic layering if in middle of piece
    if (st > 0.5 && st < totdur - incr * 2) {
        MMODALBAR(st + wait, notedur, amp * irand(.9, 1.3) / 12, cpspch(pitch2), irand(0.05, .3), 1, type, 1)
        MMODALBAR(st + wait, notedur, amp * irand(.9, 1.3) / 12, cpspch(pitch3), irand(0.05, .3), 1, type, 0.5)

        WAVETABLE(st + wait, notedur, amp * env / 6, cpspch(pitch2) / pickwrand(1,70,2,30), 0.5)
        WAVETABLE(st + wait, notedur, amp * env / 6, cpspch(pitch3), 0.5)
    }

    // Save pitch for future use
    fbfreq = pitch

    // Advance time cursor
    st += incr

    // Force quit condition again
    if (st > totdur - 1 && index = ind) {
        st = totdur
    }

    // Optional brown noise tail (commented out)
    if (st < totdur + 5) {
        // BROWN(st, dur=notedur, amp=800, pan=0.5)
    }
}

// Reset DSP state at end (adds fade-out or zeroing depending on context)
reset(500)
