function H  = entropy( lambda )
%ENTROPY of a Poisson r.v.
%   Calculates entropy by brute force numerical smmation

    H  = 0; % initialize entropy H 
    py = 0; % initialize Poisson pdf 

    %%% Set upper limits for the summation
    % these limits can be played around with 
    if lambda<50
        int_limit=150;
    else
        int_limit=4*lambda;
    end


    %%% Entropy
    for y = 1:int_limit
        
        if  isinf(factorial(y))
            break
        else
            fy = factorial(y); % factorial of y
        end
        
        py = exp(-lambda).*(lambda.^y)./fy; % Poisson pdf
        
        if  isinf(py)
            break
        else
            H = H - py*log(py);
        end
        
    end

    
    % % Use Stirlig approx.
    %  H = 0.5*log(2*pi*exp(1)*lambda)...
    %     -1/(12*lambda)...
    %     -1/(24*lambda^2);

end

