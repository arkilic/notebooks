function [ price ] = impeur( T,K,r,sigma,n,m,delta_x,t)
%% Finite difference implementation and plot of the underlying european call
%% value
deltat=T/n;
a=ones(2*m-1,1)*(-0.5*deltat*sigma^2/delta_x^2+deltat*(r-0.5*sigma^2)/2/delta_x);
b=ones(2*m-1,1)*(1+deltat*(r+sigma^2/delta_x^2));
c=-ones(2*m-1,1)*(deltat*((r-0.5*sigma^2)/2/delta_x+0.5*sigma^2/delta_x^2));
u=zeros(2*m-1,1);
B_mat=zeros(2*m-1,n+1);
for i=-m+1:m-1
    u(i+m)=max(0,exp(i*delta_x)-K);
end
B_mat(:,end)=u;
d=u;
d(end)=d(end)+deltat*((r-0.5*sigma^2)/2/delta_x+0.5*sigma^2/delta_x^2)...
    *(exp(m*delta_x)-exp(-r*(0+1)*deltat)*K);
for l=1:n
    x=tdma(a,b,c,d);
    d=x;
   d(end)=d(end)+deltat*((r-0.5*sigma^2)/2/delta_x+0.5*sigma^2/delta_x^2)...
    *(exp(m*delta_x)-exp(-r*(0+1)*deltat)*K);
B_mat(:,n+1-l)=x;
end
mat=zeros(2*m+1,n+1);
mat(2:2*m,:)=B_mat;
for l=1:n+1
    mat(end,n+2-l)=exp(m*delta_x)-exp(-r*l*deltat)*K;
end
y=zeros(1001,1);
for i=0:1000
    y(i+1)=exp(i*delta_x);
end
plot(y,mat(m+1:m+1001,t/deltat+1));
xlabel('Stock Price')
ylabel('Call Value')
price=mat;
end
