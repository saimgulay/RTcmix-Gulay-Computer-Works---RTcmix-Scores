

print_off()
rtsetparams(44100, 2)
load("WAVETABLE")
load("FLANGE")
load("JDELAY")
load("REVERBIT")

bus_config("WAVETABLE", "aux 0-1 out")
bus_config("FLANGE", "aux 0-1 in", "aux 10-11 out")
bus_config("JDELAY", "aux 10-11 in", "aux 4-5 out")
bus_config("REVERBIT", "aux 4-5 in", "out 0-1")

totdur = 30
masteramp = .7
atk = 2; dcy = 4
a= pickwrand(5.03,50,5.04,50)
pitchtab = { 5.00, a, 5.07, 6.00}
numnotes = len(pitchtab)

pitchtab2 = { 4.07, 4.11, 5.02,5.07, 5.11}
numnotes2 = len(pitchtab2)
if (a = 5.03){
b = 4.08
}
else {
b = 4.09
}
pitchtab3 = { b, 5.00, a}
numnotes3 = len(pitchtab3)

transposition = 1.00   // try 7.00 also, for some cool aliasing...
srand(2)


// ---------------------------------------------------------------- synth ---
notedur = .5
incr = notedur /1.5
maxampdb = 92
minampdb = 75

control_rate(20000)     // need high control rate for short synth notes
env = maketable("line", 10000, 0,0, 1,1, 20,0)


ampdiff = maxampdb - minampdb
for (st = 0; st < totdur; st += incr) {
   index = trunc(random() * numnotes)
   index2 = trunc(random() * numnotes2)
   index3 = trunc(random() * numnotes3)
   pitch1 = pchoct(octpch(pitchtab[index]) + octpch(transposition))
   pitch2 = pchoct(octpch(pitchtab2[index2]) + octpch(transposition))
   pitch3 = pchoct(octpch(pitchtab3[index3]) + octpch(transposition))


stt= 0
while (stt<totdur)
{

	pitch = pickwrand(pitch1,45,pitch2,45,pitch3,10)
	stt += pickwrand(5,50,10,50)
}
   wavet = maketable("wave", 10000, 1, .9, .7, .5, .3, trand(0.1,0.9), .1, .05, .02,0.05,0.2,0.3,0.5)
   amp = ampdb(minampdb + (ampdiff * random()))
   WAVETABLE(st, notedur, amp * env, pitch, pan=random(), wavet)
   WAVETABLE(st, notedur, amp * env, pitch+trand(2,13), pan=random(), wavet)

}


// for the rest
reset(500)
amp = masteramp

// --------------------------------------------------------------- flange ---
resonance = 0.3
lowpitch = 5.00
moddepth = 90
modspeed = 0.08
wetdrymix = 0.5
flangetype = "IIR"

wavetabsize = 100000
wavet = maketable("wave", wavetabsize, "sine")
maxdelay = 1.0 / cpspch(lowpitch)

FLANGE(st=0, insk=0, totdur, amp, resonance, maxdelay, moddepth, modspeed,
       wetdrymix, flangetype, inchan=0, pan=1, ringdur=0, wavet)

wavet = maketable("wave3", wavetabsize, 1, 1, -180)
lowpitch += 0.07
maxdelay = 1.0 / cpspch(lowpitch)

FLANGE(st=0, insk=0, totdur, amp, resonance, maxdelay, moddepth, modspeed,
       wetdrymix, flangetype, inchan=1, pan=0, ringdur=0, wavet)


// ---------------------------------------------------------------- delay ---
deltime = notedur * 2.2
regen = 0.70
wetdry = 0.12
cutoff = 0
ringdur = 2.0

env = maketable("line", 1000, 0,0, atk,1, totdur-dcy,1, totdur,0)

JDELAY(st=0, insk=0, totdur, amp * env, deltime, regen, ringdur, cutoff,
		wetdry, inchan=0, pan=1)
JDELAY(st=0.02, insk=0, totdur, amp * env, deltime, regen, ringdur, cutoff,
		wetdry, inchan=1, pan=0)


// --------------------------------------------------------------- reverb ---
revtime = 1.0
revpct = 0.3
rtchandel = 0.05
cf = 0

REVERBIT(st=0, insk=0, totdur + ringdur, amp, revtime, revpct, rtchandel, cf)