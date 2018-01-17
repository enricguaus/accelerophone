#include <Wire.h>
#include <SparkFun_MMA8452Q.h>
#include "touch.h"
#include "multisensor.h"

// ---------------------
// ---- DEFINITIONS ----
// ---------------------
#define MEAS_TIME 10
#define N_SENSORS  4
#define ATEN       0.999

// -------------------
// ---- VARIABLES ----
// -------------------
Touch       mainSwitch(8,9,10);
MultiSensor accelerometers;

// ---------------
// ---- SETUP ----
// ---------------
void setup(){  
  while (!Serial) delay(1000);
  Serial.begin(57600);
  Wire.begin();
  accelerometers.initSensors(N_SENSORS,ATEN);
}

// -------------------
// ---- MAIN LOOP ----
// -------------------
void loop(){
  Serial.println(-100);
  Serial.println(mainSwitch.get());
  for(int i=0;i<accelerometers.getNSensors();i++)
    Serial.println(accelerometers.getXYZDecay(i),3);
  delay(MEAS_TIME);
}

