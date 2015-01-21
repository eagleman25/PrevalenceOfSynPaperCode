function waituser()
% waits for user to press any key before advancing

% first check that no key is currently down
[ keyisdown,secs,keycode]=KbCheck;
while(keyisdown==1)
    [ keyisdown,secs,keycode]=KbCheck;
end
%             then wait for keypress
while(keyisdown==0)
    [ keyisdown,secs,keycode]=KbCheck;
end

end