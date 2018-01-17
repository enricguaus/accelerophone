(
// ---------------------------------
// ----    SERVER + SYNTHDEF    ----
// ---------------------------------
Server.default = Server.internal;
s = Server.default;
s.waitForBoot({
	SynthDef(\singing, { arg amp=0.0, freq=440, pan=0, gate=0, vocal=0;
		//var env = EnvGen.kr(Env.perc, gate);
		var snd = amp * Select.ar(vocal,[
			0.1*Formants.ar(freq, Vowel(\u, \bass)),
			0.1*Formants.ar(freq, Vowel(\o, \tenor)),
			0.1*Formants.ar(freq, Vowel(\i, \counterTenor)),
			0.1*Formants.ar(freq, Vowel(\e, \alto)),
			0.1*Formants.ar(freq, Vowel(\a, \soprano))
		]);
		Out.ar(0,Pan2.ar(snd,pan));
	}).add;
})
)

(
// -------------------------------
// ----  PREPARE CONNECTIONS  ----
// ----   OSC + Serial Port   ----
// -------------------------------
m = NetAddr("127.0.0.1", 57120);
p = SerialPort(SerialPort.devices[1],57600);

r = Routine({
    var byte, str, res, cnt_sensor;
    cnt_sensor=0;
	v=Array.fill(5,1);
    inf.do{|i|
        if(p.read==10, {
            str = "";
            while({byte = p.read; byte !=13 }, {
                str= str++byte.asAscii;
            });
			res= str.asFloat;
            if(res== -100,{
	            cnt_sensor=0;
				v.clear;
            },{
	            switch(cnt_sensor,
					0, {v.put(0, res);},
	            	1, {v.put(1, res);},
	            	2, {v.put(2, res);},
					3, {v.put(3, res);},
					4, {v.put(4, res);},
					//5, {v.put(5, res);},
					//6, {v.put(6, res);},
	            );
				cnt_sensor = cnt_sensor + 1 ;
	        });
			if(cnt_sensor==5,{
				m.sendMsg("/0/abs_accel1_value",v[1].asString);
				m.sendMsg("/0/abs_accel2_value",v[2].asString);
				m.sendMsg("/0/abs_accel3_value",v[3].asString);
				m.sendMsg("/0/abs_accel4_value",v[4].asString);
				postf("Receiving from Aduino: % - % - % - %\n",v[1],v[2],v[3],v[4]);
			});
        });
    };
}).play;
)

(
// ----------------------------------------------
// ----              OSC CONTROL             ----
// ---- Run this to start synths and receive ----
// ----------------------------------------------
n = NetAddr.new("127.0.0.1", 57120);

w=Synth.new(\singing,[\amp, 0.0, \freq, 261.63, \pan, -1.00, \vocal, 4]);
x=Synth.new(\singing,[\amp, 0.0, \freq, 587.33, \pan, -0.33, \vocal, 3]);
y=Synth.new(\singing,[\amp, 0.0, \freq, 987.77, \pan,  0.33, \vocal, 1]);
z=Synth.new(\singing,[\amp, 0.0, \freq, 1567.98, \pan,  1.00, \vocal, 0]);

o = OSCresponderNode(nil, '/0/abs_accel1_value', {|pt, pr, pmsg|
	q = pmsg[1].asFloat;
	w.set(\amp,q);
}).add;

o = OSCresponderNode(nil, '/0/abs_accel2_value', {|pt, pr, pmsg|
	q = pmsg[1].asFloat;
	x.set(\amp,q);
}).add;

o = OSCresponderNode(nil, '/0/abs_accel3_value', {|pt, pr, pmsg|
	q = pmsg[1].asFloat;
	y.set(\amp,q);
}).add;

o = OSCresponderNode(nil, '/0/abs_accel4_value', {|pt, pr, pmsg|
	q = pmsg[1].asFloat;
	z.set(\amp,q);
}).add;
)

(
// ---------------
// ---- CLOSE ----
// ---------------
w.free;
x.free;
y.free;
z.free;

o.remove;
n.disconnect;

r.stop;
r.clear;

p.close;
m.disconnect;

s.quit;
)











































































































{x=Array.fill(5,{[0.00001,0.03].asSpec.map(LFNoise2.kr(3))});Splay.ar(Friction.ar(LFTri.ar(50),friction:x,mass:x*30000))}.play





play{n=rrand(20,70);Pulse.ar(({rrand(0.2,n)}*Lag.kr(Dust.kr(n.pow(3)!2).exprange(1,10),0.4))!n,{rand(pi)}!n,n.reciprocal).sum}








play{{a=SinOsc;l=LFNoise2;a.ar(666*a.ar(l.ar(l.ar(0.5))*9)*RLPF.ar(Saw.ar(9),l.ar(0.5).range(9,999),l.ar(2))).cubed}!2}
//oscillators argue



{DFM1.ar(Saw.ar((100,100.9..110)).mean,PMOsc.ar(100,300,0.4).exprange(300,9800),0.9).dup * SoundIn.ar(0)}.play

{CrossoverDistortion.ar(SoundIn.ar, MouseX.kr(0, 1), MouseY.kr(0, 1))}.play
{Disintegrator.ar(SoundIn.ar(0), MouseX.kr(0, 44100), MouseY.kr(0, 1))}.play


{ Streson.ar(LFSaw.ar([220, 180], 0, mul:EnvGen.kr(Env.asr(0.5, 1, 0.02), 1.0) * 0.2), LinExp.kr(LFCub.kr(0.1, 0.5*pi), -1, 1, 280, 377).reciprocal, 0.9, 0.3) }.play



play{r=Impulse;c=TChoose;a=(240..8000);n=c.kr(r.kr(2),a/920);PitchShift.ar(BPF.ar(LFNoise0.ar(8,0.5),c.kr(r.kr(n),a),0.5),n/33,n/2)!2};//sc


play{x=LFSaw.ar([0.3,0.6])*LFSaw.ar([1,1.5])*SinOsc.ar([440,220]*LFPulse.kr(0.12).range(1,2));CombC.ar(x,0.5,0.5,9,0.5,x)/12}



//analogous to example in the Pitch helpfile
(
SynthDef("pitchFollow1",{
    var in, amp, freq, hasFreq, out;
    in = Mix.new(SoundIn.ar([0,1]));
    amp = Amplitude.kr(in, 0.05, 0.05);
    # freq, hasFreq = Tartini.kr(in, 0.93,1024,512,512);
    //freq = Lag.kr(freq.cpsmidi.round(1).midicps, 0.05);
    out = Mix.new(VarSaw.ar(freq * [0.5,1,2], 0, LFNoise1.kr(0.3,0.1,0.1), amp));
    6.do({
        out = AllpassN.ar(out, 0.040, [0.040.rand,0.040.rand], 2)
    });
    Out.ar(0,out)
}).play(s);
)


// Pilotes que reboten a terra - Per seguir estudiant


{AllpassN.ar(Pan2.ar(Decay.ar(Dust.ar(MouseX.kr(0.5,10),0.5), MouseX.kr(0.2,0.0005),WhiteNoise.ar),LFNoise2.ar(2)),0.5, MouseY.kr(0.01,0.5),3) +  AllpassN.ar(Pan2.ar(Decay.ar(Dust.ar(MouseX.kr(0.5,10),0.5), MouseX.kr(0.2,0.0005),PinkNoise.ar),LFNoise2.ar(2)),0.5, MouseY.kr(0.01,0.5), 3)}.play;


{AllpassN.ar(Pan2.ar(Decay.ar(SoundIn.ar(0), MouseX.kr(0.2,0.001),WhiteNoise.ar),LFNoise2.ar(2)),0.5, MouseY.kr(0.01,0.5),3) +  AllpassN.ar(Pan2.ar(Decay.ar(SoundIn.ar(0), MouseX.kr(0.2,0.001),PinkNoise.ar),LFNoise2.ar(2)),0.5, MouseY.kr(0.01,0.5), 3)}.play;



//check hasFreq values
(
a= SynthDef("testtartini",{
    var in, freq, hasFreq, out;

    in=SoundIn.ar(0);

    # freq, hasFreq = Tartini.kr(in);

    hasFreq.poll;

    Out.ar(0,[SinOsc.ar(freq,0.1),in]);
}).play(s);
)