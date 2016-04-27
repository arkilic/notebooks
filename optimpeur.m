%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [ price ] = optimpeur( T,K,r,sig,N,matrx,deltx,t)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
delt_t=T/N;
a=ones(2*matrx-1,1)*(-0.5*delt_t*sig^2/deltx^2+delt_t*(r-0.5*sig^2)/2/deltx);
b=ones(2*matrx-1,1)*(1+delt_t*(r+sig^2/deltx^2));
c=-ones(2*matrx-1,1)*(delt_t*((r-0.5*sig^2)/2/deltx+0.5*sig^2/deltx^2));
u=zeros(2*matrx-1,1);
B_Matrix=zeros(2*matrx-1,N+1);
for i=-matrx+1:matrx-1
    u(i+matrx)=max(0,exp(i*deltx)-K);
end
B_Matrix(:,end)=u;
d=u;
d(end)=d(end)+delt_t*((r-0.5*sig^2)/2/deltx+0.5*sig^2/deltx^2)...
    *(exp(matrx*deltx)-exp(-r*(0+1)*delt_t)*K);
for l=1:N
    x=tdma(a,b,c,d);
    d=x;
   d(end)=d(end)+delt_t*((r-0.5*sig^2)/2/deltx+0.5*sig^2/deltx^2)...
    *(exp(matrx*deltx)-exp(-r*(0+1)*delt_t)*K);
B_Matrix(:,N+1-l)=x;
end
Matrix=zeros(2*matrx+1,N+1);
Matrix(2:2*matrx,:)=B_Matrix;
for l=1:N+1
    Matrix(end,N+2-l)=exp(matrx*deltx)-exp(-r*l*delt_t)*K;
end
y=zeros(8001,1);
for i=0:8000
    y(i+1)=exp(i*deltx);
end
plot(y,Matrix(matrx+1:matrx+8001,t/delt_t+1));
xlabel('stock price');ylabel('Option Price');
price=Matrix(matrx+1:matrx+8001,t/delt_t+1);
end
