function Y = uniform2gaussian(X, min, max, mu, sigma)
%% UNIFORM2GAUSSIAN Converts a uniformly distributed data into Gaussian distributed data
%
%   X:  input data X which is uniformly distributed (min, max)
%   mu:     mean of the new Gaussian data
%   sigma:  standard deviation of the new Gaussian data
%   Y:  output data Y which is normally distributed with mean mu and
%   standard deviation sigma
%
%   The input data is remapped to be within [0, 1] and then the inverse of
%   the CDF associated with a Normal(mu, sigma) random variable is applied.
%
%   Billy McDermot, July 2022

%% get parameters
[D, T] = size(X);

%% remap data to [0, 1]
new_X = zeros(D, T);
for d = 1:D
    X_d = X(d,:);
    X1 = (X_d-min) / (max - min);
    new_X(d,:) = X1;
end

%% apply inverse CDF
Y = mu + sqrt(2)*sigma*erfinv(2*new_X-1);

end