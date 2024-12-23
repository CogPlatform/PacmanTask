function p_x = softmaxFun(x, coef)
p_i = zeros(1,height(coef));
for i = 1:height(coef)
    p_i(i) = exp(dot(x,coef(i,:)));
end
p_x = p_i/sum(p_i);
end