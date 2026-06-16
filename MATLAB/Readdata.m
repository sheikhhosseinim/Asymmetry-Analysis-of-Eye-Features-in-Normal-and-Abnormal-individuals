function [img3D,bscan_name]=Readdata(direction)
%%%% if index=1, pca works
path=dir(direction);
%%
% name=path(3).name;
% 
% k=1;
% for i=3:numel(path)
%     name=path(i).name;
% 
%     for j=length(name):-1:1
%         if strcmp(name(j),'.')
%             if strcmp(name(j-2),'_')
%                 idx(k)=str2double(name(j-1));
%             elseif strcmp(name(j-3),'_')
%                 idx(k)=str2double(name(j-2:j-1));
%             else
%                 idx(k)=str2double(name(j-3:j-1));
%             end
%             k=k+1;
%         end
%     end
% end
% k=0;
% i=length(name);
% while k==0
%     if strcmp(name(i),'_')
%         ii=length(name)-i;
%         name=name(1:end-ii);
%         k=1;
%     end
%     i=i-1;
% end
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
%     cd(direction)
%     if isfile(namei)
        if exist(namei, 'file')
        
        img=(imread(namei));
        img3D(:,:,k)=img;
        bscan_name{k}=namei;
        k=k+1;
    end
%     cd('C:\Users\User2\Dropbox\PostDoctoral\Code')
%     cd('C:\Users\User\Dropbox\PostDoctoral\Code')
    %     figure(2),imshow(img);title('abnormal right')
    %     pause(0.1)
end


