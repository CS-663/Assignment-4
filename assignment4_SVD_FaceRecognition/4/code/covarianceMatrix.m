function C = covarianceMatrix(X)
    [~,N] = size(X);
    X_transpose = X.';
    temp_C = mtimes(X, X_transpose);
    C = temp_C./(N-1);
end