function [U, S, V] = mySVD(A)
% A= USV' => A is m*n, U is m*m, S is m*n, V is n*n
    [U, D] = eig(A*A');
    [~, Ind] = sort(diag(D), 'descend');
    U = U(:, Ind);
    
    [V, D] = eig(A'*A);
    [~, Ind] = sort(diag(D), 'descend');
    V = V(:, Ind);
% A = USV' => S = U'AV
% But S here may contain negative singular values at diagonal matrix
% This could be solved by turning negative column vectors U corresponding
% to negative values at S
    S = U'*A*V;
    [m,n] = size(S);
    
    for i=1:min(m,n)
        if(S(i,i) < 0)
            U(:, i) = -U(:, i);
        end
    end
    S = abs(S);
end