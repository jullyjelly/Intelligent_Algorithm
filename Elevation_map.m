height=xlsread('Elevation data.xlsx');
[X,Y]=meshgrid(0:38.2:2912*38.2,0:38.2:2774*38.2);
% mesh(X,Y,height)
pcolor(X,Y,height)
shading interp;