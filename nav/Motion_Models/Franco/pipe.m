function res = pipe(xu,yu,R)
    z3 = xu;
    oo = yu./R;
    x3 = cos(oo).*R;
    y3 = sin(oo).*R;
    res = [x3,y3,z3];
end