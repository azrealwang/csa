function [overlap2] = calc_overlap_twonormal(s1,s2,mu1,mu2,xstart,xend,xinterval)

clf
x_range=xstart:xinterval:xend;
plot(x_range,[normpdf(x_range,mu1,s1)' normpdf(x_range,mu2,s2)']);
hold on
area(x_range,min([normpdf(x_range,mu1,s1)' normpdf(x_range,mu2,s2)']'));
overlap=cumtrapz(x_range,min([normpdf(x_range,mu1,s1)' normpdf(x_range,mu2,s2)']'));
overlap2 = overlap(end);

end