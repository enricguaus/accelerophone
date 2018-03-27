#include <Wire.h>
#include <SparkFun_MMA8452Q.h>
#include "touch.h"
#include "multisensor.h"

// ---------------------
// ---- DEFINITIONS ----
// ---------------------
#define MEAS_TIME 50
#define N_SENSORS  6
#define ATEN       0.99

// -------------------
// ---- VARIABLES ----
// -------------------
Touch       mainSwitch(8,9,10);
MultiSensor accelerometers;

//MMA8452Q accel0(0x1C); // El poso aqu´ perqu` a vegades d´na problemes de compilacio i no troba el MMA8452Q


// ---------------
// ---- SETUP ----
// ---------------
void setup(){  
  Wire.begin();
  while (!Serial) delay(100);
  Serial.begin(57600);
  accelerometers.initSensors(N_SENSORS,ATEN);
}

// -------------------
// ---- MAIN LOOP ----
// -------------------
void loop(){
  Serial.print(mainSwitch.get());
  Serial.print(" ");
  for(int i=0;i<accelerometers.getNSensors();i++){
    Serial.print(int(127*(accelerometers.getXYZDecay(i))));
    Serial.print(" ");
  }
  Serial.println();
  delay(MEAS_TIME);
}

