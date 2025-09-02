function mountLJFuse
cd /home/yanglab-lin/Downloads/LJFuse-master/root-ljfuse/
foldername = dir;
if size(foldername)>0
    cd /home/yanglab-lin/Downloads/LJFuse-master/
    umerror = system('fusermount -u root-ljfuse');
end  
cd /home/yanglab-lin/Downloads/LJFuse-master/
merror = system('python ljfuse.py');
cd root-ljfuse
foldername = dir;
selected_device = foldername(5).name;
display(['the labjack device being used is ',selected_device]);
cd([selected_device,'/connection']);
system('echo 2 > FIO2-dir');
system('echo 2 > FIO3-dir');
system('echo 2 > FIO0-dir');
system('echo 2 > FIO1-dir');



