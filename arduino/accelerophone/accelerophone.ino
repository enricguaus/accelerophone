#define MEAS_TIME 100
#define TOUCH_SIG_PIN   8
#define TOUCH_VCC_PIN   9
#define TOUCH_GND_PIN  10

int mainSwitch;
int last_mainSwitch;
int state_mainSwitch;

void setup(){
  pinMode(TOUCH_SIG_PIN,INPUT);
  pinMode(TOUCH_VCC_PIN,OUTPUT);
  pinMode(TOUCH_GND_PIN,OUTPUT);
  digitalWrite(TOUCH_VCC_PIN,HIGH);
  digitalWrite(TOUCH_GND_PIN,LOW);

  mainSwitch       = 0;
  last_mainSwitch  = 0;
  state_mainSwitch = 0;
  Serial.begin(9600);
}

void loop(){
  mainSwitch=digitalRead(TOUCH_SIG_PIN);
  if(mainSwitch==1 && last_mainSwitch==0){
    if(state_mainSwitch==0){
      state_mainSwitch=1;
    }else{
      state_mainSwitch=0;
    }
    Serial.print(state_mainSwitch);
  }
  last_mainSwitch=mainSwitch;
  delay(MEAS_TIME);
}


