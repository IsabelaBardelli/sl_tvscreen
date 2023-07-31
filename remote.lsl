// Define a constant to identify the dialog channel (any number between 0 and 65535)
integer DIALOG_CHANNEL = -1;
// Define a constant for the dialog menu's unique identifier
integer DIALOG_MENU_ID = 0666;

key BLACK_UUID = "d7e43026-c096-4321-4e3b-17d19fd0a83e";

list pairedButtons = ["Pair", "Power", "First Page", "Wallpaper", "Face"];
list fpOptions = ["Google", "Youtube", "Custom", "Isabela Evergarden"];
list wallOptions = ["Black", "Texture"];

integer pairCode = -1;
integer face = -1;

integer textAux = -1;

powerClicked() {
    llWhisper(pairCode, "power::0");
}

pairClicked(key id) {
    textAux = 0;
    showInputDialog(id, "Inform pair number: ");
}

pairSelected() {
    llWhisper(pairCode, "pair::" + (string) llGetKey());
}

faceClicked(key id) {
    textAux = 1;
    showInputDialog(id, "Inform face number: ");
}

faceSelected() {
    llWhisper(pairCode, "face::" + (string) face);
}

pageClicked(key id) {
    textAux = 2;
    showInputDialog(id, "Inform new page");
}

pageSelected(string np) {
    llWhisper(pairCode, "page::" + np);
}

firstPageClicked(key id) {
    textAux = 3;
    showInputDialog(id, "Inform new first page");
}

firstPageSelected(string fp) {
    llWhisper(pairCode, "firstPage::" + fp);
}

wallpaperClicked(key id) {
    llDialog(id, "Wallpapers", wallOptions, DIALOG_CHANNEL);
}

textureClicked(key id) {
    textAux = 4;
    showInputDialog(id, "Inform new texture UUID");
}

wallpaperTextureSelected(key uuid) {
    llWhisper(pairCode, "wall::" + (string) uuid);
}

showInputDialog(key user, string text) {
    llTextBox(user, text, DIALOG_CHANNEL);
}

default
{
    
    state_entry() {
        DIALOG_CHANNEL = -1 - (integer)("0x" + llGetSubString( (string)llGetKey(), -7, -1) );
    }
    
    touch_start(integer total_number)
    {
        key toucherId = llDetectedKey(0);

        llListen(DIALOG_CHANNEL, "", NULL_KEY, "");
        llDialog(toucherId, "Remote Buttons", pairedButtons, DIALOG_CHANNEL);
    }

    listen(integer channel, string name, key id, string message)
    {
        message = llStringTrim(message, STRING_TRIM);
        llListenRemove(DIALOG_CHANNEL);
        if (message == "Pair") pairClicked(id);
        else if (message == "Face") faceClicked(id);
        else if (message == "Power") powerClicked();
        // else if (message == "Page") pageClicked(id);
        else if (message == "First Page") firstPageClicked(id);
        else if (message == "Wallpaper") wallpaperClicked(id);
        else if (message == "Black") wallpaperTextureSelected(BLACK_UUID);
        else if (message == "Texture") textureClicked(id);
        else {
            if (textAux == 0) {
                if (llStringLength(message) != 4) llOwnerSay("Invalid Pair Code");
                else {
                    pairCode = (integer) message;
                    pairSelected();
                }
            } else if (textAux == 1) {
                if (llStringLength(message) > 2) llOwnerSay("Invalid Face");
                else {
                    face = (integer) message;
                    faceSelected();
                }
            } else if (textAux == 2) {
                pageSelected(message);
            } else if (textAux == 3) {
                firstPageSelected(message);
            } else if (textAux == 4) {
                //if (!isValidUUID(message)) llOwnerSay("Invalid UUID");    else 
                wallpaperTextureSelected(message);
            }
            textAux == -1;
        }
    }
}
