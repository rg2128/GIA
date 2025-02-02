function ma = movingave(x,k,windowmode)
% movingave: efficient windowed standard deviation of a time series
% usage: ma = movingave(x,k,windowmode)
% author: C. Ron Yu, Stowers Institute
% Inspired by the movingstd function from John D'Errico

% Movingave uses filter to compute the moving average and repair ends.
% Beware that this formula can suffer from numerical problems for
% data which is large in magnitude.
%
% arguments: (input)
%  x   - vector containing time series data
%
%  k   - size of the moving window to use (see windowmode)
%        All windowmodes adjust the window width near the ends of
%        the series as necessary.
%
%        k must be an integer, at least 1 for a 'central' window,
%        and at least 2 for 'forward' or 'backward'
%
%  windowmode - (OPTIONAL) flag, denotes the type of moving window used
%        DEFAULT: 'central'
%
%        windowmode = 'central' --> use a sliding window centered on
%            each point in the series. The window will have total width
%            of 2*k+1 points, thus k points on each side.
%        
%        windowmode = 'backward' --> use a sliding window that uses the
%            current point and looks back over a total of k points.
%        
%        windowmode = 'forward' --> use a sliding window that uses the
%            current point and looks forward over a total of k points.
%
%        Any simple contraction of the above options is valid, even
%        as short as a single character 'c', 'b', or 'f'. Case is
%        ignored.
%
% arguments: (output)
%  s   - vector containing the windowed standard deviation.
%        length(s) == length(x)

% check for a windowmode
if (nargin<3) || isempty(windowmode)
  % supply the default: 
  windowmode = 'central';
elseif ~ischar(windowmode)
  error 'If supplied, windowmode must be a character flag.'
end
% check for a valid shortening.
valid = {'central' 'forward' 'backward'};
windowmode = lower(windowmode);
ind = strmatch(windowmode,valid);
if isempty(ind)
  error 'Windowmode must be a character flag: ''c'', ''b'', or ''f''.'
else
  windowmode = valid{ind};
end

% length of the time series
n = length(x);

% check for valid k
if (nargin<2) || isempty(k) || (rem(k,1)~=0)
  error 'k was not provided or not an integer.'
end
switch windowmode
  case 'central'
    if k<1
      error 'k must be at least 1 for windowmode = ''central''.'
    end
    if n<(2*k+1)
      error 'k is too large for this short of a series and this windowmode.'
    end
  otherwise
    if k<2
      error 'k must be at least 2 for windowmode = ''forward'' or ''backward''.'
    end
    if (n<k)
      error 'k is too large for this short of a series.'
    end
end

% Improve the numerical analysis by subtracting off the series mean
% this has no effect on the standard deviation.
% x = x - mean(x);

% we will need the squared elements 
% x2 = x.^2;

% split into the three windowmode cases for simplicity
A = 1;
switch windowmode
  case 'central'
    B = ones(1,2*k+1);
    ma = filter(B,A,x)/(2*k+1);
    ma(k:(n-k)) = ma((2*k):end);
  case 'forward'
    B = ones(1,k);
    ma = filter(B,A,x)/k;
    ma(1:(n-k+1)) = ma(k:end);
  case 'backward'
    B = ones(1,k);
    ma = filter(B,A,x)/k;
end

% special case the ends as appropriate
switch windowmode
  case 'central'
    % repairs are needed at both ends
    for i = 1:k
      ma(i) = mean(x(1:(k+i)));
      ma(n-k+i) = mean(x((n-2*k+i):n));
    end
  case 'forward'
    % the last k elements must be repaired
    for i = (k-1):-1:1
      ma(n-i+1) = mean(x((n-i+1):n));
    end
  case 'backward'
    % the first k elements must be repaired
    for i = 1:(k-1)
      ma(i) = mean(x(1:i));
    end
end


