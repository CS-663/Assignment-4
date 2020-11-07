%% MyMainScript

tic;
%% Your code here
% https://in.mathworks.com/matlabcentral/answers/147197-how-to-return-files-with-a-specific-extension-using-dir
warning('off','all');
k = 25;
thresh = 4500;
datasetORL = '../../../ORL/';
[train_set, test_set] = datasetCreationORL(datasetORL);
test_new_set = datasetNew(datasetORL);

% Calculating mean for train and test set
mean_train_set = mean(train_set, 2);

% Subtracting mean from train and test set
mean_sub_train_set = bsxfun(@minus, train_set, mean_train_set);
mean_sub_test_set = bsxfun(@minus, test_set, mean_train_set); % Subtracting the mean of train set
mean_sub_test_new_set = bsxfun(@minus, test_new_set, mean_train_set);

%% Calculating recognition rates of ORL dataset using SVD
[U,~,~] = svd(mean_sub_train_set);
U = normc(U);

U_k = U(:,1:k);
% Eigen coefficients for the training set
A_train = (U_k')*mean_sub_train_set;

% Eigen coefficiets for the test set
A_test = (U_k')*mean_sub_test_set;

% Eigen coefficients for the new test set
A_test_new = (U_k')*mean_sub_test_new_set;

[~,test_size] = size(A_test);
false_negative = 0;
for i=1:test_size
        temp = bsxfun(@minus, A_train, A_test(:,i)).^2;
        error = sum(temp,1)/1000; % dividing by 1000 to keep the thresh values lower
        M = min(error);
        if(M > thresh)
            false_negative = false_negative + 1;
        end
end
disp(false_negative);

[~,test_size] = size(A_test_new);
false_positive = 0;
for i=1:test_size
        temp = bsxfun(@minus, A_train, A_test_new(:,i)).^2;
        error = sum(temp,1)/1000; % dividing by 1000 to keep the thresh values lower
        M = min(error);
        if(M < thresh)
            false_positive = false_positive + 1;
        end
end
disp(false_positive);

toc;
