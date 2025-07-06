/*----------------------------------------------------------------------------
 * RTcmix score
 * Description:
 *   Evolving bowed-synth piece with chained flange → delay → reverb.
 *   Original functionality preserved; code formatted for readability.
 * Requirements:
 *   - RTcmix 5.x
 *   - Stereo output @ 44.1 kHz
 *----------------------------------------------------------------------------*/

print_off();
rtsetparams(44100, 2);

load("WAVETABLE");
load("FLANGE");
load("JDELAY");
load("REVERBIT");
load("MBOWED");
load("MMESH2D");

bus_config("MBOWED", "aux 0-1 out");
bus_config("FLANGE", "aux 0-1 in",   "aux 10-11 out");
bus_config("JDELAY", "aux 10-11 in", "aux 4-5 out");
bus_config("REVERBIT", "aux 4-5 in", "out 0-1");

totdur       = 60 * 3;
masteramp    = 1;
atk          = 2; 
dcy          = 4;

pitchtab = {
  4.11, 5.00, 5.02, 5.04, 5.05, 5.07, 5.09, 5.11,
  6.00, 6.02, 6.04, 6.05, 6.07, 6.09, 6.11, 7.00
};
numnotes      = len(pitchtab);

transposition = 3.07;
srand(trand(0, 9999999999999));

// ---------------------------------------------------------------- synth ---

maxampdb   = 92;
minampdb   = 75;

control_rate(20000);

env  = maketable("line", 10000,
                 0, 0,
                 1, 1,
                 20, 0);
wavet = maketable("wave", 10000,
                  1,    .9,  .7,  .5,
                  .3,   .2,  .1,  .05, .02);

ampdiff = maxampdb - minampdb;
st       = 0;
index    = 8;

while (st < totdur) {
  notedur = pickwrand(0.25,10,
                      0.5, 75,
                      1,   7,
                      2,   3);
  incr    = notedur / 2;

  index += pickrand(-3, -1, 0, 2, 4);
  if (index >= numnotes) {
    index += pickrand(-3, -1);
  } 
  if (index < 0) {
    index += pickrand(2, 4);
  }

  pitch = pchoct(octpch(pitchtab[index]) + octpch(transposition));
  amp   = ampdb(minampdb + (ampdiff * random()));

  bowvelenv   = maketable("line", 1000, 0,0, 1,1, 2,0);
  bowpressenv = maketable("line", 1000, 0,0, 1,1, 2,0);
  bowposenv   = maketable("line", 1000, 0,1, 1,0, 3,1);
  vibwave     = maketable("wave", 1000, "sine");

  MBOWED(st,         notedur, amp * env,
         cpspch(pitch), 5, 5, 0.01, 0.5,
         bowvelenv, bowpressenv, bowposenv, vibwave, wavet);

  MBOWED(st + notedur, notedur, amp * env,
         cpspch(pitch) * 1.5, 5, 5, 0.01, 0.5,
         bowvelenv, bowpressenv, bowposenv, vibwave, wavet);

  st += incr;
}

// for the rest
reset(500);
amp = masteramp;

// --------------------------------------------------------------- flange ---

resonance   = 0.025;
lowpitch    = 5.00;
moddepth    = 90;
modspeed    = 0.08;
wetdrymix   = 0.5;
flangetype  = "IIR";

wavetabsize = 100000;
wavet       = maketable("wave", wavetabsize, "sine");
maxdelay    = 1.0 / cpspch(lowpitch);

FLANGE(st=0, insk=0, totdur, amp,
       resonance, maxdelay, moddepth, modspeed,
       wetdrymix, flangetype,
       inchan=0, pan=1, ringdur=0, wavet);

wavet = maketable("wave3", wavetabsize, 1, 1, -180);
lowpitch += 0.07;
maxdelay  = 1.0 / cpspch(lowpitch);

FLANGE(st=0, insk=0, totdur, amp,
       resonance, maxdelay, moddepth, modspeed,
       wetdrymix, flangetype,
       inchan=1, pan=0, ringdur=0, wavet);

// ---------------------------------------------------------------- delay ---

deltime = notedur * 2;
regen   = 0.0001;
wetdry  = 0.06;
cutoff  = 0.0;
ringdur = notedur * 2;

env = maketable("line", 1000,
                0,0,
                atk,1,
                totdur - dcy, 1,
                totdur, 0);

JDELAY(st=0,    insk=0, totdur, amp * env,
       deltime, regen, ringdur, cutoff,
       wetdry, inchan=0, pan=1);

JDELAY(st=0.02, insk=0, totdur, amp * env,
       deltime, regen, ringdur, cutoff,
       wetdry, inchan=1, pan=0);

// --------------------------------------------------------------- reverb ---

revtime   = 0.5;
revpct    = 0.3;
rtchandel = 0.05;
cf        = 0;

REVERBIT(st=0, insk=0, totdur + ringdur,
         amp, revtime, revpct, rtchandel, cf);

MAXBANG(totdur + notedur);
