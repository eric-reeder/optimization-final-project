clear all

syms xSolu xdTube xd xe ySolu ydTube yd ye rTube

eqn1 = (xSolu-xdTube)^2 + (ySolu-ydTube)^2 == rTube^2;
eqn2 = ySolu - yd == ((ye-yd)/(xe-xd))*(xSolu-xd);
sol = solve(eqn1, eqn2, xSolu, ySolu)