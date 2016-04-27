function [ pri ] = eurcallanaly(S,K,r, sig, T,t )
d1=1/sig/sqrt(T-t)*(log(S/K)+(r+0.5*sig^2)*(T-t));
d2=d1-sig*sqrt(T-t);
 
pri=S.*normcdf(d1)-exp(-r*(T-t))*K*normcdf(d2);
plot(S,pri);
end

