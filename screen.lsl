// listener
integer connectorListener;
string connKey = "";

// default values
integer powerOn = FALSE;
integer pairCode = -1;
integer face = -1;
string firstPage = "https://www.instagram.com/isabelaevergarden/";

// methods
generate_pairCode(integer verbose) {
    float f = llRound(llFrand(10) * 1000);
    pairCode = (integer) f;
    if (verbose) llOwnerSay("Pair Code is: " + (string) pairCode);
}

start_tv() {
        llSetPrimMediaParams(face,
            [PRIM_MEDIA_CURRENT_URL, firstPage]);
        powerOn = TRUE;
}

turn_power() {
    powerOn = !powerOn;
    if (!powerOn) llClearPrimMedia(face);
    else start_tv();
}

change_page(string newPg) {
    llClearPrimMedia(face);
    llSetPrimMediaParams(face, [PRIM_MEDIA_CURRENT_URL, newPg]);
}

// Listens to needed resource only
change_listener(integer listener, string cKey) {
    llListenRemove(listener);
    connectorListener = llListen(pairCode, "", (key) cKey, "");
}

default
{
    state_entry()
    {
        generate_pairCode(TRUE);
        connectorListener = llListen(pairCode, "", NULL_KEY, "");
    }

    listen(integer channel, string name, key id, string message) {
        message = llStringTrim(message, STRING_TRIM);
        list l = llParseString2List(message, ["::"], []);
        string command = llList2String(l, 0);
        string code = llList2String(l, 1);

        if (command == "pair") {
            connKey = (key) code;
            change_listener(connectorListener, connKey);
            llOwnerSay("TV Paired with #" + (string) pairCode);
        } else if (command == "power") {
            turn_power();
        } else if (command == "face") {
            llClearPrimMedia(face); // clear old
            face = (integer) code; // set new
            if (powerOn) start_tv();
        } else if (command == "firstPage") {
            firstPage = code;
            llOwnerSay("New first page saved: " + firstPage);
        } else if (command == "page") {
            change_page(code);
        }
    }
} 