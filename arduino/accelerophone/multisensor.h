#ifndef __MULTISENSOR_H__
#define __MULTISENSOR_H__

#include <Wire.h>
#include <SparkFun_MMA8452Q.h>

#define TCAADDR 0x70

class MultiSensor{
  public:
    MultiSensor(void);
    ~MultiSensor(void);
    void  initSensors(int pNSensors=0, float pDecay=0.0);
    void  setNSensors(int pNSensors=0);
    int   getNSensors(void);
    void  setDecay(float pDecay=0.0);
    float getDecay(void);
    float getX(int pIndex=0);
    float getXYZ(int pIndex=0);
    float getXYZDecay(int pIndex=0);
    void  selectChannel(uint8_t i);
  private:
    MMA8452Q* _accelerometers;
    int       _nSensors;
    float     _decay;
    float*    _actXYZ;
    float*    _maxXYZ;
};

#endif
