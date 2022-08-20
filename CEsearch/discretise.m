function [discrete_X] = discretise(X, quantiles)
%   DISCRETISE(X, QUANTILES)
%
%   Function that discretises data X into n quantiles. Each quantile occurs
%   with equal frequency. E.g., using quantiles=2 will discretise X into 2
%   levels, setting values equal to 1 when they are less than the 1st 
%   quantile (median) and 2 when they are greater.
%
%   Billy McDermot, July 2022

% parameter check
if mod(quantiles,1) ~= 0 || quantiles < 2
    error("quantiles must be a positive integer greater than 2.")
end

% shape of X
[m, n] = size(X);

% initialise the discretised X
discrete_X = zeros(m, n);

% find the quantile boundaries
if quantiles == 2           % edge case when we want to discretise data into 2 levels
    qs = quantile(X(:), 0.5);   % returns the value that 50% of the data is less than
else
    qs = quantile(X(:), quantiles-1);
end
qs(end+1) = inf;    % include +inf as the last boundary

% assign each element of X a new value depending on which boundaries it
% lies between
for i = 1:m
    for j = 1:n
        % find first quantile greater than X_ij
        idx = find(qs > X(i,j), 1);
        discrete_X(i, j) = idx;
    end
end

end