 function wait_time(time)
% wait.m 
% simply waits for amount of time specified by time before proceeding
% time is in seconds

start=GetSecs;
finish= GetSecs;
while(finish-start < time)
    finish = GetSecs;
end