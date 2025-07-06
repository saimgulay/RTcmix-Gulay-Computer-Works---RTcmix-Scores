
print_off()
rtsetparams(44100, 2)
load("WAVETABLE")
load("WAVY")
load("FLANGE")
load("JDELAY")
load("REVERBIT")
load("MMODALBAR")

bus_config("MMODALBAR", "aux 4-5 out")
bus_config("WAVETABLE", "aux 0-1 out")
bus_config("WAVY", "aux 0-1 out")
bus_config("FLANGE", "aux 0-1 in", "aux 10-11 out")
bus_config("JDELAY", "aux 10-11 in", "aux 4-5 out")
bus_config("REVERBIT", "aux 4-5 in", "out 0-1")

totdur = 60*5
masteramp = 1.5

ax = 0
expr = "a * b " 


srand(trand(0,12999))


// ---------------------------------------------------------------- synth ---

maxampdb = 92.5
minampdb = 70

a = pickwrand(5.03,50,5.04,50)

control_rate(30000)     // need high control rate for short synth notes
env = maketable("line", 10000, 0,0, 1,1, 20,0)
env2 = maketable("line", 10000, 0,0, 1,1, 20,0)

wavet = maketable("wave", 32767, 1, .9, .7, .5, .3, .2, .1, .05, .02, 0.07, 0.1, 0.25,0.5,0.7,1)
 wavetA = maketable("wave", 5000, "sine")
   wavetB = maketable("wave", 5000, "tri")
st = 0
ampdiff = maxampdb - minampdb
viols = 0
if ( viols <1)
{
viols +=0.005
}
while (st < totdur) {

atk = irand(0,10); dcy = irand(1,5)
//wavet = maketable("wave", 10000, 1, irand(.7,.9), irand(.6,.8), irand(.5,.7), irand(.3,.5), irand(.2,.4), irand(.1,0.3), irand(.03,.05), irand(.01, .03))
//wavet = maketable("wave", 10000, 1, irand(0.01,1), irand(0.01,1), irand(0.01,1), irand(0.01,1), irand(0.01,1),irand(0.01,1), irand(0.01,1), irand(0.01,1))

if ( a = 5.037) {
h = 5.033
}
else {
h = 5.037
}
if (st<totdur/4||st>totdur/1.15/*||st=ss*/ )
{

x = a

}
else 
{
x = h
}
pitchtab = pickwrand( 5.00,33, x,33, 5.07,33)
numnotes = len(pitchtab)
pitchtab2 = pickwrand( 4.07,33, 4.11,33, 5.02,33)
numnotes2 = len(pitchtab2)


pitchtab = {5.00+pickwrand(0,99.9,0.01,0.1),33, x,33, 5.07,33}
numnotes = len(pitchtab)
pitchtab2 = { 4.07,33, 4.11,33, 5.02,33}
numnotes2 = len(pitchtab2)


if (x=5.033) {
b = 5.078
}
else {
b = 5.096
}
gliss = maketable("line", "nonorm", 1000, 0,irand(0.99, 1.0125), 1,pickwrand(1,95, 2, 5) ) 
const = pickwrand(0.5, 10, 0.75,33, 1,28 , 1.5,20, pickwrand(2,30,4,70), 5)/pickwrand(1,57, 2,3,4,3.33,8,3.33, 2/2,30,16,3.333)
transposition = pickwrand(0.00,25, 1.00,74.5, 0.07,0.5) +7 
env2 +=0.01 
ss= irand(1,totdur)
a=pickwrand(5.03, 50,5.04,50)
notedur = pickwrand(0.25,75, 0.5,25)
notedur2 = pickwrand(0.125, 12.5, 0.25,75, 0.5,7.5, 0.083,5) * const
notedur3 =  pickwrand(0.125, 12.5, 0.25,75, 0.5,7.5, 0.083,5) * const * pickwrand(1,40,0.5,30,1.333,30)
incr = (notedur3 - notedur3/2.25)*pickrand(.25,.5,1,2)
pitchtab3 = { b,33, 5.12,33, x+1,33}
numnotes3 = len(pitchtab3)
if (st<totdur/9) {
yy = 5 
}
if (st>totdur/9&&st<2*totdur/9) {
yy = 30
}
if (st>2*totdur/9) {
yy = 10
}
	x =50 //pickwrand(irand(15,100),12.5, 75,75, 15,12.5)
   realpitchtab = {pickwrand(pitchtab,x,  pitchtab2, 100-yy-x), pitchtab3, yy}
   index = trunc(random() * numnotes)
   index2 = trunc(random() * numnotes2)
   pitch = pchoct(octpch(realpitchtab[index]) + octpch(transposition)) -0
   //pitch2 = pchoct(octpch(pitchtab2[index2]) + octpch(transposition))
   amp = ampdb(minampdb + (ampdiff * random())) *5

	WAVETABLE(st+notedur2*22, notedur3 * const*10, amp/2 *env*irand(2,2.5)*viols, pitch+pickwrand(4,30, 2,25, 3,45)+1+pickwrand(2,10,4,90), ppp=irand(-0.75,0.75), wavet)
	WAVY(st, notedur2*10, irand(0.1,0.375)*pickwrand(0,99.5,1,0.5)*amp*4* env*irand(0.06125,0.1)/8, pitch*gliss, pitchtab3/4, random(), wavet, random(), expr, irand(-0.75,0.75))
	WAVETABLE(st+notedur2*12, notedur3 * const, amp/2 *env*irand(2,2.5)*viols, pitch+1+pickwrand(4,30, 2,25, 3,45)+pickwrand(2.5,10,4.5,80), irand(-0.75,0.75), wavet)
	WAVY(st, notedur2, irand(0.2,0.75)*pickwrand(0,99.5,1,0.5)*amp *4* env*irand(0.06125,0.1)/2, pitch+trand(-2,2), pitchtab3/4, random(), wavet, random(), expr, irand(-0.75,0.75))
    MMODALBAR(st, notedur3, pickrand(0,1,0.5,0.25)*amp*5*0.025*pickwrand(0,70,1,30), pitch+pickrand(0,2,1,4,50,100,200), irand(0.25,1), irand(0.2,0.8), pickwrand( 0,37.5, 5,12.5, 7,25, 2,25 ),random(), env)

	freq = 523/2//pickrand(0.5,1,2,4)
	k =  { 1, 1.5, 1.265625, 0.75 }
	
	numnotes = len(k)
	index = trand(numnotes)
	n = k[index]
	freq *= n

if (st>totdur/2&&st<totdur/1.3){
	WAVETABLE(st, notedur2, 0.0075 * amp * env/6, freq*4 )
	WAVETABLE(st+notedur2, notedur2, 0.0075 * amp * env/6, freq*4 *1.5)
}
	
	WAVY(st+notedur2*1.1, notedur2*1.1, amp * env/990, freq*gliss, pitch-3,0.5, wavet, 1, expr, irand(-.75,0.75),wavetA)
	WAVY(st+notedur2*1.1*2, notedur2*1.1, amp * env/600, freq*gliss*1.5, pitch-3,0.5, wavet, 1, expr, irand(-.75,0.75),wavetA)
	

	st += incr
if ( st>totdur/8) {
ax = pickrand(pickwrand(irand(0.00,0.05),90,0.01,2,0.01,2,0.01,2,0.01,2,pickrand(1,2),2)/2,(pickrand(ax+pickwrand(irand(0.00,0.05),90,0.01,2,0.01,2,0.01,2,0.01,2,pickrand(1,2),2)/2, ax-pickwrand(irand(0.00,0.05),90,0.01,2,0.01,2,0.01,2,0.01,2,pickrand(1,2),2)/2)))
}
else {
ax = pickwrand(irand(0.005,0.05),90,0.01,2,0.00,2,0.01,2,0.01,2,pickrand(1,2),2)/2
}
}	

// for the rest
reset(500)
amp = masteramp

// --------------------------------------------------------------- flange ---
resonance = ax
lowpitch = 9.00
moddepth = 99
modspeed = 0.005
wetdrymix = 0.75
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
deltime = notedur * 5
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
revtime =  2
revpct = 0.3
rtchandel = 0.05
cf = 0

REVERBIT(st=0, insk=0, totdur + ringdur, amp, revtime, revpct, rtchandel, cf)