function [train_set, test_set] = datasetCreationORL(dataset)
    fileList = dir(dataset);

    % https://in.mathworks.com/matlabcentral/answers/379746-how-do-i-find-a-folder-with-a-specified-string
    % https://in.mathworks.com/matlabcentral/answers/244805-problem-with-regexp-when-multiple-file-in-a-folder
    filenames = {fileList.name};
    not_match = cellfun(@isempty, regexp(filenames, '^s\d', 'match'));
    match_folders = filenames(~not_match);

    [~,noOfFolders] = size(match_folders);

    train_set = uint8.empty;
    test_set = uint8.empty;

    for i = 1:32
        imageList = dir(strcat(dataset, match_folders{i}));
        imagenames = {imageList.name};

        % Extracting files for training
        not_match = cellfun(@isempty, regexp(imagenames, '[1-6].pgm', 'match'));
        train_files = imagenames(~not_match);
        [~, train_files_size] = size(train_files);
        for j = 1:train_files_size
            image_path = fullfile(dataset, match_folders{i}, train_files{j});
            train_set = cat(2, train_set, reshape(imread(image_path), [], 1));
        end

        % Extracting files for testing
        not_match = cellfun(@isempty, regexp(imagenames, '[^1-6].pgm', 'match'));
        test_files = imagenames(~not_match);
        [~, test_files_size] = size(test_files);
        for j=1:test_files_size
            image_patch = fullfile(dataset, match_folders{i}, test_files{j});
            test_set = cat(2, test_set, reshape(imread(image_patch), [], 1));
        end
    end
    
    train_set = double(train_set);
    test_set = double(test_set);
    
end