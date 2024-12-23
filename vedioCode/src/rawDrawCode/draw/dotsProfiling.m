function [dots,sizes,colors,n]=dotsProfiling(numRows,numCols,Map,tileSize, ...
    mx, my,pelletSize,energizerSize,scale)


dotsIndex = find(Map == '.');
dotsPos = ItoP(dotsIndex);
dotsPosX = (dotsPos(1,:)-1)*tileSize+mx;
dotsPosY = (dotsPos(2,:)-1)*tileSize+my;
enersIndex = find(Map == 'o');
enersPos = ItoP(enersIndex);
enersPosX = (enersPos(1,:)-1)*tileSize+0.5*scale+mx;
enersPosY = (enersPos(2,:)-1)*tileSize+0.5*scale+my;
n = length(dotsIndex)+length(enersIndex);
dots = [[dotsPosX,enersPosX];[dotsPosY,enersPosY]];
dotsSize = repmat(pelletSize,1,length(dotsIndex));
enersSize = repmat(energizerSize,1,length(enersIndex));
sizes = [dotsSize,enersSize];
dotsColor = repmat([1.0,184.0/255,174.0/255],length(dotsIndex),1)';
enersColor = repmat([1.0,184.0/255,174.0/255],length(enersIndex),1)';
colors = [dotsColor,enersColor];
end

function Pos = ItoP(Index)
pos_x= rem(Index,28);
if pos_x ==0
    pos_x =28;
    pos_y = fix(Index/28);
else
    pos_y = fix(Index/28)+1;
end
Pos = [pos_x;pos_y];
end
