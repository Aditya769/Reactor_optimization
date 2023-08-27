% Define the rate expression function
% K1 =input('Input the value of k1 '); % rate constant 1
% K2 =input('Input the value of K2 '); % rate constant 2
% K3 =input('Input the value of K3 '); % rate constant 3
K1 = 2;
K2=0.1;
K3=3;
%f = @(Ca) (K1 * Ca) ./ (1 + K2*Ca.^2 + K3*Ca); % form of rate equation
%g = @(Ca) (k1 * (1 - K2 * Ca.^2)) ./ (1 + K3*Ca.^2 +K2 Ca)^2;
rate = fun(Ca,K1,K2,K3);
% Calculate the derivative at a specific point
syms Ca;
%deriv = (k1*(1-K2*Ca.^2))./(1+K2*Ca.^2 + Ca)^2;
point=input('Input the point at which Ca is to be calculated ');
%e = subs(deriv,Ca,point);
d = diff(rate)./diff(Ca);
e=d(find(Ca>=point,1));
disp('Derivative of f at chosen required ca is');
disp(e);


% Calculate the area under the curve by trapezoidal rule
% Ca_max=input('Define the max value for the Ca ');
% Ca_min=input('Define the min value for our Ca ');
Ca_max=10;
Ca_min=1;
h = 0.1;
n = (Ca_max-Ca_min)/0.1;
area = 0.5*(f(Ca_max)+f(Ca_min));
for i=1:n
    Ca = Ca_min+i*h;
    area = area + f(Ca);
end
area  = area*h;
disp('area under the curve is :');
disp(area);

% finding minimum and maximum functional value over the given domain
Ca_maxfn = 0.0; % let functional maximum over the domain is at zero
maxfn = -Inf;
for Ca = Ca_min:h:Ca_max
    fn = f(Ca);
    if fn> maxfn
       maxfn = fn;
       Ca_maxfn = Ca;
    end
end
disp(['Maximum functional value is ', num2str(maxfn), ' occurs at Ca = ', num2str(Ca_maxfn)]);

Ca_minfn = 0.0; % let functional minimum over the domain is at zero
minfn = Inf;
for Ca = Ca_min:h:Ca_max
    fn = f(Ca);
    if fn< minfn
       minfn = fn;
       Ca_minfn = Ca;
    end
end
disp(['Minimum functional value is ', num2str(minfn), ' occurs at Ca = ', num2str(Ca_minfn)]);

% drawing a straight line between two points on the function
% Ca1 =input('Enter the first point for making the line '); %first point to have a line
% Ca2 =input('Enter the Second point for making the line '); %second point to have a line
Ca1 = 2;
Ca2 = 5;
plot(Ca1,f(Ca1),'xm');
m = (f(Ca2)-f(Ca1))/(Ca2-Ca1); %slope of the required line
c = f(Ca1)-m*Ca1; % intercept of the required line
disp(['the required line having points Ca1 and Ca2 is y =  ', num2str(m), '*x + ', num2str(c)]);
%Finding the value of Ca at which the slope of the curve is equal to the%
%line obtained%
disp('Ca at which the slope on the curve is equal to the slope on the line is');
Cao=fzero(@(Ca) g(Ca)-m, 1);
disp(Cao);
%Plotting the graph of the given function we have%
ca=Ca_min:0.01:Ca_max;
%Given the equation of y = f(ca)we have%
y=(k1*ca)./(1+K2*ca.^2);
plot(ca, y)
title('Plot of the given function')
xlabel('ca')
ylabel('f(ca)')
grid on

hold on;

plot(ca,y1,'k');