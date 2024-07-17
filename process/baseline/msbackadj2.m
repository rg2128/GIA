function [Y b] = msbackadj2(MZ,Y,varargin)
%% Lines 277-281, 286-289 modified by Elden @ May 11 2010
%  so that it throws away those rapidly changing points
%MSBACKADJ provides background correction for a mass spectrometry signal
%
%   YOUT = MSBACKADJ(MZ,Y) adjusts the variable background (baseline) of a
%   mass spectrometry signal by following three steps: 1) estimates the
%   background within multiple shifted windows of width 200 (MZ scale), 2)
%   regresses the varying baseline to the window points using a spline
%   approximation, and 3) adjusts the background of the input signal Y. 
%
%   MZ is the mass-charge column vector with the same size as the vector of
%   ion intensity samples Y (or spectrum). Y can be a matrix with several 
%   spectrograms, all sharing the same MZ scale.
%
%   MSBACKADJ(...,'WINDOWSIZE',WS) sets the width for the shifting window.
%   The default is 200, which means a background point is estimated for
%   windows of 200 MZ in width. WS may also be a function handle. The
%   referenced function is evaluated at each MZ value to compute a variable
%   width for the windows. This option is very useful for cases where the
%   resolution of the signal is dissimilar at different regions of the
%   spectrogram.
%
%   MSBACKADJ(...,'STEPSIZE',SS) sets the steps for the shifting window.
%   The default is 200, which means a background point is estimated for
%   windows at every 200 MZ. SS may also be a function handle. The
%   referenced function is evaluated at each MZ value to compute the
%   distance between adjacent windows.
%
%   MSBACKADJ(...,'REGRESSIONMETHOD',RM) sets the method used to regress
%   the window estimated points to a soft curve. The default is 'pchip';
%   i.e., shape-preserving piecewise cubic interpolation. Other options are
%   'linear' and 'spline' interpolation.
%
%   MSBACKADJ(...,'ESTIMATIONMETHOD',EM) sets the method used to find the
%   likely background value at every window. Default is 'quantile', in
%   which the quantile value is set to 10%. An alternative method is 'em',
%   which assumes a doubly stochastic model; i.e., every sample is the
%   i.i.d. draw of any of two normal distributed classes (background or
%   peaks). Because the class label is hidden, the distributions are
%   estimated with an expectation-maximization algorithm. The ultimate
%   background value is the mean of the background class.
%
%   MSBACKADJ(...,'SMOOTHMETHOD',SM) sets the method used to smooth the
%   curve of estimated points, useful to eliminate the effect of possible
%   outliers. Options are 'none' (default), 'lowess' (linear fit), 'loess'
%   (quadratic fit), or 'rlowess' and 'rloess' (robust linear and quadratic
%   fit).
%
%   MSBACKADJ(...,'QUANTILEVALUE',QV) changes the default quantile value.
%   The default is 0.10.
%
%   MSBACKADJ(...,'PRESERVEHEIGHTS',true) sets the baseline subtraction
%   mode to preserve the height of the tallest peak in the signal when
%   subtracting the baseline. By default heights are not preserved.
%
%   MSBACKADJ(...,'SHOWPLOT',SP) plots the background estimated points, the
%   regressed baseline, and the original spectrogram. When SP is TRUE, the
%   first spectrogram in Y is used. If MSBACKADJ is called without output
%   arguments, a plot will be shown unless SP is FALSE. SP can also contain
%   an index to one of the spectrograms in Y. 
%
%   Examples: 
%
%      load sample_lo_res
%
%      % Adjust the baseline of a group of spectrograms.
%      YB = msbackadj(MZ_lo_res,Y_lo_res);
%
%      % Plot the third spectrogram in Y_lo_res and its estimated baseline.
%      msbackadj(MZ_lo_res,Y_lo_res,'SHOWPLOT',3);
%
%      % Plot the estimated baseline for the fourth spectrogram in Y_lo_res
%      % using an anonymous function to describe a MZ dependent parameter.
%      wf = @(mz) 200 + .001 .* mz;
%      msbackadj(MZ_lo_res,Y_lo_res(:,4),'STEPSIZE',wf);
%
%   See also MSALIGN, MSHEATMAP, MSLOWESS, MSNORM, MSRESAMPLE, MSSGOLAY,
%   MSVIEWER. 

%   Copyright 2003-2005 The MathWorks, Inc.
%   $Revision: 1.1.12.2 $  $Date: 2005/06/09 21:58:22 $

% References: 
% [1] Lucio Andrade and Elias Manolakos, "Signal Background Estimation and
%     Baseline Correction Algorithms for Accurate DNA Sequencing" Journal
%     of VLSI, special issue on Bioinformatics 35:3 pp 229-243 (2003)

% set defaults
stepSize = 200;
windowSize = 200;
regressionMethod = 'pchip';
estimationMethod = 'quantile';
smoothMethod = 'none';
quantileValue = 0.1;
preserveHeights = false;
maxNumWindows = 1000;
if nargout == 1
    plotId = 0; 
else
    plotId = 1;
end

if  nargin > 2
    if rem(nargin,2) == 1
        error('Bioinfo:msbackadj:IncorrectNumberOfArguments',...
            'Incorrect number of arguments to %s.',mfilename);
    end
    okargs = {'stepsize','windowsize','regressionmethod',...
              'estimationmethod','quantilevalue','preserveheights',...
              'smoothmethod','showplot'};
    for j=1:2:nargin-2
        pname = varargin{j};
        pval = varargin{j+1};
        k = strmatch(lower(pname), okargs); %#ok
        if isempty(k)
            error('Bioinfo:msbackadj:UnknownParameterName',...
                'Unknown parameter name: %s.',pname);
        elseif length(k)>1
            error('Bioinfo:msbackadj:AmbiguousParameterName',...
                'Ambiguous parameter name: %s.',pname);
        else
            switch(k)
                case 1  % step size
                    stepSize = pval;
                    if ~isscalar(stepSize) && ~isa(stepSize,'function_handle')
                        error('Bioinfo:msbackadj:NotValidStepSize',...
                              'STEP must be a scalar or a function handle.')
                    end
                case 2 % window size
                    windowSize = pval;
                    if ~isscalar(windowSize) && class(windowSize,'function_handler')
                        error('Bioinfo:msbackadj:NotValidWindowSize',...
                              'WIDTH must be a scalar or a function handle.')
                    end
                case 3 % regression method
                    regressionMethods = {'cubic','pchip','spline','linear'};
                    regressionMethod = strmatch(lower(pval),regressionMethods); %#ok
                    if isempty(regressionMethod) 
                        error('Bioinfo:msbackadj:NotValidRegressionMethod',...
                              'Not a valid regression method.')
                    end
                    regressionMethod = regressionMethods{max(2,regressionMethod)};
                case 4 % estimation method
                    estimationMethods = {'quantile','em'};
                    estimationMethod = strmatch(lower(pval),estimationMethods); %#ok
                    if isempty(estimationMethods) 
                        error('Bioinfo:msbackadj:NotValidEstimationMethod',...
                              'Not a valid estimation method.')
                    end
                    estimationMethod = estimationMethods{estimationMethod};
                case 5 % quantile value
                    quantileValue = pval;
                case 6 % preserve heights
                    preserveHeights = opttf(pval);
                case 7 % smoothing method
                    smoothMethods = {'none','lowess','loess','rlowess','rloess'};
                    smoothMethod = strmatch(lower(pval),smoothMethods); %#ok
                    if isempty(smoothMethod) 
                        error('Bioinfo:msbackadj:NotValidSmoothMethod',...
                              'Not a valid smoothing method.')
                    elseif length(smoothMethod)>1
                        error('Bioinfo:msbackadj:AmbiguousSmoothMethod',...
                              'Ambiguous smoothing method: %s.',pname);
                    end
                    smoothMethod = smoothMethods{smoothMethod};
                case 8 % show
                    if opttf(pval) 
                        if isnumeric(pval)
                            if isscalar(pval)
                                plotId = double(pval); 
                            else
                                plotId = 1;
                                warning('Bioinfo:msbackadj:SPNoScalar',...
                                'SHOWPLOT must be a single index to one of the spectrograms in Y or\na logica. Plotting the first column in Y only.')
                            end 
                        else
                            plotId = 1;
                        end
                    else
                        plotId = 0;
                    end
            end
        end
    end
end

% validate MZ and Y

if ~isnumeric(Y) || ~isreal(Y)
   error('Bioinfo:msbackadj:IntensityNotNumericAndReal',...
       'Ion intensities must be numeric and real.') 
end

if ~isnumeric(MZ) || ~isreal(MZ)
   error('Bioinfo:msbackadj:MZNotNumericAndReal',...
       'MZ scale must be numeric and real.') 
end

if size(MZ,1) ~= size(Y,1)
   error('Bioinfo:msbackadj:NotEqualNumberOfSamples',...
       'The ion intensity vector(s) must have the same number\nof samples as the MZ scale.')
end
 
numSpectrograms = size(Y,2);

if (plotId~=0) && ~any((1:numSpectrograms)==plotId)
    warning('Bioinfo:msbackadj:InvalidPlotIndex',...
    'SHOWPLOT value is not a valid spectrogram index, no plot was generated.')
end

multiple_mz = false;
if size(MZ,2)>1
    multiple_mz = true;
    if size(MZ,2) ~= numSpectrograms
        error('Bioinfo:msbackadj:NotEqualNumberOfMZScales',...
        'A MZ scale must be supplied for every ion intensity vector when size(MZ,2)>1.')
    end
end

% change scalars to function handlers
if isnumeric(stepSize)   
    stepSize   = @(x) repmat(stepSize,size(x));   
end
if isnumeric(windowSize) 
    windowSize = @(x) repmat(windowSize,size(x)); 
end

% allocate space for mzp and WE
mzp = zeros(maxNumWindows,1);
WE = nan(maxNumWindows,1);

% calculates the location of the windows (when it is the same for all the
% spectrograms)
if ~multiple_mz
    mzpid = max(0,MZ(1));
    MZend = MZ(end);
    id = 1;
    while mzpid <= MZend
        mzp(id) = mzpid;
        mzpid = mzpid + stepSize(mzpid);
        id = id + 1;
        if id > maxNumWindows
            error('Bioinfo:msbackadj:maxNumWindowsExceeded',...
            'Maximum number of windows exceeded,\nverify the STEP value or function handle.')
        end
    end
    numWindows = id-1;
end

% iterate for every spectrogram
for ns = 1:numSpectrograms 
if nargout>0 || (ns == plotId)
     
    % find the location of the windows (when it is different for very
    % spectrogram, otherwise this was done out of the loop)
    if multiple_mz
       mzpid = max(0,MZ(1,ns));
       MZend = MZ(end,ns);
       id = 1; mzp = [];
       while mzpid <= MZend
           mzp(id) = mzpid;
           mzpid = mzpid + stepSize(mzpid);
           id = id + 1;
           if id > maxNumWindows
                error('Bioinfo:msbackadj:maxNumWindowsExceeded',...
                'Maximum number of windows exceeded,\nverify the STEP value or function handle.')
           end
       end
       numWindows = id-1;
       nnss = ns;
    else
       nnss = 1;
    end    
    mzpt = mzp(1:numWindows); 
    mzw = windowSize(mzpt);
 
    % start modification by Elden @ May 11 2010    
    tY = Y(MZ(:,nnss),ns);
    tmp = abs(tY(2:end)-tY(1:end-1));
    tyThreshold = quantile(tmp,0.75);% use only 75% 
    % end modification by Elden @ May 11 2010
    
    % find the estimated baseline for every window
    for nw = 1:numWindows
        subw = Y(MZ(:,nnss)>=mzpt(nw) & MZ(:,nnss)<= (mzpt(nw)+mzw(nw)),ns);
        % start modification by Elden @ May 11 2010    
        tmp = abs(subw(2:end)-subw(1:end-1));
        subw = subw(tmp<=tyThreshold);
        % end modification by Elden @ May 11 2010

        switch estimationMethod
            case 'quantile'
                WE(nw) = quantile(subw,quantileValue);
            case 'em'
                WE(nw) = em2c1d(subw);
        end
    end % for nw = 1:numWindows
    
    % smooth the estimated points
    if ~isequal('none',smoothMethod)
        WE(1:numWindows) = ...
            masmooth(mzpt+mzw/2,WE(1:numWindows),10,smoothMethod,2);
    end
            
    % regress the estimated points
    b = interp1(mzpt+mzw/2,WE(1:numWindows),MZ(:,nnss),regressionMethod);
    
%     if (ns == plotId)
%        figure
%        plot(MZ(:,nnss),Y(:,ns))
%        hold on
%        plot(MZ(:,nnss),b,'r','linewidth',2)
%        plot(mzpt+mzw/2,WE(1:numWindows),'kx')
%        title(sprintf('Spectrogram ID: %d',ns));
%        xlabel('Mass/Charge (M/Z)')
%        ylabel('Relative Intensity')
%        legend('Original spectrogram','Regressed baseline','Estimated baseline points')
%        axis([min(MZ(:,nnss)) max(MZ(:,nnss)) min(Y(:,ns)) max(Y(:,ns))])
%        grid on
%        hold off
%     end
    
    % apply the correction
    if preserveHeights
        K = 1 - b/max(Y(:,ns));
        Y(:,ns) = (Y(:,ns) - b) ./ K;
        %[YMax,locMax] = max(Y(:,ns));
        %K = 1 - b(locMax)/YMax;
        %Y(:,ns) = (Y(:,ns) - b) / K;
    else
        Y(:,ns) = (Y(:,ns) - b);
    end 

end % if nargout>0 || (ns == plotId)    
end % for ns = 1:numSpectrograms 

    
    
