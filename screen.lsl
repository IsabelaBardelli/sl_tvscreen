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
    integer pairCode = (integer) f;
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

// Listens to needed resource only
change_listener(integer listener, string cKey) {
    llListenRemove(listener);
    connectorListener = llListen(pairCode, "", (key) cKey, "");
}
focus_listener(key cKey) {
    change_listener(connectorListener, NULL_KEY);
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
        command = llParseString2List(message, ["::"], [])[0];
        code = llParseString2List(message, ["::"], [])[1];

        if (name == "pair") {
            connKey = code;
            focus_listener(connKey);
            llOwnerSay("TV Paired with #" + pairCode);
        } else if (name == "power") {
            turn_power();
        } else if (name == "face") {
            face = (integer) code;
        }
    }
} 