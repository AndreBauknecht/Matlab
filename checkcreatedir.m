function checkcreatedir(path,folder)
%check if directory exists, if not, create it

direxist = exist(strcat(path,'\',folder),'dir');
if direxist<1
    mkdir(path,folder);
end