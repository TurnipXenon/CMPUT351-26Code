#const steps=17. % minimum steps to solve

car(car1;car2;car3;car4;car5).

location(loc0;loc1;loc2;loc3;loc4;loc5).

at(car1,loc1,0).
at(car2,loc2,0).
at(car3,loc3,0).
at(car4,loc2,0).
at(car5,loc2,0).

at(ferry,loc0,0).

goal(T):-
  at(car1,loc2,T),
  at(car2,loc3,T),
  at(car3,loc4,T),
  at(car4,loc5,T),
  at(car5,loc1,T).

% Run time: 6.438s
% Specifications:
% Running wipl under WSL
% Architecture:        x86_64
% CPU op-mode(s):      32-bit, 64-bit
% Byte Order:          Little Endian
% Address sizes:       36 bits physical, 48 bits virtual
% CPU(s):              12
% On-line CPU(s) list: 0-11
% Thread(s) per core:  2
% Core(s) per socket:  6
% Socket(s):           1
% Vendor ID:           GenuineIntel
% CPU family:          6
% Model:               158
% Model name:          Intel(R) Core(TM) i7-8750H CPU @ 2.20GHz
% Stepping:            10
% CPU MHz:             2208.000
% CPU max MHz:         2208.0000
% BogoMIPS:            4416.00
% RAM: 16.0 GB