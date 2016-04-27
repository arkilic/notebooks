function [ pri ] = analyeur(S,K,r, sigma, T,t, fig_num )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
d1=1/sigma/sqrt(T-t)*(log(S/K)+(r+0.5*sigma^2)*(T-t));
d2=d1-sigma*sqrt(T-t);
figure(fig_num)
pri=S.*normcdf(d1)-exp(-r*(T-t))*K*normcdf(d2);
plot(S,pri);
end
