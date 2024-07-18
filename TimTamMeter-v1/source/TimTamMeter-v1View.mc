import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.ActivityMonitor;

/*
    Item          kcal
classic Timtam - 95~98

*/

(:glance)
function getCurrentTimTams() {
    var classic_timtam_kcal = 98.0;
    var calories = ActivityMonitor.getInfo().calories / classic_timtam_kcal;
    if(calories != null) {
        var trunc_calories = calories.format("%.2f");
        return trunc_calories;
    }
    else {
        return null;
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
            dc.drawText(dc.getWidth() * 0.75, dc.getHeight() * 0.5, Graphics.FONT_GLANCE_NUMBER, kcal.toString(), Graphics.TEXT_JUSTIFY_CENTER);
        }
    }
}

class TimTamMeter_v1View extends WatchUi.View {

    function initialize() {
        View.initialize();
    }

    // Load your resources here
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
        
        // var calories = 100 / 95.0; // For tests
        var kcal = getCurrentTimTams();

        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK); // fg, bg (I think?)
        if(kcal != null){
            dc.clear();
            dc.drawText(dc.getWidth() * 0.5, dc.getHeight() * 0.2, Graphics.FONT_SYSTEM_NUMBER_HOT, kcal.toString(), Graphics.TEXT_JUSTIFY_CENTER);
            dc.drawText(dc.getWidth() * 0.5, dc.getHeight() * 0.7, Graphics.FONT_MEDIUM, "Timtams", Graphics.TEXT_JUSTIFY_CENTER);
            // 1 // dc.drawText(dc.getWidth() * 0.5, dc.getHeight() * 0.7, Graphics.FONT_MEDIUM, "Timtams: " + calories.toString(), Graphics.TEXT_JUSTIFY_CENTER);
        }
        else{
            dc.clear();
            dc.drawText(dc.getWidth() * 0.5, dc.getHeight() * 0.2, Graphics.FONT_SYSTEM_NUMBER_HOT, "null", Graphics.TEXT_JUSTIFY_CENTER);
            dc.drawText(dc.getWidth() * 0.5, dc.getHeight() * 0.7, Graphics.FONT_MEDIUM, "Timtams", Graphics.TEXT_JUSTIFY_CENTER);
            // 1 // dc.drawText(dc.getWidth() * 0.5, dc.getHeight() * 0.7, Graphics.FONT_MEDIUM, "Timtams: null", Graphics.TEXT_JUSTIFY_CENTER );
        }
        
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
    }

}
