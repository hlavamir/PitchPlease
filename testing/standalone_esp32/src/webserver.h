#include "WiFi.h"
#include "AsyncTCP.h"           // https://github.com/me-no-dev/AsyncTCP
#include "ESPAsyncWebServer.h"  // https://github.com/me-no-dev/ESPAsyncWebServer

#ifndef WIFI_MAX_ATTEMPTS   
    #define WIFI_MAX_ATTEMPTS 10
#endif

#define CC_COUNT 16

const char index_html[] PROGMEM = R"rawliteral(
<!doctype html>
<html>
<head>
<meta charset="utf-8">
<meta name="viewport" content="user-scalable=no">

<title>PitchPlease! WebControl 1.0</title>

<style>
@import url('https://fonts.googleapis.com/css2?family=Source+Code+Pro&display=swap');

body {
    background: #111;
    color: #999;
    font-family: 'Source Code Pro', monospace;
    font-size: 16px;
    overflow: hidden;
    text-align: center;
}

body, div, h1 {
    margin: 0;
    padding: 0;
}

.items-row-sliders, .items-row-buttons {    
    display: flex;
    flex-flow: row nowrap;
    justify-content: center;
    align-items: stretch;
}

.items-row-sliders {
    height: 35vh;
}

.items-row-buttons {
    height: 10vh;
}

.item {
    flex-grow: 1;
    width: 25%%;
    margin: 1em;
    background: #222;
    border-radius: 1em;
    overflow: hidden;
}

h1 {
    position: relative;
    left: 0;
    top: 1em;
    font-size: 1em;
    z-index: 100;
    color: #fff;
}

.slider {
    position: relative;    
}

.slider .ui-slider-range {
    position: absolute;
    left: 0;
    bottom: 0;
    width: 100%%;
    height: 50%%;
}

.slider .ui-slider-range, .on {
    background-color: #333;
}

</style>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.1/jquery.min.js"></script>
<script src="https://code.jquery.com/ui/1.13.2/jquery-ui.js"></script>
<script type="text/javascript" src="//cdnjs.cloudflare.com/ajax/libs/jqueryui-touch-punch/0.2.3/jquery.ui.touch-punch.min.js"></script>

<script type = "text/javascript">
var sliders = [%SLIDERVALUES%];
var buttons = [%BUTTONVALUES%];
var outLast = "";

$( document ).ready(function(){
    setInterval(function(){
        out = "";
        sliders.forEach(function(element, i){
            sliders[i] = $("#s" + i).slider("value");

            if(i > 0) out += "-";
            out += sliders[i];
        });  
        
        buttons.forEach(function(element, i){
            buttons[i] = $("#b" + i).hasClass("on") ? 1 : 0;
            out += "-" + buttons[i];
        });
        
        if(out !== outLast){
            var xhr = new XMLHttpRequest();
            xhr.open("GET", "/CC?value=" + out, true);
            xhr.send();
            outLast = out;
        }

        console.log(out);
    }, 125);

    sliders.forEach(function(element, i){
        $("#s" + i).slider({
            orientation: "vertical",
            range: "min",
            min: 0,
            max: 255,
            value: sliders[i],
            slide: function( event, ui ) { }
        });
    });

    $(".button").click(function(){
        $(this).toggleClass("on");
    });

    buttons.forEach(function(element, i){
        if(element > 0) $("#b" + i).addClass("on");
        else $("#b" + i).removeClass("on");
    });
});

</script>
</head>

<body>

<div class="items-row-sliders">
    <div class="item slider" id="s0"><h1>Blink Decay</h1></div>
    <div class="item slider" id="s1"><h1>Idle Attack</h1></div>
    <div class="item slider" id="s2"><h1>Hue</h1></div>
    <div class="item slider" id="s3"><h1>Strobo Mode</h1></div>
</div>
<div class="items-row-sliders">
    <div class="item slider" id="s4"><h1>Blink Brightness</h1></div>
    <div class="item slider" id="s5"><h1>Idle Brightness</h1></div>
    <div class="item slider" id="s6"><h1>Glitch Intensity</h1></div>
    <div class="item slider" id="s7"><h1>Sensitivity</h1></div>
</div>
<div class="items-row-buttons">
    <div class="item button" id="b0"><h1>Swap Colors</h1></div>
    <div class="item button" id="b1"><h1>Idle Mode</h1></div>
    <div class="item button" id="b2"><h1>-</h1></div>
    <div class="item button" id="b3"><h1>-</h1></div>
</div>
<div class="items-row-buttons">
    <div class="item button" id="b4"><h1>-</h1></div>
    <div class="item button" id="b5"><h1>-</h1></div>
    <div class="item button" id="b6"><h1>-</h1></div>
    <div class="item button" id="b7"><h1>-</h1></div>
</div>


</body>
</html>
)rawliteral";

float cc[] = {
  0.5, 0.5, 0.5, 0.0, 
  1.0, 1.0, 0.5, 0.5,
  1.0, 0.0, 1.0, 0.0, 
  0.0, 0.0, 0.0, 0.0  
  };

bool input_available = false;
String inputMessage;

// Create AsyncWebServer object on port 80
AsyncWebServer server(80);

// Replaces placeholder with button section in your web page
String processor(const String &var)
{
    // Serial.println(var);
    if (var == "SLIDERVALUES")
    {
        String out = "";
        for (int i = 0; i < 8; i++)
        {
            if (i > 0)
                out += ", ";
            out += round(cc[i] * 255);
        }
        return out;
    }
    else if (var == "BUTTONVALUES")
    {
        String out = "";
        for (int i = 8; i < 16; i++)
        {
            if (i > 8)
                out += ", ";
            out += round(cc[i]);
        }
        return out;
    }
    return String();
}

void parseInputMessage(){
    static String chunks[CC_COUNT];
    static int ccid;
    static int startpos;
    static int endpos;
    static bool found;
    
    Serial.println("Incoming CC " + inputMessage);

    ccid = 0;
    startpos = 0;

    while(startpos <= inputMessage.length() && ccid < CC_COUNT)
    {        
        endpos = startpos + 1;
        found = false;
        while(!found)
        {
            if(inputMessage[endpos] == '-' || endpos >= inputMessage.length()) found = true;
            else endpos++;
        }

        chunks[ccid] = inputMessage.substring(startpos, endpos);       
        ccid++;
        startpos = endpos + 1;
    }

    if(ccid == CC_COUNT){

        for(int i = 0; i < CC_COUNT; i++){
            cc[i] = chunks[i].toInt();

            // sliders (id 0 to 7) are in [0..255] range, buttons (8 to 15) are [0..1]
            // cc array is only expecting [0..1] float values
            if(i < 8) cc[i] /= 255.0;
        }
    }
}

bool initWebserver(const char *ssid, const char *password)
{
    // Connect to Wi-Fi
    int tries = 0;
    WiFi.begin(ssid, password);
    while (WiFi.status() != WL_CONNECTED && tries < WIFI_MAX_ATTEMPTS)
    {
        delay(1000);
        Serial.println("Connecting to WiFi " + (String)ssid + " attempt " + (String)tries + "...");
        tries++;
    }

    if(WiFi.status() != WL_CONNECTED) return false;

    // Print ESP Local IP Address
    Serial.print("Assigned IP ");
    Serial.println(WiFi.localIP());

    // Route for root / web page
    server.on("/", HTTP_GET, [](AsyncWebServerRequest *request)
    { 
        request->send_P(200, "text/html", index_html, processor); 
    });

    // Send a GET request to <ESP_IP>/slider?value=<inputMessage>
    server.on("/CC", HTTP_GET, [](AsyncWebServerRequest *request)
    {              
        // GET input1 value on <ESP_IP>/slider?value=<inputMessage>
        if (request->hasParam("value")) {
            inputMessage = request->getParam("value")->value();
            input_available = true;
        }              

        //Serial.println(inputMessage);
        request->send(200, "text/plain", "OK"); 
    });

    // Start server
    server.begin();

    return true;
}

bool initWebserver(const char *networkCredentials[][2])
{
    bool success = false;   

    // hacky way to find out the size of the array
    int credentialsCount = *(&networkCredentials + 1) - networkCredentials;
    
    // scan WiFis
    Serial.println("Looking for networks:");
    int WiFiCount = WiFi.scanNetworks();  

    // go through all found SSIDs
    for(int j = 0; j < WiFiCount; j++){      
        Serial.println(" - " + WiFi.SSID(j) + " " + WiFi.RSSI(j));

        for(int i = 0; i < 2; i++){
            // if the SSID matches any saved SSID, try to connect
            if(WiFi.SSID(j) == networkCredentials[i][0]){
                Serial.println("   -> known SSID found, trying to connect");
                success = initWebserver(networkCredentials[i][0], networkCredentials[i][1]);
            } 

            if(success) break;
        }        
        if(success) break;
    }

    return success;
}