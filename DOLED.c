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


    localID = -1;
    hDevice = openUSBConnection(localID);
    if( hDevice  == NULL )
        goto done;

    error = getCalibrationInfo(hDevice, &caliInfo);
    if( error < 0 )
        goto close;

double ch1,ch2,ch3,ch4, value1,value2,value3,value4;
ch1 = mxGetScalar(prhs[0]);
ch2 = mxGetScalar(prhs[1]);
ch3 = mxGetScalar(prhs[2]);
ch4 = mxGetScalar(prhs[3]);
value1 = mxGetScalar(prhs[4]);
value2 = mxGetScalar(prhs[5]);
value3 = mxGetScalar(prhs[6]);
value4 = mxGetScalar(prhs[7]);
    error = eDO(hDevice, 1, ch1, value1);
    if( error != 0 )
        goto close;
    error = eDO(hDevice, 1, ch2, value2);
    if( error != 0 )
        goto close;
    error = eDO(hDevice, 1, ch3, value3);
    if( error != 0 )
        goto close;
    error = eDO(hDevice, 1, ch4, value4);
    if( error != 0 )
        goto close;
   



close:
    if( error > 0 )
        printf("Received an error code of %ld\n", error);
    closeUSBConnection(hDevice);

done:
    ;
}
   