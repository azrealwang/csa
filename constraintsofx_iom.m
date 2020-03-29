function  [c,ceq] = constraintsofx(x,iomhash,opts)


model=opts.model;
cout=1;
for i=1:size(iomhash,2)
    indexi=iomhash(i);
    mymodel=model.Wx(:,(i-1)*opts.K+1:i*opts.K);
    for j=1:opts.K
        if indexi==j
            %             c(cout) =mymodel(:,j).*x - mymodel(:,indexi).*x;
            continue;
        else
            c(cout) = sum(mymodel(:,j)'.*x-mymodel(:,indexi)'.*x );
        end
        cout=cout+1;
    end
end

ceq=[];

%c = ...     % Compute nonlinear inequalities at x. c(x) <= 0
%ceq = ...   % Compute nonlinear equalities at x. ceq(x) = 0


end