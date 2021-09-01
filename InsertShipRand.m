% insert a custom length "ship" to matrix, a line of "1"'s within a matrix,
% not overlapping any existing '1's

function NewMatrix =  InsertShipRand(Matrix,Length)

%initialise NewMatrix
NewMatrix = Matrix;

%intialise counter at 1 so the while loop will start
Counter = 1;

% on the battle field, 0 is empty, and 1 is a ship.

%will loop if there are any 1's in the way (to stop ships overlapping)
while Counter~=0
    
        %position at least a ships length from the edge
        RandPos1=randi(size(Matrix,1)-Length+1);
        %random other position in matrix
        RandPos2=randi(size(Matrix,1));
        %to be used for row and column depending on horizontal or vertical
     
        %Pick horizontal or vertical
        Orientation=randi(2);
        
        Counter = 0;
        
        switch Orientation
            case 1 %vertical
                        for j=[0:Length-1]
                            %empty spaces are 0 and ships are 1, counts the
                            %matrix area to check if there are any 1's
                            Counter=Counter+Matrix(RandPos1+j,RandPos2);
                        end
            case 2 %horizontal
                        for j=[0:Length-1]
                            Counter=Counter+Matrix(RandPos2,RandPos1+j);
                        end
        end
        
end
    

switch Orientation
case 1 %vertical
        
    for j=[0:Length-1]
        %inserts the ship (sets ones in the matrix)
        NewMatrix(RandPos1+j,RandPos2)=1;
    end

case 2 %horizontal
        
    for j=[0:Length-1]
        %inserts the ship (sets ones in the matrix)
        NewMatrix(RandPos2,RandPos1+j)=1;
    end
    
end %end switch

%DisplayField(NewMatrix);

end