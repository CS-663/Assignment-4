function recog_rate = sq_diff_yale(coff_train, coff_test)
    [~, test_size] = size(coff_test);
    
    total_matched = 0;
    for i=1:test_size
        temp = bsxfun(@minus, coff_train, coff_test(:,i)).^2;
        error = sum(temp,1);
        [~,I] = min(error);
        if(floor((i-1)/20) == floor((I-1)/40))
            total_matched = total_matched + 1;
        end
    end
    recog_rate = 100*(total_matched/test_size);
end