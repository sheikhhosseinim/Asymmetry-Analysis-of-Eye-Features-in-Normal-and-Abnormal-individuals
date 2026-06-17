function [img3D,bscan_name]=Readdata(direction)

path=dir(direction);
%%
for i=3:numel(path)
    name=path(i).name;
    tmp1=find(name=='_');
    idx(i-2)=str2double(name(tmp1(end)+1:end-4));
end
name=name(1:tmp1(end));

%%
img3D=[];
k=1;
for i=min(idx):max(idx)
    namei=strcat(direction,'\',name,num2str(i),'.png');

        if exist(namei, 'file')
        
        img=(imread(namei));
        img3D(:,:,k)=img;
        bscan_name{k}=namei;
        k=k+1;
    end

end


