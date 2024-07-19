import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.ActivityMonitor;
import Toybox.System;

/*
    Item          kcal
classic Timtam - 95~98

*/

(:glance)
function getCurrentTimTams() {
    var classic_timtam_kcal = 98.0;
    // Don't forget null checks for calls like getInfo()
    var ttc = ActivityMonitor.getInfo().calories / classic_timtam_kcal;
    if(ttc != null) {
        return ttc;
    }
    else {
        return 0.0;
    }
}

// Find a better way than if statements. I don't know if they have
// array threshold functions.
function getTimTamLevel( ttc ) {
    if(ttc.toFloat() <= 0) {
        return "meh";
    }
    else if (ttc > 0 && ttc <= 5) {
        return "connoisseur";
    }
    else if (ttc > 5 && ttc <= 11) {
        return "average";
    }
    else if (ttc > 11 && ttc <= 22) {
        return "sugar rush";
    }
    else if (ttc > 25 && ttc <= 55) {
        return "timtam fanatic";
    }
    else {
        return "you need help";
    }
}

(:glance)
function max(a, b) {
    if (a > b) {
        return a;
    }
    else{
        return b;
    }
}


(:glance)
class TimeTamMeterGlanceView extends WatchUi.GlanceView {

    function initialize() {
        GlanceView.initialize();
    }

    function onUpdate(dc) {
        var kcal = getCurrentTimTams();

        if(kcal != null) {
            dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_BLACK);
            dc.clear();
            dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_BLACK);
            dc.drawText(dc.getWidth() * 0.45, dc.getHeight() * 0.2, Graphics.FONT_GLANCE, "TIMTAM METER", Graphics.TEXT_JUSTIFY_CENTER);
            dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
            dc.drawText(dc.getWidth() * 0.75, dc.getHeight() * 0.5, Graphics.FONT_GLANCE_NUMBER, kcal.format("%.2f").toString(), Graphics.TEXT_JUSTIFY_CENTER);
        }
    }
}

class TimTamMeter_v1View extends WatchUi.View {

    function initialize() {
        View.initialize();
    }

    // Load your resources here
    // dc -> Device Context
    function onLayout(dc as Dc) as Void {
        //setLayout(Rez.Layouts.MainLayout(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {
        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
        
        //var timtam_count = 140; // For tests
        var timtam_count = getCurrentTimTams();

        var cX = dc.getWidth();
        var cY = dc.getHeight();

        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK); // fg, bg (I think?)
        if(timtam_count != null){
            dc.clear();
            //System.println(getTimTamLevel(timtam_count));
            
            dc.drawText(cX * 0.5, cY * 0.2, Graphics.FONT_NUMBER_MEDIUM, timtam_count.format("%.2f").toString(), Graphics.TEXT_JUSTIFY_CENTER);
            dc.drawText(cX * 0.5, cY * 0.6, Graphics.FONT_SMALL, getTimTamLevel(timtam_count), Graphics.TEXT_JUSTIFY_CENTER);
            dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_TRANSPARENT);
            dc.drawText(cX * 0.5, cY * 0.85, Graphics.FONT_GLANCE, "Timtams", Graphics.TEXT_JUSTIFY_CENTER);

            if (timtam_count > 0) {
                dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_TRANSPARENT);
                dc.setPenWidth(8.0);
                dc.drawArc(cX * 0.5, cY * 0.5, (cX * 0.5)-5, Graphics.ARC_CLOCKWISE, 225, max(-45, (225 - (2.7*timtam_count))));
                dc.setPenWidth(1.0);
            }

            // 1 // dc.drawText(dc.getWidth() * 0.5, dc.getHeight() * 0.7, Graphics.FONT_MEDIUM, "Timtams: " + calories.toString(), Graphics.TEXT_JUSTIFY_CENTER);
        }
        else{
            dc.clear();
            dc.drawText(cX * 0.5, cY * 0.2, Graphics.FONT_NUMBER_MILD, "null", Graphics.TEXT_JUSTIFY_CENTER);
            dc.drawText(cX * 0.5, cY * 0.6, Graphics.FONT_SMALL, "no data", Graphics.TEXT_JUSTIFY_CENTER);
            dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_TRANSPARENT);
            dc.drawText(cX * 0.5, cY * 0.85, Graphics.FONT_GLANCE, "Timtams", Graphics.TEXT_JUSTIFY_CENTER);
            // 1 // dc.drawText(dc.getWidth() * 0.5, dc.getHeight() * 0.7, Graphics.FONT_MEDIUM, "Timtams: null", Graphics.TEXT_JUSTIFY_CENTER );
        }
        
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
    }

}
