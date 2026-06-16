function [Diff,Avg,asym]=relativeMeasure(ThicknessMapR,ThicknessMapL)

for i=1:7%%% 5 layers+global thickness+ thickness at macula slice

    Diff(:,:,i)=ThicknessMapR(:,50:200,i)-ThicknessMapL(:,50:200,i);
    Avg(:,:,i)=(ThicknessMapR(:,50:200,i)+ThicknessMapL(:,50:200,i))/2;
    asym(:,:,i)=abs(Diff(:,:,i))./Avg(:,:,i);

end