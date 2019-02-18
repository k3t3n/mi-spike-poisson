function [ I ] = mutual_info( w1,lambda1, w2,lambda2 )
%MUTUAL_INFO for two Poisson r.v's
%  Calculate Mutual Information through numerical approximation
%  w1 = weight of Poisson r.v. with mean/rate lambda1
%  w2 = weight of Poisson r.v. with mean/rate lambda2
 
  I = poisson_mixture(w1,lambda1, w2,lambda2) - cond_entropy(w1,lambda1, w2,lambda2);
  I = I*log2(exp(1)); %convert into 'bits' log base 2
  % Maximum MI for equal weights is 1 bit
  if isnan(I)
        I = 0;
  end
end


function [ H_Yx ] = cond_entropy( w1,lambda1, w2,lambda2 )
%Calculates the conditional entropy
H_Yx = w1*entropy(lambda1) + w2*entropy(lambda2);
end
