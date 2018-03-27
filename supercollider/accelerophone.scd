(
// ---------------------------------
// ----    SERVER + SYNTHDEF    ----
// ---------------------------------
Server.default = Server.internal;
s = Server.default;
s.waitForBoot({
	SynthDef(\singing, { arg amp=0.0, freq=440, pan=0, gate=0, vocal=0;
		//var env = EnvGen.kr(Env.perc, gate);
		var snd = amp.lag(0.5) * Select.ar(vocal,[
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
    var byte, str, res;
    inf.do{|i|
        if(p.read==10, {
            str = "";
            while({byte = p.read; byte !=13 }, {
                str= str++byte.asAscii;
            });
			str.postln;
			res=str.split($ );
			m.sendMsg("/0/abs_accel1_value",res[1]);
			m.sendMsg("/0/abs_accel2_value",res[2]);
			m.sendMsg("/0/abs_accel3_value",res[3]);
			m.sendMsg("/0/abs_accel4_value",res[4]);
			m.sendMsg("/0/abs_accel5_value",res[5]);
			m.sendMsg("/0/abs_accel6_value",res[6]);
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

u=Synth.new(\singing,[\amp, 0.0, \freq,  261.63, \pan, -1.0, \vocal, 0]);
v=Synth.new(\singing,[\amp, 0.0, \freq,  587.33, \pan, -0.6, \vocal, 1]);
w=Synth.new(\singing,[\amp, 0.0, \freq,  809.16, \pan, -0.2, \vocal, 2]);
x=Synth.new(\singing,[\amp, 0.0, \freq, 1027.87, \pan,  0.2, \vocal, 3]);
y=Synth.new(\singing,[\amp, 0.0, \freq, 1387.77, \pan,  0.6, \vocal, 4]);
z=Synth.new(\singing,[\amp, 0.0, \freq, 1567.98, \pan,  1.0, \vocal, 4]);

o = OSCresponderNode(nil, '/0/abs_accel1_value', {|pt, pr, pmsg|
	q = pmsg[1].asFloat;
	u.set(\amp,q.linlin(0,127,0,1));
}).add;

o = OSCresponderNode(nil, '/0/abs_accel2_value', {|pt, pr, pmsg|
	q = pmsg[1].asFloat;
	v.set(\amp,q.linlin(0,127,0,1));
}).add;

o = OSCresponderNode(nil, '/0/abs_accel3_value', {|pt, pr, pmsg|
	q = pmsg[1].asFloat;
	w.set(\amp,q.linlin(0,127,0,1));
}).add;

o = OSCresponderNode(nil, '/0/abs_accel4_value', {|pt, pr, pmsg|
	q = pmsg[1].asFloat;
	x.set(\amp,q.linlin(0,127,0,1));
}).add;

o = OSCresponderNode(nil, '/0/abs_accel5_value', {|pt, pr, pmsg|
	q = pmsg[1].asFloat;
	y.set(\amp,q.linlin(0,127,0,1));
}).add;

o = OSCresponderNode(nil, '/0/abs_accel6_value', {|pt, pr, pmsg|
	q = pmsg[1].asFloat;
	z.set(\amp,q.linlin(0,127,0,1));
}).add;
)

(
// ---------------
// ---- CLOSE ----
// ---------------
u.free;
v.free;
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
