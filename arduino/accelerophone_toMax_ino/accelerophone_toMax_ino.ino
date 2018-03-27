// Author:      Enric Guaus
// Date:        27/03/2018
// Description: Artificial simulation of the accelerophone based scuplture. 
//              It provides list of N_SENSORS + 1 integer values between 0 and 127. 
//              First value is always zero and simulates an on-off switch. 
//              Values between 2 and N_SENSORS + 1 simulates the number of connected accelerometers
//              Reading sensors occurs each MEAS_TIME (in milliseconds). 
//              Sensor values are attenuated by an ATEN factor each MEAS_TIME milliseconds.
//              A new trigger (touch) is given at approximatelly TRIGGER milliseconds.
// +info:       www.sheepdog.es

// ---------------------
// ---- DEFINITIONS ----
// ---------------------
#define MEAS_TIME   50    // Delay time between reading all sensors.
#define N_SENSORS    6    // 
#define ATEN         0.99 // 1.00 means no attenuation.
#define TRIGGER   2000    // Time (in ms) between a new trigger is given (simulates sculpture touch).

// -------------------
// ---- VARIABLES ----
// -------------------
unsigned long last_time=0.0;
unsigned long current_time=0.0;
float sensor_values[N_SENSORS];

// ---------------
// ---- SETUP ----
// ---------------
void setup(){  
  while (!Serial) delay(100);
  Serial.begin(57600);
  for(int i=0;i<N_SENSORS;i++) sensor_values[i]=0.0;
  last_time=millis();
  
}

// -------------------
// ---- MAIN LOOP ----
// -------------------
void loop(){
  Serial.print(0);
  Serial.print(" ");
  if(millis()-last_time>TRIGGER){
    sensor_values[random(0,N_SENSORS)]=random(0,128);
    last_time=millis();
  }
  for(int i=0;i<N_SENSORS;i++){
    Serial.print(round(sensor_values[i]));
    sensor_values[i]=sensor_values[i]*ATEN;
    Serial.print(" ");
  }
  Serial.println();
  delay(MEAS_TIME);
}

