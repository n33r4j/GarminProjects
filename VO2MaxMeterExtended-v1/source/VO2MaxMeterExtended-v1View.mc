import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.UserProfile;
import Toybox.Math;
import Toybox.System;

(:glance)
function getCurrentVO2Max() {
    var vo2max = UserProfile.getProfile().vo2maxRunning;
    if(vo2max != null) {
        return vo2max;
    }
    else {
        return 0.0;
    }
}

function getVO2MaxLevel(vo2max_val) {
    var vo2max_level = [0, 0.0];

    if(vo2max_val.toFloat() <= 40) {
        vo2max_level[0] = 0;
        vo2max_level[1] = vo2max_val/40.0;
    }
    else if (vo2max_val > 40 && vo2max_val <= 45) {
        vo2max_level[0] = 1;
        vo2max_level[1] = (vo2max_val-40.0)/5.0;
    }
    else if (vo2max_val > 45 && vo2max_val <= 50) {
        vo2max_level[0] = 2;
        vo2max_level[1] = (vo2max_val-45.0)/5.0;
    }
    else if (vo2max_val > 50 && vo2max_val <= 55) {
        vo2max_level[0] = 3;
        vo2max_level[1] = (vo2max_val-50.0)/5.0;
    }
    else if (vo2max_val > 55 && vo2max_val <= 60) {
        vo2max_level[0] = 4;
        vo2max_level[1] = (vo2max_val-55.0)/5.0;
    }
    else if (vo2max_val > 60 && vo2max_val <= 65) {
        vo2max_level[0] = 5;
        vo2max_level[1] = (vo2max_val-60.0)/5.0;
    }
    else {
        vo2max_level[0] = -1; // Out of bounds
        vo2max_level[1] = -1.0;
    }
    return vo2max_level;
}

function drawRadialBars(dc as Dc, vo2max_val) {
    System.println("Drawing radial bars for VO2Max");
    var cX = dc.getWidth();
    var cY = dc.getHeight();

    var bar_segments = 7; // Including gaps
    var color_palette = [Graphics.COLOR_RED, 
                         Graphics.COLOR_YELLOW, 
                         Graphics.COLOR_GREEN, 
                         Graphics.COLOR_BLUE, 
                         Graphics.COLOR_PURPLE,
                         Graphics.COLOR_DK_BLUE];

    var bar_thickness_default = 8.0;
    var bar_thickness_highlighted = 16.0;
    var bar_length = 2.0 * Math.PI / bar_segments; // radians
    var bar_length_offset = bar_length / 2.0;
    
    var start_point = Math.toRadians(0) + bar_length_offset;
    var bar_start_angle = 0;
    var bar_end_angle = 0;
    var bar_radius = (cX * 0.5) - bar_thickness_default - 2.0;
    var bar_thickness = bar_thickness_default;
    var bar_spacing = Math.toRadians(4.0);

    var vo2max_level = getVO2MaxLevel(vo2max_val);
    var curr_level = vo2max_level[0];
    var perc = vo2max_level[1];

    if (curr_level >= 0){
        dc.clear();

        var curr_vo2max_angle = Math.toRadians(90) + start_point + (curr_level * bar_length) + (0.5*bar_spacing) + (bar_length*perc);
        var indicator_start_x = (cX*0.5) + ((bar_radius - 16)*Math.cos(curr_vo2max_angle));
        var indicator_start_y = (cY*0.5) + ((bar_radius - 16)*Math.sin(curr_vo2max_angle));
        var indicator_end_x = (cX*0.5) + ((bar_radius + 5)*Math.cos(curr_vo2max_angle));;
        var indicator_end_y = (cY*0.5) + ((bar_radius + 5)*Math.sin(curr_vo2max_angle));

        for(var i = 0; i < bar_segments-1; i++) {
            bar_start_angle = start_point + (i * bar_length) + (0.5*bar_spacing);
            bar_end_angle = bar_start_angle + bar_length - (0.5*bar_spacing);
            // System.println("Bar " + i + ": " + bar_start_angle + " to " + bar_end_angle);
            bar_thickness = bar_thickness_default;
            bar_radius = (cX * 0.5) - bar_thickness - 2.0;
            
            if(i == curr_level) {
                bar_thickness = bar_thickness_highlighted;
                bar_radius = (cX * 0.5) - (0.8*bar_thickness);
            }
            
            dc.setColor(color_palette[i], Graphics.COLOR_TRANSPARENT);
            dc.setPenWidth(bar_thickness);
            dc.drawArc(cX * 0.5, 
                    cY * 0.5, 
                    bar_radius, 
                    Graphics.ARC_CLOCKWISE, 
                    270 - Math.toDegrees(bar_start_angle),
                    270 - Math.toDegrees(bar_end_angle));
        }

        // Indicator
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
        dc.setPenWidth(4.0);
        dc.drawLine(indicator_start_x, indicator_start_y, indicator_end_x, indicator_end_y);
        
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.setPenWidth(2.0);
        dc.drawLine(indicator_start_x, indicator_start_y, indicator_end_x, indicator_end_y);
        dc.setPenWidth(1.0);

        // Text
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(cX * 0.5, cY * 0.2, Graphics.FONT_SYSTEM_TINY, "VO2 Max.", Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawText(cX * 0.5, cY * 0.3, Graphics.FONT_NUMBER_MEDIUM, vo2max_val.format("%.0f").toString(), Graphics.TEXT_JUSTIFY_CENTER);
        dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(cX * 0.5, cY * 0.7, Graphics.FONT_GLANCE, "date", Graphics.TEXT_JUSTIFY_CENTER);
    }
    else {
        dc.clear();
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.drawText(cX * 0.5, cY * 0.2, Graphics.FONT_SYSTEM_TINY, "VO2 Max.", Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawText(cX * 0.5, cY * 0.4, Graphics.FONT_SYSTEM_TINY, "No Data", Graphics.TEXT_JUSTIFY_CENTER);
    }
}

(:glance)
class VO2MaxMeterExtended_v1GlanceView extends WatchUi.GlanceView {

    function initialize() {
        GlanceView.initialize();
    }

    // Update the view
    function onUpdate(dc){
        var vo2max = getCurrentVO2Max();

        if(vo2max != null) {
            dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_BLACK);
            dc.clear();
            dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_BLACK);
            dc.drawText(dc.getWidth() * 0.45, dc.getHeight() * 0.2, Graphics.FONT_GLANCE, "VO2Max Extended", Graphics.TEXT_JUSTIFY_CENTER);
            dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
            dc.drawText(dc.getWidth() * 0.75, dc.getHeight() * 0.5, Graphics.FONT_GLANCE_NUMBER, vo2max.format("%.1f").toString(), Graphics.TEXT_JUSTIFY_CENTER);
        }
    }
}

class VO2MaxMeterExtended_v1View extends WatchUi.View {

    function initialize() {
        View.initialize();
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        // setLayout(Rez.Layouts.MainLayout(dc));
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

        var vo2max = getCurrentVO2Max();
        // var vo2max = 10.0; // For tests
        // var vo2max = 20.0; // For tests
        // var vo2max = 30.0; // For tests
        // var vo2max = 40.0; // For tests
        // var vo2max = 55.0; // For tests
        // var vo2max = 61.0; // For tests
        // var vo2max = 65.0; // For tests
        drawRadialBars(dc, vo2max);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
    }

}
