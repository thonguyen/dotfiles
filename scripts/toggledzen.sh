# !/bin/sh

id=`xdotool search --name dzenleft`
if [[ -n $id ]]
then
    if [[ -z `xdotool search --onlyvisible --name dzenleft` ]]
    then
        xdotool windowmap $id 
        xdotool windowsize $id 480 16
    else
        xdotool windowsize $id 480 0
        xdotool windowunmap $id 
        #xdotool windowsize $id 480 0
    fi
fi


idx=`xdotool search --name dzenright`
if [[ -n $idx ]]
then
    if [[ -z `xdotool search --onlyvisible --name dzenright` ]]
    then
        xdotool windowmap $idx
        xdotool windowsize $idx 800 16
    else
        xdotool windowsize $idx 800 0 
        xdotool windowunmap $idx
    fi
fi
