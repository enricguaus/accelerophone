#ifndef __TOUCH_H__
#define __TOUCH_H__

class Touch{
  public:
    Touch(int pSigPin=8, int pVccPin=9, int pGndPin=10);
    int get(void);
  private:
    int _sigPin;
    int _mainTouch;
    int _lastMainTouch;
    int _stateMainTouch;
};

#endif 
