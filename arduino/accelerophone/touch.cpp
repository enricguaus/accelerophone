#include "Arduino.h"
#include "Touch.h"

Touch::Touch(int pSigPin, int pVccPin, int pGndPin){
  pinMode(pSigPin,INPUT);
  pinMode(pVccPin,OUTPUT);
  pinMode(pGndPin,OUTPUT);
  digitalWrite(pVccPin,HIGH);
  digitalWrite(pGndPin,LOW);
  _sigPin         = pSigPin;
  _mainTouch      = 0;
  _lastMainTouch  = 0;
  _stateMainTouch = 0;
}

int Touch::get(void){
  _mainTouch=digitalRead(_sigPin);
  if(_mainTouch==1 && _lastMainTouch==0){
    if(_stateMainTouch==0){
      _stateMainTouch=1;
    }else{
      _stateMainTouch=0;
    }
  }
  _lastMainTouch=_mainTouch;
  return _stateMainTouch;
}
