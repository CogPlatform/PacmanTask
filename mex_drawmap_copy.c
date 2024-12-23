#include "mex.h"
#include "stdio.h"
void drawdots(int numRows,int numCols,double *dots,double *sizes,double *colors,char *currentTiles,double tileSize,double midTilex,double midTiley,double pelletSize,double energizerSize,double scale,double n)
{
  int x,y;
  int i=0;
  int num=numRows*numCols;
  char tile=' ';
  n=0;
  
  for( y=0;y<numRows;y++){

    for(x=0;x<numCols;x++){

        i = x+y*numCols;
        tile =currentTiles[i];
        switch(tile){
            case ' ':
                break;

            case '.':
               
                dots[(int)n]= (x-1)*tileSize+midTilex;
                dots[(int)n+num]= (y-1)*tileSize+midTiley;
                sizes[(int)n] = pelletSize;
                colors[(int)n] = 1.0;
                colors[(int)n+num] = 184/255;
                colors[(int)n+2*num] = 174/255;
                n=n+1;
                break;

            case 'o':
                
                dots[(int)n]= (x-1)*tileSize+0.5*scale+midTilex; 
                dots[(int)n+num]= (y-1)*tileSize+0.5*scale+midTiley;
                sizes[(int)n]=energizerSize;
                colors[(int)n] = 1.0;
                colors[(int)n+num] = 184/255;
                colors[(int)n+2*num] = 174/255;
                n=n+1;
                break;
        }
      }
   }

}
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
  int numRows,numCols;
  double *Pdots,*Psizes,*Pcolors,*n;
  char *currentTiles;
  double tileSize, midTilex,midTiley,pelletSize,energizerSize,scale;
  double num;

  numRows=mxGetScalar(prhs[0]);
  numCols=mxGetScalar(prhs[1]);

  currentTiles=mxArrayToString(prhs[2]);

  tileSize=mxGetScalar(prhs[3]);
  midTilex=mxGetScalar(prhs[4]);
  midTiley=mxGetScalar(prhs[5]);

  pelletSize=mxGetScalar(prhs[6]);
  energizerSize=mxGetScalar(prhs[7]);
  scale==mxGetScalar(prhs[8]);

  num=numRows*numCols;

  plhs[0] = mxCreateDoubleMatrix(2,(mwSize)num,mxREAL);
  Pdots = mxGetPr(plhs[0]);

  plhs[1] = mxCreateDoubleMatrix(1,(mwSize)num,mxREAL);
  Psizes = mxGetPr(plhs[1]);

  plhs[2] = mxCreateDoubleMatrix(3,(mwSize)num,mxREAL);
  Pcolors = mxGetPr(plhs[2]);

  plhs[3] = mxCreateDoubleMatrix(1, 1, mxREAL);
  test = mxGetScalar(plhs[3]);
  mexPrintf("n-pre = %d",n);
  
  drawdots(numRows,numCols, Pdots,Psizes,Pcolors,currentTiles,tileSize, midTilex, midTiley,pelletSize,energizerSize,scale,n);
  mexPrintf("n = %d",n);
    
}
