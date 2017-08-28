%% Generates the table in DataLog.xlsx
path_home=pwd;
% Get a list of all files and folders in this folder.
files = dir()
% Get a logical vector that tells which is a directory.
dirFlags = [files.isdir]
% Extract only those that are directories.
subFolders = files(dirFlags)

rdainfo=struct();
l=0
for idx=3:length(subFolders)
rda_list=dir(sprintf('./%s/*.rda',subFolders(idx).name));
for jdx=1:length(rda_list)
l=l+1
    rdainfo(l).fname=sprintf('%s/%s/%s',path_home,subFolders(idx).name,rda_list(jdx).name);
rdadump=rda_read(sprintf('./%s/%s',subFolders(idx).name,rda_list(jdx).name));
rdainfo(l).TE=rdadump.TE;
rdainfo(l).pname=strtrim(rdadump.PatientName);
rdainfo(l).pname=rdainfo(l).pname(1:4); %save only the subject number
rdainfo(l).date=strtrim(rdadump.StudyDate);
end
end