% A game of battleships against a bot.
% uses two functions, InsertShipRand and DisplayField.


% Sets up the game, then alterenates between player turn and computer turns,
% guessing coordinates of eachothers ships

% the game ends when all the ships of the player or the computer have been
% sunk

% keeps information, such as ship positions & guess positions in matricies,
% but displays information with the function displayfield

% generates the playfields using the function insertshiprand.





% clearing
clear all;clc;

% initialising a ton of variables and vectors
FieldSize=0;
Ships=[];
% use the letters for coordinates
LETTERS=['A':'Z'];
letters=['a':'z'];

% introduction
fprintf('Hello and welcome. This is battleships. You will try and sink \n')
fprintf('all of my battleships before I sink yours. I recommend enlarging\n')
fprintf('the MATLAB Command Window so you can see more text at a time.\n\n')

% let the user read the text, move on when ready
Response=input('Press Enter to Continue', 's');
clc;

% brief user and set field size
% check if field size is in acceptable range, and is integer
fprintf('We will play on a square grid called the battlefield. In general, larger \n')
fprintf('BattleFields lead to longer games. Enter a number between 7 & 15  \n')
fprintf('to set the size. eg, entering the number "7" will set a 7x7 battlefield\n\n')
    
%get user input
FieldSize=input('>>');
    
%check if input is valid, if field size is in acceptable range, and is integer
% make playfield greater than 6x6 due to bot crash bug
while isempty(FieldSize) || FieldSize < 7 || FieldSize >15 || floor(FieldSize)~=FieldSize
    
    disp('Please input a valid field size')
    FieldSize=input('>>');
    
end

% clear command window
clc;

% set the number of ships based on the field size, proportional to the area
ShipNum=ceil(FieldSize^2/20);

% remove excess letters, so that we can check user is inputting lettters 
% within bounds
Excess=(FieldSize+1):26;
LETTERS(Excess)='';
letters(Excess)='';

% Inform the user of the game proceedings
fprintf('We will each have a certain number of ships that the other will try to sink.\n')
fprintf('For your %dx%d battlefield we will have %d ships each.\n',FieldSize,FieldSize,ShipNum)

% randomise the ships that will be used, store them in the vector "Ships"
Response="";
%keep randomising until user responds "yes"
while Response~="yes" && Response~="Yes"
    Submarines=0;
    Destroyers=0;
    Carriers=0;
    
    for i=[1:ShipNum]
    
        % set them between 3 - 5 for convinience sake, since these are the
        % corresponding lengths of ships. 3=Submarine, 4=Destroyer,5=Aircraft
        % carrier
        RandNum=randi(3)+2;
        
        % store in vector
        Ships(i)=RandNum;
    
        % Record which ships have been selected
        if RandNum==3
            Submarines=Submarines+1;
        elseif RandNum==4
            Destroyers=Destroyers+1;
        elseif RandNum==5
            Carriers=Carriers+1;
        end
        
    end
    
    % display the ships
    fprintf('\nIn our game will each have the following ships: \n\n')
    fprintf('%d Submarine(s) of Length 3\n\n',Submarines)
    fprintf('%d Destroyer(s) of Length 4\n\n',Destroyers)
    fprintf('%d Aircraft Carrier(s) of Length 5\n\n',Carriers)

    % allow the user to re-randomise the ships
    fprintf('\nIs this ok? respond "yes" to continue, press ENTER to randomise\n')
    Response=input('>>', 's');
    clc;
end

% loop over ship layouts
Response="no";
while Response~="yes"
    clc;
    fprintf('Respond "yes" to choose this ship layout, or press ENTER to see another.\n\n');
    % initialise the fields
    PlayerField=zeros(FieldSize);
    ComputerField=zeros(FieldSize);
    
    for i=[1:length(Ships)]
        PlayerField=InsertShipRand(PlayerField,Ships(i));
        ComputerField=InsertShipRand(ComputerField,Ships(i));
    end
    
    % using the function DisplayField to show the field
    DisplayField(PlayerField);
    fprintf('\nIs this Field Ok?\n')
    Response=input('>>','s');
    clc;
end

%show the user how to input coordinates
fprintf('You should input coordinates like this: \n\nENTER COORDINATES: C7\n\n')
fprintf('With the row followed by the column, using a LETTER and a NUMBER\n')
fprintf('respectively. \n\nI will go First.\n')

fprintf('\nPress Enter To Start\n')
% allow user to read text, proceed when they are ready
Response=input('', 's');
clc;

% GAME START, initialise some more matricies and variables

GuessField=zeros(FieldSize);
CGuessField=zeros(FieldSize);
PlayerDispField=PlayerField;
guessState=0;
PlayerTurn=false;
Turn=0;

% main game loop. loop until someone wins and we 'break'
while 1==1 
    switch PlayerTurn
        case 1
            % player turn ***********************************************
            GuessX=0;
            GuessY=0;
            
            fprintf('YOUR TURN\n\n');

            % show user their guesses
            DisplayField(GuessField);
            
            fprintf('\n\n');
                
                % *NOTE THAT ROW IS Y AND COLUMN IS X*
                % AND THEREFORE ELEMENT IN A MATRIX IS GIVEN BY
                % MATRIX(Y,X)******
                
                
            LetterY='0';
            GuessX=0;
            % Make sure user inputs a letter and whole number both in the
            % allowable range
            
            % check a lot of parameters for the user's guess
            while ~ismember(LetterY,LETTERS) && ~ismember(LetterY,letters) || GuessX<1 || GuessX>FieldSize || floor(GuessX)~=GuessX
                    
                    Guess=input('ENTER COORDINATES: ','s');
                    % add characters to avoid error if user makes a mistake
                    Guess=[Guess,' 00'];
                    
                    
                    % take the last 2 digits, if its only 1 digit it will
                    % get the empty character ' ' from above
                    GuessX=str2num(Guess(2:3));
                    
                    
                    %take the first character as the letter
                    LetterY=Guess(1);
                    % convert Capital letter to number
                    if ismember(LetterY,LETTERS)
                        GuessY=find(LETTERS==LetterY);
                    % convert lowercase letter to number
                    else
                        GuessY=find(letters==LetterY);
                    end
            end
               
            
            clc;
            %re-display everything so it is nice and neat
            fprintf('YOUR TURN\n\nENTER COORDINATES: %s%d\n\n',LetterY,GuessX)
            CurrentGuess=ComputerField(GuessY,GuessX);
            
            %display different outcome if the player hit or missed
            switch CurrentGuess
                case 0 % Miss
                    GuessField(GuessY,GuessX)=2;
                    DisplayField(GuessField);
                    % trying to make the text stand out
                    fprintf('\n* * * * M i s s ! * * * *\n')
                case 1 % Hit
                    GuessField(GuessY,GuessX)=3;
                    DisplayField(GuessField);
                    fprintf('\n* * * * H i t ! * * * *\n')
                case 2 % already missed there
                case 3 % already Hit there
            end
            
            
            %Check if player has won
            HitTotal=0;
            for i=[1:FieldSize]
                for j=[1:FieldSize]
                    if GuessField(i,j)==3
                        HitTotal=HitTotal+1;
                    end
                end
            end
            
            %if all the ship spots have been found, end the game
            if HitTotal==sum(Ships)
                fprintf('\n\n* * * * * * * * * * * * *\n');
                fprintf('Congratulations! You won!\n');
                fprintf('* * * * * * * * * * * * *\n\n');
                Response=input('Press Enter to Exit', 's');
                return;
            end
            
            
            % wait for player response to continue
            Response=input('\nPress Enter to Continue', 's');
            clc;
            
            PlayerTurn=false;
            
        case 0
            % computer turn *********************************************
            %use this variable to track how many turns have been had
            Turn=Turn+1;
           
            fprintf('COMPUTER TURN\n\n');
            
            % record which state for debugging
            DebugRecord(1,Turn)=guessState;
            
              switch guessState
                  % case 0 is just to pick a random coordinate
                case 0
                    
                    % initialise some variables that we want to reset when
                    % we come back to case 0
                    HitX=[];
                    HitY=[];
                    EndFound=false;
                    HC=1; % this is used to remember which coordinates are hits

                    
                    GuessX=randi(FieldSize);
                    GuessY=randi(FieldSize);
                    
                    %make sure we havent guessed there already
                    while CGuessField(GuessY,GuessX)~=0
                        GuessX=randi(FieldSize);
                        GuessY=randi(FieldSize);
                    end
                    
                    %if we miss
                    if PlayerField(GuessY,GuessX)==0
                        CGuessField(GuessY,GuessX)=2; %MISS
                        Hit=false;
                        
                    
                    elseif PlayerField(GuessY,GuessX)==1
                        CGuessField(GuessY,GuessX)=3;%HIT
                        Hit=true;

                        guessState=1;
                        HitX(1)=GuessX;
                        HitY(1)=GuessY;
                        
                    end

                case 1
                    % guess a valid connected tile to the hit coordinate

                    % establish available connected guess options (if
                    % spaces nearby have already been guessed, or if it is
                    % the edge of the Field
                    
                    % pick a direction from:
                    
                    %  1   2    3     4
                    % up right down left; Clockwise order)
                    
                    % if an option is unavailable we will set it to 0
                    Options=[1,2,3,4];
                    
                    %against top border or space above already guessed
                    if HitY(HC)==1 || CGuessField(HitY(HC)-1, HitX(HC))~=0 
                        Options(1)=0;
                    end
                    %against right border or space right already guessed
                    if HitX(HC)==FieldSize || CGuessField(HitY(HC), HitX(HC)+1)~=0 
                        Options(2)=0;
                    end
                    %against bottom border or space below already guessed
                    if HitY(HC)==FieldSize || CGuessField(HitY(HC)+1, HitX(HC))~=0 
                        Options(3)=0;
                    end
                    %against left border or space left already guessed
                    if HitX(HC)==1 || CGuessField(HitY(HC), HitX(HC)-1)~=0
                        Options(4)=0;
                    end
                    
                    % make an offset vector for future
                    % reference
                    CounterOption=[Options Options];
                    CounterOption(1:2)='';
                    
                    GuessDirection=0;
                    %randomise a valid direction to guess
                    while GuessDirection==0
                        GuessDirection=Options(randi(4));
                        %  1   2    3     4
                        % up right down left; Clockwise order
                    end
                    
                    % the guess will not go off the edge
                    Edge=false;
                    
                    % convert guessdirection variable into coordinates.
                    switch GuessDirection
                        case 1 % up
                            GuessX=HitX(HC);
                            GuessY=HitY(HC)-1;
                            if GuessY==1;
                                Edge=true;
                            end                            
                        case 2 % right
                            GuessX=HitX(HC)+1;
                            GuessY=HitY(HC);
                            if GuessX==FieldSize;
                                Edge=true;
                            end  
                        case 3 % down
                            GuessX=HitX(HC);
                            GuessY=HitY(HC)+1;
                            if GuessY==FieldSize;
                                Edge=true;
                            end 
                        case 4 % left
                            GuessX=HitX(HC)-1;
                            GuessY=HitY(HC);
                            if GuessX==1
                                Edge=true;
                            end    
                    end

                        % determine whether guess hit or misseds
                    if PlayerField(GuessY,GuessX)==0
                        CGuessField(GuessY,GuessX)=2; % MISS
                        Hit=false;
                        
                    elseif PlayerField(GuessY,GuessX)==1
                        CGuessField(GuessY,GuessX)=3;% HIT
                        Hit=true;
                        HC=2;
                        
                        % if we hit, record the coordinates
                        HitX(HC)=GuessX;
                        HitY(HC)=GuessY;
                        
                        % if we are on an edge, go to state 3 next turn,
                        % turn around
                        if Edge==true
                            guessState=3;
                        else
                            guessState=2;
                        end
                        
                    end
                case 2
                    % keep guessing in the same direction
                    switch GuessDirection
                        
                        % keep guessdirection variable from before,
                        % guess accordingly

                        case 1 %up
                            GuessX=HitX(HC);
                            GuessY=HitY(HC)-1;
                            if GuessY==1
                                Edge=true;
                            end                            
                        case 2 %right
                            GuessX=HitX(HC)+1;
                            GuessY=HitY(HC);
                            if GuessX==FieldSize
                                Edge=true;
                            end                            
                        case 3 %down
                            GuessX=HitX(HC);
                            GuessY=HitY(HC)+1;
                            if GuessY==FieldSize;
                                Edge=true;
                            end                            
                        case 4 %left
                            GuessX=HitX(HC)-1;
                            GuessY=HitY(HC);
                            if GuessX==1;
                                Edge=true;
                            end                              
                    end

                    %DEAD END, Should/can we check the other side?
                    if Edge==1 || PlayerField(GuessY,GuessX)==0
                        % no
                        if EndFound==1 || CounterOption(GuessDirection)==0
                            guessState=0;
                        % yes
                        else
                            guessState=3;
                        end                        
                        Edge=false;                        
                    end
                    
                        % determine if we hit or miss                    
                    if PlayerField(GuessY,GuessX)==0 %MISS
                        CGuessField(GuessY,GuessX)=2;
                        Hit=false;
                        
                        
                    elseif PlayerField(GuessY,GuessX)==1
                        CGuessField(GuessY,GuessX)=3;%HIT
                        
                        Hit=true;
                        HC=HC+1;

                        HitX(HC)=GuessX;
                        HitY(HC)=GuessY;
                        
                    end



                case 3
                    % Go back the other way
                     switch GuessDirection

                        case 1 %originally guessed up, now go down
                            GuessX=HitX(1);
                            GuessY=HitY(1)+1;
                            GuessDirection=3;

                        case 2 %originally guessed right, now go left
                            GuessX=HitX(1)-1;
                            GuessY=HitY(1);
                            GuessDirection=4;

                        case 3 %originally guessed down, now go up
                            GuessX=HitX(1);
                            GuessY=HitY(1)-1;
                            GuessDirection=1;

                        case 4 %originally guessed left, now go right
                            GuessX=HitX(1)+1;
                            GuessY=HitY(1);
                            GuessDirection=2;
                     end


                    if PlayerField(GuessY,GuessX)==0
                        CGuessField(GuessY,GuessX)=2; %MISS
                        Hit=false;

                        guessState=0; % ship must be sunk, go back to state 0
                        
                        % record hit data
                    elseif PlayerField(GuessY,GuessX)==1
                        CGuessField(GuessY,GuessX)=3;%HIT

                        Hit=true;

                        HC=HC+1;

                        HitX(HC)=GuessX;
                        HitY(HC)=GuessY;

                        %go back to guessing in straight line, this time give up if
                        %miss
                        guessState=2;
                        EndFound=true;
                        
                    end

              end   
            
            % convert row guess to letter
            yLetter=LETTERS(GuessY);
            % display computer guess
            fprintf('COORDINATES: %s%d\n\n',yLetter,GuessX);
            
            % display result
            if Hit==1
                PlayerDispField(GuessY,GuessX)=3;
                DisplayField(PlayerDispField);
                fprintf('\n* * * * H i t ! * * * *\n\n');
            elseif Hit==0
                PlayerDispField(GuessY,GuessX)=2;
                DisplayField(PlayerDispField);
                fprintf('\n* * * * M i s s ! * * * *\n\n');
            end
            
            % Check if computer has won
            HitTotal=0;
            for i=[1:FieldSize]
                for j=[1:FieldSize]
                    if CGuessField(i,j)==3
                        HitTotal=HitTotal+1;
                    end
                end
            end
            
            % if all the ship coordinates have been found, end the game
            if HitTotal==sum(Ships)
                clc;
                fprintf('\n* * * * H i t ! * * * *\n\n');
                DisplayField(PlayerDispField);
                fprintf('\n\n- - - - - - - - - - - - - - - - - -\n');
                fprintf('\n You lost. Better Luck Next Time!\n');
                fprintf('\n- - - - - - - - - - - - - - - - - -\n\n');
                Response=input('\nPress Enter to Continue', 's');
                return;
            end
            
            % record the computer's guesses for debugging
            DebugRecord(2,Turn)=GuessX;
            DebugRecord(3,Turn)=GuessY;
            DebugRecord(4,Turn)=Hit;
            
            % set it to be the players turn
            PlayerTurn=true;
            
            % wait for user response
            Response=input('Press Enter to Continue', 's');
            clc;
    end

    
end
    
    





