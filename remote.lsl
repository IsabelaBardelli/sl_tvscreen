list unpairedButtons = ["Pair"];
list pairedButtons = ["Pair", "Power", "First Page", "Page", "Default Texture", "Face"];
list fpOptions = ["Google", "Youtube", "Custom", "Isabela Evergarden"];

boolean isPaired = false;
integer pairCode = -1;

integer face;

powerClicked() {
    llWhisper(pairCode, "power::0");
}

pairClicked() {
    llWhisper(pairCode, "pair::" + llGetKey());
}

faceClicked(integer sf) {
    llWhisper(pairCode, "sf::" + (string) sf);
}

changeFirstPage(string fp) {
    llWhisper(pairCode, "fp::" + fp);
}

default
{
    touch_start(integer total_number)
    {
        key toucherId = llDetectedKey(0);
        integer channelDialog = -1 - (integer)("0x" + llGetSubString( (string)llGetKey(), -7, -1) );

        if (isPaired)
            llDialog(toucherId, "Remote Buttons", pairedButtons, channelDialog);
        else llDialog(toucherId, "Remote Buttons", unpairedButtons, channelDialog);
    }
}
