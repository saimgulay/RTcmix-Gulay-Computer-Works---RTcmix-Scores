

print_off()
rtsetparams(44100, 2)
load("WAVETABLE")
load("MMODALBAR")

load("WAVETABLE")
load("FLANGE")
load("JDELAY")
load("REVERBIT")






totdur = 60*5
masteramp = 1
atk = 2; dcy = 4



pitchtab = { 3.05,3.07,3.09,3.11,4.00, 4.02,4.04,4.05,4.07,4.09,4.11,5.00,5.02,5.04,5.05,5.07,5.09,5.11,6.00,6.02,6.04,6.05,6.07,6.09,6.11,7.00,7.02,7.04,7.05,7.07}

numnotes = len(pitchtab)


srand(irand(0,999999999999))


trns= 3.04


maxampdb = 85
minampdb = 65

control_rate(20000)    
env = maketable("line", 10000, 0,0, 1,1, 20,0)
wavet = maketable("wave", 100000, 0, .25, .75, 1, .8, .5, .4, .3, .2, .1, .05, .02,0)

ampdiff = maxampdb - minampdb
st = 0
ind = 11
index = ind

while ( st < totdur) 
{
ind = 11
	notedur = 1.25//1.5*irand(.995,1.005)

cnst = 2
cnst2= 1
	cnnfq= 3/2
	cnnptch = 0.07
	transposition = trns
	bar = 0
    index += pickrand(-3,-1,0,2,4)

	if (index >=numnotes) {
	index += pickrand(-3,-1)
	} 
 	if (index < 0){
	index += pickrand(2,4)
	}

   ttt = pickwrand(0.1,40,irand(0.2,1.2),40,1,20)

   incr = notedur/pickwrand(2,20,1.125,20,2,60)/2
	alto = pickrand(2,9)
	tenor = 5
if (st>totdur-60&&st<totdur-10&&index=ind){
st = totdur
}
wait = 0
   ttttt = pickwrand(1,80,0,20)
   pitch = pchoct(octpch(pitchtab[index]) + octpch(transposition))
   pitch2 = pchoct(octpch(pitchtab[index-alto]) + octpch(transposition))	
   pitch3 = pchoct(octpch(pitchtab[index-tenor]) + octpch(transposition))	
   pitch4 = pchoct(octpch(pitchtab[index+3]) + octpch(transposition))
   amp = ampdb(minampdb + (ampdiff * random()))*0.8
type = 4

//WAVETABLE(7.5+st, notedur, amp * env/16,  cpspch(pitch), 0)
//WAVETABLE(7.5+st+notedur, notedur*1.01, amp * env/16,  cpspch(pitch)*cnnfq, 1)
//MMODALBAR(st, notedur, amp/2*irand(.9,1.3), cpspch(pitch), irand(0.05,.3)*1.5, 1, type,0)
//MMODALBAR(st+notedur, notedur, amp/2*irand(.9,1.3), cpspch(pitch)*cnnfq*1.5, irand(0.05,.3), 1, type,1)

//MMODALBAR(st, notedur, amp*irand(.9,1.3), cpspch(pitch)/2, irand(0.05,.3)*1.5, 1, type,1)
//MMODALBAR(st+notedur, notedur, amp*irand(.9,1.3)*pickwrand(0,40,1,60), cpspch(pitch)/2*cnnfq, irand(0.05,.3), 1, type,0)
//WAVETABLE(st+notedur*1.1, notedur*1.01, amp * env/16,  cpspch(pitch)*cnnfq, 1)
//MMODALBAR(st, notedur, amp/4*irand(.9,1.3), cpspch(pitch2)/2, irand(0.05,.3), 1, type,0)
//MMODALBAR(st, notedur, amp/4*irand(.9,1.3), cpspch(pitch3)/2, irand(0.05,.3), 1, type,0.5)
//BROWN(st,incr, amp=15000, pan=0.5)
if (st<=totdur){

MMODALBAR(st+wait, notedur, amp*irand(.9,1.3)/12, cpspch(pitch), irand(0.05,.3)*1.5, 1, type,0)
//MMODALBAR(st+notedur+wait, notedur, amp*irand(.9,1.3)/2, cpspch(pitch)*cnnfq, irand(0.05,.3)*1.5, 1, type,.85)
WAVETABLE(st+wait, notedur, amp * env/6,  cpspch(pitch), 1)



}
if (st>0.5&&st<totdur-incr*2){
MMODALBAR(st+wait, notedur, amp*irand(.9,1.3)/12, cpspch(pitch2), irand(0.05,.3), 1, type,1)
MMODALBAR(st+wait, notedur, amp*irand(.9,1.3)/12, cpspch(pitch3), irand(0.05,.3), 1, type,0.5)

//WAVETABLE(st+wait+notedur, notedur, amp * env/12,  cpspch(pitch)*cnnfq, 0)
WAVETABLE(st+wait, notedur, amp * env/6,  cpspch(pitch2)/pickwrand(1,70,2,30), .5)
WAVETABLE(st+wait, notedur, amp * env/6,  cpspch(pitch3), 0.5)
}
//BROWN(st, dur=notedur, amp=1000, pan=0.5)*/
   fbfreq = pitch
   st += incr


if (st>totdur-1&&index=ind){
st=totdur
}
if (st<totdur+5){
//BROWN(st, dur=notedur, amp=800, pan=0.5)
}

}






reset(500)













