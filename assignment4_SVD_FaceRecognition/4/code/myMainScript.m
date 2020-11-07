%% MyMainScript

tic;
%% Your code here
% https://in.mathworks.com/matlabcentral/answers/147197-how-to-return-files-with-a-specific-extension-using-dir
warning('off','all');
k = [1, 2, 3, 5, 10, 15, 20, 30, 50, 75, 100, 150, 170];
datasetORL = '../../../ORL/';
[train_set, test_set] = datasetCreationORL(datasetORL);

% Calculating mean for train and test set
mean_train_set = mean(train_set, 2);
% mean_test_set = mean(test_set, 2);

% Subtracting mean from train and test set
mean_sub_train_set = bsxfun(@minus, train_set, mean_train_set);
mean_sub_test_set = bsxfun(@minus, test_set, mean_train_set); % Subtracting the mean of train set

%% Calculating recognition rates of ORL dataset using SVD
[U,~,~] = svd(mean_sub_train_set);
recog_rate = double.empty(size(k,2),0);
for i=1:size(k,2)
    U_k = normc(U(:,1:k(i)));
    A_train = (U_k')*mean_sub_train_set;
    A_test = (U_k')*mean_sub_test_set;
    recog_rate(i) = sq_diff(A_train, A_test);
end
    
% disp(recog_rate);

plot(k,recog_rate), 
xlabel('k'), ylabel('Accuracy')
title('Recognition rates using ORL dataset and SVD')


%% Calculating recognition rates of ORL dataset using EIG
[V, D] = eig(mean_sub_train_set'*mean_sub_train_set);
[a, b]=sort(diag(D), 'descend');
% Umax10=U(:,b(1:10));
U = mean_sub_train_set*V;
recog_rate = double.empty(size(k,2),0);
for i=1:size(k,2)
    U_k = normc(U(:,b(1:k(i))));
    A_train = (U_k')*mean_sub_train_set;
    A_test = (U_k')*mean_sub_test_set;
    recog_rate(i) = sq_diff(A_train, A_test);
end
    
% disp(recog_rate);

figure;
plot(k,recog_rate), 
xlabel('k'), ylabel('Accuracy')
title('Recognition rates using ORL dataset and EIG')

%% On YALE dataset
k = [1, 2, 3, 5, 10, 15, 20, 30, 50, 60, 65, 75, 100, 200, 300, 500, 1000];
datasetYALE = '../../../CroppedYale';
[train_set, test_set] = datasetCreationYale(datasetYALE);

% Calculating mean for train and test set
mean_train_set = mean(train_set, 2);
% mean_test_set = mean(test_set, 2);

% Subtracting mean from train and test set
mean_sub_train_set = bsxfun(@minus, train_set, mean_train_set);
mean_sub_test_set = bsxfun(@minus, test_set, mean_train_set); % Subtracting the mean of train set


%% Calculating recognition rates of Yale dataset using SVD
% [U,~,~] = svd(mean_sub_train_set);
[U_Yale,S,~] = svd(mean_sub_train_set);
% U_Yale = mean_sub_train_set*U_Yale;
[a, b]=sort(diag(S), 'descend');
recog_rate = double.empty(size(k,2),0);
for i=1:size(k,2)
    U_k = normc(U_Yale(:,b(1:k(i))));
%     U_k = normc(U_Yale(:,1:k(i)));
    A_train = (U_k')*mean_sub_train_set;
    A_test = (U_k')*mean_sub_test_set;
    recog_rate(i) = sq_diff_yale(A_train, A_test);
end
    
% disp(recog_rate);

figure;
plot(k,recog_rate), 
xlabel('k'), ylabel('Accuracy')
title('Recognition rates using Yale dataset and Including First Three Eigenvectors')

%% Excluding the first Three eigen vectors
recog_rate = double.empty(size(k,2),0);
for i=1:size(k,2)
    U_k = normc(U_Yale(:,b(4:k(i)+3)));
%     U_k = normc(U_Yale(:,3:k(i)+3));
    A_train = (U_k')*mean_sub_train_set;
    A_test = (U_k')*mean_sub_test_set;
    recog_rate(i) = sq_diff_yale(A_train, A_test);
end
    
% disp(recog_rate);

figure;
plot(k,recog_rate), 
xlabel('k'), ylabel('Accuracy')
title('Recognition rates using Yale dataset and Excluding First Three Eigenvectors')



toc;
