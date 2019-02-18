function H_Y = poisson_mixture( w1,lambda1, w2,lambda2 )
%POISSON_MIXTURE model entropy of two r.v's
%  Uses numerical summation to calculate the mixture entropy of two
%  Poisson variables.
%  w1 = weight of Poisson r.v. with mean/rate lambda1
%  w2 = weight of Poisson r.v. with mean/rate lambda2

  H_Y = 0;
  for y = 0:3*max(lambda1, lambda2) % summation limit
      
      if  isinf(factorial(y))
          break
      else
          fy = factorial(y); % factorial of y
      end
      
      p_y1 = exp(-lambda1).*(lambda1.^y)./fy; % Poisson pdf 1
      p_y2 = exp(-lambda2).*(lambda2.^y)./fy; % Poisson pdf 2
      p = w1*p_y1 + w2*p_y2;
      if  isinf(p)
          break
      else
          H_Y = H_Y - p*log(p);
      end
 
  end


end

