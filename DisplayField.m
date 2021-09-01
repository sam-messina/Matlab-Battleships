function Battlefield = DisplayField(Matrix)

FieldSize=size(Matrix,1);
%set a letter vector for the Row grid Reference
Letters=['A':'Z'];

%create a vector for the column grid reference
GridRef=[];
for i =[1:FieldSize];
    GridRef=[GridRef string(i)];
end

%fprintf the matrix
for i=[1:FieldSize]
    
    %print the row letter
    fprintf('%s ',string(Letters(i)))
    
    for j=[1:FieldSize]
        
        %print these characters based on the value at that point
        switch Matrix(i,j)
            case 0
                %empty
                fprintf(' ~ ');
            case 1
                %ship
                fprintf(' X ');
            case 2
                %miss
                fprintf(' o ');
                %hit
            case 3
                fprintf(' • ');
                %testing/debug
            case 4
                fprintf(' @ ');
        end
        
    end
    fprintf('\n')
end

%add the column reference at the bottom
fprintf('  ')
if FieldSize<10
    fprintf(' %s ',GridRef)
else
    for i = 1:10
        fprintf(' %s ',GridRef(i))
    end
    %if there are more than 9 columns use less spaces so the numbers fit
    for i=[11:FieldSize]
        fprintf('%s ',GridRef(i))
    end
end
fprintf('\n')

end