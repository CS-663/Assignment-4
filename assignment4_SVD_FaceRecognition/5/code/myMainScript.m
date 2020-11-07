%% MyMainScript

tic;
%% Your code here
% https://in.mathworks.com/matlabcentral/answers/147197-how-to-return-files-with-a-specific-extension-using-dir
warning('off','all');
k = [2, 10, 20, 50, 75, 100, 125, 150, 175];
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
U = normc(U);

faceNumber = 11;

for i=1:size(k,2)
    U_k = U(:,1:k(i));
    A_train = (U_k')*mean_sub_train_set;
    image = normc(U(:,1:k(i)))*A_train(:,faceNumber);
    image = contrast_streching(reshape(image, 112, 92));
    subplot(3, 3, i);
    imshow(image);
    title(['Number of top eigenvectors considered = ',num2str(k(i))]);
end

figure;
for i=1:25
    image = contrast_streching(reshape(U(:, i), 112, 92));
    subplot(5,5,i);
    imshow(image);
    title(['Eigenvector: ' num2str(i)]);
end

toc;
