// Configure audio engine: 44.1kHz sample rate, 4 output channels
rtsetparams(44100, 4)

// Load required opcodes:
// STRUM2 for guitar-like strumming
// WAVETABLE for waveform synthesis
// MULTEQ for multi-band equalisation
load("STRUM2")
load("WAVETABLE")
load("MULTEQ")

// Initialise random seed with a pseudo-random value for variation
srand(trand(1, 2500))

// Create an envelope table: attacks, sustain and decay shapes
env = maketable("line", 10000,
    0, 0,        // start at zero amplitude
    1, 0.75,     // ramp up to 75% at time index 1
    2, 1,        // peak amplitude at time index 2
    3, 0.95,     // slight decay at time index 3
    4, 0)        // return to zero at index 4

// Base amplitude for strummed notes
amp = 5000

// Maximum number of chord progressions to generate
maxLoops = 100
srand(13)  // Reset seed for reproducible results

a = 2.5    // Base duration (in seconds) for harmonic sections

// Variable to track total progression duration
progress = 0

// Main loop: continue until accumulated progression exceeds maxLoops
while (progress < maxLoops) {
    // Random transposition offset for pitch variation
    t = pickwrand(-1.00, 40, 0.00, 60)

    // Random base pitch offset for chord selection
    p = pickwrand(-1,10, 0,10, 1,40, 2,20, 3,5, 4,15)

    // Initialise incremental counters
    kk = 0
    kk += 0.25

    // Scale factor controls rhythmic density
    c = pickrand(0.5,1,2) * irand(0.995,1.005) * pickrand(0.25,0.5,1,2) / 1.5
    notedur = c * 100            // Duration of each note
    c *= irand(0.001,4)         // Further randomise density

    // Define chord tone sets: I, I6, IV, V, V7, and iiº
    I   = { pickwrand(5.00,20, 6.00,20, 7.00,80), 7.07, 8.00, 8.07, 9.03985 + pickrand(-1,0) }
    I6  = { 7.03985, 7.07, 8.00 }
    IV  = { 6.05, 7.0915, 8.00, 8.05 }
    V   = { 6.07, 6.1115, 7.02, 7.07 }
    V7  = { 6.07, 6.1115, 7.02, 7.05, 7.05 }
    iio = { 5.1115, 6.1115, 7.02, 7.05, 7.09 }

    // Determine lengths of each chord array
    lI   = len(I)
    lI6  = len(I6)
    lIV  = len(IV)
    lV   = len(V)
    lV7  = len(V7)
    liio = len(iio)

    /*
       Section breakdown:
       1) Tonic (I)
       2) Dominant (V)
       3) Dominant 7th (V7)
       4) First inversion (I6)
       5) Tonic reprise
       6) Mixed chord vamp
       7) Supertonic diminished (iiº)
       8) Dominant 7th reprise
       9) Final cadential progression (I, IV, iiº, V, V7, I6, V7, I)
    */

    // 1) Tonic section
    for (st = 0; st < a; st += incr) {
        incr = pickwrand(0.125,10, 0.25,30, 0.5,30, 1,30) * c
        pindexI = trand(0, lI)
        pitch = I[pindexI] + p
        STRUM2(st, notedur, amp, pitch + t, 1, 1.0, random())
    }

    // 2) Dominant section
    for (st = a; st < a * 1.5; st += incr) {
        incr = pickwrand(0.125,10, 0.25,30, 0.5,30, 1,30) * c
        pindexV = trand(0, lV)
        pitch = V[pindexV] + p
        STRUM2(st, notedur, amp, pitch + t, 1, 1.0, random())
    }

    // 3) Dominant 7th section
    for (st = a * 1.5; st < 2 * a; st += incr) {
        incr = pickwrand(0.125,10, 0.25,30, 0.5,30, 1,30)
        pindexV7 = trand(0, lV7)
        pitch = V7[pindexV7] + p
        STRUM2(st, notedur, amp, pitch + t, 1, 1.0, random())
    }

    // 4) First inversion section
    for (st = 2 * a; st < 3 * a; st += incr) {
        incr = pickwrand(0.125,10, 0.25,30, 0.5,30, 1,30) * c
        pindexI6 = trand(0, lI6)
        pitch = I6[pindexI6] + p
        STRUM2(st, notedur, amp, pitch + t, 1, 1.0, random())
    }

    // 5) Tonic reprise (softer dynamic)
    for (st = 3 * a; st < 4 * a; st += incr) {
        incr = pickwrand(0.125,10, 0.25,30, 0.5,30, 1,30) * c
        pindexI = trand(0, lI)
        pitch = I[pindexI] + p
        STRUM2(st, notedur, amp * 0.85, pitch + t, 1, 1.0, random())
    }

    // 6) Mixed chord vamp with slight rhythmic variation
    for (st = 4 * a; st < 8 * a; st += incr / pickwrand(1,70, 2,30)) {
        incr = pickwrand(0.125,10, 0.25,30, 0.5,30, 1,30) * c
        pI   = trand(0, lI)
        pI6  = trand(0, lI6)
        pV7  = trand(0, lV7)
        pitch = pickwrand(I[pI], 33.3333,
                           V7[pV7], 33.3333,
                           I6[pI6], 33.3333) + p
        STRUM2(st, notedur, amp, pitch + 1 + t, 1, 1.0, random())
        STRUM2(st + notedur, notedur, amp, pitch + 1.07 + t, 1, 1.0, random())
    }

    // 7) Supertonic diminished section
    for (st = 6 * a; st < 7 * a; st += incr) {
        incr = pickwrand(0.125,5, 0.25,35, 0.5,30, 1,30) * c
        pindexiio = trand(0, liio)
        pitch = iio[pindexiio] + p
        STRUM2(st, notedur, amp, pitch + t, 1, 1.0, random())
    }

    // 8) Dominant 7th reprise
    for (st = 7 * a; st < 10 * a; st += incr) {
        incr = pickwrand(0.125,5, 0.25,35, 0.5,30, 1,30) * c
        pindexV7 = trand(0, lV7)
        pitch = V7[pindexV7] + p
        STRUM2(st, notedur, amp, pitch + t, 1, 1.0, random())
    }

    // Cadential progression: I, IV, iiº, V, V7, I6, V7, I
    // 9a) Tonic finalize
    for (st = 10 * a; st < 11 * a; st += incr) {
        incr = pickwrand(0.125,5, 0.25,35, 0.5,30, 1,30) * c
        pindexI = trand(0, lI)
        pitch = I[pindexI] + p
        STRUM2(st, notedur, amp, pitch + t, 1, 1.0, random())
    }
    // 9b) Subdominant (IV)
    for (st = 11 * a; st < 12 * a; st += incr) {
