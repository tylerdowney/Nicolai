function grid_plotter(X,Y,Z,count,avgVal,output_path,varargin)
%GLIDER_PLOTTER - Creates 2D plots from glider data using MATLAB's gridding
%tools and smooth2a function. Gridded data product output
% 
% Author:
% Nicolai Bronikowski
% Memorial University (NL)
% nvob37@mun.ca
% 
% [hl,ax1,ax2] = 
% -------------------------------------------------------------------------
%  Example use of the function:
% 
%     [hl,ax1,ax2] = glider_plotter(range(:,j),press(:,j),satn(:,j),...
%         count,avgVal,...
%         'XName','range (km)',...
%         'YName','depth (m)',...
%         'ZName','O_2 Saturation %',...
%         'ZvalueFill','on',...
%         'Smoothing','off',...
%         'SmoothingSize',10,...
%         'Contours','off',...
%         'ContourLevels',[]);
%
% Calls: "smooth2a" by: Greg Reeves, March 2009.
%        "ametrine" custom colormap 

    %% Initialisation of varargin
    XName = 'range km'; % xlabel
    YName = 'depth m'; % ylabel
    ZName = 'ZName'; % zlabel
    ZUnits = 'units'; % zvariable units
    fillZ = 'off'; % fill missing data flat
    Sflag = 'off'; % flag for smoothing
    SSize = 10; % cell size for smoothing
    Contour_flag = 'off'; % overlay contours with data
    CLevels = []; % Contour Levels specified
    SFlag = 'off'; % scatter data rather than surface plots
    
    %% Go through varargin name-value pairs
    for i = 1:length(varargin)    
        if mod(i,2)
            property = varargin{i};
            value = varargin{i+1};
                switch property
                    case 'XName'
                        XName = value;
                    case 'YName'
                        YName = value;
                    case 'ZName'
                        ZName = value;
                    case 'ZUnits'
                        ZUnits = value;
                    case 'ZvalueFill'
                        fillZ = value;
                    case 'Smoothing'
                        Sflag = value;
                    case 'SmoothingSize'
                        SSize = value;
                    case 'Contours'
                        Contour_flag = value;
                    case 'ContourLevels'
                        CLevels = value;
                    case 'Scatter'
                        SFlag = value;
                    otherwise
                        error('not enough inputs:"%s"',property);
                end
        end
    end

    %% Check input data. Don't allow NaN's in the X values of future grid.
    id = find(X(~isnan(X)));
    if ~isempty(id)
        X = X(id);
        Y = Y(id);
        Z = Z(id);
    end

    % flag, if user wants to fill missing values then MATLAB will atempt to
    % fill data using fillmissing function. 
    if(strcmp(fillZ,'on'))
       Z = fillmissing(Z,'linear','EndValues','extrap');
    end
     
    %% Create grid vectors of your choice
    x = linspace(min(X),max(X),400); % Warning Scaling of Data
    y = linspace(min(Y),max(Y),100); % Warning Scaling of Data
    [xq,yq] = meshgrid(x,y);
    
    %% Fit a linear interpolation surface to the input vectors
%     [X,Y,Z] = prepareSurfaceData(X,Y,Z);
%     sFit = scatteredInterpolant(X,Y,Z, 'nearest' );% 
%     Zout = sFit(xq,yq);
% 
%     Fg = griddedInterpolant(xq',yq',Zout','linear');
%     Zout = (Fg(xq',yq'))';

    %% Use Griddata to fit data to grid
    Zout = griddata(X,Y,Z,xq,yq);
    
    %% Smoothing data
    if(strcmp(Sflag,'on'))
        Zout = smooth2a(Zout,SSize);
    end
    
    %% initiate figure
    hl = figure(1);
    
    %% plot physical characteristic
    ax1 = subplot(2,1,1);
    
    if(strcmp(SFlag,'on'))
        scatter(X,Y,10,Z,'filled'); shading interp
        grid on
    else
        hdl1 = pcolor(xq,yq,Zout); shading interp
        hdl1.EdgeAlpha = 0.5;
    end  
    
        c1 = colorbar; s1 = colormap(ax1,ametrine(20));    
        colormap(ax1,flipud(s1))

        t=get(c1,'Limits');
        T=t(1):(t(2)-t(1))/8:t(2);
        set(c1,'Ticks',T);
        TL=arrayfun(@(x) sprintf('%.2f',x),T,'un',0);
        set(c1,'TickLabels',TL);

        xlabel(XName,'FontWeight','normal','FontSize',8) 
        ylabel(YName,'FontWeight','normal','FontSize',8)
        ylabel(c1,[ZName,' ',ZUnits],'FontSize',8);

        xl = get(ax1,'xlim');
        xTick = xl(1):(xl(2)-xl(1))/8:xl(2);
        set(ax1,'xtick',xTick)
        set(ax1,'xticklabel',num2str(get(ax1,'xtick')','%.1f')) 
        
    if(strcmp(Contour_flag,'on'))
       hold on
       [c1, h1] = contour(ax1,xq,yq,Zout,CLevels,'k','ShowText','on');
       clabel(c1,h1,'FontSize',8,'Color','k')
    end
    
%     title({[ZName,' of transect # ',num2str(count)],''},'FontSize',8,'FontWeight','normal')  
    
    set(ax1, ...
      'FontSize'    ,   8       , ...
      'Box'         , 'off'     , ...
      'TickDir'     , 'out'     , ...
      'TickLength'  , [.006 .006] , ...
      'Ydir'        , 'reverse' , ...
      'XMinorTick'  , 'on'      , ...
      'YMinorTick'  , 'on'      , ...
      'YGrid'       , 'on'      , ...
      'XColor'      , [.3 .3 .3], ...
      'YColor'      , [.3 .3 .3], ...
      'LineWidth'   , 1         );
  
%       'YTick'       , 0:200:1000, ...
    %% plot anomaly 
    ax2 = subplot(2,1,2);
    
    if(strcmp(SFlag,'on'))
        scatter(X,Y,10,Z-avgVal,'filled'); shading interp
        grid on
    else
        hdl2 = pcolor(xq,yq,Zout-avgVal); shading interp
        hdl2.EdgeAlpha = 0.5;
    end
 
    c2 = colorbar; s2 = colormap(ax2,ametrine(20)); 
    colormap(ax2,flipud(s2))
    
    t=get(c2,'Limits');
    T=t(1):(t(2)-t(1))/8:t(2);
    set(c2,'Ticks',T);
    TL=arrayfun(@(x) sprintf('%.2f',x),T,'un',0);
    set(c2,'TickLabels',TL);
    
        
    xlabel(XName,'FontWeight','normal','FontSize',8) 
    ylabel(YName,'FontWeight','normal','FontSize',8)
    ylabel(c2,['deviation of ',ZName,' from (',num2str(sprintf('%.2f',avgVal)),' ',ZUnits,')'],'FontSize',8);
   
    xl = get(ax2,'xlim');
    xTick = xl(1):(xl(2)-xl(1))/8:xl(2);
    set(ax2,'xtick',xTick)
    set(ax2,'xticklabel',num2str(get(ax2,'xtick')','%.1f'))
    
    if(strcmp(Contour_flag,'on'))
       hold on
       [c2, h2] = contour(ax2,xq,yq,Zout-avgVal,round((CLevels-avgVal)*100)/100,'k','ShowText','on'); 
       clabel(c2,h2,'FontSize',8,'Color','k')
    end    
    
%     title({([ZName,' anomaly of transect # ',num2str(count)]),''},'FontSize',8,'FontWeight','normal')
    
    set(ax2, ...
      'FontSize'    ,   8       , ...
      'Box'         , 'off'     , ...
      'TickDir'     , 'out'     , ...
      'TickLength'  , [.006 .006] , ...
      'Ydir'        , 'reverse' , ...
      'XMinorTick'  , 'on'      , ...
      'YMinorTick'  , 'on'      , ...
      'YGrid'       , 'on'      , ...
      'XColor'      , [.3 .3 .3], ...
      'YColor'      , [.3 .3 .3], ...
      'LineWidth'   , 1         );
  
  %       'YTick'       , 0:200:1000, ...

    %% Printing
    set(gcf,'PaperUnits','inches','PaperPosition',[0 0 12 8]);  %size of printed image
    plotfile = sprintf('%s',[output_path,ZName],num2str(count));
    print(hl,'-djpeg', '-r300', plotfile);
    
    close gcf
    clear hl ax1 ax2
end

function matrixOut = smooth2a(matrixIn,Nr,Nc)
% Smooths 2D array data.  Ignores NaN's.
%
%function matrixOut = smooth2a(matrixIn,Nr,Nc)
% 
% This function smooths the data in matrixIn using a mean filter over a
% rectangle of size (2*Nr+1)-by-(2*Nc+1).  Basically, you end up replacing
% element "i" by the mean of the rectange centered on "i".  Any NaN
% elements are ignored in the averaging.  If element "i" is a NaN, then it
% will be preserved as NaN in the output.  At the edges of the matrix,
% where you cannot build a full rectangle, as much of the rectangle that
% fits on your matrix is used (similar to the default on Matlab's builtin
% function "smooth").
% 
% "matrixIn": original matrix
% "Nr": number of points used to smooth rows
% "Nc": number of points to smooth columns.  If not specified, Nc = Nr.
% 
% "matrixOut": smoothed version of original matrix
% 
% 
% 	Written by Greg Reeves, March 2009.
% 	Division of Biology
% 	Caltech
% 
% 	Inspired by "smooth2", written by Kelly Hilands, October 2004
% 	Applied Research Laboratory
% 	Penn State University
% 
% 	Developed from code written by Olof Liungman, 1997
% 	Dept. of Oceanography, Earth Sciences Centre
% 	G�teborg University, Sweden
% 	E-mail: olof.liungman@oce.gu.se

%
% Initial error statements and definitions
%
if nargin < 2, error('Not enough input arguments!'), end

    N(1) = Nr; 
    if nargin < 3
        N(2) = N(1); 
    else
        N(2) = Nc; 
    end

if length(N(1)) ~= 1, error('Nr must be a scalar!'), end
if length(N(2)) ~= 1, error('Nc must be a scalar!'), end

%
% Building matrices that will compute running sums.  The left-matrix, eL,
% smooths along the rows.  The right-matrix, eR, smooths along the
% columns.  You end up replacing element "i" by the mean of a (2*Nr+1)-by- 
% (2*Nc+1) rectangle centered on element "i".
%
[row,col] = size(matrixIn);
eL = spdiags(ones(row,2*N(1)+1),(-N(1):N(1)),row,row);
eR = spdiags(ones(col,2*N(2)+1),(-N(2):N(2)),col,col);

%
% Setting all "NaN" elements of "matrixIn" to zero so that these will not
% affect the summation.  (If this isn't done, any sum that includes a NaN
% will also become NaN.)
%
A = isnan(matrixIn);
matrixIn(A) = 0;

%
% For each element, we have to count how many non-NaN elements went into
% the sums.  This is so we can divide by that number to get a mean.  We use
% the same matrices to do this (ie, "eL" and "eR").
%
nrmlize = eL*(~A)*eR;
nrmlize(A) = NaN;

%
% Actually taking the mean.
%
matrixOut = eL*matrixIn*eR;
matrixOut = matrixOut./nrmlize;

end

function cmap=ametrine(n,varargin)
%AMETRINE "Nearly" isoluminant-Colormap compatible with red-green color perception deficiencies
%
%	Written by Matthias Geissbuehler - matthias.geissbuehler@a3.epfl.ch
%	January 2013
%
%   Features:
%     1) All colors have the same luminescence (ideal for lifetime
%        images that will be displayed with an additional transparency map
%        to "mask" places where the lifetime is not well defined)
%     2) Color vision deficient persons can only see reduced color: as much
%        as 10% of adult male persons have a red-green defiency (either
%        Deuteranope  or Protanope) -> as a result they can only distinguish
%        between blue and yellow. A colormap which is "save" for color vision
%        deficient persons is hence only based on these colors.
%        However: people with normal vision DO have a larger space of colors
%        available: it would be a pity to discard this freedom. So the goal
%        must be a colormap that is both using as many colors as possible
%        for normal-sighted people as well as a colormap that will "look"
%        blue-yellow to people with colorblindness without transitions that
%        falsify the information by including a non-distinct transitions
%        (as is the case for many colormaps based on the whole spectrum
%        (ex. rainbow or jet).
%        That's what this colormap here tries to achieve.
%     3) In order to be save for publications, the colormap uses colors that
%        are only from the CMYK colorspace (or at least not too far)
%     4) In comparison to "isolum", this colormap slightly trades off
%        isoluminescence for a higher color contrast
%
%
%   See also: isolum, morgenstemning
%
%
%   Please feel free to use this colormap at your own convenience.
%   A citation to the original article is of course appreciated, however not "mandatory" :-)
%   
%   M. Geissbuehler and T. Lasser
%   "How to display data by color schemes compatible with red-green color perception deficiencies
%   Optics Express, 2013
%
%
%   For more detailed information, please see:
%   http://lob.epfl.ch -> Research -> Color maps
%
%
%   Usage:
%   cmap = ametrine(n)
%
%   All arguments are optional:
%
%   n           The number of elements (256)
%
%   Further on, the following options can be applied
%     'gamma'    The gamma of the monitor to be used (1.8)
%     'minColor' The absolute minimum value can have a different color
%                ('none'), 'white','black','lightgray', 'darkgray'
%                or any RGB value ex: [0 1 0]
%     'maxColor' The absolute maximum value can have a different color
%     'invert'   (0), 1=invert the whole colormap
%
%   Examples:
%     figure; imagesc(peaks(200));
%     colormap(ametrine)
%     colorbar
%
%     figure; imagesc(peaks(200));
%     colormap(ametrine(256,'gamma',1.8,'minColor','black','maxColor',[0 1 0]))
%     colorbar
%
%     figure; imagesc(peaks(200));
%     colormap(ametrine(256,'invert',1,'minColor','white'))
%     colorbar
%
%
%
%
%
%
%     This colormap is free software: you can redistribute it and/or modify
%     it under the terms of the GNU General Public License as published by
%     the Free Software Foundation, either version 3 of the License, or
%     (at your option) any later version.
% 
%     This colormap is distributed in the hope that it will be useful,
%     but WITHOUT ANY WARRANTY; without even the implied warranty of
%     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%     GNU General Public License for more details.
% 
%     You should have received a copy of the GNU General Public License
%     along with this program.  If not, see <http://www.gnu.org/licenses/>.

%   Copyright 2013 Matthias Geissbuehler - matthias.geissbuehler@a3.epfl.ch
%   $Revision: 3.0 $  $Date: 2013/01/29 12:00:00 $
    p=inputParser;
    p.addParamValue('gamma',1.8, @(x)x>0);
    p.addParamValue('minColor','none');
    p.addParamValue('maxColor','none');
    p.addParamValue('invert',0, @(x)x==0 || x==1);

    if nargin==1
        p.addRequired('n', @(x)x>0 && mod(x,1)==0);
        p.parse(n);
    elseif nargin>1
        p.addRequired('n', @(x)x>0 && mod(x,1)==0);
        p.parse(n, varargin{:});
    else
        p.addParamValue('n',256, @(x)x>0 && mod(x,1)==0);
        p.parse();
    end
    config = p.Results;
    n=config.n;

    %the ControlPoints and the spacing between them

    %the ControlPoints in a bit more colorful variant -> slightly less
    %isoluminescence, but gives a more vivid look
    cP(:,1) = [30  60  150]./255; k(1)=1;  %cyan at index 1
    cP(:,2) = [180 90  155]./255; k(3)=17; %purple at index 17
    cP(:,3) = [230 85  65 ]./255; k(4)=32; %redish at index 32
    cP(:,4) = [220 220 0  ]./255; k(5)=64; %yellow at index 64
    for i=1:3
        f{i}   = linspace(0,1,(k(i+1)-k(i)+1))';  % linear space between these controlpoints
        ind{i} = linspace(k(i),k(i+1),(k(i+1)-k(i)+1))';
    end
    cmap = interp1((1:4),cP',linspace(1,4,64)); % for non-iso points, a normal interpolation gives better results


    % normal linear interpolation to achieve the required number of points for the colormap
    cmap = abs(interp1(linspace(0,1,size(cmap,1)),cmap,linspace(0,1,n)));

    if config.invert
        cmap = flipud(cmap);
    end

    if ischar(config.minColor)
        if ~strcmp(config.minColor,'none')
            switch config.minColor
                case 'white'
                    cmap(1,:) = [1 1 1];
                case 'black'
                    cmap(1,:) = [0 0 0];
                case 'lightgray'
                    cmap(1,:) = [0.8 0.8 0.8];
                case 'darkgray'
                    cmap(1,:) = [0.2 0.2 0.2];
            end
        end
    else
        cmap(1,:) = config.minColor;
    end
    if ischar(config.maxColor)
            if ~strcmp(config.maxColor,'none')
                switch config.maxColor
                        case 'white'
                            cmap(end,:) = [1 1 1];
                        case 'black'
                            cmap(end,:) = [0 0 0];
                        case 'lightgray'
                            cmap(end,:) = [0.8 0.8 0.8];
                        case 'darkgray'
                            cmap(end,:) = [0.2 0.2 0.2];
                end
            end
    else
            cmap(end,:) = config.maxColor;
    end
end

