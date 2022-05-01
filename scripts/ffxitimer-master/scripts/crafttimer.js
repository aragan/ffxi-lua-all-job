
//  Usage:  Functions to calculate and format timing data for FFXI
//  Written by:  Pyogenes from www.pyogenes.com
//  Modified by: lokyst @ www.lokyst.net

// basis date is used to convert real time to game time.
// Use UTC functions to allow calculations to work for any timezone
basisDate = new Date();
basisDate.setUTCFullYear(2002, 5, 23); // Set date to 2003-06-23
basisDate.setUTCHours(15, 0, 0, 0);    // Set time to 15:00:00.0000

// moon date is used to determien the current hase of the moon.
// Use UTC functions to allow calculations to work for any timezone
Mndate = new Date();
Mndate.setUTCFullYear(2004, 0, 25); // Set date to 2004-01-25
Mndate.setUTCHours(2, 31, 12, 0);    // Set time to 02:31:12.0000

// basis date for RSE calculations
RSEdate = new Date();
RSEdate.setUTCFullYear(2004, 0, 28); // Set date to 2004-01-28
RSEdate.setUTCHours(9, 14, 24, 0);    // Set time to 09:14:24.0000

// basis date for day of week calculations
Daydate = new Date();
Daydate.setUTCFullYear(2004, 0, 28); // Set date to 2004-01-28
Daydate.setUTCHours(9, 14, 24, 0);    // Set time to 09:14:24.0000

EarthDay = new Array("Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday");
VanaDay = new Array("Firesday", "Earthsday", "Watersday", "Windsday", "Iceday", "Lightningday", "Lightsday", "Darksday");
// DayColor = new Array("#DD0000", "#AAAA00", "#0000DD", "#00AA22", "#7799FF", "#AA00AA", "#AAAAAA", "#333333");
// weakMagic = new Array("Ice","Lightning","Fire","Earth","Wind","Water","Darkness","Light");
// weakColor = new Array("#7799FF", "#AA00AA", "#DD000", "#AAAA00", "#00AA22", "#0000DD", "#333333", "#AAAAAA");

sMonth = new Array("Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec");
// RSErace = new Array("M. Hume","F. Hume","M. Elvaan","F. Elvaan","M. TaruTaru","F. TaruTaru","Mithra","Galka");
// RSEloc = new Array("Gusgen Mines","Shakrami Maze","Ordelle Caves");
// BoatSched = new Array("08:00", "16:00", "00:00");

msGameDay   = (24 * 60 * 60 * 1000 / 25); // milliseconds in a game day
msRealDay   = (24 * 60 * 60 * 1000); // milliseconds in a real day

timerId = 0;

// Dictionary Objects

CRYSTAL_DIRECTION = new Object();
CRYSTAL_DIRECTION["fire+strong"] = "West";
CRYSTAL_DIRECTION["fire+same"] = "North-West";
CRYSTAL_DIRECTION["earth+strong"] = "South-East";
CRYSTAL_DIRECTION["earth+same"] = "South";
CRYSTAL_DIRECTION["water+strong"] = "South-West";
CRYSTAL_DIRECTION["water+same"] = "West";
CRYSTAL_DIRECTION["wind+strong"] = "East";
CRYSTAL_DIRECTION["wind+same"] = "South-East";
CRYSTAL_DIRECTION["ice+strong"] = "North-West";
CRYSTAL_DIRECTION["ice+same"] = "East";
CRYSTAL_DIRECTION["lightning+strong"] = "South";
CRYSTAL_DIRECTION["lightning+same"] = "South-West";
CRYSTAL_DIRECTION["light+strong"] = "North";
CRYSTAL_DIRECTION["light+same"] = "North-East";
CRYSTAL_DIRECTION["dark+strong"] = "North-East";
CRYSTAL_DIRECTION["dark+same"] = "North";

ELEMENT = new Object();
ELEMENT["fire+strong"] = "Water";
ELEMENT["fire+same"] = "Fire";
ELEMENT["earth+strong"] = "Wind";
ELEMENT["earth+same"] = "Earth";
ELEMENT["water+strong"] = "Lightning";
ELEMENT["water+same"] = "Water";
ELEMENT["wind+strong"] = "Ice";
ELEMENT["wind+same"] = "Wind";
ELEMENT["ice+strong"] = "Fire";
ELEMENT["ice+same"] = "Ice";
ELEMENT["lightning+strong"] = "Earth";
ELEMENT["lightning+same"] = "Lightning";
ELEMENT["light+strong"] = "Dark";
//ELEMENT["light+strong"] = "North";
ELEMENT["light+same"] = "Light";
ELEMENT["dark+strong"] = "Light";
ELEMENT["dark+same"] = "Dark";

DAY_CRYSTAL_FACTOR = new Object();
DAY_CRYSTAL_FACTOR["fire+fire"] = 1;
DAY_CRYSTAL_FACTOR["fire+ice"] = -1;
DAY_CRYSTAL_FACTOR["earth+earth"] = 1;
DAY_CRYSTAL_FACTOR["earth+lightning"] = -1;
DAY_CRYSTAL_FACTOR["water+water"] = 1;
DAY_CRYSTAL_FACTOR["water+fire"] = -1;
DAY_CRYSTAL_FACTOR["wind+wind"] = 1;
DAY_CRYSTAL_FACTOR["wind+earth"] = -1;
DAY_CRYSTAL_FACTOR["ice+ice"] = 1;
DAY_CRYSTAL_FACTOR["ice+wind"] = -1;
DAY_CRYSTAL_FACTOR["lightning+lightning"] = 1;
DAY_CRYSTAL_FACTOR["lightning+water"] = -1;
DAY_CRYSTAL_FACTOR["light+light"] = 1;
DAY_CRYSTAL_FACTOR["light+dark"] = -1;
DAY_CRYSTAL_FACTOR["light+fire"] = 1;
DAY_CRYSTAL_FACTOR["light+earth"] = 1;
DAY_CRYSTAL_FACTOR["light+water"] = 1;
DAY_CRYSTAL_FACTOR["light+wind"] = 1;
DAY_CRYSTAL_FACTOR["light+ice"] = 1;
DAY_CRYSTAL_FACTOR["light+lightning"] = 1;
DAY_CRYSTAL_FACTOR["dark+dark"] = 1;
DAY_CRYSTAL_FACTOR["dark+light"] = -1;
DAY_CRYSTAL_FACTOR["dark+fire"] = -1;
DAY_CRYSTAL_FACTOR["dark+earth"] = -1;
DAY_CRYSTAL_FACTOR["dark+water"] = -1;
DAY_CRYSTAL_FACTOR["dark+wind"] = -1;
DAY_CRYSTAL_FACTOR["dark+ice"] = -1;
DAY_CRYSTAL_FACTOR["dark+lightning"] = -1;
DAY_CRYSTAL_FACTOR["lightning+earth"]= 1;
DAY_CRYSTAL_FACTOR["fire+water"]=1;
DAY_CRYSTAL_FACTOR["earth+wind"]=1;
DAY_CRYSTAL_FACTOR["water+lightning"]=1;
DAY_CRYSTAL_FACTOR["wind+ice"]=1;
DAY_CRYSTAL_FACTOR["ice+fire"]=1;

DAY_INDEX_FACTOR = new Object();
DAY_INDEX_FACTOR["0"] = "fire";
DAY_INDEX_FACTOR["1"] = "earth";
DAY_INDEX_FACTOR["2"] = "water";
DAY_INDEX_FACTOR["3"] = "wind";
DAY_INDEX_FACTOR["4"] = "ice";
DAY_INDEX_FACTOR["5"] = "lightning";
DAY_INDEX_FACTOR["6"] = "light";
DAY_INDEX_FACTOR["7"] = "dark";

SELECT_INDEX = new Object();
SELECT_INDEX["fire"] = 0;
SELECT_INDEX["earth"] = 1;
SELECT_INDEX["water"] = 2;
SELECT_INDEX["wind"] = 3;
SELECT_INDEX["ice"] = 4;
SELECT_INDEX["lightning"] = 5;
SELECT_INDEX["light"] = 6;
SELECT_INDEX["dark"] = 7;
SELECT_INDEX["all"] = 8;
SELECT_INDEX["newMoon"] = 9;
SELECT_INDEX["fullMoon"] = 10;

//**************
// Functions  **
//**************

function vanadielToEarthTime(vanaDate) {
    t = ((vanaDate - ((898 * 360 + 30) * msRealDay)) / 25) + basisDate.getTime();
    return t;
}

function readVanadielDate() {

    var vanaDateYear = document.Timer.DateYear.value;
    var vanaDateMonth = document.Timer.DateMonth.value;
    var vanaDateDay = document.Timer.DateDay.value;
    var vanaDateHour = document.Timer.DateHours.value;
    var vanaDateMinute = document.Timer.DateMinutes.value;

    if (vanaDateYear == "" || vanaDateMonth == "" || vanaDateDay == "" || vanaDateHour == "" || vanaDateMinute == "") {
        return new Date();
    }

    vanaDate = (vanaDateYear * 360 * msRealDay) + ((vanaDateMonth - 1) * 30 * msRealDay) + ((vanaDateDay - 1) * msRealDay + vanaDateHour * msRealDay/24 + vanaDateMinute * msRealDay/(24*60));

    return new Date(vanadielToEarthTime(vanaDate));

}

function getVanadielTime(now)  {

   var vanadielDate = new Object();
   var vanaDate =  ((898 * 360 + 30) * msRealDay) + (now.getTime() - basisDate.getTime()) * 25;

   var vYear = Math.floor(vanaDate / (360 * msRealDay));
   var vMon  = Math.floor((vanaDate % (360 * msRealDay)) / (30 * msRealDay)) + 1;
   var vDate = Math.floor((vanaDate % (30 * msRealDay)) / (msRealDay)) + 1;
   var vHour = Math.floor((vanaDate % (msRealDay)) / (60 * 60 * 1000));
   var vMin  = Math.floor((vanaDate % (60 * 60 * 1000)) / (60 * 1000));
   var vSec  = Math.floor((vanaDate % (60 * 1000)) / 1000);
   var vDay  = Math.floor((vanaDate % (8 * msRealDay)) / (msRealDay));

   if (vYear < 1000) { VanaYear = "0" + vYear; } else { VanaYear = vYear; }
   if (vMon  < 10)   { VanaMon  = "0" + vMon; }  else { VanaMon  = vMon; }
   if (vDate < 10)   { VanaDate = "0" + vDate; } else { VanaDate = vDate; }
   if (vHour < 10)   { VanaHour = "0" + vHour; } else { VanaHour = vHour; }
   if (vMin  < 10)   { VanaMin  = "0" + vMin; }  else { VanaMin  = vMin; }
   if (vSec  < 10)   { VanaSec  = "0" + vSec; }  else { VanaSec  = vSec; }

   vanadielDate.year = VanaYear;
   vanadielDate.month = VanaMon;
   vanadielDate.day = VanaDate;
   vanadielDate.hour = VanaHour;
   vanadielDate.minute = VanaMin;
   vanadielDate.second = VanaSec;
   vanadielDate.dayIndex = vDay;

   return vanadielDate;
}

function getMoonPhase(timenow)  {
    // new moon starts on day 38 (-10%) ends on 47 (12%)
    // full moon starts at 80 (90%) ends on 5 (-88%)
    // Moon cycle lasts 84 game days.

    var moon = getMoonInfo(timenow);
    var mnpercent = "";
    var moonPhase = new Object();

    mnpercent = "<span class=\"" + moon.phase + ">" + moon.percent + "% " + moon.name + "</span>";

    moonPhase.mnpercent = mnpercent;
    moonPhase.moonpercent = moonpercent;

    return moonPhase;
}

function setDaySched(now)  {
    var dayStart = 0;
    var repeatCal = document.setLines.DayCount.value;
    var mnpercent = "";
    var craftDifficulty = 0;
    var out = "";
    var moon = getMoonInfo(now);
    var dayInfo = getDayInfo(now);
    var selectDay = document.setLines.day.value;
    var selectMoon = document.setLines.moon.value;

    /*
    var selectPeriod = document.setLines.timePeriod.value;
    var periods = 48; // Number of half hour periods in a game day HQ related
    */

    out = "<table><tr><th></th><th>Day</th>";
    out += "<th>Begins</th><th>Ends</th>";
    out += "<th colspan=\"2\">Moon</th>";
    out += "<th title='First column shows facing same element direction as the crystal being used in the synth with advanced support. Second column shows facing a element direction that is neutral to the crystal you are using while having advanced support. Third column shows facing the strong element direction for the crystal you are using while having advanced support. TnHQ means it falls in a tier crack or your skill isnt high enough to HQ the synth. T0=Tier 0, T1=Tier 1, T2= Tier 2, T3= Tier 3' style='text-align: center;' colspan=\"3\">Difficulty Range (Hover for info)</th></tr>";
    out+="<tr'> <td></td><td></td> <td></td> <td></td> <td></td> <td></td> <td></td> <td style='font-weight: bold;'><div style='text-align: center;'>Facing Direction</div><br><div style='margin-top:-10px;'>Same &nbsp; &mdash; &nbsp; Neutral &nbsp; &mdash; &nbsp; Strong</div></td> </tr>";
    var i = 0;
    var j = 0;
    dayStart = dayInfo.dayStart;
    startTime = dayStart;
    while (i < repeatCal) {
        endTime = startTime + msGameDay;

        // Related to Eruntalon statement that day is divided up into 48 periods.
        /* if (selectPeriod == 'all') {
            startTimePeriod = startTime;
            endTimePeriod = endTime;
        }
        else {
            startTimePeriod = startTime + (msGameDay/periods) * selectPeriod;
            endTimePeriod = startTimePeriod + (msGameDay/periods);
        }
        */

        startTimePeriod = startTime;
        endTimePeriod = endTime;

        moon = getMoonInfo(startTime);
      var  day = getDayInfo(startTime);

        if ((selectMoon == moon.phase || selectMoon == "all") && (selectDay == day.name || selectDay == "all")) {

            mnpercent = "<td align=\"right\">";
            mnpercent += "<span class=\"" + moon.phase + "\">" + moon.percent + "%</span></td>";
            mnpercent += "<td><span class=\"" + moon.phase + "\">" + moon.shortName + "</span>";
            mnpercent += "</td>";

            craftDifficulty = calculateDifficulty(day.index,moon.percent);

            out += "<tr class=\"calendarLine\" onclick=\"setTimer(" + startTimePeriod + "); craftDetails(" + day.index + "," + moon.percent + "); craftDetailsDetails();\">";
            out += "<td>" + (j) + "</td>";
            out += "<td class=" + day.name + ">" + day.name + "</td>";
            out += "<td>" + formatDate(startTimePeriod, 2) + "</td>";
            out += "<td>" + formatDate(endTimePeriod, 2) + "</td>";
            out += mnpercent;
            out += "<td></td>";
            out += "<td></td>";
            out += "<td></td>";
            out +="</tr>";

           //add one more to make better spacing room for visibility

            out += "<tr class=\"calendarLine\" onclick=\"setTimer(" + startTimePeriod + "); craftDetails(" + day.index + "," + moon.percent + "); craftDetailsDetails();\">";
            out += "<td></td>";
            out += "<td class=" + day.name + "></td>";
            out += "<td></td>";
            out += "<td></td>";
            out += "<td></td>"
            out += "<td>Adv Support</td>"
            out += "<td align=\"right\">" + craftDifficulty.min + " T"+ getTierDisplay(craftDifficulty.min)+" "+ HQPercent(getTierDisplay(craftDifficulty.min),moon.phase,moon.percent,day.name,document.craftInput.crystal.value);+"</td>";
            out += "<td align =\"center\"> &nbsp; &mdash; &nbsp;"+ craftDifficulty.noDirection + " T"+ getTierDisplay(craftDifficulty.noDirection)+" "+ HQPercent(getTierDisplay(craftDifficulty.noDirection),moon.phase,moon.percent,day.name,document.craftInput.crystal.value)
                +" &nbsp; &mdash; &nbsp;</td>";
            out += "<td align=\"right\">" + craftDifficulty.max + " T"+ getTierDisplay(craftDifficulty.max)+" " +HQPercent(getTierDisplay(craftDifficulty.max),moon.phase,moon.percent,day.name,document.craftInput.crystal.value);+"</td>"
            out +="</tr>";






            //add two more times

            //normal support rows

            out += "<tr class=\"calendarLine\" onclick=\"setTimer(" + startTimePeriod + "); craftDetails(" + day.index + "," + moon.percent + "); craftDetailsDetails();\">";
            out += "<td></td>";
            out += "<td class=" + day.name + "></td>";
            out += "<td></td>";
            out += "<td></td>";
            out += "<td></td>"
            out += "<td>Free Support</td>"
            //out += mnpercent;
            //order is strong neutral same
            out += "<td align=\"right\">" + craftDifficulty.strongDirectionStandardSupport + " T"+ getTierDisplay(craftDifficulty.strongDirectionStandardSupport)+" "+ HQPercent(getTierDisplay(craftDifficulty.strongDirectionStandardSupport),moon.phase,moon.percent,day.name,document.craftInput.crystal.value);+"</td>";
            out += "<td align =\"center\"> &nbsp; &mdash; &nbsp;"+ craftDifficulty.neutralDirectionStandardSupport + " T"+ getTierDisplay(craftDifficulty.neutralDirectionStandardSupport)+" "+ HQPercent(getTierDisplay(craftDifficulty.neutralDirectionStandardSupport),moon.phase,moon.percent,day.name,document.craftInput.crystal.value)
                +" &nbsp; &mdash; &nbsp;</td>";
            out += "<td align=\"right\">" + craftDifficulty.sameDirectionStandardSupport + " T"+ getTierDisplay(craftDifficulty.sameDirectionStandardSupport)+" " +HQPercent(getTierDisplay(craftDifficulty.sameDirectionStandardSupport),moon.phase,moon.percent,day.name,document.craftInput.crystal.value);+"</td>"
            out +="</tr>";


            // no support rows

            out += "<tr class=\"calendarLine\" onclick=\"setTimer(" + startTimePeriod + "); craftDetails(" + day.index + "," + moon.percent + "); craftDetailsDetails();\">";
            out += "<td></td>";
            out += "<td class=" + day.name + "></td>";
            out += "<td></td>";
            out += "<td></td>";
            out += "<td></td>"
            out += "<td>No Support</td>"
            //out += mnpercent;
            //order is strong neutral same
            out += "<td align=\"right\">" + craftDifficulty.strongDirectionNoSupport + " T"+ getTierDisplay(craftDifficulty.strongDirectionNoSupport)+" "+ HQPercent(getTierDisplay(craftDifficulty.strongDirectionNoSupport),moon.phase,moon.percent,day.name,document.craftInput.crystal.value);+"</td>";
            out += "<td align =\"center\"> &nbsp; &mdash; &nbsp;"+ craftDifficulty.neutralDirectionNoSupport + " T"+ getTierDisplay(craftDifficulty.neutralDirectionNoSupport)+" "+ HQPercent(getTierDisplay(craftDifficulty.neutralDirectionNoSupport),moon.phase,moon.percent,day.name,document.craftInput.crystal.value)
                +" &nbsp; &mdash; &nbsp;</td>";
            out += "<td align=\"right\">" + craftDifficulty.sameDirectionNoSupport + " T"+ getTierDisplay(craftDifficulty.sameDirectionNoSupport)+" " +HQPercent(getTierDisplay(craftDifficulty.sameDirectionNoSupport),moon.phase,moon.percent,day.name,document.craftInput.crystal.value);+"</td>"
            out +="</tr>";

            out+="<tr style='outline: solid .5px black;'> <td></td><td></td> <td></td> <td></td> <td></td> <td></td> <td></td> <td></td> </tr>";
            i++;
        }

        startTime += msGameDay;
        j++;
    }

    if (repeatCal < 1) {
        out = "";
    }
    else {
        out = out + "</table>";
    }

    document.getElementById("calendar").innerHTML = out;
}

/*
function formatCountdown(varTime) {

   var dayLeft = varTime / msRealDay;
   var hourLeft = (dayLeft - Math.floor(dayLeft)) * 24;
   var minLeft = (hourLeft - Math.floor(hourLeft)) * 60;
   var secLeft = Math.floor((minLeft - Math.floor(minLeft)) * 60);
   var formattedTime = "";

   dayLeft = Math.floor(dayLeft);
   hourLeft = Math.floor(hourLeft);
   minLeft = Math.floor(minLeft);

   if (minLeft < 10) {minLeft = "0" + minLeft;}
   if (secLeft < 10) {secLeft = "0" + secLeft;}

   if (dayLeft > 0) {
      formattedTime = dayLeft + ":";
      if (hourLeft < 10) {
         formattedTime = formattedTime + "0" + hourLeft + ":";
      } else {
         formattedTime = formattedTime + hourLeft + ":";
      }
   } else if (hourLeft > 0) {
      formattedTime = hourLeft + ":";
   }

   formattedTime = formattedTime + minLeft + ":" + secLeft;
   return formattedTime;
}
*/

function formatDate(varTime, showDay) {

   var varDate = new Date(varTime);
   var yyyy = varDate.getFullYear();
   var mm = varDate.getMonth() + 1;
   if (mm < 10) { mm = "0" + mm; }

   var dd = varDate.getDate();
   if (dd < 10) { dd = "0" + dd; }

   var day = varDate.getDay();

   var hh = varDate.getHours();
   if (hh < 10) { hh = "0" + hh; }

   var min = varDate.getMinutes();
   if (min < 10) { min = "0" + min; }

   var ss = varDate.getSeconds();
   if (ss < 10) { ss = "0" + ss; }

   if (showDay == 1)  {
      dateString = EarthDay[day] + ", " + sMonth[mm-1] + " " + dd + ", " + yyyy + " " + hh + ":" + min + ":" + ss;
   } else if (showDay == 2)  {
      dateString = sMonth[mm-1] + " " + dd + ",  " + hh + ":" + min + ":" + ss;
   }
   return dateString;
}


function calculateDifficulty (dayIndex, moonpercent) {
    var skillCap = document.craftInput.skillCap.value;
    var skillCurrent = document.craftInput.skillLevel.value;

    if (skillCap=="" || skillCurrent=="")
    {
        return "";
    }

    var day = DAY_INDEX_FACTOR[dayIndex];
    var crystal = document.craftInput.crystal.value;
    var dayCrystalFactor = DAY_CRYSTAL_FACTOR[day + "+" + crystal];

    if (dayCrystalFactor == null) {
        dayCrystalFactor = 0;
    }

   // var sumOfFactors = (Math.abs(moonpercent)-50)/50 ;
    //**test**
   // console.log(moonpercent);
    var sumOfFactors = (Math.abs(moonpercent)-50)/50 + dayCrystalFactor;
   // var advancedSupport_sameDirection = -0.5;
    //below is actually advanced support and strong direction despite the name below
    // var advancedSupport_sameDirection=3.5;
    var advancedSupport_sameDirection=2.5;
    // var advancedSupport_StrongDirection = 2.5;
    var advancedSupport_StrongDirection = 3.5;

    var baseDifficulty = skillCap - skillCurrent;
    var moonDayDifficulty = baseDifficulty - sumOfFactors;


    var difficulty = new Object();

    difficulty.min = formatNumber(moonDayDifficulty - advancedSupport_StrongDirection);
    difficulty.noDirection=formatNumber(moonDayDifficulty-3);
    difficulty.sameDirectionStandardSupport=formatNumber(moonDayDifficulty -.5);
    difficulty.sameDirectionNoSupport=formatNumber(moonDayDifficulty +.5);
    difficulty.neutralDirectionStandardSupport=formatNumber(moonDayDifficulty-1.0);
    difficulty.neutralDirectionNoSupport=formatNumber(moonDayDifficulty-0.0);
    difficulty.strongDirectionStandardSupport=formatNumber(moonDayDifficulty-1.5);
    difficulty.strongDirectionNoSupport=formatNumber(moonDayDifficulty -.5);
    difficulty.moonDay = moonDayDifficulty;
    difficulty.moonDayDifficulty=moonDayDifficulty
    difficulty.base = baseDifficulty;
//(moonDayDifficulty);
    difficulty.max = formatNumber(moonDayDifficulty - advancedSupport_sameDirection);


    return difficulty;
}

function craftDetails(dayIndex,moonpercent)  {

    var difficulty = calculateDifficulty(dayIndex,moonpercent);

    var support = new Array(3,1,0);
    var direction = new Array(0.5,0,-0.5);

    var supportNames = new Array("Adv. Support","Free Support","No Support");
    var difficultyValue = 0;

    var crystal = document.craftInput.crystal.value;

    var html = "<table><tr><th width=\"25%\"></th>";
    html += "<th width=\"25%\" align=\"center\" class=\"" + ELEMENT[crystal + "+same"] + "\">" + CRYSTAL_DIRECTION[crystal + "+same"] + "</th>";
    html += "<th width=\"25%\" align=\"center\" class=\"None\">Other</th>";
    html += "<th width=\"25%\" align=\"center\" class=\"" + ELEMENT[crystal + "+strong"] + "\">" + CRYSTAL_DIRECTION[crystal + "+strong"] + "</th>"; html += "</tr>";

    for (var i=0; i < support.length; i++) {
            html = html + "<tr><td>" + supportNames[i] + "</td>";
        for (var j=0; j < direction.length; j++) {
            difficultyValue = formatNumber(difficulty.moonDay - direction[j] - support[i]);
            if (difficulty.base <= 0) {
              html += "<td align=\"center\" onclick=\"craftDetailsDetails(-999);\">" + difficultyValue  + " tier "+ getTierDisplay(difficultyValue)+ " </td>";
            }
            else {
              html += "<td align=\"center\" onclick=\"craftDetailsDetails(" + difficultyValue + ");\">" + difficultyValue  + " tier "+ getTierDisplay(difficultyValue)+"</td>";
            };
        }
        html += "</tr>";

    }

    html += "</table>"

   document.getElementById("Details").innerHTML = html;
}

function craftDetailsDetails(difficultyValue) {

    var html = "<p>";

    if (difficultyValue == -999) {
        html+= "<b>No Skill Ups</b><br/>";
        html+= "Skill ups cannot be obtained because your skill level is the same or higher than the recipe cap.";
    }
    else if (difficultyValue <= 0) {
        html+= "<b> &lt;0 The Redundant zone </b> &nbsp (" + formatNumber(difficultyValue) + ")<br/>";
        html+= "Skill ups can be hard to obtain, because the recipe is too easy to improve your skill. There are just too many factors helping you succeed, so there is no chance to learn.";
    }
    else if (difficultyValue >0 && difficultyValue <= 2) {
        html+= "<b>0-2 The Success zone</b> &nbsp (" + formatNumber(difficultyValue) + ")<br/>";
        html+= "There is a very good chance of success. Skill ups will occur, but some will be lost due to the recipe being relatively easy compared to your current skills. Best used when the recipe is break even or profit, and/or when the ingredients are expensive.";
    }
    else if (difficultyValue >2 && difficultyValue <= 4) {
        html+= "<b>2-4 The Prime Skill up zone</b> &nbsp (" + formatNumber(difficultyValue) + ")<br/>";
        html+= "There is a very good chance for skill ups. Failures will occur, but at a fair trade off for skill ups (in most cases). It is fairly easy to get the craft modifier to be in this range from anywhere from 7/8-1 levels from cap.";
    }
    else if (difficultyValue >4 && difficultyValue <= 6) {
        html+= "<b>4-6 Skill from fails zone</b> &nbsp (" + formatNumber(difficultyValue) + ")<br/>";
        html+= "The chance of a skill up is okay, but it is best to be within 5 levels of the cap so that skill ups can still be obtained from failures. The ingredients had better be cheap, or you will be digging yourself into a hole.";
    }
    else if (difficultyValue > 6) {
        html+= "<b>&gt;6 High risk, low reward zone</b> (" + formatNumber(difficultyValue) + ")<br/>";
        html+= "There is no good reason to be in this zone. This is only for the pure power leveler who could care less about expenses. Please move onto another craft/recipe before wasting your gil here.";
    }
    else {
        html += "";
    };

    html += "</p>";

    document.getElementById("Details2").innerHTML = html;
}

function setVanadielTime(now) {

    var vanaDate = getVanadielTime(now);

    var VanaTime = "<span class=" + VanaDay[vanaDate.dayIndex] + ">" + VanaDay[vanaDate.dayIndex] + "</span>:  ";
    VanaTime += vanaDate.year + "-" + vanaDate.month + "-" + vanaDate.day + "  " + vanaDate.hour + ":" + vanaDate.minute + ":" + vanaDate.second;

    document.getElementById("vTime").innerHTML = VanaTime;

}

function setEarthTime(now) {

   var earthTime = formatDate(now.getTime(), 1);
   document.getElementById("eTime").innerHTML = earthTime;

}

function setMoonPhase(now) {

    //var moonPhase = getMoonPhase(now);
    var moon = getMoonPhase(now);
    document.getElementById("mPhase").innerHTML = moon.mnpercent;

}

function setVanadielDateValue(now) {

    var vanadielDate = getVanadielTime(now);

    document.Timer.DateYear.value = vanadielDate.year;
    document.Timer.DateMonth.value = vanadielDate.month;
    document.Timer.DateDay.value = vanadielDate.day;
    document.Timer.DateHours.value = 0;
    document.Timer.DateMinutes.value = 0;
    document.Timer.DateSeconds.value = 0;
}

function setTimer(time) {

    var now = new Date(time);

    setVanadielTime(now);
    setEarthTime(now);
    setMoonPhase(now);

    clearTimeout(timerId);
}

function setBaseDifficulty() {

    var skillCap = document.craftInput.skillCap.value;
    var skillLevel = document.craftInput.skillLevel.value;
    var difficulty = skillCap - skillLevel;

    document.getElementById("baseDifficulty").innerHTML = formatNumber(difficulty);
}

function getDayProperties(now) {

    // determine phase percentage
    var moon = getMoonInfo(now);
    var vanaDate = getVanadielTime(now);
    craftDetails(vanaDate.dayIndex,moon.percent);
}

function earth2Vana() {
    var now = readEarthDate();

    setVanadielDateValue(now);
}

function vana2Earth() {
    var now = readVanadielDate();

    setEarthDateValue(now);
}

function readEarthDate() {
    var eYear = document.Timer.DateYear.value;
    var eMonth = document.Timer.DateMonth.value;
    var eDay = document.Timer.DateDay.value;
    var eHours = document.Timer.DateHours.value;
    var eMinutes = document.Timer.DateMinutes.value;
    var eSeconds = document.Timer.DateSeconds.value;

    return new Date(eYear, eMonth-1, eDay, eHours, eMinutes, eSeconds, 0);
}

function setEarthDateValue(now) {

    document.Timer.DateYear.value = now.getFullYear();
    document.Timer.DateMonth.value = now.getMonth()+1;
    document.Timer.DateDay.value = now.getDate();
    document.Timer.DateHours.value = now.getHours();
    document.Timer.DateMinutes.value = now.getMinutes();
    document.Timer.DateSeconds.value = now.getSeconds();
}

function updateEverything(now) {

   setTimer(now);
   setDaySched(now);
   setBaseDifficulty();
   getDayProperties(now);
   craftDetailsDetails();
   // runAllHighlights();
}

function printPage() {

    var now = new Date();
    var entryType = getEntryType();
    disableFields(entryType);

    if (entryType == "earth"){
        now = readEarthDate();
    }
    else if (entryType == "vanadiel") {
        now = readVanadielDate();
    }
    else {
        now = readEarthDate();
    }

   updateEverything(now);
    runAllHighlights();
}

function printPageNow() {

    var now = new Date();
    var entryType = getEntryType();
    disableFields(entryType);

    if (entryType == "earth"){
        setEarthDateValue(now);
    }
    else if (entryType == "vanadiel") {
        setVanadielDateValue(now);
    }
    else {
        setEarthDateValue(now);
    }

    updateEverything(now);
    runAllHighlights();
}

function disableFields(entryType) {

    if (entryType == "earth") {
        document.Timer.DateHours.disabled = false;
        document.Timer.DateMinutes.disabled = false;
        document.Timer.DateSeconds.disabled = false;
    }
    else if (entryType == "vanadiel") {
        document.Timer.DateHours.disabled = false;
        document.Timer.DateMinutes.disabled = false;
        document.Timer.DateSeconds.disabled = true;
    }
     else {
        document.Timer.DateHours.disabled = false;
        document.Timer.DateMinutes.disabled = false;
        document.Timer.DateSeconds.disabled = false;
    }
}

function getEntryType() {
    for (var i=0; i < document.Timer.radioEntryType.length; i++) {
        if (document.Timer.radioEntryType[i].checked) {
            var entryType = document.Timer.radioEntryType[i].value;
        }
    }
    return entryType;
}

function formatNumber(n) {
    n = Math.round(n * 100) / 100;
    var s = n.toString();
    if (s.indexOf(".") < 0) {
        s += ".00";
    } else if (s.indexOf(".") == s.length - 2) {
        s += "0";
    }
    return s;
}

function dateModeChange() {
    var entryType = getEntryType();
    var currentEntryType = document.Timer.DateEntryMode.value;

    if (currentEntryType != entryType) {
      if (entryType == "vanadiel") {
        earth2Vana();
        document.Timer.DateEntryMode.value = "vanadiel";
      }
      else if (entryType == "earth") {
        vana2Earth();
        document.Timer.DateEntryMode.value = "earth";
      }
    }
}

function getDayInfo(msTime) {
    var timeDiff = msTime - Mndate.getTime();
    var dayInfo = new Object();

    weekStart = Mndate.getTime() + Math.floor(timeDiff/(8 * msGameDay)) * (8 * msGameDay);
    dayStart = Mndate.getTime() + Math.floor(timeDiff/msGameDay) * msGameDay;

    // Determines how many days have passed since Firesday
    dayOffset = (dayStart - weekStart) / msGameDay - 2;
    if (dayOffset < 0) {
        dayOffset += 8;
    }

    dayInfo.index = dayOffset;
    dayInfo.element = DAY_INDEX_FACTOR[dayOffset];
    dayInfo.name = VanaDay[dayOffset];
    dayInfo.dayStart = dayStart;
    return dayInfo;
}

function getMoonInfo(now) {
    var moonDays = 0;
    var moon = new Object();

    moonDays = (Math.floor((now - Mndate.getTime()) / msGameDay)) % 84;

    if (moonDays < 0){
        moonDays = 84 + moonDays;
    }

    moonpercent = - Math.round((42 - moonDays) / 42 * 100);

    if (moonpercent >= -10 && moonpercent <= 5)  {
        moon.phase = "NewMoon";
        moon.shortName = "NM";
        moon.name = "New Moon";
    }
    else if (moonpercent > 5 && moonpercent < 40) {
        moon.phase = "WXC";
        moon.shortName = "WXC";
        moon.name = "Waxing Crescent";
    }
    else if (moonpercent >= 40 && moonpercent <= 55) {
        moon.phase = "FQM";
        moon.shortName = "FQM";
        moon.name = "First Quarter Moon";
    }
    else if (moonpercent > 55 && moonpercent < 90) {
        moon.phase = "WXG";
        moon.shortName = "WXG";
        moon.name = "Waxing Gibbous";
    }
    else if (moonpercent >= 90 || moonpercent <= -95)  {
        moon.phase = "FullMoon";
        moon.shortName = "FM";
        moon.name = "Full Moon";
    }
    else if (moonpercent > -95 && moonpercent < -60) {
        moon.phase = "WNG";
        moon.shortName = "WNG";
        moon.name = "Waning Gibbous";
    }
    else if (moonpercent >= -60 && moonpercent <= -45) {
        moon.phase = "LQM";
        moon.shortName = "LQM";
        moon.name = "Last Quarter Moon";
    }
    else if (moonpercent > -45 && moonpercent < -10) {
        moon.phase = "WNC";
        moon.shortName = "WNC";
        moon.name = "Waning Crescent";
    }
    moon.percent = Math.abs(moonpercent);

    return moon;
}

function getTier(synthDiff){
    synthDiff=removeDecimel(synthDiff);
    var hqtier=0;
    if((synthDiff <= 0) && (synthDiff >= -10))
    {
    //    success -= (double)(PChar->CraftContainer->getType() == ELEMENT_LIGHTNING) * 0.2;
        hqtier = 1;
    }
    else if((synthDiff <= -11) && (synthDiff >= -30)){
        hqtier = 2;}
    else if((synthDiff <= -31) && (synthDiff >= -50)){
        hqtier = 3;}
    else if(synthDiff <= -51){
        hqtier = 4;}

    return hqtier;
}
function getTierDisplay(synthDiff){
    if(checkTierCrack(synthDiff)){return 'nHQ';}
  //  if((synthDiff>=0)&&(synthDiff<1)){return 0;}
    if((synthDiff<=0)&&(synthDiff>-1)){return 0;}
    synthDiff=removeDecimel(synthDiff);
   // console.log("synthdiff"+ synthDiff);
    var hqtier;
    if(synthDiff>=0){return "nHQ";}
    if((synthDiff <= 0) && (synthDiff >= -10))
    {
        //    success -= (double)(PChar->CraftContainer->getType() == ELEMENT_LIGHTNING) * 0.2;
        hqtier = 1;

    }
    else if((synthDiff <= -11) && (synthDiff >= -30)){
        hqtier = 2;}
    else if((synthDiff <= -31) && (synthDiff >= -50)){
        hqtier = 3;}
    else if(synthDiff <= -51){
        hqtier = 4;}
  if(hqtier===undefined){
      return 'nHQ';
  }
//console.log("before" +hqtier);
    if(hqtier==0){hqtier='nHQ';}else{hqtier=hqtier-1;}
  //  console.log("after" +hqtier);
    return hqtier;
}

function removeDecimel(value){
        value=value.toString().split(".");
    return parseInt(value[0]);
}

function checkTierCrack(checkSynthDiff){
    if((checkSynthDiff<-10)&&(checkSynthDiff>-11)){return true;}
    else if((checkSynthDiff<-30)&&(checkSynthDiff>-31)){return true;}
    else if((checkSynthDiff<-50)&&(checkSynthDiff>-51)){return true;}
    else{return false;}


}

function HQPercent(tier,moontype,moonpercent,daytype,crystaltype){
    //console.log(tier);
    //console.log(moontype);
    //console.log(moonpercent);
    //console.log(daytype);
    //console.log(crystaltype);
var chance;

if(isNaN(tier)){return '';}
  // tier=parseInt(tier.tostring().replace(/\D/g,''));
switch (tier) {
    case 0:
chance=.015;
    break;
    case 1:
chance=.1;
    break;
    case 2:
chance=.3;
        break;
    case 3:
chance=.5;
        break;
}
 //   console.log(daytype);
  //  console.log(ELEMENT[convertElementDaytoElement(daytype)+"+strong"]);
   // console.log("strong element for day "+ ELEMENT[convertElementDaytoElement(daytype)+"+strong"]+ " crystal type="+titleCase(crystaltype));
   // console.log(dayTypeToLowerCaseWithoutEndingInsDays(daytype));
   // console.log("crystal+strong" + ELEMENT[crystaltype+"+strong"]) + "   " + dayTypeToLowerCaseWithoutEndingInsDays(daytype);
    chance *= 1.0 - (moonpercent - 50)/150;
    if (convertCrystalNameFormat(crystaltype) == daytype)
    { chance *= 1.0 - (.33);}
    else if (ELEMENT[crystaltype+"+strong"] == dayTypeToLowerCaseWithoutEndingInsDays(daytype))
    {  chance *= 1.0 + (.33);}
    else if (ELEMENT[convertElementDaytoElement(daytype)+"+strong"] == titleCase(crystaltype))
    {   chance *= 1.0 - (.33);}
    else if (daytype == "Lightsday")
    {    chance *= 1.0 - (.33);}
    else if (daytype == "Darksday")
    { chance *= 1.0 + (.33);}
    //tier taken care of
    if(((chance * 100).toFixed(2))>50)
    {
        return 'hq(50%' +')';
    }else{
        return 'hq('+ (chance * 100).toFixed(2) + '%' +')';
    }


}

function convertElementDaytoElement(elementday){
    switch(elementday) {
        case "Lightsday":
            return "light";
            break;
        case "Lightningday":
           return "lightning"
            break;
        case "Firesday":
            return "fire"
            break;
        case "Watersday":
            return "water"
            break;
        case "Windsday":
            return "wind"
            break;
        case "Iceday":
            return "ice"
            break;
        case "Earthsday":
        return "earth"
        break;
        case "Darksday":
            return "dark"
            break;
    }
}


function convertCrystalNameFormat(crystalname){
    crystalname=titleCase(crystalname);
    if((crystalname=="Ice")||(crystalname=="Lightning")){
        return crystalname+"day";
    }else{
        return crystalname+"sday";
    }
    //return crystalname+"sday";
}


function titleCase(str) {
    return str
        .toLowerCase()
        .split(' ')
        .map(function(word) {
            return word[0].toUpperCase() + word.substr(1);
        })
        .join(' ');
}

function dayNameFormat(index){
    return convertCrystalNameFormat(DAY_INDEX_FACTOR[index]);
}

function dayTypeToLowerCaseWithoutEndingInsDays(value){
value=value.toLowerCase();
    //console.log(value);
    if((value=="iceday")||(value=="lightningday")){
        return titleCase(value.slice(0,-3));
    }else{
        return titleCase(value.slice(0,-4));
    }
}

//function removeT(myString){
//  //  myString = myString.replace(/\D/g,'');
//    return parseInt(myString.replace(/\D/g,''));
//       // return parseInt(myString);
//}
function highlightT0() {
    keywords="T0";
    element="td";
    if(keywords) {
        var textNodes;
        keywords = keywords.replace(/\W/g, '');
        var str = keywords.split(" ");
        $(str).each(function() {
            var term = this;
            var textNodes = $(element).contents().filter(function() { return this.nodeType === 3 });
            textNodes.each(function() {
                var content = $(this).text();
                var regex = new RegExp(term, "gi");
                //content = content.replace(regex, '<span class="highlight">' + term + '</span>');
                content = content.replace(regex, '<span style="color:seagreen;font-weight:bold;">' + term + '</span>');
                $(this).replaceWith(content);
            });
        });
    }
}

function highlightT1() {
    keywords="T1";
    element="td";
    if(keywords) {
        var textNodes;
        keywords = keywords.replace(/\W/g, '');
        var str = keywords.split(" ");
        $(str).each(function() {
            var term = this;
            var textNodes = $(element).contents().filter(function() { return this.nodeType === 3 });
            textNodes.each(function() {
                var content = $(this).text();
                var regex = new RegExp(term, "gi");
                //content = content.replace(regex, '<span class="highlight">' + term + '</span>');
                content = content.replace(regex, '<span style="color:orange;font-weight:bold;">' + term + '</span>');
                $(this).replaceWith(content);
            });
        });
    }
}

function highlightT2() {
    keywords="T2";
    element="td";
    if(keywords) {
        var textNodes;
        keywords = keywords.replace(/\W/g, '');
        var str = keywords.split(" ");
        $(str).each(function() {
            var term = this;
            var textNodes = $(element).contents().filter(function() { return this.nodeType === 3 });
            textNodes.each(function() {
                var content = $(this).text();
                var regex = new RegExp(term, "gi");
                //content = content.replace(regex, '<span class="highlight">' + term + '</span>');
                content = content.replace(regex, '<span style="color:deeppink;font-weight:bold;">' + term + '</span>');
                $(this).replaceWith(content);
            });
        });
    }
}

function highlightT3() {
    keywords="T3";
    element="td";
    if(keywords) {
        var textNodes;
        keywords = keywords.replace(/\W/g, '');
        var str = keywords.split(" ");
        $(str).each(function() {
            var term = this;
            var textNodes = $(element).contents().filter(function() { return this.nodeType === 3 });
            textNodes.each(function() {
                var content = $(this).text();
                var regex = new RegExp(term, "gi");
                //content = content.replace(regex, '<span class="highlight">' + term + '</span>');
                content = content.replace(regex, '<span style="color:blue;font-weight:bold;">' + term + '</span>');
                $(this).replaceWith(content);
            });
        });
    }
}

function runAllHighlights(){
    highlightT0();
    highlightT1();
    highlightT2();
    highlightT3();
}