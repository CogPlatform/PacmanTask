#include "mex.h"
#include "stdio.h"
void drawdots(int numRows,int numCols,double *Pdots,double *Psizes,double *Pcolors,char *currentTiles,double tileSize,double midTilex,double midTiley,double pelletSize,double energizerSize,double scale,double *Pn)
{
  int x,y;
  int i=0;
  int num=numRows*numCols;
  char tile=' ';
  double n=0;
  
  for( y=0;y<numRows;y++){

    for(x=0;x<numCols;x++){

        i = x+y*numCols;
        tile =currentTiles[i];
        switch(tile){
            case ' ':
                break;

            case '.':
               
                *(Pdots+2*(int)n)= x*tileSize+midTilex;
                *(Pdots+2*(int)n+1)= y*tileSize+midTiley;
                *(Psizes+(int)n) = pelletSize;
                *(Pcolors+3*(int)n) = 1.0;
                *(Pcolors+3*(int)n+1) = 184.0/255;
                *(Pcolors+3*(int)n+2) = 174.0/255;
                n=n+1;
                break;

            case 'o':
                
                *(Pdots+2*(int)n)= x*tileSize+0.5*scale+midTilex; 
                *(Pdots+2*(int)n+1)= y*tileSize+0.5*scale+midTiley;
                *(Psizes+(int)n)=energizerSize;
                *(Pcolors+3*(int)n) = 1.0;
                *(Pcolors+3*(int)n+1) = 184.0/255;
                *(Pcolors+3*(int)n+2) = 174.0/255;
                n=n+1;
                break;
        }
      }
   }
    *Pn = n;
}



void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
  int numRows,numCols;
  double *Pdots,*Psizes,*Pcolors,*Pn;
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
  Pn = mxGetPr(plhs[3]);
  
  
  drawdots(numRows,numCols, Pdots,Psizes,Pcolors,currentTiles,tileSize, midTilex, midTiley,pelletSize,energizerSize,scale,Pn);
    
}
