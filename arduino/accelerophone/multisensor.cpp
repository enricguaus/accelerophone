#include "Arduino.h"
#include "Wire.h"
#include <SparkFun_MMA8452Q.h>
#include "multisensor.h"

MultiSensor::MultiSensor(void){
  _nSensors = 0;
  _decay    = 0.0;
}

MultiSensor::~MultiSensor(void){
  if(_accelerometers) delete [] _accelerometers;
  if(_actXYZ)         delete [] _actXYZ;
  if(_maxXYZ)         delete [] _maxXYZ;
}

void MultiSensor::initSensors(int pNSensors, float pDecay){
  //Wire.begin();
  setNSensors(pNSensors);
  setDecay(pDecay);
  for(int i=0;i<_nSensors;i++){
    int channel=(int)(i/2);
    selectChannel(channel);
    _accelerometers[i].init();
  }
}

void MultiSensor::setNSensors(int pNSensors){
  _nSensors = pNSensors;
  if(_accelerometers) delete [] _accelerometers;
  _accelerometers = new MMA8452Q[_nSensors]; 
  for(int i=0;i<_nSensors;i++){
    if((i%2)==0) _accelerometers[i]=MMA8452Q(0x1D);
    else         _accelerometers[i]=MMA8452Q(0x1C);
  }
  if(_actXYZ) delete [] _actXYZ; _actXYZ=new float[_nSensors];
  if(_maxXYZ) delete [] _maxXYZ; _maxXYZ=new float[_nSensors];
}

int MultiSensor::getNSensors(void){
  return _nSensors;
}
void MultiSensor::setDecay(float pDecay){
  _decay = pDecay;
}

float MultiSensor::getDecay(void){
  return _decay;
}
    
float MultiSensor::getX(int pIndex){
  int channel=(int)(pIndex/2);
  selectChannel(channel);
  _accelerometers[pIndex].read();
  return _accelerometers[pIndex].cx;
}

float MultiSensor::getXYZ(int pIndex){
  int channel=(int)(pIndex/2);
  selectChannel(channel);
  _accelerometers[pIndex].read();
  _actXYZ[pIndex]=abs((sqrt((_accelerometers[pIndex].cx*_accelerometers[pIndex].cx)+(_accelerometers[pIndex].cy*_accelerometers[pIndex].cy)+(_accelerometers[pIndex].cz*_accelerometers[pIndex].cz))-1)/3);
  return _actXYZ[pIndex];
}

float MultiSensor::getXYZDecay(int pIndex){
  getXYZ(pIndex);
  if(_actXYZ[pIndex]>_maxXYZ[pIndex]){
    _maxXYZ[pIndex]=_actXYZ[pIndex];
    return _actXYZ[pIndex];
  }else{
    _maxXYZ[pIndex]*=_decay;
    return _maxXYZ[pIndex];
  }
}

void MultiSensor::selectChannel(uint8_t i) { // Selects the reading input port from TCA9548
  if (i > 7) return;
  Wire.beginTransmission(TCAADDR);
  Wire.write(1 << i);
  Wire.endTransmission(); 
}
