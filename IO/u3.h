
#ifndef U3_H_
#define U3_H_

#include <sys/time.h>
#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include "labjackusb.h"


#ifdef __cplusplus
extern "C"{
#endif

typedef unsigned char uint8;
typedef unsigned short uint16;
typedef unsigned int uint32;

struct U3_CALIBRATION_INFORMATION {
    uint8 prodID;
    double hardwareVersion; 
                            
    int highVoltage;        
    double ccConstants[20];
    
};

typedef struct U3_CALIBRATION_INFORMATION u3CalibrationInfo;


struct U3_TDAC_CALIBRATION_INFORMATION {
    uint8 prodID;
    double ccConstants[4];

};

typedef struct U3_TDAC_CALIBRATION_INFORMATION u3TdacCalibrationInfo;




void normalChecksum( uint8 *b,
                     int n);


void extendedChecksum( uint8 *b,
                       int n);


uint8 normalChecksum8( uint8 *b,
                       int n);


uint16 extendedChecksum16( uint8 *b,
                           int n);


uint8 extendedChecksum8( uint8 *b);

HANDLE openUSBConnection( int localID);

void closeUSBConnection( HANDLE hDevice);

long getTickCount();

long getCalibrationInfo( HANDLE hDevice,
                         u3CalibrationInfo *caliInfo);

long getTdacCalibrationInfo( HANDLE hDevice,
                             u3TdacCalibrationInfo *caliInfo,
                             uint8 DIOAPinNum);

double FPuint8ArrayToFPDouble( uint8 *buffer,
                               int startIndex);

long isCalibrationInfoValid(u3CalibrationInfo *caliInfo);


long isTdacCalibrationInfoValid(u3TdacCalibrationInfo *caliInfo);


long getAinVoltCalibrated( u3CalibrationInfo *caliInfo,
                           int dac1Enabled,
                           uint8 negChannel,
                           uint16 bytesVolt,
                           double *analogVolt);


long getAinVoltCalibrated_hw130( u3CalibrationInfo *caliInfo,
                                 uint8 positiveChannel,
                                 uint8 negChannel,
                                 uint16 bytesVolt,
                                 double *analogVolt);


long getDacBinVoltCalibrated( u3CalibrationInfo *caliInfo,
                              int dacNumber,
                              double analogVolt,
                              uint8 *bytesVolt);


long getDacBinVoltCalibrated8Bit( u3CalibrationInfo *caliInfo,
                                  int dacNumber,
                                  double analogVolt,
                                  uint8 *bytesVolt8);

long getDacBinVoltCalibrated16Bit( u3CalibrationInfo *caliInfo,
                                   int dacNumber,
                                   double analogVolt,
                                   uint16 *bytesVolt16);


long getTdacBinVoltCalibrated( u3TdacCalibrationInfo *caliInfo,
                               int dacNumber,
                               double analogVolt,
                               uint16 *bytesVolt);


long getTempKCalibrated( u3CalibrationInfo *caliInfo,
                         uint32 bytesTemp,
                         double *kelvinTemp);



long getAinVoltUncalibrated( int dac1Enabled,
                             uint8 negChannel,
                             uint16 bytesVolt,
                             double *analogVolt);

long getAinVoltUncalibrated_hw130( int highVoltage,
                                   uint8 positiveChannel,
                                   uint8 negChannel,
                                   uint16 bytesVolt,
                                   double *analogVolt);


long getDacBinVoltUncalibrated( int dacNumber,
                                double analogVolt,
                                uint8 *bytesVolt);


long getDacBinVoltUncalibrated8Bit( int dacNumber,
                                    double analogVolt,
                                    uint8 *bytesVolt8);

long getDacBinVoltUncalibrated16Bit( int dacNumber,
                                     double analogVolt,
                                     uint16 *bytesVolt16);


long getTempKUncalibrated( uint16 bytesTemp,
                           double *kelvinTemp);


long I2C( HANDLE hDevice,
          uint8 I2COptions,
          uint8 SpeedAdjust,
          uint8 SDAPinNum,
          uint8 SCLPinNum,
          uint8 Address,
          uint8 NumI2CBytesToSend,
          uint8 NumI2CBytesToReceive,
          uint8 *I2CBytesCommand,
          uint8 *Errorcode,
          uint8 *AckArray,
          uint8 *I2CBytesResponse);

long eAIN( HANDLE Handle,
           u3CalibrationInfo *CalibrationInfo,
           long ConfigIO,
           long *DAC1Enable,
           long ChannelP,
           long ChannelN,
           double *Voltage,
           long Range,
           long Resolution,
           long Settling,
           long Binary,
           long Reserved1,
           long Reserved2);



long eDAC( HANDLE Handle,
           u3CalibrationInfo *CalibrationInfo,
           long ConfigIO,
           long Channel,
           double Voltage,
           long Binary,
           long Reserved1,
           long Reserved2);


long eDI( HANDLE Handle,
          long ConfigIO,
          long Channel,
          long *State);


long eDO( HANDLE Handle,
          long ConfigIO,
          long Channel,
          long State);


long eTCConfig( HANDLE Handle,
                long *aEnableTimers,
                long *aEnableCounters,
                long TCPinOffset,
                long TimerClockBaseIndex,
                long TimerClockDivisor,
                long *aTimerModes,
                double *aTimerValues,
                long Reserved1,
                long Reserved2);


long eTCValues( HANDLE Handle,
                long *aReadTimers,
                long *aUpdateResetTimers,
                long *aReadCounters,
                long *aResetCounters,
                double *aTimerValues,
                double *aCounterValues,
                long Reserved1,
                long Reserved2);

long ehConfigIO( HANDLE hDevice,
                 uint8 inWriteMask,
                 uint8 inTimerCounterConfig,
                 uint8 inDAC1Enable,
                 uint8 inFIOAnalog,
                 uint8 inEIOAnalog,
                 uint8 *outTimerCounterConfig,
                 uint8 *outDAC1Enable,
                 uint8 *outFIOAnalog,
                 uint8 *outEIOAnalog);

long ehConfigTimerClock( HANDLE hDevice,
                         uint8 inTimerClockConfig,
                         uint8 inTimerClockDivisor,
                         uint8 *outTimerClockConfig,
                         uint8 *outTimerClockDivisor);


long ehFeedback( HANDLE hDevice,
                 uint8 *inIOTypesDataBuff,
                 long inIOTypesDataSize,
                 uint8 *outErrorcode,
                 uint8 *outErrorFrame,
                 uint8 *outDataBuff,
                 long outDataSize);

#define LJ_tc2MHZ 10


#define LJ_tc6MHZ 11


#define LJ_tc24MHZ 12


#define LJ_tc500KHZ_DIV 13


#define LJ_tc2MHZ_DIV 14


#define LJ_tc6MHZ_DIV 15

#define LJ_tc24MHZ_DIV 16



#define LJ_tc4MHZ 20

#define LJ_tc12MHZ 21

#define LJ_tc48MHZ 22

#define LJ_tc1MHZ_DIV 23

#define LJ_tc4MHZ_DIV 24

#define LJ_tc12MHZ_DIV 25

#define LJ_tc48MHZ_DIV 26



#define LJ_tmPWM16 0


#define LJ_tmPWM8 1

#define LJ_tmRISINGEDGES32 2


#define LJ_tmFALLINGEDGES32 3

#define LJ_tmDUTYCYCLE 4

#define LJ_tmFIRMCOUNTER 5

#define LJ_tmFIRMCOUNTERDEBOUNCE 6

#define LJ_tmFREQOUT 7

#define LJ_tmQUAD 8

#define LJ_tmTIMERSTOP 9

#define LJ_tmSYSTIMERLOW 10

#define LJ_tmSYSTIMERHIGH 11

#define LJ_tmRISINGEDGES16 12

#define LJ_tmFALLINGEDGES16 13

#ifdef __cplusplus
}
#endif

#endif
