list pairedButtons = ["Pair", "Power", "First Page", "Page", "Wallpaper", "Face"];
list fpOptions = ["Google", "Youtube", "Custom", "Isabela Evergarden"];
list wallOptions = ["Black", "Texture"];

integer pairCode = -1;
integer face = -1;

integer listenHandle = -1;

powerClicked() {
    llWhisper(pairCode, "power::0");
}

pairClicked() {
    llWhisper(pairCode, "pair::" + (string) llGetKey());
}

faceClicked(integer sf) {
    llWhisper(pairCode, "face::" + (string) sf);
}

changeFirstPage(string fp) {
    llWhisper(pairCode, "firstPage::" + fp);
}

changePage(string np) {
    llWhisper(pairCode, "page::" + np);
}

default
{
    touch_start(integer total_number)
    {
        key toucherId = llDetectedKey(0);
        integer channelDialog = -1 - (integer)("0x" + llGetSubString( (string)llGetKey(), -7, -1) );

        
        listenHandle = llListen(channelDialog, "", toucherId, "");
        llDialog(toucherId, "Remote Buttons", pairedButtons, channelDialog);
    }

    listen(integer channel, string name, key id, string message)
    {
        llListenRemove(listenHandle);
        if (message == "Pair")  pairClicked();
        else if (message = "Face") faceClicked(face);
        else if (message == "Power") powerClicked();     
    }
}
