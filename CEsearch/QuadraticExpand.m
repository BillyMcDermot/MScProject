function [ expanded_data ] = QuadraticExpand(data)
%% Multiply every feature by every other feature to generate the quadratic expansion of the data
%     input data is DxT with D features over T time points.
%
% Billy McDermot, June 2022

%% determine the size of the new dataset
[D, T] = size(data);
expanded_data = cat(1, data, zeros( D/2*(D+1), T ));

%% element-wise multiply each row with every other row from the input data
k = D+1;            % first index for new entries in expanded data
for i = 1:D
    for j = i:D
        expanded_data(k,:) = data(i,:).*data(j,:);
        k = k+1;
    end
end

end