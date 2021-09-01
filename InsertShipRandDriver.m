%driver file for the function that randomly adds shipsto a matrix
A=zeros(6);
B=zeros(10);

%
A=InsertShipRand(A,5);
disp(A);

B=InsertShipRand(B,5);
disp(B);

% add more ships to the same matrix, make sure they wont overlap
B=InsertShipRand(B,2);
disp(B);

B=InsertShipRand(B,4);
disp(B);