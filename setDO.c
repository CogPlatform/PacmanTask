#include "mex.h"
#include "u3.h"
#include <unistd.h>
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]) 
{

    HANDLE hDevice;
    u3CalibrationInfo caliInfo;
    int localID;
    long DAC1Enable;
    long error;
    double dblVoltage0,dblVoltage1,dblVoltage2,dblVoltage3;
    long lngState;
    long lngTCPinOffset;
    long lngTimerClockBaseIndex;
    long lngTimerClockDivisor;
    long alngEnableTimers[2];
    long alngTimerModes[2];
    double adblTimerValues[2];
    long alngEnableCounters[2];
    long alngReadTimers[2];
    long alngUpdateResetTimers[2];
    long alngReadCounters[2];
    long alngResetCounters[2];
    double adblCounterValues[2];
    double highTime;
    double lowTime;
    double dutyCycle;


    localID = 320069602;
    hDevice = openUSBConnection(localID);
    if( hDevice  == NULL )
        goto done;

    error = getCalibrationInfo(hDevice, &caliInfo);
    if( error < 0 )
        goto close;

double ch, value;
ch = mxGetScalar(prhs[0]);
value = mxGetScalar(prhs[1]);
    error = eDO(hDevice, 1, ch, value);
    if( error != 0 )
        goto close;
	
   



close:
    if( error > 0 )
        printf("Received an error code of %ld\n", error);
    closeUSBConnection(hDevice);

done:
    ;
}
   

  

